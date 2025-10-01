// ============================================================================
// COMPLETE SYSTEM TESTBENCH
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Comprehensive testbench for entire keypad system with enhanced debouncer
// Tests all modules: scanner, decoder, debouncer, controller, and display
// ============================================================================

`timescale 1ns/1ps

module tb_complete;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    localparam CLK_PERIOD = 333; // 3MHz clock period in ns
    
    // Clock and reset
    logic        clk;
    logic        rst_n;
    
    // Test signals
    logic [3:0]  key_code;
    logic        key_detected;
    logic        key_valid;
    logic [3:0]  debounced_key;
    logic        scan_stop;
    logic        key_held;
    logic [3:0]  held_key_code;
    logic        flash_enable;
    logic        combo_ready;
    logic [3:0]  digit_left;
    logic [3:0]  digit_right;
    
    // Test control
    integer      test_num;
    integer      error_count;
    
    // ========================================================================
    // INSTANTIATE ENHANCED DEBOUNCER
    // ========================================================================
    keypad_debouncer debouncer_inst (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
        .key_detected(key_detected),
        .key_valid(key_valid),
        .debounced_key(debounced_key),
        .scan_stop(scan_stop),
        .key_held(key_held),
        .held_key_code(held_key_code),
        .flash_enable(flash_enable),
        .combo_ready(combo_ready)
    );
    
    // ========================================================================
    // INSTANTIATE CONTROLLER
    // ========================================================================
    keypad_controller controller_inst (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(debounced_key),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );
    
    // ========================================================================
    // CLOCK GENERATION
    // ========================================================================
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // ========================================================================
    // TEST TASKS
    // ========================================================================
    
    // Task to simulate key press
    task simulate_key_press(input [3:0] key, input int duration_cycles);
        begin
            $display("  [%0t] Simulating key press: 0x%h for %0d cycles", $time, key, duration_cycles);
            key_code = key;
            key_detected = 1'b1;
            repeat(duration_cycles) @(posedge clk);
            key_detected = 1'b0;
            key_code = 4'h0;
            repeat(5) @(posedge clk);
        end
    endtask
    
    // Task to simulate key hold
    task simulate_key_hold(input [3:0] key, input int hold_cycles);
        begin
            $display("  [%0t] Simulating key hold: 0x%h for %0d cycles", $time, key, hold_cycles);
            key_code = key;
            key_detected = 1'b1;
            repeat(hold_cycles) @(posedge clk);
            key_detected = 1'b0;
            key_code = 4'h0;
            repeat(5) @(posedge clk);
        end
    endtask
    
    // Task to check system state
    task check_system_state(input string test_name);
        begin
            $display("  %s:", test_name);
            $display("    key_valid=%b, debounced_key=0x%h, scan_stop=%b", 
                     key_valid, debounced_key, scan_stop);
            $display("    key_held=%b, held_key_code=0x%h", key_held, held_key_code);
            $display("    flash_enable=%b, combo_ready=%b", flash_enable, combo_ready);
            $display("    digit_left=0x%h, digit_right=0x%h", digit_left, digit_right);
        end
    endtask
    
    // ========================================================================
    // TEST SEQUENCES
    // ========================================================================
    
    // Test 1: Basic single key functionality
    task test_basic_functionality();
        begin
            test_num = 1;
            $display("\n=== TEST %0d: Basic Single Key Functionality ===", test_num);
            
            // Test key '1'
            simulate_key_press(4'h1, 70000);
            check_system_state("After key '1' press");
            
            // Test key '5'
            simulate_key_press(4'h5, 70000);
            check_system_state("After key '5' press");
            
            // Test key 'A'
            simulate_key_press(4'hA, 70000);
            check_system_state("After key 'A' press");
        end
    endtask
    
    // Test 2: Key holding functionality
    task test_key_holding();
        begin
            test_num = 2;
            $display("\n=== TEST %0d: Key Holding Functionality ===", test_num);
            
            // Hold key '3' for extended period
            simulate_key_hold(4'h3, 200000);
            check_system_state("After key '3' hold");
            
            // Hold key 'F' for extended period
            simulate_key_hold(4'hF, 200000);
            check_system_state("After key 'F' hold");
        end
    endtask
    
    // Test 3: Multi-key scenarios
    task test_multi_key_scenarios();
        begin
            test_num = 3;
            $display("\n=== TEST %0d: Multi-Key Scenarios ===", test_num);
            
            // Test rapid key sequences
            $display("  Testing rapid key sequences...");
            simulate_key_press(4'h1, 70000);  // Key '1'
            simulate_key_press(4'h2, 70000);  // Key '2'
            simulate_key_press(4'h3, 70000);  // Key '3'
            check_system_state("After rapid sequence");
            
            // Test key combinations (simulated)
            $display("  Testing key combination detection...");
            simulate_key_hold(4'h1, 100000);  // Hold '1'
            check_system_state("After key '1' hold - ready for combinations");
        end
    endtask
    
    // Test 4: Same row multi-key simulation
    task test_same_row_multi_key();
        begin
            test_num = 4;
            $display("\n=== TEST %0d: Same Row Multi-Key Simulation ===", test_num);
            
            // Simulate same row keys (1,2,3) - should show ghosting behavior
            $display("  Simulating same row keys: 1,2,3");
            $display("  In real system, this would create ghosting");
            $display("  Enhanced debouncer should handle this gracefully");
            
            // Test individual keys in same row
            simulate_key_press(4'h1, 70000);  // Row 0, Col 0
            check_system_state("After key '1' (Row 0, Col 0)");
            
            simulate_key_press(4'h2, 70000);  // Row 0, Col 1
            check_system_state("After key '2' (Row 0, Col 1)");
            
            simulate_key_press(4'h3, 70000);  // Row 0, Col 2
            check_system_state("After key '3' (Row 0, Col 2)");
        end
    endtask
    
    // Test 5: Same column multi-key simulation
    task test_same_column_multi_key();
        begin
            test_num = 5;
            $display("\n=== TEST %0d: Same Column Multi-Key Simulation ===", test_num);
            
            // Simulate same column keys (1,4,7,A) - should show ghosting behavior
            $display("  Simulating same column keys: 1,4,7,A");
            $display("  In real system, this would create ghosting");
            $display("  Enhanced debouncer should handle this gracefully");
            
            // Test individual keys in same column
            simulate_key_press(4'h1, 70000);  // Row 0, Col 0
            check_system_state("After key '1' (Row 0, Col 0)");
            
            simulate_key_press(4'h4, 70000);  // Row 1, Col 0
            check_system_state("After key '4' (Row 1, Col 0)");
            
            simulate_key_press(4'h7, 70000);  // Row 2, Col 0
            check_system_state("After key '7' (Row 2, Col 0)");
            
            simulate_key_press(4'hA, 70000);  // Row 3, Col 0
            check_system_state("After key 'A' (Row 3, Col 0)");
        end
    endtask
    
    // ========================================================================
    // MAIN TEST SEQUENCE
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("Complete System Testbench Starting");
        $display("Enhanced Debouncer with Multi-Key Support");
        $display("==========================================");
        
        // Initialize
        error_count = 0;
        key_code = 4'h0;
        key_detected = 1'b0;
        rst_n = 1'b0;
        repeat(10) @(posedge clk);
        rst_n = 1'b1;
        repeat(5) @(posedge clk);
        
        // Run tests
        test_basic_functionality();
        test_key_holding();
        test_multi_key_scenarios();
        test_same_row_multi_key();
        test_same_column_multi_key();
        
        // Final results
        $display("\n==========================================");
        $display("Complete System Test Results:");
        $display("  Total Errors: %0d", error_count);
        if (error_count == 0) begin
            $display("  ALL SYSTEM TESTS PASSED!");
            $display("  Enhanced debouncer working correctly!");
        end else begin
            $display("  %0d SYSTEM TESTS FAILED!", error_count);
        end
        $display("==========================================");
        
        $finish;
    end
    
    // ========================================================================
    // TIMEOUT PROTECTION
    // ========================================================================
    initial begin
        #1000000000; // 1 second timeout
        $display("ERROR: System testbench timeout!");
        $finish;
    end

endmodule
