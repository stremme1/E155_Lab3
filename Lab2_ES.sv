 // Emmett Stralka estralka@hmc.edu
// 09/03/25
// Lab2_ES: Main module implementing a dual seven-segment display system with power multiplexing

module Lab2_ES (
    input  clk,           // External clock input
    input  reset,         // Active-low reset signal
    input  [3:0] s0,      // First 4-bit input number
    input  [3:0] s1,      // Second 4-bit input number
    output [6:0] seg,     // Multiplexed seven-segment signal
    output select0,       // Power multiplexing control for display 0 (PNP transistor)
    output select1        // Power multiplexing control for display 1 (PNP transistor)
);

    // Internal signals
    wire [3:0] muxed_input;            // Multiplexed input to seven-segment decoder
    reg display_select;                // Current display selection (0 or 1)
    reg [23:0] divcnt;                 // Clock divider counter for multiplexing

    // Simple 4-bit multiplexer for input selection (s0 or s1)
    assign muxed_input = display_select ? s1 : s0;

    // Single seven-segment display decoder (Lab requirement: only ONE instance)
    seven_segment seven_seg_decoder (
        .num(muxed_input),             // Input: multiplexed 4-bit number
        .seg(seg)                      // Output: 7-segment pattern
    );


    // --- Power Multiplexing at ~100 Hz ---
    // This controls which display is powered on to create the illusion of both being on
    localparam HALF_PERIOD = 60_000;   // Half period for 12 MHz input clock (100 Hz switching)

    // Clock divider for power multiplexing
    always @(posedge clk or negedge reset) begin
        if (~reset) begin              // Async active-low reset
            divcnt <= 0;
            display_select <= 0;
        end else if (divcnt == HALF_PERIOD - 1) begin
            divcnt <= 0;
            display_select <= ~display_select; // Toggle between displays
        end else begin
            divcnt <= divcnt + 1;      // Increment counter
        end
    end

    // Power multiplexing control for PNP transistors
    assign select0 = display_select;   // Controls PNP for Display 0 (shows s0)
    assign select1 = ~display_select;  // Controls PNP for Display 1 (shows s1), opposite phase

endmodule
