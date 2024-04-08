.section .data

    liczba: .int 666      # Liczba dziesiętna
    maska:  .int 0xF      # Maska do wyodrębnienia 4 bitów
    wynik:  .ascii "00000000"  # Bufor wynikowy

.section .text

.globl _start

_start:

    movl $liczba, %eax    # Wczytanie liczby do rejestru
    movl $8, %ebx         # Licznik iteracji
    movl $wynik, %edi     # Ustawienie wskaźnika na początek bufora wynikowego

    iteracja:
        movl %eax, %ecx   # Skopiowanie liczby do ecx
        andl $0xF, %ecx   # Pozostawienie tylko 4 najmłodszych bitów
        call convert_to_ascii  # Konwersja 4-bitowej liczby na znak ASCII
        rol $4, %eax      # Przesunięcie o 4 bity w prawo
        dec %ebx          # Dekrementacja licznika iteracji
        jnz iteracja      # Powtarzaj, dopóki licznik nie będzie zerowy

    # Wypisanie wyniku
    movl $4, %eax
    movl $1, %ebx
    leal wynik, %ecx     # Adres bufora wynikowego
    movl $8, %edx        # Długość wyniku
    int $0x80

    # Wyjście z programu
    movl $1, %eax        # Numer wywołania systemowego dla wyjścia
    xorl %ebx, %ebx      # Kod wyjścia 0
    int $0x80            # Wywołanie przerwania

# Funkcja konwertująca 4-bitową liczbę na znak ASCII
convert_to_ascii:
    add $48, %ecx        # Konwersja liczby na ASCII
    cmp $58, %ecx        # Sprawdzenie czy liczba jest większa niż 9
    jle skip             # Jeśli nie, przejdź do pominięcia
    add $7, %ecx         # Jeśli tak, dodaj odpowiednią wartość dla liter A-F
skip:
    movb %cl, (%edi)     # Zapisz znak do bufora wynikowego
    inc %edi             # Inkrementuj wskaźnik bufora
    ret                  # Powrót z funkcji
