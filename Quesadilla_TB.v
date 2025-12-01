`timescale 1ns/1ns

module Quesadilla_tb;

// Señales
reg CLK_Q;
wire [31:0] InstQ;

// Instancia del módulo principal
Quesadilla uut (
    .CLK_Q(CLK_Q),
    .InstQ(InstQ)
);

// Generador de reloj (10 ns)
always #5 CLK_Q = ~CLK_Q;

initial begin
    $dumpfile("Quesadilla_tb.vcd");
    $dumpvars(0, Quesadilla_tb);

    $display("Iniciando simulación de Quesadilla...");
    CLK_Q = 0;

end

initial begin
    $monitor("t=%0dns | CLK=%b | InstQ=%h", $time, CLK_Q, InstQ);
end

endmodule
