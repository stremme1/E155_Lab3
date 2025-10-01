// ============================================================================
// LAB3 TOP MODULE - SIMULATION VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Top Module - Simulation Version
// Simulation version without HSOSC for testing. Uses internal clock generation
// for simulation purposes instead of hardware oscillator.
// ============================================================================

module lab3_top_sim (
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
    logic [3:0]  col_onehot;           // Column data converted to one-hot
    logic [3:0]  raw_key_code;         // Raw key code from decoder
    logic        key_valid;            // Debounced valid key press signal
    logic [3:0]  debounced_key;        // Debounced key code from debouncer
    logic [3:0]  digit_left;           // Left display digit
    logic [3:0]  digit_right;          // Right display digit
    logic        scan_stop;            // Scan stop signal from debouncer
    
    // Enhanced debouncer outputs for multi-key support
    logic        key_held;             // Signal that a key is currently held
    logic [3:0]  held_key_code;        // The code of the held key
    logic        flash_enable;         // Enable flashing behavior
    logic        combo_ready;          // Ready for key combination detection

    // ========================================================================
    // SIMULATION CLOCK GENERATION
    // ========================================================================
    initial begin
        clk = 0;
        forever #166.67 clk = ~clk; // 3MHz clock (333.33ns period)
    end

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
        .scan_stop(scan_stop)
    );
    
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
    // KEYPAD DECODER (Scanner → Decoder)
    // ========================================================================
    keypad_decoder decoder_inst (
        .row_onehot(row_idx),
        .col_onehot(col_onehot),
        .key_code(raw_key_code)
    );
    
    // ========================================================================
    // KEYPAD DEBOUNCER (Decoder → Debouncer)
    // ========================================================================
    keypad_debouncer debouncer_inst (
        .clk(clk),
        .rst_n(reset),
        .key_code(raw_key_code),
        .key_detected(key_detected),
        .key_valid(key_valid),
        .debounced_key(debounced_key),
        .scan_stop(scan_stop),
        .key_held(key_held),
        .held_key_code(held_key_code),
        .flash_enable(flash_enable),
        .combo_ready(combo_ready)
    );
    
    // ========================================================================
    // KEYPAD CONTROLLER (Debouncer → Controller)
    // ========================================================================
    keypad_controller controller_inst (
        .clk(clk),
        .rst_n(reset),
        .key_code(debounced_key),
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
