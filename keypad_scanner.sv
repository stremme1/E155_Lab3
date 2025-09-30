// ============================================================================
// KEYPAD SCANNER MODULE
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Keypad Scanner - Matrix Keypad Scanning Logic
// Scans a 4x4 matrix keypad by driving rows sequentially and reading columns.
// ============================================================================

module keypad_scanner (
    input  logic        clk,
    input  logic        rst_n,        // Active-low reset
    output logic [3:0]  row,          // Row outputs (active-low)
    input  logic [3:0]  col,          // Column inputs (pull-up, async)
    output logic [3:0]  row_idx,      // One-hot row index (for compatibility)
    output logic [3:0]  col_sync,     // Synchronized column inputs
    output logic        key_detected,  // Key press detected (any column active)
    output logic [15:0] key_matrix,   // 16-bit matrix of all key states
	input logic 		scan_stop
);

    // ========================================================================
    // PARAMETERS AND LOCAL SIGNALS
    // ========================================================================
    localparam int SCAN_PERIOD = 32'd5999; // ~2ms per row @ 3MHz (fast scanning)
    
    // FSM State definitions for multi-key scanning
    typedef enum logic [2:0] {
        SCAN_ALL_ROWS,      // Scan all rows simultaneously
        SCAN_ROW0,          // Individual row scanning (fallback)
        SCAN_ROW1,          // Individual row scanning (fallback)
        SCAN_ROW2,          // Individual row scanning (fallback)
        SCAN_ROW3           // Individual row scanning (fallback)
    } scan_state_t;
    
    scan_state_t current_state, next_state;
    
    // Double synchronization signals for columns
    logic [3:0] col_sync1, col_sync2;
    
    // Double synchronization signals for rows (if needed for feedback)
    logic [3:0] row_sync1, row_sync2;
    
    // Row scanning signals
    logic [31:0] scan_counter;
    logic        scan_timeout;
    
    // Multi-key detection signals
    logic [3:0]  row0_cols, row1_cols, row2_cols, row3_cols;
    logic [15:0] key_matrix_reg;

    // ========================================================================
    // DOUBLE SYNCHRONIZATION FOR COLUMNS AND ROWS
    // ========================================================================
    // Two-stage pipeline to synchronize asynchronous column inputs
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            col_sync1 <= 4'b1111;
            col_sync2 <= 4'b1111;
            row_sync1 <= 4'b1111;
            row_sync2 <= 4'b1111;
        end else begin
            col_sync1 <= col;
            col_sync2 <= col_sync1;
            row_sync1 <= row;
            row_sync2 <= row_sync1;
        end
    end

    // ========================================================================
    // SCAN TIMEOUT COUNTER
    // ========================================================================
    // Counter to control scan timing
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_counter <= 32'd0;
        end else begin
            if (scan_counter >= SCAN_PERIOD) begin
                scan_counter <= 32'd0;
            end else begin
                scan_counter <= scan_counter + 1;
            end
        end
    end

    // Generate timeout signal
    assign scan_timeout = (scan_counter >= SCAN_PERIOD);

    // ========================================================================
    // MULTI-KEY SCANNING FSM
    // ========================================================================
    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= SCAN_ALL_ROWS;  // Start with multi-key scanning
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic - prioritize multi-key scanning
    always_comb begin
        next_state = current_state;
        
        case (current_state)
            SCAN_ALL_ROWS: begin
                if (scan_stop) begin
                    next_state = SCAN_ALL_ROWS;
                end
                // Stay in multi-key mode unless scan_stop forces individual scanning
            end
            
            SCAN_ROW0: begin
                if (scan_stop) begin
                    next_state = SCAN_ROW0;
                end
                else if (scan_timeout) begin
                    next_state = SCAN_ROW1;
                end
            end
            
            SCAN_ROW1: begin
                if (scan_stop) begin
                    next_state = SCAN_ROW1;
                end
                else if (scan_timeout) begin
                    next_state = SCAN_ROW2;
                end
            end
            
            SCAN_ROW2: begin
                if (scan_stop) begin
                    next_state = SCAN_ROW2;
                end
                else if (scan_timeout) begin
                    next_state = SCAN_ROW3;
                end
            end
            
            SCAN_ROW3: begin
                if (scan_stop) begin
                    next_state = SCAN_ROW3;
                end
                else if (scan_timeout) begin
                    next_state = SCAN_ROW0;  // Continuous scanning
                end
            end
            
            default: begin
                next_state = SCAN_ALL_ROWS;
            end
        endcase
    end

    // ========================================================================
    // MULTI-KEY DETECTION LOGIC
    // ========================================================================
    // Store column data for each row during scanning
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_matrix_reg <= 16'h0000;
            row0_cols <= 4'b0000;
            row1_cols <= 4'b0000;
            row2_cols <= 4'b0000;
            row3_cols <= 4'b0000;
        end else begin
            case (current_state)
                SCAN_ALL_ROWS: begin
                    // For multi-key detection, we need to scan each row individually
                    // This state will transition to individual row scanning
                    key_matrix_reg <= {
                        row3_cols,  // Row 3 (top row)
                        row2_cols,  // Row 2 
                        row1_cols,  // Row 1
                        row0_cols   // Row 0 (bottom row)
                    };
                end
                
                SCAN_ROW0: begin
                    row0_cols <= ~col_sync2;
                    key_matrix_reg[3:0] <= ~col_sync2;
                end
                
                SCAN_ROW1: begin
                    row1_cols <= ~col_sync2;
                    key_matrix_reg[7:4] <= ~col_sync2;
                end
                
                SCAN_ROW2: begin
                    row2_cols <= ~col_sync2;
                    key_matrix_reg[11:8] <= ~col_sync2;
                end
                
                SCAN_ROW3: begin
                    row3_cols <= ~col_sync2;
                    key_matrix_reg[15:12] <= ~col_sync2;
                end
                
                default: begin
                    key_matrix_reg <= 16'h0000;
                end
            endcase
        end
    end

    // ========================================================================
    // OUTPUT GENERATION
    // ========================================================================
    // Provide synchronized column data for external processing
    assign col_sync = col_sync2;
    
    // Key detection: any key is pressed in the matrix
    assign key_detected = (key_matrix_reg != 16'h0000);
    
    // Output the key matrix
    assign key_matrix = key_matrix_reg;

    // ========================================================================
    // ROW DRIVING (ACTIVE-LOW)
    // ========================================================================
    // Drive rows based on current scanning mode
    always_comb begin
        case (current_state)
            SCAN_ALL_ROWS: row = 4'b0000;  // All rows active for multi-key detection
            SCAN_ROW0: row = 4'b1110;       // Row 0 active
            SCAN_ROW1: row = 4'b1101;      // Row 1 active
            SCAN_ROW2: row = 4'b1011;      // Row 2 active
            SCAN_ROW3: row = 4'b0111;      // Row 3 active
            default: row = 4'b1111;        // All rows inactive
        endcase
    end

    // ========================================================================
    // ROW INDEX GENERATION (for compatibility)
    // ========================================================================
    // Generate one-hot row index for currently active row
    always_comb begin
        case (current_state)
            SCAN_ALL_ROWS: row_idx = 4'b1111;  // All rows active
            SCAN_ROW0: row_idx = 4'b0001;      // Row 0
            SCAN_ROW1: row_idx = 4'b0010;      // Row 1
            SCAN_ROW2: row_idx = 4'b0100;      // Row 2
            SCAN_ROW3: row_idx = 4'b1000;      // Row 3
            default: row_idx = 4'b0000;        // No row active
        endcase
    end

endmodule

