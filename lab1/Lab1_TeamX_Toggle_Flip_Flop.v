`timescale 1ns/1ps

module Xor(in1, in2, out);
    input in1, in2;
    output out;
    wire _in1, _in2, w1, w2;

    not n1(_in1, in1), n2(_in2, in2);
    and a1(w1, _in1, in2), a2(w2, _in2, in1);
    or o1(out, w1, w2);
endmodule 

module Toggle_Flip_Flop(clk, q, t, rst_n);
    input clk;
    input t;
    input rst_n;
    output q;
    wire _q, xor1, and1;

    not n1(_q, q);
    Xor x1(t, _q, xor1);
    and a1(and1, xor1, rst_n);
    D_Flip_Flop d1(clk, and1, q);
endmodule