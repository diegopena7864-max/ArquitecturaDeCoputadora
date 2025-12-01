`timescale 1ns/1ns

//.1 definicion de mdulo y E/S
module cuasi(input [3:0]a,
	input [3:0] b,
	input sel,
	output reg [3:0]c //por que se le asigna su valore dentro del always.
	);

//.2 Def de componentes internos
//asssigns, intacias, bloquues secuenciale(initial,aways)

always @*
begin
	case(sel)
		1'b0:
			begin
				c=a +b;
			end

		1'b1:
			begin
				c=a&b;
			end
	endcase
end
endmodule
