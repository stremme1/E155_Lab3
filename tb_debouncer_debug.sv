// ============================================================================
// KEYPAD DEBOUNCER TEST BENCH - STATE WALKTHROUGH VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench that walks through debouncer states over time with clock changes
// Shows actual state transitions and debouncing behavior
// ============================================================================

`timescale 1ns/1ps

module tb_debouncer_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    
    // Clock and reset
    logic        clk;
    logic        rst_n;
    
    // Debouncer inputs
    logic [3:0]  key_code;
    logic [3:0]  col;
    logic        key_detected;
    
    // Debouncer outputs
    logic        key_valid;
    logic [3:0]  debounced_key;
    logic        scan_stop;
    
    // Test control
    integer      cycle_count;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    keypad_debouncer dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
        .col(col),
        .key_detected(key_detected),
        .key_valid(key_valid),
        .debounced_key(debounced_key),
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
            2'b00: return "IDLE";
            2'b01: return "DEBOUNCING";
            2'b10: return "KEY_HELD";
            default: return "UNKNOWN";
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
    
    task display_state();
        $display("[%0t] CLK=%b RST=%b KEY_CODE=%s COL=%b KEY_DET=%b KEY_VAL=%b DEB_KEY=%s SCAN_STOP=%b STATE=%s COUNT=%0d", 
                 $time, clk, rst_n, get_key_name(key_code), col, key_detected, key_valid, 
                 get_key_name(debounced_key), scan_stop, get_state_name(dut.current_state), dut.debounce_cnt);
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("DEBOUNCER STATE WALKTHROUGH TEST");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        cycle_count = 0;
        
        $display("\n[%0t] Starting test - will show state transitions over time", $time);
        $display("Format: [TIME] CLK RST KEY_CODE COL KEY_DET KEY_VAL DEB_KEY SCAN_STOP STATE COUNT");
        $display("-------------------------------------------------------------------------------");
        
        // Reset sequence
        $display("\n--- RESET SEQUENCE ---");
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Release reset
        rst_n = 1;
        $display("\n[%0t] Reset released - debouncer should be in IDLE", $time);
        
        // Test 1: Normal idle operation
        $display("\n--- TEST 1: IDLE STATE (NO KEYS) ---");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 2: Key press - should enter DEBOUNCING
        $display("\n--- TEST 2: KEY PRESS - ENTER DEBOUNCING STATE ---");
        $display("[%0t] Pressing key '1' - should enter DEBOUNCING", $time);
        key_code = 4'h1;
        col = 4'b1110;
        key_detected = 1;
        
        // Show debouncing process (but not full 20ms)
        for (cycle_count = 0; cycle_count < 50; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 3: Key release during debouncing
        $display("\n--- TEST 3: KEY RELEASE DURING DEBOUNCING ---");
        $display("[%0t] Releasing key during debouncing - should return to IDLE", $time);
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 4: Complete debounce cycle
        $display("\n--- TEST 4: COMPLETE DEBOUNCE CYCLE ---");
        $display("[%0t] Pressing key '5' - will show full debounce process", $time);
        key_code = 4'h5;
        col = 4'b1101;
        key_detected = 1;
        
        // Show debouncing with progress
        for (cycle_count = 0; cycle_count < 100; cycle_count++) begin
            @(posedge clk);
            if (cycle_count % 20 == 0) display_state(); // Show every 20th cycle
        end
        
        // Test 5: Key held - should enter KEY_HELD state
        $display("\n--- TEST 5: KEY HELD - ENTER KEY_HELD STATE ---");
        $display("[%0t] Key held - should enter KEY_HELD state", $time);
        
        for (cycle_count = 0; cycle_count < 20; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 6: Key release from KEY_HELD
        $display("\n--- TEST 6: KEY RELEASE FROM KEY_HELD ---");
        $display("[%0t] Releasing key from KEY_HELD - should return to IDLE", $time);
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 7: Multiple key sequence
        $display("\n--- TEST 7: MULTIPLE KEY SEQUENCE ---");
        
        // Key '2'
        $display("[%0t] Pressing key '2'", $time);
        key_code = 4'h2;
        col = 4'b1101;
        key_detected = 1;
        
        for (cycle_count = 0; cycle_count < 30; cycle_count++) begin
            @(posedge clk);
            if (cycle_count % 10 == 0) display_state();
        end
        
        // Release
        $display("[%0t] Releasing key '2'", $time);
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Key '8'
        $display("[%0t] Pressing key '8'", $time);
        key_code = 4'h8;
        col = 4'b1011;
        key_detected = 1;
        
        for (cycle_count = 0; cycle_count < 30; cycle_count++) begin
            @(posedge clk);
            if (cycle_count % 10 == 0) display_state();
        end
        
        // Release
        $display("[%0t] Releasing key '8'", $time);
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 8: Invalid key code
        $display("\n--- TEST 8: INVALID KEY CODE ---");
        $display("[%0t] Testing invalid key code (0x0) with key_detected=1", $time);
        key_code = 4'h0;
        col = 4'b1110;
        key_detected = 1;
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        // Final idle
        $display("\n--- FINAL IDLE STATE ---");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        $display("\n==========================================");
        $display("DEBOUNCER STATE WALKTHROUGH COMPLETE");
        $display("==========================================");
        $finish;
    end

endmodule