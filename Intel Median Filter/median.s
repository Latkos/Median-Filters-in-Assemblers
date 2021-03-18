    global median

median:

    push rbp
    mov rbp, rsp

    ;rdi-stary bufor, rsi-nowy bufor, rdx-szerokosc,rcx-wysokosc,r8-padding,r9-okienko

    xor r10,r10             ; zerujemy r10
    add r10, rdx            ; dodajemy szerokosc
    add r10, r8             ; dodajemy padding
;w r10 realny rozmiar wiersza
pixelAnalysisPreparation:
    xor r11,r11             ; zerujemy x
    xor r12,r12             ; zerujemy y
    xor r13,r13             ; iterator po inpucie
    xor r14,r14             ; wskaznik na analizowany bajt w okienku
    xor r15,r15             ; analizowany bajt

pixelAnalysisLoop:
    mov r15b,[rdi+r13]      ; dla tych niemedianowanych, po prostu przenosimy piksel
    cmp r12,1
    jbe writePixelToOutput  ; jesli to zerowy lub pierwszy wiersz to przepisujemy
    mov r14,rcx
    sub r14,2
    cmp r12,r14
    jae writePixelToOutput  ; jesli to ostatni lub przedostatni wiersz (albo paddingowy) to przepisujemy

    xor r14,r14             ; zerujemy zmienna pomocnicza

    cmp r11,1
    jbe writePixelToOutput  ; jesli to zerowa lub pierwsza kolumna to przepisujemy
    mov r14,rdx
    sub r14,2
    cmp r11,r14
    jae writePixelToOutput  ; jesli to ostatnia lub przedostatnia kolumna to przepisujemy

getWindow:
    push r11
    push r12
;wrzucilismy na stos x i y bo sa na razie niepotrzebne
    xor r11,r11             ;licznik elementow w okienku
    xor r12,r12             ; licznik piatkowy
    xor r14,r14             ; wskaznik na elementy w okienku
    add r14,r13             ; dodajemy offsecik tzn. iterator po inpucie
    sub r14,2               ; idziemy o dwa w lewo, do brzegu okienka
    sub r14,rdx 
    sub r14,rdx             ; o dwie szerokosci w dol
    sub r14,r8
    sub r14,r8              ; o dwa paddingi w dol
loadPixelIntoWindowLoop:
    mov r15b, [rdi+r14]     ;r14 wskazuje piksel ktory chcemy dodac do okienka
    mov [r9+r11], r15b      ; na odpowiednie miejsce wrzucamy pobrany bajt
    inc r11                 ; zwiekszamy licznik pikseli w okienku
    inc r14                 ; idziemy o jedna w prawo
    inc r12                 ; zwiekszamy licznik piatkowy
    cmp r12,5
    jne loadPixelIntoWindowLoop ; jesli nie wczytalismy 5 w wierszu okienka, to wczytujemy dalej
    xor r12,r12             ; zerujemy licznik piatkowy
    sub r14,5               ; odejmujemy 5 od wskaznika na piksel
    add r14,r10             ;dodajemy realny rozmiar wiersza
    cmp r11,25
    jne loadPixelIntoWindowLoop ; jesli nie wczytalismy jeszcze 25 pikseli, to wczytujemy dalej
push r10 ; wrzucamy na stos realny rozmiar wiersza, bo przyda nam sie dopiero potem
;POCZATEK MEDIANY
Median:
    xor r10,r10             ; licznik zewnetrzny
    inc r10                 ; zaczynamy od 1
    xor r11, r11 
    xor r12, r12 
    xor r14,r14
    xor r15,r15 ; zerujemy liczniki
medianLoop1:
    xor r11,r11
    add r11,25
medianLoop2:
    dec r11
    xor r12,r12
    add r12,r11
    dec r12
    mov r14b, [r9+r11]
    mov r15b, [r9+r12]
    cmp r14b,r15b
    ja afterPotentialSwap   ; jesli kolejnosc jest zla, to zamieniamy
    mov [r9+r12], r14b
    mov [r9+r11], r15b
afterPotentialSwap:
    cmp r10,r11
    jb medianLoop2          ; warunek petli wewnetrznej
    inc r10
    cmp r10,25
    jle medianLoop1         ; warunek petli zewnetrznej
median_end:
    xor r15,r15
    mov r15b, [r9+12]       ; wybieramy srodkowy element tabicy 25-elementowej, czyli element o indeksie 12
; KONIEC MEDIANY
    pop r10                 ; zdejmujemy realny rozmiar wiersza ze stosu
    pop r12                 ; zdejmujemy y ze stosu
    pop r11                 ; zdejmujemy x ze stosu 
writePixelToOutput:
    mov [rsi+r13], r15b     ; zapisujemy bajt w nowej tablicyp pikseli, niezaleznie czy byl filtrowany czy nie
    inc r11                 ; zwiekszamy x
    inc r13                 ; zwiekszamy iterator po inpucie
    cmp r11,r10             
    jb afterPotentialColumnAddition ; porownujemy z realnym rozmiarem wiersza, zeby sprawdzic czy przenosimy sie do nastepnego wiersza
    xor r11,r11
    inc r12                 ; zwiekszamy wspolrzedna y 
afterPotentialColumnAddition:
    cmp r12, rcx 
    jne pixelAnalysisLoop   ; porownujemy wspolrzedna y z wysokoscia, jesli jest jeszcze co wczytac, to wczytujemy

; koniec, sprzatamy
    mov rsp, rbp
    pop rbp
    ret
