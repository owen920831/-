`timescale 1ns/1ps

module PPPC_FPGA(clk, rst_n, enable, flip, max, min, Anode_Activate,LED_out);
    input clk, rst_n;
    input enable;
    input flip;
    input [4-1:0] max;
    input [4-1:0] min;
    output reg [3:0] Anode_Activate;
    output reg [6:0] LED_out;

    wire flip_db, flip_op, rst_db, rst_op, rst_1;
    wire dclk, nclk;

    Clock_Divider cd(clk, rst_1, dclk, nclk);

    debounce d0(flip_db, flip, clk);
    onepulse o0(flip_op, flip_db, clk);

    debounce d1(rst_db, rst_n, clk);
    onepulse o3(rst_1, rst_db, clk);

    wire direction;
    wire [3:0]  out;
    wire [13:0] out_BCD;

    toBCD t(out,out_BCD);

    wire[6:0] dir_display;
    reg [1:0] rf_cnt;
    wire [1:0] nrfcnt;

    wire eb = nclk &enable;
    reg f,r;

    assign nf = nclk?1'b0:f;
    always @(posedge clk)begin
        if(flip_op) f <= flip;
        else f<=nf;
    end

    Parameterized_Ping_Pong_Counter PPPC(clk, rst_1, eb, f, max, min, direction, out);
    assign dir_display =  direction?7'b0011101:7'b1100011; 

    assign nrfcnt = dclk?rf_cnt+1'b1:rf_cnt;
    always @(posedge clk) begin
        if(rst_1) rf_cnt<=2'b0;
        else  rf_cnt <= nrfcnt;
    end
    
    always @(*) begin
        case(rf_cnt)
        2'd0: begin
            Anode_Activate = 4'b0111;
            LED_out = out_BCD [13:7];
        end
        2'd1: begin
            Anode_Activate = 4'b1011;
            LED_out = out_BCD [6:0];
        end
        2'd2: begin
            Anode_Activate = 4'b1101;
            LED_out = dir_display;
        end
        2'd3: begin
            Anode_Activate = 4'b1110;
            LED_out = dir_display;
        end
        endcase
    end
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; // signal of a pushbutton after being debounced
    input pb; // signal from a pushbutton
    input clk;

    reg [3:0] DFF; // use shift_reg to filter pushbutton bounce
    always @(posedge clk) begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
    assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
    endmodule

module onepulse (PB_one_pulse,PB_debounced, CLK);
    input PB_debounced;
    input CLK;
    output PB_one_pulse;
    reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge CLK) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end
endmodule

module toBCD(input [3:0] out, output reg[13:0] out_BCD);
    wire LB;
    wire [3:0] RB;
    assign LB = (out>4'd9)?4'd1:4'd0;
    assign RB= (out>4'd9)?out-4'd10:out;
    always @(*)
    begin
        case(LB)
            1'b0: out_BCD[13:7] = 7'b0000001; 
            1'b1: out_BCD[13:7] = 7'b1001111;
        endcase
    end
    always @(*) begin
            case(RB)
            4'd0: out_BCD[6:0] = 7'b0000001;   
            4'd1: out_BCD[6:0] = 7'b1001111; 
            4'd2: out_BCD[6:0] = 7'b0010010;  
            4'd3: out_BCD[6:0] = 7'b0000110; 
            4'd4: out_BCD[6:0] = 7'b1001100; 
            4'd5: out_BCD[6:0] = 7'b0100100;  
            4'd6: out_BCD[6:0] = 7'b0100000; 
            4'd7: out_BCD[6:0] = 7'b0001111; 
            4'd8: out_BCD[6:0] = 7'b0000000;  
            4'd9: out_BCD[6:0] = 7'b0000100; 
        endcase
    end
endmodule

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
    input clk, rst_n;
    input enable;
    input flip;
    input [4-1:0] max;
    input [4-1:0] min;
    output reg direction;
    output reg [4-1:0] out;
    reg ndir;
    reg [3:0] n_cnt;
    reg save,nsave;
    always @(posedge clk ) begin
        if(rst_n) begin
            out <= min;
            direction <= 1'd1;
            save<=1'b1;
        end
        else begin
            out <= n_cnt;
            direction <= ndir;
            save <=nsave;
        end
    end
    always @(*) begin
        if(enable && max>min && out<= max && out>=min) begin
                if(direction) begin
                    if(out<max && !flip) n_cnt = out +1'b1;
                    else n_cnt = out - 1'b1;
                    ndir = flip?1'b0:out <max;            
                end
                else begin
                    if(out>min && !flip) n_cnt = out -1'b1;
                    else n_cnt = out + 1'b1;
                    ndir = flip?1'b1:out <= min ;
                end
        end
        else begin
            ndir = direction;
            n_cnt = out;
            nsave = save;
        end
    end
endmodule

module Clock_Divider (clk, rst_n, display_clk, num_clk);
    input clk,rst_n;
    output reg display_clk, num_clk;

    reg [17:0] ctr_co;
    reg [24:0] ctr_CO;
    always @(posedge clk) begin
        if(rst_n) begin
            ctr_co <= 1'b0;
            ctr_CO <=1'b0;
        end
        else begin
            ctr_co <= ctr_co+1'b1;
            ctr_CO <= ctr_CO+1'b1;
        end
        
    end

    always @(posedge clk) begin
        if(rst_n) begin
            display_clk <=1'b0;
            num_clk <= 1'b0;
        end
        else begin
            display_clk <= ctr_co== 18'b111111111111111111;
            num_clk <= ctr_CO== 25'b1111111111111111111111111;
        end
    end
endmodule

