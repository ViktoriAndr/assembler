.data
buf: .byte 0
.global _start
.text

_start:
    pop     %rcx  # Количество аргументов
    pop     %rdi  # Неинтересная строка
    mov     %rsp, %r10  # SAVE STACK POINTER
    dec     %rcx
    push    %rcx        
    main_loop:
    	mov     $10, %rbx  # input numbers base
        pop     %rcx          # ДОСТАЕМ НЕИСПОРЧЕННЫЙ СЧЕТЧИК АРГУМЕНТОВ
        cmp     $0, %rcx
        je      2f
        pop     %rdi
        movb     (%rdi), %dl  # считал первый символ

		cmp $0x2B, %dl  # +
		je _sum

		cmp $0x2D, %dl  # -
		je _sub

		cmp $0x2F, %dl  # /
		je _div
>>>>>>> 6743aba14e547db7bb474397aaaf3dd3dcf94fe3

		cmp $0x2A, %dl  # *
		jne 1f
		call _mul
		pop %rcx
		push %rax
		push %rcx
        jmp main_loop
        1:

        call str2int
        pop %rcx
        push    %rax
        push    %rcx
        jmp main_loop
    2:
    # TODO print result
    pop %rax
    call int_print
    call _ret

str2int:
    xor     %rax, %rax  # we will put result here
    xor     %rcx, %rcx  # index in string
    1:
        movb    (%rdi, %rcx), %dl  # read current
        cmp     $0, %dl  # check end of string
        je      2f  # go out of loop
        inc     %rcx
        sub     $0x30, %dl
        push    %rdx 
        mul     %rbx
        pop     %rdx
        add     %rdx, %rax
        jmp     1b
    2:
    ret

_sum:
		pop %rdx  # return address
		pop %rcx  # argument counter
		pop %rax
		pop %rbx
		push %rcx # save argument counter
		push %rdx # save return address
		xor %rdx, %rdx
		add %rbx, %rax
		ret
_sub:
		pop %rdx
		pop %rcx
		pop %rax
		pop %rbx
		push %rcx
		push %rdx
		cmp %rbx, %rax
		jl _minus
		sub %rbx, %rax
		ret
_minus:
		sub %rax, %rbx
		mov %rbx, %rax
		ret
_div:
		pop %rdx
		pop %rcx
		pop %rbx
		pop %rax
		push %rcx
		push %rdx
		xor %rdx, %rdx
		div %rbx
		ret

_mul:
		pop %rdx
		pop %rcx
		pop %rbx
		pop %rax
		push %rcx
		push %rdx
		xor %rdx, %rdx
		mul %rbx
		ret

# print value from RAX (int)
int_print:
		xor %rcx, %rcx
		mov $10, %rbx
		1:
			xor %rdx, %rdx
			div %rbx  # RDX ~ остаток, RAX - делитель
			push %rdx
			inc %rcx
			cmp $0, %rax
			jne 1b
		1:
			mov $buf, %rdx
			pop %rax
			add $0x30, %rax
			movb %al, (%rdx)
			push %rax
			push %rbx
			push %rcx
			call print
			pop %rcx
			pop %rbx
			pop %rax
			dec %rcx
			cmp $0, %rcx
			jne 1b
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
