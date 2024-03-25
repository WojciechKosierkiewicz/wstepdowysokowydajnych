# Jan Potocki 2019
# Funkcja odczytujaca i zwracajaca wartosc TSC (time-stamp counter)

.globl rdtsc
.type rdtsc, @function

rdtsc:
pushq %rbp              # Wejscie do funkcji
movq %rsp, %rbp
pushq %rbx              # Zapisanie wartosci rbx na stosie
                        # (zgodnie z konwencja wywolan)

movl $0, %eax           # Wybor Maximum Return Value dla CPUID
cpuid                   # Rozkaz serializujacy - zapobiega przesunieciu
                        # rdtsc przez optymalizacje na poziomie mikrokodu
rdtsc                   # edx:eax - time-stamp counter

shlq $32, %rdx          # Przesuniecie bitow z edx do wyzszej polowy rdx
orq %rax, %rdx          # W rax zwracany wynik (zlozony z edx:eax)

popq %rbx               # Przywrocenie wartosci rbx ze stosu
popq %rbp               # Wyjscie z funkcji
ret
