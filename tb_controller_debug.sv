// ============================================================================
// KEYPAD CONTROLLER TEST BENCH - DEBUG VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for keypad_controller module showing digit shifting behavior
// Tests state machine and digit register operations
// ============================================================================

`timescale 1ns/1ps

module tb_controller_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    
    // Clock and reset
    logic        clk;
    logic        rst_n;
    
    // Controller inputs
    logic [3:0]  key_code;
    logic        key_valid;
    
    // Controller outputs
    logic [3:0]  digit_left;
    logic [3:0]  digit_right;
    
    // Test control
    integer      test_count;
    integer      cycle_count;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    keypad_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
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
    // STATE DISPLAY TASKS
    // ========================================================================
    task display_state;
        case (dut.state)
            3'b000: $display("[%0t] CONTROLLER: State = IDLE (000)", $time);
            3'b001: $display("[%0t] CONTROLLER: State = KEY_HELD (001)", $time);
            default: $display("[%0t] CONTROLLER: State = UNKNOWN (%b)", $time, dut.state);
        endcase
    endtask
    
    task display_inputs;
        $display("[%0t] CONTROLLER: Inputs - Key_code = 0x%h, Key_valid = %b", 
                 $time, key_code, key_valid);
    endtask
    
    task display_outputs;
        $display("[%0t] CONTROLLER: Outputs - Digit_left = 0x%h, Digit_right = 0x%h", 
                 $time, digit_left, digit_right);
    endtask
    
    task display_registers;
        $display("[%0t] CONTROLLER: Registers - Left_reg = 0x%h, Right_reg = 0x%h, New_key = 0x%h", 
                 $time, dut.left_digit_reg, dut.right_digit_reg, dut.new_key);
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
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("KEYPAD CONTROLLER DEBUG TEST BENCH");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        key_code = 4'h0;
        key_valid = 1'b0;
        test_count = 0;
        cycle_count = 0;
        
        // Reset sequence
        $display("\n[%0t] Applying reset...", $time);
        #(CLK_PERIOD * 2);
        rst_n = 1;
        #(CLK_PERIOD);
        
        $display("\n[%0t] Reset released. Starting controller test...", $time);
        
        // Test 1: Initial state
        $display("\n--- TEST 1: Initial State ---");
        key_code = 4'h0;
        key_valid = 1'b0;
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            display_registers();
            #(CLK_PERIOD/4);
        end
        
        // Test 2: First key press (should go to left digit)
        $display("\n--- TEST 2: First Key Press (Key '5') ---");
        key_code = 4'h5;
        key_valid = 1'b1;
        $display("[%0t] Key '5' pressed - should go to left digit", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Hold key for a few cycles
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            display_registers();
            #(CLK_PERIOD/4);
        end
        
        // Release key
        key_valid = 1'b0;
        key_code = 4'h0;
        $display("[%0t] Key '5' released", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Test 3: Second key press (should shift left to right, new key to left)
        $display("\n--- TEST 3: Second Key Press (Key 'A') ---");
        key_code = 4'hA;
        key_valid = 1'b1;
        $display("[%0t] Key 'A' pressed - should shift '5' to right, 'A' to left", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Hold key for a few cycles
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            display_registers();
            #(CLK_PERIOD/4);
        end
        
        // Release key
        key_valid = 1'b0;
        key_code = 4'h0;
        $display("[%0t] Key 'A' released", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Test 4: Third key press (should shift again)
        $display("\n--- TEST 4: Third Key Press (Key '3') ---");
        key_code = 4'h3;
        key_valid = 1'b1;
        $display("[%0t] Key '3' pressed - should shift 'A' to right, '3' to left", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Hold key for a few cycles
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            display_registers();
            #(CLK_PERIOD/4);
        end
        
        // Release key
        key_valid = 1'b0;
        key_code = 4'h0;
        $display("[%0t] Key '3' released", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Test 5: Fourth key press (should shift again, '5' gets lost)
        $display("\n--- TEST 5: Fourth Key Press (Key 'F') ---");
        key_code = 4'hF;
        key_valid = 1'b1;
        $display("[%0t] Key 'F' pressed - should shift '3' to right, 'F' to left", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Hold key for a few cycles
        for (cycle_count = 0; cycle_count < 3; cycle_count++) begin
            @(posedge clk);
            display_inputs();
            display_state();
            display_outputs();
            display_registers();
            #(CLK_PERIOD/4);
        end
        
        // Release key
        key_valid = 1'b0;
        key_code = 4'h0;
        $display("[%0t] Key 'F' released", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Test 6: Key press while key is held (should be ignored)
        $display("\n--- TEST 6: Key Press While Key Held (Should Be Ignored) ---");
        key_code = 4'h7;
        key_valid = 1'b1;
        $display("[%0t] Key '7' pressed while 'F' is held - should be ignored", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Try another key while first is still held
        key_code = 4'h2;
        key_valid = 1'b1;
        $display("[%0t] Key '2' pressed while '7' is held - should be ignored", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Release all keys
        key_valid = 1'b0;
        key_code = 4'h0;
        $display("[%0t] All keys released", $time);
        
        @(posedge clk);
        display_inputs();
        display_state();
        display_outputs();
        display_registers();
        
        // Test 7: Rapid key presses
        $display("\n--- TEST 7: Rapid Key Presses ---");
        $display("[%0t] Testing rapid key presses: 1, 2, 3, 4", $time);
        
        // Key 1
        key_code = 4'h1; key_valid = 1'b1;
        @(posedge clk);
        display_inputs(); display_state(); display_outputs(); display_registers();
        key_valid = 1'b0; key_code = 4'h0;
        @(posedge clk);
        
        // Key 2
        key_code = 4'h2; key_valid = 1'b1;
        @(posedge clk);
        display_inputs(); display_state(); display_outputs(); display_registers();
        key_valid = 1'b0; key_code = 4'h0;
        @(posedge clk);
        
        // Key 3
        key_code = 4'h3; key_valid = 1'b1;
        @(posedge clk);
        display_inputs(); display_state(); display_outputs(); display_registers();
        key_valid = 1'b0; key_code = 4'h0;
        @(posedge clk);
        
        // Key 4
        key_code = 4'h4; key_valid = 1'b1;
        @(posedge clk);
        display_inputs(); display_state(); display_outputs(); display_registers();
        key_valid = 1'b0; key_code = 4'h0;
        @(posedge clk);
        
        display_inputs(); display_state(); display_outputs(); display_registers();
        
        // Test 8: Reset during operation
        $display("\n--- TEST 8: Reset During Operation ---");
        key_code = 4'h9; key_valid = 1'b1;
        @(posedge clk);
        display_inputs(); display_state(); display_outputs(); display_registers();
        
        $display("[%0t] Applying reset during key press...", $time);
        rst_n = 0;
        @(posedge clk);
        display_inputs(); display_state(); display_outputs(); display_registers();
        
        rst_n = 1;
        @(posedge clk);
        display_inputs(); display_state(); display_outputs(); display_registers();
        
        $display("\n==========================================");
        $display("CONTROLLER TEST COMPLETE");
        $display("==========================================");
        $finish;
    end
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    initial begin
        $monitor("[%0t] CLK=%b RST=%b KEY_CODE=0x%h KEY_VAL=%b DIGIT_L=0x%h DIGIT_R=0x%h", 
                 $time, clk, rst_n, key_code, key_valid, digit_left, digit_right);
    end
    
    // ========================================================================
    // WAVEFORM DUMP
    // ========================================================================
    initial begin
        $dumpfile("tb_controller_debug.vcd");
        $dumpvars(0, tb_controller_debug);
    end

endmodule
