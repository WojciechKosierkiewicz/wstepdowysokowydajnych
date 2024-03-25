# Jan Potocki 2019

.data
# Definicje numerow funkcji systemowych i ich parametrow
SYSEXIT = 60
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1
STDERR = 2

# Stale
liczba = 130            # Liczba calkowita do wypisania przez printf

# Ciagi formatujace dla scanf
int1: .asciz "%ld"      # 64-bit int
double1: .asciz "%lf"   # 64-bit double

# Ciagi formatujace dla printf
int2: .asciz "%ld\n"    # 64-bit int
double2: .asciz "%f\n"  # 64-bit double (w printf nie "%lf"!)

.bss
# Zmienne
x: .space 8             # 64-bit int
y: .space 8             # 64-bit double
wynik: .space 8         # 64-bit double

.text
.globl main

main:
pushq %rbp              # Wyrownanie stosu (alignment) - wymagane przez
                        # konwencje wywolan

# Wczytanie danych
movb $0, %al            # Brak parametrow w rejestrach wektorowych
movq $int1, %rdi        # Ciag formatujacy
movq $x, %rsi           # Wskaznik na x
call scanf

movb $0, %al            # Brak parametrow w rejestrach wektorowych
movq $double1, %rdi     # Ciag formatujacy
movq $y, %rsi           # Wskaznik na y
call scanf

# Wywolanie funkcji w C
movq (x), %rdi          # Przekazanie x (1. parametr, int) przez wartosc
movq (y), %xmm0         # Przekazanie y (2. parametr, double) przez wartosc
# Liczby rejestrow wektorowych w al nie ustawiamy, bo nasza funkcja przyjmuje
# stala liczbe parametrow (inaczej niz printf czy scanf)
call kwadrat
# Wynik zostanie zwrocony w rejestrze xmm0, ktorym rowniez przekazuje sie go do
# funkcji printf - wiec nic nie trzeba z nim robic

# Wypisanie wyniku
movb $1, %al            # 1 parametr w rejestrze wektorowym (xmm0)
movq $double2, %rdi     # Ciag formatujacy
call printf

# Wypisanie liczby calkowitej ustawionej w stalej
movb $0, %al            # Brak parametrow w rejestrach wektorowych
movq $int2, %rdi        # Ciag formatujacy
movq $liczba, %rsi      # Przekazanie stalej przez wartosc
call printf

popq %rbp               # Przywrocenie stosu do poprzedniego stanu

# Koniec programu
movq $SYSEXIT, %rax
movq $0, %rdi
syscall
