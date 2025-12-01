`timescale 1ns/1ns

module PC(
	input CLK,
	input [31:0]Dirsig,
	output reg [31:0]Dir
);

initial 
	begin
		Dir = 8'd0;
	end

	always @(posedge CLK)
	begin
		Dir <= Dirsig;
	end
	
endmodule
