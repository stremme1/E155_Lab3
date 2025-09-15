// --- scanner: synchronize 'col' and slow the scan rate (use rst_n active-low)
module keypad_scanner (
    input  logic        clk,
    input  logic        rst_n,        // use active-low across system
    output logic [3:0]  row,          // drive rows (active low)
    input  logic [3:0]  col,          // raw column inputs (async)
    output logic [3:0]  row_idx,
    output logic [3:0]  col_idx,
    output logic        key_pressed
);

    // synchronize asynchronous column inputs
    logic [3:0] col_sync1, col_sync2;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            col_sync1 <= 4'b1111;
            col_sync2 <= 4'b1111;
        end else begin
            col_sync1 <= col;
            col_sync2 <= col_sync1;
        end
    end

    // slow row scanning (change row every N clocks)
    logic [15:0] scan_counter;
    logic [1:0]  scan_state;
    localparam int SCAN_PERIOD = 16'd5999; // ~2ms per row @ 3MHz (good for physical hardware)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_counter <= 16'd0;
            scan_state   <= 2'd0;
        end else begin
            if (scan_counter == SCAN_PERIOD) begin
                scan_counter <= 16'd0;
                scan_state   <= scan_state + 1;
            end else begin
                scan_counter <= scan_counter + 1;
            end
        end
    end

    // one-hot row drive (active low)
    always_comb begin
        case (scan_state)
            2'd0: row = 4'b1110;
            2'd1: row = 4'b1101;
            2'd2: row = 4'b1011;
            2'd3: row = 4'b0111;
            default: row = 4'b1111;
        endcase
    end

    // read synchronized columns and detect valid single key press
    // Ghosting protection: only allow single key presses
    logic [3:0] col_count;
    assign col_count = (~col_sync2[0]) + (~col_sync2[1]) + (~col_sync2[2]) + (~col_sync2[3]);
    assign key_pressed = (col_sync2 != 4'b1111) && (col_count == 1);

    // produce one-hot row_idx for the currently driven row
    always_comb begin
        case (scan_state)
            2'd0: row_idx = 4'b0001;
            2'd1: row_idx = 4'b0010;
            2'd2: row_idx = 4'b0100;
            2'd3: row_idx = 4'b1000;
            default: row_idx = 4'b0000;
        endcase
    end

    // col_idx derived from synchronized columns with multiple key detection
    always_comb begin
        if (col_count > 1) begin
            // Multiple keys pressed - invalid (ghosting)
            col_idx = 4'b0000;
        end else begin
            // Single key press - map to one-hot
            case (col_sync2)
                4'b1110: col_idx = 4'b0001;  // Column 0
                4'b1101: col_idx = 4'b0010;  // Column 1
                4'b1011: col_idx = 4'b0100;  // Column 2
                4'b0111: col_idx = 4'b1000;  // Column 3
                default: col_idx = 4'b0000;  // No key or invalid
            endcase
        end
    end

endmodule
