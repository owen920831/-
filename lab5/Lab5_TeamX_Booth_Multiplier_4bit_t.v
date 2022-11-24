`timescale 1ns/1ps

module Booth_Multiplier_4bit_t;
    reg start = 0;
    reg clk = 0;
    reg rst_n = 0;
    reg [3:0] a = 0, b = 0;
    wire [7:0] p;

    Booth_Multiplier_4bit b1(
        .a(a),
        .b(b),
        .start(start),
        .clk(clk),
        .p(p),
        .rst_n(rst_n)
    );

    parameter cyc = 4;
    always # (cyc/2) clk = ~clk;

    initial begin
        #4 rst_n = 0;
        #8 rst_n = 1;
        #4 start = 1;
        a = -8;
        b = 2;
        #4 start = 0;
        a = 0;
        b = 0;
        #40
        #4 start = 1;
        a = 5;
        b = -3;
        #4 start = 0;
        a = 0;
        b = 0;
        #40
        #4 start = 1;
        a = -5;
        b = -3;
        #4 start = 0;
        a = 0;
        b = 0;

    end

endmodule