`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
    input clk, rst_n;
    input in;
    output dec;

    reg dec;
    reg [1:0] cur_a, next_a;
    reg [1:0] cur_b, next_b;
    reg [1:0] cur_c, next_c;
    parameter a0 = 0, a1 = 1, a2 = 2, a3 = 3;
    parameter b0 = 0, b1 = 1, b2 = 2, b3 = 3;
    parameter c0 = 0, c1 = 1, c2 = 2, c3 = 3;

    always @(posedge clk) begin
        if (!rst_n) begin
            cur_a <= a0;
            cur_b <= b0;
            cur_c <= c0;
        end
        else begin
            cur_a <= next_a;
            cur_b <= next_b;
            cur_c <= next_c;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            dec <= 1'b0;
        end
        else begin
            dec <= ((cur_a == a3) && in) || ((cur_b == b3) && in) || ((cur_c == c3) && !in);
        end
    end

    always @(*) begin
        case (cur_a) 
            a0 : next_a = in ? a0 : a1;
            a1 : next_a = in ? a2 : a1;
            a2 : next_a = in ? a3 : a1;
            a3 : next_a = in ? a0 : a1;
        endcase
    end
    always @(*) begin
        case (cur_b)
            b0 : next_b = in ? b1 : b0;
            b1 : next_b = in ? b1 : b2;
            b2 : next_b = in ? b3 : b0;
            b3 : next_b = in ? b1 : b2;
        endcase
    end
    always @(*) begin
        case (cur_c)
            c0 : next_c = in ? c1 : c0;
            c1 : next_c = in ? c2 : c0;
            c2 : next_c = in ? c2 : c3;
            c3 : next_c = in ? c1 : c0;
        endcase
    end

endmodule
