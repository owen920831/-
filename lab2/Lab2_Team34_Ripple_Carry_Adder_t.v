`timescale 1ns / 1ps
module test_Ripple_Carry_Adder;
    reg [8-1:0] a, b;
    reg cin;
    wire [8-1:0] sum;
    wire cout;

    Ripple_Carry_Adder m1(a, b, cin, cout, sum);

    initial begin
        a = 8'b00000000;
        b = 8'b00000000;
        cin = 1'b0;
        repeat(2 ** 8 - 1) begin
            repeat(2 ** 8 - 1) begin          
                #1
                cin = cin + 1'b1;
                #1
                cin = 1'b0;
                b = b + 1'b1;
            end
            #1
            cin = cin + 1'b1;
            #1 
            b = 8'b00000000;
            cin = 1'b0;
            a = a + 1'b1;
        end
        $finish;
    end
endmodule