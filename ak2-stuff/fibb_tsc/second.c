#include <stdio.h>
#include <unistd.h>

// Jan Potocki 2020

unsigned long long timestamp();


int main()
{
    unsigned long long tstamp1, tstamp2;
    
    tstamp1 = timestamp();
    sleep(1);
    tstamp2 = timestamp();
    
    printf("Cycles: %llu\n", tstamp2 - tstamp1);
    
    return 0;
}
