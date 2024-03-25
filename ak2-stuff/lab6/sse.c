#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Dlugosc tablic (powinna byc podzielna przez 4)
#define tab_length 60

unsigned long rdtsc();
void suma_c(int tab1[], int tab2[], int wynik[], long int length);
void suma_sse(int tab1[], int tab2[], int wynik[], long int length);

int main()
{
    int tab1[tab_length], tab2[tab_length];
    int wynik_c[tab_length], wynik_sse[tab_length];
    int i;
    
    unsigned long time_start, time_stop;
    unsigned long time_c, time_sse;
    double acc;
    
    printf("Liczba elementow w tablicach: %d\n", tab_length);
    
    // Losowanie danych
    srand(time(NULL));
    for(i = 0; i < tab_length; i++)
    {
        tab1[i] = rand() % 101;
        tab2[i] = rand() % 101;
    }
    
    // Suma - C
    printf("Sumowanie - C...\t");
    time_start = rdtsc();
    suma_c(tab1, tab2, wynik_c, tab_length);
    time_stop = rdtsc();
    time_c = time_stop - time_start;
    printf("OK\n");
    
    // Suma - SSE (asembler)
    printf("Sumowanie - SSE...\t");
    time_start = rdtsc();
    suma_sse(tab1, tab2, wynik_sse, tab_length);
    time_stop = rdtsc();
    time_sse = time_stop - time_start;
    printf("OK\n");
    
    acc = (double)time_c / (double)time_sse;
    
    // Wyswietlenie wynikow
    if(tab_length <= 60)
    {
        // Zawartosc tablic - do kontroli, jezeli sa krotkie
        printf("\n\t\tC\tSSE\n");
        for(i = 0; i < tab_length; i++)
        {
            printf("%d+%d\t=\t%d\t%d\n", tab1[i], tab2[i], wynik_c[i], wynik_sse[i]);
        }
    }
    
    printf("\nCzas sumowania (TSC) - C:\t%lu\n", time_c);
    printf("Czas sumowania (TSC) - SSE:\t%lu\n", time_sse);
    printf("%fx szybciej\n", acc);
    
    return 0;
}

void suma_c(int tab1[], int tab2[], int wynik[], long int length)
{
    int i;
    
    for(i = 0; i < length; i++)
    {
        wynik[i] = tab1[i] + tab2[i];
    }
}
