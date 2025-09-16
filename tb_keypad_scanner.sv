// ============================================================================
// KEYPAD SCANNER TESTBENCH
// ============================================================================
// Tests the keypad_scanner module functionality

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
                scan_counter <= 32'd0;
                scan_state   <= scan_state + 1;  // Move to next row
            end
            // Normal scanning when no key detected
            else if (!key_detected) begin
                if (scan_counter == SCAN_PERIOD) begin
                    scan_counter <= 32'd0;
                    scan_state   <= scan_state + 1;
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
    always_comb begin
        case (scan_state)
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
    always_comb begin
        case (scan_state)
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

// ============================================================================
// TESTBENCH
// ============================================================================

module tb_keypad_scanner;

    // Testbench signals
    logic        clk;
    logic        rst_n;
    logic        key_valid;
    logic [3:0]  row;
    logic [3:0]  col;
    logic [3:0]  row_idx;
    logic [3:0]  col_idx;
    logic        key_pressed;

    // Instantiate the scanner
    keypad_scanner dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_valid(key_valid),
        .row(row),
        .col(col),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_pressed(key_pressed)
    );

    // Clock generation - 3MHz clock
    initial clk = 0;
    always #166.67 clk = ~clk; // 3MHz clock (333.33ns period)

    // Test stimulus
    initial begin
        $display("==========================================");
        $display("KEYPAD SCANNER TESTBENCH");
        $display("Testing scanner with hold logic");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        key_valid = 0;
        col = 4'b1111; // No keys pressed initially
        
        // Reset sequence
        $display("Applying reset...");
        repeat(10) @(posedge clk);
        rst_n = 1;
        repeat(10) @(posedge clk);
        
        $display("Reset complete. Starting test...");
        
        // Test 1: Normal scanning - show continuous cycling
        $display("\n--- Test 1: Continuous Scanning ---");
        $display("Scan period is 6000 cycles, monitoring continuous row transitions...");
        
        // Show initial state
        $display("Initial: Rows=%b, Row_idx=%b, Scan_state=%0d, Counter=%0d", 
                 row, row_idx, dut.scan_state, dut.scan_counter);
        
        // Show multiple complete cycles
        for (int cycle = 0; cycle < 3; cycle++) begin
            for (int row_num = 0; row_num < 4; row_num++) begin
                repeat(6000) @(posedge clk);
                $display("Cycle %0d, Row %0d: Rows=%b, Row_idx=%b, Scan_state=%0d, Counter=%0d", 
                         cycle, row_num, row, row_idx, dut.scan_state, dut.scan_counter);
            end
        end
        
        // Test 2: Key press with hold logic
        $display("\n--- Test 2: Key Press with Hold Logic ---");
        $display("Waiting for row 0 to be active...");
        
        // Wait for row 0 to be driven (active low)
        wait(row == 4'b1110);
        $display("Row 0 is active! Pressing key...");
        
        col = 4'b1110; // Pull col 0 low
        $display("Key pressed - Rows: %b, Cols: %b", row, col);
        
        // Monitor for several cycles
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            $display("After press cycle %0d: Key_pressed=%b, Key_detected=%b, Row_idx=%b, Col_idx=%b", 
                     i, key_pressed, dut.key_detected, row_idx, col_idx);
        end
        
        // Release key first
        col = 4'b1111;
        $display("Key released");
        
        // Wait a few cycles for key_pressed to go low
        repeat(5) @(posedge clk);
        $display("After key release: Key_pressed=%b, Key_detected=%b", key_pressed, dut.key_detected);
        
        // Simulate debouncing complete
        $display("Simulating debouncing complete...");
        key_valid = 1;
        @(posedge clk);
        key_valid = 0;
        
        // Monitor after debouncing
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            $display("After debounce cycle %0d: Key_pressed=%b, Key_detected=%b, Row_idx=%b, Col_idx=%b, Scan_state=%0d", 
                     i, key_pressed, dut.key_detected, row_idx, col_idx, dut.scan_state);
        end
        
        $display("\n==========================================");
        $display("KEYPAD SCANNER TEST COMPLETE");
        $display("==========================================");
        $stop;
    end

endmodule