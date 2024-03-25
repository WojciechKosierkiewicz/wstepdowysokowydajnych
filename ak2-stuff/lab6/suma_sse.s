# Jan Potocki 2019
# Suma 2 tablic liczb int (32-bitowych) za pomoca jednostki SSE

.globl suma_sse
.type sume_sse, @function

suma_sse:
pushq %rbp                      # Wejscie do funkcji
movq %rsp, %rbp

# rdi - wskaznik na 1. tablice
# rsi - wskaznik na 2. tablice
# rdx - wskaznik na tablice przeznaczona na wynik
# rcx - dlugosc tablic

# Obliczenie dlugosci tablicy w bajtach (ograniczenie petli)
pushq %rdx                      # Zapisanie wartosci rdx na stosie
movq %rcx, %rax                 # Przygotowanie mnozenia...
movq $4, %rcx                   # int = 4 bajty (w modelu danych LP64)
mulq %rcx                       # Mnozenie (wynik w rdx:rax)
popq %rdx                       # Przywrocenie wartosci rdx ze stosu

# Sumowanie wektorowe
mov $0, %r8                     # r8 - indeks petli

suma:
movdqu (%rdi, %r8, 1), %xmm0    # xmm0 - 4 liczby z pierwszej tablicy
movdqu (%rsi, %r8, 1), %xmm1    # xmm1 - 4 liczby z drugiej tablicy
paddd %xmm1, %xmm0              # Rownoczesna suma 4 liczb
movdqu %xmm0, (%rdx, %r8, 1)    # Zapisanie wyniku w pamieci
add $16, %r8                    # Przesuniecie o 16 bajtow (4x int)
cmp %rax, %r8                   # sprawdzenie czy osiagnieto koniec tablicy
jne suma

popq %rbp                       # Wyjscie z funkcji
ret
