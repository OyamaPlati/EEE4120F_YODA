`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2020 19:11:39
// Design Name: 
// Module Name: Debounce
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
module DebounceBTN(
input clk,		//input clock
input Button,  //input reset signal (external button)
output reg Flag //output reset signal (delayed)
    );
//--------------------------------------------
reg previous_state =0;
reg [14:0]Count = 0; //assume count is null on FPGA configuration // approximatly 20ms when done counting

//--------------------------------------------
always @(posedge clk) begin  	//activates every clock edge
 //previous_state <= Button;		// localise the reset signal
   if (Button && Button != previous_state && Count == 0) begin		// reset block
    Flag <= 1'b1;					// reset the output to 1
	 Count <= 1;
	 previous_state <= 1;
  end 
  else if (Button && Button != previous_state) begin
	 Flag <= 1'b0;	
	 Count <= Count + 1'b1;
  end 
  else begin
	 Flag <= 1'b0;	
	 previous_state <= Button;
	 Count <= 0;
  end

end //always
 //--------------------------------------------
endmodule
//------------------------------------