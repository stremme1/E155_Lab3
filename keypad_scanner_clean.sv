// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Clean FSM-based Keypad Scanner - Concise version inspired by Jackson's approach

module keypad_scanner_clean (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [3:0]  keypad_rows,   // Row inputs (FPGA reads)
    output logic [3:0]  keypad_cols,   // Column outputs (FPGA drives)
    output logic [3:0]  key_code,
    output logic        key_valid
);

    // FSM states
    typedef enum logic [2:0] {
        SCAN_COL0, SCAN_COL1, SCAN_COL2, SCAN_COL3,
        DEBOUNCE, DISPLAY, HOLD
    } state_t;
    
    state_t state, next_state;
    logic [3:0] col_scan, row_hold, col_hold;
    logic [15:0] debounce_counter;
    logic [3:0] detected_key;
    logic key_pressed, debounce_done, key_released;
    
    // Synchronizer for row inputs
    logic [3:0] rows_sync1, rows_sync2;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rows_sync1 <= 4'b0000;
            rows_sync2 <= 4'b0000;
        end else begin
            rows_sync1 <= keypad_rows;
            rows_sync2 <= rows_sync1;
        end
    end
    
    // Key detection logic
    assign key_pressed = (rows_sync2 != 4'b0000);
    
    // Key decoder - Emmett's layout
    always_comb begin
        detected_key = 4'h0;
        case (col_hold)
            4'b1110: case (row_hold)  // Column 0
                        4'b0001: detected_key = 4'h1;  // 1
                        4'b0010: detected_key = 4'h4;  // 4
                        4'b0100: detected_key = 4'h7;  // 7
                        4'b1000: detected_key = 4'hA;  // A
                        default: detected_key = 4'h0;
                    endcase
            4'b1101: case (row_hold)  // Column 1
                        4'b0001: detected_key = 4'h2;  // 2
                        4'b0010: detected_key = 4'h5;  // 5
                        4'b0100: detected_key = 4'h8;  // 8
                        4'b1000: detected_key = 4'h0;  // 0
                        default: detected_key = 4'h0;
                    endcase
            4'b1011: case (row_hold)  // Column 2
                        4'b0001: detected_key = 4'h3;  // 3
                        4'b0010: detected_key = 4'h6;  // 6
                        4'b0100: detected_key = 4'h9;  // 9
                        4'b1000: detected_key = 4'hB;  // B
                        default: detected_key = 4'h0;
                    endcase
            4'b0111: case (row_hold)  // Column 3
                        4'b0001: detected_key = 4'hC;  // C
                        4'b0010: detected_key = 4'hD;  // D
                        4'b0100: detected_key = 4'hE;  // E
                        4'b1000: detected_key = 4'hF;  // F
                        default: detected_key = 4'h0;
                    endcase
            default: detected_key = 4'h0;
        endcase
    end
    
    // FSM state transitions
    always_comb begin
        next_state = state;
        case (state)
            SCAN_COL0: next_state = key_pressed ? DEBOUNCE : SCAN_COL1;
            SCAN_COL1: next_state = key_pressed ? DEBOUNCE : SCAN_COL2;
            SCAN_COL2: next_state = key_pressed ? DEBOUNCE : SCAN_COL3;
            SCAN_COL3: next_state = key_pressed ? DEBOUNCE : SCAN_COL0;
            DEBOUNCE:  next_state = debounce_done ? DISPLAY : 
                                   key_pressed ? DEBOUNCE : SCAN_COL0;
            DISPLAY:   next_state = HOLD;
            HOLD:      next_state = key_released ? SCAN_COL0 : HOLD;
            default:   next_state = SCAN_COL0;
        endcase
    end
    
    // FSM state register and outputs
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= SCAN_COL0;
            col_scan <= 4'b1110;  // Start with column 0
            debounce_counter <= 16'd0;
            key_code <= 4'h0;
            key_valid <= 1'b0;
        end else begin
            state <= next_state;
            
            // Column scanning
            case (state)
                SCAN_COL0: col_scan <= 4'b1110;
                SCAN_COL1: col_scan <= 4'b1101;
                SCAN_COL2: col_scan <= 4'b1011;
                SCAN_COL3: col_scan <= 4'b0111;
                default:   col_scan <= 4'b1110;
            endcase
            
            // Store row/column when key detected
            if (state == SCAN_COL0 && key_pressed) begin
                row_hold <= rows_sync2;
                col_hold <= 4'b1110;
            end else if (state == SCAN_COL1 && key_pressed) begin
                row_hold <= rows_sync2;
                col_hold <= 4'b1101;
            end else if (state == SCAN_COL2 && key_pressed) begin
                row_hold <= rows_sync2;
                col_hold <= 4'b1011;
            end else if (state == SCAN_COL3 && key_pressed) begin
                row_hold <= rows_sync2;
                col_hold <= 4'b0111;
            end
            
            // Debounce counter
            if (state == DEBOUNCE) begin
                if (key_pressed) begin
                    if (debounce_counter >= 16'd30000) begin  // ~10ms at 3MHz
                        debounce_done <= 1'b1;
                    end else begin
                        debounce_counter <= debounce_counter + 1;
                    end
                end else begin
                    debounce_counter <= 16'd0;
                    debounce_done <= 1'b0;
                end
            end else begin
                debounce_counter <= 16'd0;
                debounce_done <= 1'b0;
            end
            
            // Display and hold logic
            if (state == DISPLAY) begin
                key_code <= detected_key;
                key_valid <= 1'b1;
            end else if (state == HOLD) begin
                key_valid <= 1'b0;
                if (!key_pressed) begin
                    key_released <= 1'b1;
                end else begin
                    key_released <= 1'b0;
                end
            end else begin
                key_valid <= 1'b0;
                key_released <= 1'b0;
            end
        end
    end
    
    // Column outputs
    assign keypad_cols = col_scan;

endmodule
