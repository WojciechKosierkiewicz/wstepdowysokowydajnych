#!/bin/bash

as --32 -g 001.asm -o 001.o
ld -m elf_i386 -o 001 001.o
./001
