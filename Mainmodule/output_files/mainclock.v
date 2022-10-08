
module clock(mod,in,up,clk,display,display10,min1,min10,hour,hours);
input mod;
input [1:0]in;
input up;
input clk;
output [0:6]display;
output [0:6]display10;
output [0:6]min1;
output [0:6]min10;
output [0:6]hour;
output [0:6]hours;

reg mode=1;

wire clk;
wire clk1;

wire but;

wire [4:0]bcd;
wire [4:0]bcd10;
wire [4:0]min;
wire [4:0]minw10;
wire [4:0]hou;

wire tc;
wire tc2;
wire tc3;
wire tc4;

reg tc5;


button button1 (clk,up,but);
clk1hz(clk,clk1);

led u1(bcd,display);
led u2(bcd10,display10);
led u3(min+(in[1]&clk1)*10,min1);
led u4(minw10+(in[1]&clk1)*10,min10);
led u11(hou%10+(in[0]&clk1)*10,hour);
led u10(hou/10+(in[0]&clk1)*10,hours);

counterN  #(10,4) u5 (clk1&mode,(in==0)&(mod==1),1,bcd,tc);
counterN  #(6,3) u7 (!tc,(in==0)&(mod==1),1,bcd10,tc2);
counterN  #(10,4) u6 ((mode==0&in[1])?!but:!tc2,0,1,min,tc3);
counterN  #(6,3) u8 (!tc3,0,1,minw10,tc4);
counterN  #(24,5) u9 ((mode==0&in[0])?!but:!tc5,0,1,hou,);

always begin
tc5=tc4&mode;
end

always@(mod)begin
	if(mode==mod)mode=!mode;
end
endmodule
