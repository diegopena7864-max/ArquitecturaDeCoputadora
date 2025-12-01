`timescale 1ns/1ns
 
 module Burrito(
	input [4:0]Dir1,
	input [4:0]Dir2,
	input [4:0] DirEscritura
 );
 
 wire [31:0] c1,c2,c3;
 
 BR inst1(
	.AR1(Dir1),
	.AR2(Dir2),
	.AWrite(DirEscritura), 
	.DataIn(c3),
	.RegWrite(1), 
	.DR1(c1),
	.DR2(c2) 
 );
 
 ADD inst2(
	.op1(c1), 
	.op2(c2), 
	.Resultado(c3)
	);
 
 endmodule 