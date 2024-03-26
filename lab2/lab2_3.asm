section .data
    n equ 1000                      ; Maksymalna liczba do sprawdzenia

section .bss
    prime_flags resb (n+1)          ; Tablica flag dla liczb pierwszych

section .text
    global sieve_eratosthenes

sieve_eratosthenes:
    ; Inicjalizacja tablicy flag
    mov ecx, n
    mov esi, prime_flags
    mov eax, 1                       ; 1 oznacza liczbę pierwszą
    rep stosb

    ; Ustawienie flag dla 0 i 1 na 0 (nie są pierwsze)
    mov byte [prime_flags], 0
    mov byte [prime_flags + 1], 0

    ; Algorytm sita Eratostenesa
    mov edi, 2                       ; Początek sito - pierwsza liczba pierwsza
sieve_loop:
    mov eax, edi                     ; Zmienna pomocnicza
    mul eax                          ; i * i
    mov ebx, eax
    cmp ebx, n
    ja end_sieve_loop                ; Jeśli i^2 > n, zakończ algorytm

    ; Wykreślenie liczb złożonych
    mov eax, edi                     ; eax = i
    add eax, edi                     ; eax = 2 * i
    cmp eax, n
    ja next_number                   ; Jeśli 2 * i > n, przejdź do następnej liczby
cross_out_loop:
    mov byte [prime_flags + eax], 0 ; Wykreślenie liczby złożonej
    add eax, edi                     ; eax = eax + i
    cmp eax, n
    jbe cross_out_loop               ; Jeśli eax <= n, kontynuuj

next_number:
    inc edi                          ; Przejdź do następnej liczby
    jmp sieve_loop                   ; Powtórz algorytm

end_sieve_loop:
    ret
