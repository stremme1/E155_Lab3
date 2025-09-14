// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Keypad Scanner -

module keypad_scanner (
    input  logic        clk,
    input  logic        rst_n,
    output logic [3:0]  keypad_cols,    // FPGA drives columns (output) - 
    input  logic [3:0]  keypad_rows,    // FPGA reads rows (input) - 
    output logic [3:0]  key_code,
    output logic        key_pressed,
    output logic        key_valid
);

    // FSM State Definition 
    typedef enum logic [2:0] {
        SCAN_COL0,      // Scan column 0
        SCAN_COL1,      // Scan column 1  
        SCAN_COL2,      // Scan column 2
        SCAN_COL3,      // Scan column 3
        INITIALIZE,     // Initialize key detection
        VERIFY,         // Verify key press
        HOLD            // Hold until key released
    } scan_state_t;
    
    scan_state_t current_state, next_state;
    logic [3:0]  keypad_rows_sync1, keypad_rows_sync2;
    logic [3:0]  keypad_rows_sync;
    logic [3:0]  detected_key;
    logic        key_detected;
    logic [17:0] debounce_counter;
    logic        key_held;
    logic [3:0]  col_scan;
    logic [3:0]  row_hold;
    logic        exit_scan;
    
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
    
    // Exit scan detection 
    assign exit_scan = ((keypad_rows_sync == 4'b0001) || (keypad_rows_sync == 4'b0010) || 
                       (keypad_rows_sync == 4'b0100) || (keypad_rows_sync == 4'b1000));
    
    // Column outputs 
    always_comb begin
        case (current_state)
            SCAN_COL0: keypad_cols = 4'b1110;
            SCAN_COL1: keypad_cols = 4'b1101;
            SCAN_COL2: keypad_cols = 4'b1011;
            SCAN_COL3: keypad_cols = 4'b0111;
            default:   keypad_cols = 4'b1111;
        endcase
    end
    
    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            SCAN_COL0: begin
                if (exit_scan) next_state = INITIALIZE;
                else next_state = SCAN_COL1;
            end
            SCAN_COL1: begin
                if (exit_scan) next_state = INITIALIZE;
                else next_state = SCAN_COL2;
            end
            SCAN_COL2: begin
                if (exit_scan) next_state = INITIALIZE;
                else next_state = SCAN_COL3;
            end
            SCAN_COL3: begin
                if (exit_scan) next_state = INITIALIZE;
                else next_state = SCAN_COL0;
            end
            INITIALIZE: next_state = VERIFY;
            VERIFY: begin
                if (key_detected) next_state = HOLD;
                else next_state = SCAN_COL0;
            end
            HOLD: begin
                if (!exit_scan) next_state = SCAN_COL0;
                else next_state = HOLD;
            end
            default: next_state = SCAN_COL0;
        endcase
    end
    
    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= SCAN_COL0;
            col_scan <= 4'b0000;
            row_hold <= 4'b0000;
            // key_code and key_pressed are assigned via combinational logic
            key_valid <= 1'b0;
            key_held <= 1'b0;
            debounce_counter <= 18'd0;
        end else begin
            current_state <= next_state;
            
            // Store column and row when initializing
            if (next_state == INITIALIZE) begin
                col_scan <= keypad_cols;
                row_hold <= keypad_rows_sync;
            end
            
            // Key detection and debouncing
            case (next_state)
                VERIFY: begin
                    if (key_detected) begin
                        if (debounce_counter >= 18'd6) begin  // ~20ms at 300Hz
                            key_valid <= 1'b1;
                            key_held <= 1'b1;
                            debounce_counter <= 18'd0;
                        end else begin
                            debounce_counter <= debounce_counter + 1;
                        end
                    end else begin
                        key_valid <= 1'b0;
                        debounce_counter <= 18'd0;
                    end
                end
                HOLD: begin
                    key_valid <= 1'b0;
                    if (!exit_scan) begin
                        key_held <= 1'b0;
                    end
                end
                default: begin
                    key_valid <= 1'b0;
                end
            endcase
        end
    end
    
    // Key detection logic
    always_comb begin
        key_detected = 1'b0;
        detected_key = 4'b0000;
        
        if (exit_scan) begin
            key_detected = 1'b1;
            
            // Decode key based on stored column and row
            case (col_scan)
                4'b1110: begin  // Column 0
                    case (row_hold)
                        4'b0001: detected_key = 4'b0001;  // Key 1
                        4'b0010: detected_key = 4'b0100;  // Key 4
                        4'b0100: detected_key = 4'b0111;  // Key 7
                        4'b1000: detected_key = 4'b1010;  // Key A
                        default: detected_key = 4'b0000;
                    endcase
                end
                4'b1101: begin  // Column 1
                    case (row_hold)
                        4'b0001: detected_key = 4'b0010;  // Key 2
                        4'b0010: detected_key = 4'b0101;  // Key 5
                        4'b0100: detected_key = 4'b1000;  // Key 8
                        4'b1000: detected_key = 4'b0000;  // Key 0
                        default: detected_key = 4'b0000;
                    endcase
                end
                4'b1011: begin  // Column 2
                    case (row_hold)
                        4'b0001: detected_key = 4'b0011;  // Key 3
                        4'b0010: detected_key = 4'b0110;  // Key 6
                        4'b0100: detected_key = 4'b1001;  // Key 9
                        4'b1000: detected_key = 4'b1011;  // Key B
                        default: detected_key = 4'b0000;
                    endcase
                end
                4'b0111: begin  // Column 3
                    case (row_hold)
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
    
    // Output assignments
    assign key_code = detected_key;
    assign key_pressed = key_detected;

endmodule