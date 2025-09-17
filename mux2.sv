// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Mux2 - 2-to-1 Multiplexer
// Simple 2-to-1 multiplexer for signal selection

module mux2 (
    input  logic        sel,        // Select signal
    input  logic        in0,        // Input 0
    input  logic        in1,        // Input 1
    output logic        out         // Output
);

    // Simple 2-to-1 multiplexer
    assign out = sel ? in1 : in0;

endmodule
