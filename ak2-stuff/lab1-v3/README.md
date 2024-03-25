Należy napisać program, który będzie:
* Odczytywał ciąg bajtów ze standardowego strumienia wejściowego. Długość ciągu bajtów może być dowolna. Kombinacje bitów w bajtach także mogą być dowolne.
* Dla każdego odczytanego bajtu należy wypisać na standardowy strumień wyjściowy 3 bajty, z których ostatni będzie kodem ASCII spacji, a dwa pierwsze będą kodami ASCII cyfr szesnastkowych. Te cyfry mają utworzyć taką reprezentację w systemie naturalnym szesnastkowym, dla której odpowiadająca jej reprezentacja w systemie naturalnym dwójkowym (który jest systemem o bazie skojarzonej z systemem N16) będzie miała taki sam układ bitów, jak bajt odczytany ze standardowego strumienia wejściowego.

Dla przykładu:

Jeśli odczytany bajt byłby kodem ASCII znaku `'0'`, to zawierałby bity `00110000` (bit najbardziej znaczący z lewej strony). Dla takiego odczytanego bajtu należy na standardowe wyjście wypisać kolejno bajty o układach bitów `00110011`, `00110000`, `00100000`, czyli kody ASCII znaków `'3'`, `'0'` i `' '`, za pomocą których można zapisać reprezentację szesnastkową 30_N16 odpowiadającą reprezentacji binarnej 00110000_NB.

Przykładowe dane wejściowe i wymagane odpowiedzi są dostępne pod adresem: http://zak.iiar.pwr.edu.pl/materials/architektura/laboratorium%20AK2/Dane/hex.tar.bz2
