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

    typedef enum logic [1:0] { IDLE, DEBOUNCE, HOLD, RELEASE } state_t;
    state_t state, next_state;

    logic [15:0] debounce_cnt;
    localparam int DEBOUNCE_MAX = 16'd60000; // ~20ms @ 3MHz, good for physical hardware

    // candidate latch
    logic [3:0] cand_row, cand_col;

    // state register + counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            debounce_cnt <= 16'd0;
            cand_row <= 4'b0000;
            cand_col <= 4'b0000;
            key_valid <= 1'b0;
            key_row <= 4'b0000;
            key_col <= 4'b0000;
        end else begin
            state <= next_state;

            // Latch candidate values when entering DEBOUNCE state
            if (state == IDLE && next_state == DEBOUNCE && key_pressed && row_idx != 4'b0000 && col_idx != 4'b0000) begin
                cand_row <= row_idx;
                cand_col <= col_idx;
            end

            // count only while actively debouncing the same candidate
            if (state == DEBOUNCE && key_pressed && row_idx == cand_row && col_idx == cand_col) begin
                if (debounce_cnt < DEBOUNCE_MAX) debounce_cnt <= debounce_cnt + 1;
            end else begin
                debounce_cnt <= 16'd0;
            end

            // In HOLD, keep key outputs latched from candidate
            if (state == HOLD) begin
                key_valid <= 1'b1;
                key_row   <= cand_row;
                key_col   <= cand_col;
            end else begin
                key_valid <= 1'b0;
            end
        end
    end

    // next-state logic: require continuity of candidate while debouncing
    always_comb begin
        next_state = state;
        case (state)
            IDLE:      if (key_pressed) next_state = DEBOUNCE;
            DEBOUNCE:  begin
                // require the candidate to remain present; if it disappears or changes -> abort
                if (!key_pressed || row_idx != cand_row || col_idx != cand_col)
                    next_state = IDLE;
                else if (debounce_cnt >= DEBOUNCE_MAX)
                    next_state = HOLD;
            end
            HOLD:      if (!key_pressed) next_state = RELEASE;
            RELEASE:   if (!key_pressed) next_state = IDLE; // optional: add release debounce if desired
        endcase
    end
endmodule
