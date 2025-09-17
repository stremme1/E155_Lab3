// ============================================================================
// CONTROLLER TESTBENCH
// ============================================================================
// Comprehensive test for keypad controller module
// ============================================================================

module tb_controller;

    // Test signals
    logic        clk, rst_n;
    logic [3:0]  key_code;
    logic        key_valid;
    logic [3:0]  digit_left, digit_right;

    // Instantiate controller
    keypad_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

    // Clock generation (3MHz)
    initial begin
        clk = 0;
        forever #166.67 clk = ~clk;
    end

    // Test helper functions
    task reset_system;
        rst_n = 0;
        key_code = 4'b0000;
        key_valid = 0;
        repeat(10) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
    endtask

    task simulate_key_press(input [3:0] key);
        key_valid = 1;
        key_code = key;
    endtask

    task simulate_key_release;
        key_valid = 0;
        key_code = 4'b0000;
    endtask

    function void check_result(input string test_name, input [3:0] expected_left, 
                              input [3:0] expected_right);
        if (digit_left == expected_left && digit_right == expected_right) begin
            $display("  ✓ %s: PASS", test_name);
        end else begin
            $display("  ✗ %s: FAIL - Expected left=%b right=%b, Got left=%b right=%b", 
                     test_name, expected_left, expected_right, digit_left, digit_right);
        end
    endfunction

    // Main test sequence
    initial begin
        $display("==========================================");
        $display("CONTROLLER TEST");
        $display("==========================================");

        // ========================================================================
        // TEST 1: Reset and Initialization
        // ========================================================================
        $display("\nTEST 1: Reset and Initialization");
        $display("----------------------------------------");
        
        reset_system;
        check_result("Reset state", 4'b0000, 4'b0000);

        // ========================================================================
        // TEST 2: Single Key Press and Release
        // ========================================================================
        $display("\nTEST 2: Single Key Press and Release");
        $display("----------------------------------------");
        
        // Press key '1'
        simulate_key_press(4'b0001);
        repeat(5) @(posedge clk);
        check_result("Key '1' pressed (no change)", 4'b0000, 4'b0000);
        
        // Release key '1' (should shift digits)
        simulate_key_release;
        repeat(5) @(posedge clk);
        check_result("Key '1' released (digits shift)", 4'b0001, 4'b0000);

        // ========================================================================
        // TEST 3: Multiple Key Sequence
        // ========================================================================
        $display("\nTEST 3: Multiple Key Sequence");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test sequence: 1, 2, 3, 4
        for (int i = 1; i <= 4; i++) begin
            simulate_key_press(i);
            repeat(5) @(posedge clk);
            
            $display("  Key %0d pressed: digit_left=%b, digit_right=%b", i, digit_left, digit_right);
            
            simulate_key_release;
            repeat(5) @(posedge clk);
            
            $display("  Key %0d released: digit_left=%b, digit_right=%b", i, digit_left, digit_right);
        end

        // ========================================================================
        // TEST 4: State Machine Verification
        // ========================================================================
        $display("\nTEST 4: State Machine Verification");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test state transitions
        simulate_key_press(4'b0001);
        repeat(5) @(posedge clk);
        $display("  IDLE → KEY_PRESSED: digit_left=%b, digit_right=%b", digit_left, digit_right);
        
        simulate_key_release;
        repeat(5) @(posedge clk);
        $display("  KEY_PRESSED → KEY_RELEASED → SHIFT_DIGITS: digit_left=%b, digit_right=%b", digit_left, digit_right);

        // ========================================================================
        // TEST 5: Edge Cases
        // ========================================================================
        $display("\nTEST 5: Edge Cases");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test reset during key press
        simulate_key_press(4'b0001);
        repeat(5) @(posedge clk);
        rst_n = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
        check_result("Reset during key press", 4'b0000, 4'b0000);

        // ========================================================================
        // TEST 6: Continuous Operation
        // ========================================================================
        $display("\nTEST 6: Continuous Operation");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test continuous key presses
        for (int i = 0; i < 8; i++) begin
            simulate_key_press(i);
            repeat(5) @(posedge clk);
            simulate_key_release;
            repeat(5) @(posedge clk);
            
            if (i % 2 == 0) begin
                $display("  Cycle %0d: digit_left=%b, digit_right=%b", i, digit_left, digit_right);
            end
        end

        $display("\n==========================================");
        $display("CONTROLLER TEST COMPLETED");
        $display("==========================================");
        
        $finish;
    end

endmodule
