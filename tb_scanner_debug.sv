// ============================================================================
// KEYPAD SCANNER TEST BENCH - QUESTA COMPATIBLE STATE WALKTHROUGH
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench that walks through scanner states over time with proper delays
// Shows actual state transitions and timing behavior for Questa simulation
// ============================================================================

`timescale 1ns/1ps

module tb_scanner_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 10; // 10ns period for better visibility in Questa
    
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
        $display("SCANNER STATE WALKTHROUGH TEST - QUESTA VERSION");
        $display("==========================================");
        $display("This test will show state transitions over time");
        $display("Watch the STATE field change as scanner cycles through rows");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        col = 4'b1111; // No keys pressed initially
        cycle_count = 0;
        
        // Reset sequence - hold reset for several cycles
        $display("\n--- RESET SEQUENCE ---");
        repeat(10) @(posedge clk);
        
        // Release reset
        rst_n = 1;
        $display("\n[%0t] Reset released - scanner should start scanning", $time);
        
        // Test 1: Normal scanning cycle (no keys pressed)
        $display("\n--- TEST 1: NORMAL SCANNING CYCLE (NO KEYS) ---");
        $display("Watch STATE change: SCAN_ROW0 -> SCAN_ROW1 -> SCAN_ROW2 -> SCAN_ROW3 -> SCAN_ROW0...");
        col = 4'b1111; // No keys pressed
        
        // Let it scan through multiple cycles
        repeat(50) @(posedge clk);
        
        // Test 2: Key press during scanning
        $display("\n--- TEST 2: KEY PRESS DURING SCANNING ---");
        $display("Press key '1' (Row0, Col0) - should see KEY_DET=1 when scanner is on Row0");
        col = 4'b1110; // Press key '1'
        
        // Monitor for several cycles to see key detection
        repeat(30) @(posedge clk);
        
        // Test 3: Key release and continue scanning
        $display("\n--- TEST 3: KEY RELEASE AND CONTINUE SCANNING ---");
        $display("Release key - should see KEY_DET=0 and normal scanning resume");
        col = 4'b1111; // Release key
        
        repeat(20) @(posedge clk);
        
        // Test 4: Multiple key presses during different rows
        $display("\n--- TEST 4: MULTIPLE KEYS DURING DIFFERENT ROWS ---");
        
        // Press key '4' (Row1, Col0)
        $display("Press key '4' (Row1, Col0) - should see KEY_DET=1 when scanner is on Row1");
        col = 4'b1101;
        
        repeat(20) @(posedge clk);
        
        // Release and press key '7' (Row2, Col0)
        $display("Release key '4', press key '7' (Row2, Col0) - should see KEY_DET=1 when scanner is on Row2");
        col = 4'b1011;
        
        repeat(20) @(posedge clk);
        
        // Test 5: Scan stop functionality
        $display("\n--- TEST 5: SCAN STOP FUNCTIONALITY ---");
        $display("Press key and watch scan_stop signal behavior");
        
        // Press a key and show scan_stop behavior
        col = 4'b1110; // Press key '1'
        
        repeat(15) @(posedge clk);
        
        // Release key
        col = 4'b1111;
        
        repeat(15) @(posedge clk);
        
        // Test 6: Rapid key changes
        $display("\n--- TEST 6: RAPID KEY CHANGES ---");
        $display("Testing rapid key changes: 1, 2, 3, C");
        
        // Rapid sequence: 1, 2, 3, C
        col = 4'b1110; // Key '1'
        repeat(5) @(posedge clk);
        
        col = 4'b1101; // Key '2'
        repeat(5) @(posedge clk);
        
        col = 4'b1011; // Key '3'
        repeat(5) @(posedge clk);
        
        col = 4'b0111; // Key 'C'
        repeat(5) @(posedge clk);
        
        col = 4'b1111; // Release all
        repeat(5) @(posedge clk);
        
        // Final scanning cycle
        $display("\n--- FINAL SCANNING CYCLE ---");
        $display("Final normal scanning cycle to show complete state transitions");
        repeat(30) @(posedge clk);
        
        $display("\n==========================================");
        $display("SCANNER STATE WALKTHROUGH COMPLETE");
        $display("==========================================");
        $finish;
    end

endmodule