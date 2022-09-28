`timescale 1ns/1ps

module Xor(in1, in2, out);
    input in1, in2;
    output out;
    wire _in1, _in2, w1, w2;

    not n1(_in1, in1), n2(_in2, in2);
    and a1(w1, _in1, in2), a2(w2, _in2, in1);
    or o1(out, w1, w2);
endmodule 

module D_Flip_Flop(clk, d, q);
    input clk;
    input d;
    output q;
    wire _clk, q1;

    not g1(_clk, clk);
    D_Latch d1(_clk, d, q1);
    D_Latch d2(clk, q1, q);
    endmodule

module D_Latch(e, d, q);
    input e;
    input d;
    output q;
    wire _d, w1, w2, _q;

    not g1(_d, d);
    nand g2(w1, d, e);
    nand g3(w2, _d, e);
    nand g4(q, w1, _q);
    nand g5(_q, q, w2);
endmodule


module Toggle_Flip_Flop(clk, q, t, rst_n);
    input clk;
    input t;
    input rst_n;
    output q;
    wire xor1, and1;

    Xor x1(t, q, xor1);
    and a1(and1, xor1, rst_n);
    D_Flip_Flop d1(clk, and1, q);
endmodule