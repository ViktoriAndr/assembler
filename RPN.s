.data
buf: .byte 0
.global _start
.text
<<<<<<< HEAD

_start:
    pop     %rcx  # Количество аргументов
    pop     %rdi  # Неинтересная строка
    dec     %rcx
    mov     $10, %rbx  # input numbers base
    1:
        cmp     $0, %rcx
        je      2f
        pop     %rdi
        movb     (%rdi), %dl  # считал первый символ
=======
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
>>>>>>> 9ebbc383e2cd11284f77d8b89175663c5a70408e

		cmp $0x2B, %dl  # +
		je _sum

		cmp $0x2D, %dl  # -
		je _sub

		cmp $0x2F, %dl  # /
		je _div

		cmp $0x2A, %dl  # *
		je _mul

        call str2int
        push    %rax
        jmp 1b
    2:
    # TODO print result
    call _out

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
		pop %rax
		pop %rbx
		add %rbx, %rax
		ret
_sub:
		pop %rax
		pop %rbx
		sub %rbx, %rax
		js _minus
		ret
_minus:
		pop %rbx
		pop %rax
		sub %rbx, %rax
		ret
_div:
		pop %rax
		pop %rbx
		div %rbx
		ret

_mul:
		pop %rax
		pop %rbx
		mul %rbx
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
