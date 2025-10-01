// ============================================================================
// KEYPAD DEBOUNCER MODULE
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Keypad Debouncer - Switch Debouncing Logic
// This module implements a 2-state debouncer to eliminate switch bouncing
// and ensure each key press is registered only once. Features 20ms debounce
// period and proper state machine implementation.
// ============================================================================

module keypad_debouncer (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  key_code,     // from decoder (4-bit key code)
    input  logic        key_detected, // from scanner (any key pressed)
    output logic        key_valid,    // debounced valid key press
    output logic [3:0]  debounced_key, // debounced key code
    output logic        scan_stop,
    // Enhanced outputs for multi-key support
    output logic        key_held,        // Signal that a key is currently held
    output logic [3:0]  held_key_code,   // The code of the held key
    output logic        flash_enable,    // Enable flashing behavior
    output logic        combo_ready      // Ready for key combination detection
);

    // ========================================================================
    // ENHANCED 3-STATE DEBOUNCER WITH MULTIPLE KEY PROTECTION
    // ========================================================================
    typedef enum logic [1:0] {
        IDLE,           // No key pressed
        DEBOUNCING,     // Key pressed, debouncing
        KEY_HELD        // Key held, ignore additional presses
    } debouncer_state_t;
    
    debouncer_state_t current_state;
    
    // Debounce counter and key
    logic [19:0] debounce_cnt;
    logic [3:0]  l_key;
    
    // Enhanced timing and state signals
    logic [19:0] hold_timer;        // Timer for how long key has been held
    logic [19:0] flash_timer;       // Timer for flash timing
    logic        flash_state;       // Current flash state (on/off)
    logic        prev_key_detected; // Previous key_detected state for edge detection
    
    localparam DEBOUNCE_MAX = 20'd59999; // ~20ms @ 3MHz
    localparam HOLD_FLASH_START = 20'd299999; // 1 second @ 3MHz to start flashing
    localparam FLASH_PERIOD = 20'd149999;     // 500ms flash period @ 3MHz
    localparam FLASH_ON_TIME = 20'd29999;     // 100ms flash on time @ 3MHz

    // ========================================================================
    // DEBOUNCER FSM
    // ========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            debounce_cnt <= 20'd0;
            l_key <= 4'b0000;
            hold_timer <= 20'd0;
            flash_timer <= 20'd0;
            flash_state <= 1'b0;
            prev_key_detected <= 1'b0;
        end else begin
            prev_key_detected <= key_detected;
            case (current_state)
                IDLE: begin
                    // Reset enhanced signals
                    hold_timer <= 20'd0;
                    flash_timer <= 20'd0;
                    flash_state <= 1'b0;
                    
                    // Check for valid key press (ghosting protection: only single keys)
                    if (key_detected && key_code != 4'b0000) begin
                        current_state <= DEBOUNCING;
                        l_key <= key_code;
                        debounce_cnt <= 20'd0;
                    end
                end
                
                DEBOUNCING: begin
                    if (!key_detected || key_code == 4'b0000) begin
                        // Key released or invalid, go back to IDLE
                        current_state <= IDLE;
                    end else if (debounce_cnt >= DEBOUNCE_MAX) begin
                        // Debounce complete, move to KEY_HELD state
                        current_state <= KEY_HELD;
                        hold_timer <= 20'd0;  // Reset hold timer
                    end else begin
                        // Continue debouncing
                        debounce_cnt <= debounce_cnt + 1;
                    end
                end
                
                KEY_HELD: begin
                    // Increment hold timer
                    hold_timer <= hold_timer + 1;
                    
                    // Implement flash timing logic
                    if (hold_timer >= HOLD_FLASH_START) begin
                        // Start flashing after 1 second
                        flash_timer <= flash_timer + 1;
                        if (flash_timer >= FLASH_PERIOD) begin
                            flash_state <= ~flash_state;
                            flash_timer <= 20'd0;
                        end
                    end
                    
                    // Check for key release
                    if (!key_detected || key_code == 4'b0000) begin
                        // Key released, go back to IDLE
                        current_state <= IDLE;
                        hold_timer <= 20'd0;
                        flash_timer <= 20'd0;
                        flash_state <= 1'b0;
                    end
                    // Stay in KEY_HELD state while key is pressed, but allow additional processing
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
                scan_stop = 1'b0;
                key_held = 1'b0;
                held_key_code = 4'b0000;
                flash_enable = 1'b0;
                combo_ready = 1'b0;
            end
            
            DEBOUNCING: begin
                scan_stop = 1'b1;
                key_held = 1'b0;
                held_key_code = 4'b0000;
                flash_enable = 1'b0;
                combo_ready = 1'b0;
                if (debounce_cnt >= DEBOUNCE_MAX) begin
                    key_valid = 1'b1;
                    debounced_key = l_key;
                end else begin
                    key_valid = 1'b0;
                    debounced_key = 4'b0000;
                end
            end
            
            KEY_HELD: begin
                // Enhanced KEY_HELD behavior - allow continued scanning
                scan_stop = 1'b0;  // Allow continued scanning for multi-key detection
                key_valid = 1'b0;  // No new key valid while key is held
                debounced_key = 4'b0000;  // Don't output key code while held
                
                // Enhanced outputs
                key_held = 1'b1;
                held_key_code = l_key;
                flash_enable = 1'b1;  // Always enable flashing when key is held
                combo_ready = 1'b1;  // Ready for combination detection
            end
            
            default: begin
                key_valid = 1'b0;
                debounced_key = 4'b0000;
                scan_stop = 1'b0;
                key_held = 1'b0;
                held_key_code = 4'b0000;
                flash_enable = 1'b0;
                combo_ready = 1'b0;
            end
        endcase
    end

endmodule
