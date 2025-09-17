// ============================================================================
// LAB3 TOP MODULE - FINAL VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Top Module - Keypad Scanner with Display System
// 
// CLOCK SELECTION:
// - For HARDWARE: Use HSOSC (currently active)
// - For SIMULATION: Comment out HSOSC and uncomment simulation clock
// ============================================================================

module lab3_top (
    input  logic        reset,         // Active-low reset signal
    output logic [3:0]  keypad_rows,   // Keypad row outputs (FPGA drives)
    input  logic [3:0]  keypad_cols,   // Keypad column inputs (FPGA reads)
    output logic [6:0]  seg,           // Seven-segment display signals
    output logic        select0,       // Display 0 power control
    output logic        select1        // Display 1 power control
);

    // ========================================================================
    // INTERNAL SIGNALS
    // ========================================================================
    logic        clk;                  // Internal clock
    logic [3:0]  row_idx;              // Row index from scanner
    logic [3:0]  col_sync;             // Synchronized column data from scanner
    logic        key_detected;         // Key detection signal from scanner
    logic        key_valid;            // Debounced valid key press signal
    logic [3:0]  key_row;              // Debounced row from debouncer
    logic [3:0]  key_col;              // Debounced column from debouncer
    logic [3:0]  key_code;             // Decoded key code
    logic [3:0]  digit_left;           // Left display digit
    logic [3:0]  digit_right;          // Right display digit

    // ========================================================================
    // CLOCK GENERATION
    // ========================================================================
    
    // HARDWARE CLOCK - HSOSC (ACTIVE FOR HARDWARE)
    // CLKHF_DIV(2'b11) = divide by 16 to get 3MHz from 48MHz
    HSOSC #(.CLKHF_DIV(2'b11)) hf_osc (
        .CLKHFPU(1'b1), 
        .CLKHFEN(1'b1), 
        .CLKHF(clk)
    );
    
    // SIMULATION CLOCK - UNCOMMENT FOR SIMULATION
    // initial begin
    //     clk = 0;
    //     forever #166.67 clk = ~clk; // 3MHz clock (333.33ns period)
    // end

    // ========================================================================
    // KEYPAD SCANNER
    // ========================================================================
    keypad_scanner scanner_inst (
        .clk(clk),
        .rst_n(reset),
        .row(keypad_rows),
        .col(keypad_cols),
        .row_idx(row_idx),
        .col_sync(col_sync),
        .key_detected(key_detected)
    );
    
    // ========================================================================
    // KEYPAD DEBOUNCER
    // ========================================================================
    keypad_debouncer debouncer_inst (
        .clk(clk),
        .rst_n(reset),
        .key_detected(key_detected),
        .row_idx(row_idx),
        .col_sync(col_sync),
        .key_valid(key_valid),
        .key_row(key_row),
        .key_col(key_col)
    );
    
    // ========================================================================
    // KEYPAD DECODER
    // ========================================================================
    keypad_decoder decoder_inst (
        .row_onehot(key_row),
        .col_onehot(key_col),
        .key_code(key_code)
    );
    
    // ========================================================================
    // KEYPAD CONTROLLER
    // ========================================================================
    keypad_controller controller_inst (
        .clk(clk),
        .rst_n(reset),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

    // ========================================================================
    // DISPLAY SYSTEM
    // ========================================================================
    // Use existing Lab2_ES display system (single seven_segment instance)
    // Note: Lab2_ES expects active-high reset, so we invert the active-low reset signal
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
