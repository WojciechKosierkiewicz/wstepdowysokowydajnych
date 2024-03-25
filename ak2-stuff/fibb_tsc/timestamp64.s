# Jan Potocki 2020

.global timestamp

# Segment kodu
.text

timestamp:
xor %rax, %rax
cpuid
rdtsc

shl $32, %rdx
or %rdx, %rax

ret
