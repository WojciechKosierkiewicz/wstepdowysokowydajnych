EXIT_NR = 1
READ_NR = 3
WRITE_NR = 4

STDOUT = 1
EXIT_CODE = 0

.text

liczba: .int 0x1FFE

msg: .ascii "Jakas wiadomosc\n"
msgLen = . - msg

.global _start

_start:
    mov $WRITE_NR, %eax
    mov $STDOUT, %ebx

    mov $msg, %ecx
    mov $msgLen, %edx

    mov $EXIT_NR, %eax
    mov $EXIT_CODE, %ebx
    int $0x80
