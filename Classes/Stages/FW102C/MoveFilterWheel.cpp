
#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include "uart_library.h"


int _tmain(int argc, _TCHAR* argv[])
{
    int ret,port,pos;
    char b[256]="";
    char c[256]="";
    if(argc<2){
        printf("Not enough arguments. Usage:\n");
        printf("\tQuery position: \tMoveFW102C.exe SerialPortNum (MoveFW102C.exe 6)\n");
        printf("\tSet new position: \tMoveFW102C.exe SerialPortNum NewPos (MoveFW102C.exe 6 5)\n");
        return 101;
    }
        
    port=atoi(argv[1]);
    if(argc>2)
       pos=atoi(argv[2]);
    else
       pos=-1;
    printf("Atemptting to open port COM%i .\n",port);
	ret=fnUART_LIBRARY_open(port, 115200);
	if(ret != 0 ) { 
		printf("Cannot open port .\n");
		return 102;
	}
	else {
 printf("Port COM%i opened .\n",port);
        if(pos>0 && pos<7) {
            sprintf(b,"pos=%d\r",pos);
		    ret = fnUART_LIBRARY_Set(b,0);
		    
        }
        else if (pos==-1){}
        
		else{       
            printf("Position %d out of range .\n",b);    
		    fnUART_LIBRARY_close();
		    return 103;		    
        }
        sprintf(b,"pos?\r",pos);
        ret = fnUART_LIBRARY_Get(b,c);
        c[0]=c[5];
        c[1]='\0';
        printf("Position= %s\n",c);
        fnUART_LIBRARY_close();
        return atoi(c);
	}
	return 0;
}
