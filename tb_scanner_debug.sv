// ============================================================================
// KEYPAD SCANNER TEST BENCH - DEBUG VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for keypad_scanner module with clear state debugging
// Shows scan states, timing, and key detection behavior
// ============================================================================

`timescale 1ns/1ps

module tb_scanner_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    
    // Clock and reset
    logic        clk;
    logic        rst_n;
    
    // Scanner outputs
    logic [3:0]  row;
    logic [3:0]  row_idx;
    logic [3:0]  col_sync;
    logic        key_detected;
    logic        scan_stop;
    
    // Scanner inputs (simulated keypad)
    logic [3:0]  col;
    
    // Test control
    integer      test_count;
    integer      cycle_count;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    keypad_scanner dut (
        .clk(clk),
        .rst_n(rst_n),
        .row(row),
        .col(col),
        .row_idx(row_idx),
        .col_sync(col_sync),
        .key_detected(key_detected),
        .scan_stop(scan_stop)
    );
    
    // ========================================================================
    // CLOCK GENERATION
    // ========================================================================
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // ========================================================================
    // STATE DISPLAY TASKS
    // ========================================================================
    task display_scan_state;
        case (dut.current_state)
            dut.SCAN_ROW0: $display("[%0t] SCANNER: State = SCAN_ROW0, Row = %b, Row_idx = %b", $time, row, row_idx);
            dut.SCAN_ROW1: $display("[%0t] SCANNER: State = SCAN_ROW1, Row = %b, Row_idx = %b", $time, row, row_idx);
            dut.SCAN_ROW2: $display("[%0t] SCANNER: State = SCAN_ROW2, Row = %b, Row_idx = %b", $time, row, row_idx);
            dut.SCAN_ROW3: $display("[%0t] SCANNER: State = SCAN_ROW3, Row = %b, Row_idx = %b", $time, row, row_idx);
            default: $display("[%0t] SCANNER: State = UNKNOWN", $time);
        endcase
    endtask
    
    task display_key_detection;
        if (key_detected) begin
            $display("[%0t] SCANNER: KEY DETECTED! Col_sync = %b", $time, col_sync);
        end else begin
            $display("[%0t] SCANNER: No key detected, Col_sync = %b", $time, col_sync);
        end
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("KEYPAD SCANNER DEBUG TEST BENCH");
        $display("==========================================");
        
        // Initialize signals
        rst_n = 0;
        col = 4'b1111; // No keys pressed initially
        test_count = 0;
        cycle_count = 0;
        
        // Reset sequence
        $display("\n[%0t] Applying reset...", $time);
        #(CLK_PERIOD * 2);
        rst_n = 1;
        #(CLK_PERIOD);
        
        $display("\n[%0t] Reset released. Starting scanner test...", $time);
        
        // Test 1: Normal scanning operation (no keys pressed)
        $display("\n--- TEST 1: Normal Scanning (No Keys) ---");
        col = 4'b1111; // No keys pressed
        for (cycle_count = 0; cycle_count < 25; cycle_count++) begin
            @(posedge clk);
            if (cycle_count % 5 == 0) begin
                display_scan_state();
                display_key_detection();
            end
            #(CLK_PERIOD/4);
        end
        
        // Test 2: Key pressed on row 0, column 0 (key '1')
        $display("\n--- TEST 2: Key '1' Pressed (Row0, Col0) ---");
        col = 4'b1110; // Column 0 active (active-low)
        for (cycle_count = 0; cycle_count < 4; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        // Test 3: Key pressed on row 1, column 1 (key '5')
        $display("\n--- TEST 3: Key '5' Pressed (Row1, Col1) ---");
        col = 4'b1101; // Column 1 active
        for (cycle_count = 0; cycle_count < 4; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        // Test 4: Key pressed on row 2, column 2 (key '9')
        $display("\n--- TEST 4: Key '9' Pressed (Row2, Col2) ---");
        col = 4'b1011; // Column 2 active
        for (cycle_count = 0; cycle_count < 4; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        // Test 5: Key pressed on row 3, column 3 (key 'F')
        $display("\n--- TEST 5: Key 'F' Pressed (Row3, Col3) ---");
        col = 4'b0111; // Column 3 active
        for (cycle_count = 0; cycle_count < 4; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        // Test 6: Multiple keys pressed (should not detect)
        $display("\n--- TEST 6: Multiple Keys Pressed (Should Not Detect) ---");
        col = 4'b1100; // Columns 0 and 1 active
        for (cycle_count = 0; cycle_count < 4; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        // Test 7: No keys pressed
        $display("\n--- TEST 7: No Keys Pressed ---");
        col = 4'b1111; // No keys active
        for (cycle_count = 0; cycle_count < 4; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        // Test 8: Scan stop functionality
        $display("\n--- TEST 8: Scan Stop Functionality ---");
        scan_stop = 1;
        $display("[%0t] Scan stop asserted", $time);
        for (cycle_count = 0; cycle_count < 4; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        scan_stop = 0;
        $display("[%0t] Scan stop released", $time);
        for (cycle_count = 0; cycle_count < 4; cycle_count++) begin
            @(posedge clk);
            display_scan_state();
            display_key_detection();
            #(CLK_PERIOD/4);
        end
        
        $display("\n==========================================");
        $display("SCANNER TEST COMPLETE");
        $display("==========================================");
        $finish;
    end
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    initial begin
        $monitor("[%0t] CLK=%b RST=%b ROW=%b COL=%b ROW_IDX=%b COL_SYNC=%b KEY_DET=%b SCAN_STOP=%b", 
                 $time, clk, rst_n, row, col, row_idx, col_sync, key_detected, scan_stop);
    end
    
    // ========================================================================
    // WAVEFORM DUMP
    // ========================================================================
    initial begin
        $dumpfile("tb_scanner_debug.vcd");
        $dumpvars(0, tb_scanner_debug);
    end

endmodule
