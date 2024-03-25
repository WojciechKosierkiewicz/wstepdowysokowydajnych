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
# 1 parametr - wyraz ciagu (64-bit int), przekazywany przez stos
# Wynik zwracany przez stos

pushq %rbp              # Wejscie do funkcji
movq %rsp, %rbp
pushq %rbx              # Zachowanie wartosci rejestru rbx, poniewaz bedzie
                        # pozniej modyfikowany - a wg konwencji wywolan, rbx 
                        # musi byc zachowany po stronie wywolanej funkcji

cmpq $0, 16(%rbp)       # 16(%rbp) - 1. parametr przekazany na stosie
je x0
cmpq $1, 16(%rbp)
je x1
cmpq $2, 16(%rbp)
je x2

# Rekurencja
# 1 wyraz
movq 16(%rbp), %rax     # Obliczenie indeksu nowego wyrazu ciagu
subq $2, %rax
pushq %rax              # Przekazanie nowego wyrazu przez stos
call fun                # 1. wywolanie rekurencyjne
popq %rbx               # Zapisanie w rbx wyniku przekazanego przez stos

# 2 wyraz
movq 16(%rbp), %rax     # Obliczenie indeksu nowego wyrazu ciagu
subq $3, %rax
pushq %rax              # Przekazanie nowego wyrazu przez stos
call fun                # 2. wywolanie rekurencyjne
popq %rax               # Zapisanie w rax wyniku przekazanego przez stos
movq $2, %rcx           # Mnozenie 2. wyrazu przez 2
mulq %rcx

subq %rax, %rbx         # Obliczenie roznicy

# Zwrocenie wyniku obliczen (przez stos) i wyjscie
movq %rbx, 16(%rbp)
jmp fun_end

# Zwrocenie wynikow dla poczatkowych wyrazow (przez stos)
x0:
movq $2, 16(%rbp)
jmp fun_end

x1:
movq $1, 16(%rbp)
jmp fun_end

x2:
movq $3, 16(%rbp)

fun_end:
popq %rbx               # Przywrocenie wartosci rejestru rbx
popq %rbp               # Wyjscie z funkcji
ret

main:
movq $number, %rax      # Przekazanie parametru...
pushq %rax              # ...przez stos
call fun                # Wywolanie funkcji rekurencyjnej
popq %rax               # Zapisanie w rax wyniku zwroconego przez stos
movq %rax, num          # Zapisanie wyniku w pamieci

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
