// ============================================================================
// FIRST KEY ONLY TESTBENCH
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Testbench to verify "first button press only" behavior
// Tests that only the first key is registered while holding
// ============================================================================

module tb_first_key_only;

    // Clock and reset
    logic clk = 0;
    logic rst_n = 0;
    
    // Scanner signals
    logic [3:0] row;
    logic [3:0] col = 4'b1111;
    logic [3:0] row_idx;
    logic [3:0] col_sync;
    logic key_detected;
    logic ghosting_detected;
    logic scan_stop;
    
    // Decoder signals
    logic [3:0] key_code;
    
    // Debouncer signals
    logic key_valid;
    logic [3:0] debounced_key;
    logic [3:0] held_key_code;
    
    // ========================================================================
    // INSTANTIATE MODULES
    // ========================================================================
    keypad_scanner scanner (
        .clk(clk),
        .rst_n(rst_n),
        .row(row),
        .col(col),
        .row_idx(row_idx),
        .col_sync(col_sync),
        .key_detected(key_detected),
        .ghosting_detected(ghosting_detected),
        .scan_stop(scan_stop)
    );
    
    keypad_decoder decoder (
        .row_onehot(row_idx),
        .col_onehot(~col_sync),  // Convert active-low to active-high
        .key_code(key_code)
    );
    
    keypad_debouncer debouncer (
        .clk(clk),
        .rst_n(rst_n),
        .key_code(key_code),
        .key_detected(key_detected),
        .ghosting_detected(ghosting_detected),
        .key_valid(key_valid),
        .debounced_key(debounced_key),
        .held_key_code(held_key_code),
        .scan_stop(scan_stop)
    );
    
    // ========================================================================
    // CLOCK GENERATION
    // ========================================================================
    initial begin
        forever #5 clk = ~clk;
    end
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("=== FIRST KEY ONLY TESTBENCH ===");
        
        // Reset sequence
        #20 rst_n = 1;
        #50;
        
        $display("\n--- Test 1: First Key Registration ---");
        test_first_key_registration();
        
        $display("\n--- Test 2: Second Key Ignored While Holding First ---");
        test_second_key_ignored();
        
        $display("\n--- Test 3: Key Release and New Key ---");
        test_key_release_and_new_key();
        
        $display("\n--- Test 4: Multiple Keys Simultaneous (First Wins) ---");
        test_multiple_keys_simultaneous();
        
        $display("\n=== ALL TESTS COMPLETE ===");
        $finish;
    end
    
    // ========================================================================
    // TEST TASKS
    // ========================================================================
    
    task test_first_key_registration();
        $display("Testing first key registration...");
        
        // Press key 1 (Row 0, Col 0)
        col = 4'b1110;  // Column 0 active
        #200;  // Wait for debounce and hold
        
        if (held_key_code == 4'b0001) begin
            $display("PASS: First key registered and held correctly");
            $display("  Held key code: %h", held_key_code);
        end else begin
            $display("FAIL: First key not registered (held_key_code=%h)", held_key_code);
        end
        
        // Wait for key to be held
        #100;
        
        if (held_key_code == 4'b0001) begin
            $display("PASS: First key maintained in held state");
        end else begin
            $display("FAIL: First key not maintained (held_key_code = %h)", held_key_code);
        end
        
        // Release key
        col = 4'b1111;
        #50;
        
        if (held_key_code == 4'b0000) begin
            $display("PASS: Key released properly");
        end else begin
            $display("FAIL: Key not released (held_key_code = %h)", held_key_code);
        end
    endtask
    
    task test_second_key_ignored();
        $display("Testing second key ignored while holding first...");
        
        // Press key 1 first
        col = 4'b1110;  // Key 1
        #200;  // Wait for debounce and hold
        
        if (held_key_code == 4'b0001) begin
            $display("PASS: First key (1) is held");
        end else begin
            $display("FAIL: First key not held (held_key_code = %h)", held_key_code);
        end
        
        // Try to press key 2 while holding key 1
        // This should cause the system to go back to IDLE since decoder can't handle multiple keys
        col = 4'b1100;  // Keys 1 and 2 (different columns)
        #100;
        
        if (held_key_code == 4'b0000) begin
            $display("PASS: Multiple keys ignored, system returned to IDLE (correct behavior)");
        end else begin
            $display("FAIL: System should ignore multiple keys (held_key_code = %h)", held_key_code);
        end
        
        if (!key_valid) begin
            $display("PASS: No new key valid while holding first key");
        end else begin
            $display("FAIL: New key valid while holding first key");
        end
        
        // Release all keys
        col = 4'b1111;
        #50;
    endtask
    
    task test_key_release_and_new_key();
        $display("Testing key release and new key registration...");
        
        // Press key 1
        col = 4'b1110;  // Key 1
        #200;
        
        if (held_key_code == 4'b0001) begin
            $display("PASS: Key 1 held");
        end else begin
            $display("FAIL: Key 1 not held");
        end
        
        // Release key 1
        col = 4'b1111;
        #200;  // Longer delay to ensure system is in IDLE
        
        if (held_key_code == 4'b0000) begin
            $display("PASS: Key 1 released");
        end else begin
            $display("FAIL: Key 1 not released");
        end
        
        // Press key 2 (Row 0, Col 1)
        col = 4'b1101;  // Key 2 (column 1 active)
        #300;  // Longer delay for debounce
        
        if (held_key_code == 4'b0010) begin
            $display("PASS: Key 2 registered and held after key 1 release");
        end else begin
            $display("FAIL: Key 2 not registered (held_key_code=%h)", held_key_code);
        end
        
        // Release key 2
        col = 4'b1111;
        #50;
    endtask
    
    task test_multiple_keys_simultaneous();
        $display("Testing multiple keys pressed simultaneously...");
        
        // Press keys 1 and 2 simultaneously (different columns)
        // This should result in no valid key since decoder can't handle multiple keys
        col = 4'b1100;  // Keys 1 and 2
        #200;
        
        if (!key_valid) begin
            $display("PASS: No key registered from simultaneous press (expected behavior)");
        end else begin
            $display("FAIL: Key registered from simultaneous press (unexpected)");
        end
        
        // Check that no key is held (since no valid key was registered)
        if (held_key_code == 4'b0000) begin
            $display("PASS: No key held from simultaneous press (expected behavior)");
        end else begin
            $display("FAIL: Key held from simultaneous press (unexpected)");
        end
        
        // Release all keys
        col = 4'b1111;
        #50;
    endtask
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    always @(posedge clk) begin
        if (key_valid) begin
            $display("Time %0t: Key valid = %b, Key code = %h", $time, key_valid, debounced_key);
        end
        
        if (ghosting_detected) begin
            $display("Time %0t: GHOSTING DETECTED!", $time);
        end
        
        if (held_key_code != 4'b0000) begin
            $display("Time %0t: Held key = %h", $time, held_key_code);
        end
    end

endmodule
