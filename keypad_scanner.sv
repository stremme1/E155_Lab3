// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Fixed Keypad Scanner - Working implementation

module keypad_scanner (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    output logic [3:0]  keypad_rows,   // Keypad row outputs (FPGA drives)
    input  logic [3:0]  keypad_cols,   // Keypad column inputs (FPGA reads)
    output logic [3:0]  key_code,      // 4-bit key code (0-F)
    output logic        key_valid      // Valid key press (debounced)
);

    // Row scanning
    logic [15:0] scan_counter;
    logic [1:0]  row_index;
    
    // Key detection
    logic [3:0]  keypad_cols_sync;
    logic [3:0]  detected_key;
    logic        key_detected;
    
    // Debouncing
    logic [16:0] debounce_counter;
    logic        key_held;
    logic [3:0]  latched_key;
    
    // Row scanning counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row_index <= 2'b00;
            scan_counter <= 16'd0;
        end else begin
            scan_counter <= scan_counter + 1;
            if (scan_counter >= 16'd99) begin  // Much smaller threshold for testing
                scan_counter <= 16'd0;
                row_index <= row_index + 1;
            end
        end
    end
    
    // Row outputs
    always_comb begin
        case (row_index)
            2'b00: keypad_rows = 4'b1110;  // Row 0
            2'b01: keypad_rows = 4'b1101;  // Row 1
            2'b10: keypad_rows = 4'b1011;  // Row 2
            2'b11: keypad_rows = 4'b0111;  // Row 3
        endcase
    end
    
    // Column synchronization
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            keypad_cols_sync <= 4'b1111;
        end else begin
            keypad_cols_sync <= keypad_cols;
        end
    end
    
    // Key detection
    always_comb begin
        key_detected = 1'b0;
        detected_key = 4'b0000;
        
        if (keypad_cols_sync != 4'b1111) begin
            key_detected = 1'b1;
            
            // Key mapping based on row and column
            case (row_index)
                2'b00: begin  // Row 0: 1, 2, 3, C
                    if (!keypad_cols_sync[0]) detected_key = 4'b0001;  // Key 1
                    else if (!keypad_cols_sync[1]) detected_key = 4'b0010;  // Key 2
                    else if (!keypad_cols_sync[2]) detected_key = 4'b0011;  // Key 3
                    else if (!keypad_cols_sync[3]) detected_key = 4'b1100;  // Key C
                end
                2'b01: begin  // Row 1: 4, 5, 6, D
                    if (!keypad_cols_sync[0]) detected_key = 4'b0100;  // Key 4
                    else if (!keypad_cols_sync[1]) detected_key = 4'b0101;  // Key 5
                    else if (!keypad_cols_sync[2]) detected_key = 4'b0110;  // Key 6
                    else if (!keypad_cols_sync[3]) detected_key = 4'b1101;  // Key D
                end
                2'b10: begin  // Row 2: 7, 8, 9, E
                    if (!keypad_cols_sync[0]) detected_key = 4'b0111;  // Key 7
                    else if (!keypad_cols_sync[1]) detected_key = 4'b1000;  // Key 8
                    else if (!keypad_cols_sync[2]) detected_key = 4'b1001;  // Key 9
                    else if (!keypad_cols_sync[3]) detected_key = 4'b1110;  // Key E
                end
                2'b11: begin  // Row 3: A, 0, B, F
                    if (!keypad_cols_sync[0]) detected_key = 4'b1010;  // Key A
                    else if (!keypad_cols_sync[1]) detected_key = 4'b0000;  // Key 0
                    else if (!keypad_cols_sync[2]) detected_key = 4'b1011;  // Key B
                    else if (!keypad_cols_sync[3]) detected_key = 4'b1111;  // Key F
                end
            endcase
        end
    end
    
    // Simple debouncing - much simpler logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_code <= 4'h0;
            key_valid <= 1'b0;
            key_held <= 1'b0;
            latched_key <= 4'h0;
            debounce_counter <= 17'd0;
        end else begin
            if (key_detected && !key_held) begin
                // New key detected
                if (detected_key != latched_key) begin
                    latched_key <= detected_key;
                    debounce_counter <= 17'd0;
                    key_valid <= 1'b0;
                end else begin
                    // Same key, count debounce
                    if (debounce_counter >= 17'd30) begin  // Much shorter for testing
                        key_code <= detected_key;
                        key_valid <= 1'b1;
                        key_held <= 1'b1;
                    end else begin
                        debounce_counter <= debounce_counter + 1;
                        key_valid <= 1'b0;
                    end
                end
            end else if (!key_detected) begin
                // Key released
                key_valid <= 1'b0;
                key_held <= 1'b0;
                latched_key <= 4'h0;
                debounce_counter <= 17'd0;
            end else begin
                // Key held, keep key_valid high
                // key_valid stays high until key is released
            end
        end
    end

endmodule