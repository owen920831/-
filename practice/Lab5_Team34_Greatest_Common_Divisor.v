`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd, state);
    input clk, rst_n;
    input start;
    input [15:0] a;
    input [15:0] b;
    output done;
    output [15:0] gcd;

    parameter WAIT = 2'b00;
    parameter CAL = 2'b01;
    parameter FINISH = 2'b10;

    reg done, next_done; 
    reg [15:0] gcd, next_gcd;
    output reg [1:0] state;
    reg [1:0] next_state;
    reg finish_counter, next_finish_counter;
    reg [15:0] tmp_a, next_tmp_a, tmp_b, next_tmp_b;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= WAIT;
            finish_counter <= 1'b0;
            gcd <= 0;
            tmp_a <= 0;
            tmp_b <= 0;
            done <= 0;
        end
        else begin
            state <= next_state;
            finish_counter <= next_finish_counter;
            gcd <= next_gcd;
            tmp_a <= next_tmp_a;
            tmp_b <= next_tmp_b;
            done <= next_done;
        end
    end

    always @(*) begin
        if (state == FINISH) begin
            next_finish_counter = finish_counter + 1;
        end 
        else begin
            next_finish_counter = 0;
        end
    end

    always @(*) begin
        case (state)
            WAIT: begin 
                if (start) next_state = CAL;
                else next_state = WAIT;
            end
            CAL: begin
                if (0 == tmp_b || 0 == tmp_a) next_state = FINISH;
                else next_state = CAL;
            end
            FINISH : begin 
                next_state = (finish_counter == 1'd1)? WAIT: FINISH;
            end
        endcase    
    end

    always @(*) begin
        case (state)
            WAIT: begin 
                next_gcd = 0;
                next_done = 0;
                next_tmp_a = a;
                next_tmp_b = b;
            end
            CAL: begin
                next_gcd = 0;
                next_done = 0;
                next_tmp_a = (tmp_a > tmp_b)? tmp_a - tmp_b: tmp_a;
                next_tmp_b = (tmp_a > tmp_b)? tmp_b: tmp_b - tmp_a;
            end
            FINISH : begin 
                next_gcd = (tmp_a == 0)? tmp_b: tmp_a;
                next_done = 1;
                next_tmp_a = tmp_a;
                next_tmp_b = tmp_b;    
            end
        endcase    
    end
endmodule
