section .data
    ; Struktura reprezentująca wielką liczbę
    str_len dd 0        ; Długość liczby (liczba zajmowanych pozycji)
    number dd 1000 dup(0) ; Tablica z wartościami poszczególnych cyfr

section .text
    global gcd

gcd:
    ; Wczytanie pierwszej liczby
    mov eax, [esp + 4]  ; adres pierwszej liczby
    mov ebx, [eax]      ; długość pierwszej liczby
    mov esi, number[eax + 4]  ; wskaźnik do tablicy pierwszej liczby
    
    ; Inicjalizacja drugiej liczby (długość i wskaźnik)
    mov eax, [esp + 8]  ; adres drugiej liczby
    mov ecx, [eax]      ; długość drugiej liczby
    mov edi, number[eax + 4]  ; wskaźnik do tablicy drugiej liczby
    
    ; Inicjalizacja liczników
    mov edx, 0          ; inicjalizacja wyniku NWD

    ; Ustawienie wskaźnika na początek obu liczb
    mov esi, number[ebx + 4]  ; wskaźnik na najmniej znaczącą cyfrę pierwszej liczby
    mov edi, number[ecx + 4]  ; wskaźnik na najmniej znaczącą cyfrę drugiej liczby

    .euclidean_loop:
    ; Sprawdzenie, czy druga liczba jest równa 0
    cmp ecx, 0
    je .euclidean_end

    ; Obliczenie reszty z dzielenia pierwszej liczby przez drugą
    xor eax, eax
    mov al, byte [esi]  ; wczytanie najmniej znaczącej cyfry pierwszej liczby
    div byte [edi]      ; podzielenie pierwszej liczby przez drugą
    mov byte [esi], ah  ; zapisanie reszty z dzielenia jako nowej wartości pierwszej liczby

    ; Zamiana miejscami liczb, jeśli druga liczba jest teraz mniejsza od pierwszej
    cmp ebx, ecx
    jl .swap_numbers
    jmp .euclidean_loop

    .swap_numbers:
    xchg eax, ebx       ; zamiana długości liczb
    xchg esi, edi       ; zamiana wskaźników na tablice liczb
    mov ecx, eax        ; nowa długość drugiej liczby

    jmp .euclidean_loop

    .euclidean_end:
    mov eax, ebx        ; wynik NWD znajduje się w rejestrze eax
    ret
