`timescale 1ns/1ps

module Dmux_1x4_4bit_t;
    wire [3:0]a;
    wire [3:0]b;
    wire [3:0]c;
    wire [3:0]d;
    reg [1:0]sel = 2'b0;
    reg [3:0]in = 4'b1111;

    Dmux_1x4_4bit m1(
        .in (in),
        .a (a),
        .b (b),
        .c (c),
        .d (d),
        .sel (sel)
        
    );
    // uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
    // initial begin
    //      $fsdbDumpfile("MUX.fsdb");
    //      $fsdbDumpvars;
    // end

    initial begin
        repeat (8)begin
            #1 sel = sel + 2'b1;
        end
        #1 $finish;
    end
endmodule
