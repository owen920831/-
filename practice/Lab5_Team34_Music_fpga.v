module music_fpga (
    input clk,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    output pmod_1,	//AIN
	output pmod_2,	//GAIN
	output pmod_4	//SHUTDOWN_N
);
    wire [31:0] freq;
    assign pmod_2 = 1'd1;	//no gain(6dB)
    assign pmod_4 = 1'd1;	//turn-on

    parameter [8:0] KEY_CODES_ent = 9'b0_0101_1010; // enter => 5A
    parameter [8:0] KEY_CODES_s = 9'b0_0001_1011; // s => 1b
    parameter [8:0] KEY_CODES_w = 9'b0_0001_1101; // w => 1D
    parameter [8:0] KEY_CODES_r = 9'b0_0010_1101; // f => 2D

    KeyboardDecoder key_de (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(0),
        .clk(clk)
    ); 

    

        
    Decoder decoder00 (
        .tone(tone),
        .freq(freq)
    );

    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(freq),
        .duty(10'd512), 
        .PWM(pmod_1)
    );
endmodule

module music_main (
    input clk,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    in
);

    

    
endmodule
