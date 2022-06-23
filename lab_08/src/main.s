	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	asm_len
	.type	asm_len, @function
asm_len:
.LFB0:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR -24[rbp], rdi
	mov	DWORD PTR -12[rbp], 0
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -8[rbp], rax
	mov	rdx, QWORD PTR -8[rbp]
#APP
# 12 "main.c" 1
	mov $0, %al
	mov rdx, %rdi
	mov $0xffffffff, %ecx
	repne scasb
	not %ecx
	dec %ecx
	mov %ecx, edx
# 0 "" 2
#NO_APP
	mov	DWORD PTR -12[rbp], edx
	mov	eax, DWORD PTR -12[rbp]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	asm_len, .-asm_len
	.section	.rodata
	.align 8
.LC0:
	.string	"String for test: \"%s\"\nAsm_len = %d\nStrlen = %ld\n"
	.text
	.globl	tests_for_strlen
	.type	tests_for_strlen, @function
tests_for_strlen:
.LFB1:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 40
	.cfi_offset 3, -24
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -24[rbp], rax
	xor	eax, eax
	mov	DWORD PTR -40[rbp], 875770417
	mov	WORD PTR -36[rbp], 53
	lea	rax, -40[rbp]
	mov	rdi, rax
	call	strlen@PLT
	mov	rbx, rax
	lea	rax, -40[rbp]
	mov	rdi, rax
	call	asm_len
	mov	edx, eax
	lea	rax, -40[rbp]
	mov	rcx, rbx
	mov	rsi, rax
	lea	rdi, .LC0[rip]
	mov	eax, 0
	call	printf@PLT
	mov	QWORD PTR -34[rbp], 49
	mov	WORD PTR -26[rbp], 0
	lea	rax, -34[rbp]
	mov	rdi, rax
	call	strlen@PLT
	mov	rbx, rax
	lea	rax, -34[rbp]
	mov	rdi, rax
	call	asm_len
	mov	edx, eax
	lea	rax, -34[rbp]
	mov	rcx, rbx
	mov	rsi, rax
	lea	rdi, .LC0[rip]
	mov	eax, 0
	call	printf@PLT
	nop
	mov	rax, QWORD PTR -24[rbp]
	xor	rax, QWORD PTR fs:40
	je	.L4
	call	__stack_chk_fail@PLT
.L4:
	add	rsp, 40
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	tests_for_strlen, .-tests_for_strlen
	.section	.rodata
	.align 8
.LC1:
	.string	"Test 1 (different source and destination)"
	.align 8
.LC2:
	.string	"Data for ests: \nsourse = \"%s\", destination = \"%s\"\nSymbols copied = %d\n"
.LC3:
	.string	"Result: \"%s\"\n"
.LC4:
	.string	"------------------------"
	.align 8
.LC5:
	.string	"Test 2 (destination = source + 6)"
	.align 8
.LC6:
	.string	"String for tests: \nsourse = \"%s\", destination = \"%s\"\n"
	.align 8
.LC7:
	.string	"Test 3 (source = destination + 6)"
	.text
	.globl	tests_for_strcopy
	.type	tests_for_strcopy, @function
tests_for_strcopy:
.LFB2:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 144
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	movabs	rax, 7599113487299999601
	movabs	rdx, 29104504219725935
	mov	QWORD PTR -128[rbp], rax
	mov	QWORD PTR -120[rbp], rdx
	movabs	rax, 3978425819141910832
	mov	edx, 14648
	mov	QWORD PTR -112[rbp], rax
	mov	QWORD PTR -104[rbp], rdx
	mov	QWORD PTR -96[rbp], 0
	mov	QWORD PTR -88[rbp], 0
	mov	QWORD PTR -80[rbp], 0
	mov	QWORD PTR -72[rbp], 0
	mov	QWORD PTR -64[rbp], 0
	mov	QWORD PTR -56[rbp], 0
	mov	QWORD PTR -48[rbp], 0
	mov	QWORD PTR -40[rbp], 0
	mov	QWORD PTR -32[rbp], 0
	mov	QWORD PTR -24[rbp], 0
	mov	DWORD PTR -16[rbp], 0
	mov	DWORD PTR -132[rbp], 0
	lea	rdi, .LC1[rip]
	call	puts@PLT
	mov	DWORD PTR -132[rbp], 4
	mov	ecx, DWORD PTR -132[rbp]
	lea	rdx, -112[rbp]
	lea	rax, -128[rbp]
	mov	rsi, rax
	lea	rdi, .LC2[rip]
	mov	eax, 0
	call	printf@PLT
	mov	edx, DWORD PTR -132[rbp] ; длина
	lea	rcx, -128[rbp]   ; строка 2
	lea	rax, -112[rbp]   ; строка 1
	mov	rsi, rcx
	mov	rdi, rax
	call	strcopy@PLT
	lea	rax, -112[rbp]
	mov	rsi, rax
	lea	rdi, .LC3[rip]
	mov	eax, 0
	call	printf@PLT
	lea	rdi, .LC4[rip]
	call	puts@PLT
	lea	rdi, .LC5[rip]
	call	puts@PLT
	lea	rax, -128[rbp]
	add	rax, 6
	lea	rcx, -128[rbp]
	mov	rdx, rax
	mov	rsi, rcx
	lea	rdi, .LC6[rip]
	mov	eax, 0
	call	printf@PLT
	mov	DWORD PTR -132[rbp], 5
	lea	rax, -128[rbp]
	add	rax, 6
	mov	edx, DWORD PTR -132[rbp] ; ДЛИНА
	lea	rcx, -128[rbp]
	mov	rsi, rcx   ; 
	mov	rdi, rax   ;
	call	strcopy@PLT
	lea	rax, -128[rbp]
	mov	rsi, rax
	lea	rdi, .LC3[rip]
	mov	eax, 0
	call	printf@PLT
	lea	rdi, .LC4[rip]
	call	puts@PLT
	lea	rdi, .LC7[rip]
	call	puts@PLT
	lea	rax, -128[rbp]
	add	rax, 6
	lea	rdx, -128[rbp]
	mov	rsi, rax
	lea	rdi, .LC6[rip]
	mov	eax, 0
	call	printf@PLT
	mov	DWORD PTR -132[rbp], 5
	lea	rax, -128[rbp]
	add	rax, 6
	mov	edx, DWORD PTR -132[rbp]
	lea	rcx, -128[rbp]
	mov	rsi, rax
	mov	rdi, rcx
	call	strcopy@PLT
	lea	rax, -128[rbp]
	mov	rsi, rax
	lea	rdi, .LC3[rip]
	mov	eax, 0
	call	printf@PLT
	lea	rdi, .LC4[rip]
	call	puts@PLT
	nop
	mov	rax, QWORD PTR -8[rbp]
	xor	rax, QWORD PTR fs:40
	je	.L6
	call	__stack_chk_fail@PLT
.L6:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	tests_for_strcopy, .-tests_for_strcopy
	.section	.rodata
.LC8:
	.string	"TESTS FOR LEN!!!"
.LC9:
	.string	"\nTESTS FOR COPY!!!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	lea	rdi, .LC8[rip]
	call	puts@PLT
	mov	eax, 0
	call	tests_for_strlen
	lea	rdi, .LC9[rip]
	call	puts@PLT
	mov	eax, 0
	call	tests_for_strcopy
	mov	eax, 0
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
