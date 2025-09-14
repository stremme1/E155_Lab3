// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Lab3 Top Module - Clean FSM-based Keypad Scanner

module lab3_top_clean (
    input  logic        reset,
    input  logic [3:0]  keypad_rows,   // Row inputs (FPGA reads)
    output logic [3:0]  keypad_cols,   // Column outputs (FPGA drives)
    output logic [6:0]  seg,
    output logic        select0,
    output logic        select1
);

    logic        clk;
    logic [3:0]  key_code;
    logic        key_valid;
    logic [3:0]  digit_left, digit_right;

    // Internal oscillator
    HSOSC #(.CLKHF_DIV(2'b11)) 
          hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // Clean FSM keypad scanner
    keypad_scanner_clean scanner (
        .clk(clk),
        .rst_n(reset),
        .keypad_rows(keypad_rows),
        .keypad_cols(keypad_cols),
        .key_code(key_code),
        .key_valid(key_valid)
    );
    
    // Keypad controller
    keypad_controller controller (
        .clk(clk),
        .rst_n(reset),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );

    // Display system
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
