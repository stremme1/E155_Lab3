// ============================================================================
// KEYPAD SCANNER TEST BENCH - STATE WALKTHROUGH VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench that walks through scanner states over time with clock changes
// Shows actual state transitions and timing behavior
// ============================================================================

`timescale 1ns/1ps

module tb_scanner_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    
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
    integer      cycle_count;
    
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
    // DISPLAY FUNCTIONS
    // ========================================================================
    function string get_state_name(input [1:0] state);
        case (state)
            2'b00: return "SCAN_ROW0";
            2'b01: return "SCAN_ROW1";
            2'b10: return "SCAN_ROW2";
            2'b11: return "SCAN_ROW3";
            default: return "UNKNOWN";
        endcase
    endfunction
    
    task display_state();
        $display("[%0t] CLK=%b RST=%b ROW=%b COL=%b ROW_IDX=%b COL_SYNC=%b KEY_DET=%b SCAN_STOP=%b STATE=%s TIMEOUT=%0d", 
                 $time, clk, rst_n, row, col, row_idx, col_sync, key_detected, scan_stop, 
                 get_state_name(dut.current_state), dut.scan_counter);
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("SCANNER STATE WALKTHROUGH TEST");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        col = 4'b1111; // No keys pressed initially
        cycle_count = 0;
        
        $display("\n[%0t] Starting test - will show state transitions over time", $time);
        $display("Format: [TIME] CLK RST ROW COL ROW_IDX COL_SYNC KEY_DET SCAN_STOP STATE TIMEOUT");
        $display("-------------------------------------------------------------------------------");
        
        // Reset sequence
        $display("\n--- RESET SEQUENCE ---");
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Release reset
        rst_n = 1;
        $display("\n[%0t] Reset released - scanner should start scanning", $time);
        
        // Test 1: Normal scanning cycle (no keys pressed)
        $display("\n--- TEST 1: NORMAL SCANNING CYCLE (NO KEYS) ---");
        col = 4'b1111; // No keys pressed
        
        // Let it scan through all 4 rows
        for (cycle_count = 0; cycle_count < 25; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 2: Key press during scanning
        $display("\n--- TEST 2: KEY PRESS DURING SCANNING ---");
        $display("[%0t] Pressing key '1' (Row0, Col0) during scan", $time);
        col = 4'b1110; // Press key '1'
        
        // Monitor for several cycles
        for (cycle_count = 0; cycle_count < 15; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 3: Key release and continue scanning
        $display("\n--- TEST 3: KEY RELEASE AND CONTINUE SCANNING ---");
        $display("[%0t] Releasing key", $time);
        col = 4'b1111; // Release key
        
        for (cycle_count = 0; cycle_count < 15; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 4: Multiple key presses during different rows
        $display("\n--- TEST 4: MULTIPLE KEYS DURING DIFFERENT ROWS ---");
        
        // Press key '4' (Row1, Col0)
        $display("[%0t] Pressing key '4' (Row1, Col0)", $time);
        col = 4'b1101;
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Release and press key '7' (Row2, Col0)
        $display("[%0t] Releasing key '4', pressing key '7' (Row2, Col0)", $time);
        col = 4'b1011;
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 5: Scan stop functionality
        $display("\n--- TEST 5: SCAN STOP FUNCTIONALITY ---");
        $display("[%0t] Testing scan_stop signal", $time);
        
        // Press a key and show scan_stop behavior
        col = 4'b1110; // Press key '1'
        
        for (cycle_count = 0; cycle_count < 8; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Release key
        col = 4'b1111;
        
        for (cycle_count = 0; cycle_count < 8; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 6: Rapid key changes
        $display("\n--- TEST 6: RAPID KEY CHANGES ---");
        $display("[%0t] Testing rapid key changes", $time);
        
        // Rapid sequence: 1, 2, 3, C
        col = 4'b1110; // Key '1'
        @(posedge clk);
        display_state();
        
        col = 4'b1101; // Key '2'
        @(posedge clk);
        display_state();
        
        col = 4'b1011; // Key '3'
        @(posedge clk);
        display_state();
        
        col = 4'b0111; // Key 'C'
        @(posedge clk);
        display_state();
        
        col = 4'b1111; // Release all
        @(posedge clk);
        display_state();
        
        // Final scanning cycle
        $display("\n--- FINAL SCANNING CYCLE ---");
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        $display("\n==========================================");
        $display("SCANNER STATE WALKTHROUGH COMPLETE");
        $display("==========================================");
        $finish;
    end

endmodule