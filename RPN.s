.data
buf: .byte 0
.global _start
.text
_start:
		mov $0, %rcx
		mov %rsp, %r9
		call _offset

_offset:
		xor %r10, %r10
		xchg 16(%r9, %rcx, 4), %r10
		#mov 16(%r9), %r10
		xor %rax, %rax
		mov (%r10), %al
		add $2, %rcx 

		#cmp $0, %al
		#jne _offset

		cmp $0x2E, %al
		je _out

_op:
		cmp $0x2B, %al
		je _sum

		cmp $0x2D, %al
		je _sub

		cmp $0x2F, %al
		je _div

		cmp $0x2A, %al
		je _mul

		push %rax
		jmp _offset

_sum:
		pop %rax
		sub $0x30, %rax
		pop %rbx
		sub $0x30, %rbx
		add %bx, %ax
		push %rax
		jmp _offset
_mul:
		ret
_sub:
		ret
_div:
		ret

_out:
		pop %rax
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

# для запуска ./RPN 1 5 + .
# пока есть только +, числа 1-9, в конце обязательно .
# все аргументы через пробел
