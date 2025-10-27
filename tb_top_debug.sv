// ============================================================================
// LAB3 TOP MODULE TEST BENCH - DEBUG VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for lab3_top module showing complete system integration
// Tests the entire keypad system from key press to display output
// ============================================================================

`timescale 1ns/1ps

module tb_top_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    
    // Top module inputs
    logic        reset;         // Active-low reset signal
    logic [3:0]  keypad_cols;   // Keypad column inputs (FPGA reads)
    
    // Top module outputs
    logic [3:0]  keypad_rows;   // Keypad row outputs (FPGA drives)
    logic [6:0]  seg;           // Seven-segment display signals
    logic        select0;       // Display 0 power control
    logic        select1;       // Display 1 power control
    
    // Test control
    integer      test_count;
    integer      cycle_count;
    
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
    // CLOCK GENERATION
    // ========================================================================
    // Note: lab3_top uses HSOSC internally, so we don't need to generate clock
    
    // ========================================================================
    // DISPLAY TASKS
    // ========================================================================
    task display_system_state;
        $display("[%0t] SYSTEM: Rows=%b Cols=%b Seg=%b Sel0=%b Sel1=%b", 
                 $time, keypad_rows, keypad_cols, seg, select0, select1);
    endtask
    
    task display_keypad_state;
        $display("[%0t] KEYPAD: Row_idx=%b Col_sync=%b Key_det=%b Key_val=%b Deb_key=0x%h", 
                 $time, dut.row_idx, dut.col_sync, dut.key_detected, dut.key_valid, dut.debounced_key);
    endtask
    
    task display_display_state;
        $display("[%0t] DISPLAY: Digit_L=0x%h Digit_R=0x%h", 
                 $time, dut.digit_left, dut.digit_right);
    endtask
    
    function string get_seg_display(input [6:0] seg_val);
        case (seg_val)
            7'b1000000: return "0";
            7'b1111001: return "1";
            7'b0100100: return "2";
            7'b0110000: return "3";
            7'b0011001: return "4";
            7'b0010010: return "5";
            7'b0000010: return "6";
            7'b1111000: return "7";
            7'b0000000: return "8";
            7'b0010000: return "9";
            7'b0001000: return "A";
            7'b0000011: return "b";
            7'b1000110: return "C";
            7'b0100001: return "d";
            7'b0000110: return "E";
            7'b0001110: return "F";
            default: return "?";
        endcase
    endfunction
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("LAB3 TOP MODULE DEBUG TEST BENCH");
        $display("==========================================");
        
        // Initialize signals
        reset = 0;
        keypad_cols = 4'b1111; // No keys pressed initially
        test_count = 0;
        cycle_count = 0;
        
        // Reset sequence
        $display("\n[%0t] Applying reset...", $time);
        #(CLK_PERIOD * 10);
        reset = 1;
        #(CLK_PERIOD * 5);
        
        $display("\n[%0t] Reset released. Starting system test...", $time);
        
        // Test 1: Initial state (no keys pressed)
        $display("\n--- TEST 1: Initial State (No Keys) ---");
        keypad_cols = 4'b1111;
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            #(CLK_PERIOD);
            display_system_state();
            display_keypad_state();
            display_display_state();
        end
        
        // Test 2: Key '1' pressed (Row 0, Col 0)
        $display("\n--- TEST 2: Key '1' Pressed (Row0, Col0) ---");
        keypad_cols = 4'b1110; // Column 0 active
        $display("[%0t] Key '1' pressed...", $time);
        
        // Wait for debounce and processing
        for (cycle_count = 0; cycle_count < 200; cycle_count++) begin
            #(CLK_PERIOD);
            if (cycle_count % 50 == 0) begin
                display_system_state();
                display_keypad_state();
                display_display_state();
            end
            
            if (dut.key_valid && dut.debounced_key == 4'h1) begin
                $display("[%0t] *** Key '1' processed! ***", $time);
                cycle_count = 200; // Exit loop
            end
        end
        
        // Release key
        keypad_cols = 4'b1111;
        $display("[%0t] Key '1' released", $time);
        #(CLK_PERIOD * 10);
        
        // Test 3: Key '5' pressed (Row 1, Col 1)
        $display("\n--- TEST 3: Key '5' Pressed (Row1, Col1) ---");
        keypad_cols = 4'b1101; // Column 1 active
        $display("[%0t] Key '5' pressed...", $time);
        
        // Wait for debounce and processing
        for (cycle_count = 0; cycle_count < 200; cycle_count++) begin
            #(CLK_PERIOD);
            if (cycle_count % 50 == 0) begin
                display_system_state();
                display_keypad_state();
                display_display_state();
            end
            
            if (dut.key_valid && dut.debounced_key == 4'h5) begin
                $display("[%0t] *** Key '5' processed! ***", $time);
                cycle_count = 200; // Exit loop
            end
        end
        
        // Release key
        keypad_cols = 4'b1111;
        $display("[%0t] Key '5' released", $time);
        #(CLK_PERIOD * 10);
        
        // Test 4: Key 'A' pressed (Row 3, Col 0)
        $display("\n--- TEST 4: Key 'A' Pressed (Row3, Col0) ---");
        keypad_cols = 4'b1110; // Column 0 active
        $display("[%0t] Key 'A' pressed...", $time);
        
        // Wait for debounce and processing
        for (cycle_count = 0; cycle_count < 200; cycle_count++) begin
            #(CLK_PERIOD);
            if (cycle_count % 50 == 0) begin
                display_system_state();
                display_keypad_state();
                display_display_state();
            end
            
            if (dut.key_valid && dut.debounced_key == 4'hA) begin
                $display("[%0t] *** Key 'A' processed! ***", $time);
                cycle_count = 200; // Exit loop
            end
        end
        
        // Release key
        keypad_cols = 4'b1111;
        $display("[%0t] Key 'A' released", $time);
        #(CLK_PERIOD * 10);
        
        // Test 5: Key 'F' pressed (Row 3, Col 3)
        $display("\n--- TEST 5: Key 'F' Pressed (Row3, Col3) ---");
        keypad_cols = 4'b0111; // Column 3 active
        $display("[%0t] Key 'F' pressed...", $time);
        
        // Wait for debounce and processing
        for (cycle_count = 0; cycle_count < 200; cycle_count++) begin
            #(CLK_PERIOD);
            if (cycle_count % 50 == 0) begin
                display_system_state();
                display_keypad_state();
                display_display_state();
            end
            
            if (dut.key_valid && dut.debounced_key == 4'hF) begin
                $display("[%0t] *** Key 'F' processed! ***", $time);
                cycle_count = 200; // Exit loop
            end
        end
        
        // Release key
        keypad_cols = 4'b1111;
        $display("[%0t] Key 'F' released", $time);
        #(CLK_PERIOD * 10);
        
        // Test 6: Multiple key presses sequence
        $display("\n--- TEST 6: Multiple Key Presses Sequence ---");
        $display("[%0t] Testing sequence: 1, 2, 3, 4", $time);
        
        // Key 1
        keypad_cols = 4'b1110; // Column 0
        #(CLK_PERIOD * 200);
        keypad_cols = 4'b1111;
        #(CLK_PERIOD * 50);
        
        // Key 2
        keypad_cols = 4'b1101; // Column 1
        #(CLK_PERIOD * 200);
        keypad_cols = 4'b1111;
        #(CLK_PERIOD * 50);
        
        // Key 3
        keypad_cols = 4'b1011; // Column 2
        #(CLK_PERIOD * 200);
        keypad_cols = 4'b1111;
        #(CLK_PERIOD * 50);
        
        // Key 4
        keypad_cols = 4'b0111; // Column 3
        #(CLK_PERIOD * 200);
        keypad_cols = 4'b1111;
        #(CLK_PERIOD * 50);
        
        display_system_state();
        display_keypad_state();
        display_display_state();
        
        // Test 7: Display verification
        $display("\n--- TEST 7: Display Verification ---");
        $display("[%0t] Final display state:", $time);
        $display("  Left digit: 0x%h (%s)", dut.digit_left, get_seg_display(seg));
        $display("  Right digit: 0x%h", dut.digit_right);
        $display("  Seven-segment: %b (%s)", seg, get_seg_display(seg));
        $display("  Select signals: Sel0=%b, Sel1=%b", select0, select1);
        
        $display("\n==========================================");
        $display("TOP MODULE TEST COMPLETE");
        $display("==========================================");
        $finish;
    end
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    initial begin
        $monitor("[%0t] RST=%b ROWS=%b COLS=%b SEG=%b SEL0=%b SEL1=%b", 
                 $time, reset, keypad_rows, keypad_cols, seg, select0, select1);
    end
    
    // ========================================================================
    // WAVEFORM DUMP
    // ========================================================================
    initial begin
        $dumpfile("tb_top_debug.vcd");
        $dumpvars(0, tb_top_debug);
    end

endmodule
