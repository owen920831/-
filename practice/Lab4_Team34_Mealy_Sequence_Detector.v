`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
    input clk, rst_n;
    input in;
    output dec;
    
    parameter idle = 4'd0;
    parameter s0 = 4'd1;
    parameter s01 = 4'd2;
    parameter s011 = 4'd3;
    parameter s1 = 4'd4;
    parameter s10 = 4'd5;
    parameter s101 = 4'd6;
    parameter s11 = 4'd7;
    parameter s110 = 4'd8;
    parameter sx2 = 4'd9;
    parameter sx1 = 4'd10;
    
    reg dec;

    reg [3:0] state, next_state;
    always @(posedge clk) begin
        if (!rst_n)begin
            state <= idle;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            idle: begin
                next_state = (in)?s1:s0;
                dec = 0;
            end 
            s0: begin
                next_state = (in)?s01:sx2;
                dec = 0;
            end 
            s01: begin
                next_state = (in)?s011:sx1;
                dec = 0;
            end 
            s011: begin
                next_state = idle;
                dec = (in)?1:0;
            end 
            s1: begin
                next_state = (in)?s11:s10;
                dec = 0;
            end 
            s10: begin
                next_state = (in)?s101:sx1;
                dec = 0;
            end 
            s101: begin
                next_state = idle;
                dec = (in)?1:0;
            end 
            s11: begin
                next_state = (in)?idle:s110;
                dec = 0;
            end 
            s110: begin
                next_state = idle;
                dec = (in)?0:1;
            end 
            sx2: begin
                next_state = sx1;
                dec = 0;
            end 
            sx1: begin
                next_state = idle;
                dec = 0;
            end 
        endcase
    end
endmodule
