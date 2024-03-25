# Jan Potocki 2020

# Definicje numerow funkcji systemowych i ich parametrow
SYSEXIT64 = 60
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1

# Stale okreslajace rozmiar przetwarzanych danych
num_length = 256
# ...tego nie ruszac - inaczej stanie sie "cud nad klawiatura" :-D
word_length = 8
buf_length = num_length * 2
num_words = num_length / word_length
buf_words = buf_length / word_length

.global main

# Segment niezainicjalizowanych danych
.bss

liczba1: .space num_length
liczba2: .space num_length
wynik: .space buf_length

# Segment kodu
.text

main:
# Glowna petla
petla:
mov $SYSREAD, %rax          # Wczytanie danych ze standardowego wejscia
mov $STDIN, %rdi            # ...funkcja systemowa read
mov $liczba1, %rsi
mov $buf_length, %rdx
syscall

# UWAGA
# Tutaj wczytane zostana od razu obie liczby
# liczba1 i liczba2 sa w pamieci bezposrednio po sobie...
# ...i zostala przekazana do funkcji read dlugosc calego bloku

cmp $buf_length, %rax       # rax - liczba wczytanych bajtow
jl koniec                   # Jezeli nie ma 512, to dane sie skonczyly

xor %rsi, %rsi              # rsi - licznik petli zerujacej

# Petla zerujaca bufor na wynik
wyzeruj:
movq $0, wynik(, %rsi, 8)
inc %rsi
cmp $buf_words, %rsi
jl wyzeruj

xor %rsi, %rsi              # rsi - licznik pierwszej petli

# Mnozenie - petla zewnetrzna
petla1:
xor %rcx, %rcx              # rcx - miejsce na starsza czesc wyniku

# Flagi przeniesienia (potrzebne sa dwie i tego sie nie uprosci)
mov $0, %r8                 # r8 - dla koncowego wyniku (w pamieci)
clc                         # RFLAGS - dla biezacego mnozenia (rejestry)
pushf                       # ...oczywiscie z backupem na stosie

xor %rdi, %rdi              # rdi - licznik drugiej petli

# Mnozenie - petla wewnetrzna
petla2:
movq liczba1(, %rsi, 8), %rax
mulq liczba2(, %rdi, 8)

mov %rdi, %r9               # r9 - indeks wyniku
add %rsi, %r9               # (suma indeksow obu petli)

# Dodanie starszej czesci wyniku z poprzedniej iteracji
popf                        # Tutaj flagi mamy na stosie...
adc %rcx, %rax
pushf                       # ...wiec to jest proste

# Przygotowanie flagi przeniesienia do sumowania wyniku (patent cz. I)
cmp $1, %r8                 # Tego nie mamy na stosie...
je ustaw_cf1                # ...wiec musimy sprytnym sposobem ;-)

clc                         # Przypadek bez przeniesienia
jmp dodaj_wynik

ustaw_cf1:
stc                         # Przypadek z przeniesieniem

# Dodawanie biezacego wyniku do pamieci
# (tam po wszystkich iteracjach bedzie wynik koncowy)
dodaj_wynik:
adcq %rax, wynik(, %r9, 8)

# Zapisanie flagi przeniesienia do sumowania wyniku (patent cz. II)
jc zapisz_cf

mov $0, %r8                 # Jezeli przeniesienia nie bylo
jmp dalej

zapisz_cf:
mov $1, %r8                 # Jezeli przeniesienie bylo

dalej:
mov %rdx, %rcx              # Przechowanie starszej czesci wyniku w rcx

inc %rdi
cmp $num_words, %rdi
jl petla2                   # Koniec wewnetrznej petli

# Tutaj musimy sie jeszcze zajac najstarsza czescia wyniku
# (z ostatniej iteracji petli wewnetrznej)
inc %r9

popf                        # Dodanie przeniesienia z sumowania rejestrow
adc $0, %rcx                # ...jezeli jakies zostalo

# Przygotowanie flagi przeniesienia do sumowania wyniku (patent cz. I)
cmp $1, %r8
je ustaw_cf2

clc                         # Przypadek bez przeniesienia
jmp dodaj_najstarsze

ustaw_cf2:
stc                         # Przypadek z przeniesieniem

dodaj_najstarsze:
adcq %rcx, wynik(, %r9, 8)

inc %rsi
cmp $num_words, %rsi
jl petla1                   # Koniec zewnetrznej petli

mov $SYSWRITE, %rax			# Wypisanie wyniku na standardowe wyjscie
mov $STDOUT, %rdi			# ...funkcja systemowa write
mov $wynik, %rsi
mov $buf_length, %rdx
syscall

jmp petla					# Koniec glownej petli

# Wyjscie z programu
koniec:
mov $SYSEXIT64, %rax        # Funkcja systemowa exit...
mov $0, %rdi                # ...kod zakonczenia - 0
syscall
