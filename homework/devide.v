module controller (clk, reset, start, lt, load, shift, subshift, ready);
	input clk, reset,start,lt;
	output load,shift,subshift,ready;
	reg overflow;
	reg state;
	reg [1:0]count;
	localparam s0=0,s1=1;
	always@ (posedge clk or posedge reset)
		if (reset) begin state <= s0;count<=0;end
		else
			case (state)
				s0: if (start)begin state <= s1; count <=3; end
				s1: if(count ==0) state <= s0;
					else count <= count -1;
			endcase
	assign load=(state==s0)&&start;
	assign shift=(state==s1)&&lt;
	assign subshift = (state == s1)&& ~lt;
	assign ready = (state == s0) &&~reset;
endmodule
module divide(clk, reset, start, word1, word2, quotient, remainder, ready);
	input clk, reset, start;
	input [7:0] word1;
	input [3:0] word2;
	output [3:0] quotient, remainder;
	output ready;
	wire load, shift, subshift, lt;
	datapath u1 (clk, reset, load, shift, subshift, word1, word2, quotient, remainder, lt);
	controller u2(clk, reset, start, lt, load, shift, subshift, ready);
endmodule
module datapath (clk, reset, load, shift, subshift, word1, word2, quotient, remainder, lt);
	input clk, reset,load, shift, subshift;
	input [7:0]word1;
	input [3:0]word2;
	output [3:0]quotient, remainder;
	output lt;
	reg [7:0] dividend;
	reg [3:0] divisor;
	wire [4:0] diff;
	wire lt;
	assign diff = dividend[7:3] - divisor;
	assign lt = diff[4];
	assign quotient = dividend[3:0];
	assign remainder = dividend[7:4];
	always@(posedge clk or posedge reset)begin
		if (reset) begin dividend <= 0; divisor <=0; end
		else if (load) begin 
			dividend <= word1;
			divisor <= word2;
		end
		else if (shift)
			dividend <= {dividend[6:0],1'b0};
		else if (subshift)
			dividend<={diff[3:0],dividend[2:0],1'b1};
	end
endmodule
