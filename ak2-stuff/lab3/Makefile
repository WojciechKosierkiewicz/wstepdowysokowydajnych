rekurencja-reg: rekurencja-reg.s
	gcc -g rekurencja-reg.s -o rekurencja-reg -no-pie

rekurencja-stack: rekurencja-stack.s
	gcc -g rekurencja-stack.s -o rekurencja-stack -no-pie

all: rekurencja-reg rekurencja-stack

clean:
	rm -f rekurencja-reg rekurencja-stack
