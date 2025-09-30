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
    logic [3:0]  row_idx;              // Row index from scanner (one-hot)
    logic [3:0]  col_sync;             // Synchronized column data from scanner (raw)
    logic        key_detected;         // Key detection signal from scanner
    logic [15:0] key_matrix;           // Key matrix from scanner
    logic        key_valid;            // Debounced valid key press signal
    logic [15:0] debounced_matrix;     // Debounced key matrix from debouncer
    logic [3:0]  digit_left;           // Left display digit
    logic [3:0]  digit_right;          // Right display digit
    logic [15:0] pressed_keys;         // Currently pressed keys
	logic scan_stop;

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
        .key_detected(key_detected),
        .key_matrix(key_matrix),
		.scan_stop(scan_stop)
    );
    
    // ========================================================================
    // KEYPAD DEBOUNCER (Scanner â†' Debouncer)
    // ========================================================================
    keypad_debouncer debouncer_inst (
        .clk(clk),
        .rst_n(reset),
        .key_matrix(key_matrix),
        .key_detected(key_detected),
        .key_valid(key_valid),
        .debounced_matrix(debounced_matrix),
		.scan_stop(scan_stop)
    );
    
    // ========================================================================
    // KEYPAD CONTROLLER (Debouncer â†' Controller)
    // ========================================================================
    keypad_controller controller_inst (
        .clk(clk),
        .rst_n(reset),
        .key_matrix(debounced_matrix),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right),
        .pressed_keys(pressed_keys)
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
