	.file	"float.c"
	.section	.rodata
.LC5:
	.string	"%3.f\t%6.2f\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x78,0x6
	.cfi_escape 0x10,0x3,0x2,0x75,0x7c
	subl	$48, %esp
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	fldz
	fstps	-24(%ebp)
	flds	.LC1@GOTOFF(%ebx)
	fstps	-20(%ebp)
	flds	.LC2@GOTOFF(%ebx)
	fstps	-16(%ebp)
	flds	-24(%ebp)
	fstps	-28(%ebp)
	jmp	.L2
.L3:
	flds	-28(%ebp)
	flds	.LC3@GOTOFF(%ebx)
	fsubrp	%st, %st(1)
	fldl	.LC4@GOTOFF(%ebx)
	fmulp	%st, %st(1)
	fstps	-12(%ebp)
	flds	-28(%ebp)
	flds	-12(%ebp)
	subl	$12, %esp
	leal	-8(%esp), %esp
	fstpl	(%esp)
	leal	-8(%esp), %esp
	fstpl	(%esp)
	leal	.LC5@GOTOFF(%ebx), %eax
	pushl	%eax
	call	printf@PLT
	addl	$32, %esp
	flds	-28(%ebp)
	fadds	-16(%ebp)
	fstps	-28(%ebp)
.L2:
	flds	-28(%ebp)
	flds	-20(%ebp)
	fucomip	%st(1), %st
	fstp	%st(0)
	jnb	.L3
	movl	$0, %eax
	leal	-8(%ebp), %esp
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 4
.LC1:
	.long	1133903872
	.align 4
.LC2:
	.long	1101004800
	.align 4
.LC3:
	.long	1107296256
	.align 8
.LC4:
	.long	1908874354
	.long	1071761180
	.section	.text.__x86.get_pc_thunk.bx,"axG",@progbits,__x86.get_pc_thunk.bx,comdat
	.globl	__x86.get_pc_thunk.bx
	.hidden	__x86.get_pc_thunk.bx
	.type	__x86.get_pc_thunk.bx, @function
__x86.get_pc_thunk.bx:
.LFB1:
	.cfi_startproc
	movl	(%esp), %ebx
	ret
	.cfi_endproc
.LFE1:
	.ident	"GCC: (Ubuntu 7.2.0-8ubuntu3.2) 7.2.0"
	.section	.note.GNU-stack,"",@progbits
