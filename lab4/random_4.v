module Many_To_One_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg [11:0] out;

    wire xor_in;

    assign xor_in = out[1] ^ out[2] ^ out[3] ^ out[7];

    always @(posedge clk) begin
        if (!rst_n) begin
            out <= 12'b011011110110;
        end
        else begin
            out <= {out[10:0], xor_in};
        end
    end
endmodule


module random_4(clk, rst_n, ans);
    input clk;
    input rst_n;
    output reg [15:0] ans;
    wire [11:0] out;
    
    reg [3:0] a, b, c, d;
    reg [15:0] tmp_ans;

    wire same = (tmp_ans[15:12] != tmp_ans[11:8]) && 
                (tmp_ans[15:12] != tmp_ans[7:4]) && 
                (tmp_ans[15:12] != tmp_ans[3:0]) && 
                (tmp_ans[11:8] != tmp_ans[7:4]) && 
                (tmp_ans[11:8] != tmp_ans[3:0]) && 
                (tmp_ans[7:4] != tmp_ans[3:0]);


    Many_To_One_LFSR m(clk, rst_n, out);

    always @(*) begin
        a = {1'b0, out[11:9]}+1'b1;
        b = {1'b0, out[8:6]}+1'b1;
        c = {1'b0, out[5:3]}+1'b1;
        d = {1'b0, out[2:0]}+1'b1;
        tmp_ans = {a%4'b1010, (a+b)%4'b1010, (a+b+c)%4'b1010, (a+b+c+d)%4'b1010};
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            ans <= 16'b1001001101010001;
        end
        else begin
            ans <= (same) ? tmp_ans : ans;
        end
    end
endmodule