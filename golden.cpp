/**
 EEE4120F YODA pattern seek accelerator golden measure.
 The PSA searches for a particular sequence of bytes in a block of memory.
 The PSA does not have any optimisation or algorithm to accelerate the search.
 */

/* Library Includes */
#include <iostream>
#include <bits/stdc++.h> 


/* Name space includes */
using namespace std;

/** Define BYTE type which is an 8-bit unsigned quantity. */
typedef unsigned char BYTE;

/** Define hard-coded test vector. */
BYTE mem_raw[200] = {20, 88, 76, 12, 87, 20, 75, 65, 55, 75, 51, 79, 69, 26, 
					   24, 93, 42, 85, 61, 39, 70, 65, 6, 59, 90, 68, 99, 65, 37,
					   49, 31, 93, 55, 25, 36, 98, 13, 87, 85, 62, 44, 43, 96, 2,
				       46, 87, 58, 27, 24, 19, 49, 6, 12, 92, 59, 11, 53, 68, 57,
					   70, 72, 33, 62, 88, 32, 37, 90, 62, 99, 87, 37, 64, 40, 68,
					   66, 90, 15, 11, 12, 5, 70, 78, 77, 50, 83, 98, 93, 1, 48, 91,
					   56, 52, 93, 11, 26, 91, 43, 61, 19, 38}; 

/** Define tic() and toc() functions */
stack<clock_t> tictoc_stack;

void tic() 
{
    tictoc_stack.push(clock());
}

void toc() 
{
    cout      << "Time elapsed: "
              << ((double)(clock() - tictoc_stack.top())) / CLOCKS_PER_SEC
              << endl;
    tictoc_stack.pop();
}

void PSA ( 
		   // inputs 
		   int     reset,          // set b and clock reset to tell the PSA to start searching from address b
           
           int     pattern,        // start position of the pattern to be searched for (address)
           BYTE    pattern_length, // length of the pattern in bytes
           int     block,          // start position of the block of memory to search (address)
           BYTE    block_length,   // length of the block in bytes
           
           // outputs
           int    done,           // the PSA sets this to high when it is complete
           int    found           // pl + the start of the pattern that was found.
		)
{
    
    static unsigned int n;
    static unsigned int m;
    
    if (reset) 
	{
		m = 0;
        n = 0;
        done = 0;
        found = 0; 
    } 
	else 
	{
		printf("PSA to start searching from address 0x%x\n", block);
		int i = 0;
		int match = 0;
		for (n = pattern; n < (pattern_length + pattern); n ++) {
			printf("The PSA now proceeds to do the %d search\n", (i+1));
		    i++;
		    match = mem_raw[n];
			for (m = block; m < (block_length + block); m ++) {
								
				if ( match == mem_raw[m] ) {
					// printf("PSA.match = %i; PSA.key = %i \n", match, mem_raw[m]);
					done = 1;
					found = pattern_length + n;
					printf("PSA.done = %d; PSA.found = 0x%x;\n", done, found);
				}
			}
		}
		
		printf("No more matches\n");
		done = 1;
		found = 255;
		printf("PSA.done = %d; PSA.found = 0x%x;\n", done, found);
	}
}

/** Entry point to this application which implements the PSA routine. */
int main()
{

	// reset the PSA module
	PSA (1, 0, 0, 0, 0, 0, 0);
	
	// process the PSA TEST
	/**
		reset = 0;
		start at position 50 
		pattern length 4 i.e end at 54  = {49, 6, 12, 92}
		
		start at position 40
		block length 20 i.e end at 60 = {85, 62, 44, 43, 96, 2, 46, 87, 58, 27,
										 24, 19, 49, 6, 12, 92, 59, 11, 53, 68, 57}
	**/
	
	tic();
	PSA (0, 0, 5, 0, 20, 0, 0);
	toc();
	
    // return success
    return 0;
}
