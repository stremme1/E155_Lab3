// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Keypad Scanner FSM - Based on Jackson Philion's approach but adapted for Emmett's unique keypad layout

// Keypad decoder module - converts row/column to digit
module keypad_decoder_emmett(
    input   logic   [3:0]   stored_col,
    input   logic   [3:0]   stored_row,
    output  logic   [3:0]   temp_digit
);

    always_comb
        case (stored_col)
            4'b1000:    case (stored_row)  // Column 3
                            4'b1000: temp_digit = 4'hF;  // Key F
                            4'b0100: temp_digit = 4'hE;  // Key E
                            4'b0010: temp_digit = 4'hD;  // Key D
                            4'b0001: temp_digit = 4'hC;  // Key C
                            default: temp_digit = 4'h0;
                        endcase
            4'b0100:    case (stored_row)  // Column 2
                            4'b1000: temp_digit = 4'hB;  // Key B
                            4'b0100: temp_digit = 4'h9;  // Key 9
                            4'b0010: temp_digit = 4'h6;  // Key 6
                            4'b0001: temp_digit = 4'h3;  // Key 3
                            default: temp_digit = 4'h0;
                        endcase
            4'b0010:    case (stored_row)  // Column 1
                            4'b1000: temp_digit = 4'h0;  // Key 0
                            4'b0100: temp_digit = 4'h8;  // Key 8
                            4'b0010: temp_digit = 4'h5;  // Key 5
                            4'b0001: temp_digit = 4'h2;  // Key 2
                            default: temp_digit = 4'h0;
                        endcase
            4'b0001:    case (stored_row)  // Column 0
                            4'b1000: temp_digit = 4'hA;  // Key A
                            4'b0100: temp_digit = 4'h7;  // Key 7
                            4'b0010: temp_digit = 4'h4;  // Key 4
                            4'b0001: temp_digit = 4'h1;  // Key 1
                            default: temp_digit = 4'h0;
                        endcase
            default:  temp_digit = 4'h0;
        endcase
endmodule

// Debounce counter module
module debounce_counter(
    input   logic   clk,
    input   logic   reset,
    input   logic   enable,
    input   logic   [3:0]   sense,
    output  logic   [3:0]   row_hold,
    output  logic   debounce_complete,
    output  logic   key_still_pressed
);

    logic [15:0] counter;
    logic [3:0] sense_sync1, sense_sync2;
    
    // Double synchronizer
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            sense_sync1 <= 4'b0000;
            sense_sync2 <= 4'b0000;
        end else begin
            sense_sync1 <= sense;
            sense_sync2 <= sense_sync1;
        end
    end
    
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            counter <= 16'd0;
            row_hold <= 4'b0000;
            debounce_complete <= 1'b0;
            key_still_pressed <= 1'b0;
        end else if (enable) begin
            if (sense_sync2 != 4'b0000) begin  // Key pressed
                if (counter >= 16'd30000) begin  // ~10ms at 3MHz
                    debounce_complete <= 1'b1;
                    row_hold <= sense_sync2;
                    key_still_pressed <= 1'b1;
                end else begin
                    counter <= counter + 1;
                    debounce_complete <= 1'b0;
                end
            end else begin  // No key pressed
                counter <= 16'd0;
                debounce_complete <= 1'b0;
                key_still_pressed <= 1'b0;
            end
        end else begin
            counter <= 16'd0;
            debounce_complete <= 1'b0;
        end
    end
endmodule

// Hold counter module - waits for key release
module hold_counter(
    input   logic   clk,
    input   logic   reset,
    input   logic   enable,
    input   logic   [3:0]   sense,
    output  logic   key_released
);

    logic [15:0] counter;
    logic [3:0] sense_sync1, sense_sync2;
    
    // Double synchronizer
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            sense_sync1 <= 4'b0000;
            sense_sync2 <= 4'b0000;
        end else begin
            sense_sync1 <= sense;
            sense_sync2 <= sense_sync1;
        end
    end
    
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            counter <= 16'd0;
            key_released <= 1'b0;
        end else if (enable) begin
            if (sense_sync2 == 4'b0000) begin  // No key pressed
                if (counter >= 16'd15000) begin  // ~5ms at 3MHz
                    key_released <= 1'b1;
                end else begin
                    counter <= counter + 1;
                    key_released <= 1'b0;
                end
            end else begin  // Key still pressed
                counter <= 16'd0;
                key_released <= 1'b0;
            end
        end else begin
            counter <= 16'd0;
            key_released <= 1'b0;
        end
    end
endmodule

// Main keypad scanner FSM
typedef enum logic [3:0] {
    SCAN_COL0, SCAN_COL1, SCAN_COL2, SCAN_COL3,
    INITIALIZE, VERIFY, DISPLAY, HOLD,
    BOOT_DELAY1, BOOT_DELAY2
} state_type;

module keypad_scanner_fsm(
    input   logic   clk,
    input   logic   reset,
    input   logic   [3:0]   sense,  // Row inputs
    output  logic   [3:0]   scan,   // Column outputs
    output  logic   [3:0]   key_code,
    output  logic   key_valid
);

    state_type state, next_state;
    logic [3:0] row_sense_hold;
    logic [3:0] col_scan_hold, one_prior_scan, two_prior_scan;
    logic [3:0] temp_digit;
    logic ensure_en, hold_en, top_rail, bot_rail, hold_bot_rail, exit_scan;

    // Instantiate modules
    debounce_counter debounce_counter_inst(
        .clk(clk),
        .reset(reset),
        .enable(ensure_en),
        .sense(sense),
        .row_hold(row_sense_hold),
        .debounce_complete(top_rail),
        .key_still_pressed(bot_rail)
    );

    keypad_decoder_emmett keypad_decoder_inst(
        .stored_col(col_scan_hold),
        .stored_row(row_sense_hold),
        .temp_digit(temp_digit)
    );

    hold_counter hold_counter_inst(
        .clk(clk),
        .reset(reset),
        .enable(hold_en),
        .sense(sense),
        .key_released(hold_bot_rail)
    );

    // Next state logic
    assign exit_scan = ((sense == 4'b0001) | (sense == 4'b0010) | (sense == 4'b0100) | (sense == 4'b1000));
    
    always_comb
        case (state)
            BOOT_DELAY1: next_state = BOOT_DELAY2;
            BOOT_DELAY2: next_state = SCAN_COL0;
            SCAN_COL0:   if (exit_scan) next_state = INITIALIZE;
                        else            next_state = SCAN_COL1;
            SCAN_COL1:   if (exit_scan) next_state = INITIALIZE;
                        else            next_state = SCAN_COL2;
            SCAN_COL2:   if (exit_scan) next_state = INITIALIZE;
                        else            next_state = SCAN_COL3;
            SCAN_COL3:   if (exit_scan) next_state = INITIALIZE;
                        else            next_state = SCAN_COL0;
            INITIALIZE:  next_state = VERIFY;
            VERIFY:      if (bot_rail)        next_state = BOOT_DELAY1;
                        else if (top_rail)    next_state = DISPLAY;
                        else                  next_state = VERIFY;
            DISPLAY:     next_state = HOLD;
            HOLD:        if (~hold_bot_rail)  next_state = HOLD;
                        else                  next_state = BOOT_DELAY1;
            default:     next_state = BOOT_DELAY1;
        endcase

    // State register
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= BOOT_DELAY1;
            key_code <= 4'b0;
            key_valid <= 1'b0;
        end else begin
            if (next_state == INITIALIZE) begin
                row_sense_hold <= sense;
                col_scan_hold <= ~two_prior_scan;
            end
            if (next_state == DISPLAY) begin
                key_code <= temp_digit;
                key_valid <= 1'b1;
            end else if (next_state == BOOT_DELAY1) begin
                key_valid <= 1'b0;
            end
            state <= next_state;
        end
    end

    // Add scan register to make up for synchronizer delay
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            one_prior_scan <= 4'b0000;
            two_prior_scan <= 4'b0000;
        end else begin
            one_prior_scan <= scan;
            two_prior_scan <= one_prior_scan;
        end
    end

    // State output logic
    always_comb
        case (state)
            BOOT_DELAY1: begin scan = 4'b1011; ensure_en = 0; hold_en = 0; end
            BOOT_DELAY2: begin scan = 4'b0111; ensure_en = 0; hold_en = 0; end
            SCAN_COL0:   begin scan = 4'b1110; ensure_en = 0; hold_en = 0; end
            SCAN_COL1:   begin scan = 4'b1101; ensure_en = 0; hold_en = 0; end
            SCAN_COL2:   begin scan = 4'b1011; ensure_en = 0; hold_en = 0; end
            SCAN_COL3:   begin scan = 4'b0111; ensure_en = 0; hold_en = 0; end
            INITIALIZE:  begin scan = ~col_scan_hold; ensure_en = 1; hold_en = 0; end
            VERIFY:      begin scan = ~col_scan_hold; ensure_en = 1; hold_en = 0; end
            DISPLAY:     begin scan = 4'b0000; ensure_en = 0; hold_en = 1; end
            HOLD:        begin scan = 4'b0000; ensure_en = 0; hold_en = 1; end
            default:     begin scan = 4'b0001; ensure_en = 0; hold_en = 0; end
        endcase

endmodule
