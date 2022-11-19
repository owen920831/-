`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
    input clk, rst_n;
    input lr_has_car;
    output [2:0] hw_light;
    output [2:0] lr_light;

    parameter hg_lr = 3'b000;
    parameter hy_lr = 3'b001;
    parameter hr_lr_1 = 3'b010;
    parameter hr_lr_2 = 3'b011;
    parameter hr_ly = 3'b100;
    parameter hr_lg = 3'b101;

    reg h_green_light_counter, r_green_light_counter;
    reg yellow_light_counter;
    reg [3:0] state, next_state;

    reg [6:0] h_green_counter, r_green_counter;
    reg [4:0] yellow_counter;

    always @(posedge clk) begin
        yellow_counter <= (!rst_n || state == hy_lr|| state == hr_ly)? 1'b1 : yellow_counter + 1'b1;
        yellow_light_counter <= (!rst_n)? 1'b0 : (yellow_counter == 5'd25);
    end

    always @(posedge clk) begin
        r_green_counter <= (!rst_n || state == hr_lg)? 1'b1 : r_green_counter + 1'b1;
        r_green_light_counter <= (!rst_n)? 1'b0 : (r_green_light_counter == 7'd70);
    end

    always @(posedge clk) begin
        r_green_counter <= (!rst_n || state == hr_lg)? 1'b1 : r_green_counter + 1'b1;
        r_green_light_counter <= (!rst_n)? 1'b0 : (r_green_light_counter == 7'd70);
    end

    always @(posedge clk) begin
        if (!rst_n)begin
            state <= hg_lr;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            hg_lr:begin

            end 
            hy_lr:begin

            end
            hr_lr_1:begin

            end 
            hr_lg:begin

            end 
            hr_ly:begin

            end
            hr_lr_2:begin

            end 
        endcase
    end 


endmodule
