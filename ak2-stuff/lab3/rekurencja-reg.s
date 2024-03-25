# Jan Potocki 2019

# Definicje numerow funkcji systemowych i ich parametrow
SYSEXIT = 60
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1
STDERR = 2

# Stale
number = 5              # Wyraz ciagu (to mozna zmienic, reszty nie ruszac)

n_size = 8              # Rozmiar bufora

.bss
num: .space n_size      # Bufor

.text
.globl main

fun:
# Funkcja obliczajaca wynik ciagu:
# x_0=2
# x_1=1
# x_2=3
# x_i=x_(i-2) - 2*x_(i-3)
# 1 parametr - wyraz ciagu (64-bit int), przekazywany przez rejestr
# Wynik zwracany przez rejestr

pushq %rbp              # Wejscie do funkcji
movq %rsp, %rbp
pushq %rbx              # Zachowanie wartosci rejestru rbx, poniewaz bedzie
                        # pozniej modyfikowany - a wg konwencji wywolan, rbx 
                        # musi byc zachowany po stronie wywolanej funkcji

cmpq $0, %rdi           # rdi - 1. parametr (zgodnie z konwencja wywolan)
je x0
cmpq $1, %rdi
je x1
cmpq $2, %rdi
je x2

# Rekurencja
# 1 wyraz
subq $2, %rdi           # Obliczenie indeksu nowego wyrazu ciagu
pushq %rdi              # Zachowanie wartosci rejestru rdi (wg konwencji
                        # wywolan - po stronie wywolujacego)
call fun                # 1. wywolanie rekurencyjne
popq %rdi               # Przywrocenie wartosci rejestru rdi
movq %rax, %rbx         # Skopiowanie wyniku zwroconego w rejestrze rax
                        # do rejestru rbx

# 2 wyraz
subq $1, %rdi           # Obliczenie indeksu nowego wyrazu ciagu
pushq %rdi              # Zachowanie wartosci rejestru rdi (wg konwencji
                        # wywolan - po stronie wywolujacego)
call fun                # 1. wywolanie rekurencyjne
popq %rdi               # Przywrocenie wartosci rejestru rdi
movq $2, %rcx           # Mnozenie 2. wyrazu przez 2
mulq %rcx

subq %rax, %rbx         # Obliczenie roznicy

# Zwrocenie wyniku obliczen (przez rejestr rax, zgodnie z konwencja) i wyjscie
movq %rbx, %rax
jmp fun_end

# Zwrocenie wynikow dla poczatkowych wyrazow (przez rejestr rax)
x0:
movq $2, %rax
jmp fun_end

x1:
movq $1, %rax
jmp fun_end

x2:
movq $3, %rax

fun_end:
popq %rbx               # Przywrocenie wartosci rejestru rbx
popq %rbp               # Wyjscie z funkcji
ret

main:
movq $number, %rdi      # Przekazanie parametru przez rejestr rdi
call fun                # Wywolanie funkcji rekurencyjnej
movq %rax, num          # Zapisanie w pamieci wyniku zwroconego przez rax

# Wypisanie wyniku
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $num, %rsi
movq $n_size, %rdx
syscall

# Koniec programu
movq $SYSEXIT, %rax
movq $0, %rdi
syscall
