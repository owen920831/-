`timescale 1ns/1ps
module AND(a, b, out);
    input a, b;
    output out;
    wire ab;
    nand n1(ab, a, b);
    nand n2(out, ab, ab);
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

module OR(a, b, out);
    input a, b;
    output out;
    wire _a, _b;
    NOT n1(a, _a);
    NOT n2(b, _b);
    nand n3(out, _a, _b);
endmodule

module NOT(a, out);
    input a;
    output out;
    nand n1(out, a, a);
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

module Half_Adder(a, b, cout, sum);
    input a, b;
    output cout, sum;
    AND a1(a, b, cout);
    XOR x1(a, b, sum);
endmodule

module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    wire xor_ab;
    Majority m1(a, b, cin, cout);
    XOR x1(a, b, xor_ab);
    XOR x2(cin, xor_ab, sum);
endmodule

module Carry_Look_Ahead_Adder_4bit(a, b, cin, sum, cout, pg);
    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output cout;
    output [1:0] pg;

    wire [3:0] p, g, c, g_pc, pc, unused_c, k;
    wire [5:0] gi_i3;
    //gi
    AND g0(a[0], b[0], g[0]);
    AND g1(a[1], b[1], g[1]);
    AND g2(a[2], b[2], g[2]);
    AND g3(a[3], b[3], g[3]);
    //pi
    OR p0(a[0], b[0], p[0]);
    OR p1(a[1], b[1], p[1]);
    OR p2(a[2], b[2], p[2]);
    OR p3(a[3], b[3], p[3]);
    //ci
    AND p0_cin(p[0], cin, pc[0]);
    OR g0_p0cin(pc[0], g[0], c[0]); //c0

    AND p1_c0(p[1], c[0], pc[1]);
    OR g1_p1c0(pc[1], g[1], c[1]); //c1

    AND p2_c1(p[2], c[1], pc[2]);
    OR g2_p2c1(pc[2], g[2], c[2]); //c2

    AND p3_c2(p[3], c[2], pc[3]);
    OR g3_p3c2(pc[3], g[3], c[3]); //c3

    AND p1g(p[1], g[0], gi_i3[0]);
    OR g1p1(g[1], gi_i3[0], gi_i3[1]);
    AND p2g(p[2], gi_i3[1], gi_i3[2]);
    OR g2p(g[2], gi_i3[2], gi_i3[3]);
    AND p3g(p[3], gi_i3[3], gi_i3[4]);
    OR g3p(g[3], gi_i3[4], pg[0]); //g[3:0] = pg[0]

    AND a1(p[0], p[1], k[0]);
    AND a2(p[2], p[3], k[1]);
    AND a3(k[0], k[1], pg[1]); //p[3:0] = pg[1]

    Full_Adder f0(a[0], b[0], cin, unused_c[0], sum[0]);
    Full_Adder f1(a[1], b[1], c[0], unused_c[1], sum[1]);
    Full_Adder f2(a[2], b[2], c[1], unused_c[2], sum[2]);
    Full_Adder f3(a[3], b[3], c[2], cout, sum[3]);
endmodule

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
    input [8-1:0] a, b;
    input c0;
    output [8-1:0] s;
    output c8;

    wire c0_3, c4_7, c4;
    wire [1:0] pg_03, pg_47;
    wire p03c0, p47c4;

    Carry_Look_Ahead_Adder_4bit zero_to_three(a[3:0], b[3:0], c0, s[3:0], c0_3, pg_03);

    AND p03_c0(pg_03[1], c0, p03c0);
    OR g1(p03c0, pg_03[0], c4); //c4

    AND p47_c4(pg_47[1], c4, p47c4);
    OR g2(p47c4, pg_47[0], c8); //c8

    Carry_Look_Ahead_Adder_4bit four_to_seven(a[7:4], b[7:4], c4, s[7:4], c4_7, pg_47);
endmodule
