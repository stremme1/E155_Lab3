// ============================================================================
// KEYPAD DEBOUNCER TEST BENCH - COMPREHENSIVE DEBUG VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for keypad_debouncer module with comprehensive state testing
// Tests all debouncer states, timing, multiple key sequences, and edge cases
// ============================================================================

`timescale 1ns/1ps

module tb_debouncer_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    parameter DEBOUNCE_TIME = 59999; // 20ms debounce time @ 3MHz
    
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
    integer      test_count;
    integer      cycle_count;
    time         key_press_time;
    time         debounce_start_time;
    
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
    // STATE DISPLAY TASKS
    // ========================================================================
    task display_state;
        case (dut.current_state)
            dut.IDLE: $display("[%0t] DEBOUNCER: State = IDLE, Key_valid = %b, Scan_stop = %b", 
                               $time, key_valid, scan_stop);
            dut.DEBOUNCING: $display("[%0t] DEBOUNCER: State = DEBOUNCING, Count = %0d/%0d, Key_valid = %b, Scan_stop = %b", 
                                    $time, dut.debounce_cnt, DEBOUNCE_TIME, key_valid, scan_stop);
            dut.KEY_HELD: $display("[%0t] DEBOUNCER: State = KEY_HELD, Key_valid = %b, Scan_stop = %b", 
                                  $time, key_valid, scan_stop);
            default: $display("[%0t] DEBOUNCER: State = UNKNOWN", $time);
        endcase
    endtask
    
    task display_inputs;
        $display("[%0t] DEBOUNCER: Inputs - Key_code = 0x%h, Key_detected = %b, Col = %b", 
                 $time, key_code, key_detected, col);
    endtask
    
    task display_outputs;
        $display("[%0t] DEBOUNCER: Outputs - Key_valid = %b, Debounced_key = 0x%h, Scan_stop = %b", 
                 $time, key_valid, debounced_key, scan_stop);
    endtask
    
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
        input [3:0] key_val;
        input [3:0] col_val;
        input string key_name;
        
        $display("\n[%0t] Pressing %s (0x%h, Col=%b)...", $time, key_name, key_val, col_val);
        key_code = key_val;
        col = col_val;
        key_detected = 1'b1;
        key_press_time = $time;
    endtask
    
    task release_key;
        $display("[%0t] Releasing key...", $time);
        key_detected = 1'b0;
        key_code = 4'h0;
        col = 4'b1111;
    endtask
    
    task wait_for_debounce_complete;
        integer timeout_count;
        timeout_count = 0;
        
        $display("[%0t] Waiting for debounce to complete...", $time);
        while (dut.current_state != dut.KEY_HELD && timeout_count < 300) begin
            @(posedge clk);
            if (timeout_count % 50 == 0) begin
                display_inputs();
                display_state();
                display_outputs();
            end
            timeout_count = timeout_count + 1;
        end
        
        if (dut.current_state == dut.KEY_HELD) begin
            $display("[%0t] *** DEBOUNCE COMPLETED! Key %s is now valid ***", $time, get_key_name(debounced_key));
        end else begin
            $display("[%0t] *** DEBOUNCE TIMEOUT! Key did not complete debouncing ***", $time);
        end
    endtask
    
    task test_key_sequence;
        input [3:0] key_val;
        input [3:0] col_val;
        input string key_name;
        
        press_key(key_val, col_val, key_name);
        wait_for_debounce_complete();
        release_key();
        
        // Wait for return to IDLE
        while (dut.current_state != dut.IDLE) begin
            @(posedge clk);
            if (cycle_count % 20 == 0) begin
                display_state();
            end
            cycle_count = cycle_count + 1;
        end
        $display("[%0t] Returned to IDLE state", $time);
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("KEYPAD DEBOUNCER COMPREHENSIVE DEBUG TEST");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 1'b0;
        test_count = 0;
        cycle_count = 0;
        
        // Reset sequence
        $display("\n[%0t] Applying reset...", $time);
        #(CLK_PERIOD * 2);
        rst_n = 1;
        #(CLK_PERIOD);
        
        $display("\n[%0t] Reset released. Starting comprehensive debouncer test...", $time);
        
        // Test 1: Initial state (IDLE)
        $display("\n--- TEST 1: Initial State (IDLE) ---");
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Test 2: Single key press and complete debounce
        $display("\n--- TEST 2: Single Key Press and Complete Debounce ---");
        test_key_sequence(4'h5, 4'b1101, "Key '5'");
        
        // Test 3: Multiple key sequence
        $display("\n--- TEST 3: Multiple Key Sequence ---");
        $display("[%0t] Testing sequence: 1, 2, 3, 4", $time);
        
        test_key_sequence(4'h1, 4'b1110, "Key '1'");
        test_key_sequence(4'h2, 4'b1101, "Key '2'");
        test_key_sequence(4'h3, 4'b1011, "Key '3'");
        test_key_sequence(4'h4, 4'b0111, "Key '4'");
        
        // Test 4: All hexadecimal keys
        $display("\n--- TEST 4: All Hexadecimal Keys ---");
        $display("[%0t] Testing all keys 0-F...", $time);
        
        test_key_sequence(4'h0, 4'b1101, "Key '0'");
        test_key_sequence(4'h1, 4'b1110, "Key '1'");
        test_key_sequence(4'h2, 4'b1101, "Key '2'");
        test_key_sequence(4'h3, 4'b1011, "Key '3'");
        test_key_sequence(4'h4, 4'b0111, "Key '4'");
        test_key_sequence(4'h5, 4'b1110, "Key '5'");
        test_key_sequence(4'h6, 4'b1101, "Key '6'");
        test_key_sequence(4'h7, 4'b1011, "Key '7'");
        test_key_sequence(4'h8, 4'b0111, "Key '8'");
        test_key_sequence(4'h9, 4'b1110, "Key '9'");
        test_key_sequence(4'hA, 4'b1101, "Key 'A'");
        test_key_sequence(4'hB, 4'b1011, "Key 'B'");
        test_key_sequence(4'hC, 4'b0111, "Key 'C'");
        test_key_sequence(4'hD, 4'b1110, "Key 'D'");
        test_key_sequence(4'hE, 4'b1101, "Key 'E'");
        test_key_sequence(4'hF, 4'b1011, "Key 'F'");
        
        // Test 5: Short key press (should not complete debounce)
        $display("\n--- TEST 5: Short Key Press (Incomplete Debounce) ---");
        press_key(4'hC, 4'b1011, "Key 'C' (short press)");
        
        // Wait a short time
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
            #(CLK_PERIOD/4);
        end
        
        release_key();
        $display("[%0t] Key released before debounce complete", $time);
        
        // Wait for return to IDLE
        while (dut.current_state != dut.IDLE) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 6: Key press while another key is held
        $display("\n--- TEST 6: Key Press While Another Key Held ---");
        press_key(4'h7, 4'b1011, "Key '7' (first key)");
        wait_for_debounce_complete();
        
        // Try to press another key while first is held
        $display("[%0t] Trying to press Key 'A' while '7' is held...", $time);
        key_code = 4'hA;
        col = 4'b1110;
        key_detected = 1'b1;
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Release first key
        release_key();
        while (dut.current_state != dut.IDLE) begin
            @(posedge clk);
            display_state();
        end
        
        // Test 7: Rapid key presses
        $display("\n--- TEST 7: Rapid Key Presses ---");
        $display("[%0t] Testing rapid sequence: A, B, C, D", $time);
        
        // Rapid sequence without waiting for complete debounce
        press_key(4'hA, 4'b1110, "Key 'A' (rapid)");
        @(posedge clk);
        release_key();
        @(posedge clk);
        
        press_key(4'hB, 4'b1101, "Key 'B' (rapid)");
        @(posedge clk);
        release_key();
        @(posedge clk);
        
        press_key(4'hC, 4'b1011, "Key 'C' (rapid)");
        @(posedge clk);
        release_key();
        @(posedge clk);
        
        press_key(4'hD, 4'b0111, "Key 'D' (rapid)");
        @(posedge clk);
        release_key();
        @(posedge clk);
        
        // Test 8: Invalid key codes
        $display("\n--- TEST 8: Invalid Key Codes ---");
        $display("[%0t] Testing invalid key codes...", $time);
        
        // Test with key_detected but invalid key_code
        key_detected = 1'b1;
        key_code = 4'h0; // Invalid
        col = 4'b1110;
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        release_key();
        
        // Test 9: Edge cases
        $display("\n--- TEST 9: Edge Cases ---");
        
        // No key detected but valid key code
        key_detected = 1'b0;
        key_code = 4'h5;
        col = 4'b1101;
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Test 10: Reset during operation
        $display("\n--- TEST 10: Reset During Operation ---");
        press_key(4'h9, 4'b1011, "Key '9' (before reset)");
        
        // Wait a bit
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_state();
        end
        
        $display("[%0t] Applying reset during key press...", $time);
        rst_n = 0;
        @(posedge clk);
        display_state();
        
        rst_n = 1;
        @(posedge clk);
        display_state();
        
        // Test 11: Long key hold
        $display("\n--- TEST 11: Long Key Hold ---");
        press_key(4'hF, 4'b0111, "Key 'F' (long hold)");
        wait_for_debounce_complete();
        
        // Hold for additional cycles
        for (cycle_count = 0; cycle_count < 50; cycle_count++) begin
            @(posedge clk);
            if (cycle_count % 10 == 0) begin
                display_state();
            end
        end
        
        release_key();
        while (dut.current_state != dut.IDLE) begin
            @(posedge clk);
            display_state();
        end
        
        $display("\n==========================================");
        $display("COMPREHENSIVE DEBOUNCER TEST COMPLETE");
        $display("==========================================");
        $finish;
    end
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    initial begin
        $monitor("[%0t] CLK=%b RST=%b KEY_CODE=0x%h KEY_DET=%b KEY_VAL=%b DEB_KEY=0x%h SCAN_STOP=%b", 
                 $time, clk, rst_n, key_code, key_detected, key_valid, debounced_key, scan_stop);
    end
    
    // ========================================================================
    // WAVEFORM DUMP
    // ========================================================================
    initial begin
        $dumpfile("tb_debouncer_debug.vcd");
        $dumpvars(0, tb_debouncer_debug);
    end

endmodule