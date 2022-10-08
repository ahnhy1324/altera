module counter(clk,reset,enable,qout,tc);
	input clk, reset, enable;
	output reg[3:0] qout;
	output tc;
	always@(posedge clk or negedge reset)begin
		if(~reset) qout <= 0;
		else if (enable) qout <=qout+1;
	end
	assign tc= enable && (qout==4'b1111);
endmodule
	