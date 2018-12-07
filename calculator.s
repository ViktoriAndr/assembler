.data
num1 = 25
num2 = 5
op: .byte '-'
buf: .byte 0
.text

.global _start

_start:
		mov op, %al

		cmp $0x2B, %al
		je _sum

		cmp $0x2D, %al
		je _sub

		cmp $0x2F, %al
		je _div

		cmp $0x2A, %al
		je _mul

		call _printt

_sum:
		mov $num1, %rax
		mov $num2, %rbx
		add %rbx, %rax
		jmp _printt

_sub:
		mov $num1, %rax
		mov $num2, %rbx
		sub %rbx, %rax
		js _minus
		jmp _printt

_minus:
		mov $num1, %rbx
		mov $num2, %rax
		sub %rbx, %rax
		jmp _printt

_div:
		mov $num1, %rax
		mov $num2, %rbx
		div %rbx
		jmp _printt

_mul:
		mov $num1, %rax
		mov $num2, %rbx
		mul %rbx
		jmp _printt

_printt:
		xor %rbx, %rbx 
		mov $10, %rbx
		mov $0, %rcx
		call _loop1
		call _ret

_loop1:
		cmp $0, %rax
		je _loop2
		xor %rdx, %rdx
		div %rbx
		push %rdx
		inc %rcx
		jmp _loop1
		
_loop2:
		cmp $0, %rcx
		je 1f
		mov $buf, %rdx
		pop %rax
		add $0x30, %rax
		mov %al, (%rdx)
		push %rcx
		call print
		pop %rcx
		dec %rcx
		jmp _loop2
1:
		ret

print:
		mov $1, %rax
		mov $1, %rdi
		mov $buf, %rsi
		mov $1, %rdx
		syscall
		ret

_ret:
		mov $60, %rax
		mov $0, %rdi
		syscall
