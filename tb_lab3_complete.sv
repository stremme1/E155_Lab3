// ============================================================================
// LAB3 TOP MODULE COMPLETE TESTBENCH
// ============================================================================
// This testbench tests the complete lab3_top system with all modules included
// Uses modified timing for testing but maintains the same logic as hardware

// ============================================================================
// KEYPAD DECODER MODULE
// ============================================================================

module keypad_decoder (
    input  logic [3:0] row_onehot,
    input  logic [3:0] col_onehot,
    output logic [3:0] key_code   // 4-bit hex code 0000..1111
);

    always_comb begin
        key_code = 4'b0000;
        case ({row_onehot, col_onehot})
            // row0 (0001)
            {4'b0001, 4'b0001}: key_code = 4'b0001; // 1
            {4'b0001, 4'b0010}: key_code = 4'b0010; // 2
            {4'b0001, 4'b0100}: key_code = 4'b0011; // 3
            {4'b0001, 4'b1000}: key_code = 4'b1010; // A

            // row1 (0010)
            {4'b0010, 4'b0001}: key_code = 4'b0100; // 4
            {4'b0010, 4'b0010}: key_code = 4'b0101; // 5
            {4'b0010, 4'b0100}: key_code = 4'b0110; // 6
            {4'b0010, 4'b1000}: key_code = 4'b1011; // B

            // row2 (0100)
            {4'b0100, 4'b0001}: key_code = 4'b0111; // 7
            {4'b0100, 4'b0010}: key_code = 4'b1000; // 8
            {4'b0100, 4'b0100}: key_code = 4'b1001; // 9
            {4'b0100, 4'b1000}: key_code = 4'b1100; // C

            // row3 (1000)
            {4'b1000, 4'b0001}: key_code = 4'b1110; // E
            {4'b1000, 4'b0010}: key_code = 4'b0000; // 0
            {4'b1000, 4'b0100}: key_code = 4'b1111; // F
            {4'b1000, 4'b1000}: key_code = 4'b1101; // D

            default: key_code = 4'b0000;
        endcase
    end
endmodule

// ============================================================================
// KEYPAD CONTROLLER MODULE
// ============================================================================

module keypad_controller (
    input  logic        clk,           // System clock
    input  logic        rst_n,         // Active-low reset
    input  logic [3:0]  key_code,      // Key code from keypad scanner
    input  logic        key_valid,     // Valid key press signal
    output logic [3:0]  digit_left,    // Left display digit
    output logic [3:0]  digit_right   // Right display digit
);

    // Digit controller logic - implements digit shifting behavior
    logic [3:0] left_digit_reg, right_digit_reg;
    logic [3:0] new_key;  // Store new key code
    logic [2:0] state;    // State machine: 000=idle, 001=key_pressed, 010=key_released
    
    // State machine for key press/release detection and digit shifting
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            left_digit_reg <= 4'h0;
            right_digit_reg <= 4'h0;
            new_key <= 4'h0;
            state <= 3'b000;
        end
        else begin
            case (state)
                3'b000: begin // Idle state
                    if (key_valid) begin
                        // Key pressed - store key code and go to pressed state
                        new_key <= key_code;
                        state <= 3'b001;
                    end
                end
                3'b001: begin // Key pressed state
                    if (!key_valid) begin
                        // Key released - go to released state
                        state <= 3'b010;
                    end
                end
                3'b010: begin // Key released state - shift digits
                    // Shift left digit to right, put new key in left
                    right_digit_reg <= left_digit_reg;
                    left_digit_reg <= new_key;
                    state <= 3'b000; // Return to idle
                end
                default: begin
                    state <= 3'b000;
                end
            endcase
        end
    end 
    
    // Output assignments
    assign digit_left = left_digit_reg;
    assign digit_right = right_digit_reg;

endmodule

// ============================================================================
// SEVEN SEGMENT MODULE
// ============================================================================

module seven_segment (
    input  logic [3:0] num,     // 4-bit input number (0-15)
    output logic [6:0] seg      // 7-bit output for segments a-g (active low)
);

    // Combinational logic to decode 4-bit input to 7-segment pattern
    always_comb begin
        case (num)
            4'd0: seg = 7'b1000000; // 0: A,B,C,D,E,F ON; G OFF
            4'd1: seg = 7'b1111001; // 1: B,C ON
            4'd2: seg = 7'b0100100; // 2: A,B,G,E,D ON
            4'd3: seg = 7'b0110000; // 3: A,B,C,G,D ON
            4'd4: seg = 7'b0011001; // 4: B,C,F,G ON
            4'd5: seg = 7'b0010010; // 5: A,C,D,F,G ON
            4'd6: seg = 7'b0000010; // 6: C,D,E,F,G ON
            4'd7: seg = 7'b1111000; // 7: A,B,C ON
            4'd8: seg = 7'b0000000; // 8: all segments ON
            4'd9: seg = 7'b0010000; // 9: A,B,C,D,F,G ON
            4'd10: seg = 7'b0001000; // A: A,B,C,E,F,G ON
            4'd11: seg = 7'b0000011; // B: C,D,E,F,G ON
            4'd12: seg = 7'b1000110; // C: A,D,E,F ON
            4'd13: seg = 7'b0100001; // D: B,C,D,E,G ON
            4'd14: seg = 7'b0000110; // E: A,D,E,F,G ON
            4'd15: seg = 7'b0001110; // F: A,E,F,G ON
            default: seg = 7'b1111111; // blank (all segments OFF)
        endcase
    end

endmodule

// ============================================================================
// LAB2_ES DISPLAY SYSTEM MODULE
// ============================================================================

module Lab2_ES (
    input  logic        clk,           // System clock
    input  logic        reset,         // Active-high reset
    input  logic [3:0]  s0,            // Left digit (most significant)
    input  logic [3:0]  s1,            // Right digit (least significant)
    output logic [6:0]  seg,           // Seven-segment output
    output logic        select0,       // Display 0 power control
    output logic        select1        // Display 1 power control
);

    // Internal signals
    logic [3:0] digit_to_display;
    logic [6:0] seg_out;
    
    // Multiplexing counter for display switching
    logic [15:0] mux_counter;
    logic mux_select;
    
    // Multiplexing counter
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mux_counter <= 16'd0;
        end else begin
            mux_counter <= mux_counter + 1;
        end
    end
    
    // Use bit 12 of counter for multiplexing (switches every ~1.3ms @ 3MHz)
    assign mux_select = mux_counter[12];
    
    // Multiplex the digit inputs
    assign digit_to_display = mux_select ? s1 : s0;
    
    // Seven-segment decoder
    seven_segment seg_decoder (
        .num(digit_to_display),
        .seg(seg_out)
    );
    
    // Output assignments
    assign seg = seg_out;
    assign select0 = ~mux_select;  // Active low
    assign select1 = mux_select;   // Active low

endmodule

// ============================================================================
// MODIFIED KEYPAD SCANNER FOR TESTING
// ============================================================================

module keypad_scanner_test (
    input  logic        clk,
    input  logic        rst_n,        // Active-low reset
    output logic [3:0]  row,          // Row outputs (active-low)
    input  logic [3:0]  col,          // Column inputs (pull-up, async)
    output logic [3:0]  row_idx,      // One-hot row index
    output logic [3:0]  col_idx,      // One-hot column index
    output logic        key_pressed   // Valid single key press detected
);

    // ========================================================================
    // PARAMETERS AND LOCAL SIGNALS
    // ========================================================================
    localparam int SCAN_PERIOD = 32'd9; // SHORT period for testing (10 cycles per row)
    
    // Column synchronization signals
    logic [3:0] col_sync1, col_sync2;
    
    // Row scanning signals
    logic [31:0] scan_counter;
    logic [1:0]  scan_state;
    
    // Key detection signals
    logic [3:0] col_count;

    // ========================================================================
    // COLUMN INPUT SYNCHRONIZATION
    // ========================================================================
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
    // ROW SCANNING STATE MACHINE
    // ========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_counter <= 32'd0;
            scan_state   <= 2'd0;
        end else begin
            if (scan_counter == SCAN_PERIOD) begin
                scan_counter <= 32'd0;
                scan_state   <= scan_state + 1;
            end else begin
                scan_counter <= scan_counter + 1;
            end
        end
    end

    // ========================================================================
    // ROW DRIVING (ACTIVE-LOW)
    // ========================================================================
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
    assign col_count = {3'b000, ~col_sync2[0]} + {3'b000, ~col_sync2[1]} + {3'b000, ~col_sync2[2]} + {3'b000, ~col_sync2[3]};
    assign key_pressed = (col_sync2 != 4'b1111) && (col_count == 1);

    // ========================================================================
    // OUTPUT INDEX GENERATION
    // ========================================================================
    always_comb begin
        case (scan_state)
            2'd0: row_idx = 4'b0001;  // Row 0
            2'd1: row_idx = 4'b0010;  // Row 1
            2'd2: row_idx = 4'b0100;  // Row 2
            2'd3: row_idx = 4'b1000;  // Row 3
            default: row_idx = 4'b0000; // No row active
        endcase
    end

    always_comb begin
        if (col_count > 1) begin
            col_idx = 4'b0000;
        end else begin
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
// MODIFIED KEYPAD DEBOUNCER FOR TESTING
// ============================================================================

module keypad_debouncer_test (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        key_pressed, // from scanner (uses synchronized col)
    input  logic [3:0]  row_idx,
    input  logic [3:0]  col_idx,
    output logic        key_valid,   // stays high while key physically held
    output logic [3:0]  key_row,
    output logic [3:0]  key_col
);

    // Simple counter-based debouncer with SHORT period for testing
    logic [15:0] debounce_cnt;
    logic [3:0]  latched_row, latched_col;
    logic        key_stable;
    
    // Internal signals for outputs
    logic        key_valid_int;
    logic [3:0]  key_row_int;
    logic [3:0]  key_col_int;
    
    localparam int DEBOUNCE_MAX = 16'd7; // SHORT period for testing (8 cycles - less than scan period)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            debounce_cnt <= 16'd0;
            latched_row <= 4'b0000;
            latched_col <= 4'b0000;
            key_stable <= 1'b0;
            key_valid_int <= 1'b0;
            key_row_int <= 4'b0000;
            key_col_int <= 4'b0000;
        end else begin
            // If key is pressed and valid
            if (key_pressed && row_idx != 4'b0000 && col_idx != 4'b0000) begin
                // If this is a new key press, reset counter and latch new values
                if (row_idx != latched_row || col_idx != latched_col) begin
                    debounce_cnt <= 16'd0;
                    latched_row <= row_idx;
                    latched_col <= col_idx;
                    key_stable <= 1'b0;
                    key_valid_int <= 1'b0;
                end else begin
                    // Same key, increment counter
                    if (debounce_cnt < DEBOUNCE_MAX - 1) begin
                        debounce_cnt <= debounce_cnt + 1;
                    end else begin
                        // Debounce complete
                        key_stable <= 1'b1;
                        key_valid_int <= 1'b1;
                        key_row_int <= latched_row;
                        key_col_int <= latched_col;
                    end
                end
            end else begin
                // No key pressed, reset everything
                debounce_cnt <= 16'd0;
                latched_row <= 4'b0000;
                latched_col <= 4'b0000;
                key_stable <= 1'b0;
                key_valid_int <= 1'b0;
                key_row_int <= 4'b0000;
                key_col_int <= 4'b0000;
            end
        end
    end
    // Assign internal signals to outputs
    assign key_valid = key_valid_int;
    assign key_row = key_row_int;
    assign key_col = key_col_int;
endmodule

// ============================================================================
// LAB3 TOP MODULE (TEST VERSION)
// ============================================================================

module lab3_top_test (
    input  logic        reset,         // Active-low reset signal
    output logic [3:0]  keypad_rows,   // Keypad row outputs (FPGA drives)
    input  logic [3:0]  keypad_cols,   // Keypad column inputs (FPGA reads)
    output logic [6:0]  seg,           // Seven-segment display signals
    output logic        select0,       // Display 0 power control
    output logic        select1        // Display 1 power control
);

    // Internal signals
    logic        clk;                  // Internal clock
    logic [3:0]  row_idx;              // Row index from scanner
    logic [3:0]  col_idx;              // Column index from scanner
    logic        key_pressed;          // Raw key press signal
    logic        key_valid;            // Debounced valid key press signal
    logic [3:0]  key_row;              // Debounced row from debouncer
    logic [3:0]  key_col;              // Debounced column from debouncer
    logic [3:0]  key_code;             // Decoded key code
    logic [3:0]  digit_left;           // Left display digit
    logic [3:0]  digit_right;          // Right display digit

    // Clock generation - use simple clock for simulation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clock (10ns period)

    // Use test versions of scanner and debouncer with shorter periods
    keypad_scanner_test scanner_inst (
        .clk(clk),
        .rst_n(reset),
        .row(keypad_rows),
        .col(keypad_cols),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_pressed(key_pressed)
    );
    
    keypad_debouncer_test debouncer_inst (
        .clk(clk),
        .rst_n(reset),
        .key_pressed(key_pressed),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_valid(key_valid),
        .key_row(key_row),
        .key_col(key_col)
    );
    
    // Use actual modules for decoder, controller, and display
    keypad_decoder decoder_inst (
        .row_onehot(key_row),
        .col_onehot(key_col),
        .key_code(key_code)
    );
    
    keypad_controller controller_inst (
        .clk(clk),
        .rst_n(reset),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

    Lab2_ES display_system (
        .clk(clk),
        .reset(~reset),                // Invert active-low reset to active-high
        .s0(digit_left),               // Left digit from keypad
        .s1(digit_right),              // Right digit from keypad
        .seg(seg),                     // Seven-segment output
        .select0(select0),             // Display 0 power control
        .select1(select1)              // Display 1 power control
    );

endmodule

// ============================================================================
// TESTBENCH FOR LAB3 TOP MODULE (COMPLETE)
// ============================================================================

module tb_lab3_complete;

    // Testbench signals
    logic        reset;
    logic [3:0]  keypad_rows;
    logic [3:0]  keypad_cols;
    logic [6:0]  seg;
    logic        select0;
    logic        select1;

    // Instantiate the test version of lab3_top
    lab3_top_test dut (
        .reset(reset),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .seg(seg),
        .select0(select0),
        .select1(select1)
    );

    // Test stimulus
    initial begin
        $display("==========================================");
        $display("LAB3 TOP MODULE COMPLETE TESTBENCH");
        $display("Testing the COMPLETE lab3_top system");
        $display("==========================================");
        
        // Initialize signals
        reset = 0;
        keypad_cols = 4'b1111; // No keys pressed initially
        
        // Reset sequence
        $display("Applying reset...");
        repeat(10) @(posedge dut.clk);
        reset = 1;
        repeat(10) @(posedge dut.clk);
        
        $display("Reset complete. Starting tests...");
        $display("Initial state - Rows: %b, Cols: %b, Seg: %b, Select0: %b, Select1: %b", 
                 keypad_rows, keypad_cols, seg, select0, select1);
        
        // Test 1: Key '1' press (Row 0, Col 0)
        $display("\n--- Test 1: Key '1' press (Row 0, Col 0) ---");
        keypad_cols = 4'b1110; // Column 0 pressed
        $display("Key pressed at time %0t", $time);
        
        // Wait for debounce period (100 cycles)
        repeat(150) @(posedge dut.clk);
        
        $display("After debounce wait - Key_pressed: %b, Key_valid: %b, Key_code: %h", 
                 dut.key_pressed, dut.key_valid, dut.key_code);
        $display("Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        
        // Release key
        keypad_cols = 4'b1111;
        $display("Key released at time %0t", $time);
        
        // Wait for key release processing
        repeat(150) @(posedge dut.clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 dut.digit_left, dut.digit_right);
        
        // Test 2: Key '5' press (Row 1, Col 1)
        $display("\n--- Test 2: Key '5' press (Row 1, Col 1) ---");
        keypad_cols = 4'b1101; // Column 1 pressed
        $display("Key pressed at time %0t", $time);
        
        // Wait for debounce period
        repeat(150) @(posedge dut.clk);
        
        $display("After debounce wait - Key_pressed: %b, Key_valid: %b, Key_code: %h", 
                 dut.key_pressed, dut.key_valid, dut.key_code);
        $display("Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        
        // Release key
        keypad_cols = 4'b1111;
        $display("Key released at time %0t", $time);
        
        // Wait for key release processing
        repeat(150) @(posedge dut.clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 dut.digit_left, dut.digit_right);
        
        // Test 3: Key 'A' press (Row 0, Col 3)
        $display("\n--- Test 3: Key 'A' press (Row 0, Col 3) ---");
        keypad_cols = 4'b0111; // Column 3 pressed
        $display("Key pressed at time %0t", $time);
        
        // Wait for debounce period
        repeat(150) @(posedge dut.clk);
        
        $display("After debounce wait - Key_pressed: %b, Key_valid: %b, Key_code: %h", 
                 dut.key_pressed, dut.key_valid, dut.key_code);
        $display("Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        
        // Release key
        keypad_cols = 4'b1111;
        $display("Key released at time %0t", $time);
        
        // Wait for key release processing
        repeat(150) @(posedge dut.clk);
        $display("After key release - Digit_left: %h, Digit_right: %h", 
                 dut.digit_left, dut.digit_right);
        
        // Test 4: Sequence test (1->2->3->4)
        $display("\n--- Test 4: Sequence test (1->2->3->4) ---");
        $display("Testing sequence: 1 -> 2 -> 3 -> 4");
        
        // Key 1
        $display("Pressing key '1'...");
        keypad_cols = 4'b1110; repeat(150) @(posedge dut.clk);
        keypad_cols = 4'b1111; repeat(150) @(posedge dut.clk);
        $display("After '1': Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        
        // Key 2
        $display("Pressing key '2'...");
        keypad_cols = 4'b1101; repeat(150) @(posedge dut.clk);
        keypad_cols = 4'b1111; repeat(150) @(posedge dut.clk);
        $display("After '2': Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        
        // Key 3
        $display("Pressing key '3'...");
        keypad_cols = 4'b1011; repeat(150) @(posedge dut.clk);
        keypad_cols = 4'b1111; repeat(150) @(posedge dut.clk);
        $display("After '3': Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        
        // Key 4
        $display("Pressing key '4'...");
        keypad_cols = 4'b1110; repeat(150) @(posedge dut.clk);
        keypad_cols = 4'b1111; repeat(150) @(posedge dut.clk);
        $display("After '4': Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        
        // Test 5: Reset test
        $display("\n--- Test 5: Reset test ---");
        $display("Before reset - Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        reset = 0;  // Assert reset
        repeat(10) @(posedge dut.clk);
        reset = 1;  // Deassert reset
        repeat(10) @(posedge dut.clk);
        $display("After reset - Digit_left: %h, Digit_right: %h", dut.digit_left, dut.digit_right);
        
        $display("\n==========================================");
        $display("LAB3 TOP MODULE COMPLETE TESTBENCH COMPLETE");
        $display("This tested the COMPLETE lab3_top system!");
        $display("==========================================");
        $stop;
    end

    // Monitor for debugging
    initial begin
        $monitor("Time: %0t | Reset: %b | Rows: %b | Cols: %b | Key_pressed: %b | Key_valid: %b | Key_code: %h | Digit_left: %h | Digit_right: %h | Seg: %b", 
                 $time, reset, keypad_rows, keypad_cols, dut.key_pressed, dut.key_valid, dut.key_code, dut.digit_left, dut.digit_right, seg);
    end

endmodule
