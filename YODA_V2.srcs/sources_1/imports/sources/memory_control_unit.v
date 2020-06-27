`timescale 1ns / 1ps

module memory_control_unit(
      clk    ,   // clock input
      we     ,   // write enable
      w_addr ,   // write address
      w_data ,   // write data
      re     ,   // read enable 
      r_addr ,   // read address
      cs     ,   // chip select (i.e. chip ignores inputs if cs=0)
      r_data     // output for read operation
    );
  
  // Setup some parameters
  parameter DATA_WIDTH = 8;  // word size of the memory
  parameter ADDR_WIDTH = 8;  // number of memory words, e.g. 2^8-1
  parameter RAM_DEPTH  = 1 << ADDR_WIDTH;
  
  // Define inputs
  input clk, we, re, cs;
  input  [ADDR_WIDTH-1:0] r_addr, w_addr;
  input  [DATA_WIDTH-1:0] w_data;
  output reg [DATA_WIDTH-1:0] r_data;
  
  // Private registers
  reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1]; // Set up the memory array
  
  // Write to or read from memory
  always@ (posedge clk)
  begin
  if (cs)
   begin
     if (we) mem[w_addr] <= w_data;
     if (re) r_data <= mem[r_addr];
   end
  end
endmodule
