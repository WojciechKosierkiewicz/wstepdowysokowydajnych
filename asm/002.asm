.section .data
input_buffer:
    .skip 1024            # Reserve space for input buffer

.section .text
.globl _start

_start:
    # Prompt user for input
    movl $4, %eax           # System call number for sys_write
    movl $1, %ebx           # File descriptor 1 (stdout)
    movl $msg, %ecx         # Pointer to the message
    movl $12, %edx          # Message length
    int $0x80               # Call kernel

    # Read input from keyboard
    movl $3, %eax           # System call number for sys_read
    movl $0, %ebx           # File descriptor 0 (stdin)
    movl $input_buffer, %ecx  # Pointer to input buffer
    movl $1024, %edx        # Maximum number of bytes to read
    int $0x80               # Call kernel

    # Print the input back to the console
    movl $4, %eax           # System call number for sys_write
    movl $1, %ebx           # File descriptor 1 (stdout)
    movl $input_buffer, %ecx  # Pointer to the input buffer
    movl $1024, %edx        # Message length
    int $0x80               # Call kernel

    # Exit the program
    movl $1, %eax           # System call number for sys_exit
    xorl %ebx, %ebx         # Exit code 0
    int $0x80               # Call kernel

.section .data
msg:
    .string "Enter text: "

