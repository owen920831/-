`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, rd);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [4-1:0] rd;

endmodule

module NOT (
    a, out
);
    input a;
    output out;

    Universal_Gate u1(1b'1, a, out);    
endmodule

module AND (
    a, b, out
);
    input a, b;
    output out;
    wire w1;

    Universal_Gate u1(1b'1, b, w1);
    Universal_Gate u2(a, w1, out);
endmodule

module NAND (
    a, b, out
);
    input a, b;
    output out;

    wire w1;

    AND(a, b, w1);
    Universal_Gate u1(1b'1, w1, out);
endmodule

module OR(a, b, out);
    input a, b;
    output out;
    wire _a, _b;
    NOT n1(a, _a);
    NOT n2(b, _b);
    nand n3(out, _a, _b);
endmodule

module NOR(a, b, out);
    input a, b;
    output out;
    wire or_ab;
    OR o1(a, b, or_ab);
    NOT n1(or_ab, out);
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

    Full_Adder f0(a[0], b[0], 1b'0, c1, out[0]);
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
    ADD a1(_b, 1b'0001, __b);
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
    XOR x3(0, b[0], out[3]);
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