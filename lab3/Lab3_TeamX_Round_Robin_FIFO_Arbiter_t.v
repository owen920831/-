`timescale 1ns/1ps

module Round_Robin_FIFO_Arbiter_t;

    reg clk = 0;
    reg rst_n = 0;
    reg [4-1:0] wen = 0;
    reg [8-1:0] a = 0, b = 0, c = 0, d = 0;
    wire [8-1:0] dout;
    wire valid;

    reg [8-1:0] x_error;

    parameter cyc = 10;

      // generate clock.
    always#(cyc/2)clk = !clk;

    Round_Robin_FIFO_Arbiter rrfa(
        .clk (clk),
        .rst_n (rst_n),
        .wen (wen),
        .a (a),
        .b (b),
        .c (c),
        .d (d),
        .dout (dout),
        .valid (valid)
    );

    initial begin
        @(negedge clk)
        rst_n = 1;
        wen = 4'b1111;
        a = 87;
        b = 56;
        c = 9;
        d = 13;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b1000;
        a = x_error;
        b = x_error;
        c = x_error;
        d = 85;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0100;
        a = x_error;
        b = x_error;
        c = 139;
        d = x_error;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = x_error;
        b = x_error;
        c = x_error;
        d = x_error;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = x_error;
        b = x_error;
        c = x_error;
        d = x_error;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = x_error;
        b = x_error;
        c = x_error;
        d = x_error;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0001;
        a = 51;
        b = x_error;
        c = x_error;
        c = x_error;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = x_error;
        b = x_error;
        c = x_error;
        d = x_error;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = x_error;
        b = x_error;
        c = x_error;
        d = x_error;
        @(negedge clk)
        $finish;
    end
endmodule
