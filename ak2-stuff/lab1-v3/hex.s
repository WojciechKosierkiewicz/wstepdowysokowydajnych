# Jan Potocki 2020

# Definicje numerow funkcji systemowych i ich parametrow
SYSEXIT64 = 60
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1

.global _start

# Segment niezainicjalizowanych danych
.bss

bajt: .space 1				# Bufor na dane wejsciowe (1 bajt)
tekst: .space 3				# Bufor na dane wyjsciowe (3 bajty)

# Segment kodu
.text

_start:
mov $tekst, %r8				# r8 - adres bufora wyjsciowego
movb $' ', 2(%r8)			# Wpisanie spacji do bufora wyjsciowego

# Glowna petla
petla:
mov $SYSREAD, %rax			# Wczytanie danych ze standardowego wejscia
mov $STDIN, %rdi			# ...funkcja systemowa read
mov $bajt, %rsi
mov $1, %rdx
syscall

cmp $0, %rax				# rax - liczba wczytanych bajtow (zwrocona)
je koniec					# Jezeli 0, to skonczyly sie dane

movb bajt, %al				# W al zajmiemy sie mlodszymi bitami
mov %al, %bl				# W bl zajmiemy sie starszymi bitami

shr $4, %al					# Wyizolowanie 4 starszych bitow
cmp $10, %al
jl znakA1					# Cyfry 0-9
jmp znakA2					# Cyfry A-F

mlodsze:
and $0x0F, %bl				# Wyizolowanie 4 mlodszych bitow
cmp $10, %bl
jl znakB1					# Cyfry 0-9
jmp znakB2					# Cyfry A-F

zapis:
movb %al, 0(%r8)			# Zapis rezultatow w buforze wyjsciowym
movb %bl, 1(%r8)

mov $SYSWRITE, %rax			# Wypisanie wyniku na standardowe wyjscie
mov $STDOUT, %rdi			# ...funkcja systemowa write
mov $tekst, %rsi
mov $3, %rdx
syscall

jmp petla					# Koniec glownej petli

# Wyjscie z programu
koniec:
mov $SYSEXIT64, %rax
mov $0, %rdi
syscall

# Konwersja na ASCII
znakA1:
add $48, %al				# 48 -> kod ASCII zera
jmp mlodsze

znakA2:
add $55, %al				# 55+10=65 -> kod ASCII litery A
jmp mlodsze

znakB1:
add $48, %bl				# 48 -> kod ASCII zera
jmp zapis

znakB2:
add $55, %bl				# 55+10=65 -> kod ASCII litery A
jmp zapis
