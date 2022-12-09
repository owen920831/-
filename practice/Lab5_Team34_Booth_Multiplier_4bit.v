`timescale 1ns/1ps 

module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
    input clk;
    input rst_n; 
    input start;
    input signed [3:0] a, b;
    output signed [7:0] p;

    parameter WAIT = 2'b00;
	parameter CAL = 2'b01;
	parameter FINISH = 2'b10;

    reg signed [7:0] p, next_p;
    reg [1:0] state, next_state;

    reg [1:0] cal_counter, next_cal_counter;
    reg finish_counter, next_finish_counter;

	wire signed[9:0] ans = ~tmp_p+1'b1;
    wire signed[4:0] a_5bit = {a[3], a}; //01
    wire signed[4:0] a_5bit_cmp = ~({a[3], a})+1'b1; //10
    reg signed[9:0] tmp_p, next_tmp_p;
	wire [9:0] add_a = {(tmp_p[9:5]+a_5bit), tmp_p[4:0]};
	wire [9:0] add_a_cmp = {(tmp_p[9:5]+a_5bit_cmp), tmp_p[4:0]};

    always @(*) begin
        next_finish_counter = (state == FINISH)? finish_counter + 1: 0;
    end

    always @(*) begin
        if (state == CAL) begin
            next_cal_counter = cal_counter + 1;
        end 
        else begin
            next_cal_counter = 0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n)begin
            state <= WAIT;
            tmp_p <= 0;
            p <= 0;
			cal_counter <= 0;
			finish_counter <= 0;
        end
        else begin
            state <= next_state;
            tmp_p <= next_tmp_p;
            p <= next_p;
			cal_counter <= next_cal_counter;
			finish_counter <= next_finish_counter;
        end
    end

    always @(*) begin
        case (state)
            WAIT: begin 
                if (start) next_state = CAL;
                else next_state = WAIT;
            end
            CAL: begin
                if (cal_counter == 2'd3) next_state = FINISH;
                else next_state = CAL;
            end
            FINISH : begin 
                next_state = (finish_counter == 1)? WAIT: FINISH;
            end
        endcase  
    end

    always @(*) begin
        case (state)
            WAIT: begin 
                next_tmp_p = {5'b00000, b, 1'b0};
            end
            CAL: begin
                case (tmp_p[1:0])
                    2'b00, 2'b11: begin 
                        next_tmp_p = {tmp_p[9], tmp_p[9:1]};
                    end
                    2'b01: begin
                        next_tmp_p = {add_a[9], add_a[9:1]};
                    end
                    2'b10: begin 
                        next_tmp_p = {add_a_cmp[9], add_a_cmp[9:1]}; 
                    end
                endcase                 
            end
            FINISH : begin 
                next_tmp_p = tmp_p;
            end
        endcase    
    end

    always @(*) begin
        case (state)
            WAIT: begin 
                next_p = 8'b0;
            end
            CAL: begin
                next_p = 8'b0;
            end
            FINISH : begin 
                next_p = ans[8:1];
            end
        endcase    
    end

endmodule

