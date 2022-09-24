`timescale 1ns/1ps

module Mux_4x1_4bit(a, b, c, d, sel, f);
input [3:0] a, b, c, d;
input [1:0] sel;
output [3:0] f;
wire [3:0] x, y;

Mux_2x1_4bit M0(a, b, sel[0], x);
Mux_2x1_4bit M1(c, d, sel[0], y);
Mux_2x1_4bit M2(x, y, sel[1], f);

endmodule

module Mux_2x1_4bit(a, b, sel, o);
input [3:0] a, b;
input sel;
output [3:0] o;
wire _sel;
wire [3:0] A, B;

not n0(_sel, sel);

and a0(A[0], a[0], _sel);
and a1(A[1], a[1], _sel);
and a2(A[2], a[2], _sel);
and a3(A[3], a[3], _sel);
and b0(B[0], b[0], sel);
and b1(B[1], b[1], sel);
and b2(B[2], b[2], sel);
and b3(B[3], b[3], sel);

or g0(o[0], A[0], B[0]);
or g1(o[1], A[1], B[1]);
or g2(o[2], A[2], B[2]);
or g3(o[3], A[3], B[3]);

endmodule