`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [8-1:0] a, b;
input cin;
output cout;
output [8-1:0] sum;
    
wire c1, c2, c3, c4, c5, c6, c7;

Full_Adder f0(a[0], b[0], cin, c1, sum[0]);
Full_Adder f1(a[1], b[1], c1, c2, sum[1]);
Full_Adder f2(a[2], b[2], c2, c3, sum[2]);
Full_Adder f3(a[3], b[3], c3, c4, sum[3]);
Full_Adder f4(a[4], b[4], c4, c5, sum[4]);
Full_Adder f5(a[5], b[5], c5, c6, sum[5]);
Full_Adder f6(a[6], b[6], c6, c7, sum[6]);
Full_Adder f7(a[7], b[7], c7, cout, sum[7]);
endmodule

/*-------------------------------------------------------*/
// below is the module that we have to refer to
module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    wire xor_ab;
    Majority m1(a, b, cin, cout);
    XOR x1(a, b, xor_ab);
    XOR x2(cin, xor_ab, sum);
endmodule

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
