`timescale 1ns / 1ps
module SW_Decoder(
     input [15:0]SW,
     output reg [3:0]SW_Value
    );
    
    //------------------------------------------------------------------------------
    // Combinational circuit to convert switch input to a hex value output

    
    always @(*) begin

        case(SW)
            // gfedcba
            16'b0000000000000001 :  SW_Value <= 4'd0;
            16'b0000000000000011 :  SW_Value <= 4'd1;
            16'b0000000000000111 :  SW_Value <= 4'd2;
            16'b0000000000001111 :  SW_Value <= 4'd3;
            16'b0000000000011111 :  SW_Value <= 4'd4;
            16'b0000000000111111 :  SW_Value <= 4'd5;
            16'b0000000001111111 :  SW_Value <= 4'd6;
            16'b0000000011111111 :  SW_Value <= 4'd7;
            16'b0000000111111111 :  SW_Value <= 4'd8;
            16'b0000001111111111 :  SW_Value <= 4'd9;
            16'b0000011111111111 :  SW_Value <= 4'd10; //a
            16'b0000111111111111 :  SW_Value <= 4'd11; //b
            16'b0001111111111111 :  SW_Value <= 4'd12; //c
            16'b0011111111111111 :  SW_Value <= 4'd13; //d
            16'b0111111111111111 :  SW_Value <= 4'd14; //e
            16'b1111111111111111 :  SW_Value <= 4'd15; //f
            default:                SW_Value <= 4'b0;
        endcase
    end
    //---------------------------------------------------------------------------------
    
endmodule