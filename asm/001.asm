.section .data
    hello: .asciz "Hello, world!\n"
    newline: .byte 10
    counter: .long 0

.section .text
.globl _start

_start:
    movl $0, %ebx

loop_start:
    cmpl $8, counter
    jge loop_end

    movl $4, %eax
    movl $1, %ebx
    movl $hello, %ecx
    movl $13, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $0x80

    incl counter

    jmp loop_start

loop_end:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
