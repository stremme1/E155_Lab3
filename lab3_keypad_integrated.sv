// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3_ES: Keypad Scanner with integrated dual seven-segment display system
// Integrates keypad scanner with existing Lab2 display multiplexing system

module Lab3_ES (
    input  logic        clk,           // External clock input (12 MHz)
    input  logic        reset,         // Active-low reset signal
    input  logic [3:0]  keypad_rows,   // Keypad row inputs (with internal pull-ups)
    output logic [3:0]  keypad_cols,   // Keypad column outputs
    output logic [6:0]  seg,           // Multiplexed seven-segment signal
    output logic        select0,       // Power multiplexing control for display 0 (PNP transistor)
    output logic        select1        // Power multiplexing control for display 1 (PNP transistor)
);

    // Internal signals
    logic [3:0]  key_code;             // Key code from scanner
    logic        key_valid;            // Valid key press signal
    logic [3:0]  digit_left;           // Left display digit
    logic [3:0]  digit_right;          // Right display digit
    logic [3:0]  muxed_input;          // Multiplexed input to seven-segment decoder
    logic display_select;              // Current display selection (0 or 1)
    logic [23:0] divcnt;               // Clock divider counter for multiplexing

    // Instantiate keypad scanner
    keypad_scanner scanner_inst (
        .clk(clk),
        .rst_n(reset),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .key_code(key_code),
        .key_pressed(),  // Not used in top level
        .key_valid(key_valid)
    );
    
    // Instantiate keypad controller
    keypad_controller controller_inst (
        .clk(clk),
        .rst_n(reset),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

    // 2-to-1 multiplexer for input selection (left or right digit)
    MUX2_4bit input_mux (
        .d0(digit_left),               // Input: left digit from keypad
        .d1(digit_right),              // Input: right digit from keypad
        .select(display_select),       // Select signal (0 = left, 1 = right)
        .y(muxed_input)                // Output: multiplexed 4-bit input
    );

    // Single seven-segment display decoder (Lab requirement: only ONE instance)
    seven_segment seven_seg_decoder (
        .num(muxed_input),             // Input: multiplexed 4-bit number
        .seg(seg)                      // Output: 7-segment pattern
    );

    // --- Power Multiplexing at ~100 Hz ---
    // This controls which display is powered on to create the illusion of both being on
    localparam int HALF_PERIOD = 60_000; // Half period for 12 MHz input clock (100 Hz switching)

    // Clock divider for power multiplexing
    always_ff @(posedge clk or negedge reset) begin
        if (~reset) begin                    // Async active-low reset
            divcnt <= 0;
            display_select <= 0;
        end else if (divcnt == 24'(HALF_PERIOD - 1)) begin
            divcnt <= 0;
            display_select <= ~display_select; // Toggle between displays
        end else begin
            divcnt <= divcnt + 1;            // Increment counter
        end
    end

    // Power multiplexing control for PNP transistors
    assign select0 = display_select;       // Controls PNP for Display 0 (shows left digit)
    assign select1 = ~display_select;      // Controls PNP for Display 1 (shows right digit), opposite phase

endmodule
