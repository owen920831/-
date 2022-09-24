`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
    input [4-1:0] in1, in2, in3, in4;
    input [5-1:0] control;
    output [4-1:0] out1, out2, out3, out4;
    wire [3:0] crossbar_0_0, crossbar_0_1, crossbar_2_0, crossbar_2_1, crossbar_3_0, crossbar_3_1;

    Crossbar_2x2_4bit crossbar_0(in1, in2, control[0], crossbar_0_0, crossbar_0_1);
    Crossbar_2x2_4bit crossbar_3(in3, in4, control[3], crossbar_3_1, crossbar_3_1);

    Crossbar_2x2_4bit crossbar_2(crossbar_0_1, crossbar_3_0, control[2], crossbar_2_0, crossbar_2_1);

    Crossbar_2x2_4bit crossbar_1(crossbar_0_0, crossbar_2_0, control[1], out1, out2);
    Crossbar_2x2_4bit crossbar_4(crossbar_2_1, crossbar_3_1, control[4], out3, out4);
endmodule
