// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench for lab3_top module (without HSOSC)

module tb_lab3_top();

    // Testbench signals
    logic        clk;
    logic        reset;
    logic [3:0]  keypad_rows;
    logic [3:0]  keypad_cols;
    logic [6:0]  seg;
    logic        select0;
    logic        select1;

    // Instantiate DUT (we'll create a version without HSOSC for simulation)
    lab3_top_sim dut (
        .clk(clk),
        .reset(reset),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .seg(seg),
        .select0(select0),
        .select1(select1)
    );

    // Clock generation (3MHz)
    initial begin
        clk = 0;
        forever #167 clk = ~clk; // 3MHz clock (333ns period)
    end

    // Test stimulus
    initial begin
        $display("=== Lab3 Top Module Testbench ===");
        
        // Initialize
        reset = 0;
        keypad_cols = 4'b1111; // No keys pressed
        #20;
        
        // Release reset
        reset = 1;
        #1000;
        
        $display("After reset - should show '00'");
        $display("Time %0t: seg=%b, select0=%b, select1=%b", 
                 $time, seg, select0, select1);
        
        // Test keypad input sequence
        $display("\nTesting keypad sequence: 1, 5, A, F");
        
        // Press key '1' (Row 0, Col 0)
        $display("Pressing key '1'...");
        wait(keypad_rows == 4'b1110); // Wait for row 0
        keypad_cols = 4'b1110; // Col 0 pressed
        #20000000; // Wait for debounce (20ms)
        $display("Time %0t: seg=%b, select0=%b, select1=%b", 
                 $time, seg, select0, select1);
        
        // Release key
        keypad_cols = 4'b1111;
        #1000000; // 1ms
        
        // Press key '5' (Row 1, Col 1)
        $display("Pressing key '5'...");
        wait(keypad_rows == 4'b1101); // Wait for row 1
        keypad_cols = 4'b1101; // Col 1 pressed
        #20000000; // Wait for debounce (20ms)
        $display("Time %0t: seg=%b, select0=%b, select1=%b", 
                 $time, seg, select0, select1);
        
        // Release key
        keypad_cols = 4'b1111;
        #1000000; // 1ms
        
        // Press key 'A' (Row 3, Col 0)
        $display("Pressing key 'A'...");
        wait(keypad_rows == 4'b0111); // Wait for row 3
        keypad_cols = 4'b1110; // Col 0 pressed
        #20000000; // Wait for debounce (20ms)
        $display("Time %0t: seg=%b, select0=%b, select1=%b", 
                 $time, seg, select0, select1);
        
        // Release key
        keypad_cols = 4'b1111;
        #1000000; // 1ms
        
        // Press key 'F' (Row 3, Col 3)
        $display("Pressing key 'F'...");
        wait(keypad_rows == 4'b0111); // Wait for row 3
        keypad_cols = 4'b0111; // Col 3 pressed
        #20000000; // Wait for debounce (20ms)
        $display("Time %0t: seg=%b, select0=%b, select1=%b", 
                 $time, seg, select0, select1);
        
        // Release key
        keypad_cols = 4'b1111;
        #5000000; // 5ms
        
        $display("\n=== Test Complete ===");
        $finish;
    end

    // Monitor keypad scanning
    always @(posedge clk) begin
        if (keypad_rows != 4'b1111) begin
            $display("Row scanning: %b at time %0t", keypad_rows, $time);
        end
    end

endmodule

// Simulation version of lab3_top without HSOSC
module lab3_top_sim (
    input  logic        clk,
    input  logic        reset,
    output logic [3:0]  keypad_rows,
    input  logic [3:0]  keypad_cols,
    output logic [6:0]  seg,
    output logic        select0,
    output logic        select1
);

    logic [3:0]  key_code;
    logic        key_valid;
    logic [3:0]  digit_left, digit_right;

    // Keypad scanner
    keypad_scanner scanner (
        .clk(clk),
        .rst_n(reset),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .key_code(key_code),
        .key_valid(key_valid)
    );
    
    // Keypad controller
    keypad_controller controller (
        .clk(clk),
        .rst_n(reset),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

    // Display system
    Lab2_ES display (
        .clk(clk),
        .reset(reset),
        .s0(digit_left),
        .s1(digit_right),
        .seg(seg),
        .select0(select0),
        .select1(select1)
    );

endmodule
