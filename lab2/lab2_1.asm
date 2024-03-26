section .data
    str_len dd 0        ; Długość liczby (liczba zajmowanych pozycji)
    number dd 1000 dup(0) ; Tablica z wartościami poszczególnych cyfr

section .text
    global add_numbers
    global subtract_numbers
    global multiply_numbers

; Dodawanie dwóch wielkich liczb
add_numbers:
    mov eax, [esp + 4]     ; adres pierwszej liczby
    mov ebx, [esp + 8]     ; adres drugiej liczby
    mov ecx, [eax]         ; długość pierwszej liczby
    mov edx, [ebx]         ; długość drugiej liczby

    ; Znalezienie dłuższej liczby
    cmp ecx, edx
    jge .add_loop
    xchg eax, ebx          ; zamiana wskaźników
    xchg ecx, edx          ; zamiana długości
.add_loop:
    mov esi, number[eax + 4]   ; wskaźnik do tablicy pierwszej liczby
    mov edi, number[ebx + 4]   ; wskaźnik do tablicy drugiej liczby
    xor eax, eax

.add_digits_loop:Ś
    cmp eax, edx           ; sprawdzenie, czy wszystkie cyfry z mniejszej liczby zostały dodane
    jge .copy_remaining_digits
    movzx ecx, byte [esi]  ; pobranie cyfry z pierwszej liczby
    add ecx, byte [edi]    ; dodanie cyfry z drugiej liczby
    adc byte [edi], 0      ; dodanie przeniesienia
    mov byte [edi], cl     ; zapis wyniku dodawania
    inc esi                ; przesunięcie wskaźnika na następną cyfrę
    inc edi                ; przesunięcie wskaźnika na następną cyfrę
    inc eax                ; zwiększenie licznika cyfr
    jmp .add_digits_loop

.copy_remaining_digits:
    mov ecx, edx
    sub ecx, eax           ; obliczenie liczby pozostałych cyfr
    jz .end_addition       ; jeśli brak cyfr do przepisania, zakończ
    mov esi, number[ebx + 4 + eax] ; wskaźnik do pozostałych cyfr
    mov edi, number[eax + 4]       ; wskaźnik do miejsca w którym należy przepisać
.copy_loop:
    mov al, byte [esi]     ; przepisanie cyfry
    mov byte [edi], al
    inc esi
    inc edi
    dec ecx
    jnz .copy_loop

.end_addition:
    mov dword [eax], edx   ; ustawienie nowej długości liczby
    ret

; Odejmowanie dwóch wielkich liczb
subtract_numbers:
    mov eax, [esp + 4]     ; adres pierwszej liczby
    mov ebx, [esp + 8]     ; adres drugiej liczby
    mov ecx, [eax]         ; długość pierwszej liczby
    mov edx, [ebx]         ; długość drugiej liczby

    ; Sprawdzenie, czy druga liczba jest większa lub równa pierwszej
    cmp ecx, edx
    jg .negate_second_number
    je .compare_digits
    ; Jeśli druga liczba jest mniejsza, zamiana miejscami i oznaczenie wyniku jako ujemnego
    xchg eax, ebx
    xchg ecx, edx
    mov byte [esp + 12], 1 ; flaga wskazująca na wynik ujemny

.compare_digits:
    mov esi, number[eax + 4]   ; wskaźnik do tablicy pierwszej liczby
    mov edi, number[ebx + 4]   ; wskaźnik do tablicy drugiej liczby
    xor eax, eax

.subtract_digits_loop:
    cmp eax, edx           ; sprawdzenie, czy wszystkie cyfry z drugiej liczby zostały odjęte
    jge .copy_remaining_digits_after_subtraction
    movzx ecx, byte [esi]  ; pobranie cyfry z pierwszej liczby
    sub ecx, byte [edi]    ; odjęcie cyfry z drugiej liczby
    sbb byte [edi], 0      ; odjęcie przeniesienia
    mov byte [edi], cl     ; zapis wyniku odejmowania
    inc esi                ; przesunięcie wskaźnika na następną cyfrę
    inc edi                ; przesunięcie wskaźnika na następną cyfrę
    inc eax                ; zwiększenie licznika cyfr
    jmp .subtract_digits_loop

.copy_remaining_digits_after_subtraction:
    mov ecx, edx
    sub ecx, eax           ; obliczenie liczby pozostałych cyfr
    jz .end_subtraction    ; jeśli brak cyfr do przepisania, zakończ
    mov esi, number[ebx + 4 + eax] ; wskaźnik do pozostałych cyfr
    mov edi, number[eax + 4]       ; wskaźnik do miejsca w którym należy przepisać
.copy_loop_after_subtraction:
    mov al, byte [esi]     ; przepisanie cyfry
    mov byte [edi], al
    inc esi
    inc edi
    dec ecx
    jnz .copy_loop_after_subtraction

.end_subtraction:
    mov dword [eax], edx   ; ustawienie nowej długości liczby
    ret

.negate_second_number:
    mov esi, number[ebx + 4] ; wskaźnik do tablicy drugiej liczby
    mov ecx, edx
    xor eax, eax
.negate_loop:
    mov al, byte [esi]      ; pobranie cyfry
    not al                  ; negacja cyfry
    mov byte [esi], al      ; zapis wyniku
    inc esi                 ; przesunięcie wskaźnika na następną cyfrę
    loop .negate_loop       ; powtórzenie dla wszystkich cyfr
    mov byte [esp + 12], 1  ; flaga wskazująca na wynik ujemny
    jmp .compare_digits     ;
