// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Clean Keypad Scanner - Keeps synchronizers and state machine, removes complexity

module keypad_scanner (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    output logic [3:0]  keypad_rows,   // Keypad row outputs (FPGA drives)
    input  logic [3:0]  keypad_cols,   // Keypad column inputs (FPGA reads)
    output logic [3:0]  key_code,      // 4-bit key code (0-F)
    output logic        key_valid      // Valid key press (debounced)
);

    // Essential signals only
    logic [3:0]  row_counter;          // Row scanning counter
    logic [3:0]  keypad_cols_sync1, keypad_cols_sync2, keypad_cols_sync;  // Double synchronizer
    logic [3:0]  detected_key;         // Currently detected key
    logic        key_detected;         // Key detection signal
    logic [3:0]  latched_key;          // Latched key for debounce
    logic        key_latched;          // Key has been latched for debounce
    logic [16:0] debounce_counter;     // Debounce counter (17 bits for 3MHz timing)
    logic        key_held;             // Key is being held down
    
    // Double synchronizer to prevent metastability
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            keypad_cols_sync1 <= 4'b1111;  // Reset to idle state (no keys pressed)
            keypad_cols_sync2 <= 4'b1111;
            keypad_cols_sync <= 4'b1111;
        end else begin
            keypad_cols_sync1 <= keypad_cols;
            keypad_cols_sync2 <= keypad_cols_sync1;
            keypad_cols_sync <= keypad_cols_sync2;
        end
    end
    
    // Row scanning counter (cycles through rows 0-3) - Proper timing for keypad detection
    logic [15:0] scan_counter;  // 16-bit counter for proper timing
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row_counter <= 4'b0001;  // Start with row 0 (one-hot)
            scan_counter <= 16'd0;
        end else begin
            scan_counter <= scan_counter + 1;
            if (scan_counter >= 16'd5999) begin   // Change row every 6000 cycles (2ms at 3MHz)
                scan_counter <= 16'd0;
                row_counter <= {row_counter[2:0], row_counter[3]};  // Rotate left
            end
        end
    end
    
    // Assign row outputs (one-hot encoding) - FPGA drives one row LOW, others HIGH (3.3kΩ pull-ups)
    assign keypad_rows = ~row_counter;
    
    // Key detection logic - First detect IF any key is pressed, then scan to find WHICH key
    always_comb begin
        key_detected = 1'b0;
        detected_key = 4'b0000;
        
        // First check: Is ANY key pressed? (any column goes LOW due to 3.3kΩ pull-ups)
        if (keypad_cols_sync != 4'b1111) begin
            key_detected = 1'b1;
            
            // Second check: Which specific key is pressed based on current row and column
            // Your specific 4x4 keypad layout:
            //     C0  C1  C2  C3
            // R0    1   2   3   C
            // R1    4   5   6   D  
            // R2    7   8   9   E
            // R3    A   0   B   F
            case (row_counter)
                4'b0001: begin  // Row 0
                    if (!keypad_cols_sync[0]) detected_key = 4'b0001;  // Key 1
                    else if (!keypad_cols_sync[1]) detected_key = 4'b0010;  // Key 2
                    else if (!keypad_cols_sync[2]) detected_key = 4'b0011;  // Key 3
                    else if (!keypad_cols_sync[3]) detected_key = 4'b1100;  // Key C
                end
                4'b0010: begin  // Row 1
                    if (!keypad_cols_sync[0]) detected_key = 4'b0100;  // Key 4
                    else if (!keypad_cols_sync[1]) detected_key = 4'b0101;  // Key 5
                    else if (!keypad_cols_sync[2]) detected_key = 4'b0110;  // Key 6
                    else if (!keypad_cols_sync[3]) detected_key = 4'b1101;  // Key D
                end
                4'b0100: begin  // Row 2
                    if (!keypad_cols_sync[0]) detected_key = 4'b0111;  // Key 7
                    else if (!keypad_cols_sync[1]) detected_key = 4'b1000;  // Key 8
                    else if (!keypad_cols_sync[2]) detected_key = 4'b1001;  // Key 9
                    else if (!keypad_cols_sync[3]) detected_key = 4'b1110;  // Key E
                end
                4'b1000: begin  // Row 3
                    if (!keypad_cols_sync[0]) detected_key = 4'b1010;  // Key A
                    else if (!keypad_cols_sync[1]) detected_key = 4'b0000;  // Key 0
                    else if (!keypad_cols_sync[2]) detected_key = 4'b1011;  // Key B
                    else if (!keypad_cols_sync[3]) detected_key = 4'b1111;  // Key F
                end
                default: begin
                    // No key detected in this row
                    key_detected = 1'b0;
                    detected_key = 4'b0000;
                end
            endcase
        end
    end
    
    // Simple debouncing state machine (KEEP THIS!)
    typedef enum logic [1:0] {
        IDLE,           // No key detected
        DEBOUNCE_WAIT,  // Key detected, waiting for debounce
        KEY_HELD        // Key confirmed valid
    } debounce_state_t;
    
    debounce_state_t debounce_state;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            debounce_state <= IDLE;
            debounce_counter <= 17'd0;
            key_code <= 4'h0;
            key_valid <= 1'b0;
            key_held <= 1'b0;
            latched_key <= 4'h0;
            key_latched <= 1'b0;
        end else begin
            case (debounce_state)
                IDLE: begin
                    key_valid <= 1'b0;
                    if (key_detected && !key_held && !key_latched) begin
                        debounce_state <= DEBOUNCE_WAIT;
                        debounce_counter <= 17'd0;
                        latched_key <= detected_key;
                        key_latched <= 1'b1;
                    end
                end
                
                DEBOUNCE_WAIT: begin
                    if (key_detected && (detected_key == latched_key)) begin
                        if (debounce_counter >= 17'd60000) begin   // 20ms at 3MHz
                            debounce_state <= KEY_HELD;
                            key_valid <= 1'b1;
                            key_held <= 1'b1;
                            key_code <= latched_key;
                        end else begin
                            debounce_counter <= debounce_counter + 1;
                        end
                    end else if (!key_detected) begin
                        // Key released during debounce - reset
                        debounce_state <= IDLE;
                        key_latched <= 1'b0;
                    end
                    // If key_detected but different key, keep waiting (key might be bouncing)
                end
                
                KEY_HELD: begin
                    key_valid <= 1'b0;
                    if (!key_detected) begin
                        debounce_state <= IDLE;
                        key_held <= 1'b0;
                        key_latched <= 1'b0;
                    end
                end
                
                default: begin
                    // Invalid state - reset to IDLE
                    debounce_state <= IDLE;
                    key_valid <= 1'b0;
                    key_held <= 1'b0;
                    key_latched <= 1'b0;
                end
            endcase
        end
    end

endmodule