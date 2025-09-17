// ============================================================================
// LAB2_ES DISPLAY SYSTEM MODULE
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab2_ES - Seven Segment Display System
// This module implements a dual seven-segment display system with multiplexing
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