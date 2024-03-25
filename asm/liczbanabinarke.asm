sys_read = 3
sys_exit = 1
sys_write = 4

.section .data
text:
    .space 256
input_msg:
    .ascii "Enter a string: "


.section .bss
input_len:
    .long 0

.section .text
.globl _start

ask_for_input:
    movl $sys_write, %eax
    movl $1, %ebx
    movl $input_msg, %ecx
    movl $15, %edx
    int $0x80
    ret

read_input:
    movl $sys_read, %eax
    movl $0, %ebx
    movl $text, %ecx
    movl $256, %edx
    int $0x80
    movl %eax, input_len
    subl $1, input_len  
    ret

write_output:
    movl $sys_write, %eax
    movl $1, %ebx
    movl $text, %ecx
    movl input_len, %edx
    int $0x80
    ret

exit_the_program:
    movl $sys_exit, %eax
    movl $0, %ebx
    int $0x80

_start:
    call ask_for_input
    call read_input
    call large_to_small 
    call write_output
    call exit_the_program
