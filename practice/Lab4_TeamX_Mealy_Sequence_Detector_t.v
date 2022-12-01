`timescale 1ns / 1ps

module Mealy_Sequence_Detector_t;
    reg clk, rst_n, in;
    wire dec;
    wire [3:0] state;

    Mealy_Sequence_Detector m(
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .dec(dec),
        .state(state)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        in = 0;
        #10 rst_n = 1'b1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
        #10 in = 0;
        $finish;
    end
endmodule