`timescale 1ns / 1ps
// Slow clock for looping
module slow_clk (input Clk_100M, output reg clk_div);
    reg [26:0] counter = 0;
    always @(posedge Clk_100M)
    begin
        counter <= (counter >= 249999) ? 0 : counter+1;
        clk_div <= (counter < 125000) ? 1'b0 : 1'b1;
    end
endmodule
