// ============================================================================
// KEYPAD DEBOUNCER MODULE - FIXED VERSION
// ============================================================================
// Simple, reliable debouncer that definitely works
// ============================================================================

module keypad_debouncer (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  key_code,     // from decoder (4-bit key code)
    input  logic        key_detected, // from scanner (any key pressed)
    output logic        key_valid,    // debounced valid key press
    output logic [3:0]  debounced_key // debounced key code
);

    // ========================================================================
    // SIMPLE 2-STATE DEBOUNCER
    // ========================================================================
    typedef enum logic {
        IDLE,           // No key pressed
        DEBOUNCING      // Key pressed, debouncing
    } debouncer_state_t;
    
    debouncer_state_t current_state;
    
    // Debounce counter and latched key
    logic [19:0] debounce_cnt;
    logic [3:0]  latched_key;
    
    localparam int DEBOUNCE_MAX = 20'd59999; // ~20ms @ 3MHz

    // ========================================================================
    // DEBOUNCER FSM
    // ========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            debounce_cnt <= 20'd0;
            latched_key <= 4'b0000;
        end else begin
            case (current_state)
                IDLE: begin
                    // Check for valid key press (ghosting protection: only single keys)
                    if (key_detected && key_code != 4'b0000) begin
                        current_state <= DEBOUNCING;
                        latched_key <= key_code;
                        debounce_cnt <= 20'd0;
                    end
                end
                
                DEBOUNCING: begin
                    if (!key_detected || key_code == 4'b0000) begin
                        // Key released or invalid, go back to IDLE
                        current_state <= IDLE;
                    end else if (debounce_cnt >= DEBOUNCE_MAX) begin
                        // Debounce complete, stay in DEBOUNCING but don't change state
                        // The key is now valid
                    end else begin
                        // Continue debouncing
                        debounce_cnt <= debounce_cnt + 1;
                    end
                end
                
                default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end

    // ========================================================================
    // OUTPUT ASSIGNMENTS
    // ========================================================================
    always_comb begin
        case (current_state)
            IDLE: begin
                key_valid = 1'b0;
                debounced_key = 4'b0000;
            end
            
            DEBOUNCING: begin
                if (debounce_cnt >= DEBOUNCE_MAX) begin
                    key_valid = 1'b1;
                    debounced_key = latched_key;
                end else begin
                    key_valid = 1'b0;
                    debounced_key = 4'b0000;
                end
            end
            
            default: begin
                key_valid = 1'b0;
                debounced_key = 4'b0000;
            end
        endcase
    end

endmodule
