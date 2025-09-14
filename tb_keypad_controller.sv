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

    // Test stimulus
    initial begin
        $display("=== Keypad Controller Testbench ===");
        
        // Initialize
        clk = 0;
        rst_n = 0;
        key_code = 4'h0;
        key_valid = 0;
        
        // Test reset behavior
        $display("Testing reset: digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Release reset
        rst_n = 1;
        clk = 1;
        $display("After reset: digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        // Test first key press
        key_code = 4'h5;
        key_valid = 1;
        clk = 0;
        clk = 1;
        $display("After key '5': digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        key_valid = 0;
        clk = 0;
        clk = 1;
        
        // Test second key press
        key_code = 4'hA;
        key_valid = 1;
        clk = 0;
        clk = 1;
        $display("After key 'A': digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        key_valid = 0;
        clk = 0;
        clk = 1;
        
        // Test third key press
        key_code = 4'h3;
        key_valid = 1;
        clk = 0;
        clk = 1;
        $display("After key '3': digit_left = %h, digit_right = %h", digit_left, digit_right);
        
        $display("=== Test Complete ===");
        $finish;
    end

endmodule