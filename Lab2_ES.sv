// Emmett Stralka estralka@hmc.edu
// 09/03/25
// Lab2_ES: Main module implementing a dual seven-segment display system with power multiplexing

module Lab2_ES (
    input  logic        clk,           // External clock input
    input  logic        reset,         // Active-high reset signal (matches top-level)
    input  logic [3:0]  s0,            // First 4-bit input number
    input  logic [3:0]  s1,            // Second 4-bit input number
    output logic [6:0]  seg,           // Multiplexed seven-segment signal
    output logic        select0,       // Power multiplexing control for display 0 (PNP transistor)
    output logic        select1        // Power multiplexing control for display 1 (PNP transistor)
);

    // Internal signals
    logic [3:0] muxed_input;            // Multiplexed input to seven-segment decoder
    logic display_select;               // Current display selection (0 or 1)
    logic [23:0] divcnt;                // Clock divider counter for multiplexing

    // 2-to-1 multiplexer for input selection to seven-segment decoder
    // Note: Using direct assignment since MUX2 is designed for 7-bit signals
    assign muxed_input = display_select ? s1 : s0;

    // Single seven-segment display decoder (Lab requirement: only ONE instance)
    seven_segment seven_seg_decoder (
        .num(muxed_input),             // Input: multiplexed 4-bit number
        .seg(seg)                      // Output: 7-segment pattern
    );


    // --- Power Multiplexing at ~60 Hz ---
    // This controls which display is powered on to create the illusion of both being on
    localparam HALF_PERIOD = 25_000;   // Half period for 3 MHz input clock (~60 Hz switching)

    // Clock divider for power multiplexing
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin               // Async active-high reset (matches top-level)
            divcnt <= 0;
            display_select <= 0;
        end else if (divcnt >= HALF_PERIOD - 1) begin
            divcnt <= 0;
            display_select <= ~display_select; // Toggle between displays
        end else begin
            divcnt <= divcnt + 1;      // Increment counter
        end
    end

    // Power multiplexing control for PNP transistors
    assign select0 = ~display_select;  // Controls PNP for Display 0 (shows s0) - inverted for PNP
    assign select1 = display_select;   // Controls PNP for Display 1 (shows s1) - inverted for PNP

endmodule