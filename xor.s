.data
.set N, 2
.set WRITE, 1
.set READ, 0
.set OPEN, 2
.set CLOSE, 3
.set STDOUT, 1
.set O_RDONLY, 0
.set O_WRONLY, 1
.set EXIT, 60
buf: .skip N
key: .byte 00
.global _start
.text
_start:
		mov 16(%rsp), %rdi # входной фаил
		mov $OPEN, %rax
		mov $O_RDONLY, %rsi
		syscall
		mov %rax, %r10
		mov 24(%rsp), %rdi # выходной фаил
		mov $OPEN, %rax
		mov $O_WRONLY, %rsi
		syscall
		mov %rax, %r8
		mov 32(%rsp), %r9 # ключ
		movb (%r9), %cl
		movb %cl, key

_read:
		mov %r10, %rdi
		mov $READ, %rax
		lea buf, %rsi
		mov $N, %rdx
		syscall
		xor %rdx, %rdx
		mov %rax, %rdx
		cmp $0, %rax
		je _exit
		mov $0, %rbp
		movb key, %cl
		jmp _xor

_xor:
		xorb %cl, buf(%rbp)
		inc %rbp
		cmp %rbp, %rax
		je _write
		jmp _xor	

_write:
		mov $WRITE, %rax
		mov %r8, %rdi
		lea buf, %rsi
		syscall
		cmp $N, %rdx
		je _read

_exit:
		mov $EXIT, %rax
		mov $0, %rdi
		syscall
