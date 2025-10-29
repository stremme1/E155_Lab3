// ============================================================================
// KEYPAD DECODER TEST BENCH - SHOW MODULE STATE CHANGES
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench that shows actual module state changes in waveforms
// ============================================================================


module tb_decoder_debug;

    // Clock
    logic        clk;
    
    // Decoder inputs
    logic [3:0]  row_onehot;
    logic [3:0]  col_onehot;
    
    // Decoder outputs
    logic [3:0]  key_code;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    keypad_decoder dut (
        .row_onehot(row_onehot),
        .col_onehot(col_onehot),
        .key_code(key_code)
    );
    
    // ========================================================================
    // CLOCK GENERATION - VERY SLOW FOR QUESTA
    // ========================================================================
    initial begin
        clk = 0;
        forever #1000 clk = ~clk; // 500kHz clock (2us period) - SLOW ENOUGH TO SEE
    end
    
    // ========================================================================
    // WAVEFORM DUMPING - SHOW ALL INTERNAL SIGNALS
    // ========================================================================
    initial begin
        $dumpfile("tb_decoder_debug.vcd");
        $dumpvars(0, tb_decoder_debug);
        // Also dump internal decoder signals
        $dumpvars(0, dut);
    end
    
    // ========================================================================
    // TEST STIMULUS - SHOW STATE CHANGES
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("DECODER TEST - SHOWING MODULE STATE CHANGES");
        $display("==========================================");
        
        // Initialize
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        
        $display("Starting input changes...");
        
        // Test 1: No input
        $display("Test 1: No input - should see key_code=0x0");
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        repeat(10) @(posedge clk);
        
        // Test 2: Row 0 keys - should see key_code change
        $display("Test 2: Row 0 keys - watch key_code change");
        row_onehot = 4'b0001; col_onehot = 4'b0001; repeat(10) @(posedge clk); // Key 1
        row_onehot = 4'b0001; col_onehot = 4'b0010; repeat(10) @(posedge clk); // Key 2
        row_onehot = 4'b0001; col_onehot = 4'b0100; repeat(10) @(posedge clk); // Key 3
        row_onehot = 4'b0001; col_onehot = 4'b1000; repeat(10) @(posedge clk); // Key C
        
        // Test 3: Row 1 keys - should see key_code change
        $display("Test 3: Row 1 keys - watch key_code change");
        row_onehot = 4'b0010; col_onehot = 4'b0001; repeat(10) @(posedge clk); // Key 4
        row_onehot = 4'b0010; col_onehot = 4'b0010; repeat(10) @(posedge clk); // Key 5
        row_onehot = 4'b0010; col_onehot = 4'b0100; repeat(10) @(posedge clk); // Key 6
        row_onehot = 4'b0010; col_onehot = 4'b1000; repeat(10) @(posedge clk); // Key D
        
        // Test 4: Row 2 keys - should see key_code change
        $display("Test 4: Row 2 keys - watch key_code change");
        row_onehot = 4'b0100; col_onehot = 4'b0001; repeat(10) @(posedge clk); // Key 7
        row_onehot = 4'b0100; col_onehot = 4'b0010; repeat(10) @(posedge clk); // Key 8
        row_onehot = 4'b0100; col_onehot = 4'b0100; repeat(10) @(posedge clk); // Key 9
        row_onehot = 4'b0100; col_onehot = 4'b1000; repeat(10) @(posedge clk); // Key E
        
        // Test 5: Row 3 keys - should see key_code change
        $display("Test 5: Row 3 keys - watch key_code change");
        row_onehot = 4'b1000; col_onehot = 4'b0001; repeat(10) @(posedge clk); // Key A
        row_onehot = 4'b1000; col_onehot = 4'b0010; repeat(10) @(posedge clk); // Key 0
        row_onehot = 4'b1000; col_onehot = 4'b0100; repeat(10) @(posedge clk); // Key B
        row_onehot = 4'b1000; col_onehot = 4'b1000; repeat(10) @(posedge clk); // Key F
        
        // Test 6: Invalid combinations - should see key_code=0x0
        $display("Test 6: Invalid combinations - should see key_code=0x0");
        row_onehot = 4'b0000; col_onehot = 4'b0000; repeat(10) @(posedge clk); // No input
        row_onehot = 4'b0011; col_onehot = 4'b0001; repeat(10) @(posedge clk); // Multiple rows
        row_onehot = 4'b0001; col_onehot = 4'b0011; repeat(10) @(posedge clk); // Multiple columns
        
        // Test 7: Rapid changes - watch key_code change quickly
        $display("Test 7: Rapid changes - watch key_code change quickly");
        row_onehot = 4'b0001; col_onehot = 4'b0001; repeat(5) @(posedge clk); // Key 1
        row_onehot = 4'b0001; col_onehot = 4'b0010; repeat(5) @(posedge clk); // Key 2
        row_onehot = 4'b0001; col_onehot = 4'b0100; repeat(5) @(posedge clk); // Key 3
        row_onehot = 4'b0001; col_onehot = 4'b1000; repeat(5) @(posedge clk); // Key C
        row_onehot = 4'b0010; col_onehot = 4'b0001; repeat(5) @(posedge clk); // Key 4
        row_onehot = 4'b0010; col_onehot = 4'b0010; repeat(5) @(posedge clk); // Key 5
        row_onehot = 4'b0010; col_onehot = 4'b0100; repeat(5) @(posedge clk); // Key 6
        row_onehot = 4'b0010; col_onehot = 4'b1000; repeat(5) @(posedge clk); // Key D
        row_onehot = 4'b0100; col_onehot = 4'b0001; repeat(5) @(posedge clk); // Key 7
        row_onehot = 4'b0100; col_onehot = 4'b0010; repeat(5) @(posedge clk); // Key 8
        row_onehot = 4'b0100; col_onehot = 4'b0100; repeat(5) @(posedge clk); // Key 9
        row_onehot = 4'b0100; col_onehot = 4'b1000; repeat(5) @(posedge clk); // Key E
        row_onehot = 4'b1000; col_onehot = 4'b0001; repeat(5) @(posedge clk); // Key A
        row_onehot = 4'b1000; col_onehot = 4'b0010; repeat(5) @(posedge clk); // Key 0
        row_onehot = 4'b1000; col_onehot = 4'b0100; repeat(5) @(posedge clk); // Key B
        row_onehot = 4'b1000; col_onehot = 4'b1000; repeat(5) @(posedge clk); // Key F
        
        // Test 8: Final state
        $display("Test 8: Final state - should see key_code=0x0");
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        repeat(10) @(posedge clk);
        
        $display("Test complete! Check the VCD file for waveforms.");
        $finish;
    end

endmodule