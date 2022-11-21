`timescale 1ns/1ps
module toBCD(out, out_BCD);
    input [3:0] out;
    output [6:0] out_BCD;
    reg [6:0] out_BCD;
    always @(*) begin
        case (out)
            4'd0: out_BCD = 7'b0000001;   
            4'd1: out_BCD = 7'b1001111; 
            4'd2: out_BCD = 7'b0010010;  
            4'd3: out_BCD = 7'b0000110; 
            4'd4: out_BCD = 7'b1001100; 
            4'd5: out_BCD = 7'b0100100;  
            4'd6: out_BCD = 7'b0100000; 
            4'd7: out_BCD = 7'b0001111; 
            4'd8: out_BCD = 7'b0000000;  
            4'd9: out_BCD = 7'b0000100;
            4'd10: out_BCD = 7'b1111111; //empty
            default: out_BCD = 7'b1111110; // x
        endcase
    end
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; // signal of a pushbutton after being debounced
    input pb; // signal from a pushbutton
    input clk;

    reg [24:0] DFF; // use shift_reg to filter pushbutton bounce
    always @(posedge clk) begin
        DFF[24:1] <= DFF[23:0];
        DFF[0] <= pb;
    end
    assign pb_debounced = ((DFF == 25'b1111) ? 1'b1 : 1'b0);
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

module Clock_Divider (clk, rst_n, display_clk);
    input clk, rst_n;
    output reg display_clk;

    reg [16:0] d_counter;
    
    always @(posedge clk) begin
        d_counter <= (!rst_n)? 1'b0 : d_counter + 1'b1;
    end

    always @(posedge clk) begin
        display_clk <= (!rst_n)? 1'b0 : (d_counter == 17'b0);
    end
endmodule

module FPGA_vending_machine (
    input clk, rst_n, NT_5, NT_10, NT_50, cancel,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    output [3:0] available_drink_LED,
    output [6:0] seg,
    output [3:0] An
);
    wire rst_db, rst_op, NT_5_db, NT_10_db, NT_50_db, cancel_db, NT_5_op, NT_10_op, NT_50_op, cancel_op;
    wire reset = ~rst_op;

    debounce d1(rst_db, rst_n, clk);
    onepulse o1(rst_op, rst_db, clk);

    debounce d2(NT_5_db, NT_5, clk);
    onepulse o2(NT_5_op, NT_5_db, clk);

    debounce d3(NT_10_db, NT_10, clk); 
    onepulse o3(NT_10_op, NT_10_db, clk);

    debounce d4(NT_50_db, NT_50, clk); 
    onepulse o4(NT_50_op, NT_50_db, clk);

    debounce d5(cancel_db, cancel, clk); 
    onepulse o5(cancel_op, cancel_db, clk);

    wire [1:0] state;
    reg [2:0] drink_selected;
    wire [7:0] current_money;
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;

    parameter [8:0] KEY_CODES_a = 9'b0_0001_1100; // right_0 => 1c
    parameter [8:0] KEY_CODES_s = 9'b0_0001_1011; // right_1 => 1b
    parameter [8:0] KEY_CODES_d = 9'b0_0010_0011; // right_2 => 23
    parameter [8:0] KEY_CODES_f = 9'b0_0010_1011; // right_3 => 2b

    KeyboardDecoder key_de (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst_n),
        .clk(clk)
    ); 

    always @ (*) begin
        case (last_change)
            KEY_CODES_a : drink_selected = 3'b000;
            KEY_CODES_s : drink_selected = 3'b001;
            KEY_CODES_d : drink_selected = 3'b010;
            KEY_CODES_f : drink_selected = 3'b011;
            default     : drink_selected = 3'b100;
        endcase
    end

    main_vending_machine m1(clk, reset, NT_5_op, NT_10_op, NT_50_op, cancel_op, drink_selected, available_drink_LED, state, current_money, last_change, key_down, been_ready); // input ??????
    display_7seg m(clk, reset, state, current_money, seg, An);
endmodule

module main_vending_machine (clk, rst_n, NT_5, NT_10, NT_50, cancel, drink_selected, available_drink_LED, state, current_money, last_change, key_down, been_ready); //input ??????
    input clk, rst_n, NT_5, NT_10, NT_50, cancel;
    input [2:0] drink_selected;
    input [511:0] key_down;
    input [8:0] last_change;
    input been_ready;
    output [3:0] available_drink_LED;
    output [7:0] current_money;
    output [1:0] state;
    
    parameter insert_money = 2'b00;
    parameter select = 2'b01;
    parameter return_money = 2'b10;
    
    reg [1:0] state, next_state;
    reg [3:0] available_drink_LED, next_available_drink_LED; //ans
    reg [7:0] current_money, next_current_money;
    reg [29:0] r_counter, next_r_counter;

    // rst_n and update value from next
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= insert_money;
            available_drink_LED <= 0;
            current_money <= 0;
            r_counter <= 0;
        end
        else begin
            state <= next_state;
            available_drink_LED <= next_available_drink_LED;
            current_money <= next_current_money;
            r_counter <= next_r_counter;
        end
    end

    always @(*) begin
        if (r_counter == 30'd100000000) next_r_counter = 30'd0;
        else begin
            if (state == return_money) next_r_counter = r_counter + 1;
            else next_r_counter = 30'd0;    
        end
    end

    // state transfer
    always @(*) begin
        case (state) 
            insert_money: begin
                if (cancel) next_state = return_money;
                else begin
                    if (been_ready && key_down[last_change] == 1'b1) begin
                        if (drink_selected == 3'b000 && current_money >= 8'd80|| 
                            drink_selected == 3'b001 && current_money >= 8'd30|| 
                            drink_selected == 3'b010 && current_money >= 8'd25|| 
                            drink_selected == 3'b011 && current_money >= 8'd20) 
                            next_state = select;
                        else next_state = insert_money;
                    end
                end
            end
            select: begin
                next_state = return_money;
            end
            return_money: begin
                next_state = (current_money == 8'd0)? insert_money : return_money;
            end
        endcase
    end
    // what state should do 
    always @(*) begin
        case (state) 
            insert_money: begin
                if (current_money < 8'd100) begin
                    if (NT_5) next_current_money = (current_money + 8'd5 < 8'd100)? current_money + 8'd5 : 8'd100;
                    else if (NT_10) next_current_money = (current_money + 8'd10 < 8'd100)? current_money + 8'd10: 8'd100;
                    else if (NT_50) next_current_money = (current_money + 8'd50 < 8'd100)? current_money + 8'd50: 8'd100;
                    else next_current_money = current_money;
                end
                else next_current_money = 8'd100;
            end
            select: begin
                if      (drink_selected == 3'b000 && current_money >= 8'd80) next_current_money = current_money - 8'd80;
                else if (drink_selected == 3'b001 && current_money >= 8'd30) next_current_money = current_money - 8'd30;
                else if (drink_selected == 3'b010 && current_money >= 8'd25) next_current_money = current_money - 8'd25;
                else if (drink_selected == 3'b011 && current_money >= 8'd20) next_current_money = current_money - 8'd20; 
                else next_current_money = current_money;
            end
            return_money: begin
                next_current_money = (r_counter == 30'd100000000)? current_money-8'd5 : current_money;
            end
        endcase
    end
    // show that which drink can buy
    always @(*) begin
        case (state) 
            insert_money: begin
                if      (current_money >= 8'd20 && current_money < 8'd25) next_available_drink_LED = {1'b0, 1'b0, 1'b0, 1'b1};
                else if (current_money >= 8'd25 && current_money < 8'd30) next_available_drink_LED = {1'b0, 1'b0, 1'b1, 1'b1};
                else if (current_money >= 8'd30 && current_money < 8'd80) next_available_drink_LED = {1'b0, 1'b1, 1'b1, 1'b1};
                else if (current_money >= 8'd80) next_available_drink_LED = {1'b1, 1'b1, 1'b1, 1'b1};
                else next_available_drink_LED = {1'b0, 1'b0, 1'b0, 1'b0};
            end
            select, return_money: begin
                next_available_drink_LED = {1'b0, 1'b0, 1'b0, 1'b0};
            end
        endcase
    end
endmodule

module display_7seg (clk, rst_n, state, current_money, seg, an);
    input clk, rst_n;
    input [1:0] state;
    input [7:0] current_money;
    output [6:0] seg;
    output [3:0] an;

    parameter insert_money = 2'b00;
    parameter select = 2'b01;
    parameter return_money = 2'b10;
    
    wire [6:0] next_seg;
    reg [6:0] seg;
    reg [3:0] an, next_an;
    reg [1:0] an_index;
    reg [3:0] displayed_item;
    
    reg [3:0] digit_1, digit_10, digit_100;

    wire display_clk;

    Clock_Divider  c(clk, rst_n, display_clk);

    toBCD t(displayed_item, next_seg);

    wire [1:0] next_an_index = (display_clk == 1) ? an_index + 1 : an_index;

    always @(*) begin
        digit_100 = (current_money/8'd100 == 1)? current_money/8'd100 : 4'd10;
        digit_10 = (((current_money%8'd100)/8'd10) > 0|| current_money/8'd100 == 1)? ((current_money%8'd100)/8'd10) : 4'd10;
        digit_1 = (current_money%8'd100)%8'd10;
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            seg <= 7'b1111111;
            an_index <= 2'b0;
            an <= 4'b1111;
        end
        else begin
            seg <= next_seg;
            an_index <= next_an_index;
            an <= next_an;
        end
    end

    always @(*) begin
        case (an_index)
            2'b11 : displayed_item = 4'd10; // empty
            2'b10 : displayed_item = digit_100; // digit_100
            2'b01 : displayed_item = digit_10; // digit_10
            2'b00 : displayed_item = digit_1; // digit_1
        endcase
    end
    
    always @(*) begin
        case (an_index)
            2'b00 : next_an = 4'b1110; 
            2'b01 : next_an = 4'b1101; 
            2'b10 : next_an = 4'b1011; 
            2'b11 : next_an = 4'b0111; 
            default : next_an = 4'b1111;
        endcase 
    end
endmodule