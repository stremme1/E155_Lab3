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
    input  logic [3:0]  key_code,      // Key code from keypad scanner
    input  logic        key_valid,     // Valid key press signal
    output logic [3:0]  digit_left,    // Left display digit
    output logic [3:0]  digit_right    // Right display digit
);

    // Digit controller logic - implements digit shifting behavior

    logic [3:0] left_digit_reg, right_digit_reg;
    logic [3:0] new_key;  // Store new key code
    logic [2:0] state;    // State machine: 000=idle, 001=key_held
    
    // State machine for key press detection and digit shifting
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            left_digit_reg <= 4'h0;
            right_digit_reg <= 4'h0;
            new_key <= 4'h0;
            state <= 3'b000;
        end
        else begin
            case (state)
                3'b000: begin // Idle state
                    if (key_valid) begin
                        // Key pressed - immediately shift digits and display new key
                        right_digit_reg <= left_digit_reg;
                        left_digit_reg <= key_code;
                        new_key <= key_code;
                        state <= 3'b001; // Go to key held state
                    end
                end
                3'b001: begin // Key held state
                    if (!key_valid) begin
                        // Key released - return to idle
                        state <= 3'b000;
                    end
                    // Stay in this state while key is held, ignore additional key presses
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

endmodule
