`timescale 1ns / 1ps

module tb_keypad_debouncer;

    // Clock and Reset
    logic clk;
    logic rst_n;

    // DUT Inputs
    logic key_pressed;
    logic [3:0] row_idx;
    logic [3:0] col_idx;

    // DUT Outputs
    logic key_valid;
    logic [3:0] key_row;
    logic [3:0] key_col;

    // Instantiate the DUT
    keypad_debouncer dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_pressed(key_pressed),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_valid(key_valid),
        .key_row(key_row),
        .key_col(key_col)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #166.67 clk = ~clk; // 3MHz clock (333.33ns period)
    end

    // Test sequence
    initial begin
        $display("==========================================");
        $display("KEYPAD DEBOUNCER TESTBENCH");
        $display("Testing debouncer logic with proper stimulus");
        $display("==========================================");

        // Initialize inputs
        rst_n = 0;
        key_pressed = 0;
        row_idx = 4'b0000;
        col_idx = 4'b0000;

        // Apply reset
        $display("Applying reset...");
        repeat(10) @(posedge clk);
        rst_n = 1;
        repeat(10) @(posedge clk);
        
        $display("Reset complete. Starting test...");
        
        // Test 1: Verify initial state after reset
        $display("\n--- Test 1: Initial State After Reset ---");
        if (key_valid == 1'b0 && key_row == 4'b0000 && key_col == 4'b0000) begin
            $display("  ✓ Initial state correct: key_valid=%b, key_row=%b, key_col=%b", key_valid, key_row, key_col);
        end else begin
            $display("  ✗ Initial state FAIL: Expected key_valid=0, key_row=0000, key_col=0000, Got key_valid=%b, key_row=%b, key_col=%b", key_valid, key_row, key_col);
        end
        
        // Test 2: Key press detection and counter increment
        $display("\n--- Test 2: Key Press Detection and Counter Increment ---");
        $display("Pressing key at row 0, col 0...");
        
        key_pressed = 1;
        row_idx = 4'b0001;  // Row 0
        col_idx = 4'b0001;  // Col 0
        repeat(5) @(posedge clk);
        
        // Check that key_valid is still 0 (not enough time for debounce)
        if (key_valid == 1'b0) begin
            $display("  ✓ key_valid still 0 after 5 cycles: key_valid=%b", key_valid);
        end else begin
            $display("  ✗ key_valid should be 0 FAIL: Got key_valid=%b", key_valid);
        end
        
        // Check counter is incrementing
        $display("  Debounce counter: %0d (should be incrementing)", dut.debounce_cnt);
        
        // Test 3: Complete debounce period
        $display("\n--- Test 3: Complete Debounce Period ---");
        $display("Waiting for full debounce period (60000 cycles)...");
        
        // Wait for most of the debounce period
        repeat(59990) @(posedge clk);
        
        // Check counter is near completion
        $display("  Debounce counter near completion: %0d", dut.debounce_cnt);
        
        // Wait for the final cycles to complete debounce
        repeat(10) @(posedge clk);
        
        // Check that key_valid is now asserted
        if (key_valid == 1'b1 && key_row == 4'b0001 && key_col == 4'b0001) begin
            $display("  ✓ Debounce complete: key_valid=%b, key_row=%b, key_col=%b", key_valid, key_row, key_col);
        end else begin
            $display("  ✗ Debounce complete FAIL: Expected key_valid=1, key_row=0001, key_col=0001, Got key_valid=%b, key_row=%b, key_col=%b", key_valid, key_row, key_col);
        end
        
        // Test 4: Key release and reset
        $display("\n--- Test 4: Key Release and Reset ---");
        $display("Releasing key...");
        
        key_pressed = 0;
        row_idx = 4'b0000;
        col_idx = 4'b0000;
        repeat(5) @(posedge clk);
        
        // Check that everything resets
        if (key_valid == 1'b0 && key_row == 4'b0000 && key_col == 4'b0000) begin
            $display("  ✓ Reset after key release: key_valid=%b, key_row=%b, key_col=%b", key_valid, key_row, key_col);
        end else begin
            $display("  ✗ Reset after key release FAIL: Expected key_valid=0, key_row=0000, key_col=0000, Got key_valid=%b, key_row=%b, key_col=%b", key_valid, key_row, key_col);
        end
        
        // Test 5: New key press during debounce
        $display("\n--- Test 5: New Key Press During Debounce ---");
        $display("Pressing new key during debounce period...");
        
        // Start debouncing first key
        key_pressed = 1;
        row_idx = 4'b0001;  // Row 0
        col_idx = 4'b0001;  // Col 0
        repeat(1000) @(posedge clk);
        
        $display("  Debounce counter after 1000 cycles: %0d", dut.debounce_cnt);
        
        // Change to new key (different row/col)
        row_idx = 4'b0010;  // Row 1
        col_idx = 4'b0010;  // Col 1
        repeat(5) @(posedge clk);
        
        // Check that counter reset for new key
        if (dut.debounce_cnt < 100) begin
            $display("  ✓ Counter reset for new key: debounce_cnt=%0d", dut.debounce_cnt);
        end else begin
            $display("  ✗ Counter should reset for new key FAIL: debounce_cnt=%0d", dut.debounce_cnt);
        end
        
        // Complete debounce for new key
        repeat(60000) @(posedge clk);
        
        if (key_valid == 1'b1 && key_row == 4'b0010 && key_col == 4'b0010) begin
            $display("  ✓ New key debounced correctly: key_valid=%b, key_row=%b, key_col=%b", key_valid, key_row, key_col);
        end else begin
            $display("  ✗ New key debounce FAIL: Expected key_valid=1, key_row=0010, key_col=0010, Got key_valid=%b, key_row=%b, key_col=%b", key_valid, key_row, key_col);
        end
        
        // Test 6: Invalid key press (no row/col)
        $display("\n--- Test 6: Invalid Key Press (No Row/Col) ---");
        $display("Testing key_pressed=1 but no valid row/col...");
        
        key_pressed = 1;
        row_idx = 4'b0000;  // Invalid row
        col_idx = 4'b0000;  // Invalid col
        repeat(1000) @(posedge clk);
        
        // Check that debounce doesn't start for invalid key
        if (dut.debounce_cnt == 0 && key_valid == 1'b0) begin
            $display("  ✓ Invalid key ignored: debounce_cnt=%0d, key_valid=%b", dut.debounce_cnt, key_valid);
        end else begin
            $display("  ✗ Invalid key should be ignored FAIL: debounce_cnt=%0d, key_valid=%b", dut.debounce_cnt, key_valid);
        end
        
        // Test 7: Counter overflow protection
        $display("\n--- Test 7: Counter Overflow Protection ---");
        $display("Testing that counter doesn't overflow...");
        
        // Press valid key
        key_pressed = 1;
        row_idx = 4'b0001;
        col_idx = 4'b0001;
        
        // Wait for counter to reach max and verify it doesn't overflow
        repeat(60000) @(posedge clk);
        
        if (dut.debounce_cnt == 59998 && key_valid == 1'b1) begin
            $display("  ✓ Counter reached max without overflow: debounce_cnt=%0d, key_valid=%b", dut.debounce_cnt, key_valid);
        end else begin
            $display("  ✗ Counter overflow or wrong max FAIL: debounce_cnt=%0d, key_valid=%b", dut.debounce_cnt, key_valid);
        end
        
        $display("\n==========================================");
        $display("KEYPAD DEBOUNCER TEST COMPLETE");
        $display("All logic tests completed!");
        $display("==========================================");
        $stop;
    end

endmodule
