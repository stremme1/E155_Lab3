// ============================================================================
// LAB3 TOP MODULE TEST BENCH - SHOW MODULE STATE CHANGES
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench that shows actual module state changes in waveforms
// ============================================================================


module tb_top_debug;

    // Top module inputs
    logic        reset;
    logic [3:0]  keypad_cols;
    
    // Top module outputs
    logic [3:0]  keypad_rows;
    logic [6:0]  seg;
    logic        select0;
    logic        select1;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    lab3_top dut (
        .reset(reset),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .seg(seg),
        .select0(select0),
        .select1(select1)
    );
    
    // ========================================================================
    // WAVEFORM DUMPING - SHOW ALL INTERNAL SIGNALS
    // ========================================================================
    initial begin
        $dumpfile("tb_top_debug.vcd");
        $dumpvars(0, tb_top_debug);
        // Also dump internal signals from all modules
        $dumpvars(0, dut.scanner_inst.current_state);
        $dumpvars(0, dut.scanner_inst.scan_counter);
        $dumpvars(0, dut.scanner_inst.scan_timeout);
        $dumpvars(0, dut.debouncer_inst.current_state);
        $dumpvars(0, dut.debouncer_inst.debounce_cnt);
    end
    
    // ========================================================================
    // TEST STIMULUS - SHOW STATE CHANGES
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("TOP MODULE TEST - SHOWING MODULE STATE CHANGES");
        $display("==========================================");
        
        // Initialize
        reset = 0;
        keypad_cols = 4'b1111; // No keys pressed
        
        // Reset sequence
        repeat(5) @(posedge dut.clk);
        reset = 1;
        repeat(5) @(posedge dut.clk);
        
        $display("Reset complete - system should start running");
        
        // Test 1: No keys - let system run and show state changes
        $display("Test 1: No keys - watch scanner cycle through states");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk); // Let it cycle many times
        
        // Test 2: Press key 1 (Row0, Col0) - should see debouncer state changes
        $display("Test 2: Press key 1 (Row0, Col0) - watch debouncer go IDLE->DEBOUNCING->KEY_HELD");
        keypad_cols = 4'b1110;
        repeat(200) @(posedge dut.clk); // Hold for many cycles to see debounce
        
        // Test 3: Release key
        $display("Test 3: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 4: Press key 2 (Row0, Col1) - should see debouncer state changes
        $display("Test 4: Press key 2 (Row0, Col1) - watch debouncer state changes");
        keypad_cols = 4'b1101;
        repeat(200) @(posedge dut.clk);
        
        // Test 5: Release key
        $display("Test 5: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 6: Press key 3 (Row0, Col2) - should see debouncer state changes
        $display("Test 6: Press key 3 (Row0, Col2) - watch debouncer state changes");
        keypad_cols = 4'b1011;
        repeat(200) @(posedge dut.clk);
        
        // Test 7: Release key
        $display("Test 7: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 8: Press key C (Row0, Col3) - should see debouncer state changes
        $display("Test 8: Press key C (Row0, Col3) - watch debouncer state changes");
        keypad_cols = 4'b0111;
        repeat(200) @(posedge dut.clk);
        
        // Test 9: Release key
        $display("Test 9: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 10: Press key 4 (Row1, Col0) - should see debouncer state changes
        $display("Test 10: Press key 4 (Row1, Col0) - watch debouncer state changes");
        keypad_cols = 4'b1110;
        repeat(200) @(posedge dut.clk);
        
        // Test 11: Release key
        $display("Test 11: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 12: Press key 5 (Row1, Col1) - should see debouncer state changes
        $display("Test 12: Press key 5 (Row1, Col1) - watch debouncer state changes");
        keypad_cols = 4'b1101;
        repeat(200) @(posedge dut.clk);
        
        // Test 13: Release key
        $display("Test 13: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 14: Press key 6 (Row1, Col2) - should see debouncer state changes
        $display("Test 14: Press key 6 (Row1, Col2) - watch debouncer state changes");
        keypad_cols = 4'b1011;
        repeat(200) @(posedge dut.clk);
        
        // Test 15: Release key
        $display("Test 15: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 16: Press key D (Row1, Col3) - should see debouncer state changes
        $display("Test 16: Press key D (Row1, Col3) - watch debouncer state changes");
        keypad_cols = 4'b0111;
        repeat(200) @(posedge dut.clk);
        
        // Test 17: Release key
        $display("Test 17: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 18: Press key 7 (Row2, Col0) - should see debouncer state changes
        $display("Test 18: Press key 7 (Row2, Col0) - watch debouncer state changes");
        keypad_cols = 4'b1110;
        repeat(200) @(posedge dut.clk);
        
        // Test 19: Release key
        $display("Test 19: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 20: Press key 8 (Row2, Col1) - should see debouncer state changes
        $display("Test 20: Press key 8 (Row2, Col1) - watch debouncer state changes");
        keypad_cols = 4'b1101;
        repeat(200) @(posedge dut.clk);
        
        // Test 21: Release key
        $display("Test 21: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 22: Press key 9 (Row2, Col2) - should see debouncer state changes
        $display("Test 22: Press key 9 (Row2, Col2) - watch debouncer state changes");
        keypad_cols = 4'b1011;
        repeat(200) @(posedge dut.clk);
        
        // Test 23: Release key
        $display("Test 23: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 24: Press key E (Row2, Col3) - should see debouncer state changes
        $display("Test 24: Press key E (Row2, Col3) - watch debouncer state changes");
        keypad_cols = 4'b0111;
        repeat(200) @(posedge dut.clk);
        
        // Test 25: Release key
        $display("Test 25: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 26: Press key A (Row3, Col0) - should see debouncer state changes
        $display("Test 26: Press key A (Row3, Col0) - watch debouncer state changes");
        keypad_cols = 4'b1110;
        repeat(200) @(posedge dut.clk);
        
        // Test 27: Release key
        $display("Test 27: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 28: Press key 0 (Row3, Col1) - should see debouncer state changes
        $display("Test 28: Press key 0 (Row3, Col1) - watch debouncer state changes");
        keypad_cols = 4'b1101;
        repeat(200) @(posedge dut.clk);
        
        // Test 29: Release key
        $display("Test 29: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 30: Press key B (Row3, Col2) - should see debouncer state changes
        $display("Test 30: Press key B (Row3, Col2) - watch debouncer state changes");
        keypad_cols = 4'b1011;
        repeat(200) @(posedge dut.clk);
        
        // Test 31: Release key
        $display("Test 31: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 32: Press key F (Row3, Col3) - should see debouncer state changes
        $display("Test 32: Press key F (Row3, Col3) - watch debouncer state changes");
        keypad_cols = 4'b0111;
        repeat(200) @(posedge dut.clk);
        
        // Test 33: Release key
        $display("Test 33: Release key - watch debouncer go back to IDLE");
        keypad_cols = 4'b1111;
        repeat(100) @(posedge dut.clk);
        
        // Test 34: Rapid key changes - watch state changes
        $display("Test 34: Rapid key changes - watch state changes");
        keypad_cols = 4'b1110; repeat(20) @(posedge dut.clk); // Key 1
        keypad_cols = 4'b1101; repeat(20) @(posedge dut.clk); // Key 2
        keypad_cols = 4'b1011; repeat(20) @(posedge dut.clk); // Key 3
        keypad_cols = 4'b0111; repeat(20) @(posedge dut.clk); // Key C
        keypad_cols = 4'b1110; repeat(20) @(posedge dut.clk); // Key 4
        keypad_cols = 4'b1101; repeat(20) @(posedge dut.clk); // Key 5
        keypad_cols = 4'b1011; repeat(20) @(posedge dut.clk); // Key 6
        keypad_cols = 4'b0111; repeat(20) @(posedge dut.clk); // Key D
        keypad_cols = 4'b1110; repeat(20) @(posedge dut.clk); // Key 7
        keypad_cols = 4'b1101; repeat(20) @(posedge dut.clk); // Key 8
        keypad_cols = 4'b1011; repeat(20) @(posedge dut.clk); // Key 9
        keypad_cols = 4'b0111; repeat(20) @(posedge dut.clk); // Key E
        keypad_cols = 4'b1110; repeat(20) @(posedge dut.clk); // Key A
        keypad_cols = 4'b1101; repeat(20) @(posedge dut.clk); // Key 0
        keypad_cols = 4'b1011; repeat(20) @(posedge dut.clk); // Key B
        keypad_cols = 4'b0111; repeat(20) @(posedge dut.clk); // Key F
        keypad_cols = 4'b1111; repeat(100) @(posedge dut.clk); // Release all
        
        $display("Test complete! Check the VCD file for waveforms.");
        $finish;
    end

endmodule