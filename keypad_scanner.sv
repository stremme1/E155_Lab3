// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Keypad Scanner

module keypad_scanner (
    input  logic        clk,
    input  logic        rst_n,
    output logic [3:0]  keypad_rows,    // FPGA drives rows (output)
    input  logic [3:0]  keypad_cols,    // FPGA reads columns (input)
    output logic [3:0]  key_code,
    output logic        key_pressed,
    output logic        key_valid
);

    logic [3:0]  row_counter;
    logic [3:0]  keypad_cols_sync1, keypad_cols_sync2;
    logic [3:0]  keypad_cols_sync;
    logic [3:0]  detected_key;
    logic        key_detected;
    logic [17:0] debounce_counter;
    logic        key_held;
    logic [7:0]  scan_counter;
    
    // Double synchronizer
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            keypad_cols_sync1 <= 4'b0000;
            keypad_cols_sync2 <= 4'b0000;
            keypad_cols_sync <= 4'b0000;
        end else begin
            keypad_cols_sync1 <= keypad_cols;
            keypad_cols_sync2 <= keypad_cols_sync1;
            keypad_cols_sync <= keypad_cols_sync2;
        end
    end
    
    // Row scanning counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            row_counter <= 4'b0001;
            scan_counter <= 8'd0;
        end else begin
            if (scan_counter == 8'd74) begin  // Change row every 75 clock cycles at 300Hz = 4ms per row
                scan_counter <= 8'd0;  // Reset counter
                row_counter <= {row_counter[2:0], row_counter[3]};
            end else begin
                scan_counter <= scan_counter + 1;
            end
        end
    end
    
    // Row outputs (FPGA drives one row HIGH, others LOW)
    assign keypad_rows = row_counter;
    
    // Key detection logic
    always_comb begin
        key_detected = 1'b0;
        detected_key = 4'b0000;
        
        case (row_counter)
            4'b0001: begin  // Row 0
                if (keypad_cols_sync[0]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b0001;  // Key 1
                end else if (keypad_cols_sync[1]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b0010;  // Key 2
                end else if (keypad_cols_sync[2]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b0011;  // Key 3
                end else if (keypad_cols_sync[3]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b1100;  // Key C
                end
            end
            4'b0010: begin  // Row 1
                if (keypad_cols_sync[0]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b0100;  // Key 4
                end else if (keypad_cols_sync[1]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b0101;  // Key 5
                end else if (keypad_cols_sync[2]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b0110;  // Key 6
                end else if (keypad_cols_sync[3]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b1101;  // Key D
                end
            end
            4'b0100: begin  // Row 2
                if (keypad_cols_sync[0]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b0111;  // Key 7
                end else if (keypad_cols_sync[1]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b1000;  // Key 8
                end else if (keypad_cols_sync[2]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b1001;  // Key 9
                end else if (keypad_cols_sync[3]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b1110;  // Key E
                end
            end
            4'b1000: begin  // Row 3
                if (keypad_cols_sync[0]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b1010;  // Key A
                end else if (keypad_cols_sync[1]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b0000;  // Key 0
                end else if (keypad_cols_sync[2]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b1011;  // Key B
                end else if (keypad_cols_sync[3]) begin
                    key_detected = 1'b1;
                    detected_key = 4'b1111;  // Key F
                end
            end
            default: begin
                key_detected = 1'b0;
                detected_key = 4'b0000;
            end
        endcase
    end
    
    // Debouncing state machine
    typedef enum logic [1:0] {
        IDLE,
        DEBOUNCE_WAIT,
        KEY_HELD
    } debounce_state_t;
    
    debounce_state_t debounce_state;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            debounce_state <= IDLE;
            debounce_counter <= 18'd0;
            key_code <= 4'h0;
            key_pressed <= 1'b0;
            key_valid <= 1'b0;
            key_held <= 1'b0;
        end else begin
            case (debounce_state)
                IDLE: begin
                    key_valid <= 1'b0;
                    if (key_detected && !key_held) begin
                        debounce_state <= DEBOUNCE_WAIT;
                        debounce_counter <= 18'd0;
                        key_code <= detected_key;
                        key_pressed <= 1'b1;
                    end else begin
                        key_pressed <= 1'b0;
                    end
                end
                
                DEBOUNCE_WAIT: begin
                    if (key_detected && (detected_key == key_code)) begin
                        if (debounce_counter >= 18'd6) begin  // ~20ms at 300Hz
                            debounce_state <= KEY_HELD;
                            key_valid <= 1'b1;
                            key_held <= 1'b1;
                            debounce_counter <= 18'd0;  // Reset counter
                        end else begin
                            debounce_counter <= debounce_counter + 1;
                        end
                    end else begin
                        debounce_state <= IDLE;
                        key_pressed <= 1'b0;
                        debounce_counter <= 18'd0;  // Reset counter
                    end
                end
                
                KEY_HELD: begin
                    key_valid <= 1'b0;
                    if (!key_detected) begin
                        debounce_state <= IDLE;
                        key_held <= 1'b0;
                        key_pressed <= 1'b0;
                    end
                end
                
                default: begin
                    debounce_state <= IDLE;
                    key_valid <= 1'b0;
                    key_pressed <= 1'b0;
                    key_held <= 1'b0;
                end
            endcase
        end
    end

endmodule