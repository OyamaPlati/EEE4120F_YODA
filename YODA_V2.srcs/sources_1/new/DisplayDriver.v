`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2020 17:14:28
// Design Name: 
// Module Name: DisplayDriver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DisplayDriver(
            input clk,
            input pwm,
            input wire [15:0]to_display,
            
            output reg [3:0] SegmentDrivers = 4'hE, // Digit drivers (active low)
            output reg [7:0] SevenSegment // Segments (active low)

    );
    
    
// Make use of a subcircuit to decode the BCD to seven-segment (SS)
wire [6:0] SS [3:0];
BCD_Decoder BCD_Decoder0 (to_display[15:12], SS[0]);     //mins1
BCD_Decoder BCD_Decoder1 (to_display[11:8], SS[1]);     //mins2
BCD_Decoder BCD_Decoder2 (to_display[7:4], SS[2]);     //hours1
BCD_Decoder BCD_Decoder3 (to_display[3:0], SS[3]);     //hours2

// Counter to reduce the 100 MHz clock to 762.939 Hz (100 MHz / 2^17)
reg [16:0]Count = 0; //17 bits

// Scroll through the digits, switching one on at a time
always @(posedge clk) begin
    Count <= Count + 1'b1;
    if(&Count) begin
        SegmentDrivers <= {SegmentDrivers[2:0], SegmentDrivers[3]};
    end
end
//------------------------------------------------------------------------------
always @(*) begin // This describes a purely combinational circuit
    //$display("hour2 :%b  hour1:%b min2:%b   min1%b\n", SS[3],SS[2],SS[1],SS[0]);
    //$display("SegmentDrivers : %b  SevenSegment : %b\n", SegmentDrivers, SevenSegment);
    //$display("PWM: %b \n", PWM);
    SevenSegment[7] <= 1'b1; // Decimal point always off
    if(pwm) begin // if need to turn the seven segment on or not. if (pwm_out)
        case(~SegmentDrivers) // Connect the correct signals,
            4'h1 : SevenSegment[6:0] <= ~SS[0]; // depending on which digit is on at
            4'h2 : SevenSegment[6:0] <= ~SS[1]; // this point
            4'h4 : SevenSegment[6:0] <= ~SS[2];
            4'h8 : SevenSegment[6:0] <= ~SS[3];
            default: SevenSegment[6:0] <= 7'h7F;
        endcase
     end 
     else begin
         SevenSegment[6:0] <= 7'h7F;
     end
end

endmodule

