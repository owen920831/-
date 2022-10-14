`timescale 1ns/1ps

module Round_Robin_FIFO_Arbiter_t;
    
    reg clk = 0;
    reg rst_n = 0;
    reg [4-1:0] wen = 4'b1111;
    reg [7:0] a, b, c, d;
    wire [7:0] dout;
    wire vaild;

    parameter cyc = 10;

    // generate clock.
    always#(cyc/2)clk = !clk;

    Round_Robin_FIFO_Arbiter rrfa(
        .clk (clk),
        .wen (wen),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .dout(dout),
        .valid(valid),
        .rst_n(rst_n)
    );

    initial begin
        @(negedge clk)
        rst_n = 0;
        wen = 4'b1111;
        a = 1;
        b = 2;
        c = 3;
        d = 4;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b1000;
        a = 0;
        b = 0;
        c = 0;
        d = 85;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b0100;
        a = 0;
        b = 0;
        c = 139;
        d = 0;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b0000;
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        @(negedge clk)
        rst_n = 0;
         wen = 4'b0000;
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b0000;
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b0001;
        a = 51;
        b = 0;
        c = 0;
        d = 0;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b0000;
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b0000;
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b0000;
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        @(negedge clk)
        rst_n = 0;
        wen = 4'b0000;
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        $finish;
    end
endmodule
