`timescale 1ns/1ps

module Traffic_Light_Controller_t;
    reg clk = 0;
    reg rst_n = 0;
    reg lr_has_car = 0;
    wire [2:0] hw_light, lr_light;
    // wire [3:0] state;
    // wire [7:0] hg_counter, lg_counter;
    // wire [4:0] y_counter;

    parameter cyc = 4;

    always # (cyc/2) clk = ~clk;

    Traffic_Light_Controller T1(
        .clk(clk),
        .rst_n(rst_n),
        .lr_has_car(lr_has_car),
        .hw_light(hw_light),
        .lr_light(lr_light)
        // .state(state),
        // .hg_counter(hg_counter),
        // .lg_counter(lg_counter),
        // .y_counter(y_counter)
    );

    initial begin
        clk = 1;
        rst_n = 0;
        lr_has_car = 0;
        #2 rst_n = 1'b1;
        #280 lr_has_car = 1;
        #840
        $finish;
    end

endmodule