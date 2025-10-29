// ============================================================================
// KEYPAD DECODER TEST BENCH - QUESTA COMPATIBLE STATE WALKTHROUGH
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench that walks through decoder states over time with proper delays
// Shows actual key decoding as inputs change over time for Questa simulation
// ============================================================================

`timescale 1ns/1ps

module tb_decoder_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 10; // 10ns period for better visibility in Questa
    
    // Clock
    logic        clk;
    
    // Decoder inputs
    logic [3:0]  row_onehot;
    logic [3:0]  col_onehot;
    
    // Decoder outputs
    logic [3:0]  key_code;
    
    // Test control
    integer      cycle_count;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    keypad_decoder dut (
        .row_onehot(row_onehot),
        .col_onehot(col_onehot),
        .key_code(key_code)
    );
    
    // ========================================================================
    // CLOCK GENERATION
    // ========================================================================
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // ========================================================================
    // MONITOR FOR CONTINUOUS TRACKING
    // ========================================================================
    // Note: $monitor with complex expressions not supported in iverilog
    // Using display tasks instead for better compatibility
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("DECODER STATE WALKTHROUGH TEST - QUESTA VERSION");
        $display("==========================================");
        $display("This test will walk through all 16 key combinations over time");
        $display("Watch KEY_CODE change as ROW_ONEHOT and COL_ONEHOT change");
        $display("==========================================");
        
        // Initialize signals
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        cycle_count = 0;
        
        // Test 1: Row 0 keys (1, 2, 3, C)
        $display("\n--- TEST 1: ROW 0 KEYS (1, 2, 3, C) ---");
        $display("Testing keys: 1, 2, 3, C");
        
        // Key '1' (Row0, Col0)
        $display("Key '1' (Row0, Col0)");
        row_onehot = 4'b0001;
        col_onehot = 4'b0001;
        repeat(5) @(posedge clk);
        
        // Key '2' (Row0, Col1)
        $display("Key '2' (Row0, Col1)");
        row_onehot = 4'b0001;
        col_onehot = 4'b0010;
        repeat(5) @(posedge clk);
        
        // Key '3' (Row0, Col2)
        $display("Key '3' (Row0, Col2)");
        row_onehot = 4'b0001;
        col_onehot = 4'b0100;
        repeat(5) @(posedge clk);
        
        // Key 'C' (Row0, Col3)
        $display("Key 'C' (Row0, Col3)");
        row_onehot = 4'b0001;
        col_onehot = 4'b1000;
        repeat(5) @(posedge clk);
        
        // Test 2: Row 1 keys (4, 5, 6, D)
        $display("\n--- TEST 2: ROW 1 KEYS (4, 5, 6, D) ---");
        $display("Testing keys: 4, 5, 6, D");
        
        // Key '4' (Row1, Col0)
        $display("Key '4' (Row1, Col0)");
        row_onehot = 4'b0010;
        col_onehot = 4'b0001;
        repeat(5) @(posedge clk);
        
        // Key '5' (Row1, Col1)
        $display("Key '5' (Row1, Col1)");
        row_onehot = 4'b0010;
        col_onehot = 4'b0010;
        repeat(5) @(posedge clk);
        
        // Key '6' (Row1, Col2)
        $display("Key '6' (Row1, Col2)");
        row_onehot = 4'b0010;
        col_onehot = 4'b0100;
        repeat(5) @(posedge clk);
        
        // Key 'D' (Row1, Col3)
        $display("Key 'D' (Row1, Col3)");
        row_onehot = 4'b0010;
        col_onehot = 4'b1000;
        repeat(5) @(posedge clk);
        
        // Test 3: Row 2 keys (7, 8, 9, E)
        $display("\n--- TEST 3: ROW 2 KEYS (7, 8, 9, E) ---");
        $display("Testing keys: 7, 8, 9, E");
        
        // Key '7' (Row2, Col0)
        $display("Key '7' (Row2, Col0)");
        row_onehot = 4'b0100;
        col_onehot = 4'b0001;
        repeat(5) @(posedge clk);
        
        // Key '8' (Row2, Col1)
        $display("Key '8' (Row2, Col1)");
        row_onehot = 4'b0100;
        col_onehot = 4'b0010;
        repeat(5) @(posedge clk);
        
        // Key '9' (Row2, Col2)
        $display("Key '9' (Row2, Col2)");
        row_onehot = 4'b0100;
        col_onehot = 4'b0100;
        repeat(5) @(posedge clk);
        
        // Key 'E' (Row2, Col3)
        $display("Key 'E' (Row2, Col3)");
        row_onehot = 4'b0100;
        col_onehot = 4'b1000;
        repeat(5) @(posedge clk);
        
        // Test 4: Row 3 keys (A, 0, B, F)
        $display("\n--- TEST 4: ROW 3 KEYS (A, 0, B, F) ---");
        $display("Testing keys: A, 0, B, F");
        
        // Key 'A' (Row3, Col0)
        $display("Key 'A' (Row3, Col0)");
        row_onehot = 4'b1000;
        col_onehot = 4'b0001;
        repeat(5) @(posedge clk);
        
        // Key '0' (Row3, Col1)
        $display("Key '0' (Row3, Col1)");
        row_onehot = 4'b1000;
        col_onehot = 4'b0010;
        repeat(5) @(posedge clk);
        
        // Key 'B' (Row3, Col2)
        $display("Key 'B' (Row3, Col2)");
        row_onehot = 4'b1000;
        col_onehot = 4'b0100;
        repeat(5) @(posedge clk);
        
        // Key 'F' (Row3, Col3)
        $display("Key 'F' (Row3, Col3)");
        row_onehot = 4'b1000;
        col_onehot = 4'b1000;
        repeat(5) @(posedge clk);
        
        // Test 5: Invalid combinations
        $display("\n--- TEST 5: INVALID COMBINATIONS ---");
        $display("Testing invalid combinations - should result in KEY_CODE=0x0");
        
        // No input
        $display("No input (all zeros)");
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        repeat(5) @(posedge clk);
        
        // Multiple rows
        $display("Multiple rows (invalid)");
        row_onehot = 4'b0011;
        col_onehot = 4'b0001;
        repeat(5) @(posedge clk);
        
        // Multiple columns
        $display("Multiple columns (invalid)");
        row_onehot = 4'b0001;
        col_onehot = 4'b0011;
        repeat(5) @(posedge clk);
        
        // Test 6: Rapid key changes
        $display("\n--- TEST 6: RAPID KEY CHANGES ---");
        $display("Testing rapid key changes to show decoder responsiveness");
        
        // Rapid sequence: 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F, 0
        $display("Rapid sequence: 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F, 0");
        
        // Row 0 keys
        row_onehot = 4'b0001; col_onehot = 4'b0001; @(posedge clk); // 1
        row_onehot = 4'b0001; col_onehot = 4'b0010; @(posedge clk); // 2
        row_onehot = 4'b0001; col_onehot = 4'b0100; @(posedge clk); // 3
        row_onehot = 4'b0001; col_onehot = 4'b1000; @(posedge clk); // C
        
        // Row 1 keys
        row_onehot = 4'b0010; col_onehot = 4'b0001; @(posedge clk); // 4
        row_onehot = 4'b0010; col_onehot = 4'b0010; @(posedge clk); // 5
        row_onehot = 4'b0010; col_onehot = 4'b0100; @(posedge clk); // 6
        row_onehot = 4'b0010; col_onehot = 4'b1000; @(posedge clk); // D
        
        // Row 2 keys
        row_onehot = 4'b0100; col_onehot = 4'b0001; @(posedge clk); // 7
        row_onehot = 4'b0100; col_onehot = 4'b0010; @(posedge clk); // 8
        row_onehot = 4'b0100; col_onehot = 4'b0100; @(posedge clk); // 9
        row_onehot = 4'b0100; col_onehot = 4'b1000; @(posedge clk); // E
        
        // Row 3 keys
        row_onehot = 4'b1000; col_onehot = 4'b0001; @(posedge clk); // A
        row_onehot = 4'b1000; col_onehot = 4'b0010; @(posedge clk); // 0
        row_onehot = 4'b1000; col_onehot = 4'b0100; @(posedge clk); // B
        row_onehot = 4'b1000; col_onehot = 4'b1000; @(posedge clk); // F
        
        // Final state
        $display("\n--- FINAL STATE ---");
        $display("Returning to no input state");
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        repeat(5) @(posedge clk);
        
        $display("\n==========================================");
        $display("DECODER STATE WALKTHROUGH COMPLETE");
        $display("==========================================");
        $finish;
    end

endmodule