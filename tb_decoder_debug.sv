// ============================================================================
// KEYPAD DECODER TEST BENCH - DEBUG VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for keypad_decoder module showing all key code mappings
// Tests all 16 possible key combinations systematically
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
    
    function string get_row_name(input [3:0] row);
        case (row)
            4'b0001: return "Row0";
            4'b0010: return "Row1";
            4'b0100: return "Row2";
            4'b1000: return "Row3";
            default: return "None";
        endcase
    endfunction
    
    function string get_col_name(input [3:0] col);
        case (col)
            4'b0001: return "Col0";
            4'b0010: return "Col1";
            4'b0100: return "Col2";
            4'b1000: return "Col3";
            default: return "None";
        endcase
    endfunction
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("KEYPAD DECODER DEBUG TEST BENCH");
        $display("==========================================");
        
        // Initialize signals
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        test_count = 0;
        
        $display("\nTesting all 16 key combinations...");
        $display("Format: Row=RowX Col=ColY -> Key=Z (0xZ)");
        $display("----------------------------------------");
        
        // Test all valid key combinations
        for (row_test = 0; row_test < 4; row_test++) begin
            for (col_test = 0; col_test < 4; col_test++) begin
                test_count++;
                
                // Set row and column one-hot signals
                row_onehot = (1 << row_test);
                col_onehot = (1 << col_test);
                
                #(CLK_PERIOD);
                
                // Display result
                $display("Test %0d: Row=%s Col=%s -> Key=%s (0x%h)", 
                         test_count, 
                         get_row_name(row_onehot), 
                         get_col_name(col_onehot),
                         get_key_name(key_code),
                         key_code);
                
                #(CLK_PERIOD);
            end
        end
        
        // Test invalid combinations
        $display("\n--- Testing Invalid Combinations ---");
        
        // No row, no column
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        #(CLK_PERIOD);
        $display("No row, no column -> Key=%s (0x%h)", get_key_name(key_code), key_code);
        
        // Multiple rows, single column
        row_onehot = 4'b0011; // Row 0 and 1
        col_onehot = 4'b0001; // Column 0
        #(CLK_PERIOD);
        $display("Multiple rows, single column -> Key=%s (0x%h)", get_key_name(key_code), key_code);
        
        // Single row, multiple columns
        row_onehot = 4'b0001; // Row 0
        col_onehot = 4'b0011; // Column 0 and 1
        #(CLK_PERIOD);
        $display("Single row, multiple columns -> Key=%s (0x%h)", get_key_name(key_code), key_code);
        
        // Multiple rows, multiple columns
        row_onehot = 4'b0011; // Row 0 and 1
        col_onehot = 4'b0011; // Column 0 and 1
        #(CLK_PERIOD);
        $display("Multiple rows, multiple columns -> Key=%s (0x%h)", get_key_name(key_code), key_code);
        
        // Test specific keypad layout verification
        $display("\n--- Keypad Layout Verification ---");
        $display("Expected layout:");
        $display("Row0: 1 2 3 C");
        $display("Row1: 4 5 6 D");
        $display("Row2: 7 8 9 E");
        $display("Row3: A 0 B F");
        $display("----------------------------------------");
        
        // Test each row systematically
        $display("\nRow 0 (1, 2, 3, C):");
        row_onehot = 4'b0001;
        col_onehot = 4'b0001; #(CLK_PERIOD); $display("  Col0 -> %s", get_key_name(key_code));
        col_onehot = 4'b0010; #(CLK_PERIOD); $display("  Col1 -> %s", get_key_name(key_code));
        col_onehot = 4'b0100; #(CLK_PERIOD); $display("  Col2 -> %s", get_key_name(key_code));
        col_onehot = 4'b1000; #(CLK_PERIOD); $display("  Col3 -> %s", get_key_name(key_code));
        
        $display("\nRow 1 (4, 5, 6, D):");
        row_onehot = 4'b0010;
        col_onehot = 4'b0001; #(CLK_PERIOD); $display("  Col0 -> %s", get_key_name(key_code));
        col_onehot = 4'b0010; #(CLK_PERIOD); $display("  Col1 -> %s", get_key_name(key_code));
        col_onehot = 4'b0100; #(CLK_PERIOD); $display("  Col2 -> %s", get_key_name(key_code));
        col_onehot = 4'b1000; #(CLK_PERIOD); $display("  Col3 -> %s", get_key_name(key_code));
        
        $display("\nRow 2 (7, 8, 9, E):");
        row_onehot = 4'b0100;
        col_onehot = 4'b0001; #(CLK_PERIOD); $display("  Col0 -> %s", get_key_name(key_code));
        col_onehot = 4'b0010; #(CLK_PERIOD); $display("  Col1 -> %s", get_key_name(key_code));
        col_onehot = 4'b0100; #(CLK_PERIOD); $display("  Col2 -> %s", get_key_name(key_code));
        col_onehot = 4'b1000; #(CLK_PERIOD); $display("  Col3 -> %s", get_key_name(key_code));
        
        $display("\nRow 3 (A, 0, B, F):");
        row_onehot = 4'b1000;
        col_onehot = 4'b0001; #(CLK_PERIOD); $display("  Col0 -> %s", get_key_name(key_code));
        col_onehot = 4'b0010; #(CLK_PERIOD); $display("  Col1 -> %s", get_key_name(key_code));
        col_onehot = 4'b0100; #(CLK_PERIOD); $display("  Col2 -> %s", get_key_name(key_code));
        col_onehot = 4'b1000; #(CLK_PERIOD); $display("  Col3 -> %s", get_key_name(key_code));
        
        $display("\n==========================================");
        $display("DECODER TEST COMPLETE");
        $display("==========================================");
        $finish;
    end
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    initial begin
        $monitor("[%0t] ROW_ONEHOT=%b COL_ONEHOT=%b KEY_CODE=%b (0x%h)", 
                 $time, row_onehot, col_onehot, key_code, key_code);
    end
    
    // ========================================================================
    // WAVEFORM DUMP
    // ========================================================================
    initial begin
        $dumpfile("tb_decoder_debug.vcd");
        $dumpvars(0, tb_decoder_debug);
    end

endmodule
