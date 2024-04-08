EXIT_NR = 1
READ_NR = 3
WRITE_NR = 4
STDOUT = 1
EXIT_CODE = 0

# Zapis liczby w systemie szesnastkowym z zapisu dziesiętnego

.section .data
    liczba: .int 6666
    maska:  .int 0xF
    wynik:  .ascii "0000"

.section .text

.global _start
_start:

    mov liczba, %eax
    mov $4, %ebx
    lea wynik+3, %edi

    # Główna pętla
    iteracja:
        mov %eax, %ecx
        mov maska, %edx
        and %edx, %ecx
        call convert_to_ascii
        shr $4, %eax
        dec %ebx
        jnz iteracja

    # Wypisanie wyniku
    mov $WRITE_NR, %eax
    mov $STDOUT, %ebx
    lea wynik, %ecx
    mov $4, %edx
    int $0x80

    # Wyjście z programu
    mov $EXIT_NR, %eax
    mov $EXIT_CODE, %ebx
    int $0x80

# Funkcja konwertująca 4-bitową liczbę na znak ASCII
convert_to_ascii:
    add $48, %ecx
    cmp $57, %ecx
    jle write
    add $7, %ecx
    jmp write
    ret

write:
    movb %cl, (%edi)
    dec %edi
    ret
