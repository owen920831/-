`timescale 1ns/1ps
module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
    input clk;
    input rst_n;
    input wen, ren;
    input [8-1:0] din;
    output [8-1:0] dout;
    output error;

    reg [8-1:0] memory [0:8];
    reg [3:0] front, rear;
    reg [8-1:0] dout;
    reg error;
    reg [3:0] next_front, next_rear;
    reg [8-1:0] dout;

    always @(*) begin
        next_front = front+1;
        next_rear = rear+1;
        if (next_front === 4'b1001)begin
            next_front = 0;
        end
        if (next_rear === 4'b1001)begin
            next_rear = 0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n)begin
            dout <= 0;
            error <= 0;
            front <= 0;
            rear <= 0;
        end
        else begin
            if (ren) begin
                if (front == rear) begin
                    front <= front;
                    rear <= rear;
                    error <= 1;
                    dout <= 0;
                end
                else begin
                    front <= next_front;
                    rear <= rear;
                    error <= 0;
                    dout <= memory[next_front];
                end
            end
            else if (wen && !ren)begin
                if (next_rear == front) begin
                    front <= front;
                    rear <= rear;
                    error <= 1;
                    dout <= 0;
                end
                else begin
                    front <= front;
                    rear <= next_rear;
                    memory[next_rear] = din;
                    error <= 0;
                    dout <= 0;
                end
            end
            else begin
                if (front == rear) begin
                    error <= 1;
                end 
                else begin
                    error <= 0;
                end
                front <= front;
                rear <= rear;
                dout <= 0;
            end
        end
    end

endmodule

module Round_Robin_FIFO_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
    input clk;
    input rst_n;
    input [4-1:0] wen;
    input [8-1:0] a, b, c, d;
    output [8-1:0] dout;
    output valid;

    reg [1:0] counter = 0;
    wire [1:0] next_counter;
    reg r0 = 0, r1 = 0, r2 = 0, r3 = 0;
    wire [7:0] a_output, b_output, c_output, d_output;
    reg valid = 0;
    wire [8-1:0] dout;

    assign next_counter = counter + 1;
    or o[7:0](dout, a_output, b_output, c_output, d_output);
    // assign dout = b_output;

    always @(wen, counter) begin
        r0 = 0; r1 = 0; r2 = 0; r3 = 0;
        r0 = (!wen[0] && (counter === 2'b00)) ? 1 : 0;
        r1 = (!wen[1] && (counter === 2'b01)) ? 1 : 0;
        r2 = (!wen[2] && (counter === 2'b10)) ? 1 : 0;
        r3 = (!wen[3] && (counter === 2'b11)) ? 1 : 0;
    end

    FIFO_8 A(clk, rst_n, wen[0], r0, a, a_output, a_error);
    FIFO_8 B(clk, rst_n, wen[1], r1, b, b_output, b_error);
    FIFO_8 C(clk, rst_n, wen[2], r2, c, c_output, c_error);
    FIFO_8 D(clk, rst_n, wen[3], r3, d, d_output, d_error);

    always @(posedge clk) begin
        counter <= next_counter;
        if (!rst_n) begin
            counter <= 0;
            valid <= 0;
        end
        else begin
            case (counter)
                2'b00 : begin
                    if (a_error || wen[0]) begin
                        valid <= 0;
                    end
                    else begin
                        valid <= 1;
                    end
                end
                2'b01 : begin
                    if (b_error || wen[1]) begin
                        valid <= 0;
                    end
                    else begin
                        valid <= 1;
                    end
                end
                2'b10 : begin
                    if (c_error || wen[2]) begin
                        valid <= 0;
                    end
                    else begin
                        valid <= 1;
                    end
                end
                2'b11 : begin
                    if (d_error || wen[3]) begin
                        valid <= 0;
                    end
                    else begin
                        valid <= 1;
                    end
                end
            endcase
        end
    end

endmodule
