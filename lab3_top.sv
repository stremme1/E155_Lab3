// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Top Module

module lab3_top (
    input  logic        reset,
    output logic [3:0]  keypad_cols,    // FPGA drives columns (output)
    input  logic [3:0]  keypad_rows,    // FPGA reads rows (input)
    output logic [6:0]  seg,
    output logic        select0,
    output logic        select1
);

    logic        clk, clk_div;
    logic [3:0]  key_code;
    logic        key_valid;
    logic [3:0]  digit_left, digit_right;
    logic [15:0] clk_counter;

    // Internal oscillator
    HSOSC #(.CLKHF_DIV(2'b11)) 
          hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
    
    // Clock divider for better timing
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            clk_counter <= 16'd0;
            clk_div <= 1'b0;
        end else begin
            clk_counter <= clk_counter + 1;
            if (clk_counter == 16'd2999) begin  // Divide by 3000 for ~1kHz from 3MHz
                clk_counter <= 16'd0;
                clk_div <= ~clk_div;
            end
        end
    end

    // Keypad scanner (use divided clock for better debouncing)
    keypad_scanner scanner (
        .clk(clk_div),
        .rst_n(reset),
        .keypad_cols(keypad_cols),    // FPGA drives columns
        .keypad_rows(keypad_rows),    // FPGA reads rows
        .key_code(key_code),
        .key_pressed(),
        .key_valid(key_valid)
    );
    
    // Keypad controller (use divided clock)
    keypad_controller controller (
        .clk(clk_div),
        .rst_n(reset),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

    // Display system (use original clock for smooth multiplexing)
    Lab2_ES display (
        .clk(clk),
        .reset(reset),
        .s0(digit_left),
        .s1(digit_right),
        .seg(seg),
        .select0(select0),
        .select1(select1)
    );

endmodule
