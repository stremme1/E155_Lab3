// ============================================================================
// TOP MODULE TESTBENCH
// ============================================================================
// Comprehensive test for lab3_top module (simulation version)
// ============================================================================

module tb_top;

    // Test signals
    logic        clk, rst_n;
    logic [3:0]  keypad_rows, keypad_cols;
    logic [6:0]  seg;
    logic        select0, select1;
    
    // Test arrays
    logic [3:0]  test_keys [3];
    logic [3:0]  test_cols [3];

    // Instantiate top module (simulation version)
    lab3_top_sim dut (
        .reset(rst_n),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .seg(seg),
        .select0(select0),
        .select1(select1)
    );

    // Clock generation (3MHz)
    initial begin
        clk = 0;
        forever #166.67 clk = ~clk;
    end

    // Test helper functions
    task reset_system;
        rst_n = 0;
        keypad_cols = 4'b1111;
        repeat(10) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
    endtask

    task wait_debounce_period;
        repeat(60000) @(posedge clk); // ~20ms @ 3MHz
    endtask

    task simulate_key_press(input [3:0] row, input [3:0] col);
        // Wait for scanner to be on the correct row
        while (keypad_rows != row) @(posedge clk);
        keypad_cols = col;
    endtask

    task simulate_key_release;
        keypad_cols = 4'b1111;
    endtask

    function void check_display(input string test_name, input [6:0] expected_seg);
        if (seg == expected_seg) begin
            $display("  ✓ %s: PASS - seg=%b", test_name, seg);
        end else begin
            $display("  ✗ %s: FAIL - Expected seg=%b, Got seg=%b", test_name, expected_seg, seg);
        end
    endfunction

    // Main test sequence
    initial begin
        $display("==========================================");
        $display("TOP MODULE TEST");
        $display("==========================================");

        // ========================================================================
        // TEST 1: Reset and Initialization
        // ========================================================================
        $display("\nTEST 1: Reset and Initialization");
        $display("----------------------------------------");
        
        reset_system;
        $display("  After reset:");
        $display("    keypad_rows=%b, keypad_cols=%b", keypad_rows, keypad_cols);
        $display("    seg=%b, select0=%b, select1=%b", seg, select0, select1);

        // ========================================================================
        // TEST 2: Scanner Row Cycling
        // ========================================================================
        $display("\nTEST 2: Scanner Row Cycling");
        $display("----------------------------------------");
        
        $display("  Monitoring scanner row cycling...");
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            if (i % 2 == 0) begin
                $display("    Cycle %0d: row=%b", i/2, keypad_rows);
            end
        end

        // ========================================================================
        // TEST 3: Single Key Press (Key '1')
        // ========================================================================
        $display("\nTEST 3: Single Key Press (Key '1')");
        $display("----------------------------------------");
        
        // Press key '1' (row 0, col 0)
        simulate_key_press(4'b1110, 4'b1110);
        wait_debounce_period;
        @(posedge clk);
        
        $display("  After key '1' pressed:");
        $display("    keypad_rows=%b, keypad_cols=%b", keypad_rows, keypad_cols);
        $display("    seg=%b, select0=%b, select1=%b", seg, select0, select1);
        
        // Release key
        simulate_key_release;
        repeat(1000) @(posedge clk);
        
        $display("  After key '1' released:");
        $display("    seg=%b, select0=%b, select1=%b", seg, select0, select1);

        // ========================================================================
        // TEST 4: Multiple Key Sequence
        // ========================================================================
        $display("\nTEST 4: Multiple Key Sequence");
        $display("----------------------------------------");
        
        // Test sequence: 1, 2, 3
        test_keys[0] = 4'b1110; test_keys[1] = 4'b1101; test_keys[2] = 4'b1011; // Rows for keys 1,2,3
        test_cols[0] = 4'b1110; test_cols[1] = 4'b1110; test_cols[2] = 4'b1110; // Col 0 for all
        
        for (int i = 0; i < 3; i++) begin
            simulate_key_press(test_keys[i], test_cols[i]);
            wait_debounce_period;
            @(posedge clk);
            
            $display("  Key %0d pressed: seg=%b", i+1, seg);
            
            simulate_key_release;
            repeat(1000) @(posedge clk);
            
            $display("  Key %0d released: seg=%b", i+1, seg);
        end

        // ========================================================================
        // TEST 5: Display Multiplexing
        // ========================================================================
        $display("\nTEST 5: Display Multiplexing");
        $display("----------------------------------------");
        
        // Monitor display multiplexing
        $display("  Monitoring display multiplexing...");
        for (int i = 0; i < 20; i++) begin
            @(posedge clk);
            if (i % 5 == 0) begin
                $display("    Cycle %0d: seg=%b, select0=%b, select1=%b", i, seg, select0, select1);
            end
        end

        // ========================================================================
        // TEST 6: System Integration
        // ========================================================================
        $display("\nTEST 6: System Integration");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test complete system workflow
        $display("  Testing complete system workflow...");
        
        // Press key '5' (row 1, col 1)
        simulate_key_press(4'b1101, 4'b1101);
        wait_debounce_period;
        @(posedge clk);
        
        $display("  Key '5' pressed: seg=%b", seg);
        
        simulate_key_release;
        repeat(1000) @(posedge clk);
        
        $display("  Key '5' released: seg=%b", seg);

        // ========================================================================
        // TEST 7: Edge Cases
        // ========================================================================
        $display("\nTEST 7: Edge Cases");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test reset during operation
        simulate_key_press(4'b1110, 4'b1110);
        repeat(1000) @(posedge clk);
        rst_n = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
        
        $display("  After reset during operation:");
        $display("    seg=%b, select0=%b, select1=%b", seg, select0, select1);

        $display("\n==========================================");
        $display("TOP MODULE TEST COMPLETED");
        $display("==========================================");
        
        $finish;
    end

endmodule
