`timescale 1ns/1ps

module Universal_Gate(a, b, out);
input a, b;
output out;
wire _b;
not (_b, b);
and (out, a, _b);
endmodule