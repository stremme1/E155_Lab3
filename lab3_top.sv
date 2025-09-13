// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Top Module - Clean top-level for Lattice Radiant

module lab3_top (
    input  clk,           // External clock input (12 MHz)
    input  reset,         // Active-low reset signal
    input  [3:0] keypad_rows,   // Keypad row inputs
    output [3:0] keypad_cols,   // Keypad column outputs
    output [6:0] seg,           // Seven-segment display signals
    output select0,       // Display 0 power control
    output select1        // Display 1 power control
);

    // Internal signals
    wire [3:0] key_code;
    wire key_valid;
    wire [3:0] digit_left;
    wire [3:0] digit_right;
    wire [3:0] muxed_input;
    wire display_select;
    reg [23:0] divcnt;

    // Keypad scanner
    keypad_scanner scanner_inst (
        .clk(clk),
        .rst_n(reset),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .key_code(key_code),
        .key_pressed(),
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

    // Input multiplexer
    MUX2_4bit input_mux (
        .d0(digit_left),
        .d1(digit_right),
        .select(display_select),
        .y(muxed_input)
    );

    // Seven-segment decoder
    seven_segment seven_seg_decoder (
        .num(muxed_input),
        .seg(seg)
    );

    // Power multiplexing clock divider
    parameter HALF_PERIOD = 60_000;
    
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            divcnt <= 0;
            display_select <= 0;
        end else if (divcnt == (HALF_PERIOD - 1)) begin
            divcnt <= 0;
            display_select <= ~display_select;
        end else begin
            divcnt <= divcnt + 1;
        end
    end

    // Power multiplexing control
    assign select0 = display_select;
    assign select1 = ~display_select;

endmodule
