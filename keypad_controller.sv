// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Keypad Controller FSM
// This module implements a proper FSM for the keypad system that starts with dual "00"
// and manages the display of the last two hexadecimal digits pressed.

module keypad_controller (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    input  logic [3:0]  key_code,      // Key code from keypad scanner
    input  logic        key_valid,     // Valid key press signal
    output logic [3:0]  digit_left,    // Left display digit
    output logic [3:0]  digit_right   // Right display digit
);

    // FSM State Definition
    typedef enum logic [2:0] {
        INIT,           // Initial state - display "00"
        WAIT_KEY,       // Waiting for key press
        UPDATE_LEFT,    // Update left digit with first key
        UPDATE_RIGHT,   // Update right digit (shift left to right)
        HOLD_KEY        // Key is held, ignore additional inputs
    } fsm_state_t;
    
    // State and data registers
    fsm_state_t current_state, next_state;
    logic [3:0] left_digit_reg, right_digit_reg;
    logic [3:0] next_left_digit, next_right_digit;
    
    // Sequential logic for state and data registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= INIT;
            left_digit_reg <= 4'h0;
            right_digit_reg <= 4'h0;
        end else begin
            current_state <= next_state;
            left_digit_reg <= next_left_digit;
            right_digit_reg <= next_right_digit;
        end
    end
    
    // Combinational logic for next state and outputs
    always_comb begin
        // Default values
        next_state = current_state;
        next_left_digit = left_digit_reg;
        next_right_digit = right_digit_reg;
        
        case (current_state)
            INIT: begin
                // Initialize display to "00"
                next_left_digit = 4'h0;
                next_right_digit = 4'h0;
                next_state = WAIT_KEY;
            end
            
            WAIT_KEY: begin
                // Wait for valid key press
                if (key_valid) begin
                    // Check if this is the first key press (both digits are 0)
                    if (left_digit_reg == 4'h0 && right_digit_reg == 4'h0) begin
                        next_state = UPDATE_LEFT;
                    end else begin
                        next_state = UPDATE_RIGHT;
                    end
                end
            end
            
            UPDATE_LEFT: begin
                // First key press - put in left position, right stays 0
                next_left_digit = key_code;
                next_right_digit = 4'h0;  // Right stays 0 for first key
                // Handle race condition: if key_valid goes low, return to WAIT_KEY
                if (!key_valid) begin
                    next_state = WAIT_KEY;
                end else begin
                    next_state = HOLD_KEY;
                end
            end
            
            UPDATE_RIGHT: begin
                // Subsequent key presses - shift left to right, new key to left
                next_left_digit = key_code;
                next_right_digit = left_digit_reg;
                // Handle race condition: if key_valid goes low, return to WAIT_KEY
                if (!key_valid) begin
                    next_state = WAIT_KEY;
                end else begin
                    next_state = HOLD_KEY;
                end
            end
            
            HOLD_KEY: begin
                // Key is held down, wait for release
                if (!key_valid) begin
                    next_state = WAIT_KEY;
                end
            end
            
            // No default case needed - all enum values are covered
        endcase
    end
    
    // Output assignments
    assign digit_left = left_digit_reg;
    assign digit_right = right_digit_reg;

endmodule
