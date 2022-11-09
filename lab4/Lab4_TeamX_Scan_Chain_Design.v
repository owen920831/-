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
            dff <= 8'b0;
            scan_out <= dff[0];
        end
        else begin
            if (scan_en) begin
                dff <= {scan_in, dff[7:1]}; 
                scan_out <= dff[0];            
            end
            else begin
                dff <= {scan_in, p[7:1]};  
                scan_out <= p[0];             
            end
        end
    end

endmodule
