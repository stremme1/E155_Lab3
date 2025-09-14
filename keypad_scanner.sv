// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Keypad Scanner

module keypad_scanner (
    input  logic        clk,
    input  logic        rst_n,
    output logic [3:0]  keypad_cols,    // FPGA drives columns (output) 
    input  logic [3:0]  keypad_rows,    // FPGA reads rows (input) 
    output logic [3:0]  key_code,
    output logic        key_pressed,
    output logic        key_valid
);

    logic [3:0]  col_counter;
    logic [3:0]  keypad_rows_sync1, keypad_rows_sync2;
    logic [3:0]  keypad_rows_sync;
    logic [3:0]  detected_key;
    logic        key_detected;
    logic [17:0] debounce_counter;
    logic        key_held;
    logic [7:0]  scan_counter;
    
    // Double synchronizer for rows 
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
    
    // Column scanning counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            col_counter <= 4'b0001;
            scan_counter <= 8'd0;
        end else begin
            if (scan_counter == 8'd74) begin  // Change column every 75 clock cycles at 300Hz = 4ms per column
                scan_counter <= 8'd0;  // Reset counter
                col_counter <= {col_counter[2:0], col_counter[3]};
            end else begin
                scan_counter <= scan_counter + 1;
            end
        end
    end
    
    // Column outputs (FPGA drives one column LOW, others HIGH - like Jackson's design)
    assign keypad_cols = ~col_counter;
    
    // Key detection logic (like Jackson's design - detect specific row patterns)
    always_comb begin
        key_detected = 1'b0;
        detected_key = 4'b0000;
        
        // Check for key press (any row active)
        if ((keypad_rows_sync == 4'b0001) || (keypad_rows_sync == 4'b0010) || 
            (keypad_rows_sync == 4'b0100) || (keypad_rows_sync == 4'b1000)) begin
            key_detected = 1'b1;
            
            // Decode key based on column and row
            case (col_counter)
                4'b0001: begin  // Column 0
                    case (keypad_rows_sync)
                        4'b0001: detected_key = 4'b0001;  // Key 1
                        4'b0010: detected_key = 4'b0100;  // Key 4
                        4'b0100: detected_key = 4'b0111;  // Key 7
                        4'b1000: detected_key = 4'b1010;  // Key A
                        default: detected_key = 4'b0000;
                    endcase
                end
                4'b0010: begin  // Column 1
                    case (keypad_rows_sync)
                        4'b0001: detected_key = 4'b0010;  // Key 2
                        4'b0010: detected_key = 4'b0101;  // Key 5
                        4'b0100: detected_key = 4'b1000;  // Key 8
                        4'b1000: detected_key = 4'b0000;  // Key 0
                        default: detected_key = 4'b0000;
                    endcase
                end
                4'b0100: begin  // Column 2
                    case (keypad_rows_sync)
                        4'b0001: detected_key = 4'b0011;  // Key 3
                        4'b0010: detected_key = 4'b0110;  // Key 6
                        4'b0100: detected_key = 4'b1001;  // Key 9
                        4'b1000: detected_key = 4'b1011;  // Key B
                        default: detected_key = 4'b0000;
                    endcase
                end
                4'b1000: begin  // Column 3
                    case (keypad_rows_sync)
                        4'b0001: detected_key = 4'b1100;  // Key C
                        4'b0010: detected_key = 4'b1101;  // Key D
                        4'b0100: detected_key = 4'b1110;  // Key E
                        4'b1000: detected_key = 4'b1111;  // Key F
                        default: detected_key = 4'b0000;
                    endcase
                end
                default: detected_key = 4'b0000;
            endcase
        end
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
