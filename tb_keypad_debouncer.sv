`timescale 1ns/1ps

module tb_keypad_debouncer;

    // Testbench signals
    logic        clk;
    logic        rst_n;
    logic        key_pressed;
    logic [3:0]  row_idx;
    logic [3:0]  col_idx;
    logic        key_valid;
    logic [3:0]  key_row;
    logic [3:0]  key_col;

    // Instantiate keypad debouncer
    keypad_debouncer dut (
        .clk(clk),
        .rst_n(rst_n),
        .key_pressed(key_pressed),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_valid(key_valid),
        .key_row(key_row),
        .key_col(key_col)
    );

    // Function to show debouncer status based on outputs only
    function string debouncer_status(input valid);
        if (valid) 
            debouncer_status = "VALID";
        else
            debouncer_status = "DEBOUNCING";
    endfunction

    // Clock generation
    initial begin
        clk = 0;
        forever #166.67 clk = ~clk; // 3MHz clock
    end

    // Test sequence
    initial begin
        $display("=== Keypad Debouncer Testbench ===");
        
        // Initialize
        rst_n = 0;
        key_pressed = 0;
        row_idx = 4'b0000;
        col_idx = 4'b0000;
        #1000;
        
        // Release reset
        rst_n = 1;
        #1000;
        
        $display("Time %0t: System initialized", $time);
        $display("  Initial: KeyPressed=%b, RowIdx=%b, ColIdx=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                 key_pressed, row_idx, col_idx, key_valid, key_row, key_col);
        $display("  Initial Status: %s", debouncer_status(key_valid));
        
        // Test 1: Valid key press - key '1' (row 0, col 0)
        $display("\nTest 1: Valid key press - key '1' (row 0, col 0)");
        key_pressed = 1;
        row_idx = 4'b0001; // Row 0
        col_idx = 4'b0001; // Column 0
        $display("Time %0t: Key '1' pressed - KeyPressed=%b, RowIdx=%b, ColIdx=%b", 
                 $time, key_pressed, row_idx, col_idx);
        
        // Wait for state transition and check internal state
        @(posedge clk);
        $display("Time %0t: After 1 clock - Status: %s", 
                 $time, debouncer_status(key_valid));
        
        // Monitor debouncing process
        repeat(1000) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, Status: %s", 
                         $time, key_pressed, key_valid, key_row, key_col, debouncer_status(key_valid));
            end
        end
        
        $display("Time %0t: After 100ms - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, Status: %s", 
                 $time, key_pressed, key_valid, key_row, key_col, debouncer_status(key_valid));
        
        // Hold key for another 100ms
        repeat(1000) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, Status: %s", 
                         $time, key_pressed, key_valid, key_row, key_col, debouncer_status(key_valid));
            end
        end
        
        $display("Time %0t: After 200ms total - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, Status: %s", 
                 $time, key_pressed, key_valid, key_row, key_col, debouncer_status(key_valid));
        
        // Release key
        key_pressed = 0;
        $display("Time %0t: Key '1' released", $time);
        
        // Monitor release
        repeat(500) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                         $time, key_pressed, key_valid, key_row, key_col);
            end
        end
        
        $display("Time %0t: After release - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                 $time, key_pressed, key_valid, key_row, key_col);
        
        #100000; // Wait 100us
        
        // Test 2: Valid key press - key '2' (row 0, col 1)
        $display("\nTest 2: Valid key press - key '2' (row 0, col 1)");
        key_pressed = 1;
        row_idx = 4'b0001; // Row 0
        col_idx = 4'b0010; // Column 1
        $display("Time %0t: Key '2' pressed - KeyPressed=%b, RowIdx=%b, ColIdx=%b", 
                 $time, key_pressed, row_idx, col_idx);
        
        // Wait for state transition and check internal state
        @(posedge clk);
        $display("Time %0t: After 1 clock - Status: %s", 
                 $time, debouncer_status(key_valid));
        
        // Monitor debouncing process
        repeat(1000) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, Status: %s", 
                         $time, key_pressed, key_valid, key_row, key_col, debouncer_status(key_valid));
            end
        end
        
        $display("Time %0t: After 100ms - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, Status: %s", 
                 $time, key_pressed, key_valid, key_row, key_col, debouncer_status(key_valid));
        
        // Release key
        key_pressed = 0;
        $display("Time %0t: Key '2' released", $time);
        
        // Monitor release
        repeat(500) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                         $time, key_pressed, key_valid, key_row, key_col);
            end
        end
        
        $display("Time %0t: After release - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                 $time, key_pressed, key_valid, key_row, key_col);
        
        #100000; // Wait 100us
        
        // Test 3: Invalid key press (row/col = 0)
        $display("\nTest 3: Invalid key press (row/col = 0)");
        key_pressed = 1;
        row_idx = 4'b0000; // Invalid row
        col_idx = 4'b0000; // Invalid column
        $display("Time %0t: Invalid key pressed - KeyPressed=%b, RowIdx=%b, ColIdx=%b", 
                 $time, key_pressed, row_idx, col_idx);
        
        // Wait for state transition and check internal state
        @(posedge clk);
        $display("Time %0t: After 1 clock - Status: %s", 
                 $time, debouncer_status(key_valid));
        
        // Monitor for 50ms
        repeat(500) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, Status: %s", 
                         $time, key_pressed, key_valid, key_row, key_col, debouncer_status(key_valid));
            end
        end
        
        $display("Time %0t: After 50ms - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, State: %s, DebounceCnt: %0d", 
                 $time, key_pressed, key_valid, key_row, key_col, dut.state, dut.debounce_cnt);
        
        // Release key
        key_pressed = 0;
        $display("Time %0t: Invalid key released", $time);
        #100000; // Wait 100us
        
        // Test 4: Key press with changing row/col (should abort)
        $display("\nTest 4: Key press with changing row/col (should abort)");
        key_pressed = 1;
        row_idx = 4'b0001; // Row 0
        col_idx = 4'b0001; // Column 0
        $display("Time %0t: Key '1' pressed - KeyPressed=%b, RowIdx=%b, ColIdx=%b", 
                 $time, key_pressed, row_idx, col_idx);
        
        // Wait for debouncing to start
        repeat(100) begin
            @(posedge clk);
        end
        
        // Change the key (simulate bouncing to different key)
        row_idx = 4'b0010; // Row 1
        col_idx = 4'b0010; // Column 1
        $display("Time %0t: Key changed to '5' - KeyPressed=%b, RowIdx=%b, ColIdx=%b", 
                 $time, key_pressed, row_idx, col_idx);
        
        // Monitor for 50ms
        repeat(500) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                         $time, key_pressed, key_valid, key_row, key_col);
            end
        end
        
        $display("Time %0t: After 50ms - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                 $time, key_pressed, key_valid, key_row, key_col);
        
        // Release key
        key_pressed = 0;
        $display("Time %0t: Key released", $time);
        #100000; // Wait 100us
        
        // Test 5: Short key press (should not debounce)
        $display("\nTest 5: Short key press (should not debounce)");
        key_pressed = 1;
        row_idx = 4'b0001; // Row 0
        col_idx = 4'b0001; // Column 0
        $display("Time %0t: Short key press - KeyPressed=%b, RowIdx=%b, ColIdx=%b", 
                 $time, key_pressed, row_idx, col_idx);
        
        // Hold for only 10ms (less than 20ms debounce time)
        repeat(100) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                         $time, key_pressed, key_valid, key_row, key_col);
            end
        end
        
        $display("Time %0t: After 10ms - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                 $time, key_pressed, key_valid, key_row, key_col);
        
        // Release key
        key_pressed = 0;
        $display("Time %0t: Short key released", $time);
        
        // Monitor release
        repeat(200) begin
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                         $time, key_pressed, key_valid, key_row, key_col);
            end
        end
        
        $display("Time %0t: After release - KeyPressed=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b", 
                 $time, key_pressed, key_valid, key_row, key_col);
        
        $display("\n=== Keypad Debouncer Testbench Complete ===");
        $finish;
    end

endmodule
