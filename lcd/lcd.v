module lcd_test(clk, reset, start, RS, data, done,SW);
input clk; // 50 MHz (T=20ns)
input reset;
output start, RS;
output [7:0] data;
input done;
input SW;
reg [5:0] index;
reg [7:0] data;
reg [1:0] state;
reg [17:0] count;
reg delay;
reg RS, halt;
wire start;
localparam DELAY0 = 40_000/20,DELAY1 = 4_100_000/20;
localparam INIT = 0;
localparam LINE1 = INIT + 4;
localparam LAST = LINE1 + 11;
localparam S0=0, S1=1, S2=2, S3=3;
always @(posedge clk or posedge reset) begin
if (reset) begin
state <= S0;
count <= 0;
index <= INIT;
end
else begin
case (state)
S0: if (~halt) state <= S1; // idle
S1: state <= S2; // start
S2: if (done) begin // LCD write
state <= S3;
index <= index + 1;
if (delay) count <= DELAY1;
else count <= DELAY0;
end
S3: if (count==0) state <= S0; // delay
 else count <= count - 1;
default: state <= 0;
endcase
end
end
assign start = (state==1);
// data, RS, halt
always @* begin
data = 8'b0;
halt = 0;
delay = 0;
RS = 1; // default: data
case (index)
// initialize
INIT: begin data=8'b0011_1100; RS=0;delay=1; end // function set
INIT+1: begin data=8'b0000_1100; RS=0; delay=1; end // display on/off
INIT+2: begin data=8'b0000_0110; RS=0; delay=1;if (SW) data<= 8'b0000_0111; end // entry mode set
INIT+3: begin data=8'b0000_0001; RS=0; delay=1; end // clear display
// line 1
LINE1: begin RS=0; data=8'b1000_0000;  if (SW) data<= 8'b1001_0000;end // set DDRAM addr
LINE1+1: data = "2";
LINE1+2: data = "0";
LINE1+3: data = "1";
LINE1+4: data = "7";
LINE1+5: data = "2";
LINE1+6: data = "5";
LINE1+7: data = "3";
LINE1+8: data = "0";
LINE1+9: data = "1";
LINE1+10: data = "9";
// line 2
LAST: halt=1;
default: halt=1;
endcase
end
endmodule





//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//													mainmodule
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




module lcd(SW,CLOCK_50, KEY, LCD_RS, LCD_RW, LCD_EN, LCD_DATA, LCD_ON, LCD_BLON, LEDR);
input [0:0]SW;
input CLOCK_50;
input [3:0] KEY;
//------ text LCD -------
output LCD_RS, LCD_RW, LCD_EN;
output [7:0] LCD_DATA;
output LCD_ON, LCD_BLON;
output [0:0] LEDR;
wire start, RS, done;
wire [7:0] data;
wire sw=SW[0];
wire clk_50 = CLOCK_50;
wire reset = ~KEY[0];
lcd_test u1 (clk_50, reset, start, RS, data, done,sw);
lcd_controller u2 (clk_50, reset, start, RS, data, done, LCD_RS, LCD_RW, LCD_EN, LCD_DATA);
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;
assign LEDR[0] = 1'b1;
endmodule


//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//															controller module
//--------------------------------------------------------------------------------------------------------------------------------------------------------------

module lcd_controller(clk, reset, start, RS, data, done, LCD_RS, LCD_RW, LCD_E, LCD_data);
// Host side
input clk; // 50MHz clock
input reset, start;
input RS;
input [7:0] data;
output done;
// text LCD side
output LCD_RS, LCD_RW, LCD_E;
output [7:0] LCD_data;
reg [2:0] state;
reg [3:0] count;
localparam S0=0, S1=1, S2=2, S3=4, S4=3; // state
localparam PW_E = 12; // pulse width = 12 clk
assign LCD_RS = RS; // register select
assign LCD_RW = 1'b0; // write only
assign LCD_data = data; // 8-bit data output
always @(posedge clk or posedge reset) begin
if (reset) state <= S0;
else
case (state)
S0: if (start) state <= S1;
S1: state <= S2;
S2: begin state <= S3; count <= PW_E - 1; end
S3: if (count == 0) begin state<= S4; count <= 0; end
else count <= count - 1;
S4: state <= S0;
default: state <= S0;
endcase
end
assign LCD_E = (state==S3);
assign done = (state==S4);
endmodule