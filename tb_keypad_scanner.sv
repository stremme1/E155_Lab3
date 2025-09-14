// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench for keypad_scanner module

module tb_keypad_scanner();

    // Testbench signals
    logic        clk;
    logic        rst_n;
    logic [3:0]  keypad_cols;    // FPGA reads columns (input)
    logic [3:0]  keypad_rows;    // FPGA drives rows (output)
    logic [3:0]  key_code;
    logic        key_valid;

    // Instantiate DUT
    keypad_scanner dut (
        .clk(clk),
        .rst_n(rst_n),
        .keypad_cols(keypad_cols),    // FPGA reads columns
        .keypad_rows(keypad_rows),    // FPGA drives rows
        .key_code(key_code),
        .key_valid(key_valid)
    );

    // Clock generation (3MHz)
    initial begin
        clk = 0;
        forever #167 clk = ~clk; // 3MHz clock (333ns period)
    end

    // Test stimulus
    initial begin
        $display("=== Keypad Scanner Testbench ===");
        
        // Initialize
        rst_n = 0;
        keypad_cols = 4'b1111; // No keys pressed initially
        #1000;
        
        // Test reset behavior
        $display("Testing reset: keypad_rows = %b, key_code = %h", keypad_rows, key_code);
        
        // Release reset
        rst_n = 1;
        #1000;
        $display("After reset: keypad_rows = %b, key_code = %h", keypad_rows, key_code);
        
        // Wait for row scanning to stabilize
        #10000;
        $display("Row scanning stabilized: keypad_rows = %b", keypad_rows);
        
        // Test key detection - Key '1' (Row 0, Col 0)
        $display("Testing key detection - Key '1'...");
        // Wait for row 0 to be active (keypad_rows = 4'b1110)
        wait(keypad_rows == 4'b1110);
        keypad_cols = 4'b1110; // Simulate col 0 pressed
        $display("Key '1' pressed at time %0t", $time);
        
        // Wait for debounce period (20ms = 60,000 cycles at 3MHz)
        #20000000; // 20ms
        $display("After debounce: key_code = %h, key_valid = %b", key_code, key_valid);
        
        // Release key
        keypad_cols = 4'b1111;
        #1000000; // 1ms
        $display("Key released: key_code = %h, key_valid = %b", key_code, key_valid);
        
        // Test key detection - Key '5' (Row 1, Col 1)
        $display("Testing key detection - Key '5'...");
        wait(keypad_rows == 4'b1101); // Wait for row 1
        keypad_cols = 4'b1101; // Simulate col 1 pressed
        $display("Key '5' pressed at time %0t", $time);
        
        #20000000; // 20ms debounce
        $display("After debounce: key_code = %h, key_valid = %b", key_code, key_valid);
        
        // Release key
        keypad_cols = 4'b1111;
        #1000000;
        
        // Test key detection - Key 'A' (Row 3, Col 0)
        $display("Testing key detection - Key 'A'...");
        wait(keypad_rows == 4'b0111); // Wait for row 3
        keypad_cols = 4'b1110; // Simulate col 0 pressed
        $display("Key 'A' pressed at time %0t", $time);
        
        #20000000; // 20ms debounce
        $display("After debounce: key_code = %h, key_valid = %b", key_code, key_valid);
        
        // Release key
        keypad_cols = 4'b1111;
        #1000000;
        
        $display("=== Test Complete ===");
        $finish;
    end

endmodule