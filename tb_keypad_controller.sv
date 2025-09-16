// ============================================================================
// KEYPAD CONTROLLER TESTBENCH
// ============================================================================
// This testbench thoroughly tests the keypad controller module functionality
// Tests include: digit shifting, key press/release detection, and edge cases

// First, include the actual keypad_controller module
// ============================================================================
// KEYPAD CONTROLLER MODULE
// ============================================================================

module keypad_controller (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    input  logic [3:0]  key_code,      // Key code from keypad scanner
    input  logic        key_valid,     // Valid key press signal
    output logic [3:0]  digit_left,    // Left display digit
    output logic [3:0]  digit_right   // Right display digit
);

    // Digit controller logic - implements digit shifting behavior

    logic [3:0] left_digit_reg, right_digit_reg;
    logic [3:0] digit1;  // Temporary storage for new key 
    logic press, change;
    
    // Generate press and change signals from key_valid
    logic key_valid_prev;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_valid_prev <= 1'b0;
        end else begin
            key_valid_prev <= key_valid;
        end
    end
    
    assign press = key_valid && !key_valid_prev;   // Rising edge - key pressed
    assign change = !key_valid && key_valid_prev;  // Falling edge - key released
    
    // exact logic: if the key_valid signal indicates that a button has been pressed, 
    // put the first digit into the second digit and read in a new digit
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            left_digit_reg <= 4'h0;
            right_digit_reg <= 4'h0;
            digit1 <= 4'h0;
        end
        else if (press) begin
            // Store the new key code when key is first pressed
            digit1 <= key_code;
        end
        else if (change) begin
            // Shift left digit to right, put new key in left when key is released
            left_digit_reg <= digit1;
            right_digit_reg <= left_digit_reg;
        end
    end 
    
    // Output assignments
    assign digit_left = left_digit_reg;
    assign digit_right = right_digit_reg;

endmodule

// ============================================================================
// TESTBENCH FOR KEYPAD CONTROLLER
// ============================================================================

module tb_keypad_controller;

    // Testbench signals
    logic        clk;
    logic        rst_n;
    logic [3:0]  key_code;
    logic        key_valid;
    logic [3:0]  digit_left;
    logic [3:0]  digit_right;

    // Instantiate the ACTUAL keypad controller module
    keypad_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (10ns period)
    end

    // Test stimulus
    initial begin
        $display("==========================================");
        $display("KEYPAD CONTROLLER TESTBENCH STARTING");
        $display("Testing the ACTUAL keypad_controller module");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        key_code = 4'h0;
        key_valid = 0;
        
        // Reset sequence
        $display("Applying reset...");
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
        
        $display("Reset complete. Starting tests...");
        $display("Initial state - Digit_left: %h, Digit_right: %h", digit_left, digit_right);
        
        // Test 1: First key press and release
        $display("\n--- Test 1: First key press (key '5') ---");
        key_code = 4'h5;
        key_valid = 1;  // Key pressed
        @(posedge clk);
        $display("After key press - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        key_valid = 0;  // Key released
        @(posedge clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 digit_left, digit_right);
        
        // Test 2: Second key press and release
        $display("\n--- Test 2: Second key press (key '3') ---");
        key_code = 4'h3;
        key_valid = 1;  // Key pressed
        @(posedge clk);
        $display("After key press - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        key_valid = 0;  // Key released
        @(posedge clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 digit_left, digit_right);
        
        // Test 3: Third key press and release
        $display("\n--- Test 3: Third key press (key '7') ---");
        key_code = 4'h7;
        key_valid = 1;  // Key pressed
        @(posedge clk);
        $display("After key press - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        key_valid = 0;  // Key released
        @(posedge clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 digit_left, digit_right);
        
        // Test 4: Fourth key press and release
        $display("\n--- Test 4: Fourth key press (key 'A') ---");
        key_code = 4'hA;
        key_valid = 1;  // Key pressed
        @(posedge clk);
        $display("After key press - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        key_valid = 0;  // Key released
        @(posedge clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 digit_left, digit_right);
        
        // Test 5: Rapid key presses (should only register on release)
        $display("\n--- Test 5: Rapid key presses test ---");
        key_code = 4'h1;
        key_valid = 1;  // Press key 1
        @(posedge clk);
        key_code = 4'h2;  // Change to key 2 while still pressed
        @(posedge clk);
        key_code = 4'h3;  // Change to key 3 while still pressed
        @(posedge clk);
        $display("After rapid key changes (still pressed) - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        key_valid = 0;  // Release key
        @(posedge clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 digit_left, digit_right);
        
        // Test 6: Multiple key presses without release
        $display("\n--- Test 6: Multiple key presses without release ---");
        key_code = 4'h4;
        key_valid = 1;  // Press key 4
        @(posedge clk);
        $display("After key 4 press - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        key_code = 4'h6;  // Change to key 6 (still pressed)
        @(posedge clk);
        $display("After key 6 press (still held) - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        key_valid = 0;  // Release
        @(posedge clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 digit_left, digit_right);
        
        // Test 7: All hexadecimal digits test
        $display("\n--- Test 7: All hexadecimal digits test ---");
        for (int i = 0; i < 16; i++) begin
            key_code = i[3:0];
            key_valid = 1;  // Press key
            @(posedge clk);
            key_valid = 0;  // Release key
            @(posedge clk);
            $display("Key %h pressed - Digit_left: %h, Digit_right: %h", 
                     i[3:0], digit_left, digit_right);
        end
        
        // Test 8: Reset test
        $display("\n--- Test 8: Reset test ---");
        $display("Before reset - Digit_left: %h, Digit_right: %h", digit_left, digit_right);
        rst_n = 0;  // Assert reset
        @(posedge clk);
        rst_n = 1;  // Deassert reset
        @(posedge clk);
        $display("After reset - Digit_left: %h, Digit_right: %h", digit_left, digit_right);
        
        // Test 9: Edge case - key_valid stays high
        $display("\n--- Test 9: Key_valid stays high test ---");
        key_code = 4'h9;
        key_valid = 1;  // Press key
        @(posedge clk);
        $display("After key press - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        // Keep key_valid high for multiple cycles
        repeat(5) @(posedge clk);
        $display("After 5 cycles with key still pressed - Digit_left: %h, Digit_right: %h, digit1: %h", 
                 digit_left, digit_right, dut.digit1);
        
        key_valid = 0;  // Release key
        @(posedge clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 digit_left, digit_right);
        
        // Test 10: Final sequence test
        $display("\n--- Test 10: Final sequence test ---");
        $display("Testing sequence: 1 -> 2 -> 3 -> 4");
        
        key_code = 4'h1;
        key_valid = 1; @(posedge clk); key_valid = 0; @(posedge clk);
        $display("After '1': Digit_left: %h, Digit_right: %h", digit_left, digit_right);
        
        key_code = 4'h2;
        key_valid = 1; @(posedge clk); key_valid = 0; @(posedge clk);
        $display("After '2': Digit_left: %h, Digit_right: %h", digit_left, digit_right);
        
        key_code = 4'h3;
        key_valid = 1; @(posedge clk); key_valid = 0; @(posedge clk);
        $display("After '3': Digit_left: %h, Digit_right: %h", digit_left, digit_right);
        
        key_code = 4'h4;
        key_valid = 1; @(posedge clk); key_valid = 0; @(posedge clk);
        $display("After '4': Digit_left: %h, Digit_right: %h", digit_left, digit_right);
        
        $display("\n==========================================");
        $display("KEYPAD CONTROLLER TESTBENCH COMPLETE");
        $display("This tested the ACTUAL keypad_controller module!");
        $display("==========================================");
        $stop;
    end

    // Monitor for debugging
    initial begin
        $monitor("Time: %0t | Key_code: %h | Key_valid: %b | Press: %b | Change: %b | Digit_left: %h | Digit_right: %h", 
                 $time, key_code, key_valid, dut.press, dut.change, digit_left, digit_right);
    end

endmodule
