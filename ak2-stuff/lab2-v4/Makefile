all: echo

echo: echo.o
	ld -melf_i386 echo.o -o echo

echo.o: echo.s
	as --32 echo.s -o echo.o

clean:
	rm echo echo.o
