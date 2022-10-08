module div (clk, reset, start, word1, word2, quotient, remainder, ready);
	input clk, reset, start;
	input [7:0]word1;
	input [3:0]word2;
	output [3:0]quotient, remainder;
	output ready;
	wire load, shift, subshift, sub, lt;
	datapath u1(clk, reset, load, shift, subshift, word1, word2, quotient, remainder, lt);
	controler u2(clk, reset, start, lt, load, shift, subshift, ready);
endmodule


module datapath(clk, reset, load, shift, subshift, word1, word2, quotient, remainder,lt);
	input clk, reset, load, shift, subshift;
	input [7:0]word1;
	input [3:0]word2;
	output [3:0]quotient, remainder;
	output lt;
	reg [7:0]dividend;
	reg [3:0]divisor;
	reg sign;
	wire [4:0]diff;
	wire lt;
	wire [4:0]edivisor;
	wire [4:0]edividend;
	wire [4:0]diff2;
	assign edivisor={divisor[3],divisor};
	assign diff = (dividend[7]^divisor[3])?(dividend[7:3]+edivisor):(dividend[7:3]-edivisor);
	assign lt = (dividend[7]^diff[4])&&(diff!=4'b0);
	assign quotient=sign? -dividend[3:0]: dividend[3:0];
	assign remainder= dividend[7:4];
	always@ (posedge clk or posedge reset)begin
		if (reset)begin dividend <= 0; divisor <=0; end
		else if (load)begin
			dividend <=word1;
			divisor <=word2;
			sign <=word1[7]^word2[3];
		end
		else if (shift)
			dividend <= {dividend[6:0],1'b0};
		else if (subshift)
			dividend <={diff[3:0],dividend[2:0],1'b1};
	end
endmodule


module controler(clk, reset, start, lt, load, shift, subshift, ready);
	input clk, reset, start, lt;
	output load, shift, subshift, ready;
	reg overflow;
	reg state;
	reg [1:0]count;
	localparam s0= 0, s1=1;
	always@(posedge clk or posedge reset)begin
		if(reset)begin state <= s0; count <= 0;end
		else 
			case (state)
			s0: if(start)begin state <= s1; count <=3; end
			s1: if(count==0)state <= s0;
				else count <= count -1;
			endcase
	end
	assign load= (state==s0)&&start;
	assign shift = (state == s1) &&lt;
	assign subshift = (state== s1)&& ~lt;
	assign ready = (state==s0)&& ~reset;
endmodule
