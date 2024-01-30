//File: VlogMem_to_QuartusMIF.c
#include <stdio.h>
#include <string.h>

#include <stdio.h>
#define  DEPTH   (1024/4 )
#define WIDTH   32
#define  ADDRESS_RADIX  "HEX"
#define  DATA_RADIX "HEX" 
#define USAGE_REF "https://www.intel.com/content/www/us/en/programmable/quartushelp/current/index.htm#hdl/vlog/vlog_file_dir_ram_init.htm"

int main(int argc, char* argv[])
{

	unsigned long data32; 
	unsigned int  abyte[4];
	int nb; 
	int i=0; 
        char line[256];
	int address_counter =  0; 
	printf("\n-- Memory initialization File (MIF) for quartus ram/rom init \n" );
	printf("\n-- Usage see : %s\n",USAGE_REF );
	printf("\nDEPTH = %d; \n",DEPTH );
	printf("WIDTH = %d; \n", WIDTH);
	printf("ADDRESS_RADIX = %s; \n", ADDRESS_RADIX);
	printf(" DATA_RADIX = %s; \n",  DATA_RADIX);	
	printf(" CONTENT  \n");
	printf(" BEGIN  \n");

        while (fgets(line, sizeof(line), stdin)) 
	if (line[i=0]=='@')  {
		sscanf(line+1,"%d", &address_counter ); 
	}

	else {	
		do {
			nb = sscanf(&line[3*i], "%x", &abyte[i%4]);
			i=i+1;
			if (i%4==0) printf("%08x :  %08x ; \n", address_counter++,  abyte[0]| abyte[1] <<8 | abyte[2]<<16 | abyte[3]<<24 ); 
		} while (3*i< strlen(line));

	}
	if (address_counter < DEPTH-1 ) printf("[%08x .. %08x] : %08x ; \n", address_counter, DEPTH-1, 0); 
	printf("\nEND; \n");
    return 0;
}
