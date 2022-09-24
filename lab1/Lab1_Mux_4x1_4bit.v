`timescale 1ns / 1ps

module Mux_2x1_4bit(a, b, sel, f);
    input a, b, sel;
    output f;
    wire w1, w2;
    wire _sel;
    not g1(_sel, sel);
    and g2 (w1, _sel, a);
    and g3 (w2, sel, b);
    or g4 (f, w1, w2);

endmodule

module Mux_4x1_4bit(a, b, c, d, sel, f);
    input [4-1:0] a, b, c, d;
    input [2-1:0] sel;
    output [4-1:0] f;
    wire [3:0] w1, w2;
    Mux_2x1_4bit g11(a[3], c[3], sel[1], w1[3]);
    Mux_2x1_4bit g22(b[3], d[3], sel[1], w2[3]);
    Mux_2x1_4bit g33(w1[3], w2[3], sel[0], f[3]);
    
    Mux_2x1_4bit g1(a[2], c[2], sel[1], w1[2]);
    Mux_2x1_4bit g2(b[2], d[2], sel[1], w2[2]);
    Mux_2x1_4bit g3(w1[2], w2[2], sel[0], f[2]);
    
    Mux_2x1_4bit g4(a[1], c[1], sel[1], w1[1]);
    Mux_2x1_4bit g5(b[1], d[1], sel[1], w2[1]);
    Mux_2x1_4bit g6(w1[1], w2[1], sel[0], f[1]);
    
    Mux_2x1_4bit g7(a[0], c[0], sel[1], w1[0]);
    Mux_2x1_4bit g8(b[0], d[0], sel[1], w2[0]);
    Mux_2x1_4bit g9(w1[0], w2[0], sel[0], f[0]);
endmodule
