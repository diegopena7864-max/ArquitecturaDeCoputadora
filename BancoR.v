`timescale 1ns/1ns

module BR (
	input [4:0]AR1,//Direccion o indice 1
	input [4:0]AR2,//Direccion o indice 2
	input [4:0]AWrite, //Direccion donde se escribira
	input [31:0]DataIn,//Dato a guardar (escribir)
	input RegWrite, //señal que habilita escritura
	output reg[31:0]DR1,//salida1
	output reg[31:0]DR2 //salida2
);
reg [31:0]Banco[0:31];
initial
	begin
		$readmemb("Datos.txt",Banco);
		#10;
	end
	
always @*
	begin
		//Leer
		DR1 = Banco[AR1];
		DR2 = Banco[AR2];
		//Escribir
		if(RegWrite)
		begin
			Banco[AWrite]=DataIn;
		end
	end
endmodule