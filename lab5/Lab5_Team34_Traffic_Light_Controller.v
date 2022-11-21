`timescale 1ns/1ps
module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
    input clk, rst_n;
    input lr_has_car;
    output reg [2:0] hw_light;
    output reg [2:0] lr_light;

    parameter hg_lr = 3'b000;
    parameter hy_lr = 3'b001;
    parameter hr_lr_1 = 3'b010;
    parameter hr_lr_2 = 3'b011;
    parameter hr_ly = 3'b100;
    parameter hr_lg = 3'b101;

    // output [3:0] state;
    // output [7:0] hg_counter, lg_counter;
    // output [4:0] y_counter;
    reg [3:0] state, next_state;
    reg [7:0] hg_counter, next_hg_counter, lg_counter, next_lg_counter;
    reg [4:0] y_counter, next_y_counter;

    always @(posedge clk) begin
        if (!rst_n)begin
            state <= hg_lr;
            lg_counter <= 1;
            hg_counter <= 1;
            y_counter <= 1;
        end
        else begin
            state <= next_state;
            lg_counter <= next_lg_counter;
            hg_counter <= next_hg_counter;
            y_counter <= next_y_counter;
        end
    end

    always @(*) begin
        if (lg_counter == 8'd70) next_lg_counter = 8'd1;
        else begin
            if (state == hr_lg) next_lg_counter = lg_counter + 1;
            else next_lg_counter = 8'd1;    
        end
    end

    always @(*) begin
        if (y_counter == 5'd25) next_y_counter = 5'd1;
        else begin
            if (state == hy_lr|| state == hr_ly) next_y_counter = y_counter + 1;
            else next_y_counter = 5'd1;    
        end
    end

    always @(*) begin
        if (hg_counter >= 8'd70 && state == hg_lr) next_hg_counter = 8'd70;
        else begin
            if (state == hg_lr) next_hg_counter = hg_counter + 1;
            else next_hg_counter = 8'd1;    
        end
    end

    always @(*) begin
        case (state)
            hg_lr:begin
                next_state = (hg_counter == 8'd70 && lr_has_car)? hy_lr : hg_lr;
            end 
            hy_lr:begin
                next_state = (y_counter == 5'd25)? hr_lr_1 : hy_lr;
            end
            hr_lr_1:begin
                next_state = hr_lg;
            end 
            hr_lg:begin
                next_state = (lg_counter == 8'd70)? hr_ly : hr_lg;
            end 
            hr_ly:begin
                next_state = (y_counter == 5'd25)? hr_lr_2 : hr_ly;
            end
            hr_lr_2:begin
                next_state = hg_lr;
            end 
        endcase
    end 

    always @(*) begin
        if (state == hg_lr) begin
            hw_light = 3'b100;
            lr_light = 3'b001;
        end
        else if (state == hy_lr) begin
            hw_light = 3'b010;
            lr_light = 3'b001;
        end
        else if (state == hr_lr_1) begin
            hw_light = 3'b001;
            lr_light = 3'b001;
        end
        else if (state == hr_lg) begin
            hw_light = 3'b001;
            lr_light = 3'b100;
        end
        else if (state == hr_ly) begin
            hw_light = 3'b001;
            lr_light = 3'b010;
        end
        else if (state == hr_lr_2) begin
            hw_light = 3'b001;
            lr_light = 3'b001;
        end
        else begin
            hw_light = 3'b111;
            lr_light = 3'b111;
        end
    end

endmodule
