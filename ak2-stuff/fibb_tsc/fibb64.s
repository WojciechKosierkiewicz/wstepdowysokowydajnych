# Jan Potocki 2020

.global fibb

# Segment kodu
.text

fibb:
push %rbp
mov %rsp, %rbp
push %rbx

cmp $0, %rdi
je zero

cmp $1, %rdi
je jeden

dec %rdi
push %rdi
call fibb
pop %rdi
mov %rax, %rbx

dec %rdi
call fibb
add %rbx, %rax
jmp wyjscie

zero:
mov $0, %rax
jmp wyjscie

jeden:
mov $1, %rax

wyjscie:
pop %rbx
pop %rbp
ret
