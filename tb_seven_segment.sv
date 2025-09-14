// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench for seven_segment module

module tb_seven_segment();

    // Testbench signals
    logic [3:0] num;
    logic [6:0] seg;

    // Instantiate DUT
    seven_segment dut (
        .num(num),
        .seg(seg)
    );

    // Test stimulus
    initial begin
        $display("=== Seven Segment Decoder Testbench ===");
        
        // Test all hexadecimal digits
        num = 4'h0;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h1;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h2;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h3;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h4;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h5;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h6;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h7;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h8;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'h9;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'hA;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'hB;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'hC;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'hD;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'hE;
        $display("Input: %h, Segments: %b", num, seg);
        
        num = 4'hF;
        $display("Input: %h, Segments: %b", num, seg);
        
        $display("\n=== Test Complete ===");
        $finish;
    end

endmodule