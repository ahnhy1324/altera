module lcd(CLOCK_50, KEY, LCD_RS, LCD_RW, LCD_EN, LCD_DATA, LCD_ON, LCD_BLON, LEDR);
input CLOCK_50;
input [3:0] KEY;
//------ text LCD -------
output LCD_RS, LCD_RW, LCD_EN;
output [7:0] LCD_DATA;
output LCD_ON, LCD_BLON;
output [0:0] LEDR;
wire start, RS, done;
wire [7:0] data;
wire clk_50 = CLOCK_50;
wire reset = ~KEY[0];
lcd_test u1 (clk_50, reset, start, RS, data, done);
lcd_controller u2 (clk_50, reset, start, RS, data, done, LCD_RS, LCD_RW, LCD_EN, LCD_DATA);
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;
assign LEDR[0] = 1'b1;
endmodule



module lcd_test(clk, reset, start, RS, data, done);
input clk; // 50 MHz (T=20ns)
input reset;
output start, RS;
output [7:0] data;
input done;
reg [5:0] index;
reg [5:0] next_index=6'b000000;
reg [7:0] data;
reg [1:0] state;
reg [17:0] count;
reg delay;
reg RS, halt;
wire start;
// localparam DELAY = 3; // for simulation
localparam DELAY0 = 40_000/20, // > 40us
 DELAY1 = 4_100_000/20; // > 4.1ms
localparam INIT = 0;
localparam LINE1 = INIT + 4;
localparam LINE2 = LINE1 + 2;
localparam LAST = LINE2 + 17;
localparam S0=0, S1=1, S2=2, S3=3;

// 0 => 1 => 2 =>(done)=> 3 => 0
// start wait
// state, count, index
always @(posedge clk or posedge reset) begin
if (reset) begin
state <= S0;
count <= 0;
next_index=next_index+1;
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
INIT: begin data=8'b0011_1100; RS=0; delay=1; end // function set
INIT+1: begin data=8'b0000_1100; RS=0; delay=1; end // display on/off
INIT+2: begin data=8'b0000_0110; RS=0; delay=1; end // entry mode set
INIT+3: begin data=8'b0000_0001; RS=0; delay=1; end // clear display
// line 1
LINE1: begin data=8'b1000_0000; RS=0; end // set DDRAM addr
LINE1+next_index:data="1";
// line 2
LINE2: begin data=8'b1100_0000; RS=0; end // set DDRAM addr
LINE2+1: data = "U";
LINE2+2: data = "n";
LINE2+3: data = "i";
LINE2+4: data = "v";
LINE2+5: data = "e";
LINE2+6: data = "r";
LINE2+7: data = "s";
LINE2+8: data = "i";
LINE2+9: data = "t";
LINE2+10: data = "y";
LINE2+11: data = "U";
LINE2+12: data = "n";
LINE2+13: data = "i";
LINE2+14: data = "v";
LINE2+15: data = "e";
LINE2+16: data = "r";gfbvct
LAST: halt=1;
default: halt=1;
endcase
end
endmodule



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
// Timing width
// 50MHz -> T = 20ns
// RS, RW to E > 40ns 3 clk
// E pulse width > 230ns 12 clk
// E to RS, RW > 10ns 1 clk
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