// Simple keypad test - just scan and show raw values
module keypad_test_simple (
    input  logic        reset,
    output logic [3:0]  keypad_rows,   // FPGA drives rows LOW
    input  logic [3:0]  keypad_cols,   // FPGA reads columns
    output logic [6:0]  seg,           // Seven-segment display
    output logic        select0,       // Display 0
    output logic        select1        // Display 1
);

    logic        clk;
    logic [3:0]  row_counter;
    logic [15:0] scan_counter;
    logic [3:0]  raw_cols;
    logic [3:0]  display_value;

    // Internal oscillator
    HSOSC #(.CLKHF_DIV(2'b01)) 
          hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // Simple row scanning - much slower for debugging
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            row_counter <= 4'b0001;
            scan_counter <= 16'd0;
            raw_cols <= 4'b0000;
        end else begin
            scan_counter <= scan_counter + 1;
            if (scan_counter == 16'd0) begin
                row_counter <= {row_counter[2:0], row_counter[3]};
            end
            raw_cols <= keypad_cols;  // Capture column values
        end
    end

    // Drive rows LOW (one at a time)
    assign keypad_rows = ~row_counter;
    
    // Display the raw column values for debugging
    assign display_value = raw_cols;

    // Simple display system
    seven_segment seg_decoder (
        .num(display_value),
        .seg(seg)
    );

    // Simple display control - show same value on both displays
    assign select0 = 1'b1;  // Always on
    assign select1 = 1'b0;  // Always off

endmodule
