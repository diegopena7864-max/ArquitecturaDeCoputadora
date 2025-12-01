`timescale 1ns/1ns

// ALU extendida con comparaciones, desplazamientos y multiplicación
module alu_extendida(
    input  [3:0] a,     // Operando A
    input  [3:0] b,     // Operando B
    input  [2:0] sel,   // Selector principal
    input        dir,   // Dirección para desplazamientos (0=<<, 1=>>)
    output reg [7:0] c  // Salida (8 bits por multiplicación)
);

always @* begin
    case(sel)
        3'b000: c = a + b;        // Suma
        3'b001: c = a - b;        // Resta
        3'b010: c = a & b;        // AND
        3'b011: c = a | b;        // OR
        3'b100: c = a ^ b;        // XOR
        3'b101: begin             // Comparaciones
            if (a == b)
                c = 8'd1;         // iguales
            else if (a > b)
                c = 8'd2;         // mayor
            else
                c = 8'd0;         // menor
        end
        3'b110: begin             // Desplazamientos
            if (dir == 1'b0)
                c = a << 1;       // desplazamiento a la izquierda
            else
                c = a >> 1;       // desplazamiento a la derecha
        end
        3'b111: c = a * b;        // Multiplicación
        default: c = 8'b00000000; // Default
    endcase
end

endmodule
