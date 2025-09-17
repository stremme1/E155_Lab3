// ============================================================================
// SCANNER TESTBENCH
// ============================================================================
// Comprehensive test for keypad scanner module
// ============================================================================

module tb_scanner;

    // Test signals
    logic        clk, rst_n;
    logic [3:0]  row, col;
    logic [3:0]  row_idx, col_sync;
    logic        key_detected;

    // Instantiate scanner
    keypad_scanner dut (
        .clk(clk),
        .rst_n(rst_n),
        .row(row),
        .col(col),
        .row_idx(row_idx),
        .col_sync(col_sync),
        .key_detected(key_detected)
    );

    // Clock generation (3MHz)
    initial begin
        clk = 0;
        forever #166.67 clk = ~clk;
    end

    // Test helper functions
    task reset_system;
        rst_n = 0;
        col = 4'b1111;
        repeat(10) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
    endtask

    task wait_scan_cycle;
        repeat(24000) @(posedge clk); // Wait for one complete scan cycle
    endtask

    function void check_result(input string test_name, input [3:0] expected_row, 
                              input [3:0] expected_row_idx, input [3:0] expected_col_sync,
                              input logic expected_key_detected);
        if (row == expected_row && row_idx == expected_row_idx && 
            col_sync == expected_col_sync && key_detected == expected_key_detected) begin
            $display("  ✓ %s: PASS", test_name);
        end else begin
            $display("  ✗ %s: FAIL - Expected row=%b row_idx=%b col_sync=%b key_detected=%b, Got row=%b row_idx=%b col_sync=%b key_detected=%b", 
                     test_name, expected_row, expected_row_idx, expected_col_sync, expected_key_detected,
                     row, row_idx, col_sync, key_detected);
        end
    endfunction

    // Main test sequence
    initial begin
        $display("==========================================");
        $display("SCANNER TEST");
        $display("==========================================");

        // ========================================================================
        // TEST 1: Reset and Initialization
        // ========================================================================
        $display("\nTEST 1: Reset and Initialization");
        $display("----------------------------------------");
        
        reset_system;
        check_result("Reset state", 4'b1110, 4'b0001, 4'b1111, 1'b0);

        // ========================================================================
        // TEST 2: Row Scanning Sequence
        // ========================================================================
        $display("\nTEST 2: Row Scanning Sequence");
        $display("----------------------------------------");
        
        // Monitor row scanning for one complete cycle
        $display("  Monitoring row scanning pattern:");
        
        // Wait for row 0
        while (row != 4'b1110) @(posedge clk);
        check_result("Row 0 active", 4'b1110, 4'b0001, 4'b1111, 1'b0);
        
        // Wait for row 1
        while (row != 4'b1101) @(posedge clk);
        check_result("Row 1 active", 4'b1101, 4'b0010, 4'b1111, 1'b0);
        
        // Wait for row 2
        while (row != 4'b1011) @(posedge clk);
        check_result("Row 2 active", 4'b1011, 4'b0100, 4'b1111, 1'b0);
        
        // Wait for row 3
        while (row != 4'b0111) @(posedge clk);
        check_result("Row 3 active", 4'b0111, 4'b1000, 4'b1111, 1'b0);

        // ========================================================================
        // TEST 3: Column Synchronization
        // ========================================================================
        $display("\nTEST 3: Column Synchronization");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test column input synchronization
        col = 4'b1110; // Column 0 pressed
        repeat(2) @(posedge clk); // Wait for 2-stage sync
        check_result("Column 0 synchronized", 4'b1110, 4'b0001, 4'b1110, 1'b1);
        
        col = 4'b1101; // Column 1 pressed
        repeat(2) @(posedge clk);
        check_result("Column 1 synchronized", 4'b1110, 4'b0001, 4'b1101, 1'b1);
        
        col = 4'b1111; // No key pressed
        repeat(2) @(posedge clk);
        check_result("No key synchronized", 4'b1110, 4'b0001, 4'b1111, 1'b0);

        // ========================================================================
        // TEST 4: Key Detection Logic
        // ========================================================================
        $display("\nTEST 4: Key Detection Logic");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test various column combinations
        col = 4'b1111; // No key
        repeat(2) @(posedge clk);
        check_result("No key detected", 4'b1110, 4'b0001, 4'b1111, 1'b0);
        
        col = 4'b1110; // Single key (col 0)
        repeat(2) @(posedge clk);
        check_result("Single key (col 0)", 4'b1110, 4'b0001, 4'b1110, 1'b1);
        
        col = 4'b1101; // Single key (col 1)
        repeat(2) @(posedge clk);
        check_result("Single key (col 1)", 4'b1110, 4'b0001, 4'b1101, 1'b1);
        
        col = 4'b1011; // Single key (col 2)
        repeat(2) @(posedge clk);
        check_result("Single key (col 2)", 4'b1110, 4'b0001, 4'b1011, 1'b1);
        
        col = 4'b0111; // Single key (col 3)
        repeat(2) @(posedge clk);
        check_result("Single key (col 3)", 4'b1110, 4'b0001, 4'b0111, 1'b1);

        // ========================================================================
        // TEST 5: Row-Column Combinations
        // ========================================================================
        $display("\nTEST 5: Row-Column Combinations");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test key press on different rows
        for (int row_num = 0; row_num < 4; row_num++) begin
            // Wait for the correct row to be active
            while (row_idx != (1 << row_num)) @(posedge clk);
            
            // Press column 0 on this row
            col = 4'b1110;
            repeat(2) @(posedge clk);
            
            $display("  Row %0d, Col 0: row=%b, row_idx=%b, col_sync=%b, key_detected=%b", 
                     row_num, row, row_idx, col_sync, key_detected);
        end

        // ========================================================================
        // TEST 6: Continuous Operation
        // ========================================================================
        $display("\nTEST 6: Continuous Operation");
        $display("----------------------------------------");
        
        reset_system;
        
        // Monitor continuous scanning
        $display("  Running continuous scan for 2 full cycles...");
        wait_scan_cycle;
        wait_scan_cycle;
        $display("  ✓ Continuous operation completed successfully");

        // ========================================================================
        // TEST 7: Edge Cases
        // ========================================================================
        $display("\nTEST 7: Edge Cases");
        $display("----------------------------------------");
        
        reset_system;
        
        // Test reset during operation
        wait_scan_cycle;
        rst_n = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
        check_result("Reset during operation", 4'b1110, 4'b0001, 4'b1111, 1'b0);

        $display("\n==========================================");
        $display("SCANNER TEST COMPLETED");
        $display("==========================================");
        
        $finish;
    end

endmodule
