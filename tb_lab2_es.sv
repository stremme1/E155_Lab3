// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench for Lab2_ES module

module tb_lab2_es();

    // Testbench signals
    logic        clk;
    logic        reset;
    logic [3:0]  s0;
    logic [3:0]  s1;
    logic [6:0]  seg;
    logic        select0;
    logic        select1;

    // Instantiate DUT
    Lab2_ES dut (
        .clk(clk),
        .reset(reset),
        .s0(s0),
        .s1(s1),
        .seg(seg),
        .select0(select0),
        .select1(select1)
    );

    // Test stimulus
    initial begin
        $display("=== Lab2_ES Display Testbench ===");
        
        // Initialize
        clk = 0;
        reset = 0;
        s0 = 4'h0;
        s1 = 4'h0;
        
        // Test reset behavior
        $display("Testing reset: seg = %b, select0 = %b, select1 = %b", seg, select0, select1);
        
        // Release reset
        reset = 1;
        clk = 1;
        $display("After reset: seg = %b, select0 = %b, select1 = %b", seg, select0, select1);
        
        // Test with "00" display
        s0 = 4'h0;
        s1 = 4'h0;
        clk = 0;
        clk = 1;
        $display("Display '00': seg = %b, select0 = %b, select1 = %b", seg, select0, select1);
        
        // Test with "5A" display
        s0 = 4'h5;
        s1 = 4'hA;
        clk = 0;
        clk = 1;
        $display("Display '5A': seg = %b, select0 = %b, select1 = %b", seg, select0, select1);
        
        // Test with "1F" display
        s0 = 4'h1;
        s1 = 4'hF;
        clk = 0;
        clk = 1;
        $display("Display '1F': seg = %b, select0 = %b, select1 = %b", seg, select0, select1);
        
        // Test multiplexing behavior
        clk = 0;
        clk = 1;
        $display("Multiplexing: seg = %b, select0 = %b, select1 = %b", seg, select0, select1);
        
        clk = 0;
        clk = 1;
        $display("Multiplexing: seg = %b, select0 = %b, select1 = %b", seg, select0, select1);
        
        $display("=== Test Complete ===");
        $finish;
    end

endmodule