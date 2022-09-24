`timescale 1ns/1ps

module Crossbar_4x4_4bit_t;
    reg [3:0] in1 = 4'b0000;
    reg [3:0] in2 = 4'b0010;
    reg [3:0] in3 = 4'b0100;
    reg [3:0] in4 = 4'b1000;
    reg [4:0] control = 5'b00000;
    wire [3:0] out1, out2, out3, out4;

    Crossbar_4x4_4bit c1(in1, in2, in3, in4, out1, out2, out3, out4, control);

    // uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
    // initial begin
    //      $fsdbDumpfile("MUX.fsdb");
    //      $fsdbDumpvars;
    // end

    initial begin
        repeat (2 ** 5) begin
            #1control = control + 5'b1;
        end
        #1 $finish;
    end
endmodule
