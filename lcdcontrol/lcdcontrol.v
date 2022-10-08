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