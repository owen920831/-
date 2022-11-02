`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
    input clk, rst_n;
    input [2-1:0] sel;
    output clk1_2;
    output clk1_4;
    output clk1_8;
    output clk1_3;
    output dclk;
    
    reg dclk;
    reg [3:0] counter_2, counter_3, counter_4, counter_8;
    reg [3:0] n_counter_2, n_counter_3, n_counter_4, n_counter_8;
    reg vaild;
    wire clk1_2, clk1_4, clk1_3, clk1_8;

    assign clk1_2 = ((!rst_n && vaild) || (counter_2 == 0))? 1:0;
    assign clk1_3 = ((!rst_n && vaild) || (counter_3 == 0))? 1:0;
    assign clk1_4 = ((!rst_n && vaild) || (counter_4 == 0))? 1:0;
    assign clk1_8 = ((!rst_n && vaild) || (counter_8 == 0))? 1:0;

    always @(*) begin
        if (counter_2 == 1) n_counter_2 = 0;
        else n_counter_2 = counter_2+1;

        if (counter_3 == 2) n_counter_3 = 0;
        else n_counter_3 = counter_3+1;

        if (counter_4 == 3) n_counter_4 = 0;
        else n_counter_4 = counter_4+1;

        if (counter_8 == 7) n_counter_8 = 0;
        else n_counter_8 = counter_8+1;
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            vaild <= 1;
            counter_2 <= 0;
            counter_3 <= 0;
            counter_4 <= 0;
            counter_8 <= 0;
        end
        else begin
            vaild <= 0;
            counter_2 <= n_counter_2;
            counter_3 <= n_counter_3;
            counter_4 <= n_counter_4;
            counter_8 <= n_counter_8;
        end
    end

    always @(*) begin
        case (sel)
            2'b00: dclk = clk1_3;
            2'b01: dclk = clk1_2;
            2'b10: dclk = clk1_4;
            2'b11: dclk = clk1_8;
            default: dclk = 0;
        endcase
    end



endmodule