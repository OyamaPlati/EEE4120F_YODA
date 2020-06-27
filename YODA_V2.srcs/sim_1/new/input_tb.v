`timescale 1ns / 1ps

module input_tb();

        reg   CLK100MHZ;
        reg   BTNU;      //Up -- Clear current entry
        reg   BTNL;       //left -- Back to brevious entry
        reg   BTNR;       //Right -- next
        reg   BTNC;     //Center -- Reset
        reg   [15:0] SW;   //Switches represesnt (0-F)
        
        wire    [15:0]to_display;     //whatevr is in here will be displayed on the screen
        wire     [3:0]SegmentDrivers;        //Anode signals of the 7-segment LED display
        wire     [7:0]SevenSegment;          //Cathode patterns of the 7-segment LED display


Input_module inputModule(        
        CLK100MHZ,
        BTNU,       //Up -- Clear current entry
        BTNL,       //left -- Back to brevious entry
        BTNR,       //Right -- next
        BTNC,       //Center -- Reset
        SW,    //Switches represesnt (0-F)
        to_display,     //whatevr is in here will be displayed on the screen
        SegmentDrivers,        //Anode signals of the 7-segment LED display
        SevenSegment           //Cathode patterns of the 7-segment LED display
);

initial begin
        //$display("\t\t\t\t\ttime\tclock\treset\tpattern\tpattern-length\tblock\tblock-length\tdone"); // \tfound
        CLK100MHZ <= 0;
        BTNC = 0;
        BTNU = 0;
        BTNL = 0;
        BTNR = 0;
        SW = 16'd0; 


        #5;
        BTNC = 1; #5
        BTNC = 0;#1
        SW = 16'b0000000000000011;#10 
        BTNR = 1; #1 BTNR =0;  //1
        SW = 16'b0000000000000111;#2 
        BTNR = 1; #1 BTNR =0; // 2
        SW = 16'b0000000000001111;#2 
        BTNR = 1; #1 BTNR =0; //3
        SW = 16'b0000000000011111;#2 BTNR = 1; #1 BTNR =0;#10 //4   --- 
        SW = 16'b0000000000000111;#2 BTNR = 1; #1 BTNR =0; //2
        SW = 16'b0011111111111111;#2 BTNR = 1; #1 BTNR =0;//14
        SW = 16'b0000000000111111;#2 BTNR = 1; #1 BTNR =0; //5
        SW = 16'b0000000011111111;#2 BTNR = 1; #1 BTNR =0; //7 ---
        SW = 16'b0001111111111111;#2 BTNR = 1; #1 BTNR =0; //13
        SW = 16'b1111111111111111;#2 BTNR = 1; #1 BTNR =0; //15
        SW = 16'b0000100111111111;#2 BTNR = 1; #1 BTNR =0; //0
        SW = 16'b0000000111111111;#2 BTNR = 1; #1 BTNR =0; //8  ---
        SW = 16'b0000000000111111;#2 BTNR = 1; #1 BTNR =0; //13
        SW = 16'b1111111111111111;#2 BTNR = 1; #1 BTNR =0; //15
        SW = 16'b0000000000111111;#2 BTNR = 1; #1 BTNR =0; //0
        SW = 16'b0000000111111111;#2 BTNR = 1; #1 BTNR =0; //8  ---
        SW = 16'b0001111111111111;#2 BTNR = 1; #1 BTNR =0; //13
        SW = 16'b0000000001111111;#2 BTNR = 1; #1 BTNR =0; //15
        SW = 16'b1111111111111111;#2 BTNR = 1; #1 BTNR =0; //0
        SW = 16'b0000111111111111;#2 BTNR = 1; #1 BTNR =0; //8  ---
        
        
        
    end

    always begin
        // do a clock pulse
        #1 CLK100MHZ = ~CLK100MHZ;
    end



endmodule
