`timescale 1ns/1ns

module mem( 
	input [7:0]dir,
	output reg [31:0]sal
);


reg [7:0] Memor[0:255];

initial begin 
	$readmemb("memorias.txt",Memor);
	end
	

assign salida ={Memor[dir],Memor[dir+1],Memor[dir+2],Memor[dir+3]};

endmodule

