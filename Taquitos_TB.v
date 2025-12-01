`timescale 1ns/1ns
module Taquito_tb();
	reg [3:0] A_TB;
	wire [7:0] B_TB;
	
Taquito DUV(
	.A(A_TB),
	.B(B_TB)
	);
	
initial
begin 
	A_TB =4'b0001;
	#100
	A_TB =4'b0010;
	#100
	A_TB =4'b0100;
	#100
	A_TB =4'b1000;
	#100
	$stop;
end
endmodule