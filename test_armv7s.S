	.section	__TEXT,__text,regular,pure_instructions
	.ios_version_min 8, 0
	.syntax unified
	.globl	_add1                    @ -- Begin function add
	.p2align	1
	.code	16                      @ @add
	.thumb_func	_add1
_add1:
@ BB#0:
	sub	sp, #8
	str	r0, [sp, #4]
	str	r1, [sp]
	ldr	r0, [sp, #4]
	ldr	r1, [sp]
	add	r0, r1
	add	sp, #8
	bx	lr
                                        @ -- End function

.subsections_via_symbols
