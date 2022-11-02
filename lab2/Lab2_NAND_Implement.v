`timescale 1ns/1ps
module OR(a, b, out);
    input a, b;
    output out;
    wire _a, _b;
    NOT n1(a, _a);
    NOT n2(b, _b);
    nand n3(out, _a, _b);
endmodule

module AND(a, b, out);
    input a, b;
    output out;
    wire ab;
    nand n1(ab, a, b);
    nand n2(out, ab, ab);
endmodule

module NOR(a, b, out);
    input a, b;
    output out;
    wire or_ab;
    OR o1(a, b, or_ab);
    NOT n1(or_ab, out);
endmodule

module XOR(a, b, out);
    input a, b;
    output out;
    wire nand_ab, nand_aba, nand_abb;
    nand n1(nand_ab, a, b);
    nand n2(nand_aba, nand_ab, a);
    nand n3(nand_abb, nand_ab, b);
    nand n4(out, nand_aba, nand_abb);
endmodule

module XNOR(a, b, out);
    input a, b;
    output out;
    wire xor_ab;
    XOR x1(a, b, xor_ab);
    NOT n1(xor_ab, out);
endmodule

module NOT(a, out);
    input a;
    output out;
    nand n1(out, a, a);
endmodule

module Mux_8x1(a, b, c, d, e, f, g, h, sel, out);
    input a, b, c, d, e, f, g, h;
    input [2:0] sel;
    output out;
    wire x, y;

    Mux_4x1 M0(a, b, c, d, sel, x);
    Mux_4x1 M1(e, f, g, h, sel, y);
    Mux_2x1 M2(x, y, sel[2], out);
endmodule

module Mux_4x1(a, b, c, d, sel, f);
    input a, b, c, d;
    input [2:0] sel;
    output f;
    wire x, y;

    Mux_2x1 M0(a, b, sel[0], x);
    Mux_2x1 M1(c, d, sel[0], y);
    Mux_2x1 M2(x, y, sel[1], f);
endmodule

module Mux_2x1(a, b, sel, o);
    input a, b, sel;
    output o;
    wire _sel, A, B;

    NOT n0(sel, _sel);
    AND a0(a, _sel, A);
    AND b0(b, sel, B);
    OR g0(A, B, o);
endmodule

module NAND_Implement (a, b, sel, out);
    input a, b;
    input [3-1:0] sel;
    output out;
    wire ab_or, ab_and, ab_xor, _a, ab_xnor, ab_nor, ab_nand;

    OR o1(a, b, ab_or);
    AND a1(a, b, ab_and);
    XOR x1(a, b, ab_xor);
    NOT n1(a, _a);
    XNOR x2(a, b, ab_xnor);
    NOR n2(a, b, ab_nor);
    nand n3(ab_nand, a, b);
    Mux_8x1 m1(ab_nand, ab_and, ab_or, ab_nor, ab_xor, ab_xnor, _a, _a, sel, out);
endmodule
