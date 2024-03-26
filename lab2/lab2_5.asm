.section .data
fibonacci_limit: .long 10       # Limit liczby Fibonacciego
result_buffer: .long 0          # Bufor na wynik
fibonacci_start: .long 0         # Początkowa liczba Fibonacciego
fibonacci_next: .long 1          # Kolejna liczba Fibonacciego
fibonacci_temp: .long 0          # Zmienna tymczasowa do obliczeń
fibonacci_counter: .long 0       # Licznik iteracji

.section .text
.globl _start

_start:
    # Inicjalizacja początkowych wartości
    movl $0, fibonacci_start
    movl $1, fibonacci_next
    movl $0, fibonacci_counter

calculate_next_fibonacci:
    # Obliczenie kolejnej liczby Fibonacciego
    movl fibonacci_next, %eax
    addl fibonacci_start, %eax
    movl %eax, fibonacci_temp

    # Przesunięcie wartości
    movl fibonacci_next, %eax
    movl %eax, fibonacci_start
    movl fibonacci_temp, %eax
    movl %eax, fibonacci_next

    # Inkrementacja licznika
    incl fibonacci_counter

    # Wypisanie wyniku
    movl fibonacci_start, %eax
    movl %eax, result_buffer
    call print_fibonacci_number

    # Sprawdzenie warunku zakończenia
    cmpl $fibonacci_limit, fibonacci_counter
    jge end_program

    # Iteracja
    jmp calculate_next_fibonacci

end_program:
    # Zakończenie programu
    movl $60, %eax           # Syscall dla sys_exit
    xorl %edi, %edi          # Kod wyjścia 0
    syscall

print_fibonacci_number:
    # Wypisanie liczby Fibonacciego
    # Argument: %eax - liczba Fibonacciego do wypisania

    # Konwersja liczby do ciągu znaków
    movl $result_buffer, %esi     # Adres bufora wynikowego
    movl $10, %ecx                # Baza 10
    xorl %edx, %edx               # Wartość do zerowania

convert_loop:
        xorl %edx, %edx           # Wyzerowanie rejestru dzielenia
        divl %ecx                 # Podzielenie %eax przez 10
        addb $'0', %dl            # Dodanie '0' do reszty
        pushl %dx                 # Odłożenie reszty na stosie
        testl %eax, %eax          # Sprawdzenie, czy dzielenie jest zakończone
        jnz convert_loop          # Jeśli nie, kontynuuj dzielenie

    # Wyświetlenie liczby Fibonacciego
    popl %eax                    # Pobranie kolejnych cyfr zapisanych na stosie
    movb %al, (%esi)             # Zapisanie cyfry w buforze
    incl %esi                    # Przesunięcie wskaźnika do bufora
    loop print_fibonacci_number  # Powtórzenie dla pozostałych cyfr
    movb $0, (%esi)              # Dodanie znaku końca ciągu
    # Wywołanie funkcji wyświetlającej ciąg znaków
    # Przykładowa implementacja w zależności od środowiska i systemu operacyjnego

    ret
