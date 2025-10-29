// ============================================================================
// KEYPAD DECODER TEST BENCH - SIMPLIFIED VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Simple test bench for keypad_decoder module - walks through all 16 keys
// ============================================================================

`timescale 1ns/1ps

module tb_decoder_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    
    // Decoder inputs
    logic [3:0]  row_onehot;
    logic [3:0]  col_onehot;
    
    // Decoder outputs
    logic [3:0]  key_code;
    
    // Test control
    integer      test_count;
    integer      row_test, col_test;
    
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
    logic clk;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // ========================================================================
    // KEY MAPPING REFERENCE
    // ========================================================================
    function string get_key_name(input [3:0] key);
        case (key)
            4'h0: return "0";
            4'h1: return "1";
            4'h2: return "2";
            4'h3: return "3";
            4'h4: return "4";
            4'h5: return "5";
            4'h6: return "6";
            4'h7: return "7";
            4'h8: return "8";
            4'h9: return "9";
            4'hA: return "A";
            4'hB: return "B";
            4'hC: return "C";
            4'hD: return "D";
            4'hE: return "E";
            4'hF: return "F";
            default: return "?";
        endcase
    endfunction
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("KEYPAD DECODER TEST - ALL 16 KEYS");
        $display("==========================================");
        
        // Initialize signals
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        test_count = 0;
        
        $display("\nTesting all 16 key combinations:");
        $display("Row | Col | Key | Hex");
        $display("----|-----|-----|----");
        
        // Test all valid key combinations
        for (row_test = 0; row_test < 4; row_test++) begin
            for (col_test = 0; col_test < 4; col_test++) begin
                test_count++;
                
                // Set row and column one-hot signals
                row_onehot = (1 << row_test);
                col_onehot = (1 << col_test);
                
                #(CLK_PERIOD);
                
                // Display result
                $display(" %0d  |  %0d  |  %s  | 0x%h", 
                         row_test, col_test, get_key_name(key_code), key_code);
                
                #(CLK_PERIOD);
            end
        end
        
        // Test invalid combinations
        $display("\n--- Invalid Combinations ---");
        
        // No input
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        #(CLK_PERIOD);
        $display("No input -> Key=%s (0x%h)", get_key_name(key_code), key_code);
        
        // Multiple rows
        row_onehot = 4'b0011;
        col_onehot = 4'b0001;
        #(CLK_PERIOD);
        $display("Multiple rows -> Key=%s (0x%h)", get_key_name(key_code), key_code);
        
        // Multiple columns
        row_onehot = 4'b0001;
        col_onehot = 4'b0011;
        #(CLK_PERIOD);
        $display("Multiple columns -> Key=%s (0x%h)", get_key_name(key_code), key_code);
        
        $display("\n==========================================");
        $display("DECODER TEST COMPLETE - %0d tests passed", test_count);
        $display("==========================================");
        $finish;
    end

endmodule