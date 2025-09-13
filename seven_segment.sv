// Emmett Stralka estralka@hmc.edu
// 08/29/25
// Seven-segment display decoder: Converts 4-bit binary input to 7-segment display pattern

module seven_segment (
    input  logic [3:0] num,     // 4-bit input number (0-15)
    output logic [6:0] seg      // 7-bit output for segments a-g (active low)
);

// Seven-segment display mapping (segments a-g):
// 0 = A,B,C,D,E,F (all except G)
// 1 = B,C
// 2 = A,B,G,E,D
// 3 = A,B,C,G,D
// 4 = B,C,F,G
// 5 = A,C,D,F,G
// 6 = C,D,E,F,G
// 7 = A,B,C
// 8 = A,B,C,D,E,F,G (all segments)
// 9 = A,B,C,D,F,G
// A-F = Hexadecimal digits 10-15

// Note: Segments are active LOW (0 = ON, 1 = OFF)
    // Combinational logic to decode 4-bit input to 7-segment pattern
    always_comb begin
        unique case (num)
            4'd0: seg = 7'b1000000; // 0: A,B,C,D,E,F ON; G OFF
            4'd1: seg = 7'b1111001; // 1: B,C ON
            4'd2: seg = 7'b0100100; // 2: A,B,G,E,D ON
            4'd3: seg = 7'b0110000; // 3: A,B,C,G,D ON
            4'd4: seg = 7'b0011001; // 4: B,C,F,G ON
            4'd5: seg = 7'b0010010; // 5: A,C,D,F,G ON
            4'd6: seg = 7'b0000010; // 6: C,D,E,F,G ON
            4'd7: seg = 7'b1111000; // 7: A,B,C ON
            4'd8: seg = 7'b0000000; // 8: all segments ON
            4'd9: seg = 7'b0010000; // 9: A,B,C,D,F,G ON
            4'd10: seg = 7'b0001000; // A: A,B,C,E,F,G ON
            4'd11: seg = 7'b0000011; // B: C,D,E,F,G ON
            4'd12: seg = 7'b1000110; // C: A,D,E,F ON
            4'd13: seg = 7'b0100001; // D: B,C,D,E,G ON
            4'd14: seg = 7'b0000110; // E: A,D,E,F,G ON
            4'd15: seg = 7'b0001110; // F: A,E,F,G ON
            default: seg = 7'b1111111; // blank (all segments OFF)
        endcase
    end

endmodule
