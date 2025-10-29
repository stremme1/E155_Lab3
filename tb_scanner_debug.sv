// ============================================================================
// KEYPAD SCANNER TEST BENCH - SIMPLE INPUT CHANGES
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Simple testbench that changes inputs over time for Questa debugging
// ============================================================================

`timescale 1ns/1ps

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
    // CLOCK GENERATION
    // ========================================================================
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // 10MHz clock
    end
    
    // ========================================================================
    // TEST STIMULUS - SIMPLE INPUT CHANGES
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("SCANNER TEST - SIMPLE INPUT CHANGES");
        $display("==========================================");
        
        // Initialize
        rst_n = 0;
        col = 4'b1111; // No keys pressed
        
        // Reset
        #100;
        rst_n = 1;
        #100;
        
        $display("Starting input changes...");
        
        // Test 1: No keys - let scanner cycle
        $display("Test 1: No keys pressed - watch scanner cycle through states");
        col = 4'b1111;
        #2000; // Let it run for a while
        
        // Test 2: Press key 1 (Row0, Col0)
        $display("Test 2: Press key 1 (Row0, Col0)");
        col = 4'b1110;
        #2000;
        
        // Test 3: Release key
        $display("Test 3: Release key");
        col = 4'b1111;
        #2000;
        
        // Test 4: Press key 4 (Row1, Col0)
        $display("Test 4: Press key 4 (Row1, Col0)");
        col = 4'b1101;
        #2000;
        
        // Test 5: Release key
        $display("Test 5: Release key");
        col = 4'b1111;
        #2000;
        
        // Test 6: Press key 7 (Row2, Col0)
        $display("Test 6: Press key 7 (Row2, Col0)");
        col = 4'b1011;
        #2000;
        
        // Test 7: Release key
        $display("Test 7: Release key");
        col = 4'b1111;
        #2000;
        
        // Test 8: Press key A (Row3, Col0)
        $display("Test 8: Press key A (Row3, Col0)");
        col = 4'b0111;
        #2000;
        
        // Test 9: Release key
        $display("Test 9: Release key");
        col = 4'b1111;
        #2000;
        
        // Test 10: Rapid key changes
        $display("Test 10: Rapid key changes");
        col = 4'b1110; // Key 1
        #100;
        col = 4'b1101; // Key 2
        #100;
        col = 4'b1011; // Key 3
        #100;
        col = 4'b0111; // Key C
        #100;
        col = 4'b1111; // Release all
        #1000;
        
        $display("Test complete!");
        $finish;
    end

endmodule