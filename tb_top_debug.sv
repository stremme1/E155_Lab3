// ============================================================================
// LAB3 TOP MODULE TEST BENCH - QUESTA COMPATIBLE VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for lab3_top module with slower clock for Questa visibility
// Tests complete keypad system from key press to display output with all states
// ============================================================================

`timescale 1ns/1ps

module tb_top_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 100; // 100ns period (10MHz) for better Questa visibility
    parameter DEBOUNCE_TIME = 2000; // 2000 cycles for debounce (200us @ 10MHz)
    
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
    integer      timeout_count;
    
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
    // Note: lab3_top uses internal clock generation, but we'll override it for simulation
    
    // ========================================================================
    // DISPLAY TASKS
    // ========================================================================
    task display_system_state;
        $display("[%0t] SYSTEM: Rows=%b Cols=%b Seg=%b Sel0=%b Sel1=%b", 
                 $time, keypad_rows, keypad_cols, seg, select0, select1);
    endtask
    
    task display_keypad_state;
        $display("[%0t] KEYPAD: Row_idx=%b Col_sync=%b Key_det=%b Key_val=%b Deb_key=0x%h Scan_stop=%b", 
                 $time, dut.row_idx, dut.col_sync, dut.key_detected, dut.key_valid, dut.debounced_key, dut.scan_stop);
    endtask
    
    task display_display_state;
        $display("[%0t] DISPLAY: Digit_L=0x%h Digit_R=0x%h", 
                 $time, dut.digit_left, dut.digit_right);
    endtask
    
    task display_scanner_state;
        case (dut.scanner_inst.current_state)
            dut.scanner_inst.SCAN_ROW0: $display("[%0t] SCANNER: State = SCAN_ROW0, Timeout = %b", 
                                                $time, dut.scanner_inst.scan_timeout);
            dut.scanner_inst.SCAN_ROW1: $display("[%0t] SCANNER: State = SCAN_ROW1, Timeout = %b", 
                                                $time, dut.scanner_inst.scan_timeout);
            dut.scanner_inst.SCAN_ROW2: $display("[%0t] SCANNER: State = SCAN_ROW2, Timeout = %b", 
                                                $time, dut.scanner_inst.scan_timeout);
            dut.scanner_inst.SCAN_ROW3: $display("[%0t] SCANNER: State = SCAN_ROW3, Timeout = %b", 
                                                $time, dut.scanner_inst.scan_timeout);
            default: $display("[%0t] SCANNER: State = UNKNOWN", $time);
        endcase
    endtask
    
    task display_debouncer_state;
        case (dut.debouncer_inst.current_state)
            dut.debouncer_inst.IDLE: $display("[%0t] DEBOUNCER: State = IDLE, Count = %0d", 
                                             $time, dut.debouncer_inst.debounce_cnt);
            dut.debouncer_inst.DEBOUNCING: $display("[%0t] DEBOUNCER: State = DEBOUNCING, Count = %0d/%0d", 
                                                   $time, dut.debouncer_inst.debounce_cnt, DEBOUNCE_TIME);
            dut.debouncer_inst.KEY_HELD: $display("[%0t] DEBOUNCER: State = KEY_HELD", $time);
            default: $display("[%0t] DEBOUNCER: State = UNKNOWN", $time);
        endcase
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
    
    task press_key;
        input [3:0] col_val;
        input string key_name;
        
        $display("\n[%0t] Pressing %s (Col=%b)...", $time, key_name, col_val);
        keypad_cols = col_val;
    endtask
    
    task release_key;
        $display("[%0t] Releasing key...", $time);
        keypad_cols = 4'b1111;
    endtask
    
    task wait_for_key_processing;
        input [3:0] expected_key;
        input string key_name;
        
        timeout_count = 0;
        $display("[%0t] Waiting for %s to be processed...", $time, key_name);
        
        while (dut.key_valid != 1'b1 && timeout_count < 1000) begin
            @(posedge dut.clk);
            if (timeout_count % 100 == 0) begin
                display_system_state();
                display_keypad_state();
                display_display_state();
                display_scanner_state();
                display_debouncer_state();
            end
            timeout_count = timeout_count + 1;
        end
        
        if (dut.key_valid && dut.debounced_key == expected_key) begin
            $display("[%0t] *** %s PROCESSED! Key_valid = %b, Debounced_key = 0x%h ***", 
                     $time, key_name, dut.key_valid, dut.debounced_key);
        end else if (timeout_count >= 1000) begin
            $display("[%0t] *** TIMEOUT! %s was not processed within expected time ***", $time, key_name);
        end else begin
            $display("[%0t] *** UNEXPECTED! Expected 0x%h, got 0x%h ***", 
                     $time, expected_key, dut.debounced_key);
        end
    endtask
    
    task test_key_sequence;
        input [3:0] col_val;
        input [3:0] expected_key;
        input string key_name;
        
        press_key(col_val, key_name);
        wait_for_key_processing(expected_key, key_name);
        release_key();
        
        // Wait for system to settle
        for (cycle_count = 0; cycle_count < 20; cycle_count++) begin
            @(posedge dut.clk);
        end
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("LAB3 TOP MODULE QUESTA COMPATIBLE TEST");
        $display("==========================================");
        $display("This test uses a slower clock for better Questa visibility");
        $display("Watch the state changes over time as keys are pressed");
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
        $display("Watch scanner cycle through states: SCAN_ROW0 -> SCAN_ROW1 -> SCAN_ROW2 -> SCAN_ROW3");
        for (cycle_count = 0; cycle_count < 20; cycle_count++) begin
            @(posedge dut.clk);
            if (cycle_count % 5 == 0) begin
                display_system_state();
                display_keypad_state();
                display_display_state();
                display_scanner_state();
                display_debouncer_state();
            end
        end
        
        // Test 2: Single key press sequence
        $display("\n--- TEST 2: Single Key Press Sequence ---");
        $display("[%0t] Testing individual keys: 1, 5, A, F", $time);
        
        test_key_sequence(4'b1110, 4'h1, "Key '1' (R0C0)");
        test_key_sequence(4'b1101, 4'h5, "Key '5' (R1C1)");
        test_key_sequence(4'b1110, 4'hA, "Key 'A' (R3C0)");
        test_key_sequence(4'b0111, 4'hF, "Key 'F' (R3C3)");
        
        // Test 3: Multiple key sequence (digit shifting)
        $display("\n--- TEST 3: Multiple Key Sequence (Digit Shifting) ---");
        $display("[%0t] Testing digit shifting: 1, 2, 3, 4", $time);
        $display("Watch how digits shift: 1 -> 12 -> 123 -> 1234");
        
        test_key_sequence(4'b1110, 4'h1, "Key '1'");
        test_key_sequence(4'b1101, 4'h2, "Key '2'");
        test_key_sequence(4'b1011, 4'h3, "Key '3'");
        test_key_sequence(4'b0111, 4'h4, "Key '4'");
        
        // Test 4: All hexadecimal keys
        $display("\n--- TEST 4: All Hexadecimal Keys ---");
        $display("[%0t] Testing all keys 0-F...", $time);
        
        test_key_sequence(4'b1101, 4'h0, "Key '0'");
        test_key_sequence(4'b1110, 4'h1, "Key '1'");
        test_key_sequence(4'b1101, 4'h2, "Key '2'");
        test_key_sequence(4'b1011, 4'h3, "Key '3'");
        test_key_sequence(4'b0111, 4'h4, "Key '4'");
        test_key_sequence(4'b1110, 4'h5, "Key '5'");
        test_key_sequence(4'b1101, 4'h6, "Key '6'");
        test_key_sequence(4'b1011, 4'h7, "Key '7'");
        test_key_sequence(4'b0111, 4'h8, "Key '8'");
        test_key_sequence(4'b1110, 4'h9, "Key '9'");
        test_key_sequence(4'b1101, 4'hA, "Key 'A'");
        test_key_sequence(4'b1011, 4'hB, "Key 'B'");
        test_key_sequence(4'b0111, 4'hC, "Key 'C'");
        test_key_sequence(4'b1110, 4'hD, "Key 'D'");
        test_key_sequence(4'b1101, 4'hE, "Key 'E'");
        test_key_sequence(4'b1011, 4'hF, "Key 'F'");
        
        // Test 5: Rapid key presses
        $display("\n--- TEST 5: Rapid Key Presses ---");
        $display("[%0t] Testing rapid sequence: A, B, C, D", $time);
        
        press_key(4'b1110, "Key 'A' (rapid)");
        @(posedge dut.clk);
        release_key();
        @(posedge dut.clk);
        
        press_key(4'b1101, "Key 'B' (rapid)");
        @(posedge dut.clk);
        release_key();
        @(posedge dut.clk);
        
        press_key(4'b1011, "Key 'C' (rapid)");
        @(posedge dut.clk);
        release_key();
        @(posedge dut.clk);
        
        press_key(4'b0111, "Key 'D' (rapid)");
        @(posedge dut.clk);
        release_key();
        @(posedge dut.clk);
        
        // Test 6: Long key hold
        $display("\n--- TEST 6: Long Key Hold ---");
        press_key(4'b1110, "Key 'E' (long hold)");
        wait_for_key_processing(4'hE, "Key 'E'");
        
        // Hold for additional cycles
        for (cycle_count = 0; cycle_count < 50; cycle_count++) begin
            @(posedge dut.clk);
            if (cycle_count % 10 == 0) begin
                display_display_state();
                display_debouncer_state();
            end
        end
        
        release_key();
        
        // Test 7: Multiple keys pressed simultaneously (should not process)
        $display("\n--- TEST 7: Multiple Keys Pressed Simultaneously ---");
        $display("[%0t] Pressing multiple keys (should not process)...", $time);
        keypad_cols = 4'b1100; // Columns 0 and 1 active
        
        for (cycle_count = 0; cycle_count < 100; cycle_count++) begin
            @(posedge dut.clk);
            if (cycle_count % 25 == 0) begin
                display_system_state();
                display_keypad_state();
                display_display_state();
            end
        end
        
        keypad_cols = 4'b1111; // Release all
        
        // Test 8: Edge cases
        $display("\n--- TEST 8: Edge Cases ---");
        
        // No keys pressed
        keypad_cols = 4'b1111;
        for (cycle_count = 0; cycle_count < 25; cycle_count++) begin
            @(posedge dut.clk);
        end
        
        // All keys pressed (should not process)
        keypad_cols = 4'b0000;
        for (cycle_count = 0; cycle_count < 25; cycle_count++) begin
            @(posedge dut.clk);
        end
        
        keypad_cols = 4'b1111; // Release all
        
        // Test 9: Reset during operation
        $display("\n--- TEST 9: Reset During Operation ---");
        press_key(4'b1110, "Key '9' (before reset)");
        
        // Wait a bit
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge dut.clk);
        end
        
        $display("[%0t] Applying reset during key press...", $time);
        reset = 0;
        @(posedge dut.clk);
        display_system_state();
        display_display_state();
        
        reset = 1;
        @(posedge dut.clk);
        display_system_state();
        display_display_state();
        
        // Test 10: Final display verification
        $display("\n--- TEST 10: Final Display Verification ---");
        $display("[%0t] Final system state:", $time);
        display_system_state();
        display_keypad_state();
        display_display_state();
        display_scanner_state();
        display_debouncer_state();
        
        $display("\n[%0t] Display Analysis:", $time);
        $display("  Left digit: 0x%h (%s)", dut.digit_left, get_key_name(dut.digit_left));
        $display("  Right digit: 0x%h (%s)", dut.digit_right, get_key_name(dut.digit_right));
        $display("  Seven-segment: %b (%s)", seg, get_seg_display(seg));
        $display("  Select signals: Sel0=%b, Sel1=%b", select0, select1);
        
        // Test 11: Complete system walkthrough
        $display("\n--- TEST 11: Complete System Walkthrough ---");
        $display("[%0t] Testing complete system: 1, 2, 3, 4, 5", $time);
        
        test_key_sequence(4'b1110, 4'h1, "Key '1'");
        test_key_sequence(4'b1101, 4'h2, "Key '2'");
        test_key_sequence(4'b1011, 4'h3, "Key '3'");
        test_key_sequence(4'b0111, 4'h4, "Key '4'");
        test_key_sequence(4'b1110, 4'h5, "Key '5'");
        
        $display("\n[%0t] Final system state after walkthrough:", $time);
        display_system_state();
        display_display_state();
        
        $display("\n==========================================");
        $display("QUESTA COMPATIBLE TOP MODULE TEST COMPLETE");
        $display("==========================================");
        $finish;
    end
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    // Note: $monitor with complex expressions not supported in iverilog
    // Using display tasks instead for better compatibility
    
    // ========================================================================
    // WAVEFORM DUMP
    // ========================================================================
    initial begin
        $dumpfile("tb_top_debug.vcd");
        $dumpvars(0, tb_top_debug);
    end

endmodule