
module stopwatch(clk,mod,enable,ms,ms10,sec,sec10,min,min10,stop);
input clk,mod,enable;
output [0:6] ms,ms10,sec,sec10,min,min10;
output stop;
wire clk;
wire clk1;

wire [3:0]bcd;
wire [3:0]bcd10;
wire [3:0]minw;
wire [2:0]minw10;
wire [3:0]hou;
wire [2:0]hou10;


wire tc;
wire tc2;
wire tc3;
wire tc4;
wire tc5;

reg [1:0]mode=2'b10;
clk001hz(clk,clk1);
led u1(bcd,ms);
led u2(bcd10,ms10);
led u3(minw,sec);
led u4(minw10,sec10);
led k1(hou,min);
led k2(hou10,min10);

counterN  #(10,4) u5 (clk1&(mode==1),(mode==0),(mode==1),bcd,tc);
counterN  #(10,4) u7 (tc,(mode==0),1,bcd10,tc2);
counterN  #(10,4) u6 (tc2,(mode==0),1,minw,tc3);
counterN  #(6,3) u8 (tc3,(mode==0),1,minw10,tc4);
counterN  #(10,4) u9 (tc4,(mode==0),1,hou,tc5);
counterN  #(6,3) 	u10 (tc5,(mode==0),1,hou10,);

assign stop=(mode==1)?0:1; 
always@(negedge mod or negedge enable)begin
	if(!enable)mode=2;
	else if(!mod)begin
	case(mode)
	2:mode=0;
	default mode=(mode+1);
	endcase
	end
end
endmodule
