// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Simple clock generator for simulation (replaces HSOSC)

module clock_gen (
    output logic clk
);

    initial begin
        clk = 0;
        forever #166.67 clk = ~clk; // 3MHz = 333.33ns period
    end

endmodule
