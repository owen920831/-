`timescale 1ns/1ps

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
