
module Compuertas_logicas(
	//Declaraciones
	input a,
	input b,
	output _And,
	output _Nand,
	output _Or,
	output _Nor,
	output _Not,
	output _Xor,
	output _Xnor
	);
	//compuertas
	assign _And = a & b;
	assign _Nand = ~(a & b);
	assign _Or = a | b;
	assign _Nor = ~(a | b);
	assign _Not = ~a;
	assign _Xor = a^b;
	assign _Xnor= a ~^b;
endmodule

