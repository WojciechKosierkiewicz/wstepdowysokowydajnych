// Jan Potocki 2019

#include <stdio.h>
#include <math.h>
#include "arctgc.c"

double arctg(double x, int kroki);

const double x = 0.5;
const int n = 100;

int main()
{
    double wynik_asm, wynik_c;

    printf("Szereg Taylora arctg(%f) dla n=%d...\n", x, n);
    
    wynik_asm = arctg(x, n);
    wynik_c = arctgc(x, n);

    printf("Wynik asm:\t%f\n", wynik_asm);
    printf("Wynik C:\t%f\n", wynik_c);
    
    return 0;
}
