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
	assign tc=(qout==N-1)&enable;
	always @(posedge clk or posedge reset)begin
		if (reset)qout<=0;
		else if (enable) begin
			if(qout==N-1)qout=0;
			else qout <= qout+1;
		end
	end
endmodule