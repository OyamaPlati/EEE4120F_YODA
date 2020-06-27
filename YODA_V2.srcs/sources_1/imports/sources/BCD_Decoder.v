`timescale 1ns / 1ps
module BCD_Decoder(
     input [3:0]BCD,
     output reg [6:0]SevenSegment
    );
    
    //------------------------------------------------------------------------------
    // Combinational circuit to convert BCD input to seven-segment output
    always @(BCD) 
    begin
    case(BCD)
        // gfedcba
        4'd0 : SevenSegment <= 7'b0111111;  //3F     a
        4'd1 : SevenSegment <= 7'b0000110;  //06    ----
        4'd2 : SevenSegment <= 7'b1011011;  //5B   |   |
        4'd3 : SevenSegment <= 7'b1001111;  //4F  f| g |b
        4'd4 : SevenSegment <= 7'b1100110;  //66    ----
        4'd5 : SevenSegment <= 7'b1101101;  //6D   |   |
        4'd6 : SevenSegment <= 7'b1111101;  //7D  e|   |c
        4'd7 : SevenSegment <= 7'b0000111;  //07    ----
        4'd8 : SevenSegment <= 7'b1111111;  //7F     d
        4'd9 : SevenSegment <= 7'b1101111;  //6F
        4'd10 : SevenSegment <= 7'b1110111;  //a   
        4'd11 : SevenSegment <= 7'b1111100;  //b
        4'd12 : SevenSegment <= 7'b1011000;  //c     
        4'd13 : SevenSegment <= 7'b1011110;  //d
        4'd14 : SevenSegment <= 7'b1001111;  //e
        4'd15 : SevenSegment <= 7'b1110001;  //f   
    default: SevenSegment <= 7'b0000000;
    endcase
    end
    //---------------------------------------------------------------------------------
    
endmodule
