// ============================================================================
// LAB2_ES DISPLAY TEST BENCH - DEBUG VERSION
// ============================================================================
// Emmett Stralka estralka@hmc.edu
// 09/09/25
// Test bench for Lab2_ES display module with clear state debugging
// Shows seven-segment display behavior and multiplexing
// ============================================================================

`timescale 1ns/1ps

module tb_display_debug;

    // ========================================================================
    // PARAMETERS AND SIGNALS
    // ========================================================================
    parameter CLK_PERIOD = 333.33; // 3MHz clock (333.33ns period)
    
    // Clock and reset
    logic        clk;
    logic        reset;
    
    // Display inputs
    logic [3:0]  s0; // Left digit
    logic [3:0]  s1; // Right digit
    
    // Display outputs
    logic [6:0]  seg;     // Seven-segment display
    logic        select0; // Display 0 power control
    logic        select1; // Display 1 power control
    
    // Test control
    integer      test_count;
    integer      cycle_count;
    
    // ========================================================================
    // INSTANTIATE DUT
    // ========================================================================
    Lab2_ES dut (
        .clk(clk),
        .reset(reset),
        .s0(s0),
        .s1(s1),
        .seg(seg),
        .select0(select0),
        .select1(select1)
    );
    
    // ========================================================================
    // CLOCK GENERATION
    // ========================================================================
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // ========================================================================
    // DISPLAY TASKS
    // ========================================================================
    task display_seg_value;
        case (seg)
            7'b1000000: $display("[%0t] DISPLAY: Seg = 0 (0x%h)", $time, seg);
            7'b1111001: $display("[%0t] DISPLAY: Seg = 1 (0x%h)", $time, seg);
            7'b0100100: $display("[%0t] DISPLAY: Seg = 2 (0x%h)", $time, seg);
            7'b0110000: $display("[%0t] DISPLAY: Seg = 3 (0x%h)", $time, seg);
            7'b0011001: $display("[%0t] DISPLAY: Seg = 4 (0x%h)", $time, seg);
            7'b0010010: $display("[%0t] DISPLAY: Seg = 5 (0x%h)", $time, seg);
            7'b0000010: $display("[%0t] DISPLAY: Seg = 6 (0x%h)", $time, seg);
            7'b1111000: $display("[%0t] DISPLAY: Seg = 7 (0x%h)", $time, seg);
            7'b0000000: $display("[%0t] DISPLAY: Seg = 8 (0x%h)", $time, seg);
            7'b0010000: $display("[%0t] DISPLAY: Seg = 9 (0x%h)", $time, seg);
            7'b0001000: $display("[%0t] DISPLAY: Seg = A (0x%h)", $time, seg);
            7'b0000011: $display("[%0t] DISPLAY: Seg = b (0x%h)", $time, seg);
            7'b1000110: $display("[%0t] DISPLAY: Seg = C (0x%h)", $time, seg);
            7'b0100001: $display("[%0t] DISPLAY: Seg = d (0x%h)", $time, seg);
            7'b0000110: $display("[%0t] DISPLAY: Seg = E (0x%h)", $time, seg);
            7'b0001110: $display("[%0t] DISPLAY: Seg = F (0x%h)", $time, seg);
            default: $display("[%0t] DISPLAY: Seg = ? (0x%h)", $time, seg);
        endcase
    endtask
    
    task display_state;
        $display("[%0t] DISPLAY: S0=0x%h, S1=0x%h, Seg=0x%h, Sel0=%b, Sel1=%b", 
                 $time, s0, s1, seg, select0, select1);
    endtask
    
    // ========================================================================
    // TEST STIMULUS
    // ========================================================================
    initial begin
        $display("==========================================");
        $display("LAB2_ES DISPLAY DEBUG TEST BENCH");
        $display("==========================================");
        
        // Initialize signals
        reset = 1;
        s0 = 4'h0;
        s1 = 4'h0;
        test_count = 0;
        cycle_count = 0;
        
        // Reset sequence
        $display("\n[%0t] Applying reset...", $time);
        #(CLK_PERIOD * 2);
        reset = 0;
        #(CLK_PERIOD);
        
        $display("\n[%0t] Reset released. Starting display test...", $time);
        
        // Test 1: Display digit 0
        $display("\n--- TEST 1: Display Digit 0 ---");
        s0 = 4'h0;
        s1 = 4'h0;
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
            display_seg_value();
            #(CLK_PERIOD/4);
        end
        
        // Test 2: Display digit 1
        $display("\n--- TEST 2: Display Digit 1 ---");
        s0 = 4'h1;
        s1 = 4'h1;
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
            display_seg_value();
            #(CLK_PERIOD/4);
        end
        
        // Test 3: Display digit 5
        $display("\n--- TEST 3: Display Digit 5 ---");
        s0 = 4'h5;
        s1 = 4'h5;
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
            display_seg_value();
            #(CLK_PERIOD/4);
        end
        
        // Test 4: Display digit A
        $display("\n--- TEST 4: Display Digit A ---");
        s0 = 4'hA;
        s1 = 4'hA;
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
            display_seg_value();
            #(CLK_PERIOD/4);
        end
        
        // Test 5: Display digit F
        $display("\n--- TEST 5: Display Digit F ---");
        s0 = 4'hF;
        s1 = 4'hF;
        for (cycle_count = 0; cycle_count < 10; cycle_count++) begin
            @(posedge clk);
            display_state();
            display_seg_value();
            #(CLK_PERIOD/4);
        end
        
        // Test 6: Different left and right digits
        $display("\n--- TEST 6: Different Left and Right Digits ---");
        s0 = 4'h3; // Left digit = 3
        s1 = 4'h7; // Right digit = 7
        for (cycle_count = 0; cycle_count < 20; cycle_count++) begin
            @(posedge clk);
            display_state();
            display_seg_value();
            #(CLK_PERIOD/4);
        end
        
        // Test 7: All digits 0-9
        $display("\n--- TEST 7: All Digits 0-9 ---");
        for (test_count = 0; test_count < 10; test_count++) begin
            s0 = test_count[3:0];
            s1 = test_count[3:0];
            $display("[%0t] Testing digit %0d", $time, test_count);
            for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
                @(posedge clk);
                display_state();
                display_seg_value();
                #(CLK_PERIOD/4);
            end
        end
        
        // Test 8: All hex digits A-F
        $display("\n--- TEST 8: All Hex Digits A-F ---");
        for (test_count = 10; test_count < 16; test_count++) begin
            s0 = test_count[3:0];
            s1 = test_count[3:0];
            $display("[%0t] Testing digit %0h", $time, test_count[3:0]);
            for (cycle_count = 0; cycle_count < 5; cycle_count++) begin
                @(posedge clk);
                display_state();
                display_seg_value();
                #(CLK_PERIOD/4);
            end
        end
        
        // Test 9: Multiplexing test
        $display("\n--- TEST 9: Multiplexing Test ---");
        s0 = 4'h1; // Left digit = 1
        s1 = 4'h2; // Right digit = 2
        $display("[%0t] Left digit = 1, Right digit = 2", $time);
        for (cycle_count = 0; cycle_count < 30; cycle_count++) begin
            @(posedge clk);
            display_state();
            display_seg_value();
            #(CLK_PERIOD/4);
        end
        
        $display("\n==========================================");
        $display("DISPLAY TEST COMPLETE");
        $display("==========================================");
        $finish;
    end
    
    // ========================================================================
    // MONITORING
    // ========================================================================
    initial begin
        $monitor("[%0t] CLK=%b RST=%b S0=0x%h S1=0x%h SEG=0x%h SEL0=%b SEL1=%b", 
                 $time, clk, reset, s0, s1, seg, select0, select1);
    end
    
    // ========================================================================
    // WAVEFORM DUMP
    // ========================================================================
    initial begin
        $dumpfile("tb_display_debug.vcd");
        $dumpvars(0, tb_display_debug);
    end

endmodule
