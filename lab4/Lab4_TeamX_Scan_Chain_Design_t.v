`timescale 1ns / 1ps

module Scan_Chain_Design_t();
    reg clk, rst_n, scan_en, scan_in;
    wire scan_out;

    Scan_Chain_Design m0 (
        .clk(clk),
        .rst_n(rst_n),
        .scan_en(scan_en),
        .scan_in(scan_in),
        .scan_out(scan_out)
    );

    always #10 clk = ~clk;

    reg [3:0] a = 4'b1011;
    reg [3:0] b = 4'b0111;
    reg [3:0] c = 4'b1001;
    reg [3:0] d = 4'b1101;

    initial begin
        clk = 0; rst_n = 0; scan_in = 0; scan_en = 0;
        #20 rst_n = 1; scan_en = 1; scan_in = a[0];
        #20 scan_in = a[1];
        #20 scan_in = a[2];
        #20 scan_in = a[3];
        #20 scan_in = b[0];
        #20 scan_in = b[1];
        #20 scan_in = b[2];
        #20 scan_in = b[3];
        #20 scan_en = 0;
        #20 scan_en = 1;
        #160
        rst_n = 0; scan_in = 0; scan_en = 0;
        #20 rst_n = 1; scan_en = 1; scan_in = c[0];
        #20 scan_in = c[1];
        #20 scan_in = c[2];
        #20 scan_in = c[3];
        #20 scan_in = d[0];
        #20 scan_in = d[1];
        #20 scan_in = d[2];
        #20 scan_in = d[3];
        #20 scan_en = 0;
        #20 scan_en = 1;
        #160 $finish;
    end
endmodule