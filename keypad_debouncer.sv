// ============================================================================
// FIXED KEYPAD DEBOUNCER MODULE
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Fixed keypad debouncer with proper key hold behavior
// ============================================================================

module keypad_debouncer (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  key_code,     // from decoder (4-bit key code)
    input  logic        key_detected, // from scanner (any key pressed)
    output logic        key_valid,    // debounced valid key press
    output logic [3:0]  debounced_key, // debounced key code
	output logic 		scan_stop
);

    // State machine
    typedef enum logic [1:0] {
        IDLE,           // No key pressed
        DEBOUNCING,     // Key pressed, debouncing
        KEY_HELD        // Key held, ignore additional presses
    } debouncer_state_t;
    
    debouncer_state_t current_state;
    
    // Debounce counter and key
    logic [19:0] debounce_cnt;
    logic [3:0]  l_key;
    
    localparam int DEBOUNCE_MAX = 20'd59999; // ~20ms @ 3MHz

    // State machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            debounce_cnt <= 20'd0;
            l_key <= 4'b0000;
        end else begin
            case (current_state)
                IDLE: begin
                    if (key_detected && key_code != 4'b0000) begin
                        current_state <= DEBOUNCING;
                        l_key <= key_code;
                        debounce_cnt <= 20'd0;
                    end
                end
                
                DEBOUNCING: begin
                    if (!key_detected) begin
                        current_state <= IDLE;
                    end else if (debounce_cnt >= DEBOUNCE_MAX) begin
                        current_state <= KEY_HELD;
                    end else begin
                        debounce_cnt <= debounce_cnt + 1;
                        if (debounce_cnt % 10000 == 0) begin
                            $display("Debouncer: debounce_cnt=%0d, DEBOUNCE_MAX=%0d", debounce_cnt, DEBOUNCE_MAX);
                        end
                    end
                end
                
                KEY_HELD: begin
                    if (!key_detected) begin
                        current_state <= IDLE;
                    end
                end
                
                default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end

    // Output logic
    always_comb begin
        case (current_state)
            IDLE: begin
                key_valid = 1'b0;
                debounced_key = 4'b0000;
                scan_stop = 1'b0;
            end
            
            DEBOUNCING: begin
                scan_stop = 1'b1;
                if (debounce_cnt >= DEBOUNCE_MAX) begin
                    key_valid = 1'b1;
                    debounced_key = l_key;
                end else begin
                    key_valid = 1'b0;
                    debounced_key = 4'b0000;
                end
            end
            
            KEY_HELD: begin
                scan_stop = 1'b1;
                key_valid = 1'b0;
                debounced_key = 4'b0000;
            end
            
            default: begin
                key_valid = 1'b0;
                debounced_key = 4'b0000;
                scan_stop = 1'b0;
            end
        endcase
    end

endmodule
