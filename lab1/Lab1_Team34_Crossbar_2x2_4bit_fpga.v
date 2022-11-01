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

module Crossbar_2x2_4bit(in1, in2, control, out1, out2, out3, out4);
    input [4-1:0] in1, in2;
    input control;
    output [4-1:0] out1, out2, out3, out4;
    wire [3:0] in1_0, in1_1, in2_0, in2_1;
    wire _control;

    not n1(_control, control);
    Dmux_1x2_4bit in1_Dmux(in1, in1_0, in1_1, control);
    Dmux_1x2_4bit in2_Dmux(in2, in2_0, in2_1, _control);
    Mux_2x1_4bit out1_mux(in1_0, in2_0, control, out1);
    Mux_2x1_4bit out2_mux(in1_1, in2_1, _control, out2);
    Mux_2x1_4bit out3_mux(in1_0, in2_0, control, out3);
    Mux_2x1_4bit out4_mux(in1_1, in2_1, _control, out4);
endmodule
