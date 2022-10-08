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

