#Autor: Micha³ £¹tkowski (S4I2)
#Opis programu: Program wykonuje operacjê filtracji medianowej na pliku .bmp


	.data
fileIn:		.asciiz "fileIn.bmp"
fileOut:	.asciiz "fileOut.bmp"
msgWelcome:	.asciiz "Program przeprowadzi filtracje medianowa na pliku test.bmp i zapisze wynik w fileOut.bmp \n"
msgError:	.asciiz "Wczytanie pliku zakonczone niepowodzeniem \n"
msgExit:	.asciiz "Program zakonczyl pomyslnie swoje dzialanie \n"

#alokujemy po 4 bajty, bo tyle maksymalnie maja wczytywane wartosci
		.align 2	# poprawka dla slowa, inaczej nie dziala
buff:		.space 4
offset:		.space 4
size:		.space 4
width:		.space 4
height:		.space 4
poczatek:	.space 4

array:		.space 25 #bo mamy okno 5x5
	.text
	.globl main

main:
	la $a0, msgWelcome	# chcemy wyswietlic wiadomosc poczatkowa
	li $v0, 4		# kod syscalla wyswietlenia stringa
	syscall

readFileHeader:	
	la $a0, fileIn		# chcemy otworzyc plik o nazwie "fileIn.bmp"
	li $a1, 0		# 0, bo chcemy otworzyc plik
	li $a2, 0		# flagi
	li $v0, 13		# kod syscalla otwarcia pliku
	syscall
	
	move $t0, $v0 		# deskryptor pliku przenosimy do t0
	bltz $t0, readError	# jesli deskryptor pliku jest ujemny, przechodzimy do wyswietlenia bledu
	
	# wczytanie BM - niepotrzebne
	move $a0, $t0		# deskryptor pliku
	la $a1, buff		# bufor na niepotrzebne
	li $a2, 2		# ilosc bajtow do wczytania
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall

	# wczytanie 4 bajtow FileSize - potrzebne
	move $a0, $t0		# deskryptor pliku
	la $a1, size		# bufor na rozmiar
	li $a2, 4		# ilosc bajtow do wczytania
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall
	
	lw $t2, size		# zapisujemy rozmiar pliku w t2
	
	# wczytanie 4 bajtow zarezerwowanych - niepotrzebne
	move $a0, $t0		# deskryptor pliku
	la $a1, buff		# bufor na niepotrzebne
	li $a2, 4		# ilosc bajtow do wczytania
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall
	
	# wczytanie 4 bajtow offsetu - potrzebne
	move $a0, $t0		# deskryptor pliku
	la $a1, offset		# bufor na offset
	li $a2, 4		# ilosc bajtow do wczytania
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall
	
	
	 # wczytanie  4 bajtow naglowka - niepotrzebne	
	move $a0, $t0		# deskryptor pliku
	la $a1, buff		# bufor na niepotrzebne
	li $a2, 4		# ilosc bajtow do wczytania
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall
	 
	# wczytanie 4 bajtow szerokosci - potrzebne
	move $a0, $t0		# deskryptor pliku
	la $a1, width		# bufor na szerokosc
	li $a2, 4		# ilosc bajtow do wczytania
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall
	 
	lw $t6, width 		# zapisujemy szerokosc w t6
	 	  
	# wczytanie 4 bajtow wysokosci - potrzebne
	move $a0, $t0		# deskryptor pliku
	la $a1, height		# bufor na wysokosc
	li $a2, 4		# ilosc bajtow do wczytania
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall
	 
	lw $t5, height 		# zapisujemy wysokosc w t5
	
	move $a0, $t2		#ladujemy rozmiar pliku do a0
	li $v0, 9		# SBRK
	syscall

	move $t3,$v0		# w t3 bedziemy mieli adres pierwszego bufora
	
	move $a0, $t2           # wczesniej zapisany rozmiar
        li $v0, 9		# SBRK
	syscall
	
	move $t4, $v0 		# w t4 bedziemy mieli adres drugiego bufora
	
	# zamkniecie pliku
	move $a0, $t0		# deskryptor pliku
	li $v0, 16		# kod syscalla zamkniecia pliku
	syscall
	
readFileContentsDouble: 		
	# po wczytaniu informacji naglowka wczytujemy zawartosc pliku
 	# otwieramy plik raz jeszcze
 	la $a0, fileIn		# chcemy otworzyc plik o nazwie "fileIn.bmp"
	li $a1, 0		# 0, bo chcemy otworzyc plik
	li $a2, 0		# flagi
	li $v0, 13		# kod syscalla otwarcia pliku
	syscall
	
	move $t0, $v0 # pobranie deskryptora pliku
	bltz $t0, readError	# jesli deskryptor pliku jest ujemny, przechodzimy do wyswietlenia bledu
	
	move $a0, $t0		# deskryptor pliku
	la $a1, ($t3)		# bufor do wczytania, czyli ten pierwszy
	la $a2, ($t2)		# ilosc bajtow do wczytania, czyli wszystko
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall
	
	# zamkniecie pliku
	move $a0, $t0		# deskryptor pliku
	li $v0, 16		# kod syscalla zamkniecia pliku
	syscall
	
# I RAZ JESZCZE
# po wczytaniu informacji naglowka wczytujemy zawartosc pliku
 	# otwieramy plik raz jeszcze, tym razem dla nowego bufora
 	li $v0, 13
	la $a0, fileIn
	li $a1, 0
	li $a2, 0
	syscall
	
	move $t0, $v0 # pobranie deskryptora pliku
	bltz $t0, readError	# jesli deskryptor pliku jest ujemny, przechodzimy do wyswietlenia bledu
	
	move $a0, $t0		# deskryptor pliku
	la $a1, ($t4)		# bufor do wczytania, czyli ten drugi
	la $a2, ($t2)		# ilosc bajtow do wczytania, czyli wszystko
	li $v0, 14		# kod syscalla odczytu z pliku
	syscall
	
	# zamkniecie pliku
	move $a0, $t0		# deskryptor pliku
	li $v0, 16		# kod syscalla zamkniecia pliku
	syscall
	
	# przesuwamy wskaznik po pikselach, tak aby zaczac od tablicy pikseli
	lw $t1, offset		# w t1 zapisujemy offset
	addu $t3, $t3, $t1	# przesuwamy t3 o offset
	addu $t4, $t4, $t1	# przesuwamy t4 o offset

#POCZATEK ALGORYTMU	
	# zawartosc rejestrow przedstawia/bedzie sie przedstawiac sie nastepujaco:
	# t0 - deskryptor
	# t1 - offset
	# t2 - rozmiar tablicy pikseli
	# t3 - bufor oryginalny
	# t4 - bufor do modyfikacji
	# t5 - wysokosc
	# t6 - szerokosc
	# t7 - padding
	# t8 - realny rozmiar wiersza tzn. szerokosc plus padding
	# s0 - wspolrzedna x piksela
	# s1 - wspolrzedna y piksela
	# s2 -licznik elementow do 25 przy ladowaniu do okienka
	# s3 - rozpatrywany piksel w okienku
	# s4 -25
	# s5,s6,s7 pomocnicze przy medianie
countPadding:	 
	andi $t7, $t6, 3 	# reszta z dzielenia szerokosci przez 4
	beq $t7, 0, pixelAnalysisPreparation 	# jeœli reszta jest 0 to padding to 0
	addi $t9, $zero, 4 	# t9 to zmienna pomocnicza
	sub $t7, $t9, $t7 	# dla przykladu, skoro reszta jest 1, to potrzeba doliczyc 3 bajty
	
	# notka: z pikselem mozna zrobic dwie rzeczy-przepisac bez zmian (jesli nasz rozmiar okna czyli 5x5 to wymusza) lub wykonac na nim operacje filtracji
	# pierwsze dwa wiersze/kolumny i ostatnie dwa wiersze/kolumny sa w zwiazku z tym przepisywane
	# jestesmy na poczatku tablicy pikseli (w t3)
pixelAnalysisPreparation:
	# notka: koncept jest taki, zeby sprawdzac przy pikselu czy jest jednym z tych niemodyfikowalnych (pierwszym, drugim, przedostatnim lub ostatnim)
	# jesli tak to go przepisujemy-przy bitmapie o duzej rozmiarze (a im wieksza, tym sensowniejsze jest zastosowanie filtra zamiast recznej korekcji) nie ma to wielkiego znaczenia
	# jesli nie, to na pewno okienko 5x5 zadziala wiec nie musimy sprawdzac czy piksel nalezy do bitmapy itp.
	addi $t8,$zero,0	# zerujemy t8
	add $t8,$t6,$t7		# t8-realny rozmiar wiersza (widoczne bity plus padding)
	addi $s0,$zero,0	# zerujemy s0 - licznik pozycji w wierszu tzn. wspolrzedna x  (z paddingiem)
	addi $s1,$zero,0	# zerujemy s1 - licznik pozycji w kolumnie tzn. wspolrzedna y
	# LOOP poczatek pixenAnalysisLoop
pixelAnalysisLoop:
	lbu $t0, ($t3)          # pobieramy bajt do t0
	ble $s1, 1, writePixelToOutput # jesli to pierwszy lub drugi wiersz, przejdz do przepisania piksela
	sub $t9, $t5, 2 	# t9-zmienna pomocnicza 
	bge $s1, $t9, writePixelToOutput # jesli to przedostatni lub ostatni wiersz, przejdz do przepisania piksela
	ble $s0, 1, writePixelToOutput # jesli to pierwsza lub druga kolumna, przejdz do przepisania piksela
	sub $t9, $t6, 2 	# t9-zmienna pomocnicza 
	bge $s0, $t9, writePixelToOutput # jesli to przedostatnia lub ostatnia kolumna (albo kolumna zlozona z bitow paddingowych), przejdz do przepisania piksela
	
	# tutaj rozpoczynamy mediane, skoro tu dotarlismy, to wokol analizowanego piksela mozna zbudowac okienko
getWindow:
	addi $s2,$zero,0 	# zerujemy licznik elementow w okienku
	addi $s4,$zero,25	# ustawiamy sobie ogranicznik petli rowny 25 w s4
	addi $s6,$zero,0	# s6 to licznik pi¹tkowy, czyli liczymy od 0 do 5 i skaczemy w górê o kolumnê, gdy dotrzemy do 5
	move $s3,$t3		# s3 to piksel aktualnie dodawany do okienka
	# notka: trzeba cofnac sie o dwa w lewo i dwa w gore, pamietajac o paddingu
	subi $s3, $s3, 2	# o dwa w lewo
	sub $s3, $s3, $t6 	# o wiersz w dol
	sub $s3, $s3, $t7	# doliczamy padding
	sub $s3, $s3, $t6	# o wiersz w dol
	sub $s3, $s3, $t7	# doliczamy padding
	# notka: jestesmy w dolnym lewym rogu okienka, teraz musimy pobrac 5 pikseli, przeskoczyc, pobrac 5 pikseli...az bedziemy mieli 25 pikseli i bedziemy w prawym gornym rogu okienka
loadPixelIntoWindowLoop:
	lbu $s5, ($s3)		# $s3 wskazuje piksel, ktory chcemy dodajemy do okienka, wiec go zapisujemy
	sb $s5, array($s2)	# wczytujemy piksel do okienka pod indeksem licznika
	addi $s2,$s2,1		# zwiekszamy licznik pikseli w okienku o jeden
	addi $s3,$s3,1		# idziemy o jedna w prawo
	addi $s6,$s6,1		# zwiekszamy licznik piatkowy o 1
	bne $s6, 5, loadPixelIntoWindowLoop # jesli nie wczytalismy jeszcze w tym wierszu 5 pikseli, to wczytujemy dalej
	addi $s6,$zero,0	# zerujemy licznik piatkowy, wczytalismy w tym wierszu juz 5 pikseli
	subi $s3,$s3,5		# odejmujemy 5 od wskaznika na piksel
	add $s3,$s3,$t8	# dodajemy t8, czyli realny rozmiar wiersza (szerokosc plus padding)
	bne $s2, $s4, loadPixelIntoWindowLoop 	# sprawdzamy czy wczytalismy juz 25 pikseli, jesli tak, to mozemy juz liczyc mediane
#POCZATEK MEDIANY
Median:
        addi $s3, $zero, 1	# zaczynamy licznik zewnetrzny od 1
	add $s4, $zero, $zero	# zerujemy licznik
	add $s5, $zero, $zero	# zerujemy licznik
	add $s6, $zero, $zero	# zerujemy licznik
	add $s7, $zero, $zero	# zerujemy licznik
medianLoop1:
        addi $s4, $zero, 25     # s4 = rozmiar bufora
medianLoop2:
        addi $s4, $s4, -1	# s4 wskazuje na pewien indeks w tablicy
        addi $s5, $s4, -1	# s5 wskazje na indeks w tablicy o 1 nizszy od s4
        lbu $s6, array($s4)	# do s6 wczytujemy bajt z tablicy pod indeksem s4
        lbu $s7, array($s5)	# do s7 wczytujemy bajt z tablicy pod indeksem s5
        bgt $s6, $s7, afterPotentialSwap # jesli elementy sa w dobrej kolejnosci, to ich nie zamieniamy
        sb $s6, array($s5)	# zamieniamy miejscami s6 z s5
        sb $s7, array($s4)
afterPotentialSwap:
	blt $s3, $s4, medianLoop2 # warunek petli wewnetrznej
	addi $s3,$s3,1		# zwiekszamy licznik petli zewnetrznej
	ble $s3, 25, medianLoop1 # jesli s3 wiekszy od rozmiaru bufora, to konczymy liczenie mediany
median_end:
        addi $t0,$t0,0		# zerujemy wartosc piksela ktora zapiszemy w zmodyfikowanym pliku
        addi $s3,$zero,12	# ustawiamy s3 jako wskaznik na srodkowy element posortowanej tablicy, czyli mediane
        lbu $t0, array($s3)
#KONIEC MEDIANY
	
writePixelToOutput:
	sb $t0, ($t4) 		# zapisz bajt w nowym pliku
	addi $s0,$s0,1 		# ustawiamy wspolrzedna x nastepnego piksela
	addi $t3, $t3, 1        # przesuwamy wskaznik bufora wejsciowego
        addi $t4, $t4, 1        # przesuwamy wskaznik bufora wyjsciowego
	blt $s0,$t8,afterPotentialColumnAddition # sprawdzamy czy trzeba przeskoczyc do kolejnej kolumny
	addi $s0,$zero,0	#zerujemy wspolrzedna x piksela
	addi $s1,$s1,1 		#zwiekszamy wspolrzedna y piksela o 1
afterPotentialColumnAddition:
	#notka: warunek konczacy plik jest nastepujacy-dotarlismy do momentu, w ktorym nasza wspolrzedna y jest rowna liczbie wierszy (poniewaz indeksowalismy od 0)
	bne $s1,$t5 pixelAnalysisLoop # jesli mamy jeszcze piksele do wczytania, to idziemy dalej w petli
#KONIEC ALGORYTMU
saveFileAfterAlgorithm:
	li $v0, 13 		# 13 - otwarcie pliku
	la $a0, fileOut 	# jeœli plik istnieje, to go nadpisujemy. Jesli nie, to go tworzymy
	li $a1, 1		# 1, bo zapisujemy
	li $a2, 0		# flagi
	syscall
	
	move $t0, $v0 		# zapisujemy deskryptor pliku
	
	# zapisujemy plik
	li $v0, 15		# kod syscalla zapisu
	sub $t4,$t4,$t2		# odejmujemy rozmiar pliku
	move $a0, $t0		# deskryptor pliku
	la $a1, ($t4)		# zapisujemy z bufora drugiego, czyli zmodyfikowanego
	la $a2, ($t2)		# rozmiar obrazka, tyle bajtow zapisujemy
	syscall	

closeNewFile:			#zamkniecie pliku
	move $a0,$t0		#deskryptor pliku
	li $v0, 16 		#kod syscalla zamkniecia pliku
	syscall
	
exit:				#zamkniecie programu
	li $v0, 10		#kod syscalla zamkniecia programu
	syscall
	
readError:			#wyswietlenie wiadomosc o bledzie
	la $a0, msgError	#chcemy wyswietlic przygotowana w sekcji danych wiadomosc
	li $v0, 4		#kod syscalla wyswietlenia stringa
	syscall
	
	li $v0, 10		#kod syscalla zamkniecia programu
	syscall
	
