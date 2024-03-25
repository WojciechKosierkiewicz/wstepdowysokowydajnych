# Jan Potocki 2020
# Przyklad wywolania:
# echo 08 | xxd -p -r | ./fibb_asm | hexdump

# Definicje numerow funkcji systemowych i ich parametrow
SYSEXIT64 = 60
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1

# Stale okreslajace rozmiar przetwarzanych danych
word_length = 8

.global main

# Segment niezainicjalizowanych danych
.bss
result: .space word_length

# Segment zainicjalizowanych danych
.data
term: .zero word_length

# Segment kodu
.text

main:
mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $term, %rsi
mov $word_length, %rdx
syscall

movq term, %rdi
call fibb
movq %rax, result

mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $result, %rsi
mov $word_length, %rdx
syscall

mov $SYSEXIT64, %rax
mov $0, %rdi
syscall
