`timescale 1ns / 1ps

module PSA (
        // input ports
        clk, // clock to activate the PSA and tell it to continue searching from last address
        reset, // set b and clock reset to tell the PSA to start searching from address b
        pattern, // the pattern to be searched for
        pattern_length, // length of the pattern in bytes
        block, // address of the block of memory to search
        block_length,
        // output ports
        done, // the PSA sets this to high when it is complete
        found // pl + the start of the pattern that was found. 
    );
    
    // setup parameters
    parameter DATA_WIDTH = 8;  // word size of the memory
    parameter ADDR_WIDTH = 8;  // number of memory words, e.g. 2^8-1
    parameter RAM_DEPTH  = 1 << ADDR_WIDTH;
    
    // define inputs
    input clk, reset; 
    input wire [ADDR_WIDTH-1:0] pattern;
    input wire [DATA_WIDTH-1:0] pattern_length;
    input wire [ADDR_WIDTH-1:0] block;
    input wire [DATA_WIDTH-1:0] block_length;
    
    // define outputs
    output done;
    output wire [DATA_WIDTH-1: 0] found;
    
    // define private registers
    reg [DATA_WIDTH-1:0] block_memory [0:RAM_DEPTH-1]; // Set up the block memory array    
    reg                    ping;
    reg [DATA_WIDTH-1:0]   match_location;
    integer                    i;
    integer                    k;
    reg [DATA_WIDTH-1:0]   match;
    reg [DATA_WIDTH-1:0]   key;
    
    initial begin
         $readmemh("bram_memory.mem", block_memory);
    end
    
    assign found = match_location; // get location of matching pattern in block memory
    assign done  = ping;           // alert found found match
    
    always @(posedge clk) begin
        if (reset) begin
            ping  <= 0;
            match_location <= 8'h00;
            i     <= pattern;       // set the input
            k     <= block;         // set the input
        end
        else begin   
             // Main PSA logic
             // The following is a rolled out for loop, we iterate through the patterns (keys)
             if (i <= (pattern + pattern_length)) 
                 begin
                    key <= block_memory[i];
                    i <= i + 1;
                 end
                 
            if (i > (pattern + pattern_length))
                begin
                    ping <= 1;
                    match_location <= 8'hff;
                end
        end
    end
    
    /* 
        for each key search throught the block to find matches
    */
    always @(key) begin
        for (k = block; k <= (block + block_length);  k = k + 1)
            begin
                if (block_memory[k] == key)
                    begin
                       // we've found match, alert user 
                       ping <= 1; 
                       match_location <= pattern_length + i;
                    end
            end    
    end
endmodule
