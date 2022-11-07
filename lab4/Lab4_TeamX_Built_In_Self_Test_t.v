module Built_In_Self_Test_t;
    reg clk = 1;
    reg rst_n = 1;
    reg scan_en = 0;
    wire scan_in;
    wire scan_out;

    // specify duration of a clock cycle.
    parameter cyc = 10;

    // generate clock.
    always #(cyc/2) clk = ~clk;

    Built_In_Self_Test b(clk, rst_n, scan_en, scan_in, scan_out);

    initial begin
        @ (negedge clk) begin
            rst_n = 0;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 0;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
        @ (negedge clk) begin
            rst_n = 1;
            scan_en = 1;
        end
    end


endmodule