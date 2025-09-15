// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Top Module - Keypad Scanner with Display System

module lab3_top (
    input  logic        reset,         // Active-low reset signal
    output logic [3:0]  keypad_rows,   // Keypad row outputs (FPGA drives)
    input  logic [3:0]  keypad_cols,   // Keypad column inputs (FPGA reads)
    output logic [6:0]  seg,           // Seven-segment display signals
    output logic        select0,       // Display 0 power control
    output logic        select1        // Display 1 power control
);

    // Internal signals
    logic        clk;                  // Internal clock from HSOSC
    logic [3:0]  row_idx;              // Row index from scanner
    logic [3:0]  col_idx;              // Column index from scanner
    logic        key_pressed;          // Raw key press signal
    logic        key_valid;            // Debounced valid key press signal
    logic [3:0]  key_row;              // Debounced row from debouncer
    logic [3:0]  key_col;              // Debounced column from debouncer
    logic [3:0]  key_code;             // Decoded key code
    logic [3:0]  digit_left;           // Left display digit
    logic [3:0]  digit_right;          // Right display digit

    // Clock generation - use HSOSC for synthesis, clock_gen for simulation
    // For synthesis: HSOSC #(.CLKHF_DIV(2'b10)) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
    // For simulation: clock_gen sim_clk (.clk(clk));
    
    // Use HSOSC for synthesis (physical hardware)
    HSOSC #(.CLKHF_DIV(2'b10)) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // Keypad scanner
    keypad_scanner scanner_inst (
        .clk(clk),
        .rst_n(reset),
        .row(keypad_rows),
        .col(keypad_cols),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_pressed(key_pressed)
    );
    
    // Keypad debouncer
    keypad_debouncer debouncer_inst (
        .clk(clk),
        .rst_n(reset),
        .key_pressed(key_pressed),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_valid(key_valid),
        .key_row(key_row),
        .key_col(key_col)
    );
    
    // Keypad decoder - converts row/col to key code
    keypad_decoder decoder_inst (
        .row_onehot(key_row),
        .col_onehot(key_col),
        .key_code(key_code)
    );
    
    // Keypad controller
    keypad_controller controller_inst (
        .clk(clk),
        .rst_n(reset),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

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
