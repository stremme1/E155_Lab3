// ============================================================================
// KEYPAD SCANNER MODULE
// ============================================================================
// Scans a 4x4 matrix keypad by driving rows sequentially and reading columns.
// Features:
// - Column input synchronization (2-stage pipeline)
// - Continuous row scanning with configurable timing
// - Active-low row driving with pull-up column detection
// - Provides synchronized column data for external processing
// - Key detection output for decoder integration
// ============================================================================

module keypad_scanner (
    input  logic        clk,
    input  logic        rst_n,        // Active-low reset
    output logic [3:0]  row,          // Row outputs (active-low)
    input  logic [3:0]  col,          // Column inputs (pull-up, async)
    output logic [3:0]  row_idx,      // One-hot row index
    output logic [3:0]  col_sync,     // Synchronized column inputs
    output logic        key_detected  // Key press detected (any column active)
);

    // ========================================================================
    // PARAMETERS AND LOCAL SIGNALS
    // ========================================================================
    localparam int SCAN_PERIOD = 32'd5999; // ~2ms per row @ 3MHz (fast scanning)
    
    // FSM State definitions
    typedef enum logic [1:0] {
        SCAN_ROW0,      // Scanning row 0
        SCAN_ROW1,      // Scanning row 1  
        SCAN_ROW2,      // Scanning row 2
        SCAN_ROW3       // Scanning row 3
    } scan_state_t;
    
    scan_state_t current_state, next_state;
    
    // Double synchronization signals for columns
    logic [3:0] col_sync1, col_sync2;
    
    // Double synchronization signals for rows (if needed for feedback)
    logic [3:0] row_sync1, row_sync2;
    
    // Row scanning signals
    logic [31:0] scan_counter;
    logic        scan_timeout;

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
    // KEYPAD SCANNING FSM
    // ========================================================================
    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= SCAN_ROW0;  // Start scanning immediately after reset
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic - simple continuous scanning
    always_comb begin
        next_state = current_state;
        
        case (current_state)
            SCAN_ROW0: begin
                if (scan_timeout) begin
                    next_state = SCAN_ROW1;
                end
            end
            
            SCAN_ROW1: begin
                if (scan_timeout) begin
                    next_state = SCAN_ROW2;
                end
            end
            
            SCAN_ROW2: begin
                if (scan_timeout) begin
                    next_state = SCAN_ROW3;
                end
            end
            
            SCAN_ROW3: begin
                if (scan_timeout) begin
                    next_state = SCAN_ROW0;  // Continuous scanning
                end
            end
            
            default: begin
                next_state = SCAN_ROW0;
            end
        endcase
    end

    // ========================================================================
    // OUTPUT GENERATION
    // ========================================================================
    // Provide synchronized column data for external processing
    assign col_sync = col_sync2;
    
    // Key detection: any column is active (active-low, so any bit is 0)
    assign key_detected = (col_sync2 != 4'b1111);

    // ========================================================================
    // ROW DRIVING (ACTIVE-LOW)
    // ========================================================================
    // Drive one row low at a time in sequence based on current state
    always_comb begin
        case (current_state)
            SCAN_ROW0: row = 4'b1110;  // Row 0 active
            SCAN_ROW1: row = 4'b1101;  // Row 1 active
            SCAN_ROW2: row = 4'b1011;  // Row 2 active
            SCAN_ROW3: row = 4'b0111;  // Row 3 active
            default: row = 4'b1111;    // All rows inactive
        endcase
    end

    // ========================================================================
    // ROW INDEX GENERATION
    // ========================================================================
    
    // Generate one-hot row index for currently active row
    always_comb begin
        case (current_state)
            SCAN_ROW0: row_idx = 4'b0001;  // Row 0
            SCAN_ROW1: row_idx = 4'b0010;  // Row 1
            SCAN_ROW2: row_idx = 4'b0100;  // Row 2
            SCAN_ROW3: row_idx = 4'b1000;  // Row 3
            default: row_idx = 4'b0000;    // No row active
        endcase
    end

endmodule

