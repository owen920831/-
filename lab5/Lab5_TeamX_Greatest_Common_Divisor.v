`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output done;
output [15:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH1 = 2'b10;
parameter FINISH2 = 2'b11;
reg [15:0] a_buf, b_buf, gcd;
reg [1:0] state, next_state, cnt;
reg done;
reg [15:0] ans;
wire ready = (state == WAIT)? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (rst_n == 0) begin
        state <= WAIT;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = 2'bx;
    case (state)
        WAIT: begin 
            if (start) next_state = CAL;
            else next_state = WAIT;
        end
        CAL: begin
            if (0 != b_buf) next_state= CAL;
            else next_state = FINISH1;
        end
        FINISH1: next_state = FINISH2;
        FINISH2: next_state = WAIT;
    endcase    
end

always @ (posedge clk) begin
    if (!rst_n) begin
        gcd <= 0;
        a_buf <= 0;
        b_buf <= 0;
        done <= 0;
    end
    else begin
        case (state)
            WAIT: begin
                if (start) begin
                    a_buf <= a;
                    b_buf <= b;
                end
                gcd <= 0;
                done <= 0;
            end
            CAL: begin
                if (a_buf > b_buf) begin
                    a_buf <= a_buf - b_buf;
                    b_buf <= b_buf;
                end
                else begin
                    b_buf <= b_buf - a_buf;
                    a_buf <= a_buf;
                end
            end
            FINISH1: begin
                gcd <= b_buf;
                done <= 1;
            end
            FINISH2: begin
                gcd <= (a_buf == 0) ? b_buf: a_buf;
                done <= 1;
            end
        endcase
    end
end
endmodule