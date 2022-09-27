`timescale 1ns/1ps

module Dmux_1x2_4bit(in, a, b, sel);
    input [4-1:0] in;
    input sel;
    output [4-1:0] a, b;
    wire _sel;

    not Not(_sel, sel);

    and g3a(a[3], in[3], _sel);
    and g3b(b[3], in[3], sel);

    and g2a(a[2], in[2], _sel);
    and g2b(b[2], in[2], sel);

    and g1a(a[1], in[1], _sel);
    and g1b(b[1], in[1], sel);

    and g0a(a[0], in[0], _sel);
    and g0b(b[0], in[0], sel);
endmodule

module Dmux_1x4_4bit(in, a, b, c, d, sel);
    input [4-1:0] in;
    input [2-1:0] sel;
    output [4-1:0] a, b, c, d;
    wire [3:0] ab, cd;

    Dmux_1x2_4bit ABCD(in, ab, cd, sel[1]);
    Dmux_1x2_4bit AB(in, a, b, sel[0]);
    Dmux_1x2_4bit CD(in, c, d, sel[0]);
endmodule
