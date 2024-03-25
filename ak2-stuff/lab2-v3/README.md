Należy napisać program, który:
* Ze standardowego strumienia wejściowego odczyta (za pomocą funkcji systemowej _read_) bloki zawierające 512 bajtów każdy. Liczba bloków może być dowolna. Kombinacje bitów w bajtach mogą być dowolne.
* Każdy blok potraktowany zostanie jako zapisane po sobie dwie reprezentacje w kodzie naturalnym binarnym. Pierwszy odczytany bajt w bloku zawiera najmniej znaczący bit reprezentacji. Każda z reprezentacji zajmuje ciągłą połowę odczytanego bloku, czyli układ danych w bloku można opisać jako:  
`A0 A1 A2 ... A255 B0 B1 B2 ... B255`
gdzie `Ai` i `Bi` oznaczają kolejne bajty (o indeksach _i_) reprezentacji pierwszej (_A_) i drugiej (_B_).
* Po odczytaniu bloku danych, na standardowe wyjście zostanie wypisana reprezentacja iloczynu liczb zapisanych reprezentacjami A i B. Format reprezentacji wyjściowej będzie taki sam, jak wejściowych, ale o odpowiednio dopasowanej wielkości.


Przykładowe dane wejściowe i oczekiwane wyniki są dostępne pod adresem http://zak.iiar.pwr.wroc.pl/materials/architektura/laboratorium%20AK2/Dane/mul.tar.bz2  
Pliki z rozszerzeniem `.in` to dane wejściowe, pliki `*.out` to oczekiwane odpowiedzi.  
Docelowo program ma działać dla danych z plików `mul_256.*`, ale dla ułatwienia Państwu pracy na początku realizacji zadania przygotowałem także pliki z reprezentacjami 4-bajtowymi (pliki `mul_4.*`).

Podczas implementacji największe problemy może Państwu sprawić poprawna realizacja algorytmu mnożenia.  
Przykładowe koncepcje należy sobie przypomnieć z materiałów z poprzedniego semestru, np. slajdy 38 i 39 pliku http://zak.iiar.pwr.wroc.pl/materials/Arytmetyka%20komputerow/architekura.pdf i podstawy z pliku http://zak.iiar.pwr.wroc.pl/materials/Arytmetyka%20komputerow/mnozenie.pdf  
Oczywiście zadanie to można zrealizować na wiele sposobów, zmieniając zarówno rozmiar pojedynczych iloczynów częściowych, jak i kolejność ich kumulacji.  
Można np. kumulację iloczynów częściowych przeprowadzać "wierszami", dodając poszczególne iloczyny częściowe "w poziomie", można także kumulować "kolumnami" sumując iloczyny "w pionie". Można także stosować różne rozwiązania pośrednie.  
Niezależnie jednak od przyjętego sposobu, koniecznie proszę pamiętać o właściwej propagacji przeniesień.
