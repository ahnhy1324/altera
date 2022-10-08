module mulmul(clk,reset,start,word1,word2,product,ready,sign);
	input clk,reset,start;
	input[3:0]word1,word2;
	output[7:0]product;
	wire [7:0] test1,test2;
	wire t,f;
	output ready;
	input sign;
	wire m0,load,shift,add;
	wire m1,load2,shift2;
	datapath u1(clk,reset,load,shift,add,word1,word2,test1,m0);
	controller u2(clk,reset,start,m0,load,shift,add,t);
	datapaths u3(clk,reset,load2,shift2,addshift,sub,word1,word2,test2,m1);
	controllers u4(clk,reset,start,m1,load2,shift2,addshift,sub,f);
	assign product=(sign==1)? test2:test1;
	assign ready=(sign==1)? f:t;
endmodule