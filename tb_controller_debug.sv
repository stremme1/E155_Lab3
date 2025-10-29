// ============================================================================
// KEYPAD CONTROLLER TEST BENCH - SHOW MODULE STATE CHANGES
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench that shows actual module state changes in waveforms
// ============================================================================


module tb_controller_debug;

    // Clock and reset
    logic        clk;
    logic        rst_n;
    
    // Controller inputs
    logic [3:0]  key_code;
    logic        key_valid;
    
    // Controller outputs
    logic [3:0]  digit_left;
    logic [3:0]  digit_right;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    keypad_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
        .key_valid(key_valid),
        .digit_left(digit_left),
        .digit_right(digit_right)
    );
    
    // ========================================================================
    // CLOCK GENERATION - VERY SLOW FOR QUESTA
    // ========================================================================
    initial begin
        clk = 0;
        forever #1000 clk = ~clk; // 500kHz clock (2us period) - SLOW ENOUGH TO SEE
    end
    
    // ========================================================================
    // WAVEFORM DUMPING - SHOW ALL INTERNAL SIGNALS
    // ========================================================================
    initial begin
        $dumpfile("tb_controller_debug.vcd");
        $dumpvars(0, tb_controller_debug);
    end
    
    // ========================================================================
    // TEST STIMULUS - SHOW STATE CHANGES
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("CONTROLLER TEST - SHOWING MODULE STATE CHANGES");
        $display("==========================================");
        
        // Initialize
        rst_n = 0;
        key_code = 4'h0;
        key_valid = 0;
        
        // Reset sequence
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
        
        $display("Reset complete - controller should be in IDLE state");
        
        // Test 1: No input - should stay in IDLE
        $display("Test 1: No input - should stay in IDLE state");
        key_code = 4'h0;
        key_valid = 0;
        repeat(20) @(posedge clk);
        
        // Test 2: Key 1 valid - should go to KEY_HELD and update digits
        $display("Test 2: Key 1 valid - should go IDLE->KEY_HELD and update digits");
        key_code = 4'h1;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 3: Key 2 valid - should go to KEY_HELD and shift digits
        $display("Test 3: Key 2 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h2;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 4: Key 3 valid - should go to KEY_HELD and shift digits
        $display("Test 4: Key 3 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h3;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 5: Key C valid - should go to KEY_HELD and shift digits
        $display("Test 5: Key C valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'hC;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 6: Key 4 valid - should go to KEY_HELD and shift digits
        $display("Test 6: Key 4 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h4;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 7: Key 5 valid - should go to KEY_HELD and shift digits
        $display("Test 7: Key 5 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h5;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 8: Key 6 valid - should go to KEY_HELD and shift digits
        $display("Test 8: Key 6 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h6;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 9: Key D valid - should go to KEY_HELD and shift digits
        $display("Test 9: Key D valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'hD;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 10: Key 7 valid - should go to KEY_HELD and shift digits
        $display("Test 10: Key 7 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h7;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 11: Key 8 valid - should go to KEY_HELD and shift digits
        $display("Test 11: Key 8 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h8;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 12: Key 9 valid - should go to KEY_HELD and shift digits
        $display("Test 12: Key 9 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h9;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 13: Key E valid - should go to KEY_HELD and shift digits
        $display("Test 13: Key E valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'hE;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 14: Key A valid - should go to KEY_HELD and shift digits
        $display("Test 14: Key A valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'hA;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 15: Key 0 valid - should go to KEY_HELD and shift digits
        $display("Test 15: Key 0 valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'h0;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 16: Key B valid - should go to KEY_HELD and shift digits
        $display("Test 16: Key B valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'hB;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 17: Key F valid - should go to KEY_HELD and shift digits
        $display("Test 17: Key F valid - should go IDLE->KEY_HELD and shift digits");
        key_code = 4'hF;
        key_valid = 1;
        repeat(10) @(posedge clk);
        key_valid = 0;
        repeat(10) @(posedge clk);
        
        // Test 18: Rapid key changes - watch digit shifting
        $display("Test 18: Rapid key changes - watch digit shifting");
        key_code = 4'h1; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 1
        key_code = 4'h2; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 2
        key_code = 4'h3; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 3
        key_code = 4'hC; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key C
        key_code = 4'h4; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 4
        key_code = 4'h5; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 5
        key_code = 4'h6; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 6
        key_code = 4'hD; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key D
        key_code = 4'h7; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 7
        key_code = 4'h8; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 8
        key_code = 4'h9; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 9
        key_code = 4'hE; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key E
        key_code = 4'hA; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key A
        key_code = 4'h0; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key 0
        key_code = 4'hB; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key B
        key_code = 4'hF; key_valid = 1; repeat(5) @(posedge clk); key_valid = 0; repeat(5) @(posedge clk); // Key F
        
        // Test 19: Final state
        $display("Test 19: Final state - should show final digit values");
        key_code = 4'h0;
        key_valid = 0;
        repeat(20) @(posedge clk);
        
        $display("Test complete! Check the VCD file for waveforms.");
        $finish;
    end

endmodule