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
    mov $sys_write, %eax
    mov $1, %ebx
    mov $input_msg, %ecx
    mov $15, %edx
    int $0x80
    ret

read_input:
    mov $sys_read, %eax
    mov $0, %ebx
    mov $text, %ecx
    mov $256, %edx
    int $0x80
    mov %eax, input_len
    dec input_len  
    ret

reverse_text:
    mov input_len, %ecx
    lea text, %esi
    lea text, %edi
    add %ecx, %edi
    dec %edi
    mov %ecx, %eax
    xor %edx, %edx
    mov $2, %ecx
    div %ecx
    mov %eax, %ecx

pntl:
    mov (%esi), %al
    mov (%edi), %bl
    mov %al, (%edi)
    mov %bl, (%esi)
    inc %esi
    dec %edi
    dec %ecx
    jnz pntl 
    ret

write_output:
    mov $sys_write, %eax
    mov $1, %ebx
    mov $text, %ecx
    mov input_len, %edx
    int $0x80
    ret

exit_the_program:
    mov $sys_exit, %eax
    mov $0, %ebx
    int $0x80

_start:
    call ask_for_input
    call read_input
    call reverse_text
    call write_output
    call exit_the_program
