// ============================================================================
// KEYPAD DEBOUNCER TEST BENCH - SHOW MODULE STATE CHANGES
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench that shows actual module state changes in waveforms
// ============================================================================


module tb_debouncer_debug;

    // Clock and reset
    logic        clk;
    logic        rst_n;
    
    // Debouncer inputs
    logic [3:0]  key_code;
    logic [3:0]  col;
    logic        key_detected;
    
    // Debouncer outputs
    logic        key_valid;
    logic [3:0]  debounced_key;
    logic        scan_stop;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    keypad_debouncer dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
        .col(col),
        .key_detected(key_detected),
        .key_valid(key_valid),
        .debounced_key(debounced_key),
        .scan_stop(scan_stop)
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
        $dumpfile("tb_debouncer_debug.vcd");
        $dumpvars(0, tb_debouncer_debug);
        // Also dump internal debouncer signals
        $dumpvars(0, dut.current_state);
        $dumpvars(0, dut.debounce_cnt);
    end
    
    // ========================================================================
    // TEST STIMULUS - SHOW STATE CHANGES
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("DEBOUNCER TEST - SHOWING MODULE STATE CHANGES");
        $display("==========================================");
        
        // Initialize
        rst_n = 0;
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        
        // Reset sequence
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);
        
        $display("Reset complete - debouncer should be in IDLE state");
        
        // Test 1: No input - should stay in IDLE
        $display("Test 1: No input - should stay in IDLE state");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 2: Key detected - should go to DEBOUNCING
        $display("Test 2: Key detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h1;
        col = 4'b1110;
        key_detected = 1;
        repeat(100) @(posedge clk); // Hold for many cycles to see debounce
        
        // Test 3: Key released - should go back to IDLE
        $display("Test 3: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 4: Key 2 detected - should go to DEBOUNCING
        $display("Test 4: Key 2 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h2;
        col = 4'b1101;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 5: Key released - should go back to IDLE
        $display("Test 5: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 6: Key 3 detected - should go to DEBOUNCING
        $display("Test 6: Key 3 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h3;
        col = 4'b1011;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 7: Key released - should go back to IDLE
        $display("Test 7: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 8: Key C detected - should go to DEBOUNCING
        $display("Test 8: Key C detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'hC;
        col = 4'b0111;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 9: Key released - should go back to IDLE
        $display("Test 9: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 10: Key 4 detected - should go to DEBOUNCING
        $display("Test 10: Key 4 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h4;
        col = 4'b1110;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 11: Key released - should go back to IDLE
        $display("Test 11: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 12: Key 5 detected - should go to DEBOUNCING
        $display("Test 12: Key 5 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h5;
        col = 4'b1101;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 13: Key released - should go back to IDLE
        $display("Test 13: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 14: Key 6 detected - should go to DEBOUNCING
        $display("Test 14: Key 6 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h6;
        col = 4'b1011;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 15: Key released - should go back to IDLE
        $display("Test 15: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 16: Key D detected - should go to DEBOUNCING
        $display("Test 16: Key D detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'hD;
        col = 4'b0111;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 17: Key released - should go back to IDLE
        $display("Test 17: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 18: Key 7 detected - should go to DEBOUNCING
        $display("Test 18: Key 7 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h7;
        col = 4'b1110;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 19: Key released - should go back to IDLE
        $display("Test 19: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 20: Key 8 detected - should go to DEBOUNCING
        $display("Test 20: Key 8 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h8;
        col = 4'b1101;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 21: Key released - should go back to IDLE
        $display("Test 21: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 22: Key 9 detected - should go to DEBOUNCING
        $display("Test 22: Key 9 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h9;
        col = 4'b1011;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 23: Key released - should go back to IDLE
        $display("Test 23: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 24: Key E detected - should go to DEBOUNCING
        $display("Test 24: Key E detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'hE;
        col = 4'b0111;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 25: Key released - should go back to IDLE
        $display("Test 25: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 26: Key A detected - should go to DEBOUNCING
        $display("Test 26: Key A detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'hA;
        col = 4'b1110;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 27: Key released - should go back to IDLE
        $display("Test 27: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 28: Key 0 detected - should go to DEBOUNCING
        $display("Test 28: Key 0 detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'h0;
        col = 4'b1101;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 29: Key released - should go back to IDLE
        $display("Test 29: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 30: Key B detected - should go to DEBOUNCING
        $display("Test 30: Key B detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'hB;
        col = 4'b1011;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 31: Key released - should go back to IDLE
        $display("Test 31: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 32: Key F detected - should go to DEBOUNCING
        $display("Test 32: Key F detected - should go IDLE->DEBOUNCING->KEY_HELD");
        key_code = 4'hF;
        col = 4'b0111;
        key_detected = 1;
        repeat(100) @(posedge clk);
        
        // Test 33: Key released - should go back to IDLE
        $display("Test 33: Key released - should go back to IDLE");
        key_code = 4'h0;
        col = 4'b1111;
        key_detected = 0;
        repeat(20) @(posedge clk);
        
        // Test 34: Rapid key changes - watch state changes
        $display("Test 34: Rapid key changes - watch state changes");
        key_code = 4'h1; col = 4'b1110; key_detected = 1; repeat(10) @(posedge clk); // Key 1
        key_code = 4'h2; col = 4'b1101; key_detected = 1; repeat(10) @(posedge clk); // Key 2
        key_code = 4'h3; col = 4'b1011; key_detected = 1; repeat(10) @(posedge clk); // Key 3
        key_code = 4'hC; col = 4'b0111; key_detected = 1; repeat(10) @(posedge clk); // Key C
        key_code = 4'h4; col = 4'b1110; key_detected = 1; repeat(10) @(posedge clk); // Key 4
        key_code = 4'h5; col = 4'b1101; key_detected = 1; repeat(10) @(posedge clk); // Key 5
        key_code = 4'h6; col = 4'b1011; key_detected = 1; repeat(10) @(posedge clk); // Key 6
        key_code = 4'hD; col = 4'b0111; key_detected = 1; repeat(10) @(posedge clk); // Key D
        key_code = 4'h7; col = 4'b1110; key_detected = 1; repeat(10) @(posedge clk); // Key 7
        key_code = 4'h8; col = 4'b1101; key_detected = 1; repeat(10) @(posedge clk); // Key 8
        key_code = 4'h9; col = 4'b1011; key_detected = 1; repeat(10) @(posedge clk); // Key 9
        key_code = 4'hE; col = 4'b0111; key_detected = 1; repeat(10) @(posedge clk); // Key E
        key_code = 4'hA; col = 4'b1110; key_detected = 1; repeat(10) @(posedge clk); // Key A
        key_code = 4'h0; col = 4'b1101; key_detected = 1; repeat(10) @(posedge clk); // Key 0
        key_code = 4'hB; col = 4'b1011; key_detected = 1; repeat(10) @(posedge clk); // Key B
        key_code = 4'hF; col = 4'b0111; key_detected = 1; repeat(10) @(posedge clk); // Key F
        key_code = 4'h0; col = 4'b1111; key_detected = 0; repeat(20) @(posedge clk); // Release all
        
        $display("Test complete! Check the VCD file for waveforms.");
        $finish;
    end

endmodule