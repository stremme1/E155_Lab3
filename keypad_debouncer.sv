module keypad_debouncer (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        key_pressed, // from scanner (uses synchronized col)
    input  logic [3:0]  row_idx,
    input  logic [3:0]  col_idx,
    output logic        key_valid,   // stays high while key physically held
    output logic [3:0]  key_row,
    output logic [3:0]  key_col
);

    // Simple counter-based debouncer
    logic [15:0] debounce_cnt;
    logic [3:0]  latched_row, latched_col;
    logic        key_stable;
    
    // Internal signals for outputs
    logic        key_valid_int;
    logic [3:0]  key_row_int;
    logic [3:0]  key_col_int;
    
    localparam int DEBOUNCE_MAX = 16'd59999; // ~20ms @ 3MHz (59999 cycles for proper completion)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            debounce_cnt <= 16'd0;
            latched_row <= 4'b0000;
            latched_col <= 4'b0000;
            key_stable <= 1'b0;
            key_valid_int <= 1'b0;
            key_row_int <= 4'b0000;
            key_col_int <= 4'b0000;
        end else begin
            // If key is pressed and valid
            if (key_pressed && row_idx != 4'b0000 && col_idx != 4'b0000) begin
                // If this is a new key press, reset counter and latch new values
                if (row_idx != latched_row || col_idx != latched_col) begin
                    debounce_cnt <= 16'd0;
                    latched_row <= row_idx;
                    latched_col <= col_idx;
                    key_stable <= 1'b0;
                    key_valid_int <= 1'b0;
                end else begin
                    // Same key, increment counter
                    if (debounce_cnt < DEBOUNCE_MAX - 1) begin
                        debounce_cnt <= debounce_cnt + 1;
                    end else begin
                        // Debounce complete
                        key_stable <= 1'b1;
                        key_valid_int <= 1'b1;
                        key_row_int <= latched_row;
                        key_col_int <= latched_col;
                    end
                end
            end else begin
                // No key pressed, reset everything
                debounce_cnt <= 16'd0;
                latched_row <= 4'b0000;
                latched_col <= 4'b0000;
                key_stable <= 1'b0;
                key_valid_int <= 1'b0;
                key_row_int <= 4'b0000;
                key_col_int <= 4'b0000;
            end
        end
    end

    // Assign internal signals to outputs
    assign key_valid = key_valid_int;
    assign key_row = key_row_int;
    assign key_col = key_col_int;

endmodule
