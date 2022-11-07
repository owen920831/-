`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
    input clk;
    input rst_n;
    input wen, ren;
    input [8-1:0] din;
    output [8-1:0] dout;
    output error;

    reg [8-1:0] error_x;
    reg [8-1:0] memory [0:8];
    reg [3:0] front, rear;
    reg [8-1:0] dout;
    reg error;
    reg [3:0] next_front = 0, next_rear  = 0;

    always @(*) begin
        next_front = front+1;
        next_rear = rear+1;
        if (front == 4'b1000)begin
            next_front = 0;
        end
        if (rear == 4'b1000)begin
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
                    dout <= error_x;
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
                    dout <= error_x;
                end
                else begin
                    front <= front;
                    rear <= next_rear;
                    memory[next_rear] = din;
                    error <= 0;
                    dout <= error_x;
                end
            end
            else begin
                front <= front;
                rear <= rear;
                error <= 0;
                dout <= error_x;
            end
        end
    end

endmodule
