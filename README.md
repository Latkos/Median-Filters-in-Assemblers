# Assemblers Median Filters
Filtry medianowe zaimplementowane w dwóch różnych assemblerach (MIPS i Intel x86).
Program ten można wykorzystać np. do redukcji szumów w obrazku.
Służy on do filtrowania 8-bitowych plików BMP w skali szarości!



PRZED
![fileIn](https://user-images.githubusercontent.com/48084189/111650463-9ae75d00-8805-11eb-8fbc-c451325d5cd1.png)

PO

![sampleFileOut](https://user-images.githubusercontent.com/48084189/111656186-94a7af80-880a-11eb-8b35-315e75664c6c.png)


-------------------------------------------------------------------------------------
JAK URUCHOMIĆ:

A) MIPS
Do uruchomienia MIPS można np. wykorzystać symulator Mars (http://courses.missouristate.edu/kenvollmar/mars/). Uruchamiamy program w Mars, co pozwala na filtrację pliku "fileIn.bmp".
UWAGA: Przez fakt używania MIPS na symulatorze, program jest znacznie wolniejszy i nie poleca się nim filtrować dużych plików.

B) Intel
Do uruchomienia programu należy wejść do folderu i uruchomić opcję make.
_Konieczna jest instalacja biblioteki graficznej Allegro 5._
Użytkownik podaje w konsoli nazwę pliku (np. "file_to_be_filtered.bmp"), po czym program wyświetla obraz przed i po filtracji.


