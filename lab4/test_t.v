`timescale 1ns/1ps

module test_t;
reg clk = 1'b1;
reg rst_n = 1'b0;
wire [15:0] ans;
wire [3:0] a, b, c, d;
assign a = ans[15:12];
assign b = ans[11:8];
assign c = ans[7:4];
assign d = ans[3:0];

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

random_4 r(clk, rst_n, ans);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Mealy.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @ (negedge clk) rst_n = 1'b0;
    @ (negedge clk) rst_n = 1'b1;
end

endmodule
