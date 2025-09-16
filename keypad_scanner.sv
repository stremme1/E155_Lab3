// ============================================================================
// KEYPAD SCANNER MODULE
// ============================================================================
// Scans a 4x4 matrix keypad by driving rows sequentially and reading columns.
// Features:
// - Column input synchronization (2-stage pipeline)
// - Fast scanning rate with hold logic for proper debouncing
// - Ghosting protection (rejects multiple simultaneous key presses)
// - Active-low row driving with pull-up column detection
// ============================================================================

module keypad_scanner (
    input  logic        clk,
    input  logic        rst_n,        // Active-low reset
    input  logic        key_valid,    // From debouncer - indicates debouncing complete
    output logic [3:0]  row,          // Row outputs (active-low)
    input  logic [3:0]  col,          // Column inputs (pull-up, async)
    output logic [3:0]  row_idx,      // One-hot row index
    output logic [3:0]  col_idx,      // One-hot column index
    output logic        key_pressed   // Valid single key press detected
);

    // ========================================================================
    // PARAMETERS AND LOCAL SIGNALS
    // ========================================================================
    localparam int SCAN_PERIOD = 32'd5999; // ~2ms per row @ 3MHz (fast scanning)
    
    // Column synchronization signals
    logic [3:0] col_sync1, col_sync2;
    
    // Row scanning signals
    logic [31:0] scan_counter;
    logic [1:0]  scan_state;
    logic        key_detected;    // Internal flag for key detection
    logic [1:0]  held_state;      // State to hold when key detected
    
    // Key detection signals
    logic [3:0] col_count;

    // ========================================================================
    // COLUMN INPUT SYNCHRONIZATION
    // ========================================================================
    // Two-stage pipeline to synchronize asynchronous column inputs
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            col_sync1 <= 4'b1111;
            col_sync2 <= 4'b1111;
        end else begin
            col_sync1 <= col;
            col_sync2 <= col_sync1;
        end
    end

    // ========================================================================
    // ROW SCANNING STATE MACHINE WITH KEY HOLD LOGIC
    // ========================================================================
    // Fast counter to change active row every SCAN_PERIOD clock cycles
    // BUT hold the state when a key is detected until debouncing completes
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_counter <= 32'd0;
            scan_state   <= 2'd0;
            key_detected <= 1'b0;
            held_state   <= 2'd0;
        end else begin
            // Check if a key is pressed (and we haven't already detected one)
            if (key_pressed && !key_detected) begin
                key_detected <= 1'b1;
                held_state   <= scan_state;  // Hold current state
            end
            
            // If debouncing is complete, resume scanning
            if (key_valid && key_detected) begin
                key_detected <= 1'b0;
                scan_counter <= 32'd0;  // Reset counter to start fresh scan period
                // Move to next row after debouncing completes
                scan_state <= (held_state == 2'd3) ? 2'd0 : held_state + 1;
            end
            // If key is released and we were detecting, clear the detection
            else if (!key_pressed && key_detected) begin
                key_detected <= 1'b0;
                scan_counter <= 32'd0;  // Reset counter to start fresh scan period
                // Stay on the same row when key is released (don't advance)
                scan_state <= held_state;
            end
            // Normal scanning when no key detected
            else if (!key_detected) begin
                if (scan_counter == SCAN_PERIOD) begin
                    scan_counter <= 32'd0;
                    scan_state   <= (scan_state == 2'd3) ? 2'd0 : scan_state + 1;  // Wrap around
                end else begin
                    scan_counter <= scan_counter + 1;
                end
            end
            // When key detected, hold the state (don't increment counter or state)
        end
    end

    // ========================================================================
    // ROW DRIVING (ACTIVE-LOW)
    // ========================================================================
    // Drive one row low at a time in sequence
    // Use held_state when key is detected to maintain the active row
    always_comb begin
        case (key_detected ? held_state : scan_state)
            2'd0: row = 4'b1110;  // Row 0 active
            2'd1: row = 4'b1101;  // Row 1 active
            2'd2: row = 4'b1011;  // Row 2 active
            2'd3: row = 4'b0111;  // Row 3 active
            default: row = 4'b1111; // All rows inactive
        endcase
    end

    // ========================================================================
    // KEY DETECTION AND GHOSTING PROTECTION
    // ========================================================================
    // Count how many columns are low (pressed)
    assign col_count = {3'b000, ~col_sync2[0]} + {3'b000, ~col_sync2[1]} + {3'b000, ~col_sync2[2]} + {3'b000, ~col_sync2[3]};
    
    // Valid key press: exactly one column low and not all columns high
    assign key_pressed = (col_sync2 != 4'b1111) && (col_count == 1);

    // ========================================================================
    // OUTPUT INDEX GENERATION
    // ========================================================================
    
    // Generate one-hot row index for currently active row
    // Use held_state when key is detected to maintain the active row
    always_comb begin
        case (key_detected ? held_state : scan_state)
            2'd0: row_idx = 4'b0001;  // Row 0
            2'd1: row_idx = 4'b0010;  // Row 1
            2'd2: row_idx = 4'b0100;  // Row 2
            2'd3: row_idx = 4'b1000;  // Row 3
            default: row_idx = 4'b0000; // No row active
        endcase
    end

    // Generate one-hot column index from synchronized column inputs
    always_comb begin
        if (col_count > 1) begin
            // Multiple keys pressed - invalid (ghosting protection)
            col_idx = 4'b0000;
        end else begin
            // Single key press - map to one-hot column index
            case (col_sync2)
                4'b1110: col_idx = 4'b0001;  // Column 0 pressed
                4'b1101: col_idx = 4'b0010;  // Column 1 pressed
                4'b1011: col_idx = 4'b0100;  // Column 2 pressed
                4'b0111: col_idx = 4'b1000;  // Column 3 pressed
                default: col_idx = 4'b0000;  // No key pressed
            endcase
        end
    end

endmodule
