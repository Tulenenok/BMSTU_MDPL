app.exe:
	nasm -f elf64 strcopy.asm
	gcc -c main.c
	gcc -o app.exe strcopy.o main.o

clean:
	rm -f *.exe *.o