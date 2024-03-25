// Jan Potocki 2019

#include <math.h>

double arctgc(double x, int kroki)
{
    int wyraz, i;
    double potega, wynik;
    double suma = x;
    
    for(i = 1; i <= kroki; i++)
    {
        wyraz = 2*i + 1;
        potega = pow(x, (double)wyraz);
        wynik = potega/(double)wyraz;

        if(i % 2 == 1)
        {
            wynik = -wynik;
        }

        suma += wynik;
    }

    return suma;
}
