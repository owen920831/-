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
    reg [3:0] counter;
    wire [3:0] next_counter;
    reg clk1_2, clk1_4, clk1_3, clk1_8;

    assign next_counter = counter + 1;

    always @(posedge clk) begin
        counter <= next_counter;
        clk1_2 <= counter[1];
        clk1_3 <= counter[1] && counter[0];
        clk1_4 <= counter[2];
        clk1_8 <= counter[3];
        if (!rst_n) begin
            clk1_2 <= 1;
            clk1_4 <= 1;
            clk1_3 <= 1;
            clk1_8 <= 1;
            dclk <= 0;
            counter <= 3'b000;
        end
        else begin
            case (sel)
                2'b00: dclk <= clk1_3;
                2'b01: dclk <= clk1_2;
                2'b10: dclk <= clk1_4;
                2'b11: dclk <= clk1_8;
                default: dclk <= 0;
            endcase
        end
    end

endmodule