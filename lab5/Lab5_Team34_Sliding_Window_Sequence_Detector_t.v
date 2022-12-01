`timescale 1ns/1ps

module q1_t;
    
    reg clk = 0;
    reg rst_n = 0;
    reg in = 0;
    wire dec;

    parameter cyc = 10;
    always # (cyc / 2) clk = ~clk;

    Sliding_Window_Sequence_Detector S1(
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .dec(dec)
    );

    initial begin
        $dumpfile("sliding_window.vcd");
        $dumpvars("+all");
    end

    initial begin
        @(negedge clk) 
        rst_n = 0;
        in = 0;
        @(negedge clk) 
        rst_n = 1;
        in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) 
        rst_n = 0;
        in = 0;
        @(negedge clk)
        rst_n = 1;
        in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1; //dec = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1; //dec = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk);
        $finish;
    end

endmodule
