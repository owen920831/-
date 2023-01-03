`timescale 1ns / 1ps
module sprite2();

    parameter RAM_WIDTH = 8;
    parameter RAM_ADDR_BITS = 14;
    // 16 k Memoria
    (* RAM_STYLE="{AUTO | BLOCK |  BLOCK_POWER1 | BLOCK_POWER2}" *)
    reg [RAM_WIDTH-1:0] imagen [(2**RAM_ADDR_BITS)-1:0];
    integer i;

    //  The forllowing code is only necessary if you wish to initialize the RAM 
    //  contents via an external file (use $readmemb for binary data)
    initial begin
        #10;    
        $readmemb("sprite2.bin", imagen, 0, (2**RAM_ADDR_BITS)-1);
        #10;

        for (i = 0; i<20; i = i+1) begin
            $display ("%b", imagen[i]);
        end
        #10;
        $finish;
    end		
	
endmodule