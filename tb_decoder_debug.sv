// ============================================================================
// KEYPAD DECODER TEST BENCH - SIMPLE INPUT CHANGES
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Simple testbench that changes inputs over time for Questa debugging
// ============================================================================

`timescale 1ns/1ps

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
        $display("DECODER TEST - SIMPLE INPUT CHANGES");
        $display("==========================================");
        
        // Initialize
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        
        $display("Starting input changes...");
        
        // Test 1: No input
        $display("Test 1: No input");
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        #1000;
        
        // Test 2: Row 0 keys
        $display("Test 2: Row 0 keys");
        row_onehot = 4'b0001; col_onehot = 4'b0001; #500; // Key 1
        row_onehot = 4'b0001; col_onehot = 4'b0010; #500; // Key 2
        row_onehot = 4'b0001; col_onehot = 4'b0100; #500; // Key 3
        row_onehot = 4'b0001; col_onehot = 4'b1000; #500; // Key C
        
        // Test 3: Row 1 keys
        $display("Test 3: Row 1 keys");
        row_onehot = 4'b0010; col_onehot = 4'b0001; #500; // Key 4
        row_onehot = 4'b0010; col_onehot = 4'b0010; #500; // Key 5
        row_onehot = 4'b0010; col_onehot = 4'b0100; #500; // Key 6
        row_onehot = 4'b0010; col_onehot = 4'b1000; #500; // Key D
        
        // Test 4: Row 2 keys
        $display("Test 4: Row 2 keys");
        row_onehot = 4'b0100; col_onehot = 4'b0001; #500; // Key 7
        row_onehot = 4'b0100; col_onehot = 4'b0010; #500; // Key 8
        row_onehot = 4'b0100; col_onehot = 4'b0100; #500; // Key 9
        row_onehot = 4'b0100; col_onehot = 4'b1000; #500; // Key E
        
        // Test 5: Row 3 keys
        $display("Test 5: Row 3 keys");
        row_onehot = 4'b1000; col_onehot = 4'b0001; #500; // Key A
        row_onehot = 4'b1000; col_onehot = 4'b0010; #500; // Key 0
        row_onehot = 4'b1000; col_onehot = 4'b0100; #500; // Key B
        row_onehot = 4'b1000; col_onehot = 4'b1000; #500; // Key F
        
        // Test 6: Invalid combinations
        $display("Test 6: Invalid combinations");
        row_onehot = 4'b0000; col_onehot = 4'b0000; #500; // No input
        row_onehot = 4'b0011; col_onehot = 4'b0001; #500; // Multiple rows
        row_onehot = 4'b0001; col_onehot = 4'b0011; #500; // Multiple columns
        
        // Test 7: Rapid changes
        $display("Test 7: Rapid changes");
        row_onehot = 4'b0001; col_onehot = 4'b0001; #100; // Key 1
        row_onehot = 4'b0001; col_onehot = 4'b0010; #100; // Key 2
        row_onehot = 4'b0001; col_onehot = 4'b0100; #100; // Key 3
        row_onehot = 4'b0001; col_onehot = 4'b1000; #100; // Key C
        row_onehot = 4'b0010; col_onehot = 4'b0001; #100; // Key 4
        row_onehot = 4'b0010; col_onehot = 4'b0010; #100; // Key 5
        row_onehot = 4'b0010; col_onehot = 4'b0100; #100; // Key 6
        row_onehot = 4'b0010; col_onehot = 4'b1000; #100; // Key D
        row_onehot = 4'b0100; col_onehot = 4'b0001; #100; // Key 7
        row_onehot = 4'b0100; col_onehot = 4'b0010; #100; // Key 8
        row_onehot = 4'b0100; col_onehot = 4'b0100; #100; // Key 9
        row_onehot = 4'b0100; col_onehot = 4'b1000; #100; // Key E
        row_onehot = 4'b1000; col_onehot = 4'b0001; #100; // Key A
        row_onehot = 4'b1000; col_onehot = 4'b0010; #100; // Key 0
        row_onehot = 4'b1000; col_onehot = 4'b0100; #100; // Key B
        row_onehot = 4'b1000; col_onehot = 4'b1000; #100; // Key F
        
        // Test 8: Final state
        $display("Test 8: Final state");
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        #1000;
        
        $display("Test complete!");
        $finish;
    end

endmodule