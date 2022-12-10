`timescale 1ns/1ps

module Greatest_Common_Divisor_t;
    reg start = 0;
    reg [15:0] a = 0, b = 0;
    reg clk = 0;
    reg rst_n = 0;
    wire [15:0] gcd;
    wire done;
    wire [1:0] state;

    parameter cyc = 4;
    always # (cyc/2) clk = ~clk;

    Greatest_Common_Divisor G1(
        .start(start),
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .gcd(gcd),
        .done(done),
        .state(state)
    );
    
    initial begin
        #4 rst_n = 0;
        #8 rst_n = 1;
        #4 start = 1;
        a = 108;
        b = 36;
        #4 
        a = 0;
        b = 0;
        #24
        a = 16;
        b = 16;
        #8
        a = 12;
        b = 16;

    end
endmodule