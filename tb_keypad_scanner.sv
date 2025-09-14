// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench for keypad_scanner module

module tb_keypad_scanner();

    // Testbench signals
    logic        clk;
    logic        rst_n;
    logic [3:0]  keypad_cols;    // FPGA drives columns (output)
    logic [3:0]  keypad_rows;    // FPGA reads rows (input)
    logic [3:0]  key_code;
    logic        key_pressed;
    logic        key_valid;

    // Instantiate DUT
    keypad_scanner dut (
        .clk(clk),
        .rst_n(rst_n),
        .keypad_cols(keypad_cols),    // FPGA drives columns
        .keypad_rows(keypad_rows),    // FPGA reads rows
        .key_code(key_code),
        .key_pressed(key_pressed),
        .key_valid(key_valid)
    );

    // Test stimulus
    initial begin
        $display("=== Keypad Scanner Testbench ===");
        
        // Initialize
        clk = 0;
        rst_n = 0;
        keypad_cols = 4'b1111; // No keys pressed initially
        
        // Test reset behavior
        $display("Testing reset: keypad_rows = %b, key_code = %h", keypad_rows, key_code);
        
        // Release reset
        rst_n = 1;
        clk = 1;
        $display("After reset: keypad_rows = %b, key_code = %h", keypad_rows, key_code);
        
        // Test row scanning
        clk = 0;
        clk = 1;
        $display("Row scan 1: keypad_rows = %b", keypad_rows);
        
        clk = 0;
        clk = 1;
        $display("Row scan 2: keypad_rows = %b", keypad_rows);
        
        clk = 0;
        clk = 1;
        $display("Row scan 3: keypad_rows = %b", keypad_rows);
        
        clk = 0;
        clk = 1;
        $display("Row scan 4: keypad_rows = %b", keypad_rows);
        
        // Test key detection - Key '1' (Row 0, Col 0)
        $display("Testing key detection - Key '1'...");
        keypad_cols = 4'b1110; // Simulate col 0 pressed
        clk = 0;
        clk = 1;
        $display("Key '1' detected: key_code = %h, key_valid = %b", key_code, key_valid);
        
        // Test key detection - Key '5' (Row 1, Col 1)
        $display("Testing key detection - Key '5'...");
        keypad_cols = 4'b1101; // Simulate col 1 pressed
        clk = 0;
        clk = 1;
        $display("Key '5' detected: key_code = %h, key_valid = %b", key_code, key_valid);
        
        // Test key detection - Key 'A' (Row 3, Col 0)
        $display("Testing key detection - Key 'A'...");
        keypad_cols = 4'b1110; // Simulate col 0 pressed
        clk = 0;
        clk = 1;
        $display("Key 'A' detected: key_code = %h, key_valid = %b", key_code, key_valid);
        
        // Release key
        keypad_cols = 4'b1111;
        clk = 0;
        clk = 1;
        $display("Key released: key_code = %h, key_valid = %b", key_code, key_valid);
        
        $display("=== Test Complete ===");
        $finish;
    end

endmodule