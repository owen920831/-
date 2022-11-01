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

module Multiplier_4bit(a, b, p);
    input [4-1:0] a, b;
    output [8-1:0] p;
    wire [3:0] b0a, b1a, b2a, b3a;
    wire [12:0] c;
    wire [6:0] s;

    AND b0a0(a[0], b[0], p[0]); //p[0]
    AND b0a1(a[1], b[0], b0a[1]);
    AND b0a2(a[2], b[0], b0a[2]);
    AND b0a3(a[3], b[0], b0a[3]);

    AND b1a0(a[0], b[1], b1a[0]);
    AND b1a1(a[1], b[1], b1a[1]);
    AND b1a2(a[2], b[1], b1a[2]);
    AND b1a3(a[3], b[1], b1a[3]);
    
    AND b2a0(a[0], b[2], b2a[0]);
    AND b2a1(a[1], b[2], b2a[1]);
    AND b2a2(a[2], b[2], b2a[2]);
    AND b2a3(a[3], b[2], b2a[3]);

    AND b3a0(a[0], b[3], b3a[0]);
    AND b3a1(a[1], b[3], b3a[1]);
    AND b3a2(a[2], b[3], b3a[2]);
    AND b3a3(a[3], b[3], b3a[3]);
    
    Half_Adder h1(b0a[1], b1a[0], c[1], p[1]); //p[1]

    Full_Adder f1(c[1], b0a[2], b1a[1], c[2], s[0]); //p[2]
    Half_Adder h2(s[0], b2a[0], c[3], p[2]); 

    Full_Adder f2(c[2], b0a[3], b1a[2], c[4], s[1]);
    Full_Adder f3(c[3], b2a[1], b3a[0], c[5], s[2]); //p[3]
    Half_Adder h3(s[1], s[2], c[6], p[3]); 

    Full_Adder f4(c[4], b1a[3], b2a[2], c[7], s[3]); //p[4]
    Full_Adder f5(c[5], b3a[1], c[6], c[8], s[4]);
    Half_Adder h4(s[3], s[4], c[9], p[4]); 

    Full_Adder f6(c[7], b2a[3], b3a[2], c[10], s[5]); //p[5]
    Full_Adder f7(c[8], c[9], s[5], c[11], p[5]);

    Full_Adder f8(c[10], c[11], b3a[3], p[7], p[6]); //p[6], p[7]

endmodule
