`timescale 1ns / 1ps

module PSA (
        // define inputs
        input CLK100MHZ,  wire reset, 
        input [15:0] SW,
        
        // define outputs
        output [1:0] LED
        //output LED16_B
        /*output [3:0] SegmentDrivers,
        output [7:0] SevenSegment*/
    );
    
    // setup parameters
    parameter DATA_WIDTH = 8;  // word size of the memory
    parameter ADDR_WIDTH = 8;  // number of memory words, e.g. 2^8-1
    parameter RAM_DEPTH  = 1 << ADDR_WIDTH;
    
    // define private registers
    wire [4:0] pattern; // the pattern to be searched for
    wire [4:0] pattern_length; // length of the pattern
    wire [4:0] block; // address of the block of memory to search
    wire [4:0] block_length; // length of the block
    
    reg [DATA_WIDTH-1:0] block_memory [0:RAM_DEPTH-1]; // Set up the block memory array    
    reg [1:0] ping;
    reg [DATA_WIDTH-1:0] key = 0;
    //reg found; // pl + the start of the pattern that was found.
    
    // add the reset
    
    wire clk_div;
    slow_clk clock (CLK100MHZ, clk_div);
    
    //assign LED = ping;
    /* set up PWM
    wire pwm_out;
    PWM pwm (CLK100MHZ, SW, pwm_out);
    
    // Initialize seven segment
	SS_Driver SSDriver (
		CLK100MHZ, reset, pwm_out,
		found [15:12], found [11:8], found [7:4], found [3:0], // Use temporary test values before adding hours2, hours1, mins2, mins1
		SegmentDrivers, SevenSegment
	);*/
    
    // add the bram
    initial begin
         $readmemh("bram_memory.mem", block_memory);
    end
    
    // assigning input switches to internal signals 
    assign pattern = SW [15:12];
    assign pattern_length = SW [11:8];
    assign block = SW [7:4];
    assign block_length = SW [3:0];
    
    integer k;
    always @(posedge CLK100MHZ) begin
        if (reset) begin
            ping <= 2'b00;
            //found <= 0;
            $display ("RESET = %b: Insert inputs -->\n", reset);
            // partition sections of the switches to the inputs
            k <= pattern; 
            $display ("P: %d  PL: %d B: %d BL: %d\n", pattern, pattern_length, block, block_length);
        end
        else begin   
             // Main PSA logic
             $display ("RESET = %b: Perform PSA -->\n", reset);
             // The following is a rolled out for loop, we iterate through the patterns (keys)
             if (k < (pattern + pattern_length + 1)) 
                 begin
                    key <= block_memory[k];
                    k <= k + 1;
                 end
                 
            if (k > (pattern + pattern_length + 1))
                begin
                    ping <= 2'b00;
                    //found <= 0;
                end
        end
    end
    
    integer j;
    always @(key) begin
        for (j = 0; j < 256; j = j + 1) begin
            if (j < (block + block_length + 1))
                begin
                    $display ("Compare -> block value [j = %d] = %h : pattern value = %h", 
                        j, block_memory[j], key);
                    if (block_memory[j] == key)
                        begin
                            $display ("we've found match, alert user");
                            // we've found match, alert user 
                            ping <= 2'b11;
                            //found <= 1;
                        end
                end
        end
    end
    
    // assigning internal signals to output LEDs
    assign LED [0] = ping [0];
    assign LED [1] = ping [1];
    //assign LED16_B = found; 
endmodule
