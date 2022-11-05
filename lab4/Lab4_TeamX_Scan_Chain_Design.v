`timescale 1ns/1ps

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
    input clk;
    input rst_n;
    input scan_in;
    input scan_en;
    output scan_out;

    reg scan_out;
    reg [7:0] p, dff;


    always @(*) begin
        p = dff[3:0] * dff[7:4];
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            dff[0] <= 0;
            dff[1] <= 0;
            dff[2] <= 0;
            dff[3] <= 0;
            dff[4] <= 0;
            dff[5] <= 0;
            dff[6] <= 0;
            dff[7] <= 0;
            scan_out <= dff[0];
        end
        else begin
            if (scan_en) begin
                dff[0] <= dff[1];
                dff[1] <= dff[2];
                dff[2] <= dff[3];
                dff[3] <= dff[4];
                dff[4] <= dff[5];
                dff[5] <= dff[6];
                dff[6] <= dff[7];
                dff[7] <= scan_in;   
                scan_out <= dff[0];            
            end
            else begin
                dff[0] <= p[0];
                dff[1] <= p[1];
                dff[2] <= p[2];
                dff[3] <= p[3];
                dff[4] <= p[4];
                dff[5] <= p[5];
                dff[6] <= p[6];
                dff[7] <= p[7];   
                scan_out <= dff[0];             
            end
        end
    end

endmodule
