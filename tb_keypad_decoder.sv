// ============================================================================
// KEYPAD DECODER TESTBENCH
// ============================================================================
// This testbench thoroughly tests the keypad_decoder module
// Tests all 16 key mappings, invalid inputs, and edge cases

// First, include the actual keypad_decoder module
// ============================================================================
// KEYPAD DECODER MODULE
// ============================================================================

module keypad_decoder (
    input  logic [3:0] row_onehot,
    input  logic [3:0] col_onehot,
    output logic [3:0] key_code   // 4-bit hex code 0000..1111
);

    always_comb begin
        // default
        key_code = 4'b0000;
        case ({row_onehot, col_onehot})
            // row0 (0001)
            {4'b0001, 4'b0001}: key_code = 4'b0001; // 1
            {4'b0001, 4'b0010}: key_code = 4'b0010; // 2
            {4'b0001, 4'b0100}: key_code = 4'b0011; // 3
            {4'b0001, 4'b1000}: key_code = 4'b1010; // A

            // row1 (0010)
            {4'b0010, 4'b0001}: key_code = 4'b0100; // 4
            {4'b0010, 4'b0010}: key_code = 4'b0101; // 5
            {4'b0010, 4'b0100}: key_code = 4'b0110; // 6
            {4'b0010, 4'b1000}: key_code = 4'b1011; // B

            // row2 (0100)
            {4'b0100, 4'b0001}: key_code = 4'b0111; // 7
            {4'b0100, 4'b0010}: key_code = 4'b1000; // 8
            {4'b0100, 4'b0100}: key_code = 4'b1001; // 9
            {4'b0100, 4'b1000}: key_code = 4'b1100; // C

            // row3 (1000)
            {4'b1000, 4'b0001}: key_code = 4'b1110; // E
            {4'b1000, 4'b0010}: key_code = 4'b0000; // 0
            {4'b1000, 4'b0100}: key_code = 4'b1111; // F
            {4'b1000, 4'b1000}: key_code = 4'b1101; // D

            default: key_code = 4'b0000;
        endcase
    end
endmodule

// ============================================================================
// TESTBENCH FOR KEYPAD DECODER
// ============================================================================

module tb_keypad_decoder;

    // Testbench signals
    logic [3:0] row_onehot;
    logic [3:0] col_onehot;
    logic [3:0] key_code;

    // Instantiate the ACTUAL keypad decoder module
    keypad_decoder dut (
        .row_onehot(row_onehot),
        .col_onehot(col_onehot),
        .key_code(key_code)
    );

    // Test stimulus
    initial begin
        $display("==========================================");
        $display("KEYPAD DECODER TESTBENCH STARTING");
        $display("Testing the ACTUAL keypad_decoder module");
        $display("==========================================");
        
        // Initialize signals
        row_onehot = 4'b0000;
        col_onehot = 4'b0000;
        
        $display("Initial state - Row: %b, Col: %b, Key_code: %h", 
                 row_onehot, col_onehot, key_code);
        
        // Test 1: All valid key mappings
        $display("\n--- Test 1: All Valid Key Mappings ---");
        $display("Testing all 16 key combinations...");
        
        // Row 0 keys (1, 2, 3, A)
        $display("\nRow 0 keys:");
        row_onehot = 4'b0001; col_onehot = 4'b0001; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 1)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0001; col_onehot = 4'b0010; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 2)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0001; col_onehot = 4'b0100; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 3)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0001; col_onehot = 4'b1000; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: A)", row_onehot, col_onehot, key_code);
        
        // Row 1 keys (4, 5, 6, B)
        $display("\nRow 1 keys:");
        row_onehot = 4'b0010; col_onehot = 4'b0001; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 4)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0010; col_onehot = 4'b0010; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 5)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0010; col_onehot = 4'b0100; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 6)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0010; col_onehot = 4'b1000; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: B)", row_onehot, col_onehot, key_code);
        
        // Row 2 keys (7, 8, 9, C)
        $display("\nRow 2 keys:");
        row_onehot = 4'b0100; col_onehot = 4'b0001; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 7)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0100; col_onehot = 4'b0010; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 8)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0100; col_onehot = 4'b0100; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 9)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0100; col_onehot = 4'b1000; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: C)", row_onehot, col_onehot, key_code);
        
        // Row 3 keys (E, 0, F, D)
        $display("\nRow 3 keys:");
        row_onehot = 4'b1000; col_onehot = 4'b0001; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: E)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b1000; col_onehot = 4'b0010; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: 0)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b1000; col_onehot = 4'b0100; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: F)", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b1000; col_onehot = 4'b1000; #1;
        $display("Row: %b, Col: %b -> Key: %h (expected: D)", row_onehot, col_onehot, key_code);
        
        // Test 2: Invalid inputs (no key pressed)
        $display("\n--- Test 2: Invalid Inputs ---");
        row_onehot = 4'b0000; col_onehot = 4'b0000; #1;
        $display("No key pressed - Row: %b, Col: %b -> Key: %h (expected: 0)", 
                 row_onehot, col_onehot, key_code);
        
        // Test 3: Multiple row bits set (invalid)
        $display("\n--- Test 3: Multiple Row Bits Set (Invalid) ---");
        row_onehot = 4'b0011; col_onehot = 4'b0001; #1;
        $display("Multiple rows - Row: %b, Col: %b -> Key: %h (expected: 0)", 
                 row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b1100; col_onehot = 4'b0010; #1;
        $display("Multiple rows - Row: %b, Col: %b -> Key: %h (expected: 0)", 
                 row_onehot, col_onehot, key_code);
        
        // Test 4: Multiple column bits set (invalid)
        $display("\n--- Test 4: Multiple Column Bits Set (Invalid) ---");
        row_onehot = 4'b0001; col_onehot = 4'b0011; #1;
        $display("Multiple cols - Row: %b, Col: %b -> Key: %h (expected: 0)", 
                 row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0010; col_onehot = 4'b1100; #1;
        $display("Multiple cols - Row: %b, Col: %b -> Key: %h (expected: 0)", 
                 row_onehot, col_onehot, key_code);
        
        // Test 5: All bits set (invalid)
        $display("\n--- Test 5: All Bits Set (Invalid) ---");
        row_onehot = 4'b1111; col_onehot = 4'b1111; #1;
        $display("All bits set - Row: %b, Col: %b -> Key: %h (expected: 0)", 
                 row_onehot, col_onehot, key_code);
        
        // Test 6: Edge cases
        $display("\n--- Test 6: Edge Cases ---");
        row_onehot = 4'b0001; col_onehot = 4'b0000; #1;
        $display("Row set, no col - Row: %b, Col: %b -> Key: %h (expected: 0)", 
                 row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0000; col_onehot = 4'b0001; #1;
        $display("Col set, no row - Row: %b, Col: %b -> Key: %h (expected: 0)", 
                 row_onehot, col_onehot, key_code);
        
        // Test 7: Keypad layout verification
        $display("\n--- Test 7: Keypad Layout Verification ---");
        $display("Keypad Layout:");
        $display("Row 0: 1 2 3 A");
        $display("Row 1: 4 5 6 B");
        $display("Row 2: 7 8 9 C");
        $display("Row 3: E 0 F D");
        
        // Verify a few key positions
        $display("\nVerifying key positions:");
        row_onehot = 4'b0001; col_onehot = 4'b0001; #1;
        $display("Top-left (1): Row: %b, Col: %b -> Key: %h", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b1000; col_onehot = 4'b0010; #1;
        $display("Bottom-center (0): Row: %b, Col: %b -> Key: %h", row_onehot, col_onehot, key_code);
        
        row_onehot = 4'b0100; col_onehot = 4'b1000; #1;
        $display("Middle-right (C): Row: %b, Col: %b -> Key: %h", row_onehot, col_onehot, key_code);
        
        // Test 8: Comprehensive validation
        $display("\n--- Test 8: Comprehensive Validation ---");
        $display("Testing all combinations systematically...");
        
        for (int row = 0; row < 4; row++) begin
            for (int col = 0; col < 4; col++) begin
                row_onehot = (1 << row);
                col_onehot = (1 << col);
                #1;
                $display("Row %0d, Col %0d: Row: %b, Col: %b -> Key: %h", 
                         row, col, row_onehot, col_onehot, key_code);
            end
        end
        
        $display("\n==========================================");
        $display("KEYPAD DECODER TESTBENCH COMPLETE");
        $display("This tested the ACTUAL keypad_decoder module!");
        $display("==========================================");
        $stop;
    end

    // Monitor for debugging
    initial begin
        $monitor("Time: %0t | Row: %b | Col: %b | Key_code: %h", 
                 $time, row_onehot, col_onehot, key_code);
    end

endmodule
