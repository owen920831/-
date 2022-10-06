`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, rd);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [4-1:0] rd;
wire [3:0] sub, add, bit_or, bit_and, rshift, lshift, cmp_lt, cmp_eq;

SUB s1(rs, rt, sub);
ADD a1(rs, rt, add);
BIT_OR b1(rs, rt, bit_or);
BIT_AND b2(rs, rt, bit_and);
R_SHIFT r1(rs, rt, rshift);
L_SHIFT l1(rs, rt, lshift);
CMP_LT c1(rs, rt, cmp_lt);
CMP_EQ c2(rs, rt, cmp_eq);
Mux_8x1 m0(sub[0], add[0], bit_or[0], bit_and[0], rshift[0], lshift[0], cmp_lt[0], cmp_eq[0], sel, rd[0]);
Mux_8x1 m1(sub[1], add[1], bit_or[1], bit_and[1], rshift[1], lshift[1], cmp_lt[1], cmp_eq[1], sel, rd[1]);
Mux_8x1 m2(sub[2], add[2], bit_or[2], bit_and[2], rshift[2], lshift[2], cmp_lt[2], cmp_eq[2], sel, rd[2]);
Mux_8x1 m3(sub[3], add[3], bit_or[3], bit_and[3], rshift[3], lshift[3], cmp_lt[3], cmp_eq[3], sel, rd[3]);
endmodule

module NOT (
    a, out
);
    input a;
    output out;

    Universal_Gate u1(1'b1, a, out);    
endmodule

module AND (
    a, b, out
);
    input a, b;
    output out;
    wire _b;

    NOT n1(b, _b);
    Universal_Gate u1(a, _b, out);
endmodule

module NAND (
    a, b, out
);
    input a, b;
    output out;

    wire w1;

    AND a1(a, b, w1);
    NOT n1(w1, out);
endmodule

module OR(a, b, out);
    input a, b;
    output out;
    wire _a, _b;
    NOT n1(a, _a);
    NOT n2(b, _b);
    NAND n3(_a, _b, out);
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
    NAND n1(a, b, nand_ab);
    NAND n2(nand_ab, a, nand_aba);
    NAND n3(nand_ab, b, nand_abb);
    NAND n4(nand_aba, nand_abb, out);
endmodule

module XNOR(a, b, out);
    input a, b;
    output out;
    wire xor_ab;
    XOR x1(a, b, xor_ab);
    NOT n1(xor_ab, out);
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

module Majority(a, b, c, out);
    input a, b, c;
    output out;
    wire w1, w2, w3, w4;
    AND a1(a, b, w1);
    AND a2(b, c, w4);
    AND a3(a, c, w2);
    OR o1(w1, w2, w3);
    OR o2(w3, w4, out);
endmodule

module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    wire xor_ab;
    Majority m1(a, b, cin, cout);
    XOR x1(a, b, xor_ab);
    XOR x2(cin, xor_ab, sum);
endmodule

module ADD (
    a, b, out
);
    input [3:0] a, b;
    output [3:0] out;
    wire c1, c2, c3, no_use;

    Full_Adder f0(a[0], b[0], 1'b0, c1, out[0]);
    Full_Adder f1(a[1], b[1], c1, c2, out[1]);
    Full_Adder f2(a[2], b[2], c2, c3, out[2]);
    Full_Adder f3(a[3], b[3], c3, no_use, out[3]);
endmodule

module SUB (
    a, b, out
);
    input [3:0] a, b;
    output [3:0] out;
    wire [3:0] _b, __b;

    XOR x0(1, b[0], _b[0]);
    XOR x1(1, b[1], _b[1]);
    XOR x2(1, b[2], _b[2]);
    XOR x3(1, b[3], _b[3]);
    ADD a1(_b, 4'b0001, __b);
    ADD a2(a, __b, out);
endmodule

module BIT_OR (
    a, b, out
);
    input [3:0] a, b;
    output [3:0] out;

    OR o0(a[0], b[0], out[0]);
    OR o1(a[1], b[1], out[1]);
    OR o2(a[2], b[2], out[2]);
    OR o3(a[3], b[3], out[3]);
endmodule

module BIT_AND (
    a, b, out
);
    input [3:0] a, b;
    output [3:0] out;

    AND a0(a[0], b[0], out[0]);
    AND a1(a[1], b[1], out[1]);
    AND a2(a[2], b[2], out[2]);
    AND a3(a[3], b[3], out[3]);
endmodule

module R_SHIFT (
    a, b, out
);
    input [3:0] a, b;
    output [3:0] out;

    XOR x0(0, b[1], out[0]);
    XOR x1(0, b[2], out[1]);
    XOR x2(0, b[3], out[2]);
    XOR x3(0, b[3], out[3]);
endmodule

module L_SHIFT (
    a, b, out
);
    input [3:0] a, b;
    output [3:0] out;

    XOR x0(0, b[3], out[0]);
    XOR x1(0, b[0], out[1]);
    XOR x2(0, b[1], out[2]);
    XOR x3(0, b[2], out[3]);
endmodule

module cmp_1bit (
    a, b, e, al, bl
);
    input a, b;
    output e, al, bl;
    wire _a, _b, and_ab, and__a_b;

    NOT n1(a, _a);
    NOT n2(b, _b);
    AND a1(a, b, and_ab);
    AND a2(_a, _b, and__a_b);
    OR o1(and_ab, and__a_b, e);
    AND a3(a, _b, al);
    AND a4(_a, b);
endmodule

module CMP_LT (
    a, b, out
);
    input [3:0] a, b;
    output [3:0] out;
    wire EQ, AL, e0, e1, e2, e3, al0, al1, al2, al3, bl0, bl1, bl2, bl3;
    wire _AL, _EQ;
    wire x, y;
    wire aa, bb, c, d, e, f, g, h;

    XOR x1(1'b0, 1'b1, out[3]);
    XOR x2(1'b0, 1'b0, out[2]);
    XOR x3(1'b0, 1'b1, out[1]);

    cmp_1bit cmp0(a[0], b[0], e0, al0, bl0);
    cmp_1bit cmp1(a[1], b[1], e1, al1, bl1);
    cmp_1bit cmp2(a[2], b[2], e2, al2, bl2);
    cmp_1bit cmp3(a[3], b[3], e3, al3, bl3);
    // CREATE EQ
    AND a1(e0, e1, x);
    AND a2(e2, e3, y);
    AND a3(x, y, EQ);

    // CREATE AL
    AND a4(al2, e3, aa); //aa
    AND a5(al1, e3, bb);
    AND a6(bb, e2, c); //c
    AND a7(al0, e3, d);
    AND a8(e1, e2, e);
    AND a9(d, e, f); //f
    OR o1(al3, aa, g);
    OR o2(c, f, h);
    OR o3(g, h, AL);

    // CREATE BL
    NOT n1(AL, _AL);
    NOT n2(EQ, _EQ);
    AND a10(_EQ, _AL, out[0]);

endmodule

module CMP_EQ (
    a, b, out
);
    input [3:0] a, b;
    output [3:0] out;
    wire e0, e1, e2, e3, al0, al1, al2, al3, bl0, bl1, bl2, bl3;
    wire x, y;
    XOR x1(1'b0, 1'b1, out[3]);
    XOR x2(1'b0, 1'b1, out[2]);
    XOR x3(1'b0, 1'b1, out[1]);

    cmp_1bit cmp0(a[0], b[0], e0, al0, bl0);
    cmp_1bit cmp1(a[1], b[1], e1, al1, bl1);
    cmp_1bit cmp2(a[2], b[2], e2, al2, bl2);
    cmp_1bit cmp3(a[3], b[3], e3, al3, bl3);
    AND a1(e0, e1, x);
    AND a2(e2, e3, y);
    AND a3(x, y, out[0]);

endmodule