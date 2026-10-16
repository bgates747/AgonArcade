	.section	.text,"ax",@progbits
	.assume	ADL = 1
	.file	"inspect.cpp"
	.globl	_lookup_phase                   ; -- Begin function lookup_phase
	.type	_lookup_phase,@function
_lookup_phase:                          ; @lookup_phase
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	(ix + 6), hl
	ld	(ix + 9), de
	pop	ix
	jp	__ZN10span_phase7paintedEjj
	.local	.Lfunc_end0
.Lfunc_end0:
	.size	_lookup_phase, .Lfunc_end0-_lookup_phase
                                        ; -- End function
	.weak	__ZN10span_phase7paintedEjj     ; -- Begin function _ZN10span_phase7paintedEjj
	.type	__ZN10span_phase7paintedEjj,@function
__ZN10span_phase7paintedEjj:            ; @_ZN10span_phase7paintedEjj
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	de, -224
	xor	a, a
	lea	hl, iy + 0
	add	hl, de
	ld	de, -108
	or	a, a
	sbc	hl, de
	jp	c, .LBB1_4
; %bb.1:
	ld	bc, -104
	ld	de, __ZN10span_phaseL11DepthModuloE
	add	iy, bc
	ld	c, 1
	lea	hl, iy + 0
	call	__ishl
	push	hl
	pop	bc
	ex	de, hl
	add	hl, bc
	ld	hl, (hl)
	ld	iy, 0
	ex	de, hl
	ld	iyl, e
	ld	iyh, d
	ex	de, hl
	ld	bc, (ix + 9)
	add	iy, bc
	lea	hl, iy + 0
	ld	de, -8000
	add	hl, de
	push	hl
	pop	bc
	ld	de, 8000
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	push	bc
	pop	hl
	jr	nc, .LBB1_3
; %bb.2:
	lea	hl, iy + 0
	.local	.LBB1_3
.LBB1_3:
	ld	de, 4000
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	.local	.LBB1_4
.LBB1_4:
	pop	ix
	ret
	.local	.Lfunc_end1
.Lfunc_end1:
	.size	__ZN10span_phase7paintedEjj, .Lfunc_end1-__ZN10span_phase7paintedEjj
                                        ; -- End function
	.globl	_original_phase                 ; -- Begin function original_phase
	.type	_original_phase,@function
_original_phase:                        ; @original_phase
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	d, 0
	ld	bc, 116
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	c, .LBB2_2
; %bb.1:
	ld	bc, -96
	ld	hl, 800000
	add	iy, bc
	lea	bc, iy + 0
	call	__idivu
	xor	a, a
	ld	e, a
	ld	bc, (ix + 9)
	call	__ladd
	ld	bc, 8000
	ld	a, d
	call	__lremu
	ld	bc, 4000
	call	__lcmpu
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	d, a
	.local	.LBB2_2
.LBB2_2:
	ld	a, d
	pop	ix
	ret
	.local	.Lfunc_end2
.Lfunc_end2:
	.size	_original_phase, .Lfunc_end2-_original_phase
                                        ; -- End function
	.section	.rodata,"a",@progbits
	.local	__ZN10span_phaseL11DepthModuloE
__ZN10span_phaseL11DepthModuloE:
	dw	4000                            ; 0xfa0
	dw	888                             ; 0x378
	dw	0                               ; 0x0
	dw	727                             ; 0x2d7
	dw	2666                            ; 0xa6a
	dw	5538                            ; 0x15a2
	dw	1142                            ; 0x476
	dw	5333                            ; 0x14d5
	dw	2000                            ; 0x7d0
	dw	7058                            ; 0x1b92
	dw	4444                            ; 0x115c
	dw	2105                            ; 0x839
	dw	0                               ; 0x0
	dw	6095                            ; 0x17cf
	dw	4363                            ; 0x110b
	dw	2782                            ; 0xade
	dw	1333                            ; 0x535
	dw	0                               ; 0x0
	dw	6769                            ; 0x1a71
	dw	5629                            ; 0x15fd
	dw	4571                            ; 0x11db
	dw	3586                            ; 0xe02
	dw	2666                            ; 0xa6a
	dw	1806                            ; 0x70e
	dw	1000                            ; 0x3e8
	dw	242                             ; 0xf2
	dw	7529                            ; 0x1d69
	dw	6857                            ; 0x1ac9
	dw	6222                            ; 0x184e
	dw	5621                            ; 0x15f5
	dw	5052                            ; 0x13bc
	dw	4512                            ; 0x11a0
	dw	4000                            ; 0xfa0
	dw	3512                            ; 0xdb8
	dw	3047                            ; 0xbe7
	dw	2604                            ; 0xa2c
	dw	2181                            ; 0x885
	dw	1777                            ; 0x6f1
	dw	1391                            ; 0x56f
	dw	1021                            ; 0x3fd
	dw	666                             ; 0x29a
	dw	326                             ; 0x146
	dw	0                               ; 0x0
	dw	7686                            ; 0x1e06
	dw	7384                            ; 0x1cd8
	dw	7094                            ; 0x1bb6
	dw	6814                            ; 0x1a9e
	dw	6545                            ; 0x1991
	dw	6285                            ; 0x188d
	dw	6035                            ; 0x1793
	dw	5793                            ; 0x16a1
	dw	5559                            ; 0x15b7
	dw	5333                            ; 0x14d5
	dw	5114                            ; 0x13fa
	dw	4903                            ; 0x1327
	dw	4698                            ; 0x125a
	dw	4500                            ; 0x1194
	dw	4307                            ; 0x10d3
	dw	4121                            ; 0x1019
	dw	3940                            ; 0xf64
	dw	3764                            ; 0xeb4
	dw	3594                            ; 0xe0a
	dw	3428                            ; 0xd64
	dw	3267                            ; 0xcc3
	dw	3111                            ; 0xc27
	dw	2958                            ; 0xb8e
	dw	2810                            ; 0xafa
	dw	2666                            ; 0xa6a
	dw	2526                            ; 0x9de
	dw	2389                            ; 0x955
	dw	2256                            ; 0x8d0
	dw	2126                            ; 0x84e
	dw	2000                            ; 0x7d0
	dw	1876                            ; 0x754
	dw	1756                            ; 0x6dc
	dw	1638                            ; 0x666
	dw	1523                            ; 0x5f3
	dw	1411                            ; 0x583
	dw	1302                            ; 0x516
	dw	1195                            ; 0x4ab
	dw	1090                            ; 0x442
	dw	988                             ; 0x3dc
	dw	888                             ; 0x378
	dw	791                             ; 0x317
	dw	695                             ; 0x2b7
	dw	602                             ; 0x25a
	dw	510                             ; 0x1fe
	dw	421                             ; 0x1a5
	dw	333                             ; 0x14d
	dw	247                             ; 0xf7
	dw	163                             ; 0xa3
	dw	80                              ; 0x50
	dw	0                               ; 0x0
	dw	7920                            ; 0x1ef0
	dw	7843                            ; 0x1ea3
	dw	7766                            ; 0x1e56
	dw	7692                            ; 0x1e0c
	dw	7619                            ; 0x1dc3
	dw	7547                            ; 0x1d7b
	dw	7476                            ; 0x1d34
	dw	7407                            ; 0x1cef
	dw	7339                            ; 0x1cab
	dw	7272                            ; 0x1c68
	dw	7207                            ; 0x1c27
	dw	7142                            ; 0x1be6
	dw	7079                            ; 0x1ba7
	dw	7017                            ; 0x1b69
	dw	6956                            ; 0x1b2c
	dw	6896                            ; 0x1af0
	dw	6837                            ; 0x1ab5
	dw	6779                            ; 0x1a7b
	dw	6722                            ; 0x1a42
	dw	6666                            ; 0x1a0a
	dw	6611                            ; 0x19d3
	dw	6557                            ; 0x199d
	dw	6504                            ; 0x1968
	dw	6451                            ; 0x1933
	dw	6400                            ; 0x1900
	dw	6349                            ; 0x18cd
	dw	6299                            ; 0x189b

	.ident	"clang version 15.0.7 (https://github.com/AgonPlatform/agon-llvm-project.git c76386c0083e6a6236ff774275227e2389f85538)"
	.extern	__idivu
	.extern	__Unwind_SjLj_Register
	.extern	__Unwind_SjLj_Unregister
	.extern	__lremu
	.extern	__lcmpu
	.extern	__frameset0
	.extern	__ishl
	.extern	__ladd
