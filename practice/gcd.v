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

    reg [1:0] state, next_state;
    reg [15:0] tmp_a, tmp_b, next_tmp_a, next_tmp_b, gcd, next_gcd;
    reg finish_counter, next_finish_counter;
    reg done, next_done;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= WAIT;
            tmp_a <= 16'd0;
            tmp_b <= 16'd0;
            gcd <= 16'd0;
            finish_counter <= 0;
            done <= 0;
        end
        else begin
            state <= next_state;
            tmp_a <= next_tmp_a;
            tmp_b <= next_tmp_b;
            gcd <= next_gcd;
            finish_counter <= next_finish_counter;
            done <= next_done; 
        end
    end

    //counter
    always @(*) begin
        if (state == FINISH) begin
            next_finish_counter = finish_counter + 1;
        end
        else begin
            next_finish_counter = 0;
        end
    end

    //state trans
    always @(*) begin
        case (state)
            WAIT: begin
                next_state = (start)? CAL:WAIT;
            end 
            CAL: begin
                next_state = (tmp_a == 0|| tmp_b == 0)? FINISH:CAL;
            end
            FINISH: begin
                next_state = (finish_counter)? WAIT:FINISH;
            end
        endcase
    end

    //state perform
    always @(*) begin
        case (state)
            WAIT: begin
                next_tmp_a = a;
                next_tmp_b = b;
            end 
            CAL: begin
                if (tmp_a > tmp_b)begin
                    next_tmp_a = tmp_a - tmp_b;
                    next_tmp_b = tmp_b;
                end
                else begin
                    next_tmp_a = tmp_a;
                    next_tmp_b = tmp_b - tmp_a;
                end
            end
            FINISH: begin
                next_tmp_a = tmp_a;
                next_tmp_b = tmp_b;
            end
        endcase
    end

    //gcd
    always @(*) begin
        case (state)
            WAIT: begin
                next_gcd = 16'd0;
                next_done = 0;
            end 
            CAL: begin
                next_gcd = 16'd0;
                next_done = 0;
            end
            FINISH: begin
                next_gcd = (tmp_a == 0)? tmp_b : tmp_a;
                next_done = 1;
            end
        endcase
    end
endmodule

module onepulse(clk, pb_one_pulse, pb_debounce);
    input clk, pb_debounce;
    output PB_one_pulse;
    reg pb_one_pulse, PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= pb_debounce & (!PB_debounced_delay);
        PB_debounced_delay <= pb_debounce;
    end
endmodule

module debounce(clk , pb, pb_debounce);
    input clk, pb;
    output pb_debounce;

    wire pb_debounce;
    reg dff[3:0];

    always @(posedge clk) begin
        dff[3:1] <= dff[2:0];
        dff[0] <= pb;
    end
    assign pb_debounce = (dff == 4'b1111) ? 1'b1:1'b0;

endmodule