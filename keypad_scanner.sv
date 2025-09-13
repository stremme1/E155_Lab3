// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Clean Keypad Scanner - Keeps synchronizers and state machine, removes complexity

module keypad_scanner (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    input  logic [3:0]  keypad_rows,   // Keypad row inputs (FPGA reads)
    output logic [3:0]  keypad_cols,   // Keypad column outputs (FPGA drives)
    output logic [3:0]  key_code,      // 4-bit key code (0-F)
    output logic        key_pressed,   // Key press detected (not used in top level)
    output logic        key_valid      // Valid key press (debounced)
);

    // Essential signals only
    logic [3:0]  col_counter;          // Column scanning counter
    logic [3:0]  keypad_rows_sync1, keypad_rows_sync2;  // Double synchronizer
    logic [3:0]  keypad_rows_sync;     // Final synchronized input
    logic [3:0]  detected_key;         // Currently detected key
    logic        key_detected;         // Key detection signal
    logic [17:0] debounce_counter;     // Debounce counter
    logic        key_held;             // Key is being held down
    
    // Double synchronizer to prevent metastability (KEEP THIS!)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            keypad_rows_sync1 <= 4'b0000;
            keypad_rows_sync2 <= 4'b0000;
            keypad_rows_sync <= 4'b0000;
        end else begin
            keypad_rows_sync1 <= keypad_rows;
            keypad_rows_sync2 <= keypad_rows_sync1;
            keypad_rows_sync <= keypad_rows_sync2;
        end
    end
    
    // Enhanced state machine based on working lab examples
    typedef enum logic [2:0] {
        SCAN_COL0, SCAN_COL1, SCAN_COL2, SCAN_COL3,  // Column scanning states
        DEBOUNCE_WAIT,                                // Debouncing state
        KEY_VALID,                                    // Key confirmed valid
        WAIT_RELEASE                                  // Wait for key release
    } scan_state_t;
    
    scan_state_t scan_state;
    logic [5:0] debounce_counter;
    logic [3:0] current_col;
    logic [7:0] scan_counter;  // Counter to slow down column scanning
    
    // Enhanced scanning state machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_state <= SCAN_COL0;
            col_counter <= 4'b0001;  // Start with column 0 (one-hot)
            debounce_counter <= 6'd0;
            current_col <= 4'b0000;
            scan_counter <= 8'd0;
        end else begin
            case (scan_state)
                SCAN_COL0: begin
                    col_counter <= 4'b0001;
                    current_col <= 4'b0000;
                    if (key_detected) begin
                        scan_state <= DEBOUNCE_WAIT;
                        debounce_counter <= 6'd0;
                    end else if (scan_counter >= 8'd100) begin  // Wait 100 clock cycles before next column
                        scan_state <= SCAN_COL1;
                        scan_counter <= 8'd0;
                    end else begin
                        scan_counter <= scan_counter + 1;
                    end
                end
                
                SCAN_COL1: begin
                    col_counter <= 4'b0010;
                    current_col <= 4'b0001;
                    if (key_detected) begin
                        scan_state <= DEBOUNCE_WAIT;
                        debounce_counter <= 6'd0;
                    end else if (scan_counter >= 8'd100) begin  // Wait 100 clock cycles before next column
                        scan_state <= SCAN_COL2;
                        scan_counter <= 8'd0;
                    end else begin
                        scan_counter <= scan_counter + 1;
                    end
                end
                
                SCAN_COL2: begin
                    col_counter <= 4'b0100;
                    current_col <= 4'b0010;
                    if (key_detected) begin
                        scan_state <= DEBOUNCE_WAIT;
                        debounce_counter <= 6'd0;
                    end else if (scan_counter >= 8'd100) begin  // Wait 100 clock cycles before next column
                        scan_state <= SCAN_COL3;
                        scan_counter <= 8'd0;
                    end else begin
                        scan_counter <= scan_counter + 1;
                    end
                end
                
                SCAN_COL3: begin
                    col_counter <= 4'b1000;
                    current_col <= 4'b0011;
                    if (key_detected) begin
                        scan_state <= DEBOUNCE_WAIT;
                        debounce_counter <= 6'd0;
                    end else if (scan_counter >= 8'd100) begin  // Wait 100 clock cycles before next column
                        scan_state <= SCAN_COL0;
                        scan_counter <= 8'd0;
                    end else begin
                        scan_counter <= scan_counter + 1;
                    end
                end
                
                DEBOUNCE_WAIT: begin
                    if (key_detected) begin
                        if (debounce_counter >= 6'd60) begin  // 60 clock cycles debounce (~20ms at 3MHz)
                            scan_state <= KEY_VALID;
                        end else begin
                            debounce_counter <= debounce_counter + 1;
                        end
                    end else begin
                        scan_state <= SCAN_COL0;  // Key released during debounce
                    end
                end
                
                KEY_VALID: begin
                    scan_state <= WAIT_RELEASE;
                end
                
                WAIT_RELEASE: begin
                    if (!key_detected) begin
                        scan_state <= SCAN_COL0;  // Key released, resume scanning
                    end
                end
                
                default: scan_state <= SCAN_COL0;
            endcase
        end
    end
    
    // Assign column outputs (one-hot encoding) - FPGA drives columns HIGH
    assign keypad_cols = col_counter;
    
    // Enhanced key detection logic with proper row scanning
    always_comb begin
        key_detected = 1'b0;
        detected_key = 4'b0000;
        
        // Check for any row being pressed (any row goes LOW when pressed)
        if (!keypad_rows_sync[0] || !keypad_rows_sync[1] || !keypad_rows_sync[2] || !keypad_rows_sync[3]) begin
            key_detected = 1'b1;
            
            // Determine which key based on current column and pressed row
            // EMMETT'S KEYPAD LAYOUT (different from working code):
            //     C0  C1  C2  C3
            // R0    1   2   3   C
            // R1    4   5   6   D  
            // R2    7   8   9   E
            // R3    A   0   B   F
            case (current_col)
                2'b00: begin  // Column 0
                    if (!keypad_rows_sync[0]) detected_key = 4'b0001;      // Key 1
                    else if (!keypad_rows_sync[1]) detected_key = 4'b0100; // Key 4
                    else if (!keypad_rows_sync[2]) detected_key = 4'b0111; // Key 7
                    else if (!keypad_rows_sync[3]) detected_key = 4'b1010; // Key A
                end
                2'b01: begin  // Column 1
                    if (!keypad_rows_sync[0]) detected_key = 4'b0010;      // Key 2
                    else if (!keypad_rows_sync[1]) detected_key = 4'b0101; // Key 5
                    else if (!keypad_rows_sync[2]) detected_key = 4'b1000; // Key 8
                    else if (!keypad_rows_sync[3]) detected_key = 4'b0000; // Key 0
                end
                2'b10: begin  // Column 2
                    if (!keypad_rows_sync[0]) detected_key = 4'b0011;      // Key 3
                    else if (!keypad_rows_sync[1]) detected_key = 4'b0110; // Key 6
                    else if (!keypad_rows_sync[2]) detected_key = 4'b1001; // Key 9
                    else if (!keypad_rows_sync[3]) detected_key = 4'b1011; // Key B
                end
                2'b11: begin  // Column 3
                    if (!keypad_rows_sync[0]) detected_key = 4'b1100;      // Key C
                    else if (!keypad_rows_sync[1]) detected_key = 4'b1101; // Key D
                    else if (!keypad_rows_sync[2]) detected_key = 4'b1110; // Key E
                    else if (!keypad_rows_sync[3]) detected_key = 4'b1111; // Key F
                end
            endcase
        end
    end
    
    // Simplified output logic using enhanced state machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_code <= 4'h0;
            key_pressed <= 1'b0;
            key_valid <= 1'b0;
            key_held <= 1'b0;
        end else begin
            case (scan_state)
                SCAN_COL0, SCAN_COL1, SCAN_COL2, SCAN_COL3: begin
                    key_valid <= 1'b0;
                    key_pressed <= 1'b0;
                    if (key_detected) begin
                        key_code <= detected_key;
                    end
                end
                
                DEBOUNCE_WAIT: begin
                    key_valid <= 1'b0;
                    key_pressed <= 1'b0;
                end
                
                KEY_VALID: begin
                    key_valid <= 1'b1;
                    key_pressed <= 1'b1;
                    key_held <= 1'b1;
                end
                
                WAIT_RELEASE: begin
                    key_valid <= 1'b0;
                    key_pressed <= 1'b0;
                end
                
                default: begin
                    key_valid <= 1'b0;
                    key_pressed <= 1'b0;
                end
            endcase
        end
    end

endmodule