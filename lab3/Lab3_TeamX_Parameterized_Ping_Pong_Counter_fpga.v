`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, seg, an);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg [6:0] seg;
output reg [4-1:0] an;

reg [3:0] out;
reg direction;
reg [1:0]led_counter, next_led_counter;
wire cnt_clk;
wire dis_clk;

clk_div c1(clk, cnt_clk);
clock_divider c2(clk, dis_clk);

wire derstn, rstn_out;
debounce a(clk, rst_n, derstn);
onepulse b(dis_clk, derstn, rstn_out);

wire deflip, flip_out;
debounce c(clk, flip, deflip);
onepulse d(dis_clk, deflip, flip_out);

always @(posedge dis_clk) begin
    led_counter <= next_led_counter;
end

always @* begin
    next_led_counter = led_counter + 1;
    if(led_counter == 3) next_led_counter = 0;
end

always @(posedge cnt_clk) begin
    if (rstn_out) begin
        out <= min;
        direction <= 1'b1;
    end
    else if (enable && (max > min)) begin
        if ((out <= max) && (out >= min)) begin
            if (flip_out) begin
                direction <= ~direction;
                if (direction == 1'b0 && out < max) 
                    out <= out + 4'b0001;
                else if (direction == 1'b1 && out > min)
                    out <= out - 4'b0001;
                else  begin
                    out <= out;
                    direction <= direction;
                end
            end
            else begin
                if (direction) begin
                    if (out > max - 4'b0001)
                        out <= max - 4'b0001;
                    else out <= out + 4'b0001;
                    direction <= (out == max) ? 0 : 1;
                end
                else begin
                    if (out < min + 4'b0001)
                        out <= min + 4'b0001;
                    else out <= out - 4'b0001;
                    direction <= (out == min) ? 1 : 0;
                end 
            end
        end
    end
end

always @(*) begin
    case(led_counter)
        2'b00: begin
            an = 4'b0111;
            if (out >= 4'b1010) seg = 7'b1001111;
            else seg = 7'b0000001;
        end
        2'b01: begin
            an = 4'b1011;
            case (out)
                4'b0000 : seg = 7'b0000001;
                4'b0001 : seg = 7'b1001111;
                4'b0010 : seg = 7'b0010010;
                4'b0011 : seg = 7'b0000110;
                4'b0100 : seg = 7'b1001100;
                4'b0101 : seg = 7'b0100100;
                4'b0110 : seg = 7'b0100000;
                4'b0111 : seg = 7'b0001111;
                4'b1000 : seg = 7'b0000000;
                4'b1001 : seg = 7'b0000100;  
                4'b1010 : seg = 7'b0000001;   // 10
                4'b1011 : seg = 7'b1001111;
                4'b1100 : seg = 7'b0010010;
                4'b1101 : seg = 7'b0000110;
                4'b1110 : seg = 7'b1001100;
                default : seg = 7'b0100100;
            endcase
        end
        2'b10: begin
            an = 4'b1101;
            case (direction)
                1'b0: begin
                seg = 7'b1100011;
                end
                default: begin
                    seg = 7'b0011101;
                end
            endcase
        end
        2'b11: begin
            an = 4'b1110;
            case (direction)
                1'b0: begin
                    seg = 7'b1100011;
                end
                default: begin
                    seg = 7'b0011101;
                end
            endcase
        end
        default: begin
            an = 4'b0111;
            if (out >= 4'b1010) seg = 7'b1001111;
            else seg = 7'b0000001;
        end
    endcase
end
endmodule

module signal2seven_digit(
    a, seg
);
    input [3:0] a;
    output [6:0] seg;
    reg [6:0] seg;

    always @(*) begin
    case (a)
        4'b0000 : seg <= 7'b0000001;
        4'b0001 : seg <= 7'b1001111;
        4'b0010 : seg <= 7'b0010010;
        4'b0011 : seg <= 7'b0000110;
        4'b0100 : seg <= 7'b1001100;
        4'b0101 : seg <= 7'b0100100;
        4'b0110 : seg <= 7'b0100000;
        4'b0111 : seg <= 7'b0001111;
        4'b1000 : seg <= 7'b0000000;
        4'b1001 : seg <= 7'b0000100;  
        4'b1010 : seg <= 7'b0000001;   // 10
        4'b1011 : seg <= 7'b1001111;
        4'b1100 : seg <= 7'b0010010;
        4'b1101 : seg <= 7'b0000110;
        4'b1110 : seg <= 7'b1001100;
        default : seg <= 7'b0100100;
    endcase
    end
endmodule

module debounce(clk, pb, pb_debounced);

output pb_debounced;
input pb;
input clk;

reg [3:0] DFF;

always @(posedge clk)
begin
    DFF [3:1] <= DFF[2:0];
    DFF[0] <= pb;
end

assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module onepulse (clk, pb_debounced, pb_one_pulse);
input pb_debounced;
input clk;
output pb_one_pulse;
reg pb_one_pulse;
reg pb_debounced_delay;

always @(posedge clk)
begin
    pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
    pb_debounced_delay <= pb_debounced;
end
endmodule

module clock_divider(    // generate display clock
    input clk,
    output clk_div  
    );
    parameter n = 11;
    reg [n-1:0] num;
    wire [n-1:0] next_num;
    always @(posedge clk) begin
        num <= next_num;
    end
    assign next_num = num + 1;
    assign clk_div = num[n-1];
endmodule

module clk_div(     // generate counting clock
    input clk,
    output clk_div  
    );
    parameter n = 25;
    reg [n-1:0] num;
    wire [n-1:0] next_num;
    always @(posedge clk) begin
        num <= next_num;
    end
    assign next_num = num + 1;
    assign clk_div = num[n-1];
endmodule