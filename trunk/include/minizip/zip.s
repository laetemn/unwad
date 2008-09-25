	.file	"zip.c"
.globl zip_copyright
	.section	.rodata
	.align 32
	.type	zip_copyright, @object
	.size	zip_copyright, 79
zip_copyright:
	.string	" zip 1.01 Copyright 1998-2004 Gilles Vollant - http://www.winimage.com/zLibDll"
	.text
	.type	decrypt_byte, @function
decrypt_byte:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %eax
	andl	$65533, %eax
	orl	$2, %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	xorl	$1, %eax
	imull	-4(%ebp), %eax
	shrl	$8, %eax
	andl	$255, %eax
	leave
	ret
	.size	decrypt_byte, .-decrypt_byte
	.type	update_keys, @function
update_keys:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	xorl	16(%ebp), %eax
	andl	$255, %eax
	sall	$2, %eax
	addl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	shrl	$8, %eax
	xorl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %ecx
	addl	$4, %ecx
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	andl	$255, %eax
	leal	(%edx,%eax), %eax
	movl	%eax, (%ecx)
	movl	8(%ebp), %edx
	addl	$4, %edx
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	imull	$134775813, %eax, %eax
	addl	$1, %eax
	movl	%eax, (%edx)
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	shrl	$24, %eax
	movl	%eax, %edx
	movl	8(%ebp), %ecx
	addl	$8, %ecx
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %eax
	xorl	%edx, %eax
	andl	$255, %eax
	sall	$2, %eax
	addl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %eax
	shrl	$8, %eax
	xorl	%edx, %eax
	movl	%eax, (%ecx)
	movl	16(%ebp), %eax
	popl	%ebp
	ret
	.size	update_keys, .-update_keys
	.type	init_keys, @function
init_keys:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	12(%ebp), %eax
	movl	$305419896, (%eax)
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	$591751049, (%eax)
	movl	12(%ebp), %eax
	addl	$8, %eax
	movl	$878082192, (%eax)
	jmp	.L6
.L7:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al,%eax
	movl	%eax, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	update_keys
	addl	$1, 8(%ebp)
.L6:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L7
	leave
	ret
	.size	init_keys, .-init_keys
	.local	calls.3642
	.comm	calls.3642,4,4
	.type	crypthead, @function
crypthead:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	movl	8(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -44(%ebp)
	movl	24(%ebp), %eax
	movl	%eax, -48(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -4(%ebp)
	xorl	%eax, %eax
	cmpl	$11, 16(%ebp)
	jg	.L11
	movl	$0, -52(%ebp)
	jmp	.L13
.L11:
	movl	calls.3642, %eax
	addl	$1, %eax
	movl	%eax, calls.3642
	movl	calls.3642, %eax
	cmpl	$1, %eax
	jne	.L14
	movl	$0, (%esp)
	call	time
	xorl	$-1153374642, %eax
	movl	%eax, (%esp)
	call	srand
.L14:
	movl	-48(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	init_keys
	movl	$0, -20(%ebp)
	jmp	.L16
.L17:
	call	rand
	sarl	$7, %eax
	andl	$255, %eax
	movl	%eax, -28(%ebp)
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	decrypt_byte
	movl	%eax, -24(%ebp)
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	update_keys
	movl	-20(%ebp), %edx
	movl	-28(%ebp), %eax
	xorl	-24(%ebp), %eax
	movb	%al, -14(%ebp,%edx)
	addl	$1, -20(%ebp)
.L16:
	cmpl	$9, -20(%ebp)
	jle	.L17
	movl	-48(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	init_keys
	movl	$0, -20(%ebp)
	jmp	.L19
.L20:
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	decrypt_byte
	movl	%eax, -24(%ebp)
	movl	-20(%ebp), %eax
	movzbl	-14(%ebp,%eax), %eax
	movzbl	%al, %eax
	movl	%eax, 8(%esp)
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	update_keys
	movl	-20(%ebp), %eax
	movl	%eax, %edx
	addl	-40(%ebp), %edx
	movl	-20(%ebp), %eax
	movzbl	-14(%ebp,%eax), %eax
	movzbl	%al, %eax
	xorl	-24(%ebp), %eax
	movb	%al, (%edx)
	addl	$1, -20(%ebp)
.L19:
	cmpl	$9, -20(%ebp)
	jle	.L20
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	decrypt_byte
	movl	%eax, -24(%ebp)
	movl	28(%ebp), %eax
	shrl	$16, %eax
	andl	$255, %eax
	movl	%eax, 8(%esp)
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	update_keys
	movl	-20(%ebp), %eax
	movl	%eax, %edx
	addl	-40(%ebp), %edx
	movl	28(%ebp), %eax
	shrl	$16, %eax
	andl	$255, %eax
	xorl	-24(%ebp), %eax
	movb	%al, (%edx)
	addl	$1, -20(%ebp)
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	decrypt_byte
	movl	%eax, -24(%ebp)
	movl	28(%ebp), %eax
	shrl	$24, %eax
	andl	$255, %eax
	movl	%eax, 8(%esp)
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	update_keys
	movl	-20(%ebp), %eax
	movl	%eax, %edx
	addl	-40(%ebp), %edx
	movl	28(%ebp), %eax
	shrl	$24, %eax
	andl	$255, %eax
	xorl	-24(%ebp), %eax
	movb	%al, (%edx)
	addl	$1, -20(%ebp)
	movl	-20(%ebp), %edx
	movl	%edx, -52(%ebp)
.L13:
	movl	-52(%ebp), %eax
	movl	-4(%ebp), %edx
	xorl	%gs:20, %edx
	je	.L23
	call	__stack_chk_fail
.L23:
	leave
	ret
	.size	crypthead, .-crypthead
	.type	allocate_new_datablock, @function
allocate_new_datablock:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$4096, (%esp)
	call	malloc
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	je	.L25
	movl	-4(%ebp), %eax
	movl	$0, (%eax)
	movl	-4(%ebp), %eax
	movl	$0, 8(%eax)
	movl	-4(%ebp), %eax
	movl	$4080, 4(%eax)
.L25:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	allocate_new_datablock, .-allocate_new_datablock
	.type	free_datablock, @function
free_datablock:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	jmp	.L29
.L30:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, 8(%ebp)
	je	.L31
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L31:
	movl	-4(%ebp), %eax
	movl	%eax, 8(%ebp)
.L29:
	cmpl	$0, 8(%ebp)
	jne	.L30
	leave
	ret
	.size	free_datablock, .-free_datablock
	.type	init_linkedlist, @function
init_linkedlist:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	movl	$0, 4(%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	popl	%ebp
	ret
	.size	init_linkedlist, .-init_linkedlist
	.type	free_linkedlist, @function
free_linkedlist:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	free_datablock
	movl	8(%ebp), %eax
	movl	$0, 4(%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	leave
	ret
	.size	free_linkedlist, .-free_linkedlist
	.type	add_data_in_datablock, @function
add_data_in_datablock:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	cmpl	$0, 8(%ebp)
	jne	.L40
	movl	$-104, -36(%ebp)
	jmp	.L42
.L40:
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	jne	.L43
	call	allocate_new_datablock
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L43
	movl	$-104, -36(%ebp)
	jmp	.L42
.L43:
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -4(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -8(%ebp)
	jmp	.L46
.L47:
	movl	-4(%ebp), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	jne	.L48
	call	allocate_new_datablock
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	%edx, (%eax)
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L50
	movl	$-104, -36(%ebp)
	jmp	.L42
.L50:
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -4(%ebp)
	movl	8(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%eax, 4(%edx)
.L48:
	movl	-4(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	16(%ebp), %eax
	jae	.L52
	movl	-4(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -12(%ebp)
	jmp	.L54
.L52:
	movl	16(%ebp), %eax
	movl	%eax, -12(%ebp)
.L54:
	movl	-4(%ebp), %edx
	addl	$16, %edx
	movl	-4(%ebp), %eax
	movl	8(%eax), %eax
	leal	(%edx,%eax), %eax
	movl	%eax, -20(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L55
.L56:
	movl	-16(%ebp), %eax
	movl	%eax, %edx
	addl	-20(%ebp), %edx
	movl	-16(%ebp), %eax
	addl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	movb	%al, (%edx)
	addl	$1, -16(%ebp)
.L55:
	movl	-16(%ebp), %eax
	cmpl	-12(%ebp), %eax
	jb	.L56
	movl	-4(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, %edx
	addl	-12(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	-4(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, %edx
	subl	-12(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-12(%ebp), %eax
	addl	%eax, -8(%ebp)
	movl	-12(%ebp), %eax
	subl	%eax, 16(%ebp)
.L46:
	cmpl	$0, 16(%ebp)
	jne	.L47
	movl	$0, -36(%ebp)
.L42:
	movl	-36(%ebp), %eax
	leave
	ret
	.size	add_data_in_datablock, .-add_data_in_datablock
	.type	ziplocal_putValue, @function
ziplocal_putValue:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$36, %esp
	movl	$0, -12(%ebp)
	jmp	.L61
.L62:
	movl	-12(%ebp), %eax
	movl	16(%ebp), %edx
	movb	%dl, -8(%ebp,%eax)
	shrl	$8, 16(%ebp)
	addl	$1, -12(%ebp)
.L61:
	movl	-12(%ebp), %eax
	cmpl	20(%ebp), %eax
	jl	.L62
	cmpl	$0, 16(%ebp)
	je	.L64
	movl	$0, -12(%ebp)
	jmp	.L66
.L67:
	movl	-12(%ebp), %eax
	movb	$-1, -8(%ebp,%eax)
	addl	$1, -12(%ebp)
.L66:
	movl	-12(%ebp), %eax
	cmpl	20(%ebp), %eax
	jl	.L67
.L64:
	movl	8(%ebp), %eax
	movl	8(%eax), %ecx
	movl	20(%ebp), %edx
	movl	8(%ebp), %eax
	movl	28(%eax), %ebx
	movl	%edx, 12(%esp)
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ebx, (%esp)
	call	*%ecx
	movl	%eax, %edx
	movl	20(%ebp), %eax
	cmpl	%eax, %edx
	je	.L68
	movl	$-1, -24(%ebp)
	jmp	.L70
.L68:
	movl	$0, -24(%ebp)
.L70:
	movl	-24(%ebp), %eax
	addl	$36, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	ziplocal_putValue, .-ziplocal_putValue
	.type	ziplocal_putValue_inmemory, @function
ziplocal_putValue_inmemory:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$0, -8(%ebp)
	jmp	.L73
.L74:
	movl	-8(%ebp), %eax
	movl	%eax, %edx
	addl	-4(%ebp), %edx
	movl	12(%ebp), %eax
	movb	%al, (%edx)
	shrl	$8, 12(%ebp)
	addl	$1, -8(%ebp)
.L73:
	movl	-8(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L74
	cmpl	$0, 12(%ebp)
	je	.L80
	movl	$0, -8(%ebp)
	jmp	.L78
.L79:
	movl	-8(%ebp), %eax
	addl	-4(%ebp), %eax
	movb	$-1, (%eax)
	addl	$1, -8(%ebp)
.L78:
	movl	-8(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L79
.L80:
	leave
	ret
	.size	ziplocal_putValue_inmemory, .-ziplocal_putValue_inmemory
	.type	ziplocal_TmzDateToDosDate, @function
ziplocal_TmzDateToDosDate:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	20(%eax), %eax
	movl	%eax, -8(%ebp)
	cmpl	$1980, -8(%ebp)
	jbe	.L82
	subl	$1980, -8(%ebp)
	jmp	.L84
.L82:
	cmpl	$80, -8(%ebp)
	jbe	.L84
	subl	$80, -8(%ebp)
.L84:
	movl	8(%ebp), %eax
	movl	12(%eax), %ecx
	movl	-8(%ebp), %eax
	movl	%eax, %edx
	sall	$4, %edx
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	leal	(%edx,%eax), %eax
	addl	$1, %eax
	sall	$5, %eax
	leal	(%ecx,%eax), %eax
	movl	%eax, %ebx
	sall	$16, %ebx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, %ecx
	shrl	%ecx
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, %edx
	sall	$6, %edx
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	leal	(%edx,%eax), %eax
	sall	$5, %eax
	leal	(%ecx,%eax), %eax
	orl	%ebx, %eax
	addl	$16, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	ziplocal_TmzDateToDosDate, .-ziplocal_TmzDateToDosDate
	.type	ziplocal_getByte, @function
ziplocal_getByte:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	28(%eax), %ecx
	movl	$1, 12(%esp)
	leal	-1(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	*%edx
	movl	%eax, -8(%ebp)
	cmpl	$1, -8(%ebp)
	jne	.L88
	movzbl	-1(%ebp), %eax
	movzbl	%al, %edx
	movl	16(%ebp), %eax
	movl	%edx, (%eax)
	movl	$0, -20(%ebp)
	jmp	.L90
.L88:
	movl	8(%ebp), %eax
	movl	24(%eax), %ecx
	movl	8(%ebp), %eax
	movl	28(%eax), %edx
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	*%ecx
	testl	%eax, %eax
	je	.L91
	movl	$-1, -20(%ebp)
	jmp	.L90
.L91:
	movl	$0, -20(%ebp)
.L90:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	ziplocal_getByte, .-ziplocal_getByte
	.type	ziplocal_getShort, @function
ziplocal_getShort:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getByte
	movl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L95
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getByte
	movl	%eax, -12(%ebp)
.L95:
	movl	-8(%ebp), %eax
	sall	$8, %eax
	addl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L97
	movl	16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%eax, (%edx)
	jmp	.L99
.L97:
	movl	16(%ebp), %eax
	movl	$0, (%eax)
.L99:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	ziplocal_getShort, .-ziplocal_getShort
	.type	ziplocal_getLong, @function
ziplocal_getLong:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getByte
	movl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L102
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getByte
	movl	%eax, -12(%ebp)
.L102:
	movl	-8(%ebp), %eax
	sall	$8, %eax
	addl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L104
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getByte
	movl	%eax, -12(%ebp)
.L104:
	movl	-8(%ebp), %eax
	sall	$16, %eax
	addl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L106
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getByte
	movl	%eax, -12(%ebp)
.L106:
	movl	-8(%ebp), %eax
	sall	$24, %eax
	addl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L108
	movl	16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%eax, (%edx)
	jmp	.L110
.L108:
	movl	16(%ebp), %eax
	movl	$0, (%eax)
.L110:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	ziplocal_getLong, .-ziplocal_getLong
	.type	ziplocal_SearchCentralDir, @function
ziplocal_SearchCentralDir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$65535, -16(%ebp)
	movl	$0, -20(%ebp)
	movl	8(%ebp), %eax
	movl	16(%eax), %ecx
	movl	8(%ebp), %eax
	movl	28(%eax), %edx
	movl	$2, 12(%esp)
	movl	$0, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	*%ecx
	testl	%eax, %eax
	je	.L113
	movl	$0, -36(%ebp)
	jmp	.L115
.L113:
	movl	8(%ebp), %eax
	movl	12(%eax), %ecx
	movl	8(%ebp), %eax
	movl	28(%eax), %edx
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	*%ecx
	movl	%eax, -8(%ebp)
	movl	-16(%ebp), %eax
	cmpl	-8(%ebp), %eax
	jbe	.L116
	movl	-8(%ebp), %eax
	movl	%eax, -16(%ebp)
.L116:
	movl	$1028, (%esp)
	call	malloc
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jne	.L118
	movl	$0, -36(%ebp)
	jmp	.L115
.L118:
	movl	$4, -12(%ebp)
	jmp	.L120
.L121:
	movl	-12(%ebp), %eax
	addl	$1024, %eax
	cmpl	-16(%ebp), %eax
	jbe	.L122
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	.L124
.L122:
	addl	$1024, -12(%ebp)
.L124:
	movl	-12(%ebp), %edx
	movl	-8(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -28(%ebp)
	movl	-28(%ebp), %edx
	movl	-8(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -40(%ebp)
	cmpl	$1028, -40(%ebp)
	jbe	.L125
	movl	$1028, -40(%ebp)
.L125:
	movl	-40(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	8(%ebp), %eax
	movl	16(%eax), %edx
	movl	8(%ebp), %eax
	movl	28(%eax), %ecx
	movl	$0, 12(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	*%edx
	testl	%eax, %eax
	jne	.L126
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	28(%eax), %ecx
	movl	-24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	*%edx
	cmpl	-24(%ebp), %eax
	jne	.L126
	movl	-24(%ebp), %eax
	subl	$3, %eax
	movl	%eax, -32(%ebp)
	jmp	.L129
.L130:
	movl	-32(%ebp), %eax
	addl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$80, %al
	jne	.L129
	movl	-32(%ebp), %eax
	addl	-4(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$75, %al
	jne	.L129
	movl	-32(%ebp), %eax
	addl	-4(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %eax
	cmpb	$5, %al
	jne	.L129
	movl	-32(%ebp), %eax
	addl	-4(%ebp), %eax
	addl	$3, %eax
	movzbl	(%eax), %eax
	cmpb	$6, %al
	jne	.L129
	movl	-32(%ebp), %eax
	addl	-28(%ebp), %eax
	movl	%eax, -20(%ebp)
	jmp	.L135
.L129:
	cmpl	$0, -32(%ebp)
	setg	%al
	subl	$1, -32(%ebp)
	testb	%al, %al
	jne	.L130
.L135:
	cmpl	$0, -20(%ebp)
	jne	.L126
.L120:
	movl	-12(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jb	.L121
.L126:
	cmpl	$0, -4(%ebp)
	je	.L136
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L136:
	movl	-20(%ebp), %eax
	movl	%eax, -36(%ebp)
.L115:
	movl	-36(%ebp), %eax
	leave
	ret
	.size	ziplocal_SearchCentralDir, .-ziplocal_SearchCentralDir
.globl zipOpen2
	.type	zipOpen2, @function
zipOpen2:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$16688, %esp
	movl	8(%ebp), %eax
	movl	%eax, -16652(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -16656(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -16660(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	$0, -16588(%ebp)
	cmpl	$0, -16660(%ebp)
	jne	.L140
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	fill_fopen_filefunc
	jmp	.L142
.L140:
	movl	-16660(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -16580(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -16576(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -16572(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -16568(%ebp)
	movl	16(%edx), %eax
	movl	%eax, -16564(%ebp)
	movl	20(%edx), %eax
	movl	%eax, -16560(%ebp)
	movl	24(%edx), %eax
	movl	%eax, -16556(%ebp)
	movl	28(%edx), %eax
	movl	%eax, -16552(%ebp)
.L142:
	movl	-16580(%ebp), %edx
	movl	%edx, -16672(%ebp)
	cmpl	$0, 12(%ebp)
	jne	.L143
	movl	$11, -16668(%ebp)
	jmp	.L145
.L143:
	movl	$7, -16668(%ebp)
.L145:
	movl	-16552(%ebp), %edx
	movl	-16668(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-16652(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	*-16672(%ebp)
	movl	%eax, -16548(%ebp)
	movl	-16548(%ebp), %eax
	testl	%eax, %eax
	jne	.L146
	movl	$0, -16664(%ebp)
	jmp	.L148
.L146:
	movl	-16568(%ebp), %ecx
	movl	-16548(%ebp), %eax
	movl	-16552(%ebp), %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	*%ecx
	movl	%eax, -28(%ebp)
	movl	$0, -16536(%ebp)
	movl	$0, -16476(%ebp)
	movl	$0, -20(%ebp)
	movl	$0, -24(%ebp)
	leal	-16580(%ebp), %eax
	addl	$36, %eax
	movl	%eax, (%esp)
	call	init_linkedlist
	movl	$16568, (%esp)
	call	malloc
	movl	%eax, -16584(%ebp)
	cmpl	$0, -16584(%ebp)
	jne	.L149
	movl	-16560(%ebp), %eax
	movl	-16548(%ebp), %edx
	movl	-16552(%ebp), %ecx
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%eax
	movl	$0, -16664(%ebp)
	jmp	.L148
.L149:
	movl	$0, -16(%ebp)
	cmpl	$2, 12(%ebp)
	jne	.L151
	movl	-16548(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_SearchCentralDir
	movl	%eax, -16604(%ebp)
	cmpl	$0, -16604(%ebp)
	jne	.L153
	movl	$-1, -16588(%ebp)
.L153:
	movl	-16564(%ebp), %ebx
	movl	-16548(%ebp), %edx
	movl	-16552(%ebp), %ecx
	movl	$0, 12(%esp)
	movl	-16604(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L155
	movl	$-1, -16588(%ebp)
.L155:
	movl	-16548(%ebp), %edx
	leal	-16608(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getLong
	testl	%eax, %eax
	je	.L157
	movl	$-1, -16588(%ebp)
.L157:
	movl	-16548(%ebp), %edx
	leal	-16612(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getShort
	testl	%eax, %eax
	je	.L159
	movl	$-1, -16588(%ebp)
.L159:
	movl	-16548(%ebp), %edx
	leal	-16616(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getShort
	testl	%eax, %eax
	je	.L161
	movl	$-1, -16588(%ebp)
.L161:
	movl	-16548(%ebp), %edx
	leal	-16620(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getShort
	testl	%eax, %eax
	je	.L163
	movl	$-1, -16588(%ebp)
.L163:
	movl	-16548(%ebp), %edx
	leal	-16624(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getShort
	testl	%eax, %eax
	je	.L165
	movl	$-1, -16588(%ebp)
.L165:
	movl	-16624(%ebp), %edx
	movl	-16620(%ebp), %eax
	cmpl	%eax, %edx
	jne	.L167
	movl	-16616(%ebp), %eax
	testl	%eax, %eax
	jne	.L167
	movl	-16612(%ebp), %eax
	testl	%eax, %eax
	je	.L170
.L167:
	movl	$-103, -16588(%ebp)
.L170:
	movl	-16548(%ebp), %edx
	leal	-16596(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getLong
	testl	%eax, %eax
	je	.L171
	movl	$-1, -16588(%ebp)
.L171:
	movl	-16548(%ebp), %edx
	leal	-16600(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getLong
	testl	%eax, %eax
	je	.L173
	movl	$-1, -16588(%ebp)
.L173:
	movl	-16548(%ebp), %edx
	leal	-16628(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-16580(%ebp), %eax
	movl	%eax, (%esp)
	call	ziplocal_getShort
	testl	%eax, %eax
	je	.L175
	movl	$-1, -16588(%ebp)
.L175:
	movl	-16600(%ebp), %eax
	movl	-16596(%ebp), %edx
	addl	%edx, %eax
	cmpl	-16604(%ebp), %eax
	jbe	.L177
	cmpl	$0, -16588(%ebp)
	jne	.L177
	movl	$-103, -16588(%ebp)
.L177:
	cmpl	$0, -16588(%ebp)
	je	.L180
	movl	-16560(%ebp), %eax
	movl	-16548(%ebp), %edx
	movl	-16552(%ebp), %ecx
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%eax
	movl	$0, -16664(%ebp)
	jmp	.L148
.L180:
	movl	-16628(%ebp), %eax
	testl	%eax, %eax
	je	.L182
	movl	-16628(%ebp), %eax
	addl	$1, %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	testl	%eax, %eax
	je	.L182
	movl	-16576(%ebp), %esi
	movl	-16628(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	-16548(%ebp), %ecx
	movl	-16552(%ebp), %ebx
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%ebx, (%esp)
	call	*%esi
	movl	%eax, -16628(%ebp)
	movl	-16(%ebp), %edx
	movl	-16628(%ebp), %eax
	leal	(%edx,%eax), %eax
	movb	$0, (%eax)
.L182:
	movl	-16600(%ebp), %edx
	movl	-16596(%ebp), %eax
	addl	%eax, %edx
	movl	-16604(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -16592(%ebp)
	movl	-16592(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-16596(%ebp), %eax
	movl	%eax, -16632(%ebp)
	movl	$4080, -16636(%ebp)
	movl	-16636(%ebp), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -16640(%ebp)
	movl	-16564(%ebp), %ebx
	movl	-16600(%ebp), %eax
	addl	-16592(%ebp), %eax
	movl	-16548(%ebp), %edx
	movl	-16552(%ebp), %ecx
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L187
	movl	$-1, -16588(%ebp)
	jmp	.L187
.L188:
	movl	$4080, -16644(%ebp)
	movl	-16644(%ebp), %eax
	cmpl	-16632(%ebp), %eax
	jbe	.L189
	movl	-16632(%ebp), %eax
	movl	%eax, -16644(%ebp)
.L189:
	movl	-16576(%ebp), %edx
	movl	-16548(%ebp), %ecx
	movl	-16552(%ebp), %ebx
	movl	-16644(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-16640(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%ebx, (%esp)
	call	*%edx
	cmpl	-16644(%ebp), %eax
	je	.L191
	movl	$-1, -16588(%ebp)
.L191:
	cmpl	$0, -16588(%ebp)
	jne	.L193
	movl	-16644(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-16640(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-16580(%ebp), %eax
	addl	$36, %eax
	movl	%eax, (%esp)
	call	add_data_in_datablock
	movl	%eax, -16588(%ebp)
.L193:
	movl	-16644(%ebp), %eax
	subl	%eax, -16632(%ebp)
.L187:
	cmpl	$0, -16632(%ebp)
	je	.L195
	cmpl	$0, -16588(%ebp)
	je	.L188
.L195:
	cmpl	$0, -16640(%ebp)
	je	.L197
	movl	-16640(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L197:
	movl	-16592(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	-16624(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	-16564(%ebp), %ebx
	movl	-16600(%ebp), %eax
	addl	-16592(%ebp), %eax
	movl	-16548(%ebp), %edx
	movl	-16552(%ebp), %ecx
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L151
	movl	$-1, -16588(%ebp)
.L151:
	cmpl	$0, -16656(%ebp)
	je	.L200
	movl	-16(%ebp), %edx
	movl	-16656(%ebp), %eax
	movl	%edx, (%eax)
.L200:
	cmpl	$0, -16588(%ebp)
	je	.L202
	movl	-16(%ebp), %eax
	testl	%eax, %eax
	je	.L204
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L204:
	cmpl	$0, -16584(%ebp)
	je	.L206
	movl	-16584(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L206:
	movl	$0, -16664(%ebp)
	jmp	.L148
.L202:
	movl	-16584(%ebp), %eax
	movl	%eax, %ecx
	leal	-16580(%ebp), %edx
	movl	$16568, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	memcpy
	movl	-16584(%ebp), %edx
	movl	%edx, -16664(%ebp)
.L148:
	movl	-16664(%ebp), %eax
	movl	-12(%ebp), %edx
	xorl	%gs:20, %edx
	je	.L209
	call	__stack_chk_fail
.L209:
	addl	$16688, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	zipOpen2, .-zipOpen2
.globl zipOpen
	.type	zipOpen, @function
zipOpen:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	zipOpen2
	leave
	ret
	.size	zipOpen, .-zipOpen
	.section	.rodata
.LC0:
	.string	"-"
.LC1:
	.string	"1.2.3.3"
	.text
.globl zipOpenNewFileInZip3
	.type	zipOpenNewFileInZip3, @function
zipOpenNewFileInZip3:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$116, %esp
	movl	8(%ebp), %eax
	movl	%eax, -56(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -60(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -64(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -68(%ebp)
	movl	28(%ebp), %eax
	movl	%eax, -72(%ebp)
	movl	36(%ebp), %eax
	movl	%eax, -76(%ebp)
	movl	64(%ebp), %eax
	movl	%eax, -80(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -8(%ebp)
	xorl	%eax, %eax
	movl	$0, -40(%ebp)
	cmpl	$0, -56(%ebp)
	jne	.L213
	movl	$-102, -84(%ebp)
	jmp	.L215
.L213:
	cmpl	$0, 40(%ebp)
	je	.L216
	cmpl	$8, 40(%ebp)
	je	.L216
	movl	$-102, -84(%ebp)
	jmp	.L215
.L216:
	movl	-56(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-24(%ebp), %eax
	movl	44(%eax), %eax
	cmpl	$1, %eax
	jne	.L219
	movl	-56(%ebp), %eax
	movl	%eax, (%esp)
	call	zipCloseFileInZip
	movl	%eax, -40(%ebp)
	cmpl	$0, -40(%ebp)
	je	.L219
	movl	-40(%ebp), %edx
	movl	%edx, -84(%ebp)
	jmp	.L215
.L219:
	cmpl	$0, -60(%ebp)
	jne	.L222
	movl	$.LC0, -60(%ebp)
.L222:
	cmpl	$0, -76(%ebp)
	jne	.L224
	movl	$0, -32(%ebp)
	jmp	.L226
.L224:
	movl	-76(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, -32(%ebp)
.L226:
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, -28(%ebp)
	cmpl	$0, -64(%ebp)
	jne	.L227
	movl	-24(%ebp), %eax
	movl	$0, 16520(%eax)
	jmp	.L229
.L227:
	movl	-64(%ebp), %eax
	movl	24(%eax), %eax
	testl	%eax, %eax
	je	.L230
	movl	-64(%ebp), %eax
	movl	24(%eax), %edx
	movl	-24(%ebp), %eax
	movl	%edx, 16520(%eax)
	jmp	.L229
.L230:
	movl	-64(%ebp), %eax
	movl	24(%eax), %eax
	movl	-64(%ebp), %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_TmzDateToDosDate
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 16520(%eax)
.L229:
	movl	-24(%ebp), %eax
	movl	$0, 124(%eax)
	cmpl	$8, 44(%ebp)
	je	.L232
	cmpl	$9, 44(%ebp)
	jne	.L234
.L232:
	movl	-24(%ebp), %eax
	movl	124(%eax), %eax
	movl	%eax, %edx
	orl	$2, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 124(%eax)
.L234:
	cmpl	$2, 44(%ebp)
	jne	.L235
	movl	-24(%ebp), %eax
	movl	124(%eax), %eax
	movl	%eax, %edx
	orl	$4, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 124(%eax)
.L235:
	cmpl	$1, 44(%ebp)
	jne	.L237
	movl	-24(%ebp), %eax
	movl	124(%eax), %eax
	movl	%eax, %edx
	orl	$6, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 124(%eax)
.L237:
	cmpl	$0, -80(%ebp)
	je	.L239
	movl	-24(%ebp), %eax
	movl	124(%eax), %eax
	movl	%eax, %edx
	orl	$1, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 124(%eax)
.L239:
	movl	-24(%ebp), %eax
	movl	$0, 16524(%eax)
	movl	-24(%ebp), %edx
	movl	40(%ebp), %eax
	movl	%eax, 128(%edx)
	movl	-24(%ebp), %eax
	movl	$0, 16528(%eax)
	movl	-24(%ebp), %eax
	movl	$0, 104(%eax)
	movl	-24(%ebp), %eax
	movl	$0, 108(%eax)
	movl	-24(%ebp), %edx
	movl	48(%ebp), %eax
	movl	%eax, 132(%edx)
	movl	-24(%ebp), %eax
	movl	12(%eax), %ecx
	movl	-24(%ebp), %eax
	movl	32(%eax), %edx
	movl	-24(%ebp), %eax
	movl	28(%eax), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ecx
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 112(%eax)
	movl	32(%ebp), %eax
	addl	-28(%ebp), %eax
	addl	-32(%ebp), %eax
	leal	46(%eax), %edx
	movl	-24(%ebp), %eax
	movl	%edx, 120(%eax)
	movl	-24(%ebp), %eax
	movl	120(%eax), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 116(%eax)
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	movl	$4, 8(%esp)
	movl	$33639248, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$4, %eax
	movl	$2, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$6, %eax
	movl	$2, 8(%esp)
	movl	$20, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	124(%eax), %edx
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$8, %eax
	movl	$2, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	128(%eax), %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$10, %eax
	movl	$2, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	16520(%eax), %edx
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$12, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$16, %eax
	movl	$4, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$20, %eax
	movl	$4, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$24, %eax
	movl	$4, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	leal	28(%eax), %edx
	movl	$2, 8(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	leal	30(%eax), %edx
	movl	$2, 8(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	leal	32(%eax), %edx
	movl	$2, 8(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$34, %eax
	movl	$2, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	cmpl	$0, -64(%ebp)
	jne	.L241
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$36, %eax
	movl	$2, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	jmp	.L243
.L241:
	movl	-64(%ebp), %eax
	movl	28(%eax), %edx
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$36, %eax
	movl	$2, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
.L243:
	cmpl	$0, -64(%ebp)
	jne	.L244
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$38, %eax
	movl	$4, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	jmp	.L246
.L244:
	movl	-64(%ebp), %eax
	movl	32(%eax), %edx
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$38, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
.L246:
	movl	-24(%ebp), %eax
	movl	112(%eax), %edx
	movl	-24(%ebp), %eax
	movl	16556(%eax), %eax
	subl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	addl	$42, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
	movl	$0, -36(%ebp)
	jmp	.L247
.L248:
	movl	-24(%ebp), %eax
	movl	116(%eax), %edx
	movl	-36(%ebp), %eax
	leal	(%edx,%eax), %eax
	leal	46(%eax), %edx
	movl	-36(%ebp), %eax
	addl	-60(%ebp), %eax
	movzbl	(%eax), %eax
	movb	%al, (%edx)
	addl	$1, -36(%ebp)
.L247:
	movl	-36(%ebp), %eax
	cmpl	-28(%ebp), %eax
	jb	.L248
	movl	$0, -36(%ebp)
	jmp	.L250
.L251:
	movl	-24(%ebp), %eax
	movl	116(%eax), %edx
	movl	-28(%ebp), %eax
	addl	%eax, %edx
	movl	-36(%ebp), %eax
	leal	(%edx,%eax), %eax
	leal	46(%eax), %ecx
	movl	-72(%ebp), %edx
	movl	-36(%ebp), %eax
	leal	(%edx,%eax), %eax
	movzbl	(%eax), %eax
	movb	%al, (%ecx)
	addl	$1, -36(%ebp)
.L250:
	movl	-36(%ebp), %eax
	cmpl	32(%ebp), %eax
	jb	.L251
	movl	$0, -36(%ebp)
	jmp	.L253
.L254:
	movl	-24(%ebp), %eax
	movl	116(%eax), %edx
	movl	-28(%ebp), %eax
	addl	%eax, %edx
	movl	32(%ebp), %eax
	addl	%eax, %edx
	movl	-36(%ebp), %eax
	leal	(%edx,%eax), %eax
	leal	46(%eax), %edx
	movl	-36(%ebp), %eax
	addl	-76(%ebp), %eax
	movzbl	(%eax), %eax
	movb	%al, (%edx)
	addl	$1, -36(%ebp)
.L253:
	movl	-36(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L254
	movl	-24(%ebp), %eax
	movl	116(%eax), %eax
	testl	%eax, %eax
	jne	.L256
	movl	$-104, -84(%ebp)
	jmp	.L215
.L256:
	movl	-24(%ebp), %eax
	movl	32(%eax), %eax
	movl	-24(%ebp), %edx
	movl	$4, 12(%esp)
	movl	$67324752, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
	cmpl	$0, -40(%ebp)
	jne	.L258
	movl	-24(%ebp), %eax
	movl	32(%eax), %eax
	movl	-24(%ebp), %edx
	movl	$2, 12(%esp)
	movl	$20, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L258:
	cmpl	$0, -40(%ebp)
	jne	.L260
	movl	-24(%ebp), %eax
	movl	124(%eax), %edx
	movl	-24(%ebp), %eax
	movl	32(%eax), %eax
	movl	-24(%ebp), %ecx
	movl	$2, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L260:
	cmpl	$0, -40(%ebp)
	jne	.L262
	movl	-24(%ebp), %eax
	movl	128(%eax), %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	32(%eax), %eax
	movl	-24(%ebp), %ecx
	movl	$2, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L262:
	cmpl	$0, -40(%ebp)
	jne	.L264
	movl	-24(%ebp), %eax
	movl	16520(%eax), %edx
	movl	-24(%ebp), %eax
	movl	32(%eax), %eax
	movl	-24(%ebp), %ecx
	movl	$4, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L264:
	cmpl	$0, -40(%ebp)
	jne	.L266
	movl	-24(%ebp), %eax
	movl	32(%eax), %eax
	movl	-24(%ebp), %edx
	movl	$4, 12(%esp)
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L266:
	cmpl	$0, -40(%ebp)
	jne	.L268
	movl	-24(%ebp), %eax
	movl	32(%eax), %eax
	movl	-24(%ebp), %edx
	movl	$4, 12(%esp)
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L268:
	cmpl	$0, -40(%ebp)
	jne	.L270
	movl	-24(%ebp), %eax
	movl	32(%eax), %eax
	movl	-24(%ebp), %edx
	movl	$4, 12(%esp)
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L270:
	cmpl	$0, -40(%ebp)
	jne	.L272
	movl	-24(%ebp), %eax
	movl	32(%eax), %edx
	movl	-24(%ebp), %ecx
	movl	$2, 12(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L272:
	cmpl	$0, -40(%ebp)
	jne	.L274
	movl	-24(%ebp), %eax
	movl	32(%eax), %edx
	movl	-24(%ebp), %ecx
	movl	$2, 12(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -40(%ebp)
.L274:
	cmpl	$0, -40(%ebp)
	jne	.L276
	cmpl	$0, -28(%ebp)
	je	.L276
	movl	-24(%ebp), %eax
	movl	8(%eax), %ebx
	movl	-24(%ebp), %eax
	movl	32(%eax), %edx
	movl	-24(%ebp), %eax
	movl	28(%eax), %ecx
	movl	-28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-60(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	-28(%ebp), %eax
	je	.L276
	movl	$-1, -40(%ebp)
.L276:
	cmpl	$0, -40(%ebp)
	jne	.L280
	cmpl	$0, 24(%ebp)
	je	.L280
	movl	-24(%ebp), %eax
	movl	8(%eax), %ebx
	movl	-24(%ebp), %eax
	movl	32(%eax), %edx
	movl	-24(%ebp), %eax
	movl	28(%eax), %ecx
	movl	24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-68(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	24(%ebp), %eax
	je	.L280
	movl	$-1, -40(%ebp)
.L280:
	movl	-24(%ebp), %eax
	movl	$0, 52(%eax)
	movl	-24(%ebp), %eax
	movl	$16384, 64(%eax)
	movl	-24(%ebp), %edx
	addl	$136, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 60(%eax)
	movl	-24(%ebp), %eax
	movl	$0, 56(%eax)
	movl	-24(%ebp), %eax
	movl	$0, 68(%eax)
	cmpl	$0, -40(%ebp)
	jne	.L284
	movl	-24(%ebp), %eax
	movl	128(%eax), %eax
	cmpl	$8, %eax
	jne	.L284
	movl	-24(%ebp), %eax
	movl	132(%eax), %eax
	testl	%eax, %eax
	jne	.L284
	movl	-24(%ebp), %eax
	movl	$0, 80(%eax)
	movl	-24(%ebp), %eax
	movl	$0, 84(%eax)
	movl	-24(%ebp), %eax
	movl	$0, 88(%eax)
	cmpl	$0, 52(%ebp)
	jle	.L288
	negl	52(%ebp)
.L288:
	movl	-24(%ebp), %edx
	addl	$48, %edx
	movl	$56, 28(%esp)
	movl	$.LC1, 24(%esp)
	movl	60(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	56(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	52(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$8, 8(%esp)
	movl	44(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	deflateInit2_
	movl	%eax, -40(%ebp)
	cmpl	$0, -40(%ebp)
	jne	.L284
	movl	-24(%ebp), %eax
	movl	$1, 104(%eax)
.L284:
	movl	-24(%ebp), %eax
	movl	$0, 16548(%eax)
	cmpl	$0, -40(%ebp)
	jne	.L291
	cmpl	$0, -80(%ebp)
	je	.L291
	movl	-24(%ebp), %eax
	movl	$1, 16528(%eax)
	call	get_crc_table
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	%edx, 16544(%eax)
	movl	-24(%ebp), %eax
	movl	16544(%eax), %edx
	movl	-24(%ebp), %ecx
	addl	$16532, %ecx
	movl	68(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	%edx, 16(%esp)
	movl	%ecx, 12(%esp)
	movl	$12, 8(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-80(%ebp), %eax
	movl	%eax, (%esp)
	call	crypthead
	movl	%eax, -44(%ebp)
	movl	-44(%ebp), %edx
	movl	-24(%ebp), %eax
	movl	%edx, 16548(%eax)
	movl	-24(%ebp), %eax
	movl	8(%eax), %ebx
	movl	-24(%ebp), %eax
	movl	32(%eax), %edx
	movl	-24(%ebp), %eax
	movl	28(%eax), %ecx
	movl	-44(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	-44(%ebp), %eax
	je	.L291
	movl	$-1, -40(%ebp)
.L291:
	cmpl	$0, -40(%ebp)
	jne	.L295
	movl	-24(%ebp), %eax
	movl	$1, 44(%eax)
.L295:
	movl	-40(%ebp), %eax
	movl	%eax, -84(%ebp)
.L215:
	movl	-84(%ebp), %eax
	movl	-8(%ebp), %edx
	xorl	%gs:20, %edx
	je	.L298
	call	__stack_chk_fail
.L298:
	addl	$116, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	zipOpenNewFileInZip3, .-zipOpenNewFileInZip3
.globl zipOpenNewFileInZip2
	.type	zipOpenNewFileInZip2, @function
zipOpenNewFileInZip2:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	movl	$0, 60(%esp)
	movl	$0, 56(%esp)
	movl	$0, 52(%esp)
	movl	$8, 48(%esp)
	movl	$-15, 44(%esp)
	movl	48(%ebp), %eax
	movl	%eax, 40(%esp)
	movl	44(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	40(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	zipOpenNewFileInZip3
	leave
	ret
	.size	zipOpenNewFileInZip2, .-zipOpenNewFileInZip2
.globl zipOpenNewFileInZip
	.type	zipOpenNewFileInZip, @function
zipOpenNewFileInZip:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, 40(%esp)
	movl	44(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	40(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	zipOpenNewFileInZip2
	leave
	ret
	.size	zipOpenNewFileInZip, .-zipOpenNewFileInZip
	.type	zipFlushWriteBuffer, @function
zipFlushWriteBuffer:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$32, %esp
	movl	$0, -12(%ebp)
	movl	8(%ebp), %eax
	movl	16528(%eax), %eax
	testl	%eax, %eax
	je	.L304
	movl	$0, -16(%ebp)
	jmp	.L306
.L307:
	movl	8(%ebp), %eax
	movl	16544(%eax), %eax
	movl	8(%ebp), %edx
	addl	$16532, %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	decrypt_byte
	movl	%eax, -20(%ebp)
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	movzbl	136(%edx,%eax), %eax
	movzbl	%al, %ecx
	movl	8(%ebp), %eax
	movl	16544(%eax), %eax
	movl	8(%ebp), %edx
	addl	$16532, %edx
	movl	%ecx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	update_keys
	movl	-16(%ebp), %ecx
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	movzbl	136(%edx,%eax), %eax
	movzbl	%al, %eax
	xorl	-20(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 136(%ecx,%eax)
	addl	$1, -16(%ebp)
.L306:
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	cmpl	-16(%ebp), %eax
	ja	.L307
.L304:
	movl	8(%ebp), %eax
	movl	8(%eax), %esi
	movl	8(%ebp), %eax
	movl	108(%eax), %ecx
	movl	8(%ebp), %ebx
	addl	$136, %ebx
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	movl	%ecx, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%esi
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	cmpl	%eax, %edx
	je	.L308
	movl	$-1, -12(%ebp)
.L308:
	movl	8(%ebp), %eax
	movl	$0, 108(%eax)
	movl	-12(%ebp), %eax
	addl	$32, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	zipFlushWriteBuffer, .-zipFlushWriteBuffer
.globl zipWriteInFileInZip
	.type	zipWriteInFileInZip, @function
zipWriteInFileInZip:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, -8(%ebp)
	cmpl	$0, 8(%ebp)
	jne	.L312
	movl	$-102, -36(%ebp)
	jmp	.L314
.L312:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	44(%eax), %eax
	testl	%eax, %eax
	jne	.L315
	movl	$-102, -36(%ebp)
	jmp	.L314
.L315:
	movl	12(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 48(%eax)
	movl	-4(%ebp), %edx
	movl	16(%ebp), %eax
	movl	%eax, 52(%edx)
	movl	12(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	16524(%eax), %ecx
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	crc32
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 16524(%eax)
	jmp	.L317
.L318:
	movl	-4(%ebp), %eax
	movl	64(%eax), %eax
	testl	%eax, %eax
	jne	.L319
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	zipFlushWriteBuffer
	cmpl	$-1, %eax
	jne	.L321
	movl	$-1, -8(%ebp)
.L321:
	movl	-4(%ebp), %eax
	movl	$16384, 64(%eax)
	movl	-4(%ebp), %edx
	addl	$136, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 60(%eax)
.L319:
	cmpl	$0, -8(%ebp)
	jne	.L323
	movl	-4(%ebp), %eax
	movl	128(%eax), %eax
	cmpl	$8, %eax
	jne	.L325
	movl	-4(%ebp), %eax
	movl	132(%eax), %eax
	testl	%eax, %eax
	jne	.L325
	movl	-4(%ebp), %eax
	movl	68(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	-4(%ebp), %eax
	addl	$48, %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	deflate
	movl	%eax, -8(%ebp)
	movl	-4(%ebp), %eax
	movl	108(%eax), %edx
	movl	-4(%ebp), %eax
	movl	68(%eax), %eax
	subl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 108(%eax)
	jmp	.L317
.L325:
	movl	-4(%ebp), %eax
	movl	52(%eax), %edx
	movl	-4(%ebp), %eax
	movl	64(%eax), %eax
	cmpl	%eax, %edx
	jae	.L328
	movl	-4(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, -16(%ebp)
	jmp	.L330
.L328:
	movl	-4(%ebp), %eax
	movl	64(%eax), %eax
	movl	%eax, -16(%ebp)
.L330:
	movl	$0, -20(%ebp)
	jmp	.L331
.L332:
	movl	-4(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-4(%ebp), %eax
	movl	48(%eax), %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	leal	(%edx,%eax), %eax
	movzbl	(%eax), %eax
	movb	%al, (%ecx)
	addl	$1, -20(%ebp)
.L331:
	movl	-20(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jb	.L332
	movl	-4(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, %edx
	subl	-16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 52(%eax)
	movl	-4(%ebp), %eax
	movl	64(%eax), %eax
	movl	%eax, %edx
	subl	-16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 64(%eax)
	movl	-4(%ebp), %eax
	movl	48(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 48(%eax)
	movl	-4(%ebp), %eax
	movl	60(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 60(%eax)
	movl	-4(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, %edx
	addl	-16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 56(%eax)
	movl	-4(%ebp), %eax
	movl	68(%eax), %eax
	movl	%eax, %edx
	addl	-16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 68(%eax)
	movl	-4(%ebp), %eax
	movl	108(%eax), %eax
	movl	%eax, %edx
	addl	-16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 108(%eax)
.L317:
	cmpl	$0, -8(%ebp)
	jne	.L323
	movl	-4(%ebp), %eax
	movl	52(%eax), %eax
	testl	%eax, %eax
	jne	.L318
.L323:
	movl	-8(%ebp), %eax
	movl	%eax, -36(%ebp)
.L314:
	movl	-36(%ebp), %eax
	leave
	ret
	.size	zipWriteInFileInZip, .-zipWriteInFileInZip
.globl zipCloseFileInZipRaw
	.type	zipCloseFileInZipRaw, @function
zipCloseFileInZipRaw:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$52, %esp
	movl	$0, -16(%ebp)
	cmpl	$0, 8(%ebp)
	jne	.L337
	movl	$-102, -40(%ebp)
	jmp	.L339
.L337:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	44(%eax), %eax
	testl	%eax, %eax
	jne	.L340
	movl	$-102, -40(%ebp)
	jmp	.L339
.L340:
	movl	-8(%ebp), %eax
	movl	$0, 52(%eax)
	movl	-8(%ebp), %eax
	movl	128(%eax), %eax
	cmpl	$8, %eax
	jne	.L342
	movl	-8(%ebp), %eax
	movl	132(%eax), %eax
	testl	%eax, %eax
	jne	.L342
	jmp	.L345
.L346:
	movl	-8(%ebp), %eax
	movl	64(%eax), %eax
	testl	%eax, %eax
	jne	.L347
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	zipFlushWriteBuffer
	cmpl	$-1, %eax
	jne	.L349
	movl	$-1, -16(%ebp)
.L349:
	movl	-8(%ebp), %eax
	movl	$16384, 64(%eax)
	movl	-8(%ebp), %edx
	addl	$136, %edx
	movl	-8(%ebp), %eax
	movl	%edx, 60(%eax)
.L347:
	movl	-8(%ebp), %eax
	movl	68(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	-8(%ebp), %eax
	addl	$48, %eax
	movl	$4, 4(%esp)
	movl	%eax, (%esp)
	call	deflate
	movl	%eax, -16(%ebp)
	movl	-8(%ebp), %eax
	movl	108(%eax), %edx
	movl	-8(%ebp), %eax
	movl	68(%eax), %eax
	subl	-20(%ebp), %eax
	addl	%eax, %edx
	movl	-8(%ebp), %eax
	movl	%edx, 108(%eax)
.L345:
	cmpl	$0, -16(%ebp)
	je	.L346
.L342:
	cmpl	$1, -16(%ebp)
	jne	.L351
	movl	$0, -16(%ebp)
.L351:
	movl	-8(%ebp), %eax
	movl	108(%eax), %eax
	testl	%eax, %eax
	je	.L353
	cmpl	$0, -16(%ebp)
	jne	.L353
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	zipFlushWriteBuffer
	cmpl	$-1, %eax
	jne	.L353
	movl	$-1, -16(%ebp)
.L353:
	movl	-8(%ebp), %eax
	movl	128(%eax), %eax
	cmpl	$8, %eax
	jne	.L357
	movl	-8(%ebp), %eax
	movl	132(%eax), %eax
	testl	%eax, %eax
	jne	.L357
	movl	-8(%ebp), %eax
	addl	$48, %eax
	movl	%eax, (%esp)
	call	deflateEnd
	movl	%eax, -16(%ebp)
	movl	-8(%ebp), %eax
	movl	$0, 104(%eax)
.L357:
	movl	-8(%ebp), %eax
	movl	132(%eax), %eax
	testl	%eax, %eax
	jne	.L360
	movl	-8(%ebp), %eax
	movl	16524(%eax), %eax
	movl	%eax, 16(%ebp)
	movl	-8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, 12(%ebp)
.L360:
	movl	-8(%ebp), %eax
	movl	68(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	movl	16548(%eax), %eax
	addl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	movl	116(%eax), %eax
	leal	16(%eax), %edx
	movl	$4, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-8(%ebp), %eax
	movl	116(%eax), %eax
	leal	20(%eax), %edx
	movl	$4, 8(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue_inmemory
	movl	-8(%ebp), %eax
	movl	92(%eax), %eax
	cmpl	$1, %eax
	jne	.L362
	movl	-8(%ebp), %eax
	movl	116(%eax), %eax
	addl	$36, %eax
	movl	$2, 8(%esp)
	movl	$1, 4(%esp)
	movl	%eax, (%esp)
	call	ziplocal_putValue_inmemory
.L362:
	movl	-8(%ebp), %eax
	movl	116(%eax), %eax
	leal	24(%eax), %edx
	movl	$4, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue_inmemory
	cmpl	$0, -16(%ebp)
	jne	.L364
	movl	-8(%ebp), %eax
	movl	120(%eax), %ecx
	movl	-8(%ebp), %eax
	movl	116(%eax), %eax
	movl	-8(%ebp), %edx
	addl	$36, %edx
	movl	%ecx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	add_data_in_datablock
	movl	%eax, -16(%ebp)
.L364:
	movl	-8(%ebp), %eax
	movl	116(%eax), %eax
	movl	%eax, (%esp)
	call	free
	cmpl	$0, -16(%ebp)
	jne	.L366
	movl	-8(%ebp), %eax
	movl	12(%eax), %ecx
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %eax
	movl	28(%eax), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ecx
	movl	%eax, -24(%ebp)
	movl	-8(%ebp), %eax
	movl	16(%eax), %ebx
	movl	-8(%ebp), %eax
	movl	112(%eax), %eax
	leal	14(%eax), %ecx
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %eax
	movl	28(%eax), %eax
	movl	$0, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L368
	movl	$-1, -16(%ebp)
.L368:
	cmpl	$0, -16(%ebp)
	jne	.L370
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	movl	$4, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L370:
	cmpl	$0, -16(%ebp)
	jne	.L372
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	movl	$4, 12(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L372:
	cmpl	$0, -16(%ebp)
	jne	.L374
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	movl	$4, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L374:
	movl	-8(%ebp), %eax
	movl	16(%eax), %ecx
	movl	-24(%ebp), %ebx
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %eax
	movl	28(%eax), %eax
	movl	$0, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ecx
	testl	%eax, %eax
	je	.L366
	movl	$-1, -16(%ebp)
.L366:
	movl	-8(%ebp), %eax
	movl	16560(%eax), %eax
	leal	1(%eax), %edx
	movl	-8(%ebp), %eax
	movl	%edx, 16560(%eax)
	movl	-8(%ebp), %eax
	movl	$0, 44(%eax)
	movl	-16(%ebp), %eax
	movl	%eax, -40(%ebp)
.L339:
	movl	-40(%ebp), %eax
	addl	$52, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	zipCloseFileInZipRaw, .-zipCloseFileInZipRaw
.globl zipCloseFileInZip
	.type	zipCloseFileInZip, @function
zipCloseFileInZip:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	zipCloseFileInZipRaw
	leave
	ret
	.size	zipCloseFileInZip, .-zipCloseFileInZip
.globl zipClose
	.type	zipClose, @function
zipClose:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$64, %esp
	movl	$0, -16(%ebp)
	movl	$0, -20(%ebp)
	cmpl	$0, 8(%ebp)
	jne	.L381
	movl	$-102, -44(%ebp)
	jmp	.L383
.L381:
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	44(%eax), %eax
	cmpl	$1, %eax
	jne	.L384
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	zipCloseFileInZip
	movl	%eax, -16(%ebp)
.L384:
	cmpl	$0, 12(%ebp)
	jne	.L386
	movl	-12(%ebp), %eax
	movl	16564(%eax), %eax
	movl	%eax, 12(%ebp)
.L386:
	cmpl	$0, 12(%ebp)
	jne	.L388
	movl	$0, -28(%ebp)
	jmp	.L390
.L388:
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, -28(%ebp)
.L390:
	movl	-12(%ebp), %eax
	movl	12(%eax), %ecx
	movl	-12(%ebp), %eax
	movl	32(%eax), %edx
	movl	-12(%ebp), %eax
	movl	28(%eax), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ecx
	movl	%eax, -24(%ebp)
	cmpl	$0, -16(%ebp)
	jne	.L391
	movl	-12(%ebp), %eax
	movl	36(%eax), %eax
	movl	%eax, -32(%ebp)
	jmp	.L393
.L394:
	cmpl	$0, -16(%ebp)
	jne	.L395
	movl	-32(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L395
	movl	-12(%ebp), %eax
	movl	8(%eax), %esi
	movl	-32(%ebp), %eax
	movl	8(%eax), %ecx
	movl	-32(%ebp), %ebx
	addl	$16, %ebx
	movl	-12(%ebp), %eax
	movl	32(%eax), %edx
	movl	-12(%ebp), %eax
	movl	28(%eax), %eax
	movl	%ecx, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%esi
	movl	%eax, %edx
	movl	-32(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, %edx
	je	.L395
	movl	$-1, -16(%ebp)
.L395:
	movl	-32(%ebp), %eax
	movl	8(%eax), %eax
	addl	%eax, -20(%ebp)
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -32(%ebp)
.L393:
	cmpl	$0, -32(%ebp)
	jne	.L394
.L391:
	movl	-12(%ebp), %eax
	movl	36(%eax), %eax
	movl	%eax, (%esp)
	call	free_datablock
	cmpl	$0, -16(%ebp)
	jne	.L399
	movl	-12(%ebp), %eax
	movl	32(%eax), %eax
	movl	-12(%ebp), %edx
	movl	$4, 12(%esp)
	movl	$101010256, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L399:
	cmpl	$0, -16(%ebp)
	jne	.L401
	movl	-12(%ebp), %eax
	movl	32(%eax), %eax
	movl	-12(%ebp), %edx
	movl	$2, 12(%esp)
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L401:
	cmpl	$0, -16(%ebp)
	jne	.L403
	movl	-12(%ebp), %eax
	movl	32(%eax), %eax
	movl	-12(%ebp), %edx
	movl	$2, 12(%esp)
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L403:
	cmpl	$0, -16(%ebp)
	jne	.L405
	movl	-12(%ebp), %eax
	movl	16560(%eax), %edx
	movl	-12(%ebp), %eax
	movl	32(%eax), %eax
	movl	-12(%ebp), %ecx
	movl	$2, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L405:
	cmpl	$0, -16(%ebp)
	jne	.L407
	movl	-12(%ebp), %eax
	movl	16560(%eax), %edx
	movl	-12(%ebp), %eax
	movl	32(%eax), %eax
	movl	-12(%ebp), %ecx
	movl	$2, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L407:
	cmpl	$0, -16(%ebp)
	jne	.L409
	movl	-12(%ebp), %eax
	movl	32(%eax), %edx
	movl	-12(%ebp), %ecx
	movl	$4, 12(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L409:
	cmpl	$0, -16(%ebp)
	jne	.L411
	movl	-12(%ebp), %eax
	movl	16556(%eax), %edx
	movl	-24(%ebp), %eax
	movl	%eax, %ecx
	subl	%edx, %ecx
	movl	%ecx, %edx
	movl	-12(%ebp), %eax
	movl	32(%eax), %eax
	movl	-12(%ebp), %ecx
	movl	$4, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L411:
	cmpl	$0, -16(%ebp)
	jne	.L413
	movl	-12(%ebp), %eax
	movl	32(%eax), %edx
	movl	-12(%ebp), %ecx
	movl	$2, 12(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	ziplocal_putValue
	movl	%eax, -16(%ebp)
.L413:
	cmpl	$0, -16(%ebp)
	jne	.L415
	cmpl	$0, -28(%ebp)
	je	.L415
	movl	-12(%ebp), %eax
	movl	8(%eax), %ebx
	movl	-12(%ebp), %eax
	movl	32(%eax), %edx
	movl	-12(%ebp), %eax
	movl	28(%eax), %ecx
	movl	-28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	-28(%ebp), %eax
	je	.L415
	movl	$-1, -16(%ebp)
.L415:
	movl	-12(%ebp), %eax
	movl	20(%eax), %ecx
	movl	-12(%ebp), %eax
	movl	32(%eax), %edx
	movl	-12(%ebp), %eax
	movl	28(%eax), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ecx
	testl	%eax, %eax
	je	.L419
	cmpl	$0, -16(%ebp)
	jne	.L419
	movl	$-1, -16(%ebp)
.L419:
	movl	-12(%ebp), %eax
	movl	16564(%eax), %eax
	testl	%eax, %eax
	je	.L422
	movl	-12(%ebp), %eax
	movl	16564(%eax), %eax
	movl	%eax, (%esp)
	call	free
.L422:
	cmpl	$0, -12(%ebp)
	je	.L424
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L424:
	movl	-16(%ebp), %eax
	movl	%eax, -44(%ebp)
.L383:
	movl	-44(%ebp), %eax
	addl	$64, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	zipClose, .-zipClose
	.ident	"GCC: (GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu1)"
	.section	.note.GNU-stack,"",@progbits
