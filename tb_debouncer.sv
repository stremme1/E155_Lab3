// ============================================================================
// DEBOUNCER TESTBENCH
// ============================================================================
// Comprehensive test for keypad debouncer module
// ============================================================================

module tb_debouncer;

    // Test signals
    logic        clk, rst_n;
    logic [3:0]  key_code;
    logic        key_detected;
    logic        key_valid;
    logic [3:0]  debounced_key;
    logic        scan_stop;

    // Instantiate debouncer
    keypad_debouncer dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
        .key_detected(key_detected),
        .key_valid(key_valid),
        .debounced_key(debounced_key),
        .scan_stop(scan_stop)
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
        key_detected = 0;
        repeat(10) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
    endtask

    task wait_debounce_period;
        repeat(60000) @(posedge clk); // ~20ms @ 3MHz
    endtask

    task simulate_key_press(input [3:0] key);
        key_detected = 1;
        key_code = key;
    endtask

    task simulate_key_release;
        key_detected = 0;
        key_code = 4'b0000;
    endtask

    function void check_result(input string test_name, input logic expected_valid, 
                              input [3:0] expected_key);
        if (key_valid == expected_valid && debounced_key == expected_key) begin
            $display("  ✓ %s: PASS", test_name);
        end else begin
            $display("  ✗ %s: FAIL - Expected valid=%b key=%b, Got valid=%b key=%b", 
                     test_name, expected_valid, expected_key, key_valid, debounced_key);
        end
    endfunction

    // Main test sequence
    initial begin
        $display("==========================================");
        $display("DEBOUNCER TEST");
        $display("==========================================");

        // ========================================================================
        // TEST 1: Reset and Initialization
        // ========================================================================
        $display("\nTEST 1: Reset and Initialization");
        $display("----------------------------------------");
        
        reset_system;
        check_result("Reset state", 1'b0, 4'b0000);

        // ========================================================================
        // TEST 2: Basic Key Press and Debouncing
        // ========================================================================
        $display("\nTEST 2: Basic Key Press and Debouncing");
        $display("----------------------------------------");
        
        // Press key '1'
        simulate_key_press(4'b0001);
        wait_debounce_period;
        @(posedge clk); // One more cycle for output update
        check_result("Key '1' debounced", 1'b1, 4'b0001);
        
        // Release key
        simulate_key_release;
        repeat(1000) @(posedge clk);
        check_result("Key '1' released", 1'b0, 4'b0000);

        // ========================================================================
        // TEST 3: Multiple Key Presses
        // ========================================================================
        $display("\nTEST 3: Multiple Key Presses");
        $display("----------------------------------------");
        
        for (int i = 1; i <= 4; i++) begin
            simulate_key_press(i);
            wait_debounce_period;
            @(posedge clk);
            check_result($sformatf("Key '%0d' debounced", i), 1'b1, i);
            
            simulate_key_release;
            repeat(1000) @(posedge clk);
            check_result($sformatf("Key '%0d' released", i), 1'b0, 4'b0000);
        end

        // ========================================================================
        // TEST 4: Ghosting Protection
        // ========================================================================
        $display("\nTEST 4: Ghosting Protection");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test invalid key code
        simulate_key_press(4'b0000);
        wait_debounce_period;
        @(posedge clk);
        check_result("Invalid key code", 1'b0, 4'b0000);

        // ========================================================================
        // TEST 5: Rapid Key Changes
        // ========================================================================
        $display("\nTEST 5: Rapid Key Changes");
        $display("----------------------------------------");
        
        reset_system;
        
        // Rapid key changes before debounce completes
        simulate_key_press(4'b0001);
        repeat(1000) @(posedge clk);
        simulate_key_press(4'b0010);
        repeat(1000) @(posedge clk);
        simulate_key_press(4'b0011);
        wait_debounce_period;
        @(posedge clk);
        
        $display("  After rapid key changes:");
        $display("    key_valid=%b, debounced_key=%b", key_valid, debounced_key);

        // ========================================================================
        // TEST 6: Edge Cases
        // ========================================================================
        $display("\nTEST 6: Edge Cases");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test reset during debouncing
        simulate_key_press(4'b0001);
        repeat(1000) @(posedge clk);
        rst_n = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
        check_result("Reset during debouncing", 1'b0, 4'b0000);

        $display("\n==========================================");
        $display("DEBOUNCER TEST COMPLETED");
        $display("==========================================");
        
        $finish;
    end

endmodule
