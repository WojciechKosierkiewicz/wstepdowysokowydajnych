# Jan Potocki 2019
# Szereg Taylora arctg(x) dla |x| < 1
# y = (-1)^n * (x^(2n + 1)) / (2n + 1)

.globl arctg
.type arctg, @function

arctg:
pushq %rbp              # Wejscie do funkcji
movq %rsp, %rbp
subq $8, %rsp           # 64-bit double - tymczasowe miejsce w pamieci na x
subq $4, %rsp           # 32-bit int - tymczasowe miejsce w pamieci na 2n+1

# Przygotowanie danych
vmovsd %xmm0, -8(%rbp)  # Umieszczenie w pamieci argumentu funkcji
movq $0, %r8            # r8 - indeks sumy (n), na razie wyzerowany...
fldl -8(%rbp)           # Umieszczenie na stosie FPU poczatkowego wyrazu (x)

szereg:
# Glowna petla
incq %r8                # ...trzeba zliczac od 1 - indeksu kolejnego wyrazu

# Obliczenie 2n+1
movq $2, %rax
mulq %r8
incq %rax
movl %eax, -12(%rbp)    # Zapisanie wyniku 2n+1 w pamieci

# Potegowanie (iteracyjne)
fldl -8(%rbp)           # Umieszczenie na stosie FPU poczatkowej wartosci
movq $1, %r9            # r9 - zliczanie wykladnika (zaczynamy od 1. potegi)

potega:
fmull -8(%rbp)          # Mnozenie st(0) przez podstawe potegi (w pamieci)
incq %r9                # Aktualizacja wykladnika
cmpq %r9, %rax          # Sprawdzenie czy wykladnik 2n+1 zostal osiagniety
jne potega

# Dzielenie
fidivl -12(%rbp)

# Sprawdzenie parzystosci wykladnika w (-1)^n
movq $0, %rdx           # rdx - starsza polowka bitow dzielnej
movq %r8, %rax          # rax - mlodsza polowka bitow dzielnej
movq $2, %rcx           # rcx - dzielnik
divq %rcx
cmpq $1, %rdx           # rdx - reszta z dzielenia
jne suma                # Reszta 0 -> wykladnik parzysty, jest OK
fchs                    # Reszta 1 -> wykladnik nieparzysty, potrzebny minus

suma:
faddp                   # st(1) - poprzednia iteracja, st(0) - aktualna

cmpq %r8, %rdi          # Sprawdzenie czy wyraz szeregu zostal osiagniety
jne szereg

fstl -8(%rbp)           # Zapisanie wyniku w pamieci...
movsd -8(%rbp), %xmm0   # i zwrocenie w xmm0 (bezposrednio sie nie da)

addq $12, %rsp          # Zwolnienie zmiennych lokalnych
popq %rbp               # Wyjscie z funkcji
ret
