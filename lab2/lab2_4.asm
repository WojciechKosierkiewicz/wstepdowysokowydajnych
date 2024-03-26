section .data
array dq 1, 5, 3, 8, 2, 7, 4, 6 ; Tablica liczb 64-bitowych
array_size equ ($ - array) / 8   ; Rozmiar tablicy (liczba elementów)

section .text
global _start

_start:
    mov rdi, array        ; Adres początku tablicy
    mov rsi, array_size   ; Liczba elementów w tablicy
    call quicksort        ; Wywołanie funkcji sortującej

    ; Wyświetlenie posortowanej tablicy
    mov rdi, array
    mov rsi, array_size
    call print_array

    ; Zakończenie programu
    mov eax, 60           ; Syscall dla sys_exit
    xor edi, edi          ; Kod wyjścia 0
    syscall

; Funkcja sortująca Quick Sort
quicksort:
    push rbp
    mov rbp, rsp
    sub rsp, 8            ; Rezerwacja miejsca na zmienną tymczasową

    ; Warunek zakończenia rekurencji - gdy liczba elementów <= 1
    cmp rsi, 1
    jle .end_quicksort

    ; Pivot - wybór ostatniego elementu jako punktu odniesienia
    mov rax, rsi
    dec rax
    mov rbx, rax          ; Indeks pivot

    ; Partitioning - podział tablicy względem pivot
    mov rdx, rdi          ; Indeks i
    mov rdi, rbx          ; Przesunięcie wskazania tablicy na pivot
    call partition

    ; Rekurencyjne sortowanie lewej i prawej części tablicy
    mov rdi, rdx          ; Lewa część tablicy
    sub rsi, rbx          ; Rozmiar lewej części tablicy
    call quicksort

    mov rdi, rdx          ; Prawa część tablicy
    add rdi, rbx          ; Przesunięcie wskazania tablicy na prawą część
    mov rsi, rbx          ; Rozmiar prawej części tablicy
    call quicksort

.end_quicksort:
    add rsp, 8
    pop rbp
    ret

; Funkcja partycjonująca tablicę
; Argumenty:
;   rdi - adres początku tablicy
;   rsi - liczba elementów w tablicy
; Zwraca:
;   rbx - indeks pivot
partition:
    mov rax, qword [rdi + rbx * 8]  ; Wartość pivot
    mov rcx, rbx          ; Indeks mniejszego elementu
    xor rbx, rbx          ; Indeks i

.loop_partition:
    cmp rbx, rsi          ; Sprawdzenie, czy koniec tablicy
    jge .end_loop_partition

    mov rdx, qword [rdi + rbx * 8]  ; Aktualny element
    cmp rdx, rax          ; Porównanie z pivot
    jg .skip_swap         ; Jeśli większy, pominięcie zamiany

    ; Zamiana elementów w tablicy
    mov qword [rdi + rbx * 8], qword [rdi + rcx * 8]
    mov qword [rdi + rcx * 8], rdx
    inc rcx               ; Zwiększenie indeksu mniejszego elementu

.skip_swap:
    inc rbx               ; Zwiększenie indeksu i
    jmp .loop_partition

.end_loop_partition:
    ; Zamiana pivot z elementem na pozycji rcx
    mov rdx, qword [rdi + rcx * 8]
    mov qword [rdi + rcx * 8], qword [rdi + rsi * 8]
    mov qword [rdi + rsi * 8], rdx

    mov rbx, rcx          ; Zwrócenie indeksu pivot
    ret

; Funkcja wyświetlająca tablicę
; Argumenty:
;   rdi - adres początku tablicy
;   rsi - liczba elementów w tablicy
print_array:
    mov rdx, rsi          ; Licznik elementów
    mov rsi, rdi          ; Adres początku tablicy
    mov rdi, 1            ; File descriptor 1 (stdout)
    mov rcx, 8            ; Długość pojedynczego elementu w bajtach

print_loop:
    mov rax, 1            ; Syscall dla sys_write
    syscall

    add rsi, rcx          ; Przesunięcie wskaźnika na następny element
    dec rdx               ; Dekrementacja licznika
    jnz print_loop        ; Powtórzenie dla pozostałych elementów

    ret
