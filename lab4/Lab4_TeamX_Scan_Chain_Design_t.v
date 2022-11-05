`timescale 1ns/1ps

module Scan_Chain_Design_t;
    reg clk = 1'b1;
    reg rst_n = 1'b0;
    reg scan_in = 1'b0;
    reg scan_en = 1'b1;
    wire scan_out;

    // specify duration of a clock cycle.
    parameter cyc = 10;

    // generate clock.
    always #(cyc/2) clk = ~clk;

    Scan_Chain_Design s(
        clk,
        rst_n, 
        scan_in, 
        scan_en, 
        scan_out
    );

    // uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
    // initial begin
    //     $fsdbDumpfile("Mealy.fsdb");
    //     $fsdbDumpvars;
    // end

    initial begin
        @ (negedge clk) begin
            rst_n = 0;
            scan_en = 0;
            scan_in = 1;
        end
        @ (negedge clk) begin // b0
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin //b1
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin //b2
            rst_n = 1;
            scan_en = 1;
            scan_in = 1;
        end
        @ (negedge clk) begin //b3
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin //a0
            rst_n = 1;
            scan_en = 1;
            scan_in = 1;
        end
        @ (negedge clk) begin//a1
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin//a2
            rst_n = 1;
            scan_en = 1;
            scan_in = 1;
        end
        @ (negedge clk) begin//a3
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 0;
            scan_in = 1;
        end
        @ (negedge clk) begin //p0
            rst_n = 1;
            scan_en = 1;
            scan_in = 1;
        end
        @ (negedge clk) begin//p1
            rst_n = 1;
            scan_en = 1;
            scan_in = 1;
        end
        @ (negedge clk) begin//p2
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin//p3
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin//p4
            rst_n = 1;
            scan_en = 1;
            scan_in = 1;
        end
        @ (negedge clk) begin//p5
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin//p6
            rst_n = 1;
            scan_en = 1;
            scan_in = 0;
        end
        @ (negedge clk) begin//p7
            rst_n = 1;
            scan_en = 1;
            scan_in = 1;
        end
    end

endmodule
