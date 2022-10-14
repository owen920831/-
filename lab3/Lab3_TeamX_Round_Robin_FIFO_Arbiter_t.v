`timescale 1ns/1ps

module Round_Robin_FIFO_Arbiter_t;

    reg clk = 0;
    reg rst_n = 0;
    reg [4-1:0] wen = 4'b0000;
    reg [8-1:0] a = 0, b = 0, c = 0, d = 0;
    wire [8-1:0] dout;
    wire valid;

    wire [8-1:0] not_found;

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
        a = 8'd87;
        b = 8'd56;
        c = 8'd9;
        d = 8'd12;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b1000;
        a = not_found;
        b = not_found;
        c = not_found;
        d = 8'd85;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0100;
        a = not_found;
        b = not_found;
        c = 8'd139;
        d = not_found;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = not_found;
        b = not_found;
        c = not_found;
        d = not_found;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = not_found;
        b = not_found;
        c = not_found;
        d = not_found;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = not_found;
        b = not_found;
        c = not_found;
        d = not_found;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0001;
        a = 8'd51;
        b = not_found;
        c = not_found;
        c = not_found;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = not_found;
        b = not_found;
        c = not_found;
        d = not_found;
        @(negedge clk)
        rst_n = 1;
        wen = 4'b0000;
        a = not_found;
        b = not_found;
        c = not_found;
        d = not_found;
        @(negedge clk)
        $finish;
    end
endmodule
