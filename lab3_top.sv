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
    logic [3:0]  key_code;             // Key code from scanner
    logic        key_valid;            // Valid key press signal
    logic [3:0]  digit_left;           // Left display digit
    logic [3:0]  digit_right;          // Right display digit

    // Simple clock generator for testing
    clock_gen clk_gen (.clk(clk));

    // Keypad scanner
    keypad_scanner scanner_inst (
        .clk(clk),
        .rst_n(reset),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .key_code(key_code),
        .key_valid(key_valid)
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
