hex: hex.o
	ld hex.o -o hex

hex.o: hex.s
	as hex.s -o hex.o
	
all: hex

clean:
	rm hex
