	.section	__TEXT,__text,regular,pure_instructions
	.ios_version_min 8, 0
	.globl	_add1                    ; -- Begin function add
	.p2align	2
_add1:                                   ; @add
	.cfi_startproc
; BB#0:
	sub	sp, sp, #16             ; =16
Lcfi0:
	.cfi_def_cfa_offset 16
	str	w0, [sp, #12]
	str	w1, [sp, #8]
	ldr	w0, [sp, #12]
	ldr	w1, [sp, #8]
	add		w0, w0, w1
	add	sp, sp, #16             ; =16
	ret
	.cfi_endproc
                                        ; -- End function

.subsections_via_symbols
