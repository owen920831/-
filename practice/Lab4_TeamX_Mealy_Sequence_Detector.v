`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec, state);
    input clk, rst_n;
    input in;
    output dec;
    output [3:0] state;
    parameter s0 = 4'd0;
    parameter s1 = 4'd1;
    parameter s01 = 4'd2;
    parameter s011 = 4'd3;
    parameter s0111 = 4'd4;
    parameter s10 = 4'd5;
    parameter s101 = 4'd6;
    parameter s1011 = 4'd7;
    parameter s11 = 4'd8;
    parameter s110 = 4'd9;
    parameter s1100 = 4'd10;

    reg [3:0] state, next_state;
    reg dec;

    always @(posedge clk) begin
        if (!rst_n) begin
            if (in == 0) state <= s0;
            else state <= s1;
        end
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            s0: begin
                next_state = (in)? s01: s0;
                dec = 0;
            end 
            s1: begin
                next_state = (in)? s11: s0;
                dec = 0;
            end 
            s01: begin
                next_state = (in)? s011: s0;
                dec = 0;
            end 
            s011: begin
                next_state = (in)? s0111: s0;
                dec = (in)? 1: 0;
            end 
            s0111: begin
                next_state = (in)? s1: s0;
                dec = 0;
            end 
            s10: begin
                next_state = (in)? s101: s0;
                dec = 0;
            end 
            s101: begin
                next_state = (in)? s1011: s0;
                dec = (in)? 1: 0;
            end 
            s1011: begin
                next_state = (in)? s1: s0;
                dec = 0;
            end 
            s11: begin
                next_state = (in)? s1: s110;
                dec = 0;
            end 
            s110: begin
                next_state = (in)? s1: s1100;
                dec = (in)? 0: 1;
            end 
            s1100: begin
                next_state = (in)? s1: s0;
                dec = 0;
            end 
            default: begin
                next_state = s0;
                dec = 0;
            end
        endcase
    end
endmodule
