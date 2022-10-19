`timescale 1ns/1ps

module Multi_Bank_Memory_t;
reg clk = 0;
reg ren = 1'b0;
reg wen = 1'b0;
reg [10:0] waddr = 0, radder = 0;
reg [7:0] din = 0;
wire [7:0] dout;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always#(cyc/2)clk = !clk;

Multi_Bank_Memory mem(
    .clk(clk),
    .ren(ren),
    .wen(wen),
    .din(din),
    .waddr(waddr),
    .raddr(radder),
    .dout(dout)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Memory.fsdb");
//     $fsdbDumpvars;
// end

    initial begin
        @(negedge clk) //將20寫入addr[1]
            waddr = 1;
            radder = 0;
            wen = 1;
            ren = 0;
            din = 20;
        @(negedge clk) //將200寫入addr[200]，同時讀取 addr[1]
            waddr = 200;
            radder = 1;
            wen = 1;
            ren = 1;
            din = 200;
        @(negedge clk) //再來讀取addr[200]
            waddr = 1;
            radder = 200;
            wen = 0;
            ren = 1;
            din = 200;
        @(negedge clk) //將201寫入addr[201]
            waddr = 201;
            radder = 201;
            wen = 1;
            ren = 0;
            din = 201;
        @(negedge clk) //將202寫入addr[201]，並同時讀取addr[200]
            waddr = 201;
            radder = 200;
            wen = 1;
            ren = 1;
            din = 202;
        @(negedge clk) //讀取 addr[202]
            waddr = 100;
            radder = 202;
            wen = 0;
            ren = 1;
            din = 20;
        $finish;
    end
endmodule

