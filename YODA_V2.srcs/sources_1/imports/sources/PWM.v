`timescale 1ns / 1ps

module PWM(
    input clk,			//input clock
    output reg pwm_out 	//output of PWM
    );
    
    // Counter to reduce the 100 MHz clock to 762.939 Hz (100 MHz / 2^17)
    reg [16:0] Count =0;
    reg [7:0]pwm_in = 8'b00011111;
    
    always @(posedge clk) begin
    //$display("PWMin: %b       PEM_OUT %b \n", pwm_in,pwm_out);
        Count <= Count + 1'b1;
        if (Count <= (pwm_in << 9)) pwm_out <= 1;	
        else pwm_out <= 0;
    end
    
endmodule