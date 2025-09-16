`timescale 1ns / 1ps

module tb_keypad_scanner;

    // Clock and Reset
    logic clk;
    logic rst_n;

    // DUT Inputs
    logic key_valid;
    logic [3:0] col;

    // DUT Outputs
    logic [3:0] row;
    logic [3:0] row_idx;
    logic [3:0] col_idx;
    logic key_pressed;

    // Instantiate the DUT
    keypad_scanner dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_valid(key_valid),
        .row(row),
        .col(col),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_pressed(key_pressed)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #166.67 clk = ~clk; // 3MHz clock (333.33ns period)
    end

    // Test sequence
    initial begin
        $display("==========================================");
        $display("KEYPAD SCANNER TESTBENCH");
        $display("Testing scanner logic with proper stimulus");
        $display("==========================================");

        // Initialize inputs
        rst_n = 0;
        key_valid = 0;
        col = 4'b1111; // No key pressed

        // Apply reset
        $display("Applying reset...");
        repeat(10) @(posedge clk);
        rst_n = 1;
        repeat(10) @(posedge clk);
        
        $display("Reset complete. Starting test...");
        
        // Test 1: Verify continuous row scanning
        $display("\n--- Test 1: Continuous Row Scanning ---");
        $display("Monitoring row transitions over multiple scan periods...");
        
        // Check initial state right after reset
        $display("Initial state after reset: Rows=%b, Row_idx=%b, Scan_state=%0d", row, row_idx, dut.scan_state);
        
        // Wait for a few scan periods and verify row transitions
        for (int scan_cycle = 0; scan_cycle < 3; scan_cycle++) begin
            $display("Scan cycle %0d:", scan_cycle);
            
            // Check each row as it becomes active
            for (int expected_row = 0; expected_row < 4; expected_row++) begin
                // Wait for scan period (6000 cycles) then check the NEXT row
                repeat(6000) @(posedge clk);
                
                // Verify the correct row is active (after 6000 cycles, we should be on the next row)
                case (expected_row)
                    0: begin
                        if (row == 4'b1101 && row_idx == 4'b0010) begin
                            $display("  ✓ Row 1: Rows=%b, Row_idx=%b (after Row 0 period)", row, row_idx);
                        end else begin
                            $display("  ✗ Row 1 FAIL: Expected Rows=1101, Row_idx=0010, Got Rows=%b, Row_idx=%b", row, row_idx);
                        end
                    end
                    1: begin
                        if (row == 4'b1011 && row_idx == 4'b0100) begin
                            $display("  ✓ Row 2: Rows=%b, Row_idx=%b (after Row 1 period)", row, row_idx);
                        end else begin
                            $display("  ✗ Row 2 FAIL: Expected Rows=1011, Row_idx=0100, Got Rows=%b, Row_idx=%b", row, row_idx);
                        end
                    end
                    2: begin
                        if (row == 4'b0111 && row_idx == 4'b1000) begin
                            $display("  ✓ Row 3: Rows=%b, Row_idx=%b (after Row 2 period)", row, row_idx);
                        end else begin
                            $display("  ✗ Row 3 FAIL: Expected Rows=0111, Row_idx=1000, Got Rows=%b, Row_idx=%b", row, row_idx);
                        end
                    end
                    3: begin
                        if (row == 4'b1110 && row_idx == 4'b0001) begin
                            $display("  ✓ Row 0: Rows=%b, Row_idx=%b (after Row 3 period - wrapped around)", row, row_idx);
                        end else begin
                            $display("  ✗ Row 0 FAIL: Expected Rows=1110, Row_idx=0001, Got Rows=%b, Row_idx=%b", row, row_idx);
                        end
                    end
                endcase
            end
        end
        
        // Test 2: Key detection logic
        $display("\n--- Test 2: Key Detection Logic ---");
        
        // Wait for row 0 to be active
        wait(row == 4'b1110);
        $display("Row 0 is active, testing key detection...");
        
        // Test single key press (col 0)
        col = 4'b1110; // Pull column 0 low
        repeat(5) @(posedge clk); // Wait for synchronization
        
        if (key_pressed == 1'b1 && col_idx == 4'b0001) begin
            $display("  ✓ Single key detection: Key_pressed=%b, Col_idx=%b", key_pressed, col_idx);
        end else begin
            $display("  ✗ Single key detection FAIL: Expected Key_pressed=1, Col_idx=0001, Got Key_pressed=%b, Col_idx=%b", key_pressed, col_idx);
        end
        
        // Test multiple key press (should be rejected)
        col = 4'b1100; // Pull columns 0 and 1 low
        repeat(5) @(posedge clk);
        
        if (key_pressed == 1'b0 && col_idx == 4'b0000) begin
            $display("  ✓ Multiple key rejection: Key_pressed=%b, Col_idx=%b", key_pressed, col_idx);
        end else begin
            $display("  ✗ Multiple key rejection FAIL: Expected Key_pressed=0, Col_idx=0000, Got Key_pressed=%b, Col_idx=%b", key_pressed, col_idx);
        end
        
        // Test 3: Hold logic when key is detected
        $display("\n--- Test 3: Hold Logic ---");
        
        // Wait for row 0 to be active again
        col = 4'b1111; // Release all keys
        repeat(10) @(posedge clk);
        wait(row == 4'b1110);
        
        $display("Row 0 active, pressing key to test hold logic...");
        col = 4'b1110; // Press key in row 0, col 0
        repeat(5) @(posedge clk);
        
        // Verify key is detected and scanner holds
        if (dut.key_detected == 1'b1 && dut.held_state == 2'd0) begin
            $display("  ✓ Key detected and state held: Key_detected=%b, Held_state=%0d", dut.key_detected, dut.held_state);
        end else begin
            $display("  ✗ Hold logic FAIL: Expected Key_detected=1, Held_state=0, Got Key_detected=%b, Held_state=%0d", dut.key_detected, dut.held_state);
        end
        
        // Wait for several scan periods and verify scanner is still on row 0
        repeat(12000) @(posedge clk); // 2 scan periods
        
        if (row == 4'b1110 && row_idx == 4'b0001) begin
            $display("  ✓ Scanner held on row 0 during key press: Rows=%b, Row_idx=%b", row, row_idx);
        end else begin
            $display("  ✗ Scanner did not hold FAIL: Expected Rows=1110, Row_idx=0001, Got Rows=%b, Row_idx=%b", row, row_idx);
        end
        
        // Test 4: Resume scanning after key release
        $display("\n--- Test 4: Resume Scanning After Key Release ---");
        
        col = 4'b1111; // Release key
        repeat(5) @(posedge clk);
        
        if (dut.key_detected == 1'b0) begin
            $display("  ✓ Key detection cleared after release: Key_detected=%b", dut.key_detected);
        end else begin
            $display("  ✗ Key detection not cleared FAIL: Expected Key_detected=0, Got Key_detected=%b", dut.key_detected);
        end
        
        // After key release, scanner should stay on the same row (row 0) and then continue normal scanning
        if (row == 4'b1110 && row_idx == 4'b0001) begin
            $display("  ✓ Scanner stayed on row 0 after key release: Rows=%b, Row_idx=%b", row, row_idx);
        end else begin
            $display("  ✗ Scanner did not stay on row 0 FAIL: Expected Rows=1110, Row_idx=0001, Got Rows=%b, Row_idx=%b", row, row_idx);
        end
        
        // Wait for scanner to continue normal scanning and move to next row
        repeat(6000) @(posedge clk); // One scan period
        
        if (row == 4'b1101 && row_idx == 4'b0010) begin
            $display("  ✓ Scanner continued normal scanning to row 1: Rows=%b, Row_idx=%b", row, row_idx);
        end else begin
            $display("  ✗ Scanner continue scanning FAIL: Expected Rows=1101, Row_idx=0010, Got Rows=%b, Row_idx=%b", row, row_idx);
        end
        
        // Test 5: Resume scanning after key_valid assertion
        $display("\n--- Test 5: Resume Scanning After key_valid ---");
        
        // Wait for row 0 to be active again
        wait(row == 4'b1110);
        col = 4'b1110; // Press key
        repeat(5) @(posedge clk);
        
        // Simulate debouncer completing
        key_valid = 1;
        @(posedge clk);
        key_valid = 0;
        
        if (dut.key_detected == 1'b0) begin
            $display("  ✓ Key detection cleared after key_valid: Key_detected=%b", dut.key_detected);
        end else begin
            $display("  ✗ Key detection not cleared after key_valid FAIL: Expected Key_detected=0, Got Key_detected=%b", dut.key_detected);
        end
        
        // Wait for scanner to resume
        repeat(6000) @(posedge clk);
        
        if (row == 4'b1101 && row_idx == 4'b0010) begin
            $display("  ✓ Scanner resumed after key_valid: Rows=%b, Row_idx=%b", row, row_idx);
        end else begin
            $display("  ✗ Scanner resume after key_valid FAIL: Expected Rows=1101, Row_idx=0010, Got Rows=%b, Row_idx=%b", row, row_idx);
        end
        
        $display("\n==========================================");
        $display("KEYPAD SCANNER TEST COMPLETE");
        $display("All logic tests completed!");
        $display("==========================================");
        $stop;
    end

endmodule