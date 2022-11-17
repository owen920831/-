`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec, state);
    input clk, rst_n;
    input in;
    output reg dec;
    output reg [3:0] state;

    parameter S0 = 4'b0000;
    parameter S1 = 4'b0001;
    parameter S11 = 4'b0010;
    parameter S111 = 4'b0011;
    parameter S1110 = 4'b0100;
    parameter S1110_0 = 4'b0101;
    parameter S1110_01 = 4'b0110;
    parameter S1110_01_1 = 4'b0111;
    parameter S1110_01_11 = 4'b1000;

    reg [3:0] next_state;
    always @(posedge clk) begin
        if (!rst_n)begin
            if (in) state <= S1;
            else state <= S0;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0:begin
                if (in) begin
                    next_state = S1;
                    dec = 0;
                end 
                else begin
                    next_state = S0;
                    dec = 0;
                end
            end 
            S1:begin
                if (in) begin
                    next_state = S11;
                    dec = 0;
                end 
                else begin
                    next_state = S0;
                    dec = 0;
                end
            end
            S11:begin
                if (in) begin
                    next_state = S111;
                    dec = 0;
                end 
                else begin
                    next_state = S0;
                    dec = 0;
                end
            end 
            S111:begin
                if (in) begin
                    next_state = S111;
                    dec = 0;
                end 
                else begin
                    next_state = S1110;
                    dec = 0;
                end
            end 
            S1110:begin
                if (in) begin
                    next_state = S1;
                    dec = 0;
                end 
                else begin
                    next_state = S1110_0;
                    dec = 0;
                end
            end
            S1110_0:begin
                if (in) begin
                    next_state = S1110_01;
                    dec = 0;
                end 
                else begin
                    next_state = S0;
                    dec = 0;
                end
            end 
            S1110_01:begin
                if (in) begin
                    next_state = S1110_01_1;
                    dec = 0;
                end 
                else begin
                    next_state = S1110_0;
                    dec = 0;
                end
            end 
            S1110_01_1:begin
                if (in) begin
                    next_state = S1110_01_11;
                    dec = 0;
                end 
                else begin
                    next_state = S0;
                    dec = 0;
                end
            end
            S1110_01_11:begin
                if (in) begin
                    next_state = S111;
                    dec = 1;
                end 
                else begin
                    next_state = S1110;
                    dec = 1;
                end
            end 
        endcase
    end    


endmodule 