// ============================================================================
// DECODER TESTBENCH
// ============================================================================
// Comprehensive test for keypad decoder module
// ============================================================================

module tb_decoder;

    // Test signals
    logic [3:0]  row_onehot, col_onehot;
    logic [3:0]  key_code;

    // Instantiate decoder
    keypad_decoder dut (
        .row_onehot(row_onehot),
        .col_onehot(col_onehot),
        .key_code(key_code)
    );

    // Test helper functions
    function void check_result(input string test_name, input [3:0] expected_key);
        if (key_code == expected_key) begin
            $display("  ✓ %s: PASS", test_name);
        end else begin
            $display("  ✗ %s: FAIL - Expected key=%b, Got key=%b", 
                     test_name, expected_key, key_code);
        end
    endfunction

    // Test variables
    logic [3:0] expected_key;

    // Main test sequence
    initial begin
        $display("==========================================");
        $display("DECODER TEST");
        $display("==========================================");

        // ========================================================================
        // TEST 1: No Key Pressed
        // ========================================================================
        $display("\nTEST 1: No Key Pressed");
        $display("----------------------------------------");
        
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        #1; // Small delay for combinational logic
        check_result("No key pressed", 4'b0000);

        // ========================================================================
        // TEST 2: Row 0 Keys (1, 2, 3, A)
        // ========================================================================
        $display("\nTEST 2: Row 0 Keys (1, 2, 3, A)");
        $display("----------------------------------------");
        
        row_onehot = 4'b0001; // Row 0
        
        col_onehot = 4'b0001; // Col 0
        #1;
        check_result("Key '1' (row 0, col 0)", 4'b0001);
        
        col_onehot = 4'b0010; // Col 1
        #1;
        check_result("Key '2' (row 0, col 1)", 4'b0010);
        
        col_onehot = 4'b0100; // Col 2
        #1;
        check_result("Key '3' (row 0, col 2)", 4'b0011);
        
        col_onehot = 4'b1000; // Col 3
        #1;
        check_result("Key 'A' (row 0, col 3)", 4'b1010);

        // ========================================================================
        // TEST 3: Row 1 Keys (4, 5, 6, B)
        // ========================================================================
        $display("\nTEST 3: Row 1 Keys (4, 5, 6, B)");
        $display("----------------------------------------");
        
        row_onehot = 4'b0010; // Row 1
        
        col_onehot = 4'b0001; // Col 0
        #1;
        check_result("Key '4' (row 1, col 0)", 4'b0100);
        
        col_onehot = 4'b0010; // Col 1
        #1;
        check_result("Key '5' (row 1, col 1)", 4'b0101);
        
        col_onehot = 4'b0100; // Col 2
        #1;
        check_result("Key '6' (row 1, col 2)", 4'b0110);
        
        col_onehot = 4'b1000; // Col 3
        #1;
        check_result("Key 'B' (row 1, col 3)", 4'b1011);

        // ========================================================================
        // TEST 4: Row 2 Keys (7, 8, 9, C)
        // ========================================================================
        $display("\nTEST 4: Row 2 Keys (7, 8, 9, C)");
        $display("----------------------------------------");
        
        row_onehot = 4'b0100; // Row 2
        
        col_onehot = 4'b0001; // Col 0
        #1;
        check_result("Key '7' (row 2, col 0)", 4'b0111);
        
        col_onehot = 4'b0010; // Col 1
        #1;
        check_result("Key '8' (row 2, col 1)", 4'b1000);
        
        col_onehot = 4'b0100; // Col 2
        #1;
        check_result("Key '9' (row 2, col 2)", 4'b1001);
        
        col_onehot = 4'b1000; // Col 3
        #1;
        check_result("Key 'C' (row 2, col 3)", 4'b1100);

        // ========================================================================
        // TEST 5: Row 3 Keys (0, F, E, D)
        // ========================================================================
        $display("\nTEST 5: Row 3 Keys (0, F, E, D)");
        $display("----------------------------------------");
        
        row_onehot = 4'b1000; // Row 3
        
        col_onehot = 4'b0001; // Col 0
        #1;
        check_result("Key '0' (row 3, col 0)", 4'b0000);
        
        col_onehot = 4'b0010; // Col 1
        #1;
        check_result("Key 'F' (row 3, col 1)", 4'b1111);
        
        col_onehot = 4'b0100; // Col 2
        #1;
        check_result("Key 'E' (row 3, col 2)", 4'b1110);
        
        col_onehot = 4'b1000; // Col 3
        #1;
        check_result("Key 'D' (row 3, col 3)", 4'b1101);

        // ========================================================================
        // TEST 6: Invalid Combinations
        // ========================================================================
        $display("\nTEST 6: Invalid Combinations");
        $display("----------------------------------------");
        
        // Multiple rows active (invalid)
        row_onehot = 4'b0011; // Rows 0 and 1
        col_onehot = 4'b0001;
        #1;
        check_result("Multiple rows active", 4'b0000);
        
        // Multiple columns active (invalid)
        row_onehot = 4'b0001;
        col_onehot = 4'b0011; // Cols 0 and 1
        #1;
        check_result("Multiple columns active", 4'b0000);
        
        // No row active
        row_onehot = 4'b0000;
        col_onehot = 4'b0001;
        #1;
        check_result("No row active", 4'b0000);
        
        // No column active
        row_onehot = 4'b0001;
        col_onehot = 4'b0000;
        #1;
        check_result("No column active", 4'b0000);

        // ========================================================================
        // TEST 7: All Key Combinations
        // ========================================================================
        $display("\nTEST 7: All Key Combinations");
        $display("----------------------------------------");
        
        // Test all 16 key combinations
        for (int row = 0; row < 4; row++) begin
            for (int col = 0; col < 4; col++) begin
                row_onehot = (1 << row);
                col_onehot = (1 << col);
                #1;
                
                // Calculate expected key code based on row/col
                case ({row_onehot, col_onehot})
                    {4'b0001, 4'b0001}: expected_key = 4'b0001; // 1
                    {4'b0001, 4'b0010}: expected_key = 4'b0010; // 2
                    {4'b0001, 4'b0100}: expected_key = 4'b0011; // 3
                    {4'b0001, 4'b1000}: expected_key = 4'b1010; // A
                    {4'b0010, 4'b0001}: expected_key = 4'b0100; // 4
                    {4'b0010, 4'b0010}: expected_key = 4'b0101; // 5
                    {4'b0010, 4'b0100}: expected_key = 4'b0110; // 6
                    {4'b0010, 4'b1000}: expected_key = 4'b1011; // B
                    {4'b0100, 4'b0001}: expected_key = 4'b0111; // 7
                    {4'b0100, 4'b0010}: expected_key = 4'b1000; // 8
                    {4'b0100, 4'b0100}: expected_key = 4'b1001; // 9
                    {4'b0100, 4'b1000}: expected_key = 4'b1100; // C
                    {4'b1000, 4'b0001}: expected_key = 4'b0000; // 0
                    {4'b1000, 4'b0010}: expected_key = 4'b1111; // F
                    {4'b1000, 4'b0100}: expected_key = 4'b1110; // E
                    {4'b1000, 4'b1000}: expected_key = 4'b1101; // D
                    default: expected_key = 4'b0000;
                endcase
                
                if (key_code == expected_key) begin
                    $display("  ✓ Key [%0d,%0d]: %b", row, col, key_code);
                end else begin
                    $display("  ✗ Key [%0d,%0d]: Expected %b, Got %b", row, col, expected_key, key_code);
                end
            end
        end

        $display("\n==========================================");
        $display("DECODER TEST COMPLETED");
        $display("==========================================");
        
        $finish;
    end

endmodule
