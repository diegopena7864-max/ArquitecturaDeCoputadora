`timescale 1ns/1ps


module cusi_TB();
//intanciamos
	reg [3:0]A_tb;
	reg [3:0]B_tb;
	reg [3:0]sel_tb;
	wire [3:0] C_tb;

	cuasi DUV(.a(A_tb), .b(B_tb), .sel(sel_tb),.c(C_tb));

	initial begin
	
		A_tb = 4'd0;
        B_tb = 4'd0;
        sel_tb = 1'b0;
		 $monitor("t=%0dns | A=%d (%b) | B=%d (%b) | sel=%b | C=%d (%b)", 
                  $time, A_tb, A_tb, B_tb, B_tb, sel_tb, C_tb, C_tb);
		//8+6
		A_tb = 4'd8;
		B_tb = 4'd6;
		sel_tb =4'd0;//suma 8+6 -> 14
		#100
		sel_tb =1'd1;//suma 8&6 -> 0
		#100
		
		//3+2
		A_tb = 4'd3;
		B_tb = 4'd2;
		sel_tb = 4'd0;
		#100
		sel_tb = 1'd1;
		#100
		
		//1+1
		A_tb = 4'd1;
		B_tb = 4'd1;
		sel_tb = 4'd0;
		#100
		sel_tb = 1'd1;
		#100
		
		//1+5
		A_tb = 4'd1;
		B_tb = 4'd5;
		sel_tb = 4'd0;
		#100
		sel_tb = 1'd1;
		#100
		
		//10+2
		A_tb = 4'd10;
		B_tb = 4'd2;
		sel_tb = 4'd0;
		#100
		sel_tb = 1'd1;
		#100
		$stop;
	end
endmodule
