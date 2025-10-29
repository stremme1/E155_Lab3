// ============================================================================
// KEYPAD SCANNER TEST BENCH - COMPREHENSIVE DEBUG VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for keypad_scanner module with comprehensive state testing
// Tests all scan states, timing, key detection, and multiple key sequences
// ============================================================================

`timescale 1ns/1ps

module tb_scanner_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    parameter SCAN_PERIOD = 6000;  // Scanner timeout period
    
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
    
    // Test control
    integer      test_count;
    integer      cycle_count;
    integer      scan_cycle_count;
    
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
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // ========================================================================
    // STATE DISPLAY TASKS
    // ========================================================================
    task display_scan_state;
        case (dut.current_state)
            dut.SCAN_ROW0: $display("[%0t] SCANNER: State = SCAN_ROW0, Row = %b, Row_idx = %b, Timeout = %b", 
                                   $time, row, row_idx, dut.scan_timeout);
            dut.SCAN_ROW1: $display("[%0t] SCANNER: State = SCAN_ROW1, Row = %b, Row_idx = %b, Timeout = %b", 
                                   $time, row, row_idx, dut.scan_timeout);
            dut.SCAN_ROW2: $display("[%0t] SCANNER: State = SCAN_ROW2, Row = %b, Row_idx = %b, Timeout = %b", 
                                   $time, row, row_idx, dut.scan_timeout);
            dut.SCAN_ROW3: $display("[%0t] SCANNER: State = SCAN_ROW3, Row = %b, Row_idx = %b, Timeout = %b", 
                                   $time, row, row_idx, dut.scan_timeout);
            default: $display("[%0t] SCANNER: State = UNKNOWN", $time);
        endcase
    endtask
    
    task display_key_detection;
        if (key_detected) begin
            $display("[%0t] SCANNER: KEY DETECTED! Col_sync = %b", $time, col_sync);
        end else begin
            $display("[%0t] SCANNER: No key detected, Col_sync = %b", $time, col_sync);
        end
    endtask
    
    task wait_for_scan_cycle;
        $display("[%0t] Waiting for complete scan cycle...", $time);
        for (scan_cycle_count = 0; scan_cycle_count < 4; scan_cycle_count++) begin
            // Wait for timeout to occur
            wait(dut.scan_timeout);
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
    endtask
    
    task test_key_sequence;
        input [3:0] test_col;
        input string key_name;
        input integer row_num;
        
        $display("\n--- Testing %s (Row%d, Col=%b) ---", key_name, row_num, test_col);
        col = test_col;
        
        // Wait for the correct row to be active
        wait(dut.current_state == (row_num == 0 ? dut.SCAN_ROW0 : 
                                  row_num == 1 ? dut.SCAN_ROW1 :
                                  row_num == 2 ? dut.SCAN_ROW2 : dut.SCAN_ROW3));
        
        // Monitor for a few cycles while key is pressed
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        // Release key
        col = 4'b1111;
        $display("[%0t] %s released", $time, key_name);
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("KEYPAD SCANNER COMPREHENSIVE DEBUG TEST");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        col = 4'b1111; // No keys pressed initially
        test_count = 0;
        cycle_count = 0;
        scan_stop = 0;
        
        // Reset sequence
        $display("\n[%0t] Applying reset...", $time);
        #(CLK_PERIOD * 2);
        rst_n = 1;
        #(CLK_PERIOD);
        
        $display("\n[%0t] Reset released. Starting comprehensive scanner test...", $time);
        
        // Test 1: Normal scanning operation (no keys pressed)
        $display("\n--- TEST 1: Normal Scanning (No Keys) - Full Cycle ---");
        col = 4'b1111; // No keys pressed
        wait_for_scan_cycle();
        
        // Test 2: Key pressed on each row during its scan cycle
        $display("\n--- TEST 2: Key Pressed on Each Row ---");
        
        // Key '1' on Row 0, Col 0
        test_key_sequence(4'b1110, "Key '1'", 0);
        
        // Key '5' on Row 1, Col 1  
        test_key_sequence(4'b1101, "Key '5'", 1);
        
        // Key '9' on Row 2, Col 2
        test_key_sequence(4'b1011, "Key '9'", 2);
        
        // Key 'F' on Row 3, Col 3
        test_key_sequence(4'b0111, "Key 'F'", 3);
        
        // Test 3: Multiple keys pressed simultaneously (should not detect)
        $display("\n--- TEST 3: Multiple Keys Pressed (Should Not Detect) ---");
        col = 4'b1100; // Columns 0 and 1 active
        wait_for_scan_cycle();
        
        // Test 4: Key held across multiple scan cycles
        $display("\n--- TEST 4: Key Held Across Multiple Scan Cycles ---");
        col = 4'b1110; // Column 0 active
        $display("[%0t] Key held for multiple scan cycles...", $time);
        wait_for_scan_cycle();
        col = 4'b1111; // Release
        $display("[%0t] Key released", $time);
        
        // Test 5: Rapid key presses
        $display("\n--- TEST 5: Rapid Key Presses ---");
        $display("[%0t] Testing rapid sequence: 1, 2, 3, 4", $time);
        
        // Key 1
        col = 4'b1110; // Column 0
        @(posedge clk);
        display_scan_state();
        display_key_detection();
        col = 4'b1111;
        @(posedge clk);
        
        // Key 2  
        col = 4'b1101; // Column 1
        @(posedge clk);
        display_scan_state();
        display_key_detection();
        col = 4'b1111;
        @(posedge clk);
        
        // Key 3
        col = 4'b1011; // Column 2
        @(posedge clk);
        display_scan_state();
        display_key_detection();
        col = 4'b1111;
        @(posedge clk);
        
        // Key 4
        col = 4'b0111; // Column 3
        @(posedge clk);
        display_scan_state();
        display_key_detection();
        col = 4'b1111;
        @(posedge clk);
        
        // Test 6: Scan stop functionality
        $display("\n--- TEST 6: Scan Stop Functionality ---");
        scan_stop = 1;
        $display("[%0t] Scan stop asserted - should freeze scanning", $time);
        wait_for_scan_cycle();
        
        scan_stop = 0;
        $display("[%0t] Scan stop released - should resume scanning", $time);
        wait_for_scan_cycle();
        
        // Test 7: All possible key combinations
        $display("\n--- TEST 7: All Key Combinations ---");
        $display("[%0t] Testing all 16 key combinations...", $time);
        
        // Row 0 keys: 1, 2, 3, C
        test_key_sequence(4'b1110, "Key '1' (R0C0)", 0);
        test_key_sequence(4'b1101, "Key '2' (R0C1)", 0);
        test_key_sequence(4'b1011, "Key '3' (R0C2)", 0);
        test_key_sequence(4'b0111, "Key 'C' (R0C3)", 0);
        
        // Row 1 keys: 4, 5, 6, D
        test_key_sequence(4'b1110, "Key '4' (R1C0)", 1);
        test_key_sequence(4'b1101, "Key '5' (R1C1)", 1);
        test_key_sequence(4'b1011, "Key '6' (R1C2)", 1);
        test_key_sequence(4'b0111, "Key 'D' (R1C3)", 1);
        
        // Row 2 keys: 7, 8, 9, E
        test_key_sequence(4'b1110, "Key '7' (R2C0)", 2);
        test_key_sequence(4'b1101, "Key '8' (R2C1)", 2);
        test_key_sequence(4'b1011, "Key '9' (R2C2)", 2);
        test_key_sequence(4'b0111, "Key 'E' (R2C3)", 2);
        
        // Row 3 keys: A, 0, B, F
        test_key_sequence(4'b1110, "Key 'A' (R3C0)", 3);
        test_key_sequence(4'b1101, "Key '0' (R3C1)", 3);
        test_key_sequence(4'b1011, "Key 'B' (R3C2)", 3);
        test_key_sequence(4'b0111, "Key 'F' (R3C3)", 3);
        
        // Test 8: Edge cases
        $display("\n--- TEST 8: Edge Cases ---");
        
        // No keys pressed
        col = 4'b1111;
        wait_for_scan_cycle();
        
        // All keys pressed (should not detect)
        col = 4'b0000;
        wait_for_scan_cycle();
        
        // Invalid combinations
        col = 4'b1010; // Columns 1 and 3
        wait_for_scan_cycle();
        
        col = 4'b0101; // Columns 0 and 2
        wait_for_scan_cycle();
        
        $display("\n==========================================");
        $display("COMPREHENSIVE SCANNER TEST COMPLETE");
        $display("==========================================");
        $finish;
    end
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    initial begin
        $monitor("[%0t] CLK=%b RST=%b ROW=%b COL=%b ROW_IDX=%b COL_SYNC=%b KEY_DET=%b SCAN_STOP=%b TIMEOUT=%b", 
                 $time, clk, rst_n, row, col, row_idx, col_sync, key_detected, scan_stop, dut.scan_timeout);
    end
    
    // ========================================================================
    // WAVEFORM DUMP
    // ========================================================================
    initial begin
        $dumpfile("tb_scanner_debug.vcd");
        $dumpvars(0, tb_scanner_debug);
    end

endmodule