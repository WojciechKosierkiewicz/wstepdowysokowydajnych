# Jan Potocki 2020

.global timestamp

# Segment kodu
.text

timestamp:
xor %eax, %eax
cpuid
rdtsc

ret
