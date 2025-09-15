// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Keypad Controller - Digit Controller Logic
// This module implements digit controller logic for the keypad system.
// When a key is pressed, it shifts the left digit to the right and puts the new key in the left position.

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
        else if (change) begin
            // Shift left digit to right, put new key in left
            left_digit_reg <= digit1;
            right_digit_reg <= left_digit_reg;
        end
        else if (press) begin
            // Store the new key code
            digit1 <= key_code;
        end
    end 
    
    // Output assignments
    assign digit_left = left_digit_reg;
    assign digit_right = right_digit_reg;

endmodule
