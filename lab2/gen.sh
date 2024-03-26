#!/bin/bash

NAME="lab2_5"

as --32 -g  $NAME.asm -o $NAME.o
ld -m elf_i386 -o $NAME $NAME.o
./$NAME