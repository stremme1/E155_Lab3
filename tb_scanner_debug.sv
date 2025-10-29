// ============================================================================
// KEYPAD SCANNER TEST BENCH - SHOW MODULE STATE CHANGES
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench that shows actual module state changes in waveforms
// ============================================================================


module tb_scanner_debug;

    // Clock and reset
    logic        clk;
    logic        rst_n;
    
    // Scanner outputs
    logic [3:0]  row;
    logic [3:0]  row_idx;
    logic [3:0]  col_sync;
    logic        key_detected;
    logic        scan_stop;
    
    // Scanner inputs (simulated keypad)
    logic [3:0]  col;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    keypad_scanner dut (
        .clk(clk),
        .rst_n(rst_n),
        .row(row),
        .col(col),
        .row_idx(row_idx),
        .col_sync(col_sync),
        .key_detected(key_detected),
        .scan_stop(scan_stop)
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
        $dumpfile("tb_scanner_debug.vcd");
        $dumpvars(0, tb_scanner_debug);
        // Also dump internal scanner signals
        $dumpvars(0, dut.current_state);
        $dumpvars(0, dut.scan_counter);
        $dumpvars(0, dut.scan_timeout);
    end
    
    // ========================================================================
    // TEST STIMULUS - SHOW STATE CHANGES
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("SCANNER TEST - SHOWING MODULE STATE CHANGES");
        $display("==========================================");
        
        // Initialize
        rst_n = 0;
        col = 4'b1111; // No keys pressed
        
        // Reset sequence
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
        
        $display("Reset complete - scanner should start cycling through states");
        
        // Test 1: No keys - let scanner cycle through all states
        $display("Test 1: No keys - watch scanner cycle through SCAN_ROW0->SCAN_ROW1->SCAN_ROW2->SCAN_ROW3");
        col = 4'b1111;
        repeat(100) @(posedge clk); // Let it cycle many times
        
        // Test 2: Press key 1 (Row0, Col0) - should see key_detected go high
        $display("Test 2: Press key 1 (Row0, Col0) - should see key_detected=1 and scan_stop=1");
        col = 4'b1110;
        repeat(50) @(posedge clk); // Hold for many cycles
        
        // Test 3: Release key
        $display("Test 3: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 4: Press key 2 (Row0, Col1) - should see key_detected go high
        $display("Test 4: Press key 2 (Row0, Col1) - should see key_detected=1 and scan_stop=1");
        col = 4'b1101;
        repeat(50) @(posedge clk);
        
        // Test 5: Release key
        $display("Test 5: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 6: Press key 3 (Row0, Col2) - should see key_detected go high
        $display("Test 6: Press key 3 (Row0, Col2) - should see key_detected=1 and scan_stop=1");
        col = 4'b1011;
        repeat(50) @(posedge clk);
        
        // Test 7: Release key
        $display("Test 7: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 8: Press key C (Row0, Col3) - should see key_detected go high
        $display("Test 8: Press key C (Row0, Col3) - should see key_detected=1 and scan_stop=1");
        col = 4'b0111;
        repeat(50) @(posedge clk);
        
        // Test 9: Release key
        $display("Test 9: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 10: Press key 4 (Row1, Col0) - should see key_detected go high
        $display("Test 10: Press key 4 (Row1, Col0) - should see key_detected=1 and scan_stop=1");
        col = 4'b1110;
        repeat(50) @(posedge clk);
        
        // Test 11: Release key
        $display("Test 11: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 12: Press key 5 (Row1, Col1) - should see key_detected go high
        $display("Test 12: Press key 5 (Row1, Col1) - should see key_detected=1 and scan_stop=1");
        col = 4'b1101;
        repeat(50) @(posedge clk);
        
        // Test 13: Release key
        $display("Test 13: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 14: Press key 6 (Row1, Col2) - should see key_detected go high
        $display("Test 14: Press key 6 (Row1, Col2) - should see key_detected=1 and scan_stop=1");
        col = 4'b1011;
        repeat(50) @(posedge clk);
        
        // Test 15: Release key
        $display("Test 15: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 16: Press key D (Row1, Col3) - should see key_detected go high
        $display("Test 16: Press key D (Row1, Col3) - should see key_detected=1 and scan_stop=1");
        col = 4'b0111;
        repeat(50) @(posedge clk);
        
        // Test 17: Release key
        $display("Test 17: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 18: Press key 7 (Row2, Col0) - should see key_detected go high
        $display("Test 18: Press key 7 (Row2, Col0) - should see key_detected=1 and scan_stop=1");
        col = 4'b1110;
        repeat(50) @(posedge clk);
        
        // Test 19: Release key
        $display("Test 19: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 20: Press key 8 (Row2, Col1) - should see key_detected go high
        $display("Test 20: Press key 8 (Row2, Col1) - should see key_detected=1 and scan_stop=1");
        col = 4'b1101;
        repeat(50) @(posedge clk);
        
        // Test 21: Release key
        $display("Test 21: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 22: Press key 9 (Row2, Col2) - should see key_detected go high
        $display("Test 22: Press key 9 (Row2, Col2) - should see key_detected=1 and scan_stop=1");
        col = 4'b1011;
        repeat(50) @(posedge clk);
        
        // Test 23: Release key
        $display("Test 23: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 24: Press key E (Row2, Col3) - should see key_detected go high
        $display("Test 24: Press key E (Row2, Col3) - should see key_detected=1 and scan_stop=1");
        col = 4'b0111;
        repeat(50) @(posedge clk);
        
        // Test 25: Release key
        $display("Test 25: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 26: Press key A (Row3, Col0) - should see key_detected go high
        $display("Test 26: Press key A (Row3, Col0) - should see key_detected=1 and scan_stop=1");
        col = 4'b1110;
        repeat(50) @(posedge clk);
        
        // Test 27: Release key
        $display("Test 27: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 28: Press key 0 (Row3, Col1) - should see key_detected go high
        $display("Test 28: Press key 0 (Row3, Col1) - should see key_detected=1 and scan_stop=1");
        col = 4'b1101;
        repeat(50) @(posedge clk);
        
        // Test 29: Release key
        $display("Test 29: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 30: Press key B (Row3, Col2) - should see key_detected go high
        $display("Test 30: Press key B (Row3, Col2) - should see key_detected=1 and scan_stop=1");
        col = 4'b1011;
        repeat(50) @(posedge clk);
        
        // Test 31: Release key
        $display("Test 31: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 32: Press key F (Row3, Col3) - should see key_detected go high
        $display("Test 32: Press key F (Row3, Col3) - should see key_detected=1 and scan_stop=1");
        col = 4'b0111;
        repeat(50) @(posedge clk);
        
        // Test 33: Release key
        $display("Test 33: Release key - should see key_detected=0 and scan_stop=0");
        col = 4'b1111;
        repeat(50) @(posedge clk);
        
        // Test 34: Rapid key changes - watch state changes
        $display("Test 34: Rapid key changes - watch state changes");
        col = 4'b1110; repeat(10) @(posedge clk); // Key 1
        col = 4'b1101; repeat(10) @(posedge clk); // Key 2
        col = 4'b1011; repeat(10) @(posedge clk); // Key 3
        col = 4'b0111; repeat(10) @(posedge clk); // Key C
        col = 4'b1110; repeat(10) @(posedge clk); // Key 4
        col = 4'b1101; repeat(10) @(posedge clk); // Key 5
        col = 4'b1011; repeat(10) @(posedge clk); // Key 6
        col = 4'b0111; repeat(10) @(posedge clk); // Key D
        col = 4'b1110; repeat(10) @(posedge clk); // Key 7
        col = 4'b1101; repeat(10) @(posedge clk); // Key 8
        col = 4'b1011; repeat(10) @(posedge clk); // Key 9
        col = 4'b0111; repeat(10) @(posedge clk); // Key E
        col = 4'b1110; repeat(10) @(posedge clk); // Key A
        col = 4'b1101; repeat(10) @(posedge clk); // Key 0
        col = 4'b1011; repeat(10) @(posedge clk); // Key B
        col = 4'b0111; repeat(10) @(posedge clk); // Key F
        col = 4'b1111; repeat(50) @(posedge clk); // Release all
        
        $display("Test complete! Check the VCD file for waveforms.");
        $finish;
    end

endmodule