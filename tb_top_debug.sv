// ============================================================================
// LAB3 TOP MODULE TEST BENCH - SIMPLE INPUT CHANGES
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Simple testbench that changes inputs over time for Questa debugging
// ============================================================================

`timescale 1ns/1ps

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
    // TEST STIMULUS - SIMPLE INPUT CHANGES
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("TOP MODULE TEST - SIMPLE INPUT CHANGES");
        $display("==========================================");
        
        // Initialize
        reset = 0;
        keypad_cols = 4'b1111; // No keys pressed
        
        // Reset sequence
        #100;
        reset = 1;
        #100;
        
        $display("Starting input changes...");
        
        // Test 1: No keys - let system run
        $display("Test 1: No keys pressed - watch system run");
        keypad_cols = 4'b1111;
        #5000; // Let it run for a while
        
        // Test 2: Press key 1 (Row0, Col0)
        $display("Test 2: Press key 1 (Row0, Col0)");
        keypad_cols = 4'b1110;
        #10000; // Hold for a while
        
        // Test 3: Release key
        $display("Test 3: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 4: Press key 2 (Row0, Col1)
        $display("Test 4: Press key 2 (Row0, Col1)");
        keypad_cols = 4'b1101;
        #10000;
        
        // Test 5: Release key
        $display("Test 5: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 6: Press key 3 (Row0, Col2)
        $display("Test 6: Press key 3 (Row0, Col2)");
        keypad_cols = 4'b1011;
        #10000;
        
        // Test 7: Release key
        $display("Test 7: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 8: Press key C (Row0, Col3)
        $display("Test 8: Press key C (Row0, Col3)");
        keypad_cols = 4'b0111;
        #10000;
        
        // Test 9: Release key
        $display("Test 9: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 10: Press key 4 (Row1, Col0)
        $display("Test 10: Press key 4 (Row1, Col0)");
        keypad_cols = 4'b1110;
        #10000;
        
        // Test 11: Release key
        $display("Test 11: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 12: Press key 5 (Row1, Col1)
        $display("Test 12: Press key 5 (Row1, Col1)");
        keypad_cols = 4'b1101;
        #10000;
        
        // Test 13: Release key
        $display("Test 13: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 14: Press key 6 (Row1, Col2)
        $display("Test 14: Press key 6 (Row1, Col2)");
        keypad_cols = 4'b1011;
        #10000;
        
        // Test 15: Release key
        $display("Test 15: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 16: Press key D (Row1, Col3)
        $display("Test 16: Press key D (Row1, Col3)");
        keypad_cols = 4'b0111;
        #10000;
        
        // Test 17: Release key
        $display("Test 17: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 18: Press key 7 (Row2, Col0)
        $display("Test 18: Press key 7 (Row2, Col0)");
        keypad_cols = 4'b1110;
        #10000;
        
        // Test 19: Release key
        $display("Test 19: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 20: Press key 8 (Row2, Col1)
        $display("Test 20: Press key 8 (Row2, Col1)");
        keypad_cols = 4'b1101;
        #10000;
        
        // Test 21: Release key
        $display("Test 21: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 22: Press key 9 (Row2, Col2)
        $display("Test 22: Press key 9 (Row2, Col2)");
        keypad_cols = 4'b1011;
        #10000;
        
        // Test 23: Release key
        $display("Test 23: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 24: Press key E (Row2, Col3)
        $display("Test 24: Press key E (Row2, Col3)");
        keypad_cols = 4'b0111;
        #10000;
        
        // Test 25: Release key
        $display("Test 25: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 26: Press key A (Row3, Col0)
        $display("Test 26: Press key A (Row3, Col0)");
        keypad_cols = 4'b1110;
        #10000;
        
        // Test 27: Release key
        $display("Test 27: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 28: Press key 0 (Row3, Col1)
        $display("Test 28: Press key 0 (Row3, Col1)");
        keypad_cols = 4'b1101;
        #10000;
        
        // Test 29: Release key
        $display("Test 29: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 30: Press key B (Row3, Col2)
        $display("Test 30: Press key B (Row3, Col2)");
        keypad_cols = 4'b1011;
        #10000;
        
        // Test 31: Release key
        $display("Test 31: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 32: Press key F (Row3, Col3)
        $display("Test 32: Press key F (Row3, Col3)");
        keypad_cols = 4'b0111;
        #10000;
        
        // Test 33: Release key
        $display("Test 33: Release key");
        keypad_cols = 4'b1111;
        #5000;
        
        // Test 34: Rapid key changes
        $display("Test 34: Rapid key changes");
        keypad_cols = 4'b1110; #1000; // Key 1
        keypad_cols = 4'b1101; #1000; // Key 2
        keypad_cols = 4'b1011; #1000; // Key 3
        keypad_cols = 4'b0111; #1000; // Key C
        keypad_cols = 4'b1110; #1000; // Key 4
        keypad_cols = 4'b1101; #1000; // Key 5
        keypad_cols = 4'b1011; #1000; // Key 6
        keypad_cols = 4'b0111; #1000; // Key D
        keypad_cols = 4'b1110; #1000; // Key 7
        keypad_cols = 4'b1101; #1000; // Key 8
        keypad_cols = 4'b1011; #1000; // Key 9
        keypad_cols = 4'b0111; #1000; // Key E
        keypad_cols = 4'b1110; #1000; // Key A
        keypad_cols = 4'b1101; #1000; // Key 0
        keypad_cols = 4'b1011; #1000; // Key B
        keypad_cols = 4'b0111; #1000; // Key F
        keypad_cols = 4'b1111; #5000; // Release all
        
        $display("Test complete!");
        $finish;
    end

endmodule