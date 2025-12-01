`timescale 1ns/1ns

module Alu(
	input [3:0]op1,
	input [31:0]op2,
	output [31:0]Resultado
);

assign Resultado = op1 + op2;

endmodule

