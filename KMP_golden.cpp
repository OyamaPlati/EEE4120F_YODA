// C++ program for implementation of KMP pattern searching 
// algorithm 
#include <bits/stdc++.h> 

/** Define BYTE type which is an 8-bit unsigned quantity. */
typedef unsigned char BYTE;

/** Define hard-coded test vector. */
BYTE mem_raw[200] = {	20, 88, 76, 12, 87, 20, 75, 65 , 55, 75, 51, 79, 69, 26, 
					   	24, 93, 42, 85, 61, 39, 70, 65, 6, 59, 90, 68, 99, 65, 37,
					   	49, 31, 93, 55, 25, 36, 98, 13, 87, 85, 62, 44, 43, 96, 2,
				       	46, 87, 58, 27, 24, 19, 49, 6, 12, 92, 59, 11, 53, 68, 57,
					   	70, 72, 33, 62, 88, 32, 37, 90, 62, 99, 87, 37, 64, 40, 68,
					   	66, 90, 15, 11, 12, 5, 70, 78, 77, 50, 83, 98, 93, 1, 48, 91,
					   	56, 52, 93, 11, 26, 91, 43, 61, 19, 38, 20, 88, 76, 12, 87, 20, 75, 65 , 55, 75, 51, 79, 69, 26, 
					   	24, 93, 42, 85, 61, 39, 70, 65, 6, 59, 90, 68, 99, 65, 37,
					   	49, 31, 93, 55, 25, 36, 98, 13, 87, 85, 62, 44, 43, 96, 2,
				       	46, 87, 58, 27, 24, 19, 49, 6, 12, 92, 59, 11, 53, 68, 57,
					   	70, 72, 33, 62, 88, 32, 37, 90, 62, 99, 87, 37, 64, 40, 68,
					   	66, 90, 15, 11, 12, 5, 70, 78, 77, 50, 83, 98, 93, 1, 48, 91,
					   	56, 52, 93, 11, 26, 91, 43, 61, 19, 38};

/** Define preprocess frunction */
void preProcess(BYTE* pat, int M, int* lps); 

/** Define tic() and toc() functions */
std::stack<clock_t> tictoc_stack;

void tic() {
    tictoc_stack.push(clock());
}

void toc() {
    std::cout << "Time elapsed: "
              << ((float)(clock() - tictoc_stack.top())) / CLOCKS_PER_SEC
              << std::endl;
    tictoc_stack.pop();
}

void PSA( 
		   // inputs 
		   int      reset,              // set b and clock reset to tell the PSA to start searching from address b
           
           int      pattern,            // start position of the pattern to be searched for (address)
           BYTE     pattern_length,     // length of the pattern in bytes
           int      block,              // start position of the block of memory to search (address)
           BYTE     block_length,       // length of the block in bytes
           
           // outputs
           int    done,                 // the PSA sets this to high when it is complete
           int    found                 // pl + the start of the pattern that was found.
		   ) 
{   
    int lps[pattern_length];            // create lps[] that will hold the longest prefix suffix values for pattern
    //Define vairalbes for lps calculation
    int len = pattern;                  //length of longest lps for substring of pattern
    int k = pattern + 1;                //index of pattern and length of substring pattern
    //Define variables for search algorithm
    int i = block;                      // index for block to search [block,end of block]
    int j = pattern;                    // index for pattern to search starts at address given [pattern start,pattern end]
  

    if(reset){
        done =0;
        found =0;
    }
    else{
        /* Preprocess the pattern (calculate lps[] array) ***********************************************
        Preprocess the data by finding the length of the lowest proper prefix of the pattern to be found 
        the length of the lpf for the first i charaters of the pattern is stored in the lps[] array  */
        
        lps[0] = 0; // lps[0] is always 0 
  
        while (k < pattern_length + pattern) { 
            if (mem_raw[k] == mem_raw[len]) { 
                len++; 
                lps[k - pattern] = len - pattern; 
                k++; 
            } 
            else // (pat[i] != pat[len]) 
            {  
                if ((len - pattern) != 0) { 
                len = lps[len - 1 - pattern] + pattern; 

                } 
                else // if (len == 0) 
                { 
                    lps[k -pattern] = 0; 
                    k++; 
                } 
            } 
        } 

        printf("Pattern processed, lps[] populated: ");
        for(int loop = 0; loop < pattern_length; loop++){
        printf("%d ", lps[loop]);
        }
        printf("\n");
        //**************************************************************************************************/

        while (i < block_length + block) { 
            if (mem_raw[j] == mem_raw[i]) { 
                j++; 
                i++; 
            } 
    
            if ((j - pattern) == pattern_length) { 
                printf("PSA.Found =%d Found pattern at index %d \n",found, i - pattern_length); 
                j = lps[j - 1 - pattern] + pattern; 
            } 
    
            // mismatch after j matches 
            else if ((i - block) < block_length && mem_raw[j] != mem_raw[i]) { 
                // Do not match lps[0..lps[j-1]] characters, 
                // they will match anyway 
                if ((j - pattern) != 0) 
                    j = lps[j - 1 - pattern] + pattern; 
                else
                    i = i + 1; 
            } 
        } 
    }
    
} 




/** Entry point to this application which implements the PSA routine. */
int main()
{
 
    PSA (1, 0, 0, 0, 0, 0, 0);

    tic();
    PSA(0,50,4,0,200,0,0);
    toc();
      
    // return success
    return 0;
}