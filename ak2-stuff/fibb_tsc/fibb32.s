# Jan Potocki 2020

.global fibb

# Segment kodu
.text

fibb:
push %ebp
mov %esp, %ebp
push %ebx

cmpl $0, 8(%ebp)
je zero

cmpl $1, 8(%ebp)
je jeden

movl 8(%ebp), %edx
dec %edx
push %edx
call fibb
pop %edx
mov %eax, %ebx

dec %edx
push %edx
call fibb
add $4, %esp
add %ebx, %eax
jmp wyjscie

zero:
mov $0, %eax
jmp wyjscie

jeden:
mov $1, %eax

wyjscie:
pop %ebx
pop %ebp
ret
