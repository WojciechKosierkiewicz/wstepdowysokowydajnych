.section .data
msg:
    .string "Hello, World!\n"

.section .text
.globl _start

_start:
    # Print the message
    movl $4, %eax           # System call number for sys_write
    movl $1, %ebx           # File descriptor 1 (stdout)
    movl $msg, %ecx         # Pointer to the message
    movl $14, %edx          # Message length
    int $0x80               # Call kernel

    # Exit the program
    movl $1, %eax           # System call number for sys_exit
    xorl %ebx, %ebx         # Exit code 0
    int $0x80               # Call kernel

