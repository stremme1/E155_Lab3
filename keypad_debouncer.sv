module keypad_debouncer (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        key_detected, // from scanner
    input  logic [3:0]  row_idx,      // from scanner (one-hot)
    input  logic [3:0]  col_sync,     // from scanner (raw synchronized columns)
    output logic        key_valid,    // stays high while key physically held
    output logic [3:0]  key_row,      // one-hot row for decoder
    output logic [3:0]  key_col       // one-hot column for decoder
);

    // ========================================================================
    // FSM STATE DEFINITIONS
    // ========================================================================
    typedef enum logic [1:0] {
        IDLE,           // No key detected
        DEBOUNCING,     // Debouncing in progress
        KEY_VALID       // Key is valid and stable
    } debounce_state_t;
    
    debounce_state_t current_state, next_state;
    
    // Column conversion from raw to one-hot
    logic [3:0] col_onehot;
    
    // Debounce counter and latched values
    logic [19:0] debounce_cnt;
    logic [3:0]  latched_row, latched_col;
    
    // Internal signals for outputs
    logic        key_valid_int;
    logic [3:0]  key_row_int;
    logic [3:0]  key_col_int;
    
    localparam int DEBOUNCE_MAX = 20'd59999; // ~20ms @ 3MHz

    // ========================================================================
    // COLUMN CONVERSION: Raw to One-Hot
    // ========================================================================
    // Convert synchronized column data to one-hot format for decoder
    always_comb begin
        case (col_sync)
            4'b1110: col_onehot = 4'b0001;  // Column 0 pressed
            4'b1101: col_onehot = 4'b0010;  // Column 1 pressed
            4'b1011: col_onehot = 4'b0100;  // Column 2 pressed
            4'b0111: col_onehot = 4'b1000;  // Column 3 pressed
            default: col_onehot = 4'b0000;  // No key or multiple keys
        endcase
    end

    // ========================================================================
    // DEBOUNCE FSM
    // ========================================================================
    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        
        case (current_state)
            IDLE: begin
                if (key_detected && row_idx != 4'b0000 && col_onehot != 4'b0000) begin
                    next_state = DEBOUNCING;
                end
            end
            
            DEBOUNCING: begin
                if (!key_detected) begin
                    next_state = IDLE;
                end else if (col_onehot != latched_col) begin
                    next_state = DEBOUNCING; // New column, restart debouncing
                end else if (debounce_cnt >= DEBOUNCE_MAX) begin
                    next_state = KEY_VALID;
                end
            end
            
            KEY_VALID: begin
                if (!key_detected) begin
                    next_state = IDLE;
                end else if (col_onehot != latched_col) begin
                    next_state = DEBOUNCING; // New column pressed
                end
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State machine outputs and data handling
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            debounce_cnt <= 20'd0;
            latched_row <= 4'b0000;
            latched_col <= 4'b0000;
            key_valid_int <= 1'b0;
            key_row_int <= 4'b0000;
            key_col_int <= 4'b0000;
        end else begin
            case (current_state)
                IDLE: begin
                    debounce_cnt <= 20'd0;
                    key_valid_int <= 1'b0;
                    key_row_int <= 4'b0000;
                    key_col_int <= 4'b0000;
                end
                
                DEBOUNCING: begin
                    // Latch key values on first entry to debouncing
                    if (col_onehot != latched_col) begin
                        latched_row <= row_idx;
                        latched_col <= col_onehot;
                        debounce_cnt <= 20'd0;
                    end else begin
                        // Increment debounce counter
                        if (debounce_cnt < DEBOUNCE_MAX) begin
                            debounce_cnt <= debounce_cnt + 1;
                        end
                    end
                    key_valid_int <= 1'b0;
                end
                
                KEY_VALID: begin
                    // Key is valid, output the latched values
                    key_valid_int <= 1'b1;
                    key_row_int <= latched_row;
                    key_col_int <= latched_col;
                end
                
                default: begin
                    // Default case
                    key_valid_int <= 1'b0;
                end
            endcase
        end
    end

    // Assign internal signals to outputs
    assign key_valid = key_valid_int;
    assign key_row = key_row_int;
    assign key_col = key_col_int;

endmodule
