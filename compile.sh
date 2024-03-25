#!/bin/bash
for file in asm/*.asm
do
    base=$(basename $file .asm)
    as --32 -g $file -o bin/$base.o
    ld -m elf_i386 -o bin/$base.elf bin/$base.o
    rm bin/$base.o
done
