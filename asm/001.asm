.section .data
input_buffer:
    .string "Hello, World!"    # Input text to be reversed

.section .text
.globl _start

_start:
    # Reverse the text in the buffer
    movl $input_buffer, %edi        # Point edi to the start of the input buffer
    movl $input_buffer, %esi        # Point esi to the start of the input buffer

    # Find the end of the string
    xorl %ecx, %ecx                 # Clear ecx (counter for string length)
    movb $0, %al                    # Store null terminator in al
.find_length_loop:
    cmpb $0, (%edi)                 # Compare the current byte with null terminator
    je .reverse_string              # If null terminator is found, jump to reverse_string
    inc %ecx                        # Increment counter
    inc %edi                        # Move to the next byte
    jmp .find_length_loop           # Repeat the loop

.reverse_string:
    decl %edi                       # Move edi back to the end of the string
    movl %ecx, %edx                 # Store the length of the string in edx
    shr %edx                        # Divide by 2 to get the number of iterations needed
    jz .end_reverse                 # If string length is 0 or 1, no need to reverse

.reverse_loop:
    movb (%esi), %al                # Load byte from the beginning of the string
    movb (%edi), %dl                # Load byte from the end of the string
    movb %dl, (%esi)                # Store the byte from the end at the beginning
    movb %al, (%edi)                # Store the byte from the beginning at the end
    inc %esi                        # Move esi forward
    dec %edi                        # Move edi backward
    loop .reverse_loop              # Repeat the loop until ecx is 0


.end_reverse:
    # Now the text in the buffer is reversed
    # You can print it or perform any other operation as needed

    # Exit the program
    movl $1, %eax           # System call number for sys_exit
    xorl %ebx, %ebx         # Exit code 0
    int $0x80               # Call kernel

