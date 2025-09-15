module keypad_decoder (
    input  logic [3:0] row_onehot,
    input  logic [3:0] col_onehot,
    output logic [3:0] key_code   // 4-bit hex code 0000..1111
);

    always_comb begin
        // default
        key_code = 4'b0000;
        case ({row_onehot, col_onehot})
            // row0 (0001)
            {4'b0001, 4'b0001}: key_code = 4'b0001; // 1
            {4'b0001, 4'b0010}: key_code = 4'b0010; // 2
            {4'b0001, 4'b0100}: key_code = 4'b0011; // 3
            {4'b0001, 4'b1000}: key_code = 4'b1100; // C

            // row1 (0010)
            {4'b0010, 4'b0001}: key_code = 4'b0100; // 4
            {4'b0010, 4'b0010}: key_code = 4'b0101; // 5
            {4'b0010, 4'b0100}: key_code = 4'b0110; // 6
            {4'b0010, 4'b1000}: key_code = 4'b1101; // D

            // row2 (0100)
            {4'b0100, 4'b0001}: key_code = 4'b0111; // 7
            {4'b0100, 4'b0010}: key_code = 4'b1000; // 8
            {4'b0100, 4'b0100}: key_code = 4'b1001; // 9
            {4'b0100, 4'b1000}: key_code = 4'b1110; // E

            // row3 (1000)
            {4'b1000, 4'b0001}: key_code = 4'b1010; // A
            {4'b1000, 4'b0010}: key_code = 4'b0000; // 0
            {4'b1000, 4'b0100}: key_code = 4'b1011; // B
            {4'b1000, 4'b1000}: key_code = 4'b1111; // F

            default: key_code = 4'b0000;
        endcase
    end
endmodule
