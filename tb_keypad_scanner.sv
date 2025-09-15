`timescale 1ns/1ps

module tb_keypad_scanner;

    // Testbench signals
    logic        clk;
    logic        rst_n;
    logic [3:0]  row;
    logic [3:0]  col;
    logic [3:0]  row_idx;
    logic [3:0]  col_idx;
    logic        key_pressed;

    // Instantiate keypad scanner
    keypad_scanner dut (
        .clk(clk),
        .rst_n(rst_n),
        .row(row),
        .col(col),
        .row_idx(row_idx),
        .col_idx(col_idx),
        .key_pressed(key_pressed)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #166.67 clk = ~clk; // 3MHz clock
    end

    // Test sequence
    initial begin
        $display("=== Keypad Scanner Testbench ===");
        
        // Initialize
        rst_n = 0;
        col = 4'b1111; // No keys pressed
        #1000;
        
        // Release reset
        rst_n = 1;
        #100000; // Wait for system to stabilize
        
        $display("Time %0t: System initialized", $time);
        $display("  Initial: Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 row, col, row_idx, col_idx, key_pressed);
        
        // Test 1: Monitor row scanning
        $display("\nTest 1: Monitoring row scanning for 2ms");
        repeat(6000) begin // 2ms at 3MHz
            @(posedge clk);
            if ($time % 100000 == 0) begin // Print every 100us
                $display("Time %0t: Rows=%b, RowIdx=%b", $time, row, row_idx);
            end
        end
        
        // Test 2: Single key press on row 0, col 0 (key '1')
        $display("\nTest 2: Single key press - key '1' (row 0, col 0)");
        wait(row == 4'b1110); // Wait for row 0 to be active
        #1000; // Small delay
        col = 4'b1110; // Column 0 goes low
        $display("Time %0t: Key '1' pressed - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Hold for 1ms
        #1000000;
        $display("Time %0t: After holding - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Release key
        col = 4'b1111;
        $display("Time %0t: Key '1' released", $time);
        #100000;
        
        // Test 3: Single key press on row 0, col 1 (key '2')
        $display("\nTest 3: Single key press - key '2' (row 0, col 1)");
        wait(row == 4'b1110); // Wait for row 0 to be active
        #1000; // Small delay
        col = 4'b1101; // Column 1 goes low
        $display("Time %0t: Key '2' pressed - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Hold for 1ms
        #1000000;
        $display("Time %0t: After holding - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Release key
        col = 4'b1111;
        $display("Time %0t: Key '2' released", $time);
        #100000;
        
        // Test 4: Single key press on row 1, col 1 (key '5')
        $display("\nTest 4: Single key press - key '5' (row 1, col 1)");
        wait(row == 4'b1101); // Wait for row 1 to be active
        #1000; // Small delay
        col = 4'b1101; // Column 1 goes low
        $display("Time %0t: Key '5' pressed - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Hold for 1ms
        #1000000;
        $display("Time %0t: After holding - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Release key
        col = 4'b1111;
        $display("Time %0t: Key '5' released", $time);
        #100000;
        
        // Test 5: Ghosting protection - multiple keys pressed
        $display("\nTest 5: Ghosting protection - multiple keys pressed");
        wait(row == 4'b1110); // Wait for row 0 to be active
        #1000; // Small delay
        col = 4'b1100; // Columns 0 and 1 low (ghosting)
        $display("Time %0t: Multiple keys pressed - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Hold for 1ms
        #1000000;
        $display("Time %0t: After holding multiple keys - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Release keys
        col = 4'b1111;
        $display("Time %0t: Multiple keys released", $time);
        #100000;
        
        // Test 6: All columns low (invalid state)
        $display("\nTest 6: All columns low (invalid state)");
        wait(row == 4'b1110); // Wait for row 0 to be active
        #1000; // Small delay
        col = 4'b0000; // All columns low
        $display("Time %0t: All columns low - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Hold for 1ms
        #1000000;
        $display("Time %0t: After holding all columns - Rows=%b, Cols=%b, RowIdx=%b, ColIdx=%b, KeyPressed=%b", 
                 $time, row, col, row_idx, col_idx, key_pressed);
        
        // Release keys
        col = 4'b1111;
        $display("Time %0t: All columns released", $time);
        #100000;
        
        $display("\n=== Keypad Scanner Testbench Complete ===");
        $finish;
    end

    // Monitor for row transitions
    logic [3:0] prev_row;
    initial begin
        prev_row = 4'b1111;
        forever begin
            @(posedge clk);
            if (row != prev_row) begin
                $display("Time %0t: Row transition from %b to %b", $time, prev_row, row);
                prev_row = row;
            end
        end
    end

endmodule
