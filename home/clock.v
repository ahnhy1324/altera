module clock(mod,reset,clk,display,display10,min1,min10,hour,hour10);
input mod;
input reset;
input clk;
output [0:6]display;
output [0:6]display10;
output [0:6]min1;
output [0:6]min10;
output [0:6]hour;
output [0:6]hour10;

reg [0:6]mode=1;

wire [0:6]disp;
wire [0:6]disp10;
wire [0:6]minc1;
wire [0:6]minc10;
wire [0:6]hours;
wire [0:6]hours10;

wire pulse;

wire clk;
wire clk1;

wire [4:0]bcd;
wire [4:0]bcd10;
wire [4:0]min;
wire [4:0]minw10;
wire [4:0]hou;
wire [4:0]hou10;


wire tc;
wire tc2;
wire tc3;
wire tc4;
wire tc5;

clk1hz(clk,clk1);
led u1(bcd+(!mode*clk1*13),disp);
led u2(bcd10+(!mode*clk1*13),disp10);
led u3(min+(!mode*clk1*13),minc1);
led u4(minw10+(!mode*clk1*13),minc10);
led k1(hou%10+(!mode*clk1*13),hours);
led k2(hou/10+(!mode*clk1*13),hours10);

counterN  #(10,4) u5 (clk1&mode,!reset&mode,1,bcd,tc);
counterN  #(6,3) u7 (tc,!reset&mode,1,bcd10,tc2);
counterN  #(10,4) u6 (tc2^(!mode&!pulse),!reset&mode,1,min,tc3);
counterN  #(6,3) u8 (tc3,!reset&mode,1,minw10,tc4);
counterN  #(24,5) u9 (tc4,!reset&mode,1,hou,tc5);

pulse u10(clk,mode,reset,pulse);

assign display = disp;
assign display10 = disp10;
assign min1 = minc1;
assign min10 = minc10;
assign hour=hours;
assign hour10=hours10;

always@(posedge mod)begin
mode=!mode;
end
endmodule
module led(bcd, disp);
input [4:0] bcd;
output [0:6] disp;
reg [6:0] display;
assign disp = ~display;
always @(*) begin
case (bcd)
0: display=7'b111_1110;
1: display=7'b011_0000;
2: display=7'b110_1101;
3: display=7'b111_1001;
4: display=7'b011_0011;
5: display=7'b101_1011;
6: display=7'b101_1111;
7: display=7'b111_0000;
8: display=7'b111_1111;
9: display=7'b111_1011;
default: display = 7'b000_0000; // blank
endcase
end
endmodule
module clk1hz(clk50,clk1);
input clk50;
output reg clk1;
localparam N = 5000_0000/2;
wire tc;


counterN #(2500_0000,25)u1(clk50,0,1,,tc);
always @(posedge clk50)begin
if (tc)
clk1<=~clk1;
end
endmodule
module counterN(clk,reset,enable,qout,tc);
parameter N=24, M=5;
input clk, reset;
input enable;
output [M-1:0]qout;
output tc;
reg [M-1:0]qout;
assign tc=(qout==0)&enable;
always @(posedge clk or posedge reset)begin
if (reset)qout<=0;
else if (enable) begin
if(qout==N-1)qout=0;
else qout <= qout+1;
end
end
endmodule


module pulse(clk,reset,button_in,button_out);
	input clk,reset,button_in;
	output button_out;
	reg d0,d1;
	always@(posedge clk or posedge reset)begin
		if(reset)begin d0<=0;d1<=0;end
		else begin d0 <= button_in;d1<=d0;end
	end
	assign button_out=~d0 &d1;
endmodule