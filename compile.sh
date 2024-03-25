#!/bin/bash
for file in *.asm
do
    base=${file%.asm}
    as --32 -g $file -o $base.o
    ld -m elf_i386 -o $base.elf $base.o
done
