`timescale 1ns/1ps

module alu_extendida_TB();
    // Señales de prueba
    reg  [3:0] A_tb;
    reg  [3:0] B_tb;
    reg  [2:0] sel_tb;
    reg        dir_tb;
    wire [7:0] C_tb;

    // Instancia del DUT
    alu_extendida DUT (
        .a(A_tb),
        .b(B_tb),
        .sel(sel_tb),
        .dir(dir_tb),
        .c(C_tb)
    );

    initial begin
        // Monitor
        $monitor("t=%0dns | A=%d (%b) | B=%d (%b) | sel=%b | dir=%b | C=%d (%b)", 
                 $time, A_tb, A_tb, B_tb, B_tb, sel_tb, dir_tb, C_tb, C_tb);

        // --- Suma ---
        A_tb = 4'd8; B_tb = 4'd6; sel_tb = 3'b000; dir_tb=0; #50; // 8+6=14

        // --- Resta ---
        A_tb = 4'd10; B_tb = 4'd3; sel_tb = 3'b001; #50;       // 10-3=7
        A_tb = 4'd3;  B_tb = 4'd10; sel_tb = 3'b001; #50;      // 3-10=wrap

        // --- AND ---
        A_tb = 4'b1010; B_tb = 4'b1100; sel_tb = 3'b010; #50;  // 1010 & 1100 = 1000

        // --- OR ---
        sel_tb = 3'b011; #50; // 1010 | 1100 = 1110

        // --- XOR ---
        sel_tb = 3'b100; #50; // 1010 ^ 1100 = 0110

        // --- Comparación ---
        A_tb = 4'd5; B_tb = 4'd5; sel_tb = 3'b101; #50;  // iguales -> 1
        A_tb = 4'd9; B_tb = 4'd2; sel_tb = 3'b101; #50;  // a > b -> 2
        A_tb = 4'd2; B_tb = 4'd9; sel_tb = 3'b101; #50;  // a < b -> 0

        // --- Desplazamientos ---
        A_tb = 4'b0110; sel_tb = 3'b110; dir_tb=0; #50;  // 0110 << 1 = 1100
        dir_tb=1; #50;                                   // 0110 >> 1 = 0011

        // --- Multiplicación ---
        A_tb = 4'd15; B_tb = 4'd15; sel_tb = 3'b111; #50; // 15*15 = 225

        $stop;
    end
endmodule
