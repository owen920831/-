`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
    input [4-1:0] in1, in2;
    input control;
    output [4-1:0] out1, out2;
    wire [3:0] in1_0, in1_1, in2_0, in2_1;
    wire _control;

    Dmux_1x2_4bit in1_Dmux(in1, in1_0, in1_1, control);
    Dmux_1x2_4bit in1_Dmux(in2, in2_0, in2_1, _control);
    Mux_2x1_4bit out1_mux(in1_0, in1_1, control, out1);
    Mux_2x1_4bit out1_mux(in2_0, in2_1, _control, out2);
endmodule
