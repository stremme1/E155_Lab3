// ============================================================================
// KEYPAD DEBOUNCER TEST BENCH - DEBUG VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for keypad_debouncer module showing state transitions
// Tests IDLE, DEBOUNCING, and KEY_HELD states with timing verification
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
            dut.DEBOUNCING: $display("[%0t] DEBOUNCER: State = DEBOUNCING, Count = %0d, Key_valid = %b, Scan_stop = %b", 
                                    $time, dut.debounce_cnt, key_valid, scan_stop);
            dut.KEY_HELD: $display("[%0t] DEBOUNCER: State = KEY_HELD, Key_valid = %b, Scan_stop = %b", 
                                  $time, key_valid, scan_stop);
            default: $display("[%0t] DEBOUNCER: State = UNKNOWN", $time);
        endcase
    endtask
    
    task display_inputs;
        $display("[%0t] DEBOUNCER: Inputs - Key_code = 0x%h, Key_detected = %b", 
                 $time, key_code, key_detected);
    endtask
    
    task display_outputs;
        $display("[%0t] DEBOUNCER: Outputs - Key_valid = %b, Debounced_key = 0x%h, Scan_stop = %b", 
                 $time, key_valid, debounced_key, scan_stop);
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("KEYPAD DEBOUNCER DEBUG TEST BENCH");
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
        
        $display("\n[%0t] Reset released. Starting debouncer test...", $time);
        
        // Test 1: Initial state (IDLE)
        $display("\n--- TEST 1: Initial State (IDLE) ---");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 1'b0;
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Test 2: Key press detection and debouncing
        $display("\n--- TEST 2: Key Press Detection and Debouncing ---");
        key_code = 4'h5; // Key '5'
        col = 4'b1101; // Column 1 active
        key_detected = 1'b1;
        key_press_time = $time;
        debounce_start_time = $time;
        
        $display("[%0t] Key '5' pressed, starting debounce...", $time);
        
        // Monitor debouncing process
        for (cycle_count = 0; cycle_count < 200; cycle_count++) begin
            @(posedge clk);
            if (cycle_count % 20 == 0) begin
                display_inputs();
                display_state();
                display_outputs();
            end
            
            // Check if debounce completed
            if (key_valid && dut.current_state == dut.KEY_HELD) begin
                $display("[%0t] *** DEBOUNCE COMPLETED! Key '5' is now valid ***", $time);
                cycle_count = 200; // Exit loop
            end
            
            #(CLK_PERIOD/4);
        end
        
        // Test 3: Key held state
        $display("\n--- TEST 3: Key Held State ---");
        $display("[%0t] Key held, should ignore additional presses...", $time);
        
        // Try to press different key while first is held
        key_code = 4'hA; // Try key 'A'
        col = 4'b1110; // Column 0 active
        key_detected = 1'b1;
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Test 4: Key release
        $display("\n--- TEST 4: Key Release ---");
        key_detected = 1'b0;
        key_code = 4'h0;
        col = 4'b1111;
        $display("[%0t] Key released, should return to IDLE...", $time);
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Test 5: Multiple key presses (should only process first)
        $display("\n--- TEST 5: Multiple Key Presses ---");
        key_code = 4'h3; // Key '3'
        col = 4'b1011; // Column 2 active
        key_detected = 1'b1;
        $display("[%0t] Key '3' pressed...", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        
        // Immediately try another key
        key_code = 4'h7; // Key '7'
        col = 4'b0111; // Column 3 active
        key_detected = 1'b1;
        $display("[%0t] Key '7' pressed while '3' is being processed...", $time);
        
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Test 6: Short key press (should not complete debounce)
        $display("\n--- TEST 6: Short Key Press (Incomplete Debounce) ---");
        key_detected = 1'b0;
        key_code = 4'h0;
        col = 4'b1111;
        $display("[%0t] Key released before debounce complete...", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        
        // Short press
        key_code = 4'hC; // Key 'C'
        key_detected = 1'b1;
        $display("[%0t] Short press of key 'C'...", $time);
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Release before debounce completes
        key_detected = 1'b0;
        key_code = 4'h0;
        $display("[%0t] Key released before debounce complete...", $time);
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        // Test 7: Complete debounce cycle
        $display("\n--- TEST 7: Complete Debounce Cycle ---");
        key_code = 4'hF; // Key 'F'
        key_detected = 1'b1;
        $display("[%0t] Key 'F' pressed, waiting for complete debounce...", $time);
        
        // Wait for complete debounce
        for (cycle_count = 0; cycle_count < 200; cycle_count++) begin
            @(posedge clk);
            if (cycle_count % 20 == 0) begin
                display_inputs();
                display_state();
                display_outputs();
            end
            
            if (key_valid && dut.current_state == dut.KEY_HELD) begin
                $display("[%0t] *** DEBOUNCE COMPLETED! Key 'F' is now valid ***", $time);
                cycle_count = 200; // Exit loop
            end
            #(CLK_PERIOD/4);
        end
        
        // Release key
        key_detected = 1'b0;
        key_code = 4'h0;
        $display("[%0t] Key 'F' released...", $time);
        
        for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            #(CLK_PERIOD/4);
        end
        
        $display("\n==========================================");
        $display("DEBOUNCER TEST COMPLETE");
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
