// Emmett Stralka estralka@hmc.edu
// 09/09/25
// 2-to-1 multiplexer: selects between two 4-bit inputs based on select signal

module MUX2_4bit (
    input  logic [3:0] d0,      // First 4-bit input (selected when select=0)
    input  logic [3:0] d1,      // Second 4-bit input (selected when select=1)
    input  logic       select,  // Select signal (0=d0, 1=d1)
    output logic [3:0] y        // 4-bit output
);

    // 2-to-1 multiplexer: selects d1 when select=1, otherwise selects d0
    assign y = select ? d1 : d0;
endmodule
