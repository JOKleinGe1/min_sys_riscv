//test.c
#define   LEDRADDRESS   (*(volatile char *)  0x8000)
#define   SWADDRESS   (*(volatile char *)  0x8004)
int main (void){
	int i=1; 
	while (1){
		LEDRADDRESS =  i++;
		while (SWADDRESS & 0x01);
	 }
return 0;  
}

