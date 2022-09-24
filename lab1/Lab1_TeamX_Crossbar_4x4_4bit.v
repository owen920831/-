`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [3:0] in1, in2, in3, in4;
input [4:0] control;
output [3:0] out1, out2, out3, out4;
wire [3:0] a, b, c, d, e, f;

Crossbar_2x2_4bit C0(in1, in2, a, b, control[0]);
Crossbar_2x2_4bit C3(in3, in4, d, f, control[3]);
Crossbar_2x2_4bit C2(b, d, c, e, control[2]);
Crossbar_2x2_4bit C1(a, c, out1, out2, control[1]);
Crossbar_2x2_4bit C4(e, f, out3, out4, control[4]);

endmodule

module Crossbar_2x2_4bit(in1, in2, out1, out2, control);
input [3:0] in1, in2;
input control;
output [3:0] out1, out2;
wire _control;
wire [3:0] a, b, c, d;

not n0(_control, control);
Dmux_1x2_4bit D1(in1, control, a, b);
Dmux_1x2_4bit D2(in2, _control, c, d);
Mux_2x1_2bit D3(a, c, control, out1);
Mux_2x1_2bit D4(b, d, _control, out2);
endmodule

module Dmux_1x2_4bit(in, sel, X, Y);
input [3:0] in;
input sel;
output [3:0] X, Y;
wire _sel;

not n0(_sel, sel);

and a0(X[0], in[0], _sel);
and a1(X[1], in[1], _sel);
and a2(X[2], in[2], _sel);
and a3(X[3], in[3], _sel);

and b0(Y[0], in[0], sel);
and b1(Y[1], in[1], sel);
and b2(Y[2], in[2], sel);
and b3(Y[3], in[3], sel);
endmodule

module Mux_2x1_2bit(x, y, sel, o);
input [3:0] x, y;
input sel;
output [3:0] o;
wire _sel;
wire [3:0] X, Y;

not n0(_sel, sel);

and a0(X[0], x[0], _sel);
and a1(X[1], x[1], _sel);
and a2(X[2], x[2], _sel);
and a3(X[3], x[3], _sel);
and b0(Y[0], y[0], sel);
and b1(Y[1], y[1], sel);
and b2(Y[2], y[2], sel);
and b3(Y[3], y[3], sel);

or g0(o[0], X[0], Y[0]);
or g1(o[1], X[1], Y[1]);
or g2(o[2], X[2], Y[2]);
or g3(o[3], X[3], Y[3]);
endmodule
