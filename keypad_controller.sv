// ============================================================================
// KEYPAD CONTROLLER MODULE
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Keypad Controller - Digit Controller Logic
// This module implements digit controller logic for the keypad system.
// When a key is pressed, it shifts the left digit to the right and puts the new key in the left position.
// ============================================================================

module keypad_controller (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    input  logic [15:0] key_matrix,    // Key matrix from debouncer
    input  logic        key_valid,     // Valid key press signal
    output logic [3:0]  digit_left,   // Left display digit
    output logic [3:0]  digit_right,  // Right display digit
    output logic [15:0] pressed_keys  // Currently pressed keys
);

    // Multi-key controller logic - handles multiple simultaneous key presses
    
    logic [3:0] left_digit_reg, right_digit_reg;
    logic [15:0] pressed_keys_reg;
    logic [2:0] state;    // State machine: 000=idle, 001=key_held
    
    // Function to find first pressed key in matrix (for digit display)
    function [3:0] find_first_key(input [15:0] matrix);
        begin
            find_first_key = 4'h0;
            if (matrix[0]) find_first_key = 4'h0;  // Key 0
            else if (matrix[1]) find_first_key = 4'h1;  // Key 1
            else if (matrix[2]) find_first_key = 4'h2;  // Key 2
            else if (matrix[3]) find_first_key = 4'h3;  // Key 3
            else if (matrix[4]) find_first_key = 4'h4;  // Key 4
            else if (matrix[5]) find_first_key = 4'h5;  // Key 5
            else if (matrix[6]) find_first_key = 4'h6;  // Key 6
            else if (matrix[7]) find_first_key = 4'h7;  // Key 7
            else if (matrix[8]) find_first_key = 4'h8;  // Key 8
            else if (matrix[9]) find_first_key = 4'h9;  // Key 9
            else if (matrix[10]) find_first_key = 4'hA;  // Key A
            else if (matrix[11]) find_first_key = 4'hB;  // Key B
            else if (matrix[12]) find_first_key = 4'hC;  // Key C
            else if (matrix[13]) find_first_key = 4'hD;  // Key D
            else if (matrix[14]) find_first_key = 4'hE;  // Key E
            else if (matrix[15]) find_first_key = 4'hF;  // Key F
        end
    endfunction
    
    // State machine for key press detection and digit shifting
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            left_digit_reg <= 4'h0;
            right_digit_reg <= 4'h0;
            pressed_keys_reg <= 16'h0000;
            state <= 3'b000;
        end
        else begin
            case (state)
                3'b000: begin // Idle state
                    if (key_valid) begin
                        // Key(s) pressed - update pressed keys and shift digits
                        pressed_keys_reg <= key_matrix;
                        if (key_matrix != 16'h0000) begin
                            // Shift digits and display first key
                            right_digit_reg <= left_digit_reg;
                            left_digit_reg <= find_first_key(key_matrix);
                        end
                        state <= 3'b001; // Go to key held state
                    end
                end
                3'b001: begin // Key held state
                    if (!key_valid) begin
                        // Key released - return to idle
                        pressed_keys_reg <= 16'h0000;
                        state <= 3'b000;
                    end else begin
                        // Update pressed keys while held
                        pressed_keys_reg <= key_matrix;
                    end
                end
                default: begin
                    state <= 3'b000;
                end
            endcase
        end
    end 
    
    // Output assignments
    assign digit_left = left_digit_reg;
    assign digit_right = right_digit_reg;
    assign pressed_keys = pressed_keys_reg;

endmodule
