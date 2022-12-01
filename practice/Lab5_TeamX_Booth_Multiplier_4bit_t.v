`timescale 1ns/1ps 

module Booth_Multiplier_4bit_tb();
    reg clk, rst_n, start;
    reg signed [3:0] a, b;
    reg [8:0] correct_cnt;
    reg [7:0] temp;
    wire signed [7:0] p;

    Booth_Multiplier_4bit M(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .a(a),
        .b(b),
        .p(p)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; start = 0; a = 0; b = 0; temp = 0; correct_cnt = 0;
        
        repeat(2 ** 8) begin
            # 13
            {a, b} = temp;
            temp = temp + 1;
            # 10 
            rst_n = 1; start = 1;
            # 4
            start = 0;
            # 7
            
            if (p == a*b)
                correct_cnt = correct_cnt + 1;
            else 
                $display("===== ERROR =====\n%d != %d * %d", p, a, b);
        end
        #20
        if (correct_cnt == 2 ** 8)
            $display(">>> All correct ! <<<");
        $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, Booth_Multiplier_4bit_tb);
    end
endmodule