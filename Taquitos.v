`timescale 1ns/1ns

module Taquito(
	input [3:0]A,
	output reg [7:0] B
	);
	
reg [7:0] chicharron = 8'd67;
reg [7:0] papa = 8'd80;
reg [7:0] frijol = 8'd70;
reg [7:0] deshebrada = 8'd68;

always @*
	begin
		case(A)
			4'b0001:
				begin
					B=chicharron;
				end
			4'b0010:
				begin
					B=papa;
				end
			4'b0100:
				begin
					B=frijol;
				end
			4'b1000:
				begin
					B=deshebrada;
				end
				default:
				begin
					B=8'dx;
				end
		endcase
	end
endmodule