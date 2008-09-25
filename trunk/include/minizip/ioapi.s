	.file	"ioapi.c"
	.section	.rodata
.LC0:
	.string	"rb"
.LC1:
	.string	"r+b"
.LC2:
	.string	"wb"
	.text
.globl fopen_file_func
	.type	fopen_file_func, @function
fopen_file_func:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, -4(%ebp)
	movl	$0, -8(%ebp)
	movl	16(%ebp), %eax
	andl	$3, %eax
	cmpl	$1, %eax
	jne	.L2
	movl	$.LC0, -8(%ebp)
	jmp	.L4
.L2:
	movl	16(%ebp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L5
	movl	$.LC1, -8(%ebp)
	jmp	.L4
.L5:
	movl	16(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L4
	movl	$.LC2, -8(%ebp)
.L4:
	cmpl	$0, 12(%ebp)
	je	.L8
	cmpl	$0, -8(%ebp)
	je	.L8
	movl	-8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -4(%ebp)
.L8:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	fopen_file_func, .-fopen_file_func
.globl fread_file_func
	.type	fread_file_func, @function
fread_file_func:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1, 4(%esp)
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	fread
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	fread_file_func, .-fread_file_func
.globl fwrite_file_func
	.type	fwrite_file_func, @function
fwrite_file_func:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1, 4(%esp)
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	fwrite
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	fwrite_file_func, .-fwrite_file_func
.globl ftell_file_func
	.type	ftell_file_func, @function
ftell_file_func:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ftell
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	ftell_file_func, .-ftell_file_func
.globl fseek_file_func
	.type	fseek_file_func, @function
fseek_file_func:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$0, -4(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -24(%ebp)
	cmpl	$1, -24(%ebp)
	je	.L21
	cmpl	$2, -24(%ebp)
	je	.L22
	cmpl	$0, -24(%ebp)
	je	.L20
	jmp	.L19
.L21:
	movl	$1, -4(%ebp)
	jmp	.L23
.L22:
	movl	$2, -4(%ebp)
	jmp	.L23
.L20:
	movl	$0, -4(%ebp)
	jmp	.L23
.L19:
	movl	$-1, -20(%ebp)
	jmp	.L24
.L23:
	movl	$0, -8(%ebp)
	movl	16(%ebp), %eax
	movl	12(%ebp), %ecx
	movl	-4(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	fseek
	movl	-8(%ebp), %eax
	movl	%eax, -20(%ebp)
.L24:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	fseek_file_func, .-fseek_file_func
.globl fclose_file_func
	.type	fclose_file_func, @function
fclose_file_func:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	fclose_file_func, .-fclose_file_func
.globl ferror_file_func
	.type	ferror_file_func, @function
ferror_file_func:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ferror
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	ferror_file_func, .-ferror_file_func
.globl fill_fopen_filefunc
	.type	fill_fopen_filefunc, @function
fill_fopen_filefunc:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	movl	$fopen_file_func, (%eax)
	movl	8(%ebp), %eax
	movl	$fread_file_func, 4(%eax)
	movl	8(%ebp), %eax
	movl	$fwrite_file_func, 8(%eax)
	movl	8(%ebp), %eax
	movl	$ftell_file_func, 12(%eax)
	movl	8(%ebp), %eax
	movl	$fseek_file_func, 16(%eax)
	movl	8(%ebp), %eax
	movl	$fclose_file_func, 20(%eax)
	movl	8(%ebp), %eax
	movl	$ferror_file_func, 24(%eax)
	movl	8(%ebp), %eax
	movl	$0, 28(%eax)
	popl	%ebp
	ret
	.size	fill_fopen_filefunc, .-fill_fopen_filefunc
	.ident	"GCC: (GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu1)"
	.section	.note.GNU-stack,"",@progbits
