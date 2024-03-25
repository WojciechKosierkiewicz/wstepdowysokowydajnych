# Jan Potocki 2023
# Wersja przystosowana do zbudowania jako PIE (Position Independent Executable)

# Definicje numerow funkcji systemowych i ich parametrow
SYSEXIT64 = 60

# Stale okreslajace rozmiar przetwarzanych danych
word_length = 8

.global main

# Segment niezainicjalizowanych danych
.bss
element: .space word_length

# Segment zainicjalizowanych danych
.data
format_s: .asciz "%lu"
format_p: .asciz "%lu\n"

# Segment kodu
.text

main:
# To jest potrzebne zeby printf i scanf nie konczyly sie segfaultem
push %rbp
mov %rsp, %rbp

lea format_s(%rip), %rdi    # Adresowanie wzgledem rip, wprowadzone w x86-64
#mov $format_s, %rdi        # ...tu nam wystarczy sam adres
lea element(%rip), %rsi
#mov $element, %rsi
mov $0, %rax                # Nie ma argumentow dla scanf() w rejestrach xmm
call scanf


lea element(%rip), %r8      # Tutaj trzeba jakis posredni rejestr...
movq (%r8), %rdi            # ...zeby odwolac sie do wartosci
#movq element, %rdi
call fibb

lea format_p(%rip), %rdi
#mov $format_p, %rdi
mov %rax, %rsi              # rax - wartosc zwrocona przez fibb()
mov $0, %rax                # Nie ma argumentow dla printf() w rejestrach xmm
call printf

mov $SYSEXIT64, %rax
mov $0, %rdi
syscall
