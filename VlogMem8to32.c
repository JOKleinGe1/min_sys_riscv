//File: VlogMem8to32.c
#include <stdio.h>
#include <string.h>

#include <stdio.h>

int main(int argc, char* argv[])
{

	unsigned long data32; 
	unsigned int  abyte[4];
	int nb; 
	int i=0; 
        char line[256];
  
        while (fgets(line, sizeof(line), stdin)) 
	if (line[i=0]=='@')  printf("%s", line); 
	else {	
		do {
			//printf("%s \n",&line[3*i]); 
			nb = sscanf(&line[3*i], "%x", &abyte[i%4]);
			//printf("i:%d nb:%d rd:%x\n",i,nb,abyte[i%4]);
			i=i+1;
			if (i%4==0) printf("%08x ",  abyte[0]| abyte[1] <<8 | abyte[2]<<16 | abyte[3]<<24 ); 
		} while (3*i< strlen(line));
		printf("\n");
	}
    return 0;
}
