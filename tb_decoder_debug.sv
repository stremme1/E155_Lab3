// ============================================================================
// KEYPAD DECODER TEST BENCH - STATE WALKTHROUGH VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench that walks through decoder states over time with clock changes
// Shows actual key decoding as inputs change over time
// ============================================================================

`timescale 1ns/1ps

module tb_decoder_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    
    // Clock
    logic        clk;
    
    // Decoder inputs
    logic [3:0]  row_onehot;
    logic [3:0]  col_onehot;
    
    // Decoder outputs
    logic [3:0]  key_code;
    
    // Test control
    integer      cycle_count;
    integer      key_index;
    
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
    // DISPLAY FUNCTIONS
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
    
    task display_state();
        $display("[%0t] CLK=%b ROW=%s COL=%s -> KEY=%s (0x%h)", 
                 $time, clk, get_row_name(row_onehot), get_col_name(col_onehot), 
                 get_key_name(key_code), key_code);
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("DECODER STATE WALKTHROUGH TEST");
        $display("==========================================");
        
        // Initialize signals
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        cycle_count = 0;
        
        $display("\n[%0t] Starting test - will show key decoding over time", $time);
        $display("Format: [TIME] CLK ROW COL -> KEY (HEX)");
        $display("----------------------------------------------------");
        
        // Test 1: No input
        $display("\n--- TEST 1: NO INPUT ---");
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 2: Row 0 keys (1, 2, 3, C)
        $display("\n--- TEST 2: ROW 0 KEYS (1, 2, 3, C) ---");
        row_onehot = 4'b0001; // Row 0 active
        
        // Key 1 (Col 0)
        $display("[%0t] Pressing key '1' (Row0, Col0)", $time);
        col_onehot = 4'b0001;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key 2 (Col 1)
        $display("[%0t] Pressing key '2' (Row0, Col1)", $time);
        col_onehot = 4'b0010;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key 3 (Col 2)
        $display("[%0t] Pressing key '3' (Row0, Col2)", $time);
        col_onehot = 4'b0100;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key C (Col 3)
        $display("[%0t] Pressing key 'C' (Row0, Col3)", $time);
        col_onehot = 4'b1000;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 3: Row 1 keys (4, 5, 6, D)
        $display("\n--- TEST 3: ROW 1 KEYS (4, 5, 6, D) ---");
        row_onehot = 4'b0010; // Row 1 active
        
        // Key 4 (Col 0)
        $display("[%0t] Pressing key '4' (Row1, Col0)", $time);
        col_onehot = 4'b0001;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key 5 (Col 1)
        $display("[%0t] Pressing key '5' (Row1, Col1)", $time);
        col_onehot = 4'b0010;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key 6 (Col 2)
        $display("[%0t] Pressing key '6' (Row1, Col2)", $time);
        col_onehot = 4'b0100;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key D (Col 3)
        $display("[%0t] Pressing key 'D' (Row1, Col3)", $time);
        col_onehot = 4'b1000;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 4: Row 2 keys (7, 8, 9, E)
        $display("\n--- TEST 4: ROW 2 KEYS (7, 8, 9, E) ---");
        row_onehot = 4'b0100; // Row 2 active
        
        // Key 7 (Col 0)
        $display("[%0t] Pressing key '7' (Row2, Col0)", $time);
        col_onehot = 4'b0001;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key 8 (Col 1)
        $display("[%0t] Pressing key '8' (Row2, Col1)", $time);
        col_onehot = 4'b0010;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key 9 (Col 2)
        $display("[%0t] Pressing key '9' (Row2, Col2)", $time);
        col_onehot = 4'b0100;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key E (Col 3)
        $display("[%0t] Pressing key 'E' (Row2, Col3)", $time);
        col_onehot = 4'b1000;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 5: Row 3 keys (A, 0, B, F)
        $display("\n--- TEST 5: ROW 3 KEYS (A, 0, B, F) ---");
        row_onehot = 4'b1000; // Row 3 active
        
        // Key A (Col 0)
        $display("[%0t] Pressing key 'A' (Row3, Col0)", $time);
        col_onehot = 4'b0001;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key 0 (Col 1)
        $display("[%0t] Pressing key '0' (Row3, Col1)", $time);
        col_onehot = 4'b0010;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key B (Col 2)
        $display("[%0t] Pressing key 'B' (Row3, Col2)", $time);
        col_onehot = 4'b0100;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key F (Col 3)
        $display("[%0t] Pressing key 'F' (Row3, Col3)", $time);
        col_onehot = 4'b1000;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 6: Rapid key sequence
        $display("\n--- TEST 6: RAPID KEY SEQUENCE ---");
        $display("[%0t] Testing rapid key changes", $time);
        
        // Quick sequence: 1, 5, 9, F
        row_onehot = 4'b0001; col_onehot = 4'b0001; @(posedge clk); display_state(); // 1
        row_onehot = 4'b0010; col_onehot = 4'b0010; @(posedge clk); display_state(); // 5
        row_onehot = 4'b0100; col_onehot = 4'b0100; @(posedge clk); display_state(); // 9
        row_onehot = 4'b1000; col_onehot = 4'b1000; @(posedge clk); display_state(); // F
        
        // Test 7: Invalid combinations
        $display("\n--- TEST 7: INVALID COMBINATIONS ---");
        
        // Multiple rows
        $display("[%0t] Multiple rows, single column", $time);
        row_onehot = 4'b0011; col_onehot = 4'b0001;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Multiple columns
        $display("[%0t] Single row, multiple columns", $time);
        row_onehot = 4'b0001; col_onehot = 4'b0011;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // No input
        $display("[%0t] No input", $time);
        row_onehot = 4'b0000; col_onehot = 4'b0000;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 8: Complete keypad walkthrough
        $display("\n--- TEST 8: COMPLETE KEYPAD WALKTHROUGH ---");
        $display("[%0t] Walking through all 16 keys systematically", $time);
        
        // Walk through all keys in order
        for (key_index = 0; key_index < 16; key_index++) begin
            row_onehot = (1 << (key_index / 4));
            col_onehot = (1 << (key_index % 4));
            
            @(posedge clk);
            display_state();
            @(posedge clk);
        end
        
        $display("\n==========================================");
        $display("DECODER STATE WALKTHROUGH COMPLETE");
        $display("==========================================");
        $finish;
    end

endmodule