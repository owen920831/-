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

