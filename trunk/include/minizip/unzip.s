	.file	"unzip.c"
.globl unz_copyright
	.section	.rodata
	.align 32
	.type	unz_copyright, @object
	.size	unz_copyright, 81
unz_copyright:
	.string	" unzip 1.01 Copyright 1998-2004 Gilles Vollant - http://www.winimage.com/zLibDll"
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
	.type	unzlocal_getByte, @function
unzlocal_getByte:
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
	jne	.L11
	movzbl	-1(%ebp), %eax
	movzbl	%al, %edx
	movl	16(%ebp), %eax
	movl	%edx, (%eax)
	movl	$0, -20(%ebp)
	jmp	.L13
.L11:
	movl	8(%ebp), %eax
	movl	24(%eax), %ecx
	movl	8(%ebp), %eax
	movl	28(%eax), %edx
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	*%ecx
	testl	%eax, %eax
	je	.L14
	movl	$-1, -20(%ebp)
	jmp	.L13
.L14:
	movl	$0, -20(%ebp)
.L13:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzlocal_getByte, .-unzlocal_getByte
	.type	unzlocal_getShort, @function
unzlocal_getShort:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getByte
	movl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L18
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getByte
	movl	%eax, -12(%ebp)
.L18:
	movl	-8(%ebp), %eax
	sall	$8, %eax
	addl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L20
	movl	16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%eax, (%edx)
	jmp	.L22
.L20:
	movl	16(%ebp), %eax
	movl	$0, (%eax)
.L22:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	unzlocal_getShort, .-unzlocal_getShort
	.type	unzlocal_getLong, @function
unzlocal_getLong:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getByte
	movl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L25
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getByte
	movl	%eax, -12(%ebp)
.L25:
	movl	-8(%ebp), %eax
	sall	$8, %eax
	addl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L27
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getByte
	movl	%eax, -12(%ebp)
.L27:
	movl	-8(%ebp), %eax
	sall	$16, %eax
	addl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L29
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getByte
	movl	%eax, -12(%ebp)
.L29:
	movl	-8(%ebp), %eax
	sall	$24, %eax
	addl	%eax, -4(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L31
	movl	16(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%eax, (%edx)
	jmp	.L33
.L31:
	movl	16(%ebp), %eax
	movl	$0, (%eax)
.L33:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	unzlocal_getLong, .-unzlocal_getLong
	.type	strcmpcasenosensitive_internal, @function
strcmpcasenosensitive_internal:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
.L36:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movb	%al, -1(%ebp)
	addl	$1, 8(%ebp)
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	movb	%al, -2(%ebp)
	addl	$1, 12(%ebp)
	cmpb	$96, -1(%ebp)
	jle	.L37
	cmpb	$122, -1(%ebp)
	jg	.L37
	movzbl	-1(%ebp), %eax
	subl	$32, %eax
	movb	%al, -1(%ebp)
.L37:
	cmpb	$96, -2(%ebp)
	jle	.L40
	cmpb	$122, -2(%ebp)
	jg	.L40
	movzbl	-2(%ebp), %eax
	subl	$32, %eax
	movb	%al, -2(%ebp)
.L40:
	cmpb	$0, -1(%ebp)
	jne	.L43
	cmpb	$0, -2(%ebp)
	jne	.L45
	movl	$0, -20(%ebp)
	jmp	.L47
.L45:
	movl	$-1, -20(%ebp)
.L47:
	movl	-20(%ebp), %eax
	movl	%eax, -24(%ebp)
	jmp	.L48
.L43:
	cmpb	$0, -2(%ebp)
	jne	.L49
	movl	$1, -24(%ebp)
	jmp	.L48
.L49:
	movzbl	-1(%ebp), %eax
	cmpb	-2(%ebp), %al
	jge	.L51
	movl	$-1, -24(%ebp)
	jmp	.L48
.L51:
	movzbl	-1(%ebp), %eax
	cmpb	-2(%ebp), %al
	jle	.L36
	movl	$1, -24(%ebp)
.L48:
	movl	-24(%ebp), %eax
	leave
	ret
	.size	strcmpcasenosensitive_internal, .-strcmpcasenosensitive_internal
.globl unzStringFileNameCompare
	.type	unzStringFileNameCompare, @function
unzStringFileNameCompare:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	cmpl	$0, 16(%ebp)
	jne	.L57
	movl	$1, 16(%ebp)
.L57:
	cmpl	$1, 16(%ebp)
	jne	.L59
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	strcmp
	movl	%eax, -4(%ebp)
	jmp	.L61
.L59:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	strcmpcasenosensitive_internal
	movl	%eax, -4(%ebp)
.L61:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	unzStringFileNameCompare, .-unzStringFileNameCompare
	.type	unzlocal_SearchCentralDir, @function
unzlocal_SearchCentralDir:
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
	je	.L64
	movl	$0, -36(%ebp)
	jmp	.L66
.L64:
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
	jbe	.L67
	movl	-8(%ebp), %eax
	movl	%eax, -16(%ebp)
.L67:
	movl	$1028, (%esp)
	call	malloc
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jne	.L69
	movl	$0, -36(%ebp)
	jmp	.L66
.L69:
	movl	$4, -12(%ebp)
	jmp	.L71
.L72:
	movl	-12(%ebp), %eax
	addl	$1024, %eax
	cmpl	-16(%ebp), %eax
	jbe	.L73
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	.L75
.L73:
	addl	$1024, -12(%ebp)
.L75:
	movl	-12(%ebp), %edx
	movl	-8(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -28(%ebp)
	movl	-28(%ebp), %edx
	movl	-8(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -40(%ebp)
	cmpl	$1028, -40(%ebp)
	jbe	.L76
	movl	$1028, -40(%ebp)
.L76:
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
	jne	.L77
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
	jne	.L77
	movl	-24(%ebp), %eax
	subl	$3, %eax
	movl	%eax, -32(%ebp)
	jmp	.L80
.L81:
	movl	-32(%ebp), %eax
	addl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$80, %al
	jne	.L80
	movl	-32(%ebp), %eax
	addl	-4(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$75, %al
	jne	.L80
	movl	-32(%ebp), %eax
	addl	-4(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %eax
	cmpb	$5, %al
	jne	.L80
	movl	-32(%ebp), %eax
	addl	-4(%ebp), %eax
	addl	$3, %eax
	movzbl	(%eax), %eax
	cmpb	$6, %al
	jne	.L80
	movl	-32(%ebp), %eax
	addl	-28(%ebp), %eax
	movl	%eax, -20(%ebp)
	jmp	.L86
.L80:
	cmpl	$0, -32(%ebp)
	setg	%al
	subl	$1, -32(%ebp)
	testb	%al, %al
	jne	.L81
.L86:
	cmpl	$0, -20(%ebp)
	jne	.L77
.L71:
	movl	-12(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jb	.L72
.L77:
	cmpl	$0, -4(%ebp)
	je	.L87
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L87:
	movl	-20(%ebp), %eax
	movl	%eax, -36(%ebp)
.L66:
	movl	-36(%ebp), %eax
	leave
	ret
	.size	unzlocal_SearchCentralDir, .-unzlocal_SearchCentralDir
.globl unzOpen2
	.type	unzOpen2, @function
unzOpen2:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$228, %esp
	movl	$0, -32(%ebp)
	movzbl	unz_copyright, %eax
	cmpb	$32, %al
	je	.L91
	movl	$0, -216(%ebp)
	jmp	.L93
.L91:
	cmpl	$0, 12(%ebp)
	jne	.L94
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	fill_fopen_filefunc
	jmp	.L96
.L94:
	movl	12(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -212(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -208(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -204(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -200(%ebp)
	movl	16(%edx), %eax
	movl	%eax, -196(%ebp)
	movl	20(%edx), %eax
	movl	%eax, -192(%ebp)
	movl	24(%edx), %eax
	movl	%eax, -188(%ebp)
	movl	28(%edx), %eax
	movl	%eax, -184(%ebp)
.L96:
	movl	-212(%ebp), %ecx
	movl	-184(%ebp), %edx
	movl	$5, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	*%ecx
	movl	%eax, -180(%ebp)
	movl	-180(%ebp), %eax
	testl	%eax, %eax
	jne	.L97
	movl	$0, -216(%ebp)
	jmp	.L93
.L97:
	movl	-180(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_SearchCentralDir
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L99
	movl	$-1, -32(%ebp)
.L99:
	movl	-196(%ebp), %ebx
	movl	-180(%ebp), %edx
	movl	-184(%ebp), %ecx
	movl	$0, 12(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L101
	movl	$-1, -32(%ebp)
.L101:
	movl	-180(%ebp), %edx
	leal	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L103
	movl	$-1, -32(%ebp)
.L103:
	movl	-180(%ebp), %edx
	leal	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L105
	movl	$-1, -32(%ebp)
.L105:
	movl	-180(%ebp), %edx
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L107
	movl	$-1, -32(%ebp)
.L107:
	movl	-180(%ebp), %edx
	leal	-212(%ebp), %eax
	addl	$36, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L109
	movl	$-1, -32(%ebp)
.L109:
	movl	-180(%ebp), %edx
	leal	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L111
	movl	$-1, -32(%ebp)
.L111:
	movl	-176(%ebp), %edx
	movl	-28(%ebp), %eax
	cmpl	%eax, %edx
	jne	.L113
	movl	-24(%ebp), %eax
	testl	%eax, %eax
	jne	.L113
	movl	-20(%ebp), %eax
	testl	%eax, %eax
	je	.L116
.L113:
	movl	$-103, -32(%ebp)
.L116:
	movl	-180(%ebp), %edx
	leal	-212(%ebp), %eax
	addl	$64, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L117
	movl	$-1, -32(%ebp)
.L117:
	movl	-180(%ebp), %edx
	leal	-212(%ebp), %eax
	addl	$68, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L119
	movl	$-1, -32(%ebp)
.L119:
	movl	-180(%ebp), %edx
	leal	-212(%ebp), %eax
	addl	$40, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L121
	movl	$-1, -32(%ebp)
.L121:
	movl	-144(%ebp), %eax
	movl	-148(%ebp), %edx
	addl	%edx, %eax
	cmpl	-12(%ebp), %eax
	jbe	.L123
	cmpl	$0, -32(%ebp)
	jne	.L123
	movl	$-103, -32(%ebp)
.L123:
	cmpl	$0, -32(%ebp)
	je	.L126
	movl	-192(%ebp), %eax
	movl	-180(%ebp), %edx
	movl	-184(%ebp), %ecx
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%eax
	movl	$0, -216(%ebp)
	jmp	.L93
.L126:
	movl	-144(%ebp), %edx
	movl	-148(%ebp), %eax
	addl	%eax, %edx
	movl	-12(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -168(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, -152(%ebp)
	movl	$0, -56(%ebp)
	movl	$0, -52(%ebp)
	movl	$180, (%esp)
	call	malloc
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, %ecx
	leal	-212(%ebp), %edx
	movl	$180, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	memcpy
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzGoToFirstFile
	movl	-8(%ebp), %eax
	movl	%eax, -216(%ebp)
.L93:
	movl	-216(%ebp), %eax
	addl	$228, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	unzOpen2, .-unzOpen2
.globl unzOpen
	.type	unzOpen, @function
unzOpen:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzOpen2
	leave
	ret
	.size	unzOpen, .-unzOpen
.globl unzClose
	.type	unzClose, @function
unzClose:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	cmpl	$0, 8(%ebp)
	jne	.L132
	movl	$-102, -20(%ebp)
	jmp	.L134
.L132:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	156(%eax), %eax
	testl	%eax, %eax
	je	.L135
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzCloseCurrentFile
.L135:
	movl	-4(%ebp), %eax
	movl	20(%eax), %ecx
	movl	-4(%ebp), %eax
	movl	32(%eax), %edx
	movl	-4(%ebp), %eax
	movl	28(%eax), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ecx
	cmpl	$0, -4(%ebp)
	je	.L137
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L137:
	movl	$0, -20(%ebp)
.L134:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzClose, .-unzClose
.globl unzGetGlobalInfo
	.type	unzGetGlobalInfo, @function
unzGetGlobalInfo:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	cmpl	$0, 8(%ebp)
	jne	.L141
	movl	$-102, -20(%ebp)
	jmp	.L143
.L141:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	40(%eax), %edx
	movl	36(%eax), %eax
	movl	12(%ebp), %ecx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	$0, -20(%ebp)
.L143:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzGetGlobalInfo, .-unzGetGlobalInfo
	.type	unzlocal_DosDateToTmuDate, @function
unzlocal_DosDateToTmuDate:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	shrl	$16, %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %edx
	andl	$31, %edx
	movl	12(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	-4(%ebp), %eax
	andl	$480, %eax
	shrl	$5, %eax
	leal	-1(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-4(%ebp), %eax
	andl	$65024, %eax
	shrl	$9, %eax
	leal	1980(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, 20(%eax)
	movl	8(%ebp), %eax
	andl	$63488, %eax
	movl	%eax, %edx
	shrl	$11, %edx
	movl	12(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	8(%ebp), %eax
	andl	$2016, %eax
	movl	%eax, %edx
	shrl	$5, %edx
	movl	12(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	andl	$31, %eax
	leal	(%eax,%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	leave
	ret
	.size	unzlocal_DosDateToTmuDate, .-unzlocal_DosDateToTmuDate
	.type	unzlocal_GetCurrentFileInfoInternal, @function
unzlocal_GetCurrentFileInfoInternal:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$132, %esp
	movl	$0, -16(%ebp)
	movl	$0, -24(%ebp)
	cmpl	$0, 8(%ebp)
	jne	.L148
	movl	$-102, -120(%ebp)
	jmp	.L150
.L148:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	16(%eax), %ebx
	movl	-8(%ebp), %eax
	movl	52(%eax), %edx
	movl	-8(%ebp), %eax
	movl	44(%eax), %eax
	leal	(%edx,%eax), %ecx
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
	je	.L151
	movl	$-1, -16(%ebp)
.L151:
	cmpl	$0, -16(%ebp)
	jne	.L153
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L155
	movl	$-1, -16(%ebp)
	jmp	.L153
.L155:
	movl	-20(%ebp), %eax
	cmpl	$33639248, %eax
	je	.L153
	movl	$-103, -16(%ebp)
.L153:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L158
	movl	$-1, -16(%ebp)
.L158:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$4, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L160
	movl	$-1, -16(%ebp)
.L160:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$8, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L162
	movl	$-1, -16(%ebp)
.L162:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$12, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L164
	movl	$-1, -16(%ebp)
.L164:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$16, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L166
	movl	$-1, -16(%ebp)
.L166:
	movl	-100(%ebp), %edx
	leal	-116(%ebp), %eax
	addl	$56, %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	unzlocal_DosDateToTmuDate
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$20, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L168
	movl	$-1, -16(%ebp)
.L168:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$24, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L170
	movl	$-1, -16(%ebp)
.L170:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$28, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L172
	movl	$-1, -16(%ebp)
.L172:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$32, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L174
	movl	$-1, -16(%ebp)
.L174:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$36, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L176
	movl	$-1, -16(%ebp)
.L176:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$40, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L178
	movl	$-1, -16(%ebp)
.L178:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$44, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L180
	movl	$-1, -16(%ebp)
.L180:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$48, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L182
	movl	$-1, -16(%ebp)
.L182:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-116(%ebp), %eax
	addl	$52, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L184
	movl	$-1, -16(%ebp)
.L184:
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %ecx
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L186
	movl	$-1, -16(%ebp)
.L186:
	movl	-84(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -24(%ebp)
	cmpl	$0, -16(%ebp)
	jne	.L188
	cmpl	$0, 20(%ebp)
	je	.L188
	movl	-84(%ebp), %eax
	cmpl	24(%ebp), %eax
	jae	.L191
	movl	-84(%ebp), %eax
	addl	20(%ebp), %eax
	movb	$0, (%eax)
	movl	-84(%ebp), %eax
	movl	%eax, -28(%ebp)
	jmp	.L193
.L191:
	movl	24(%ebp), %eax
	movl	%eax, -28(%ebp)
.L193:
	movl	-84(%ebp), %eax
	testl	%eax, %eax
	je	.L194
	cmpl	$0, 24(%ebp)
	je	.L194
	movl	-8(%ebp), %eax
	movl	4(%eax), %ebx
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %eax
	movl	28(%eax), %ecx
	movl	-28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	-28(%ebp), %eax
	je	.L194
	movl	$-1, -16(%ebp)
.L194:
	movl	-24(%ebp), %eax
	subl	-28(%ebp), %eax
	movl	%eax, -24(%ebp)
.L188:
	cmpl	$0, -16(%ebp)
	jne	.L198
	cmpl	$0, 28(%ebp)
	je	.L198
	movl	-80(%ebp), %eax
	cmpl	32(%ebp), %eax
	jae	.L201
	movl	-80(%ebp), %eax
	movl	%eax, -32(%ebp)
	jmp	.L203
.L201:
	movl	32(%ebp), %eax
	movl	%eax, -32(%ebp)
.L203:
	cmpl	$0, -24(%ebp)
	je	.L204
	movl	-8(%ebp), %eax
	movl	16(%eax), %ecx
	movl	-24(%ebp), %ebx
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %eax
	movl	28(%eax), %eax
	movl	$1, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ecx
	testl	%eax, %eax
	jne	.L206
	movl	$0, -24(%ebp)
	jmp	.L204
.L206:
	movl	$-1, -16(%ebp)
.L204:
	movl	-80(%ebp), %eax
	testl	%eax, %eax
	je	.L208
	cmpl	$0, 32(%ebp)
	je	.L208
	movl	-8(%ebp), %eax
	movl	4(%eax), %ebx
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %eax
	movl	28(%eax), %ecx
	movl	-32(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	-32(%ebp), %eax
	je	.L208
	movl	$-1, -16(%ebp)
.L208:
	movl	-80(%ebp), %eax
	movl	%eax, %edx
	subl	-32(%ebp), %edx
	movl	-24(%ebp), %eax
	leal	(%edx,%eax), %eax
	movl	%eax, -24(%ebp)
	jmp	.L212
.L198:
	movl	-80(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -24(%ebp)
.L212:
	cmpl	$0, -16(%ebp)
	jne	.L213
	cmpl	$0, 36(%ebp)
	je	.L213
	movl	-76(%ebp), %eax
	cmpl	40(%ebp), %eax
	jae	.L216
	movl	-76(%ebp), %eax
	addl	36(%ebp), %eax
	movb	$0, (%eax)
	movl	-76(%ebp), %eax
	movl	%eax, -36(%ebp)
	jmp	.L218
.L216:
	movl	40(%ebp), %eax
	movl	%eax, -36(%ebp)
.L218:
	cmpl	$0, -24(%ebp)
	je	.L219
	movl	-8(%ebp), %eax
	movl	16(%eax), %ecx
	movl	-24(%ebp), %ebx
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %eax
	movl	28(%eax), %eax
	movl	$1, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ecx
	testl	%eax, %eax
	jne	.L221
	movl	$0, -24(%ebp)
	jmp	.L219
.L221:
	movl	$-1, -16(%ebp)
.L219:
	movl	-76(%ebp), %eax
	testl	%eax, %eax
	je	.L223
	cmpl	$0, 40(%ebp)
	je	.L223
	movl	-8(%ebp), %eax
	movl	4(%eax), %ebx
	movl	-8(%ebp), %eax
	movl	32(%eax), %edx
	movl	-8(%ebp), %eax
	movl	28(%eax), %ecx
	movl	-36(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	-36(%ebp), %eax
	je	.L223
	movl	$-1, -16(%ebp)
.L223:
	movl	-76(%ebp), %eax
	movl	%eax, %edx
	subl	-36(%ebp), %edx
	movl	-24(%ebp), %eax
	leal	(%edx,%eax), %eax
	movl	%eax, -24(%ebp)
	jmp	.L227
.L213:
	movl	-76(%ebp), %eax
	movl	-24(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -24(%ebp)
.L227:
	cmpl	$0, -16(%ebp)
	jne	.L228
	cmpl	$0, 12(%ebp)
	je	.L228
	movl	12(%ebp), %eax
	movl	%eax, %ecx
	leal	-116(%ebp), %edx
	movl	$80, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	memcpy
.L228:
	cmpl	$0, -16(%ebp)
	jne	.L231
	cmpl	$0, 16(%ebp)
	je	.L231
	movl	16(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%eax, (%edx)
.L231:
	movl	-16(%ebp), %eax
	movl	%eax, -120(%ebp)
.L150:
	movl	-120(%ebp), %eax
	addl	$132, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	unzlocal_GetCurrentFileInfoInternal, .-unzlocal_GetCurrentFileInfoInternal
.globl unzGetCurrentFileInfo
	.type	unzGetCurrentFileInfo, @function
unzGetCurrentFileInfo:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	36(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_GetCurrentFileInfoInternal
	leave
	ret
	.size	unzGetCurrentFileInfo, .-unzGetCurrentFileInfo
.globl unzGoToFirstFile
	.type	unzGoToFirstFile, @function
unzGoToFirstFile:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, -4(%ebp)
	cmpl	$0, 8(%ebp)
	jne	.L238
	movl	$-102, -20(%ebp)
	jmp	.L240
.L238:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	68(%eax), %edx
	movl	-8(%ebp), %eax
	movl	%edx, 52(%eax)
	movl	-8(%ebp), %eax
	movl	$0, 48(%eax)
	movl	-8(%ebp), %eax
	addl	$152, %eax
	movl	-8(%ebp), %edx
	addl	$72, %edx
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_GetCurrentFileInfoInternal
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	sete	%al
	movzbl	%al, %edx
	movl	-8(%ebp), %eax
	movl	%edx, 56(%eax)
	movl	-4(%ebp), %eax
	movl	%eax, -20(%ebp)
.L240:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzGoToFirstFile, .-unzGoToFirstFile
.globl unzGoToNextFile
	.type	unzGoToNextFile, @function
unzGoToNextFile:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	cmpl	$0, 8(%ebp)
	jne	.L243
	movl	$-102, -20(%ebp)
	jmp	.L245
.L243:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	56(%eax), %eax
	testl	%eax, %eax
	jne	.L246
	movl	$-100, -20(%ebp)
	jmp	.L245
.L246:
	movl	-4(%ebp), %eax
	movl	36(%eax), %eax
	cmpl	$65535, %eax
	je	.L248
	movl	-4(%ebp), %eax
	movl	48(%eax), %eax
	leal	1(%eax), %edx
	movl	-4(%ebp), %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	jne	.L248
	movl	$-100, -20(%ebp)
	jmp	.L245
.L248:
	movl	-4(%ebp), %eax
	movl	52(%eax), %ecx
	movl	-4(%ebp), %eax
	movl	104(%eax), %edx
	movl	-4(%ebp), %eax
	movl	108(%eax), %eax
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	112(%eax), %eax
	leal	(%edx,%eax), %eax
	leal	(%ecx,%eax), %eax
	leal	46(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 52(%eax)
	movl	-4(%ebp), %eax
	movl	48(%eax), %eax
	leal	1(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 48(%eax)
	movl	-4(%ebp), %eax
	addl	$152, %eax
	movl	-4(%ebp), %edx
	addl	$72, %edx
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_GetCurrentFileInfoInternal
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	sete	%al
	movzbl	%al, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 56(%eax)
	movl	-8(%ebp), %eax
	movl	%eax, -20(%ebp)
.L245:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzGoToNextFile, .-unzGoToNextFile
.globl unzLocateFile
	.type	unzLocateFile, @function
unzLocateFile:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$424, %esp
	movl	8(%ebp), %eax
	movl	%eax, -372(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -376(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -4(%ebp)
	xorl	%eax, %eax
	cmpl	$0, -372(%ebp)
	jne	.L253
	movl	$-102, -380(%ebp)
	jmp	.L255
.L253:
	movl	-376(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	cmpl	$255, %eax
	jbe	.L256
	movl	$-102, -380(%ebp)
	jmp	.L255
.L256:
	movl	-372(%ebp), %eax
	movl	%eax, -268(%ebp)
	movl	-268(%ebp), %eax
	movl	56(%eax), %eax
	testl	%eax, %eax
	jne	.L258
	movl	$-100, -380(%ebp)
	jmp	.L255
.L258:
	movl	-268(%ebp), %eax
	movl	48(%eax), %eax
	movl	%eax, -280(%ebp)
	movl	-268(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, -284(%ebp)
	movl	-268(%ebp), %eax
	leal	-364(%ebp), %ecx
	leal	72(%eax), %edx
	movl	$80, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	memcpy
	movl	-268(%ebp), %eax
	movl	152(%eax), %eax
	movl	%eax, -276(%ebp)
	movl	-372(%ebp), %eax
	movl	%eax, (%esp)
	call	unzGoToFirstFile
	movl	%eax, -272(%ebp)
	jmp	.L260
.L261:
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$256, 12(%esp)
	leal	-261(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	-372(%ebp), %eax
	movl	%eax, (%esp)
	call	unzGetCurrentFileInfo
	movl	%eax, -272(%ebp)
	cmpl	$0, -272(%ebp)
	jne	.L260
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-376(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-261(%ebp), %eax
	movl	%eax, (%esp)
	call	unzStringFileNameCompare
	testl	%eax, %eax
	jne	.L263
	movl	$0, -380(%ebp)
	jmp	.L255
.L263:
	movl	-372(%ebp), %eax
	movl	%eax, (%esp)
	call	unzGoToNextFile
	movl	%eax, -272(%ebp)
.L260:
	cmpl	$0, -272(%ebp)
	je	.L261
	movl	-268(%ebp), %edx
	movl	-280(%ebp), %eax
	movl	%eax, 48(%edx)
	movl	-268(%ebp), %edx
	movl	-284(%ebp), %eax
	movl	%eax, 52(%edx)
	movl	-268(%ebp), %eax
	leal	72(%eax), %ecx
	leal	-364(%ebp), %edx
	movl	$80, %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	memcpy
	movl	-268(%ebp), %edx
	movl	-276(%ebp), %eax
	movl	%eax, 152(%edx)
	movl	-272(%ebp), %edx
	movl	%edx, -380(%ebp)
.L255:
	movl	-380(%ebp), %eax
	movl	-4(%ebp), %edx
	xorl	%gs:20, %edx
	je	.L267
	call	__stack_chk_fail
.L267:
	leave
	ret
	.size	unzLocateFile, .-unzLocateFile
.globl unzGetFilePos
	.type	unzGetFilePos, @function
unzGetFilePos:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	cmpl	$0, 8(%ebp)
	je	.L269
	cmpl	$0, 12(%ebp)
	jne	.L271
.L269:
	movl	$-102, -20(%ebp)
	jmp	.L272
.L271:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	56(%eax), %eax
	testl	%eax, %eax
	jne	.L273
	movl	$-100, -20(%ebp)
	jmp	.L272
.L273:
	movl	-4(%ebp), %eax
	movl	52(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	movl	-4(%ebp), %eax
	movl	48(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	$0, -20(%ebp)
.L272:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzGetFilePos, .-unzGetFilePos
.globl unzGoToFilePos
	.type	unzGoToFilePos, @function
unzGoToFilePos:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	cmpl	$0, 8(%ebp)
	je	.L277
	cmpl	$0, 12(%ebp)
	jne	.L279
.L277:
	movl	$-102, -20(%ebp)
	jmp	.L280
.L279:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 52(%eax)
	movl	12(%ebp), %eax
	movl	4(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 48(%eax)
	movl	-4(%ebp), %eax
	addl	$152, %eax
	movl	-4(%ebp), %edx
	addl	$72, %edx
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_GetCurrentFileInfoInternal
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	sete	%al
	movzbl	%al, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 56(%eax)
	movl	-8(%ebp), %eax
	movl	%eax, -20(%ebp)
.L280:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzGoToFilePos, .-unzGoToFilePos
	.type	unzlocal_CheckCurrentFileCoherencyHeader, @function
unzlocal_CheckCurrentFileCoherencyHeader:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$52, %esp
	movl	$0, -28(%ebp)
	movl	12(%ebp), %eax
	movl	$0, (%eax)
	movl	16(%ebp), %eax
	movl	$0, (%eax)
	movl	20(%ebp), %eax
	movl	$0, (%eax)
	movl	8(%ebp), %eax
	movl	16(%eax), %ebx
	movl	8(%ebp), %eax
	movl	152(%eax), %edx
	movl	8(%ebp), %eax
	movl	44(%eax), %eax
	leal	(%edx,%eax), %ecx
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	movl	$0, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L283
	movl	$-1, -40(%ebp)
	jmp	.L285
.L283:
	cmpl	$0, -28(%ebp)
	jne	.L286
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L288
	movl	$-1, -28(%ebp)
	jmp	.L286
.L288:
	movl	-8(%ebp), %eax
	cmpl	$67324752, %eax
	je	.L286
	movl	$-103, -28(%ebp)
.L286:
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L291
	movl	$-1, -28(%ebp)
.L291:
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L293
	movl	$-1, -28(%ebp)
.L293:
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L295
	movl	$-1, -28(%ebp)
	jmp	.L297
.L295:
	cmpl	$0, -28(%ebp)
	jne	.L297
	movl	8(%ebp), %eax
	movl	84(%eax), %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	je	.L297
	movl	$-103, -28(%ebp)
.L297:
	cmpl	$0, -28(%ebp)
	jne	.L300
	movl	8(%ebp), %eax
	movl	84(%eax), %eax
	testl	%eax, %eax
	je	.L300
	movl	8(%ebp), %eax
	movl	84(%eax), %eax
	cmpl	$8, %eax
	je	.L300
	movl	$-103, -28(%ebp)
.L300:
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L304
	movl	$-1, -28(%ebp)
.L304:
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L306
	movl	$-1, -28(%ebp)
	jmp	.L308
.L306:
	cmpl	$0, -28(%ebp)
	jne	.L308
	movl	8(%ebp), %eax
	movl	92(%eax), %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	je	.L308
	movl	-16(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L308
	movl	$-103, -28(%ebp)
.L308:
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L312
	movl	$-1, -28(%ebp)
	jmp	.L314
.L312:
	cmpl	$0, -28(%ebp)
	jne	.L314
	movl	8(%ebp), %eax
	movl	96(%eax), %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	je	.L314
	movl	-16(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L314
	movl	$-103, -28(%ebp)
.L314:
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getLong
	testl	%eax, %eax
	je	.L318
	movl	$-1, -28(%ebp)
	jmp	.L320
.L318:
	cmpl	$0, -28(%ebp)
	jne	.L320
	movl	8(%ebp), %eax
	movl	100(%eax), %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	je	.L320
	movl	-16(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L320
	movl	$-103, -28(%ebp)
.L320:
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L324
	movl	$-1, -28(%ebp)
	jmp	.L326
.L324:
	cmpl	$0, -28(%ebp)
	jne	.L326
	movl	8(%ebp), %eax
	movl	104(%eax), %edx
	movl	-20(%ebp), %eax
	cmpl	%eax, %edx
	je	.L326
	movl	$-103, -28(%ebp)
.L326:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	-20(%ebp), %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	32(%eax), %edx
	movl	8(%ebp), %ecx
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	unzlocal_getShort
	testl	%eax, %eax
	je	.L329
	movl	$-1, -28(%ebp)
.L329:
	movl	8(%ebp), %eax
	movl	152(%eax), %edx
	movl	-20(%ebp), %eax
	leal	(%edx,%eax), %eax
	leal	30(%eax), %edx
	movl	16(%ebp), %eax
	movl	%edx, (%eax)
	movl	-24(%ebp), %edx
	movl	20(%ebp), %eax
	movl	%edx, (%eax)
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	-24(%ebp), %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	movl	-28(%ebp), %eax
	movl	%eax, -40(%ebp)
.L285:
	movl	-40(%ebp), %eax
	addl	$52, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	unzlocal_CheckCurrentFileCoherencyHeader, .-unzlocal_CheckCurrentFileCoherencyHeader
	.section	.rodata
.LC0:
	.string	"1.2.3.3"
	.text
.globl unzOpenCurrentFile3
	.type	unzOpenCurrentFile3, @function
unzOpenCurrentFile3:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$96, %esp
	movl	8(%ebp), %eax
	movl	%eax, -60(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -64(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -68(%ebp)
	movl	24(%ebp), %eax
	movl	%eax, -72(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	$0, -28(%ebp)
	cmpl	$0, -60(%ebp)
	jne	.L333
	movl	$-102, -80(%ebp)
	jmp	.L335
.L333:
	movl	-60(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	-36(%ebp), %eax
	movl	56(%eax), %eax
	testl	%eax, %eax
	jne	.L336
	movl	$-102, -80(%ebp)
	jmp	.L335
.L336:
	movl	-36(%ebp), %eax
	movl	156(%eax), %eax
	testl	%eax, %eax
	je	.L338
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	unzCloseCurrentFile
.L338:
	leal	-48(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-44(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_CheckCurrentFileCoherencyHeader
	testl	%eax, %eax
	je	.L340
	movl	$-103, -80(%ebp)
	jmp	.L335
.L340:
	movl	$144, (%esp)
	call	malloc
	movl	%eax, -40(%ebp)
	cmpl	$0, -40(%ebp)
	jne	.L342
	movl	$-104, -80(%ebp)
	jmp	.L335
.L342:
	movl	$16384, (%esp)
	call	malloc
	movl	%eax, %edx
	movl	-40(%ebp), %eax
	movl	%edx, (%eax)
	movl	-44(%ebp), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 68(%eax)
	movl	-48(%ebp), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 72(%eax)
	movl	-40(%ebp), %eax
	movl	$0, 76(%eax)
	movl	-40(%ebp), %edx
	movl	20(%ebp), %eax
	movl	%eax, 140(%edx)
	movl	-40(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L344
	cmpl	$0, -40(%ebp)
	je	.L346
	movl	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L346:
	movl	$-104, -80(%ebp)
	jmp	.L335
.L344:
	movl	-40(%ebp), %eax
	movl	$0, 64(%eax)
	cmpl	$0, -64(%ebp)
	je	.L348
	movl	-36(%ebp), %eax
	movl	84(%eax), %eax
	movl	%eax, %edx
	movl	-64(%ebp), %eax
	movl	%edx, (%eax)
.L348:
	cmpl	$0, -68(%ebp)
	je	.L350
	movl	-68(%ebp), %eax
	movl	$6, (%eax)
	movl	-36(%ebp), %eax
	movl	80(%eax), %eax
	movl	%eax, %edx
	andl	$6, %edx
	movl	%edx, -76(%ebp)
	cmpl	$4, -76(%ebp)
	je	.L353
	cmpl	$6, -76(%ebp)
	je	.L354
	cmpl	$2, -76(%ebp)
	je	.L352
	jmp	.L350
.L354:
	movl	-68(%ebp), %eax
	movl	$1, (%eax)
	jmp	.L350
.L353:
	movl	-68(%ebp), %eax
	movl	$2, (%eax)
	jmp	.L350
.L352:
	movl	-68(%ebp), %eax
	movl	$9, (%eax)
.L350:
	movl	-36(%ebp), %eax
	movl	84(%eax), %eax
	testl	%eax, %eax
	je	.L355
	movl	-36(%ebp), %eax
	movl	84(%eax), %eax
	cmpl	$8, %eax
	je	.L355
	movl	$-103, -28(%ebp)
.L355:
	movl	-36(%ebp), %eax
	movl	92(%eax), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 84(%eax)
	movl	-40(%ebp), %eax
	movl	$0, 80(%eax)
	movl	-36(%ebp), %eax
	movl	84(%eax), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 132(%eax)
	movl	-36(%ebp), %eax
	movl	32(%eax), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 128(%eax)
	movl	-40(%ebp), %ecx
	movl	-36(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, 96(%ecx)
	movl	4(%edx), %eax
	movl	%eax, 100(%ecx)
	movl	8(%edx), %eax
	movl	%eax, 104(%ecx)
	movl	12(%edx), %eax
	movl	%eax, 108(%ecx)
	movl	16(%edx), %eax
	movl	%eax, 112(%ecx)
	movl	20(%edx), %eax
	movl	%eax, 116(%ecx)
	movl	24(%edx), %eax
	movl	%eax, 120(%ecx)
	movl	28(%edx), %eax
	movl	%eax, 124(%ecx)
	movl	-36(%ebp), %eax
	movl	44(%eax), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 136(%eax)
	movl	-40(%ebp), %eax
	movl	$0, 24(%eax)
	movl	-36(%ebp), %eax
	movl	84(%eax), %eax
	cmpl	$8, %eax
	jne	.L358
	cmpl	$0, 20(%ebp)
	jne	.L358
	movl	-40(%ebp), %eax
	movl	$0, 36(%eax)
	movl	-40(%ebp), %eax
	movl	$0, 40(%eax)
	movl	-40(%ebp), %eax
	movl	$0, 44(%eax)
	movl	-40(%ebp), %eax
	movl	$0, 4(%eax)
	movl	-40(%ebp), %eax
	movl	$0, 8(%eax)
	movl	-40(%ebp), %eax
	addl	$4, %eax
	movl	$56, 12(%esp)
	movl	$.LC0, 8(%esp)
	movl	$-15, 4(%esp)
	movl	%eax, (%esp)
	call	inflateInit2_
	movl	%eax, -28(%ebp)
	cmpl	$0, -28(%ebp)
	jne	.L361
	movl	-40(%ebp), %eax
	movl	$1, 64(%eax)
	jmp	.L358
.L361:
	cmpl	$0, -40(%ebp)
	je	.L363
	movl	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L363:
	movl	-28(%ebp), %eax
	movl	%eax, -80(%ebp)
	jmp	.L335
.L358:
	movl	-36(%ebp), %eax
	movl	96(%eax), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 88(%eax)
	movl	-36(%ebp), %eax
	movl	100(%eax), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	-36(%ebp), %eax
	movl	152(%eax), %edx
	movl	-32(%ebp), %eax
	leal	(%edx,%eax), %eax
	leal	30(%eax), %edx
	movl	-40(%ebp), %eax
	movl	%edx, 60(%eax)
	movl	-40(%ebp), %eax
	movl	$0, 8(%eax)
	movl	-36(%ebp), %edx
	movl	-40(%ebp), %eax
	movl	%eax, 156(%edx)
	cmpl	$0, -72(%ebp)
	je	.L365
	call	get_crc_table
	movl	%eax, %edx
	movl	-36(%ebp), %eax
	movl	%edx, 176(%eax)
	movl	-36(%ebp), %eax
	movl	176(%eax), %eax
	movl	-36(%ebp), %edx
	addl	$164, %edx
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	init_keys
	movl	-36(%ebp), %eax
	movl	16(%eax), %ebx
	movl	-36(%ebp), %eax
	movl	156(%eax), %eax
	movl	60(%eax), %edx
	movl	-36(%ebp), %eax
	movl	156(%eax), %eax
	movl	136(%eax), %eax
	leal	(%edx,%eax), %ecx
	movl	-36(%ebp), %eax
	movl	32(%eax), %edx
	movl	-36(%ebp), %eax
	movl	28(%eax), %eax
	movl	$0, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L367
	movl	$-104, -80(%ebp)
	jmp	.L335
.L367:
	movl	-36(%ebp), %eax
	movl	4(%eax), %ecx
	movl	-36(%ebp), %eax
	movl	32(%eax), %ebx
	movl	-36(%ebp), %eax
	movl	28(%eax), %edx
	movl	$12, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	%edx, (%esp)
	call	*%ecx
	cmpl	$11, %eax
	ja	.L369
	movl	$-104, -80(%ebp)
	jmp	.L335
.L369:
	movl	$0, -52(%ebp)
	jmp	.L371
.L372:
	movl	-52(%ebp), %ebx
	movl	-52(%ebp), %eax
	movzbl	-24(%ebp,%eax), %esi
	movl	-36(%ebp), %eax
	movl	176(%eax), %eax
	movl	-36(%ebp), %edx
	addl	$164, %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	decrypt_byte
	xorl	%esi, %eax
	movb	%al, -24(%ebp,%ebx)
	movzbl	-24(%ebp,%ebx), %eax
	movsbl	%al,%ecx
	movl	-36(%ebp), %eax
	movl	176(%eax), %eax
	movl	-36(%ebp), %edx
	addl	$164, %edx
	movl	%ecx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	update_keys
	addl	$1, -52(%ebp)
.L371:
	cmpl	$11, -52(%ebp)
	jle	.L372
	movl	-36(%ebp), %eax
	movl	156(%eax), %edx
	movl	-36(%ebp), %eax
	movl	156(%eax), %eax
	movl	60(%eax), %eax
	addl	$12, %eax
	movl	%eax, 60(%edx)
	movl	-36(%ebp), %eax
	movl	$1, 160(%eax)
.L365:
	movl	$0, -80(%ebp)
.L335:
	movl	-80(%ebp), %eax
	movl	-12(%ebp), %edx
	xorl	%gs:20, %edx
	je	.L375
	call	__stack_chk_fail
.L375:
	addl	$96, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	unzOpenCurrentFile3, .-unzOpenCurrentFile3
.globl unzOpenCurrentFile
	.type	unzOpenCurrentFile, @function
unzOpenCurrentFile:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzOpenCurrentFile3
	leave
	ret
	.size	unzOpenCurrentFile, .-unzOpenCurrentFile
.globl unzOpenCurrentFilePassword
	.type	unzOpenCurrentFilePassword, @function
unzOpenCurrentFilePassword:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzOpenCurrentFile3
	leave
	ret
	.size	unzOpenCurrentFilePassword, .-unzOpenCurrentFilePassword
.globl unzOpenCurrentFile2
	.type	unzOpenCurrentFile2, @function
unzOpenCurrentFile2:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, 16(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzOpenCurrentFile3
	leave
	ret
	.size	unzOpenCurrentFile2, .-unzOpenCurrentFile2
.globl unzReadCurrentFile
	.type	unzReadCurrentFile, @function
unzReadCurrentFile:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$92, %esp
	movl	$0, -16(%ebp)
	movl	$0, -20(%ebp)
	cmpl	$0, 8(%ebp)
	jne	.L383
	movl	$-102, -80(%ebp)
	jmp	.L385
.L383:
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-24(%ebp), %eax
	movl	156(%eax), %eax
	movl	%eax, -28(%ebp)
	cmpl	$0, -28(%ebp)
	jne	.L386
	movl	$-102, -80(%ebp)
	jmp	.L385
.L386:
	movl	-28(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L388
	movl	$-100, -80(%ebp)
	jmp	.L385
.L388:
	cmpl	$0, 16(%ebp)
	jne	.L390
	movl	$0, -80(%ebp)
	jmp	.L385
.L390:
	movl	12(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-28(%ebp), %edx
	movl	16(%ebp), %eax
	movl	%eax, 20(%edx)
	movl	-28(%ebp), %eax
	movl	92(%eax), %eax
	cmpl	16(%ebp), %eax
	jae	.L392
	movl	-28(%ebp), %eax
	movl	140(%eax), %eax
	testl	%eax, %eax
	jne	.L392
	movl	-28(%ebp), %eax
	movl	92(%eax), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 20(%eax)
.L392:
	movl	-28(%ebp), %eax
	movl	88(%eax), %edx
	movl	-28(%ebp), %eax
	movl	8(%eax), %eax
	leal	(%edx,%eax), %eax
	cmpl	16(%ebp), %eax
	jae	.L398
	movl	-28(%ebp), %eax
	movl	140(%eax), %eax
	testl	%eax, %eax
	je	.L398
	movl	-28(%ebp), %eax
	movl	88(%eax), %edx
	movl	-28(%ebp), %eax
	movl	8(%eax), %eax
	addl	%eax, %edx
	movl	-28(%ebp), %eax
	movl	%edx, 20(%eax)
	jmp	.L398
.L399:
	movl	-28(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L400
	movl	-28(%ebp), %eax
	movl	88(%eax), %eax
	testl	%eax, %eax
	je	.L400
	movl	$16384, -32(%ebp)
	movl	-28(%ebp), %eax
	movl	88(%eax), %eax
	cmpl	-32(%ebp), %eax
	jae	.L403
	movl	-28(%ebp), %eax
	movl	88(%eax), %eax
	movl	%eax, -32(%ebp)
.L403:
	cmpl	$0, -32(%ebp)
	jne	.L405
	movl	$0, -80(%ebp)
	jmp	.L385
.L405:
	movl	-28(%ebp), %eax
	movl	112(%eax), %ebx
	movl	-28(%ebp), %eax
	movl	60(%eax), %edx
	movl	-28(%ebp), %eax
	movl	136(%eax), %eax
	leal	(%edx,%eax), %ecx
	movl	-28(%ebp), %eax
	movl	128(%eax), %edx
	movl	-28(%ebp), %eax
	movl	124(%eax), %eax
	movl	$0, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L407
	movl	$-1, -80(%ebp)
	jmp	.L385
.L407:
	movl	-28(%ebp), %eax
	movl	100(%eax), %esi
	movl	-28(%ebp), %eax
	movl	(%eax), %ecx
	movl	-28(%ebp), %eax
	movl	128(%eax), %ebx
	movl	-28(%ebp), %eax
	movl	124(%eax), %edx
	movl	-32(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	%edx, (%esp)
	call	*%esi
	cmpl	-32(%ebp), %eax
	je	.L409
	movl	$-1, -80(%ebp)
	jmp	.L385
.L409:
	movl	-24(%ebp), %eax
	movl	160(%eax), %eax
	testl	%eax, %eax
	je	.L411
	movl	$0, -36(%ebp)
	jmp	.L413
.L414:
	movl	-28(%ebp), %eax
	movl	(%eax), %edx
	movl	-36(%ebp), %eax
	leal	(%edx,%eax), %esi
	movl	-28(%ebp), %eax
	movl	(%eax), %edx
	movl	-36(%ebp), %eax
	leal	(%edx,%eax), %edi
	movl	-28(%ebp), %eax
	movl	(%eax), %edx
	movl	-36(%ebp), %eax
	leal	(%edx,%eax), %eax
	movzbl	(%eax), %ebx
	movl	-24(%ebp), %eax
	movl	176(%eax), %eax
	movl	-24(%ebp), %edx
	addl	$164, %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	decrypt_byte
	xorl	%ebx, %eax
	movb	%al, (%edi)
	movzbl	(%edi), %eax
	movsbl	%al,%ecx
	movl	-24(%ebp), %eax
	movl	176(%eax), %eax
	movl	-24(%ebp), %edx
	addl	$164, %edx
	movl	%ecx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	update_keys
	movb	%al, (%esi)
	addl	$1, -36(%ebp)
.L413:
	movl	-36(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L414
.L411:
	movl	-28(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, %edx
	addl	-32(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 60(%eax)
	movl	-28(%ebp), %eax
	movl	88(%eax), %eax
	movl	%eax, %edx
	subl	-32(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 88(%eax)
	movl	-28(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-28(%ebp), %edx
	movl	-32(%ebp), %eax
	movl	%eax, 8(%edx)
.L400:
	movl	-28(%ebp), %eax
	movl	132(%eax), %eax
	testl	%eax, %eax
	je	.L415
	movl	-28(%ebp), %eax
	movl	140(%eax), %eax
	testl	%eax, %eax
	je	.L417
.L415:
	movl	-28(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L418
	movl	-28(%ebp), %eax
	movl	88(%eax), %eax
	testl	%eax, %eax
	jne	.L418
	movl	-20(%ebp), %eax
	movl	%eax, -80(%ebp)
	jmp	.L385
.L418:
	movl	-28(%ebp), %eax
	movl	20(%eax), %edx
	movl	-28(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, %edx
	jae	.L421
	movl	-28(%ebp), %eax
	movl	20(%eax), %eax
	movl	%eax, -40(%ebp)
	jmp	.L423
.L421:
	movl	-28(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -40(%ebp)
.L423:
	movl	$0, -44(%ebp)
	jmp	.L424
.L425:
	movl	-28(%ebp), %eax
	movl	16(%eax), %edx
	movl	-44(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-28(%ebp), %eax
	movl	4(%eax), %edx
	movl	-44(%ebp), %eax
	leal	(%edx,%eax), %eax
	movzbl	(%eax), %eax
	movb	%al, (%ecx)
	addl	$1, -44(%ebp)
.L424:
	movl	-44(%ebp), %eax
	cmpl	-40(%ebp), %eax
	jb	.L425
	movl	-28(%ebp), %eax
	movl	16(%eax), %edx
	movl	-28(%ebp), %eax
	movl	80(%eax), %ecx
	movl	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	crc32
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	movl	%edx, 80(%eax)
	movl	-28(%ebp), %eax
	movl	92(%eax), %eax
	movl	%eax, %edx
	subl	-40(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	-28(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, %edx
	subl	-40(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	-28(%ebp), %eax
	movl	20(%eax), %eax
	movl	%eax, %edx
	subl	-40(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 20(%eax)
	movl	-28(%ebp), %eax
	movl	16(%eax), %edx
	movl	-40(%ebp), %eax
	addl	%eax, %edx
	movl	-28(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-28(%ebp), %eax
	movl	4(%eax), %edx
	movl	-40(%ebp), %eax
	addl	%eax, %edx
	movl	-28(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-28(%ebp), %eax
	movl	24(%eax), %eax
	movl	%eax, %edx
	addl	-40(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 24(%eax)
	movl	-40(%ebp), %eax
	addl	%eax, -20(%ebp)
	jmp	.L398
.L417:
	movl	$2, -64(%ebp)
	movl	-28(%ebp), %eax
	movl	24(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	-28(%ebp), %eax
	movl	16(%eax), %eax
	movl	%eax, -56(%ebp)
	movl	-28(%ebp), %edx
	addl	$4, %edx
	movl	-64(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	inflate
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	js	.L427
	movl	-28(%ebp), %eax
	movl	28(%eax), %eax
	testl	%eax, %eax
	je	.L427
	movl	$-3, -16(%ebp)
.L427:
	movl	-28(%ebp), %eax
	movl	24(%eax), %eax
	movl	%eax, -52(%ebp)
	movl	-48(%ebp), %edx
	movl	-52(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -60(%ebp)
	movl	-28(%ebp), %eax
	movl	80(%eax), %edx
	movl	-60(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-56(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	crc32
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	movl	%edx, 80(%eax)
	movl	-28(%ebp), %eax
	movl	92(%eax), %eax
	movl	%eax, %edx
	subl	-60(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	-48(%ebp), %edx
	movl	-52(%ebp), %eax
	subl	%edx, %eax
	addl	%eax, -20(%ebp)
	cmpl	$1, -16(%ebp)
	jne	.L430
	movl	-20(%ebp), %eax
	movl	%eax, -80(%ebp)
	jmp	.L385
.L430:
	cmpl	$0, -16(%ebp)
	jne	.L432
.L398:
	movl	-28(%ebp), %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	jne	.L399
.L432:
	cmpl	$0, -16(%ebp)
	jne	.L433
	movl	-20(%ebp), %eax
	movl	%eax, -80(%ebp)
	jmp	.L385
.L433:
	movl	-16(%ebp), %eax
	movl	%eax, -80(%ebp)
.L385:
	movl	-80(%ebp), %eax
	addl	$92, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	unzReadCurrentFile, .-unzReadCurrentFile
.globl unztell
	.type	unztell, @function
unztell:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	cmpl	$0, 8(%ebp)
	jne	.L437
	movl	$-102, -20(%ebp)
	jmp	.L439
.L437:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	156(%eax), %eax
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L440
	movl	$-102, -20(%ebp)
	jmp	.L439
.L440:
	movl	-8(%ebp), %eax
	movl	24(%eax), %eax
	movl	%eax, -20(%ebp)
.L439:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unztell, .-unztell
.globl unzeof
	.type	unzeof, @function
unzeof:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	cmpl	$0, 8(%ebp)
	jne	.L444
	movl	$-102, -20(%ebp)
	jmp	.L446
.L444:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	156(%eax), %eax
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L447
	movl	$-102, -20(%ebp)
	jmp	.L446
.L447:
	movl	-8(%ebp), %eax
	movl	92(%eax), %eax
	testl	%eax, %eax
	jne	.L449
	movl	$1, -20(%ebp)
	jmp	.L446
.L449:
	movl	$0, -20(%ebp)
.L446:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzeof, .-unzeof
.globl unzGetLocalExtrafield
	.type	unzGetLocalExtrafield, @function
unzGetLocalExtrafield:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$36, %esp
	cmpl	$0, 8(%ebp)
	jne	.L453
	movl	$-102, -24(%ebp)
	jmp	.L455
.L453:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	156(%eax), %eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L456
	movl	$-102, -24(%ebp)
	jmp	.L455
.L456:
	movl	-12(%ebp), %eax
	movl	72(%eax), %edx
	movl	-12(%ebp), %eax
	movl	76(%eax), %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, -20(%ebp)
	cmpl	$0, 12(%ebp)
	jne	.L458
	movl	-20(%ebp), %eax
	movl	%eax, -24(%ebp)
	jmp	.L455
.L458:
	movl	16(%ebp), %eax
	cmpl	-20(%ebp), %eax
	jbe	.L460
	movl	-20(%ebp), %eax
	movl	%eax, -16(%ebp)
	jmp	.L462
.L460:
	movl	16(%ebp), %eax
	movl	%eax, -16(%ebp)
.L462:
	cmpl	$0, -16(%ebp)
	jne	.L463
	movl	$0, -24(%ebp)
	jmp	.L455
.L463:
	movl	-12(%ebp), %eax
	movl	112(%eax), %ebx
	movl	-12(%ebp), %eax
	movl	68(%eax), %edx
	movl	-12(%ebp), %eax
	movl	76(%eax), %eax
	leal	(%edx,%eax), %ecx
	movl	-12(%ebp), %eax
	movl	128(%eax), %edx
	movl	-12(%ebp), %eax
	movl	124(%eax), %eax
	movl	$0, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L465
	movl	$-1, -24(%ebp)
	jmp	.L455
.L465:
	movl	-12(%ebp), %eax
	movl	100(%eax), %ebx
	movl	-12(%ebp), %eax
	movl	128(%eax), %edx
	movl	-12(%ebp), %eax
	movl	124(%eax), %ecx
	movl	-16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	-16(%ebp), %eax
	je	.L467
	movl	$-1, -24(%ebp)
	jmp	.L455
.L467:
	movl	-16(%ebp), %ecx
	movl	%ecx, -24(%ebp)
.L455:
	movl	-24(%ebp), %eax
	addl	$36, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	unzGetLocalExtrafield, .-unzGetLocalExtrafield
.globl unzCloseCurrentFile
	.type	unzCloseCurrentFile, @function
unzCloseCurrentFile:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, -4(%ebp)
	cmpl	$0, 8(%ebp)
	jne	.L471
	movl	$-102, -20(%ebp)
	jmp	.L473
.L471:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	156(%eax), %eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L474
	movl	$-102, -20(%ebp)
	jmp	.L473
.L474:
	movl	-12(%ebp), %eax
	movl	92(%eax), %eax
	testl	%eax, %eax
	jne	.L476
	movl	-12(%ebp), %eax
	movl	140(%eax), %eax
	testl	%eax, %eax
	jne	.L476
	movl	-12(%ebp), %eax
	movl	80(%eax), %edx
	movl	-12(%ebp), %eax
	movl	84(%eax), %eax
	cmpl	%eax, %edx
	je	.L476
	movl	$-105, -4(%ebp)
.L476:
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L480
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	free
.L480:
	movl	-12(%ebp), %eax
	movl	$0, (%eax)
	movl	-12(%ebp), %eax
	movl	64(%eax), %eax
	testl	%eax, %eax
	je	.L482
	movl	-12(%ebp), %eax
	addl	$4, %eax
	movl	%eax, (%esp)
	call	inflateEnd
.L482:
	movl	-12(%ebp), %eax
	movl	$0, 64(%eax)
	cmpl	$0, -12(%ebp)
	je	.L484
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L484:
	movl	-8(%ebp), %eax
	movl	$0, 156(%eax)
	movl	-4(%ebp), %eax
	movl	%eax, -20(%ebp)
.L473:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzCloseCurrentFile, .-unzCloseCurrentFile
.globl unzGetGlobalComment
	.type	unzGetGlobalComment, @function
unzGetGlobalComment:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$36, %esp
	movl	$0, -8(%ebp)
	cmpl	$0, 8(%ebp)
	jne	.L488
	movl	$-102, -24(%ebp)
	jmp	.L490
.L488:
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-12(%ebp), %eax
	movl	40(%eax), %eax
	cmpl	-16(%ebp), %eax
	jae	.L491
	movl	-12(%ebp), %eax
	movl	40(%eax), %eax
	movl	%eax, -16(%ebp)
.L491:
	movl	-12(%ebp), %eax
	movl	16(%eax), %ebx
	movl	-12(%ebp), %eax
	movl	60(%eax), %eax
	leal	22(%eax), %ecx
	movl	-12(%ebp), %eax
	movl	32(%eax), %edx
	movl	-12(%ebp), %eax
	movl	28(%eax), %eax
	movl	$0, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	*%ebx
	testl	%eax, %eax
	je	.L493
	movl	$-1, -24(%ebp)
	jmp	.L490
.L493:
	cmpl	$0, -16(%ebp)
	je	.L495
	movl	12(%ebp), %eax
	movb	$0, (%eax)
	movl	-12(%ebp), %eax
	movl	4(%eax), %ebx
	movl	-12(%ebp), %eax
	movl	32(%eax), %edx
	movl	-12(%ebp), %eax
	movl	28(%eax), %ecx
	movl	-16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	*%ebx
	cmpl	-16(%ebp), %eax
	je	.L495
	movl	$-1, -24(%ebp)
	jmp	.L490
.L495:
	cmpl	$0, 12(%ebp)
	je	.L498
	movl	-12(%ebp), %eax
	movl	40(%eax), %eax
	cmpl	16(%ebp), %eax
	jae	.L498
	movl	-12(%ebp), %eax
	movl	40(%eax), %eax
	addl	12(%ebp), %eax
	movb	$0, (%eax)
.L498:
	movl	-16(%ebp), %eax
	movl	%eax, -24(%ebp)
.L490:
	movl	-24(%ebp), %eax
	addl	$36, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	unzGetGlobalComment, .-unzGetGlobalComment
.globl unzGetOffset
	.type	unzGetOffset, @function
unzGetOffset:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	cmpl	$0, 8(%ebp)
	jne	.L503
	movl	$-102, -20(%ebp)
	jmp	.L505
.L503:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	56(%eax), %eax
	testl	%eax, %eax
	jne	.L506
	movl	$0, -20(%ebp)
	jmp	.L505
.L506:
	movl	-4(%ebp), %eax
	movl	36(%eax), %eax
	testl	%eax, %eax
	je	.L508
	movl	-4(%ebp), %eax
	movl	36(%eax), %eax
	cmpl	$65535, %eax
	je	.L508
	movl	-4(%ebp), %eax
	movl	48(%eax), %edx
	movl	-4(%ebp), %eax
	movl	36(%eax), %eax
	cmpl	%eax, %edx
	jne	.L508
	movl	$0, -20(%ebp)
	jmp	.L505
.L508:
	movl	-4(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, -20(%ebp)
.L505:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzGetOffset, .-unzGetOffset
.globl unzSetOffset
	.type	unzSetOffset, @function
unzSetOffset:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	cmpl	$0, 8(%ebp)
	jne	.L514
	movl	$-102, -20(%ebp)
	jmp	.L516
.L514:
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %edx
	movl	12(%ebp), %eax
	movl	%eax, 52(%edx)
	movl	-4(%ebp), %eax
	movl	36(%eax), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 48(%eax)
	movl	-4(%ebp), %eax
	addl	$152, %eax
	movl	-4(%ebp), %edx
	addl	$72, %edx
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	unzlocal_GetCurrentFileInfoInternal
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	sete	%al
	movzbl	%al, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 56(%eax)
	movl	-8(%ebp), %eax
	movl	%eax, -20(%ebp)
.L516:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	unzSetOffset, .-unzSetOffset
	.ident	"GCC: (GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu1)"
	.section	.note.GNU-stack,"",@progbits
