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


module Input_module(
        // Inputs
        input   CLK100MHZ,
        input   BTNU,       //Up -- Clear current entry
        input   BTNL,       //left -- Back to brevious entry
        input   BTNR,       //Right -- next
        input   BTNC,       //Center -- Reset
        input   [15:0] SW,    //Switches represesnt (0-F)
        
        output reg [15:0]to_display,     //whatevr is in here will be displayed on the screen
        output     [3:0]SegmentDrivers,        //Anode signals of the 7-segment LED display
        output     [7:0]SevenSegment           //Cathode patterns of the 7-segment LED display
    );
    
    parameter DISP_WIDTH = 16;  // word size of the memory
    parameter ADDR_WIDTH = 32;  // number of memory words, e.g. 2^8-1
    
    // create registers   
    reg [ADDR_WIDTH-1:0]patternAddr;      //stores the adress of teh start of the pattern
    reg [ADDR_WIDTH-1:0]patternLen;       //stores the length address in binary
    reg [ADDR_WIDTH-1:0]memAddr;          //stores the strt address of the block of memeory to search
    reg [ADDR_WIDTH-1:0]memLen;           //Stores the size of teh block of memeory to be searched
    reg done;              //indicates if if teh psa module is done searching
    reg [ADDR_WIDTH-1: 0]found;
    reg [3:0] seq = 0;                    //allows us to track what is being entered
    reg resetPSA =0;
    wire pwm_out;
    
    //create buttons
    wire clearBTN,backBTN,nextBTN,resetBTN;
    DebounceBTN DebounceU(CLK100MHZ, BTNU, clearBTN);
	DebounceBTN DebounceL(CLK100MHZ, BTNL, backBTN);
	DebounceBTN DebounceR(CLK100MHZ, BTNR, nextBTN);
	DebounceBTN DebounceC(CLK100MHZ, BTNC, resetBTN);

	//debounce all switches 
	wire [15:0]inputSW;
	DebounceBTN DebounceSW00(CLK100MHZ, SW[0], inputSW[0]);
	DebounceBTN DebounceSW01(CLK100MHZ, SW[1], inputSW[1]);
	DebounceBTN DebounceSW02(CLK100MHZ, SW[2], inputSW[2]);
	DebounceBTN DebounceSW03(CLK100MHZ, SW[3], inputSW[3]);
	DebounceBTN DebounceSW04(CLK100MHZ, SW[4], inputSW[4]);
	DebounceBTN DebounceSW05(CLK100MHZ, SW[5], inputSW[5]);
	DebounceBTN DebounceSW06(CLK100MHZ, SW[6], inputSW[6]);
	DebounceBTN DebounceSW07(CLK100MHZ, SW[7], inputSW[7]);
	DebounceBTN DebounceSW08(CLK100MHZ, SW[8], inputSW[8]);
	DebounceBTN DebounceSW09(CLK100MHZ, SW[9], inputSW[9]);
	DebounceBTN DebounceSW10(CLK100MHZ, SW[10], inputSW[10]);
	DebounceBTN DebounceSW11(CLK100MHZ, SW[11], inputSW[11]);
	DebounceBTN DebounceSW12(CLK100MHZ, SW[12], inputSW[12]);
	DebounceBTN DebounceSW13(CLK100MHZ, SW[13], inputSW[13]);
	DebounceBTN DebounceSW14(CLK100MHZ, SW[14], inputSW[14]);
	DebounceBTN DebounceSW15(CLK100MHZ, SW[15], inputSW[15]);
    
    wire [3:0] SW_Value; // should only have a value for 1 clk cycle and then resturn to zero
    PWM pwm(CLK100MHZ,pwm_out);
    DisplayDriver DisplayDriver0(CLK100MHZ,pwm_out,SW_Value,SegmentDrivers,SevenSegment);
    SW_Decoder SWDecoder(SW,SW_Value); //on every change of SW ahould update the SW_value (after debouncing)
    
    // doesnt sythesize with psa module
    //PSA PSA0(CLK100MHZ,resetPSA,patternAddr,patternLEn,memAddr,memLen,done,found);
    
    reg [((ADDR_WIDTH)/4)-1:0]inputChar = 1;  //stores the index of the current hex character to be inputted by SW. 
        
	always @(posedge CLK100MHZ) begin              //Main FSM that contains each state
	   
	   if(resetBTN == 1) begin
	   $display("Reset system");
        	to_display  <= 0;     
            patternAddr <= 0;     
            patternLen  <= 0;       
            memAddr     <= 0;         
            memLen      <= 0;
            done        <= 0; 
            found       <= 0;  
            seq         <= 0;     
            inputChar   <= 1;  
	   end 
	   else begin
	       case (seq) 
	           4'b0001 : begin  //enter pattern address 
	           $display("Enter pattern adresss character %d \t toDisplay = %h",inputChar,to_display);
	                       if (clearBTN) begin
	                           patternAddr = 0;
	                           inputChar   = 1;
	                       end
	                       else if(backBTN) begin
                               if(seq == 0) begin
                                   seq = 0;
                               end
                               else begin
                                   seq = seq - 1;
                               end
                           end
	                       else if ((inputChar == 1<< (DISP_WIDTH/4 -1)) && nextBTN == 1) begin   
	                           seq         = seq +1;
	                           inputChar   = 1;
	                       end
	                       else if ((inputChar == 1<< (DISP_WIDTH/4 -1))) begin   
	                           inputChar   = 1<< (DISP_WIDTH/4 -1);
	                       end
	                       else begin
	                       $display("patternaddr %b  \t  sw value %b\n",patternAddr,SW_Value);
                               patternAddr[3:0] = SW_Value;
                               patternAddr      = patternAddr << 4;     	  
	                           inputChar        = inputChar << 1;   
	                           to_display       = patternAddr;
	                       end
	                   end
	           4'b0010 : begin  //enter pattern length
	           $display("Enter pattern length character %d \t toDisplay = %h",inputChar,to_display);
	                       if (clearBTN) begin
	                           patternLen  = 0;
	                           inputChar   = 1;
	                       end
	                       else if(backBTN) begin
                               if(seq == 0) begin
                                   seq = 0;
                               end
                               else begin
                                   seq = seq - 1;
                               end
                           end
	                       else if ((inputChar == 1<< (DISP_WIDTH/4 -1)) && nextBTN == 1) begin   
	                           seq         = seq +1;
	                           inputChar   = 1;
	                       end
	                       else if ((inputChar == 1<< (DISP_WIDTH/4 -1))) begin   
	                           inputChar   = 1<< (DISP_WIDTH/4 -1);
	                       end
	                       else begin
	                       $display("patternaddr %b  \t  sw value %b\n",patternLen[3:0],SW_Value);
                               patternLen[3:0] = SW_Value;
                               to_display      =  patternLen; 
                               patternLen      = patternLen << 4;     	  
	                           inputChar       = inputChar << 1;  
	                           
	                       end
	                   end
	           4'b0011 : begin  //enter block address
	           $display("Enter mem adresss character %d \t toDisplay = %h",inputChar,to_display);
	                       if (clearBTN) begin
	                           memAddr     = 0;
	                           inputChar   = 1;
	                       end
	                       else if(backBTN) begin
                               if(seq == 0) begin
                                   seq = 0;
                               end
                               else begin
                                   seq = seq - 1;
                               end
                           end
	                       else if ((inputChar == 1<< (DISP_WIDTH/4 -1)) && nextBTN == 1) begin   
	                           seq         = seq +1;
	                           inputChar   = 1;
	                       end
	                       else if ((inputChar == 1<< (DISP_WIDTH/4 -1))) begin   
	                           inputChar   = 1<< (DISP_WIDTH/4 -1);
	                       end
	                       else begin
                               memAddr[3:0] = SW_Value;
                               to_display   =  memAddr;
                               memAddr      = memAddr << 4;     	  
	                           inputChar    = inputChar << 1;   
	                           
	                       end
	                   end
	           4'b0100 : begin //enter block length
	           $display("Enter mem length character %d \t toDisplay = %h",inputChar,to_display);
	                       if (clearBTN == 1) begin
	                           memLen      = 0;
	                           inputChar   = 1;
	                       end
	                       else if(backBTN) begin
                               if(seq == 0) begin
                                   seq = 0;
                               end
                               else begin
                                   seq = seq - 1;
                               end
                           end
	                       else if ((inputChar == 1<< (DISP_WIDTH/4 -1)) && nextBTN) begin   
	                           seq         = seq +1;
	                           inputChar   = 1;
	                       end
	                       else if ((inputChar == 1<< (DISP_WIDTH/4 -1))) begin   
	                           inputChar   = 1;
	                       end
	                       else begin
                               memLen[3:0]      = SW_Value;
                               to_display       =  memLen;
                               memLen           = memLen << 4;     	  
	                           inputChar        = inputChar << 1;   
	                           
	                       end
	                   end
	           4'b0101 : begin // seraching
	           $display("Searching");
	                       if (done) begin 
	                           seq = seq +1;
	                       end
	                       else begin
	                       // not sure how to start the PSA
	                       
	                       end
	                   end
	           4'b0111 : begin // display start address of pattern
	           $display("Pattern founf at : XXXX");
	                       if(nextBTN) begin
	                           seq  = 0;
	                       end
                           else begin	           
                               to_display  = found;
                           end
	                   end
	           default : begin // display start address of pattern
	           $display("Default case");
	                       to_display  = 16'hFFFF;
	                       if(nextBTN) begin
	                           seq  = seq +1;
	                       end
	                   end
	       endcase
	   end
	end

	
	
endmodule





