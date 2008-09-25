	.file	"minizip.c"
	.section	.rodata
.LC0:
	.string	"-"
	.text
.globl filetime
	.type	filetime, @function
filetime:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$392, %esp
	movl	8(%ebp), %eax
	movl	%eax, -372(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -376(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -380(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -4(%ebp)
	xorl	%eax, %eax
	movl	$0, -268(%ebp)
	movl	$0, -276(%ebp)
	movl	$.LC0, 4(%esp)
	movl	-372(%ebp), %eax
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	je	.L2
	movl	-372(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, -280(%ebp)
	cmpl	$256, -280(%ebp)
	jle	.L4
	movl	$256, -280(%ebp)
.L4:
	movl	$255, 8(%esp)
	movl	-372(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-261(%ebp), %eax
	movl	%eax, (%esp)
	call	strncpy
	movb	$0, -5(%ebp)
	movl	-280(%ebp), %eax
	subl	$1, %eax
	movzbl	-261(%ebp,%eax), %eax
	cmpb	$47, %al
	jne	.L6
	movl	-280(%ebp), %eax
	subl	$1, %eax
	movb	$0, -261(%ebp,%eax)
.L6:
	leal	-368(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-261(%ebp), %eax
	movl	%eax, (%esp)
	call	stat
	testl	%eax, %eax
	jne	.L2
	movl	-304(%ebp), %eax
	movl	%eax, -276(%ebp)
	movl	$1, -268(%ebp)
.L2:
	leal	-276(%ebp), %eax
	movl	%eax, (%esp)
	call	localtime
	movl	%eax, -272(%ebp)
	movl	-272(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, %edx
	movl	-376(%ebp), %eax
	movl	%edx, (%eax)
	movl	-272(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, %edx
	movl	-376(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-272(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, %edx
	movl	-376(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	-272(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, %edx
	movl	-376(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	-272(%ebp), %eax
	movl	16(%eax), %eax
	movl	%eax, %edx
	movl	-376(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-272(%ebp), %eax
	movl	20(%eax), %eax
	movl	%eax, %edx
	movl	-376(%ebp), %eax
	movl	%edx, 20(%eax)
	movl	-268(%ebp), %eax
	movl	-4(%ebp), %edx
	xorl	%gs:20, %edx
	je	.L10
	call	__stack_chk_fail
.L10:
	leave
	ret
	.size	filetime, .-filetime
	.section	.rodata
.LC1:
	.string	"rb"
	.text
.globl check_exist_file
	.type	check_exist_file, @function
check_exist_file:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$1, -8(%ebp)
	movl	$.LC1, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jne	.L12
	movl	$0, -8(%ebp)
	jmp	.L14
.L12:
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
.L14:
	movl	-8(%ebp), %eax
	leave
	ret
	.size	check_exist_file, .-check_exist_file
	.section	.rodata
	.align 4
.LC2:
	.string	"MiniZip 1.01b, demo of zLib + Zip package written by Gilles Vollant"
	.align 4
.LC3:
	.string	"more info at http://www.winimage.com/zLibDll/unzip.html\n"
	.text
.globl do_banner
	.type	do_banner, @function
do_banner:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$.LC2, (%esp)
	call	puts
	movl	$.LC3, (%esp)
	call	puts
	leave
	ret
	.size	do_banner, .-do_banner
	.section	.rodata
	.align 4
.LC4:
	.string	"Usage : minizip [-o] [-a] [-0 to -9] [-p password] file.zip [files_to_add]\n\n  -o  Overwrite existing file.zip\n  -a  Append to existing file.zip\n  -0  Store only\n  -1  Compress faster\n  -9  Compress better\n"
	.text
.globl do_help
	.type	do_help, @function
do_help:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$.LC4, (%esp)
	call	puts
	leave
	ret
	.size	do_help, .-do_help
	.section	.rodata
.LC5:
	.string	"error in reading %s\n"
.LC6:
	.string	"file %s crc %x\n"
	.text
.globl getFileCrc
	.type	getFileCrc, @function
getFileCrc:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, -4(%ebp)
	movl	$0, -8(%ebp)
	movl	$.LC1, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -12(%ebp)
	movl	$0, -16(%ebp)
	movl	$0, -20(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L21
	movl	$-1, -8(%ebp)
.L21:
	cmpl	$0, -8(%ebp)
	jne	.L23
.L24:
	movl	$0, -8(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	fread
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	cmpl	16(%ebp), %eax
	jae	.L25
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	feof
	testl	%eax, %eax
	jne	.L25
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC5, (%esp)
	call	printf
	movl	$-1, -8(%ebp)
.L25:
	cmpl	$0, -16(%ebp)
	je	.L28
	movl	12(%ebp), %edx
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	crc32
	movl	%eax, -4(%ebp)
.L28:
	movl	-16(%ebp), %eax
	addl	%eax, -20(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L23
	cmpl	$0, -16(%ebp)
	jne	.L24
.L23:
	cmpl	$0, -12(%ebp)
	je	.L31
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
.L31:
	movl	20(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%eax, (%edx)
	movl	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC6, (%esp)
	call	printf
	movl	-8(%ebp), %eax
	leave
	ret
	.size	getFileCrc, .-getFileCrc
	.section	.rodata
.LC7:
	.string	"Error allocating memory"
.LC8:
	.string	".zip"
.LC9:
	.string	"error opening %s\n"
.LC10:
	.string	"creating %s\n"
	.align 4
.LC11:
	.string	"error in opening %s in zipfile\n"
	.align 4
.LC12:
	.string	"error in opening %s for reading\n"
	.align 4
.LC13:
	.string	"error in writing %s in the zipfile\n"
	.align 4
.LC14:
	.string	"error in closing %s in the zipfile\n"
.LC15:
	.string	"error in closing %s\n"
	.text
.globl mz_main
	.type	mz_main, @function
mz_main:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$484, %esp
	movl	12(%ebp), %eax
	movl	%eax, -408(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -8(%ebp)
	xorl	%eax, %eax
	movl	$1, -292(%ebp)
	movl	$-1, -296(%ebp)
	movl	$0, -300(%ebp)
	movl	$0, -308(%ebp)
	movl	$0, -312(%ebp)
	movl	$0, -316(%ebp)
	movl	$0, -320(%ebp)
	call	do_banner
	cmpl	$1, 8(%ebp)
	jne	.L35
	call	do_help
	movl	$0, -424(%ebp)
	jmp	.L37
.L35:
	movl	$1, -288(%ebp)
	jmp	.L38
.L39:
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$45, %al
	jne	.L40
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movl	%eax, -324(%ebp)
	jmp	.L42
.L43:
	movl	-324(%ebp), %eax
	movzbl	(%eax), %eax
	movb	%al, -281(%ebp)
	addl	$1, -324(%ebp)
	cmpb	$111, -281(%ebp)
	je	.L44
	cmpb	$79, -281(%ebp)
	jne	.L46
.L44:
	movl	$1, -292(%ebp)
.L46:
	cmpb	$97, -281(%ebp)
	je	.L47
	cmpb	$65, -281(%ebp)
	jne	.L49
.L47:
	movl	$2, -292(%ebp)
.L49:
	cmpb	$47, -281(%ebp)
	jle	.L50
	cmpb	$57, -281(%ebp)
	jg	.L50
	movsbl	-281(%ebp),%eax
	subl	$48, %eax
	movl	%eax, -296(%ebp)
.L50:
	cmpb	$112, -281(%ebp)
	je	.L53
	cmpb	$80, -281(%ebp)
	jne	.L42
.L53:
	movl	-288(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L42
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, -320(%ebp)
	addl	$1, -288(%ebp)
.L42:
	movl	-324(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L43
	jmp	.L57
.L40:
	cmpl	$0, -300(%ebp)
	jne	.L57
	movl	-288(%ebp), %eax
	movl	%eax, -300(%ebp)
.L57:
	addl	$1, -288(%ebp)
.L38:
	movl	-288(%ebp), %eax
	cmpl	8(%ebp), %eax
	jl	.L39
	movl	$16384, -312(%ebp)
	movl	-312(%ebp), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -316(%ebp)
	cmpl	$0, -316(%ebp)
	jne	.L60
	movl	$.LC7, (%esp)
	call	puts
	movl	$-104, -424(%ebp)
	jmp	.L37
.L60:
	cmpl	$0, -300(%ebp)
	jne	.L62
	movl	$0, -304(%ebp)
	jmp	.L64
.L62:
	movl	$0, -336(%ebp)
	movl	$1, -304(%ebp)
	movl	-300(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	movl	$255, 8(%esp)
	movl	%eax, 4(%esp)
	leal	-280(%ebp), %eax
	movl	%eax, (%esp)
	call	strncpy
	movb	$0, -24(%ebp)
	leal	-280(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, -332(%ebp)
	movl	$0, -328(%ebp)
	jmp	.L65
.L66:
	movl	-328(%ebp), %eax
	movzbl	-280(%ebp,%eax), %eax
	cmpb	$46, %al
	jne	.L67
	movl	$1, -336(%ebp)
.L67:
	addl	$1, -328(%ebp)
.L65:
	movl	-328(%ebp), %eax
	cmpl	-332(%ebp), %eax
	jl	.L66
	cmpl	$0, -336(%ebp)
	jne	.L70
	movl	$5, 8(%esp)
	movl	$.LC8, 4(%esp)
	leal	-280(%ebp), %ebx
	leal	-280(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	leal	(%ebx,%eax), %eax
	movl	%eax, (%esp)
	call	memcpy
.L70:
	cmpl	$2, -292(%ebp)
	jne	.L64
	leal	-280(%ebp), %eax
	movl	%eax, (%esp)
	call	check_exist_file
	testl	%eax, %eax
	jne	.L64
	movl	$1, -292(%ebp)
.L64:
	cmpl	$1, -304(%ebp)
	jne	.L74
	cmpl	$2, -292(%ebp)
	jne	.L76
	movl	$2, -420(%ebp)
	jmp	.L78
.L76:
	movl	$0, -420(%ebp)
.L78:
	movl	-420(%ebp), %edx
	movl	%edx, 4(%esp)
	leal	-280(%ebp), %eax
	movl	%eax, (%esp)
	call	zipOpen
	movl	%eax, -340(%ebp)
	cmpl	$0, -340(%ebp)
	jne	.L79
	leal	-280(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC9, (%esp)
	call	printf
	movl	$-1, -308(%ebp)
	jmp	.L81
.L79:
	leal	-280(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC10, (%esp)
	call	printf
.L81:
	movl	-300(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -288(%ebp)
	jmp	.L82
.L83:
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$45, %al
	je	.L84
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$47, %al
	jne	.L86
.L84:
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$111, %al
	je	.L87
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$79, %al
	je	.L87
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$97, %al
	je	.L87
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$65, %al
	je	.L87
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$112, %al
	je	.L87
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$80, %al
	je	.L87
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$47, %al
	jg	.L87
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	cmpb	$57, %al
	jg	.L86
.L87:
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strlen
	cmpl	$2, %eax
	je	.L95
.L86:
	movl	-288(%ebp), %eax
	sall	$2, %eax
	addl	-408(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -356(%ebp)
	movl	$0, -360(%ebp)
	movl	$0, -376(%ebp)
	movl	-376(%ebp), %eax
	movl	%eax, -380(%ebp)
	movl	-380(%ebp), %eax
	movl	%eax, -384(%ebp)
	movl	-384(%ebp), %eax
	movl	%eax, -388(%ebp)
	movl	-388(%ebp), %eax
	movl	%eax, -392(%ebp)
	movl	-392(%ebp), %eax
	movl	%eax, -396(%ebp)
	movl	$0, -372(%ebp)
	movl	$0, -368(%ebp)
	movl	$0, -364(%ebp)
	leal	-396(%ebp), %eax
	addl	$24, %eax
	movl	%eax, 8(%esp)
	leal	-396(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-356(%ebp), %eax
	movl	%eax, (%esp)
	call	filetime
	cmpl	$0, -320(%ebp)
	je	.L96
	cmpl	$0, -308(%ebp)
	jne	.L96
	movl	-312(%ebp), %edx
	leal	-360(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	-316(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-356(%ebp), %eax
	movl	%eax, (%esp)
	call	getFileCrc
	movl	%eax, -308(%ebp)
.L96:
	movl	-360(%ebp), %eax
	movl	%eax, -416(%ebp)
	cmpl	$0, -296(%ebp)
	je	.L99
	movl	$8, -412(%ebp)
	jmp	.L101
.L99:
	movl	$0, -412(%ebp)
.L101:
	movl	-416(%ebp), %edx
	movl	%edx, 60(%esp)
	movl	-320(%ebp), %eax
	movl	%eax, 56(%esp)
	movl	$0, 52(%esp)
	movl	$8, 48(%esp)
	movl	$-15, 44(%esp)
	movl	$0, 40(%esp)
	movl	-296(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	-412(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	leal	-396(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-356(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-340(%ebp), %eax
	movl	%eax, (%esp)
	call	zipOpenNewFileInZip3
	movl	%eax, -308(%ebp)
	cmpl	$0, -308(%ebp)
	je	.L102
	movl	-356(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC11, (%esp)
	call	printf
	jmp	.L104
.L102:
	movl	$.LC1, 4(%esp)
	movl	-356(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -348(%ebp)
	cmpl	$0, -348(%ebp)
	jne	.L104
	movl	$-1, -308(%ebp)
	movl	-356(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC12, (%esp)
	call	printf
.L104:
	cmpl	$0, -308(%ebp)
	jne	.L106
.L107:
	movl	$0, -308(%ebp)
	movl	-312(%ebp), %edx
	movl	-348(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$1, 4(%esp)
	movl	-316(%ebp), %eax
	movl	%eax, (%esp)
	call	fread
	movl	%eax, -352(%ebp)
	movl	-352(%ebp), %eax
	cmpl	-312(%ebp), %eax
	jge	.L108
	movl	-348(%ebp), %eax
	movl	%eax, (%esp)
	call	feof
	testl	%eax, %eax
	jne	.L108
	movl	-356(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC5, (%esp)
	call	printf
	movl	$-1, -308(%ebp)
.L108:
	cmpl	$0, -352(%ebp)
	jle	.L111
	movl	-352(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-316(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-340(%ebp), %eax
	movl	%eax, (%esp)
	call	zipWriteInFileInZip
	movl	%eax, -308(%ebp)
	cmpl	$0, -308(%ebp)
	jns	.L111
	movl	-356(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC13, (%esp)
	call	printf
.L111:
	cmpl	$0, -308(%ebp)
	jne	.L106
	cmpl	$0, -352(%ebp)
	jg	.L107
.L106:
	cmpl	$0, -348(%ebp)
	je	.L115
	movl	-348(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
.L115:
	cmpl	$0, -308(%ebp)
	jns	.L117
	movl	$-1, -308(%ebp)
	jmp	.L95
.L117:
	movl	-340(%ebp), %eax
	movl	%eax, (%esp)
	call	zipCloseFileInZip
	movl	%eax, -308(%ebp)
	cmpl	$0, -308(%ebp)
	je	.L95
	movl	-356(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC14, (%esp)
	call	printf
.L95:
	addl	$1, -288(%ebp)
.L82:
	movl	-288(%ebp), %eax
	cmpl	8(%ebp), %eax
	jge	.L120
	cmpl	$0, -308(%ebp)
	je	.L83
.L120:
	movl	$0, 4(%esp)
	movl	-340(%ebp), %eax
	movl	%eax, (%esp)
	call	zipClose
	movl	%eax, -344(%ebp)
	cmpl	$0, -344(%ebp)
	je	.L124
	leal	-280(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC15, (%esp)
	call	printf
	jmp	.L124
.L74:
	call	do_help
.L124:
	movl	-316(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	movl	$0, -424(%ebp)
.L37:
	movl	-424(%ebp), %eax
	movl	-8(%ebp), %edx
	xorl	%gs:20, %edx
	je	.L126
	call	__stack_chk_fail
.L126:
	addl	$484, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	mz_main, .-mz_main
	.ident	"GCC: (GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu1)"
	.section	.note.GNU-stack,"",@progbits
