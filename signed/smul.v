module smul(clk,reset,start,word1,word2,product,ready);
	input clk,reset,start;
	input[3:0]word1,word2;
	output[7:0]product;
	output ready;
	wire m0,load,shift,addshift,sub;
	datapaths u1(clk,reset,load,shift,addshift,sub,word1,word2,product,m0);
	controllers u2(clk,reset,start,m0,load,shift,addshift,sub,ready);
endmodule



module controllers(clk,reset,start,m0,load,shift,addshift,sub,ready);
	input clk, reset,start,m0;
	output load, shift, addshift,sub, ready;
	
	reg state;
	reg[1:0]count;
	localparam s0=0,s1=1;
	
	always@(posedge clk,posedge reset)
		if(reset)begin state<=s0; count<=0;end
		else
			case (state)
				s0:if(start)begin state<=s1;count<=3;end
				s1:if(count==0)state<=s0;else count<=count -1;
			endcase
	assign load=(state==s0)&&start;
	assign shift = (state==s1)&&~m0;
	assign addshift = (state==s1)&&m0;
	assign sub = (state==s1)&&(count==0);
	assign ready = (state == s0)&&~reset;
endmodule



module datapaths(clk,reset, load,shift,addshift,sub,word1,word2,product,m0);
	input clk, reset,load,shift,addshift,sub;
	input [3:0]word1,word2;
	output [7:0]product;
	output m0;
	
	reg[7:0]product;
	reg[3:0]multiplicand;
	wire[4:0]sum;
	wire[4:0]eproduct,emcand;
	
	assign m0=product[0];
	
	assign eproduct={product[7],product[7:4]};
	assign emcand = {multiplicand[3],multiplicand};
	assign sum=sub? (eproduct-emcand):(eproduct+emcand);
	always@(posedge clk or posedge reset)begin
		if(reset)begin multiplicand <= 0;product<=0;end
		else if (load)begin
			multiplicand<=word1;
			product<={4'b0,word2};
		end
		else if(shift)
			product<={product[7],product[7:1]};
		else if (addshift)
			product<={sum,product[3:1]};
	end
endmodule