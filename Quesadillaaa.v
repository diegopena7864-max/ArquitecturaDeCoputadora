
module Quesadilla(
	input CLK_Q ,
	output [31:0]InstQ
);

wire [31:0] C1;
wire [31:0] C2;

Alu insta1(
	.op1(4'b0100),
	.op2(C1),
	.Resultado(C2)
);

PC intant2(
	.Dirsig(C2),
	.Dir(C1)

);

mem instat3(
	.dir(C1),
	.sal(InstQ)
);
endmodule
