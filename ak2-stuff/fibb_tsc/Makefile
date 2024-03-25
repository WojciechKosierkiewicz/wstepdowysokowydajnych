all: fibb_32 fibb_64 fibb_32_inline fibb_asm fibb_bin second

fibb_32: fibb_c.c fibb32.s timestamp32.s
	gcc -m32 fibb32.s timestamp32.s fibb_c.c -o fibb_32

fibb_64: fibb_c.c fibb64.s timestamp64.s
	gcc fibb64.s timestamp64.s fibb_c.c -o fibb_64

fibb_32_inline: fibb_inline.c fibb32.s
	gcc -m32 fibb32.s fibb_inline.c -o fibb_32_inline

fibb_asm: fibb_asm.s fibb64.s
	gcc fibb64.s fibb_asm.s -o fibb_asm

fibb_bin: fibb_bin.s fibb64.s
	gcc -no-pie fibb64.s fibb_bin.s -o fibb_bin

second: second.c timestamp32.s
	gcc -m32 timestamp32.s second.c -o second

clean:
	rm fibb_32 fibb_64 fibb_32_inline fibb_asm fibb_bin second
