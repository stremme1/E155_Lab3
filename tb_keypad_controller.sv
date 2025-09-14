// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench for keypad_controller module

module tb_keypad_controller();

    // Testbench signals
    logic        clk;
    logic        rst_n;
    logic [3:0]  key_code;
    logic        key_valid;
    logic [3:0]  digit_left;
    logic [3:0]  digit_right;

    // Instantiate DUT
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
        forever #167 clk = ~clk; // 3MHz clock (333ns period)
    end

    // Test stimulus
    initial begin
        $display("=== Keypad Controller Testbench ===");
        
        // Initialize
        rst_n = 0;
        key_code = 4'h0;
        key_valid = 0;
        #1000;
        
        // Test reset behavior
        $display("Testing reset: digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Release reset
        rst_n = 1;
        #1000;
        $display("After reset: digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Test first key press (should go to left position)
        $display("Testing first key press - Key '5'...");
        key_code = 4'h5;
        key_valid = 1;
        #1000; // Wait for state transition
        $display("After key '5': digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Release key
        key_valid = 0;
        #1000;
        
        // Test second key press (should shift left to right)
        $display("Testing second key press - Key 'A'...");
        key_code = 4'hA;
        key_valid = 1;
        #1000; // Wait for state transition
        $display("After key 'A': digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Release key
        key_valid = 0;
        #1000;
        
        // Test third key press (should shift again)
        $display("Testing third key press - Key '3'...");
        key_code = 4'h3;
        key_valid = 1;
        #1000; // Wait for state transition
        $display("After key '3': digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Release key
        key_valid = 0;
        #1000;
        
        // Test FSM state transitions
        $display("Testing FSM state transitions...");
        
        // Test key hold behavior
        key_code = 4'hF;
        key_valid = 1;
        #1000;
        $display("Key held: digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Keep key held for multiple clock cycles
        #5000;
        $display("Key still held: digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Release key
        key_valid = 0;
        #1000;
        $display("Key released: digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        $display("=== Test Complete ===");
        $finish;
    end

endmodule