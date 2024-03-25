#include <stdio.h>

// Jan Potocki 2020

unsigned long fibb(unsigned long n);
unsigned long long timestamp();

int main()
{
    unsigned long term, result;
    unsigned long long tstamp1, tstamp2;

    scanf("%lu", &term);

    tstamp1 = timestamp();
    result = fibb(term);
    tstamp2 = timestamp();

    printf("Result: %lu\n", result);
    printf("Cycles: %llu\n", tstamp2-tstamp1);

    return 0;
}
