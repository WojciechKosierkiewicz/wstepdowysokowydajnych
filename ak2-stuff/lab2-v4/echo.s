# Jan Potocki 2022

# Definicje numerow funkcji systemowych i ich argumentow
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL32 = 0x80

# Stale
buff_len = 1
end_char = 'Q'

.global _start

.bss
# Bufor na czytany znak
buff: .space buff_len

.text
_start:
mov $SYSREAD, %eax      # Wczytanie znaku ze standardowego wejscia
mov $STDIN, %ebx        # ...funkcja systemowa read
mov $buff, %ecx
mov $buff_len, %edx
int $SYSCALL32

mov $end_char, %eax     # Sprawdzenie, czy wczytano znak konczacy
cmp %eax, buff
je koniec               # ...jezeli tak, skok na koniec

mov $SYSWRITE, %eax     # Wypisanie znaku na standardowe wyjscie
mov $STDOUT, %ebx       # ...funkcja systemowa write
mov $buff, %ecx
mov $buff_len, %edx
int $SYSCALL32
jmp _start              # Skok na poczatek (petla)

koniec:
mov $SYSEXIT, %eax      # Funkcja systemowa exit...
mov $0, %ebx            # ...kod zakonczenia 0
int $SYSCALL32
