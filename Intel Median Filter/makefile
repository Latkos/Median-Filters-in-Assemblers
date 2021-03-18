CC = gcc
CFLAGS = -Wall -m64 -no-pie
ASMFILE = bezier
CFILE = main
NAME = bezier
LIBS = -lallegro -lallegro_dialog -lallegro_image -lallegro_primitives

all: main.o median.o
	$(CC) $(CFLAGS) main.o median.o -o median $(LIBS)

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

median.o: median.s
	nasm -f elf64 -g median.s

clean:
	rm -f *.o median
