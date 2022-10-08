module alarm(out2,out3,out4,out5,in0,in1,in2,in3,clk,led,in,mode,set);
output [0:6]out2,out3,out4,out5;
wire[0:6]out112,out113,out114,out115;
output led;
input [0:1]mode;
input[0:6]in0,in2,in3,in1;
input clk;
input in;
input [0:1]set;
reg ledcon=0;
wire go;
wire [4:0]bcd;
wire [4:0]hou;
reg a,b=0;


counterN  #(60,4) u8 (a,0,1,bcd,tc);
counterN  #(24,5) u9 (b,0,1,hou,);

led u3(bcd%10+((mode[0]&go)*10),out112);
led u4(bcd/10+((mode[0]&go)*10),out113);
led u5(hou%10+((mode[1]&go)*10),out114);
led u6(hou/10+((mode[1]&go)*10),out115);
clk1hz clk1 (clk,go);
assign led=ledcon;
assign out2=out112;
assign out3=out113;
assign out4=out114;
assign out5=out115;
always@(posedge go)begin
if ((in0==out112)&(in1==out113)&(in2==out114)&(in3==out115))ledcon=~ledcon;
else ledcon=0;
end
always begin
if(in&mode[0]) a=1;else a=0;
if(in&mode[1]) b=1;else b=0;
end
endmodule
