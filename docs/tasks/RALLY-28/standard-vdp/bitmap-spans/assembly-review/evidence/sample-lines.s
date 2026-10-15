	.section	.text,"ax",@progbits
	.assume	ADL = 1
	.file	"main.cpp"
	.globl	_main                           ; -- Begin function main
	.type	_main,@function
_main:                                  ; @main
	.local	.Lfunc_begin0
.Lfunc_begin0:
; %bb.0:
	ld	hl, -335
	call	__frameset
	ld	bc, -305
	lea	hl, ix + 0
	add	hl, bc
	ld	bc, -314
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	lea	hl, ix - 38
	push	ix
	ld	bc, -308
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	call	_mos_sysvars
	ld	(__ZN12_GLOBAL__N_13sysE), hl
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	ld	hl, ___const.main.init
	ld	iy, 32
	lea	bc, iy + 0
	ldir
	push	iy
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	ld	hl, 11585
	push	hl
	ld	hl, __ZL5Setup
	push	hl
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15fenceEv
	bit	0, a
	jr	nz, .LBB0_2
; %bb.1:
	ld	hl, _.str
	ld	(__ZN12_GLOBAL__N_17failureE), hl
	.local	.LBB0_2
.LBB0_2:
	ld	de, _.str.6
	ld	hl, __ZN12_GLOBAL__N_16pixelsE+12
	ld	bc, -311
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	lea	hl, iy + 11
	push	ix
	ld	bc, -308
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	lea	hl, iy + 0
	ld	bc, -320
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	bc, 6
	ld	iy, 0
	.local	.LBB0_3
.LBB0_3:                                ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_12 Depth 2
                                        ;     Child Loop BB0_20 Depth 2
                                        ;     Child Loop BB0_30 Depth 2
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_33
; %bb.4:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_17failureE)
	ld	de, _.str.1
	push	de
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	call	_strcmp
	ld	bc, -317
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	pop	de
	pop	de
	ld	de, _.str.6
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB0_33
; %bb.5:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	a, iyl
	ld	c, 3
	call	__bremu
	cp	a, 1
	ld	hl, 40
	jr	z, .LBB0_7
; %bb.6:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, 280
	.local	.LBB0_7
.LBB0_7:                                ;   in Loop: Header=BB0_3 Depth=1
	or	a, a
	ld	de, 160
	push	ix
	ld	bc, -314
	push	af
	add	ix, bc
	pop	af
	ld	(ix + 0), de
	pop	ix
	jr	z, .LBB0_9
; %bb.8:                                ;   in Loop: Header=BB0_3 Depth=1
	push	ix
	ld	bc, -314
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	.local	.LBB0_9
.LBB0_9:                                ;   in Loop: Header=BB0_3 Depth=1
	lea	hl, iy + 0
	ld	de, 3
	or	a, a
	sbc	hl, de
	ld	hl, 0
	jr	c, .LBB0_11
; %bb.10:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, 4000
	.local	.LBB0_11
.LBB0_11:                               ;   in Loop: Header=BB0_3 Depth=1
	push	ix
	ld	bc, -323
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	push	de
	push	iy
	call	__ZN12_GLOBAL__N_15labelEjij
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -323
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_14drawEij
	pop	hl
	pop	hl
	bit	0, a
	ld	de, 0
	jp	z, .LBB0_32
	.local	.LBB0_12
.LBB0_12:                               ;   Parent Loop BB0_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	push	de
	pop	iy
	ld	bc, 3
	add	iy, bc
	lea	hl, iy + 0
	ld	bc, 27
	or	a, a
	sbc	hl, bc
	jr	z, .LBB0_17
; %bb.13:                               ;   in Loop: Header=BB0_12 Depth=2
	ld	bc, -326
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	ld	hl, ___const.main.ys
	add	hl, de
	ld	de, (hl)
	ld	bc, -323
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -329
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	push	de
	call	__ZN12_GLOBAL__N_17paintedEij
	pop	hl
	pop	hl
	bit	0, a
	ld	hl, 11
	jr	nz, .LBB0_15
; %bb.14:                               ;   in Loop: Header=BB0_12 Depth=2
	ld	hl, 8
	.local	.LBB0_15
.LBB0_15:                               ;   in Loop: Header=BB0_12 Depth=2
	push	hl
	ld	bc, -329
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_15pointEjjjj
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	ld	bc, -326
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	de, (hl)
	jp	nz, .LBB0_12
; %bb.16:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, _.str.3
	ld	(__ZN12_GLOBAL__N_17failureE), hl
	.local	.LBB0_17
.LBB0_17:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	de, 18181
	ld	bc, -323
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	add	hl, de
	ld	bc, 8000
	call	__iremu
	ld	de, 4000
	or	a, a
	sbc	hl, de
	ld	hl, 9
	ld	de, -329
	lea	iy, ix + 0
	push	af
	add	iy, de
	pop	af
	ld	(iy + 0), hl
	jr	c, .LBB0_19
; %bb.18:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, 15
	ld	bc, -329
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	.local	.LBB0_19
.LBB0_19:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	lea	hl, iy + 0
	ld	de, -105
	add	hl, de
	push	ix
	ld	bc, -323
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	de, -96
	add	iy, de
	scf
	sbc	hl, hl
	.local	.LBB0_20
.LBB0_20:                               ;   Parent Loop BB0_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	push	ix
	ld	de, -326
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	bc, 2
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	p, .LBB0_28
; %bb.21:                               ;   in Loop: Header=BB0_20 Depth=2
	ld	de, -323
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	bc, 320
	or	a, a
	sbc	hl, bc
	ld	bc, -314
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	(hl), iy
	jr	nc, .LBB0_24
; %bb.22:                               ;   in Loop: Header=BB0_20 Depth=2
	ld	hl, 2
	push	hl
	ld	hl, 140
	push	hl
	ld	bc, -323
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_15pointEjjjj
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	jr	nz, .LBB0_24
; %bb.23:                               ;   in Loop: Header=BB0_20 Depth=2
	ld	hl, _.str.4
	ld	(__ZN12_GLOBAL__N_17failureE), hl
	.local	.LBB0_24
.LBB0_24:                               ;   in Loop: Header=BB0_20 Depth=2
	lea	hl, iy + 0
	ld	bc, 320
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_27
; %bb.25:                               ;   in Loop: Header=BB0_20 Depth=2
	ld	bc, -329
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 140
	push	hl
	push	iy
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_15pointEjjjj
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	jr	nz, .LBB0_27
; %bb.26:                               ;   in Loop: Header=BB0_20 Depth=2
	ld	hl, _.str.5
	ld	(__ZN12_GLOBAL__N_17failureE), hl
	.local	.LBB0_27
.LBB0_27:                               ;   in Loop: Header=BB0_20 Depth=2
	lea	de, iy + 0
	ld	bc, -326
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	bc, 2
	add	iy, bc
	ld	bc, 210
	ld	(ix - 3), de
	push	ix
	ld	de, -323
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	add	hl, bc
	push	ix
	ld	bc, -323
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	lea	hl, iy + 0
	ld	de, (ix - 3)
	push	de
	pop	iy
	ld	bc, 192
	add	iy, bc
	jp	.LBB0_20
	.local	.LBB0_28
.LBB0_28:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_17failureE)
	ld	de, _.str.1
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	ld	de, _.str.6
	jr	nz, .LBB0_33
; %bb.29:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_19completedE)
	inc	hl
	ld	(__ZN12_GLOBAL__N_19completedE), hl
	call	_getsysvar_time
	ld	bc, -314
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	ld	bc, -323
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	.local	.LBB0_30
.LBB0_30:                               ;   Parent Loop BB0_3 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	call	_getsysvar_time
	ld	(ix - 3), de
	ld	de, -314
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -323
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lsub
	ld	bc, 240
	xor	a, a
	call	__lcmpu
	jr	c, .LBB0_30
; %bb.31:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	inc	iy
	ld	de, _.str.6
	ld	bc, 6
	jp	.LBB0_3
	.local	.LBB0_32
.LBB0_32:
	ld	hl, _.str.2
	ld	(__ZN12_GLOBAL__N_17failureE), hl
	ld	de, _.str.6
	.local	.LBB0_33
.LBB0_33:
	ld	hl, 6
	push	hl
	push	de
	call	_mos_fopen
	ld	e, a
	pop	hl
	pop	hl
	or	a, a
	ld	hl, 2
	jp	z, .LBB0_57
; %bb.34:
	ld	hl, (__ZN12_GLOBAL__N_19completedE)
	ld	bc, -317
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	hl, (__ZN12_GLOBAL__N_15countE)
	push	ix
	ld	bc, -323
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	iy, (__ZN12_GLOBAL__N_111road_writesE)
	ld	bc, (__ZN12_GLOBAL__N_14wireE)
	ld	a, (__ZN12_GLOBAL__N_14wireE+3)
	ld	(ix - 3), bc
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ld	e, a
	ld	hl, (__ZN12_GLOBAL__N_17failureE)
	push	hl
	push	de
	ld	bc, (ix - 3)
	push	bc
	push	iy
	ld	bc, -323
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.7
	push	hl
	ld	hl, 256
	push	hl
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	ld	hl, 27
	add	hl, sp
	ld	sp, hl
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_15writeEhPKc
	pop	hl
	pop	hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_mos_fclose
	pop	hl
	ld	hl, 6
	push	hl
	ld	hl, _.str.8
	push	hl
	call	_mos_fopen
	ld	e, a
	pop	hl
	pop	hl
	or	a, a
	ld	hl, 3
	jp	z, .LBB0_57
; %bb.35:
	ld	hl, _.str.9
	push	hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	push	de
	call	__ZN12_GLOBAL__N_15writeEhPKc
	pop	hl
	pop	hl
	ld	bc, 0
	.local	.LBB0_36
.LBB0_36:                               ; =>This Inner Loop Header: Depth=1
	ld	de, (__ZN12_GLOBAL__N_15countE)
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jp	nc, .LBB0_38
; %bb.37:                               ;   in Loop: Header=BB0_36 Depth=1
	ld	de, -311
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	hl, (iy - 12)
	push	ix
	ld	de, -323
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (iy - 9)
	push	ix
	ld	de, -326
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (iy - 6)
	push	ix
	ld	de, -329
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (iy - 3)
	push	ix
	ld	de, -332
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (iy)
	push	ix
	ld	de, -335
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -317
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	ld	bc, (iy + 3)
	ld	de, (iy + 6)
	ld	hl, (iy + 9)
	push	hl
	push	de
	push	bc
	ld	bc, -335
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -332
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -329
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -326
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -323
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.10
	push	hl
	ld	hl, 256
	push	hl
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	ld	hl, 33
	add	hl, sp
	ld	sp, hl
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_15writeEhPKc
	ld	de, -317
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	pop	hl
	pop	hl
	inc	bc
	ld	de, -311
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	lea	iy, iy + 24
	push	ix
	add	ix, de
	ld	(ix + 0), iy
	pop	ix
	jp	.LBB0_36
	.local	.LBB0_38
.LBB0_38:
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_mos_fclose
	pop	hl
	ld	hl, 6
	push	hl
	ld	hl, _.str.11
	push	hl
	call	_mos_fopen
	ld	e, a
	pop	hl
	pop	hl
	or	a, a
	ld	hl, 5
	jp	z, .LBB0_57
; %bb.39:
	ld	hl, 737
	push	hl
	ld	hl, __ZL11RoadCommand
	push	hl
	push	de
	ld	bc, -311
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	call	_mos_fwrite
	ld	bc, -308
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -311
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_mos_fclose
	pop	hl
	ld	de, 737
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	jp	nz, .LBB0_55
; %bb.40:
	ld	hl, 6
	push	hl
	ld	hl, _.str.12
	push	hl
	call	_mos_fopen
	ld	e, a
	pop	hl
	pop	hl
	or	a, a
	ld	hl, 4
	jp	z, .LBB0_57
; %bb.41:
	ld	hl, _.str.13
	push	hl
	push	de
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	call	__ZN12_GLOBAL__N_15writeEhPKc
	pop	hl
	pop	hl
	ld	bc, -308
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_mos_fclose
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_17failureE)
	ld	de, _.str.1
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB0_56
; %bb.42:
	or	a, a
	sbc	hl, hl
	ex	de, hl
	push	de
	ld	hl, 160
	push	hl
	push	de
	call	__ZN12_GLOBAL__N_15labelEjij
	pop	hl
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 160
	push	hl
	call	__ZN12_GLOBAL__N_14drawEij
	pop	hl
	pop	hl
	ld	hl, _str
	push	hl
	call	_puts
	pop	hl
	or	a, a
	sbc	hl, hl
	ld	bc, -308
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	.local	.LBB0_43
.LBB0_43:                               ; =>This Inner Loop Header: Depth=1
	call	_getchar
	ld	a, l
	cp	a, 27
	jp	z, .LBB0_54
; %bb.44:                               ;   in Loop: Header=BB0_43 Depth=1
	ld	a, l
	cp	a, 32
	jp	nz, .LBB0_52
; %bb.45:                               ;   in Loop: Header=BB0_43 Depth=1
	ld	de, -308
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	inc	hl
	ld	bc, 6
	call	__iremu
	push	hl
	pop	iy
	ld	a, iyl
	ld	c, 3
	call	__bremu
	cp	a, 1
	ld	hl, 40
	jr	z, .LBB0_47
; %bb.46:                               ;   in Loop: Header=BB0_43 Depth=1
	ld	hl, 280
	.local	.LBB0_47
.LBB0_47:                               ;   in Loop: Header=BB0_43 Depth=1
	or	a, a
	ld	de, 160
	push	de
	pop	bc
	jr	z, .LBB0_49
; %bb.48:                               ;   in Loop: Header=BB0_43 Depth=1
	push	hl
	pop	bc
	.local	.LBB0_49
.LBB0_49:                               ;   in Loop: Header=BB0_43 Depth=1
	lea	hl, iy + 0
	ld	de, 3
	or	a, a
	sbc	hl, de
	ld	hl, 0
	jr	c, .LBB0_51
; %bb.50:                               ;   in Loop: Header=BB0_43 Depth=1
	ld	hl, 4000
	.local	.LBB0_51
.LBB0_51:                               ;   in Loop: Header=BB0_43 Depth=1
	push	ix
	ld	de, -314
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	push	hl
	push	bc
	ld	de, -308
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	push	iy
	ld	de, -311
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	call	__ZN12_GLOBAL__N_15labelEjij
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -314
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -311
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_14drawEij
	pop	hl
	pop	hl
	jp	.LBB0_43
	.local	.LBB0_52
.LBB0_52:                               ;   in Loop: Header=BB0_43 Depth=1
	ld	a, l
	cp	a, 81
	jr	z, .LBB0_54
; %bb.53:                               ;   in Loop: Header=BB0_43 Depth=1
	ld	a, l
	cp	a, 113
	jp	nz, .LBB0_43
	.local	.LBB0_54
.LBB0_54:
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	ld	hl, ___const.main.end
	ld	iy, 11
	lea	bc, iy + 0
	ldir
	push	iy
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	jr	.LBB0_57
	.local	.LBB0_55
.LBB0_55:
	ld	hl, 6
	jr	.LBB0_57
	.local	.LBB0_56
.LBB0_56:
	ld	hl, (__ZN12_GLOBAL__N_17failureE)
	push	hl
	ld	hl, _.str.14
	push	hl
	call	_printf
	pop	hl
	pop	hl
	ld	hl, 1
	.local	.LBB0_57
.LBB0_57:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end0
.Lfunc_end0:
	.size	_main, .Lfunc_end0-_main
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_14sendEPKhj,@function ; -- Begin function _ZN12_GLOBAL__N_14sendEPKhj
__ZN12_GLOBAL__N_14sendEPKhj:           ; @_ZN12_GLOBAL__N_14sendEPKhj
	.local	.Lfunc_begin1
.Lfunc_begin1:
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 6)
	ld	bc, (ix + 9)
	ld	de, 0
	push	de
	push	bc
	push	hl
	call	_mos_puts
	pop	hl
	pop	hl
	pop	hl
	xor	a, a
	ld	hl, (__ZN12_GLOBAL__N_14wireE)
	ld	iy, __ZN12_GLOBAL__N_14wireE
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix + 9)
	call	__ladd
	ld	a, e
	ld	(__ZN12_GLOBAL__N_14wireE), hl
	ld	(__ZN12_GLOBAL__N_14wireE+3), a
	pop	ix
	ret
	.local	.Lfunc_end1
.Lfunc_end1:
	.size	__ZN12_GLOBAL__N_14sendEPKhj, .Lfunc_end1-__ZN12_GLOBAL__N_14sendEPKhj
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_15fenceEv,@function ; -- Begin function _ZN12_GLOBAL__N_15fenceEv
__ZN12_GLOBAL__N_15fenceEv:             ; @_ZN12_GLOBAL__N_15fenceEv
	.local	.Lfunc_begin2
.Lfunc_begin2:
; %bb.0:
	ld	hl, -13
	call	__frameset
	ld	hl, __ZN12_GLOBAL__N_15tokenE
	ld	de, 7
	ld	(ix - 7), 23
	ld	(ix - 6), d
	ld	(ix - 5), -54
	ld	(ix - 4), 23
	ld	(ix - 3), d
	ld	(ix - 2), -128
	inc	(hl)
	ld	a, (hl)
	ld	(ix - 1), a
	push	de
	pea	ix - 7
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	call	_getsysvar_time
	ld	(ix - 10), hl
	ld	d, e
	.local	.LBB2_1
.LBB2_1:                                ; =>This Inner Loop Header: Depth=1
	ld	iy, (__ZN12_GLOBAL__N_13sysE)
	ld	l, (iy + 55)
	ld	a, (__ZN12_GLOBAL__N_15tokenE)
	ld	e, a
	ld	a, l
	cp	a, e
	jr	z, .LBB2_3
; %bb.2:                                ;   in Loop: Header=BB2_1 Depth=1
	ld	(ix - 11), d                    ; 1-byte Folded Spill
	ld	(ix - 12), l                    ; 1-byte Folded Spill
	ld	(ix - 13), e                    ; 1-byte Folded Spill
	call	_getsysvar_time
	ld	d, (ix - 11)                    ; 1-byte Folded Reload
	ld	bc, (ix - 10)
	ld	a, d
	call	__lsub
	push	hl
	pop	bc
	ld	a, e
	ld	hl, 600
	ld	e, 0
	call	__lcmpu
	ld	e, (ix - 13)                    ; 1-byte Folded Reload
	ld	l, (ix - 12)                    ; 1-byte Folded Reload
	jr	nc, .LBB2_1
	.local	.LBB2_3
.LBB2_3:
	ld	a, l
	cp	a, e
	jr	z, .LBB2_5
; %bb.4:
	ld	a, 0
	jr	.LBB2_6
	.local	.LBB2_5
.LBB2_5:
	ld	a, -1
	.local	.LBB2_6
.LBB2_6:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end2
.Lfunc_end2:
	.size	__ZN12_GLOBAL__N_15fenceEv, .Lfunc_end2-__ZN12_GLOBAL__N_15fenceEv
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_15labelEjij,@function ; -- Begin function _ZN12_GLOBAL__N_15labelEjij
__ZN12_GLOBAL__N_15labelEjij:           ; @_ZN12_GLOBAL__N_15labelEjij
	.local	.Lfunc_begin3
.Lfunc_begin3:
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	iy, ___const._ZN12_GLOBAL__N_15labelEjij.pos
	ld	de, 3
	lea	hl, ix - 3
	ld	a, (iy)
	ld	(hl), a
	ld	a, (___const._ZN12_GLOBAL__N_15labelEjij.pos+1)
	ld	(ix - 2), a
	ld	a, (___const._ZN12_GLOBAL__N_15labelEjij.pos+2)
	ld	(ix - 1), a
	push	de
	push	hl
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	ld	hl, (ix + 6)
	inc	hl
	ld	de, (ix + 12)
	push	de
	ld	de, (ix + 9)
	push	de
	push	hl
	ld	hl, _.str.16
	push	hl
	call	_printf
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end3
.Lfunc_end3:
	.size	__ZN12_GLOBAL__N_15labelEjij, .Lfunc_end3-__ZN12_GLOBAL__N_15labelEjij
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_14drawEij,@function ; -- Begin function _ZN12_GLOBAL__N_14drawEij
__ZN12_GLOBAL__N_14drawEij:             ; @_ZN12_GLOBAL__N_14drawEij
	.local	.Lfunc_begin4
.Lfunc_begin4:
; %bb.0:
	ld	hl, -23
	call	__frameset
	ld	hl, ___const._ZN12_GLOBAL__N_14drawEij.clear
	lea	iy, ix - 15
	lea	de, iy + 0
	ld	bc, 15
	ldir
	ld	hl, 15
	push	hl
	push	iy
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	ld	de, (ix + 6)
	ld	(ix - 19), e                    ; 1-byte Folded Spill
	ld	a, d
	ld	(ix - 20), a
	ld	de, 720
	push	hl
	pop	bc
	.local	.LBB4_1
.LBB4_1:                                ; =>This Inner Loop Header: Depth=1
	ld	(ix - 18), hl
	or	a, a
	sbc	hl, de
	jr	z, .LBB4_5
; %bb.2:                                ;   in Loop: Header=BB4_1 Depth=1
	ld	(ix - 23), bc
	push	bc
	pop	hl
	ld	de, 104
	add	hl, de
	ld	de, (ix + 9)
	push	de
	push	hl
	call	__ZN12_GLOBAL__N_17paintedEij
	pop	hl
	pop	hl
	bit	0, a
	ld	a, 61
	jr	nz, .LBB4_4
; %bb.3:                                ;   in Loop: Header=BB4_1 Depth=1
	ld	a, 60
	.local	.LBB4_4
.LBB4_4:                                ;   in Loop: Header=BB4_1 Depth=1
	ld	hl, (ix - 18)
	push	hl
	pop	de
	ld	iy, __ZL11RoadCommand
	add	iy, de
	ld	(iy + 11), a
	ld	(iy + 12), -41
	ld	a, (ix - 19)
	ld	(iy + 13), a
	ld	a, (ix - 20)
	ld	(iy + 14), a
	ld	bc, (ix - 23)
	inc	bc
	ld	de, 6
	add	hl, de
	ld	de, 720
	jr	.LBB4_1
	.local	.LBB4_5
.LBB4_5:
	ld	hl, (__ZN12_GLOBAL__N_111road_writesE)
	inc	hl
	ld	(__ZN12_GLOBAL__N_111road_writesE), hl
	ld	hl, 737
	push	hl
	ld	hl, __ZL11RoadCommand
	push	hl
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15fenceEv
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end4
.Lfunc_end4:
	.size	__ZN12_GLOBAL__N_14drawEij, .Lfunc_end4-__ZN12_GLOBAL__N_14drawEij
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_15pointEjjjj,@function ; -- Begin function _ZN12_GLOBAL__N_15pointEjjjj
__ZN12_GLOBAL__N_15pointEjjjj:          ; @_ZN12_GLOBAL__N_15pointEjjjj
	.local	.Lfunc_begin5
.Lfunc_begin5:
; %bb.0:
	ld	hl, -16
	call	__frameset
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	hl, 7
	ld	iy, (__ZN12_GLOBAL__N_13sysE)
	res	2, (iy + 4)
	ld	(ix - 7), 23
	ld	(ix - 6), h
	ld	(ix - 5), -124
	ld	(ix - 4), e
	ld	a, d
	ld	(ix - 3), a
	ld	(ix - 2), c
	ld	a, b
	ld	(ix - 1), a
	push	hl
	pea	ix - 7
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15fenceEv
	bit	0, a
	jp	z, .LBB5_4
; %bb.1:
	ld	iy, (__ZN12_GLOBAL__N_13sysE)
	ld	a, (iy + 4)
	bit	2, a
	ld	a, 0
	jp	z, .LBB5_6
; %bb.2:
	ld	(ix - 10), iy
	ld	iy, __ZN12_GLOBAL__N_16pixelsE
	ld	hl, (__ZN12_GLOBAL__N_15countE)
	push	hl
	pop	de
	inc	de
	ld	(__ZN12_GLOBAL__N_15countE), de
	ld	bc, 24
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	(ix - 13), iy
	ld	iy, (ix - 10)
	ld	a, (iy + 22)
	ld	bc, 0
	push	bc
	pop	hl
	ld	l, a
	ld	iy, (ix - 10)
	ld	a, (iy + 10)
	push	bc
	pop	de
	ld	e, a
	ld	(ix - 16), de
	ld	iy, (ix - 10)
	ld	c, (iy + 11)
	ld	iy, (ix - 10)
	ld	a, (iy + 12)
	ld	de, 0
	ld	e, a
	ld	(ix - 10), de
	ld	de, (ix + 6)
	ld	iy, (ix - 13)
	ld	(iy), de
	ld	de, (ix + 9)
	ld	(iy + 3), de
	ld	de, (ix + 12)
	ld	(iy + 6), de
	ld	de, (ix + 15)
	ld	(iy + 9), de
	ld	(iy + 12), hl
	ld	de, (ix - 16)
	ld	(iy + 15), de
	ld	(iy + 18), bc
	ld	de, (ix - 10)
	ld	(iy + 21), de
	ld	de, (ix + 15)
	or	a, a
	sbc	hl, de
	jr	z, .LBB5_5
; %bb.3:
	ld	a, 0
	jr	.LBB5_6
	.local	.LBB5_4
.LBB5_4:
	xor	a, a
	jr	.LBB5_6
	.local	.LBB5_5
.LBB5_5:
	ld	a, -1
	.local	.LBB5_6
.LBB5_6:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end5
.Lfunc_end5:
	.size	__ZN12_GLOBAL__N_15pointEjjjj, .Lfunc_end5-__ZN12_GLOBAL__N_15pointEjjjj
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_17paintedEij,@function ; -- Begin function _ZN12_GLOBAL__N_17paintedEij
__ZN12_GLOBAL__N_17paintedEij:          ; @_ZN12_GLOBAL__N_17paintedEij
	.local	.Lfunc_begin6
.Lfunc_begin6:
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	d, 0
	ld	bc, 116
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	m, .LBB6_2
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
	.local	.LBB6_2
.LBB6_2:
	ld	a, d
	pop	ix
	ret
	.local	.Lfunc_end6
.Lfunc_end6:
	.size	__ZN12_GLOBAL__N_17paintedEij, .Lfunc_end6-__ZN12_GLOBAL__N_17paintedEij
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_15writeEhPKc,@function ; -- Begin function _ZN12_GLOBAL__N_15writeEhPKc
__ZN12_GLOBAL__N_15writeEhPKc:          ; @_ZN12_GLOBAL__N_15writeEhPKc
	.local	.Lfunc_begin7
.Lfunc_begin7:
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 9)
	push	hl
	call	_strlen
	pop	de
	push	hl
	ld	hl, (ix + 9)
	push	hl
	ld	l, (ix + 6)
	push	hl
	call	_mos_fwrite
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end7
.Lfunc_end7:
	.size	__ZN12_GLOBAL__N_15writeEhPKc, .Lfunc_end7-__ZN12_GLOBAL__N_15writeEhPKc
                                        ; -- End function
	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_13sysE
__ZN12_GLOBAL__N_13sysE:
	.skip	3

	.section	.rodata,"a",@progbits
	.local	___const.main.init
___const.main.init:
	db	22, 8, 23, 0, 192, 0, 23, 1, 0, 23, 0, 248, 1, 0, 1, 0, 12, 18, 0, 4, 25, 4, 0, 0, "P", 0, 25, "e?", 1, "g", 0

	.local	__ZL5Setup
__ZL5Setup:
	db	23, 0, 160, "<", 215, 2, 23, 0, 160, "<", 215, 0, "#", 0, 255, 255, 255, 213, 255, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 255, 213, 255, 255, 255, 23, 27, " <", 215, 23, 27, "!#", 0, 1, 0, 1, 23, 0, 160, "=", 215, 2, 23, 0, 160, "=", 215, 0, "#", 0, 195, 195, 195, 213, 207, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 207, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 207, 213, 195, 195, 195, 23, 27, " =", 215, 23, 27, "!#", 0, 1, 0, 1, 23, 0, 160, 216, 214, 2, 23, 0, 160, 216, 214, 0, 208, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 160, 160, 215, " ", 0, 23, 0, 160, 160, 215, " ", 11, 198, "@", 0, 0, 0, 160, 251, 0, 0, "@", 0, 0, 0, 23, 0, 160, 161, 215, " ", 0, 23, 0, 160, 161, 215, " ", 11, 198, "L", 0, 0, 0, 206, 250, 0, 0, "@", 0, 0, 0, 23, 0, 160, 162, 215, " ", 0, 23, 0, 160, 162, 215, " ", 11, 198, "T", 0, 0, 0, "B", 250, 0, 0, "@", 0, 0, 0, 23, 0, 160, 163, 215, " ", 0, 23, 0, 160, 163, 215, " ", 11, 198, 92, 0, 0, 0, 182, 249, 0, 0, "@", 0, 0, 0, 23, 0, 160, 164, 215, " ", 0, 23, 0, 160, 164, 215, " ", 11, 198, "d", 0, 0, 0, "*", 249, 0, 0, "@", 0, 0, 0, 23, 0, 160, 165, 215, " ", 0, 23, 0, 160, 165, 215, " ", 11, 198, "l", 0, 0, 0, 158, 248, 0, 0, "@", 0, 0, 0, 23, 0, 160, 166, 215, " ", 0, 23, 0, 160, 166, 215, " ", 11, 198, "t", 0, 0, 0, 18, 248, 0, 0, "@", 0, 0, 0, 23, 0, 160, 167, 215, " ", 0, 23, 0, 160, 167, 215, " ", 11, 198, "|", 0, 0, 0, 134, 247, 0, 0, "@", 0, 0, 0, 23, 0, 160, 168, 215, " ", 0, 23, 0, 160, 168, 215, " ", 11, 198, 132, 0, 0, 0, 250, 246, 0, 0, "@", 0, 0, 0, 23, 0, 160, 169, 215, " ", 0, 23, 0, 160, 169, 215, " ", 11, 198, 144, 0, 0, 0, "(", 246, 0, 0, "@", 0, 0, 0, 23, 0, 160, 170, 215, " ", 0, 23, 0, 160, 170, 215, " ", 11, 198, 152, 0, 0, 0, 156, 245, 0, 0, "@", 0, 0, 0, 23, 0, 160, 171, 215, " ", 0, 23, 0, 160, 171, 215, " ", 11, 198, 160, 0, 0, 0, 16, 245, 0, 0, "@", 0, 0, 0, 23, 0, 160, 172, 215, " ", 0, 23, 0, 160, 172, 215, " ", 11, 198, 168, 0, 0, 0, 132, 244, 0, 0, "@", 0, 0, 0, 23, 0, 160, 173, 215, " ", 0, 23, 0, 160, 173, 215, " ", 11, 198, 176, 0, 0, 0, 248, 243, 0, 0, "@", 0, 0, 0, 23, 0, 160, 174, 215, " ", 0, 23, 0, 160, 174, 215, " ", 11, 198, 184, 0, 0, 0, "l", 243, 0, 0, "@", 0, 0, 0, 23, 0, 160, 175, 215, " ", 0, 23, 0, 160, 175, 215, " ", 11, 198, 192, 0, 0, 0, 224, 242, 0, 0, "@", 0, 0, 0, 23, 0, 160, 176, 215, " ", 0, 23, 0, 160, 176, 215, " ", 11, 198, 200, 0, 0, 0, "T", 242, 0, 0, "@", 0, 0, 0, 23, 0, 160, 177, 215, " ", 0, 23, 0, 160, 177, 215, " ", 11, 198, 212, 0, 0, 0, 130, 241, 0, 0, "@", 0, 0, 0, 23, 0, 160, 178, 215, " ", 0, 23, 0, 160, 178, 215, " ", 11, 198, 220, 0, 0, 0, 246, 240, 0, 0, "@", 0, 0, 0, 23, 0, 160, 179, 215, " ", 0, 23, 0, 160, 179, 215, " ", 11, 198, 228, 0, 0, 0, "j", 240, 0, 0, "@", 0, 0, 0, 23, 0, 160, 180, 215, " ", 0, 23, 0, 160, 180, 215, " ", 11, 198, 236, 0, 0, 0, 222, 239, 0, 0, "@", 0, 0, 0, 23, 0, 160, 181, 215, " ", 0, 23, 0, 160, 181, 215, " ", 11, 198, 244, 0, 0, 0, "R", 239, 0, 0, "@", 0, 0, 0, 23, 0, 160, 182, 215, " ", 0, 23, 0, 160, 182, 215, " ", 11, 198, 252, 0, 0, 0, 198, 238, 0, 0, "@", 0, 0, 0, 23, 0, 160, 183, 215, " ", 0, 23, 0, 160, 183, 215, " ", 11, 198, 4, 1, 0, 0, ":", 238, 0, 0, "@", 0, 0, 0, 23, 0, 160, 184, 215, " ", 0, 23, 0, 160, 184, 215, " ", 11, 198, 12, 1, 0, 0, 174, 237, 0, 0, "@", 0, 0, 0, 23, 0, 160, 185, 215, " ", 0, 23, 0, 160, 185, 215, " ", 11, 198, 20, 1, 0, 0, 34, 237, 0, 0, "@", 0, 0, 0, 23, 0, 160, 186, 215, " ", 0, 23, 0, 160, 186, 215, " ", 11, 198, " ", 1, 0, 0, "P", 236, 0, 0, "@", 0, 0, 0, 23, 0, 160, 187, 215, " ", 0, 23, 0, 160, 187, 215, " ", 11, 198, "(", 1, 0, 0, 196, 235, 0, 0, "@", 0, 0, 0, 23, 0, 160, 188, 215, " ", 0, 23, 0, 160, 188, 215, " ", 11, 198, "0", 1, 0, 0, "8", 235, 0, 0, "@", 0, 0, 0, 23, 0, 160, 189, 215, " ", 0, 23, 0, 160, 189, 215, " ", 11, 198, "8", 1, 0, 0, 172, 234, 0, 0, "@", 0, 0, 0, 23, 0, 160, 190, 215, " ", 0, 23, 0, 160, 190, 215, " ", 11, 198, "@", 1, 0, 0, " ", 234, 0, 0, "@", 0, 0, 0, 23, 0, 160, 191, 215, " ", 0, 23, 0, 160, 191, 215, " ", 11, 198, "H", 1, 0, 0, 148, 233, 0, 0, "@", 0, 0, 0, 23, 0, 160, 192, 215, " ", 0, 23, 0, 160, 192, 215, " ", 11, 198, "P", 1, 0, 0, 8, 233, 0, 0, "@", 0, 0, 0, 23, 0, 160, 193, 215, " ", 0, 23, 0, 160, 193, 215, " ", 11, 198, "X", 1, 0, 0, "|", 232, 0, 0, "@", 0, 0, 0, 23, 0, 160, 194, 215, " ", 0, 23, 0, 160, 194, 215, " ", 11, 198, "d", 1, 0, 0, 170, 231, 0, 0, "@", 0, 0, 0, 23, 0, 160, 195, 215, " ", 0, 23, 0, 160, 195, 215, " ", 11, 198, "l", 1, 0, 0, 30, 231, 0, 0, "@", 0, 0, 0, 23, 0, 160, 196, 215, " ", 0, 23, 0, 160, 196, 215, " ", 11, 198, "t", 1, 0, 0, 146, 230, 0, 0, "@", 0, 0, 0, 23, 0, 160, 197, 215, " ", 0, 23, 0, 160, 197, 215, " ", 11, 198, "|", 1, 0, 0, 6, 230, 0, 0, "@", 0, 0, 0, 23, 0, 160, 198, 215, " ", 0, 23, 0, 160, 198, 215, " ", 11, 198, 132, 1, 0, 0, "z", 229, 0, 0, "@", 0, 0, 0, 23, 0, 160, 199, 215, " ", 0, 23, 0, 160, 199, 215, " ", 11, 198, 140, 1, 0, 0, 238, 228, 0, 0, "@", 0, 0, 0, 23, 0, 160, 200, 215, " ", 0, 23, 0, 160, 200, 215, " ", 11, 198, 148, 1, 0, 0, "b", 228, 0, 0, "@", 0, 0, 0, 23, 0, 160, 201, 215, " ", 0, 23, 0, 160, 201, 215, " ", 11, 198, 156, 1, 0, 0, 214, 227, 0, 0, "@", 0, 0, 0, 23, 0, 160, 202, 215, " ", 0, 23, 0, 160, 202, 215, " ", 11, 198, 168, 1, 0, 0, 4, 227, 0, 0, "@", 0, 0, 0, 23, 0, 160, 203, 215, " ", 0, 23, 0, 160, 203, 215, " ", 11, 198, 176, 1, 0, 0, "x", 226, 0, 0, "@", 0, 0, 0, 23, 0, 160, 204, 215, " ", 0, 23, 0, 160, 204, 215, " ", 11, 198, 184, 1, 0, 0, 236, 225, 0, 0, "@", 0, 0, 0, 23, 0, 160, 205, 215, " ", 0, 23, 0, 160, 205, 215, " ", 11, 198, 192, 1, 0, 0, "`", 225, 0, 0, "@", 0, 0, 0, 23, 0, 160, 206, 215, " ", 0, 23, 0, 160, 206, 215, " ", 11, 198, 200, 1, 0, 0, 212, 224, 0, 0, "@", 0, 0, 0, 23, 0, 160, 207, 215, " ", 0, 23, 0, 160, 207, 215, " ", 11, 198, 208, 1, 0, 0, "H", 224, 0, 0, "@", 0, 0, 0, 23, 0, 160, 208, 215, " ", 0, 23, 0, 160, 208, 215, " ", 11, 198, 216, 1, 0, 0, 188, 223, 0, 0, "@", 0, 0, 0, 23, 0, 160, 209, 215, " ", 0, 23, 0, 160, 209, 215, " ", 11, 198, 224, 1, 0, 0, "0", 223, 0, 0, "@", 0, 0, 0, 23, 0, 160, 210, 215, " ", 0, 23, 0, 160, 210, 215, " ", 11, 198, 232, 1, 0, 0, 164, 222, 0, 0, "@", 0, 0, 0, 23, 0, 160, 211, 215, " ", 0, 23, 0, 160, 211, 215, " ", 11, 198, 244, 1, 0, 0, 210, 221, 0, 0, "@", 0, 0, 0, 23, 0, 160, 212, 215, " ", 0, 23, 0, 160, 212, 215, " ", 11, 198, 252, 1, 0, 0, "F", 221, 0, 0, "@", 0, 0, 0, 23, 0, 160, 213, 215, " ", 0, 23, 0, 160, 213, 215, " ", 11, 198, 4, 2, 0, 0, 186, 220, 0, 0, "@", 0, 0, 0, 23, 0, 160, 214, 215, " ", 0, 23, 0, 160, 214, 215, " ", 11, 198, 12, 2, 0, 0, ".", 220, 0, 0, "@", 0, 0, 0, 23, 0, 160, 215, 215, " ", 0, 23, 0, 160, 215, 215, " ", 11, 198, 20, 2, 0, 0, 162, 219, 0, 0, "@", 0, 0, 0, 23, 0, 160, 216, 215, " ", 0, 23, 0, 160, 216, 215, " ", 11, 198, 28, 2, 0, 0, 22, 219, 0, 0, "@", 0, 0, 0, 23, 0, 160, 217, 215, " ", 0, 23, 0, 160, 217, 215, " ", 11, 198, "$", 2, 0, 0, 138, 218, 0, 0, "@", 0, 0, 0, 23, 0, 160, 218, 215, " ", 0, 23, 0, 160, 218, 215, " ", 11, 198, ",", 2, 0, 0, 254, 217, 0, 0, "@", 0, 0, 0, 23, 0, 160, 219, 215, " ", 0, 23, 0, 160, 219, 215, " ", 11, 198, "8", 2, 0, 0, ",", 217, 0, 0, "@", 0, 0, 0, 23, 0, 160, 220, 215, " ", 0, 23, 0, 160, 220, 215, " ", 11, 198, "@", 2, 0, 0, 160, 216, 0, 0, "@", 0, 0, 0, 23, 0, 160, 221, 215, " ", 0, 23, 0, 160, 221, 215, " ", 11, 198, "H", 2, 0, 0, 20, 216, 0, 0, "@", 0, 0, 0, 23, 0, 160, 222, 215, " ", 0, 23, 0, 160, 222, 215, " ", 11, 198, "P", 2, 0, 0, 136, 215, 0, 0, "@", 0, 0, 0, 23, 0, 160, 223, 215, " ", 0, 23, 0, 160, 223, 215, " ", 11, 198, "X", 2, 0, 0, 252, 214, 0, 0, "@", 0, 0, 0, 23, 0, 160, 224, 215, " ", 0, 23, 0, 160, 224, 215, " ", 11, 198, "`", 2, 0, 0, "p", 214, 0, 0, "@", 0, 0, 0, 23, 0, 160, 225, 215, " ", 0, 23, 0, 160, 225, 215, " ", 11, 198, "h", 2, 0, 0, 228, 213, 0, 0, "@", 0, 0, 0, 23, 0, 160, 226, 215, " ", 0, 23, 0, 160, 226, 215, " ", 11, 198, "p", 2, 0, 0, "X", 213, 0, 0, "@", 0, 0, 0, 23, 0, 160, 227, 215, " ", 0, 23, 0, 160, 227, 215, " ", 11, 198, "|", 2, 0, 0, 134, 212, 0, 0, "@", 0, 0, 0, 23, 0, 160, 228, 215, " ", 0, 23, 0, 160, 228, 215, " ", 11, 198, 132, 2, 0, 0, 250, 211, 0, 0, "@", 0, 0, 0, 23, 0, 160, 229, 215, " ", 0, 23, 0, 160, 229, 215, " ", 11, 198, 140, 2, 0, 0, "n", 211, 0, 0, "@", 0, 0, 0, 23, 0, 160, 230, 215, " ", 0, 23, 0, 160, 230, 215, " ", 11, 198, 148, 2, 0, 0, 226, 210, 0, 0, "@", 0, 0, 0, 23, 0, 160, 231, 215, " ", 0, 23, 0, 160, 231, 215, " ", 11, 198, 156, 2, 0, 0, "V", 210, 0, 0, "@", 0, 0, 0, 23, 0, 160, 232, 215, " ", 0, 23, 0, 160, 232, 215, " ", 11, 198, 164, 2, 0, 0, 202, 209, 0, 0, "@", 0, 0, 0, 23, 0, 160, 233, 215, " ", 0, 23, 0, 160, 233, 215, " ", 11, 198, 172, 2, 0, 0, ">", 209, 0, 0, "@", 0, 0, 0, 23, 0, 160, 234, 215, " ", 0, 23, 0, 160, 234, 215, " ", 11, 198, 180, 2, 0, 0, 178, 208, 0, 0, "@", 0, 0, 0, 23, 0, 160, 235, 215, " ", 0, 23, 0, 160, 235, 215, " ", 11, 198, 188, 2, 0, 0, "&", 208, 0, 0, "@", 0, 0, 0, 23, 0, 160, 236, 215, " ", 0, 23, 0, 160, 236, 215, " ", 11, 198, 200, 2, 0, 0, "T", 207, 0, 0, "@", 0, 0, 0, 23, 0, 160, 237, 215, " ", 0, 23, 0, 160, 237, 215, " ", 11, 198, 208, 2, 0, 0, 200, 206, 0, 0, "@", 0, 0, 0, 23, 0, 160, 238, 215, " ", 0, 23, 0, 160, 238, 215, " ", 11, 198, 216, 2, 0, 0, "<", 206, 0, 0, "@", 0, 0, 0, 23, 0, 160, 239, 215, " ", 0, 23, 0, 160, 239, 215, " ", 11, 198, 224, 2, 0, 0, 176, 205, 0, 0, "@", 0, 0, 0, 23, 0, 160, 240, 215, " ", 0, 23, 0, 160, 240, 215, " ", 11, 198, 232, 2, 0, 0, "$", 205, 0, 0, "@", 0, 0, 0, 23, 0, 160, 241, 215, " ", 0, 23, 0, 160, 241, 215, " ", 11, 198, 240, 2, 0, 0, 152, 204, 0, 0, "@", 0, 0, 0, 23, 0, 160, 242, 215, " ", 0, 23, 0, 160, 242, 215, " ", 11, 198, 248, 2, 0, 0, 12, 204, 0, 0, "@", 0, 0, 0, 23, 0, 160, 243, 215, " ", 0, 23, 0, 160, 243, 215, " ", 11, 198, 0, 3, 0, 0, 128, 203, 0, 0, "@", 0, 0, 0, 23, 0, 160, 244, 215, " ", 0, 23, 0, 160, 244, 215, " ", 11, 198, 12, 3, 0, 0, 174, 202, 0, 0, "@", 0, 0, 0, 23, 0, 160, 245, 215, " ", 0, 23, 0, 160, 245, 215, " ", 11, 198, 20, 3, 0, 0, 34, 202, 0, 0, "@", 0, 0, 0, 23, 0, 160, 246, 215, " ", 0, 23, 0, 160, 246, 215, " ", 11, 198, 28, 3, 0, 0, 150, 201, 0, 0, "@", 0, 0, 0, 23, 0, 160, 247, 215, " ", 0, 23, 0, 160, 247, 215, " ", 11, 198, "$", 3, 0, 0, 10, 201, 0, 0, "@", 0, 0, 0, 23, 0, 160, 248, 215, " ", 0, 23, 0, 160, 248, 215, " ", 11, 198, ",", 3, 0, 0, "~", 200, 0, 0, "@", 0, 0, 0, 23, 0, 160, 249, 215, " ", 0, 23, 0, 160, 249, 215, " ", 11, 198, "4", 3, 0, 0, 242, 199, 0, 0, "@", 0, 0, 0, 23, 0, 160, 250, 215, " ", 0, 23, 0, 160, 250, 215, " ", 11, 198, "<", 3, 0, 0, "f", 199, 0, 0, "@", 0, 0, 0, 23, 0, 160, 251, 215, " ", 0, 23, 0, 160, 251, 215, " ", 11, 198, "D", 3, 0, 0, 218, 198, 0, 0, "@", 0, 0, 0, 23, 0, 160, 252, 215, " ", 0, 23, 0, 160, 252, 215, " ", 11, 198, "P", 3, 0, 0, 8, 198, 0, 0, "@", 0, 0, 0, 23, 0, 160, 253, 215, " ", 0, 23, 0, 160, 253, 215, " ", 11, 198, "X", 3, 0, 0, "|", 197, 0, 0, "@", 0, 0, 0, 23, 0, 160, 254, 215, " ", 0, 23, 0, 160, 254, 215, " ", 11, 198, "`", 3, 0, 0, 240, 196, 0, 0, "@", 0, 0, 0, 23, 0, 160, 255, 215, " ", 0, 23, 0, 160, 255, 215, " ", 11, 198, "h", 3, 0, 0, "d", 196, 0, 0, "@", 0, 0, 0, 23, 0, 160, 0, 216, " ", 0, 23, 0, 160, 0, 216, " ", 11, 198, "p", 3, 0, 0, 216, 195, 0, 0, "@", 0, 0, 0, 23, 0, 160, 1, 216, " ", 0, 23, 0, 160, 1, 216, " ", 11, 198, "x", 3, 0, 0, "L", 195, 0, 0, "@", 0, 0, 0, 23, 0, 160, 2, 216, " ", 0, 23, 0, 160, 2, 216, " ", 11, 198, 128, 3, 0, 0, 192, 194, 0, 0, "@", 0, 0, 0, 23, 0, 160, 3, 216, " ", 0, 23, 0, 160, 3, 216, " ", 11, 198, 136, 3, 0, 0, "4", 194, 0, 0, "@", 0, 0, 0, 23, 0, 160, 4, 216, " ", 0, 23, 0, 160, 4, 216, " ", 11, 198, 144, 3, 0, 0, 168, 193, 0, 0, "@", 0, 0, 0, 23, 0, 160, 5, 216, " ", 0, 23, 0, 160, 5, 216, " ", 11, 198, 156, 3, 0, 0, 214, 192, 0, 0, "@", 0, 0, 0, 23, 0, 160, 6, 216, " ", 0, 23, 0, 160, 6, 216, " ", 11, 198, 164, 3, 0, 0, "J", 192, 0, 0, "@", 0, 0, 0, 23, 0, 160, 7, 216, " ", 0, 23, 0, 160, 7, 216, " ", 11, 198, 172, 3, 0, 0, 190, 191, 0, 0, "@", 0, 0, 0, 23, 0, 160, 8, 216, " ", 0, 23, 0, 160, 8, 216, " ", 11, 198, 180, 3, 0, 0, "2", 191, 0, 0, "@", 0, 0, 0, 23, 0, 160, 9, 216, " ", 0, 23, 0, 160, 9, 216, " ", 11, 198, 188, 3, 0, 0, 166, 190, 0, 0, "@", 0, 0, 0, 23, 0, 160, 10, 216, " ", 0, 23, 0, 160, 10, 216, " ", 11, 198, 196, 3, 0, 0, 26, 190, 0, 0, "@", 0, 0, 0, 23, 0, 160, 11, 216, " ", 0, 23, 0, 160, 11, 216, " ", 11, 198, 204, 3, 0, 0, 142, 189, 0, 0, "@", 0, 0, 0, 23, 0, 160, 12, 216, " ", 0, 23, 0, 160, 12, 216, " ", 11, 198, 212, 3, 0, 0, 2, 189, 0, 0, "@", 0, 0, 0, 23, 0, 160, 13, 216, " ", 0, 23, 0, 160, 13, 216, " ", 11, 198, 224, 3, 0, 0, "0", 188, 0, 0, "@", 0, 0, 0, 23, 0, 160, 14, 216, " ", 0, 23, 0, 160, 14, 216, " ", 11, 198, 232, 3, 0, 0, 164, 187, 0, 0, "@", 0, 0, 0, 23, 0, 160, 15, 216, " ", 0, 23, 0, 160, 15, 216, " ", 11, 198, 240, 3, 0, 0, 24, 187, 0, 0, "@", 0, 0, 0, 23, 0, 160, 16, 216, " ", 0, 23, 0, 160, 16, 216, " ", 11, 198, 248, 3, 0, 0, 140, 186, 0, 0, "@", 0, 0, 0, 23, 0, 160, 17, 216, " ", 0, 23, 0, 160, 17, 216, " ", 11, 198, 0, 4, 0, 0, 0, 186, 0, 0, "@", 0, 0, 0, 23, 0, 160, 18, 216, " ", 0, 23, 0, 160, 18, 216, " ", 11, 198, 8, 4, 0, 0, "t", 185, 0, 0, "@", 0, 0, 0, 23, 0, 160, 19, 216, " ", 0, 23, 0, 160, 19, 216, " ", 11, 198, 16, 4, 0, 0, 232, 184, 0, 0, "@", 0, 0, 0, 23, 0, 160, 20, 216, " ", 0, 23, 0, 160, 20, 216, " ", 11, 198, 24, 4, 0, 0, 92, 184, 0, 0, "@", 0, 0, 0, 23, 0, 160, 21, 216, " ", 0, 23, 0, 160, 21, 216, " ", 11, 198, "$", 4, 0, 0, 138, 183, 0, 0, "@", 0, 0, 0, 23, 0, 160, 22, 216, " ", 0, 23, 0, 160, 22, 216, " ", 11, 198, ",", 4, 0, 0, 254, 182, 0, 0, "@", 0, 0, 0, 23, 0, 160, 23, 216, " ", 0, 23, 0, 160, 23, 216, " ", 11, 198, "4", 4, 0, 0, "r", 182, 0, 0, "@", 0, 0, 0, 23, 0, 160, 217, 214, 2, 23, 0, 160, 217, 214, 0, 248, 7, 23, 27, " <", 215, 23, 0, 150, 1, 160, 215, 25, 237, 160, 0, "h", 0, 23, 27, " <", 215, 23, 0, 150, 1, 161, 215, 25, 237, 160, 0, "i", 0, 23, 27, " <", 215, 23, 0, 150, 1, 162, 215, 25, 237, 160, 0, "j", 0, 23, 27, " <", 215, 23, 0, 150, 1, 163, 215, 25, 237, 160, 0, "k", 0, 23, 27, " <", 215, 23, 0, 150, 1, 164, 215, 25, 237, 160, 0, "l", 0, 23, 27, " <", 215, 23, 0, 150, 1, 165, 215, 25, 237, 160, 0, "m", 0, 23, 27, " <", 215, 23, 0, 150, 1, 166, 215, 25, 237, 160, 0, "n", 0, 23, 27, " <", 215, 23, 0, 150, 1, 167, 215, 25, 237, 160, 0, "o", 0, 23, 27, " <", 215, 23, 0, 150, 1, 168, 215, 25, 237, 160, 0, "p", 0, 23, 27, " <", 215, 23, 0, 150, 1, 169, 215, 25, 237, 160, 0, "q", 0, 23, 27, " <", 215, 23, 0, 150, 1, 170, 215, 25, 237, 160, 0, "r", 0, 23, 27, " <", 215, 23, 0, 150, 1, 171, 215, 25, 237, 160, 0, "s", 0, 23, 27, " <", 215, 23, 0, 150, 1, 172, 215, 25, 237, 160, 0, "t", 0, 23, 27, " <", 215, 23, 0, 150, 1, 173, 215, 25, 237, 160, 0, "u", 0, 23, 27, " <", 215, 23, 0, 150, 1, 174, 215, 25, 237, 160, 0, "v", 0, 23, 27, " <", 215, 23, 0, 150, 1, 175, 215, 25, 237, 160, 0, "w", 0, 23, 27, " <", 215, 23, 0, 150, 1, 176, 215, 25, 237, 160, 0, "x", 0, 23, 27, " <", 215, 23, 0, 150, 1, 177, 215, 25, 237, 160, 0, "y", 0, 23, 27, " <", 215, 23, 0, 150, 1, 178, 215, 25, 237, 160, 0, "z", 0, 23, 27, " <", 215, 23, 0, 150, 1, 179, 215, 25, 237, 160, 0, "{", 0, 23, 27, " <", 215, 23, 0, 150, 1, 180, 215, 25, 237, 160, 0, "|", 0, 23, 27, " <", 215, 23, 0, 150, 1, 181, 215, 25, 237, 160, 0, "}", 0, 23, 27, " <", 215, 23, 0, 150, 1, 182, 215, 25, 237, 160, 0, "~", 0, 23, 27, " <", 215, 23, 0, 150, 1, 183, 215, 25, 237, 160, 0, 127, 0, 23, 27, " <", 215, 23, 0, 150, 1, 184, 215, 25, 237, 160, 0, 128, 0, 23, 27, " <", 215, 23, 0, 150, 1, 185, 215, 25, 237, 160, 0, 129, 0, 23, 27, " <", 215, 23, 0, 150, 1, 186, 215, 25, 237, 160, 0, 130, 0, 23, 27, " <", 215, 23, 0, 150, 1, 187, 215, 25, 237, 160, 0, 131, 0, 23, 27, " <", 215, 23, 0, 150, 1, 188, 215, 25, 237, 160, 0, 132, 0, 23, 27, " <", 215, 23, 0, 150, 1, 189, 215, 25, 237, 160, 0, 133, 0, 23, 27, " <", 215, 23, 0, 150, 1, 190, 215, 25, 237, 160, 0, 134, 0, 23, 27, " <", 215, 23, 0, 150, 1, 191, 215, 25, 237, 160, 0, 135, 0, 23, 27, " <", 215, 23, 0, 150, 1, 192, 215, 25, 237, 160, 0, 136, 0, 23, 27, " <", 215, 23, 0, 150, 1, 193, 215, 25, 237, 160, 0, 137, 0, 23, 27, " <", 215, 23, 0, 150, 1, 194, 215, 25, 237, 160, 0, 138, 0, 23, 27, " <", 215, 23, 0, 150, 1, 195, 215, 25, 237, 160, 0, 139, 0, 23, 27, " <", 215, 23, 0, 150, 1, 196, 215, 25, 237, 160, 0, 140, 0, 23, 27, " <", 215, 23, 0, 150, 1, 197, 215, 25, 237, 160, 0, 141, 0, 23, 27, " <", 215, 23, 0, 150, 1, 198, 215, 25, 237, 160, 0, 142, 0, 23, 27, " <", 215, 23, 0, 150, 1, 199, 215, 25, 237, 160, 0, 143, 0, 23, 27, " <", 215, 23, 0, 150, 1, 200, 215, 25, 237, 160, 0, 144, 0, 23, 27, " <", 215, 23, 0, 150, 1, 201, 215, 25, 237, 160, 0, 145, 0, 23, 27, " <", 215, 23, 0, 150, 1, 202, 215, 25, 237, 160, 0, 146, 0, 23, 27, " <", 215, 23, 0, 150, 1, 203, 215, 25, 237, 160, 0, 147, 0, 23, 27, " <", 215, 23, 0, 150, 1, 204, 215, 25, 237, 160, 0, 148, 0, 23, 27, " <", 215, 23, 0, 150, 1, 205, 215, 25, 237, 160, 0, 149, 0, 23, 27, " <", 215, 23, 0, 150, 1, 206, 215, 25, 237, 160, 0, 150, 0, 23, 27, " <", 215, 23, 0, 150, 1, 207, 215, 25, 237, 160, 0, 151, 0, 23, 27, " <", 215, 23, 0, 150, 1, 208, 215, 25, 237, 160, 0, 152, 0, 23, 27, " <", 215, 23, 0, 150, 1, 209, 215, 25, 237, 160, 0, 153, 0, 23, 27, " <", 215, 23, 0, 150, 1, 210, 215, 25, 237, 160, 0, 154, 0, 23, 27, " <", 215, 23, 0, 150, 1, 211, 215, 25, 237, 160, 0, 155, 0, 23, 27, " <", 215, 23, 0, 150, 1, 212, 215, 25, 237, 160, 0, 156, 0, 23, 27, " <", 215, 23, 0, 150, 1, 213, 215, 25, 237, 160, 0, 157, 0, 23, 27, " <", 215, 23, 0, 150, 1, 214, 215, 25, 237, 160, 0, 158, 0, 23, 27, " <", 215, 23, 0, 150, 1, 215, 215, 25, 237, 160, 0, 159, 0, 23, 27, " <", 215, 23, 0, 150, 1, 216, 215, 25, 237, 160, 0, 160, 0, 23, 27, " <", 215, 23, 0, 150, 1, 217, 215, 25, 237, 160, 0, 161, 0, 23, 27, " <", 215, 23, 0, 150, 1, 218, 215, 25, 237, 160, 0, 162, 0, 23, 27, " <", 215, 23, 0, 150, 1, 219, 215, 25, 237, 160, 0, 163, 0, 23, 27, " <", 215, 23, 0, 150, 1, 220, 215, 25, 237, 160, 0, 164, 0, 23, 27, " <", 215, 23, 0, 150, 1, 221, 215, 25, 237, 160, 0, 165, 0, 23, 27, " <", 215, 23, 0, 150, 1, 222, 215, 25, 237, 160, 0, 166, 0, 23, 27, " <", 215, 23, 0, 150, 1, 223, 215, 25, 237, 160, 0, 167, 0, 23, 27, " <", 215, 23, 0, 150, 1, 224, 215, 25, 237, 160, 0, 168, 0, 23, 27, " <", 215, 23, 0, 150, 1, 225, 215, 25, 237, 160, 0, 169, 0, 23, 27, " <", 215, 23, 0, 150, 1, 226, 215, 25, 237, 160, 0, 170, 0, 23, 27, " <", 215, 23, 0, 150, 1, 227, 215, 25, 237, 160, 0, 171, 0, 23, 27, " <", 215, 23, 0, 150, 1, 228, 215, 25, 237, 160, 0, 172, 0, 23, 27, " <", 215, 23, 0, 150, 1, 229, 215, 25, 237, 160, 0, 173, 0, 23, 27, " <", 215, 23, 0, 150, 1, 230, 215, 25, 237, 160, 0, 174, 0, 23, 27, " <", 215, 23, 0, 150, 1, 231, 215, 25, 237, 160, 0, 175, 0, 23, 27, " <", 215, 23, 0, 150, 1, 232, 215, 25, 237, 160, 0, 176, 0, 23, 27, " <", 215, 23, 0, 150, 1, 233, 215, 25, 237, 160, 0, 177, 0, 23, 27, " <", 215, 23, 0, 150, 1, 234, 215, 25, 237, 160, 0, 178, 0, 23, 27, " <", 215, 23, 0, 150, 1, 235, 215, 25, 237, 160, 0, 179, 0, 23, 27, " <", 215, 23, 0, 150, 1, 236, 215, 25, 237, 160, 0, 180, 0, 23, 27, " <", 215, 23, 0, 150, 1, 237, 215, 25, 237, 160, 0, 181, 0, 23, 27, " <", 215, 23, 0, 150, 1, 238, 215, 25, 237, 160, 0, 182, 0, 23, 27, " <", 215, 23, 0, 150, 1, 239, 215, 25, 237, 160, 0, 183, 0, 23, 27, " <", 215, 23, 0, 150, 1, 240, 215, 25, 237, 160, 0, 184, 0, 23, 27, " <", 215, 23, 0, 150, 1, 241, 215, 25, 237, 160, 0, 185, 0, 23, 27, " <", 215, 23, 0, 150, 1, 242, 215, 25, 237, 160, 0, 186, 0, 23, 27, " <", 215, 23, 0, 150, 1, 243, 215, 25, 237, 160, 0, 187, 0, 23, 27, " <", 215, 23, 0, 150, 1, 244, 215, 25, 237, 160, 0, 188, 0, 23, 27, " <", 215, 23, 0, 150, 1, 245, 215, 25, 237, 160, 0, 189, 0, 23, 27, " <", 215, 23, 0, 150, 1, 246, 215, 25, 237, 160, 0, 190, 0, 23, 27, " <", 215, 23, 0, 150, 1, 247, 215, 25, 237, 160, 0, 191, 0, 23, 27, " <", 215, 23, 0, 150, 1, 248, 215, 25, 237, 160, 0, 192, 0, 23, 27, " <", 215, 23, 0, 150, 1, 249, 215, 25, 237, 160, 0, 193, 0, 23, 27, " <", 215, 23, 0, 150, 1, 250, 215, 25, 237, 160, 0, 194, 0, 23, 27, " <", 215, 23, 0, 150, 1, 251, 215, 25, 237, 160, 0, 195, 0, 23, 27, " <", 215, 23, 0, 150, 1, 252, 215, 25, 237, 160, 0, 196, 0, 23, 27, " <", 215, 23, 0, 150, 1, 253, 215, 25, 237, 160, 0, 197, 0, 23, 27, " <", 215, 23, 0, 150, 1, 254, 215, 25, 237, 160, 0, 198, 0, 23, 27, " <", 215, 23, 0, 150, 1, 255, 215, 25, 237, 160, 0, 199, 0, 23, 27, " <", 215, 23, 0, 150, 1, 0, 216, 25, 237, 160, 0, 200, 0, 23, 27, " <", 215, 23, 0, 150, 1, 1, 216, 25, 237, 160, 0, 201, 0, 23, 27, " <", 215, 23, 0, 150, 1, 2, 216, 25, 237, 160, 0, 202, 0, 23, 27, " <", 215, 23, 0, 150, 1, 3, 216, 25, 237, 160, 0, 203, 0, 23, 27, " <", 215, 23, 0, 150, 1, 4, 216, 25, 237, 160, 0, 204, 0, 23, 27, " <", 215, 23, 0, 150, 1, 5, 216, 25, 237, 160, 0, 205, 0, 23, 27, " <", 215, 23, 0, 150, 1, 6, 216, 25, 237, 160, 0, 206, 0, 23, 27, " <", 215, 23, 0, 150, 1, 7, 216, 25, 237, 160, 0, 207, 0, 23, 27, " <", 215, 23, 0, 150, 1, 8, 216, 25, 237, 160, 0, 208, 0, 23, 27, " <", 215, 23, 0, 150, 1, 9, 216, 25, 237, 160, 0, 209, 0, 23, 27, " <", 215, 23, 0, 150, 1, 10, 216, 25, 237, 160, 0, 210, 0, 23, 27, " <", 215, 23, 0, 150, 1, 11, 216, 25, 237, 160, 0, 211, 0, 23, 27, " <", 215, 23, 0, 150, 1, 12, 216, 25, 237, 160, 0, 212, 0, 23, 27, " <", 215, 23, 0, 150, 1, 13, 216, 25, 237, 160, 0, 213, 0, 23, 27, " <", 215, 23, 0, 150, 1, 14, 216, 25, 237, 160, 0, 214, 0, 23, 27, " <", 215, 23, 0, 150, 1, 15, 216, 25, 237, 160, 0, 215, 0, 23, 27, " <", 215, 23, 0, 150, 1, 16, 216, 25, 237, 160, 0, 216, 0, 23, 27, " <", 215, 23, 0, 150, 1, 17, 216, 25, 237, 160, 0, 217, 0, 23, 27, " <", 215, 23, 0, 150, 1, 18, 216, 25, 237, 160, 0, 218, 0, 23, 27, " <", 215, 23, 0, 150, 1, 19, 216, 25, 237, 160, 0, 219, 0, 23, 27, " <", 215, 23, 0, 150, 1, 20, 216, 25, 237, 160, 0, 220, 0, 23, 27, " <", 215, 23, 0, 150, 1, 21, 216, 25, 237, 160, 0, 221, 0, 23, 27, " <", 215, 23, 0, 150, 1, 22, 216, 25, 237, 160, 0, 222, 0, 23, 27, " <", 215, 23, 0, 150, 1, 23, 216, 25, 237, 160, 0, 223, 0, 23, 0, 160, 218, 214, 2, 23, 0, 160, 218, 214, 0, "+", 21, 23, 0, 160, 217, 214, 5, 226, 3, 0, 2, 0, 216, 214, 0, 0, 23, 0, 160, 217, 214, 5, 226, 13, 0, 2, 0, 216, 214, 2, 0, 23, 0, 160, 217, 214, 5, 226, 9, 0, 2, 0, 216, 214, 4, 0, 23, 0, 160, 217, 214, 5, 226, 20, 0, 2, 0, 216, 214, 6, 0, 23, 0, 160, 217, 214, 5, 226, 30, 0, 2, 0, 216, 214, 8, 0, 23, 0, 160, 217, 214, 5, 226, 26, 0, 2, 0, 216, 214, 10, 0, 23, 0, 160, 217, 214, 5, 226, "%", 0, 2, 0, 216, 214, 12, 0, 23, 0, 160, 217, 214, 5, 226, "/", 0, 2, 0, 216, 214, 14, 0, 23, 0, 160, 217, 214, 5, 226, "+", 0, 2, 0, 216, 214, 16, 0, 23, 0, 160, 217, 214, 5, 226, "6", 0, 2, 0, 216, 214, 18, 0, 23, 0, 160, 217, 214, 5, 226, "@", 0, 2, 0, 216, 214, 20, 0, 23, 0, 160, 217, 214, 5, 226, "<", 0, 2, 0, 216, 214, 22, 0, 23, 0, 160, 217, 214, 5, 226, "G", 0, 2, 0, 216, 214, 24, 0, 23, 0, 160, 217, 214, 5, 226, "Q", 0, 2, 0, 216, 214, 26, 0, 23, 0, 160, 217, 214, 5, 226, "M", 0, 2, 0, 216, 214, 28, 0, 23, 0, 160, 217, 214, 5, 226, "X", 0, 2, 0, 216, 214, 30, 0, 23, 0, 160, 217, 214, 5, 226, "b", 0, 2, 0, 216, 214, " ", 0, 23, 0, 160, 217, 214, 5, 226, "^", 0, 2, 0, 216, 214, 34, 0, 23, 0, 160, 217, 214, 5, 226, "i", 0, 2, 0, 216, 214, "$", 0, 23, 0, 160, 217, 214, 5, 226, "s", 0, 2, 0, 216, 214, "&", 0, 23, 0, 160, 217, 214, 5, 226, "o", 0, 2, 0, 216, 214, "(", 0, 23, 0, 160, 217, 214, 5, 226, "z", 0, 2, 0, 216, 214, "*", 0, 23, 0, 160, 217, 214, 5, 226, 132, 0, 2, 0, 216, 214, ",", 0, 23, 0, 160, 217, 214, 5, 226, 128, 0, 2, 0, 216, 214, ".", 0, 23, 0, 160, 217, 214, 5, 226, 139, 0, 2, 0, 216, 214, "0", 0, 23, 0, 160, 217, 214, 5, 226, 149, 0, 2, 0, 216, 214, "2", 0, 23, 0, 160, 217, 214, 5, 226, 145, 0, 2, 0, 216, 214, "4", 0, 23, 0, 160, 217, 214, 5, 226, 156, 0, 2, 0, 216, 214, "6", 0, 23, 0, 160, 217, 214, 5, 226, 166, 0, 2, 0, 216, 214, "8", 0, 23, 0, 160, 217, 214, 5, 226, 162, 0, 2, 0, 216, 214, ":", 0, 23, 0, 160, 217, 214, 5, 226, 173, 0, 2, 0, 216, 214, "<", 0, 23, 0, 160, 217, 214, 5, 226, 183, 0, 2, 0, 216, 214, ">", 0, 23, 0, 160, 217, 214, 5, 226, 179, 0, 2, 0, 216, 214, "@", 0, 23, 0, 160, 217, 214, 5, 226, 190, 0, 2, 0, 216, 214, "B", 0, 23, 0, 160, 217, 214, 5, 226, 200, 0, 2, 0, 216, 214, "D", 0, 23, 0, 160, 217, 214, 5, 226, 196, 0, 2, 0, 216, 214, "F", 0, 23, 0, 160, 217, 214, 5, 226, 207, 0, 2, 0, 216, 214, "H", 0, 23, 0, 160, 217, 214, 5, 226, 217, 0, 2, 0, 216, 214, "J", 0, 23, 0, 160, 217, 214, 5, 226, 213, 0, 2, 0, 216, 214, "L", 0, 23, 0, 160, 217, 214, 5, 226, 224, 0, 2, 0, 216, 214, "N", 0, 23, 0, 160, 217, 214, 5, 226, 234, 0, 2, 0, 216, 214, "P", 0, 23, 0, 160, 217, 214, 5, 226, 230, 0, 2, 0, 216, 214, "R", 0, 23, 0, 160, 217, 214, 5, 226, 241, 0, 2, 0, 216, 214, "T", 0, 23, 0, 160, 217, 214, 5, 226, 251, 0, 2, 0, 216, 214, "V", 0, 23, 0, 160, 217, 214, 5, 226, 247, 0, 2, 0, 216, 214, "X", 0, 23, 0, 160, 217, 214, 5, 226, 2, 1, 2, 0, 216, 214, "Z", 0, 23, 0, 160, 217, 214, 5, 226, 12, 1, 2, 0, 216, 214, 92, 0, 23, 0, 160, 217, 214, 5, 226, 8, 1, 2, 0, 216, 214, "^", 0, 23, 0, 160, 217, 214, 5, 226, 19, 1, 2, 0, 216, 214, "`", 0, 23, 0, 160, 217, 214, 5, 226, 29, 1, 2, 0, 216, 214, "b", 0, 23, 0, 160, 217, 214, 5, 226, 25, 1, 2, 0, 216, 214, "d", 0, 23, 0, 160, 217, 214, 5, 226, "$", 1, 2, 0, 216, 214, "f", 0, 23, 0, 160, 217, 214, 5, 226, ".", 1, 2, 0, 216, 214, "h", 0, 23, 0, 160, 217, 214, 5, 226, "*", 1, 2, 0, 216, 214, "j", 0, 23, 0, 160, 217, 214, 5, 226, "5", 1, 2, 0, 216, 214, "l", 0, 23, 0, 160, 217, 214, 5, 226, "?", 1, 2, 0, 216, 214, "n", 0, 23, 0, 160, 217, 214, 5, 226, ";", 1, 2, 0, 216, 214, "p", 0, 23, 0, 160, 217, 214, 5, 226, "F", 1, 2, 0, 216, 214, "r", 0, 23, 0, 160, 217, 214, 5, 226, "P", 1, 2, 0, 216, 214, "t", 0, 23, 0, 160, 217, 214, 5, 226, "L", 1, 2, 0, 216, 214, "v", 0, 23, 0, 160, 217, 214, 5, 226, "W", 1, 2, 0, 216, 214, "x", 0, 23, 0, 160, 217, 214, 5, 226, "a", 1, 2, 0, 216, 214, "z", 0, 23, 0, 160, 217, 214, 5, 226, "]", 1, 2, 0, 216, 214, "|", 0, 23, 0, 160, 217, 214, 5, 226, "h", 1, 2, 0, 216, 214, "~", 0, 23, 0, 160, 217, 214, 5, 226, "r", 1, 2, 0, 216, 214, 128, 0, 23, 0, 160, 217, 214, 5, 226, "n", 1, 2, 0, 216, 214, 130, 0, 23, 0, 160, 217, 214, 5, 226, "y", 1, 2, 0, 216, 214, 132, 0, 23, 0, 160, 217, 214, 5, 226, 131, 1, 2, 0, 216, 214, 134, 0, 23, 0, 160, 217, 214, 5, 226, 127, 1, 2, 0, 216, 214, 136, 0, 23, 0, 160, 217, 214, 5, 226, 138, 1, 2, 0, 216, 214, 138, 0, 23, 0, 160, 217, 214, 5, 226, 148, 1, 2, 0, 216, 214, 140, 0, 23, 0, 160, 217, 214, 5, 226, 144, 1, 2, 0, 216, 214, 142, 0, 23, 0, 160, 217, 214, 5, 226, 155, 1, 2, 0, 216, 214, 144, 0, 23, 0, 160, 217, 214, 5, 226, 165, 1, 2, 0, 216, 214, 146, 0, 23, 0, 160, 217, 214, 5, 226, 161, 1, 2, 0, 216, 214, 148, 0, 23, 0, 160, 217, 214, 5, 226, 172, 1, 2, 0, 216, 214, 150, 0, 23, 0, 160, 217, 214, 5, 226, 182, 1, 2, 0, 216, 214, 152, 0, 23, 0, 160, 217, 214, 5, 226, 178, 1, 2, 0, 216, 214, 154, 0, 23, 0, 160, 217, 214, 5, 226, 189, 1, 2, 0, 216, 214, 156, 0, 23, 0, 160, 217, 214, 5, 226, 199, 1, 2, 0, 216, 214, 158, 0, 23, 0, 160, 217, 214, 5, 226, 195, 1, 2, 0, 216, 214, 160, 0, 23, 0, 160, 217, 214, 5, 226, 206, 1, 2, 0, 216, 214, 162, 0, 23, 0, 160, 217, 214, 5, 226, 216, 1, 2, 0, 216, 214, 164, 0, 23, 0, 160, 217, 214, 5, 226, 212, 1, 2, 0, 216, 214, 166, 0, 23, 0, 160, 217, 214, 5, 226, 223, 1, 2, 0, 216, 214, 168, 0, 23, 0, 160, 217, 214, 5, 226, 233, 1, 2, 0, 216, 214, 170, 0, 23, 0, 160, 217, 214, 5, 226, 229, 1, 2, 0, 216, 214, 172, 0, 23, 0, 160, 217, 214, 5, 226, 240, 1, 2, 0, 216, 214, 174, 0, 23, 0, 160, 217, 214, 5, 226, 250, 1, 2, 0, 216, 214, 176, 0, 23, 0, 160, 217, 214, 5, 226, 246, 1, 2, 0, 216, 214, 178, 0, 23, 0, 160, 217, 214, 5, 226, 1, 2, 2, 0, 216, 214, 180, 0, 23, 0, 160, 217, 214, 5, 226, 11, 2, 2, 0, 216, 214, 182, 0, 23, 0, 160, 217, 214, 5, 226, 7, 2, 2, 0, 216, 214, 184, 0, 23, 0, 160, 217, 214, 5, 226, 18, 2, 2, 0, 216, 214, 186, 0, 23, 0, 160, 217, 214, 5, 226, 28, 2, 2, 0, 216, 214, 188, 0, 23, 0, 160, 217, 214, 5, 226, 24, 2, 2, 0, 216, 214, 190, 0, 23, 0, 160, 217, 214, 5, 226, "#", 2, 2, 0, 216, 214, 192, 0, 23, 0, 160, 217, 214, 5, 226, "-", 2, 2, 0, 216, 214, 194, 0, 23, 0, 160, 217, 214, 5, 226, ")", 2, 2, 0, 216, 214, 196, 0, 23, 0, 160, 217, 214, 5, 226, "4", 2, 2, 0, 216, 214, 198, 0, 23, 0, 160, 217, 214, 5, 226, ">", 2, 2, 0, 216, 214, 200, 0, 23, 0, 160, 217, 214, 5, 226, ":", 2, 2, 0, 216, 214, 202, 0, 23, 0, 160, 217, 214, 5, 226, "E", 2, 2, 0, 216, 214, 204, 0, 23, 0, 160, 217, 214, 5, 226, "O", 2, 2, 0, 216, 214, 206, 0, 23, 0, 160, 217, 214, 5, 226, "K", 2, 2, 0, 216, 214, 208, 0, 23, 0, 160, 217, 214, 5, 226, "V", 2, 2, 0, 216, 214, 210, 0, 23, 0, 160, 217, 214, 5, 226, "`", 2, 2, 0, 216, 214, 212, 0, 23, 0, 160, 217, 214, 5, 226, 92, 2, 2, 0, 216, 214, 214, 0, 23, 0, 160, 217, 214, 5, 226, "g", 2, 2, 0, 216, 214, 216, 0, 23, 0, 160, 217, 214, 5, 226, "q", 2, 2, 0, 216, 214, 218, 0, 23, 0, 160, 217, 214, 5, 226, "m", 2, 2, 0, 216, 214, 220, 0, 23, 0, 160, 217, 214, 5, 226, "x", 2, 2, 0, 216, 214, 222, 0, 23, 0, 160, 217, 214, 5, 226, 130, 2, 2, 0, 216, 214, 224, 0, 23, 0, 160, 217, 214, 5, 226, "~", 2, 2, 0, 216, 214, 226, 0, 23, 0, 160, 217, 214, 5, 226, 137, 2, 2, 0, 216, 214, 228, 0, 23, 0, 160, 217, 214, 5, 226, 147, 2, 2, 0, 216, 214, 230, 0, 23, 0, 160, 217, 214, 5, 226, 143, 2, 2, 0, 216, 214, 232, 0, 23, 0, 160, 217, 214, 5, 226, 154, 2, 2, 0, 216, 214, 234, 0, 23, 0, 160, 217, 214, 5, 226, 164, 2, 2, 0, 216, 214, 236, 0, 23, 0, 160, 217, 214, 5, 226, 160, 2, 2, 0, 216, 214, 238, 0, 23, 0, 160, 217, 214, 5, 226, 171, 2, 2, 0, 216, 214, 240, 0, 23, 0, 160, 217, 214, 5, 226, 181, 2, 2, 0, 216, 214, 242, 0, 23, 0, 160, 217, 214, 5, 226, 177, 2, 2, 0, 216, 214, 244, 0, 23, 0, 160, 217, 214, 5, 226, 188, 2, 2, 0, 216, 214, 246, 0, 23, 0, 160, 217, 214, 5, 226, 198, 2, 2, 0, 216, 214, 248, 0, 23, 0, 160, 217, 214, 5, 226, 194, 2, 2, 0, 216, 214, 250, 0, 23, 0, 160, 217, 214, 5, 226, 205, 2, 2, 0, 216, 214, 252, 0, 23, 0, 160, 217, 214, 5, 226, 215, 2, 2, 0, 216, 214, 254, 0, 23, 0, 160, 217, 214, 5, 226, 211, 2, 2, 0, 216, 214, 0, 1, 23, 0, 160, 217, 214, 5, 226, 222, 2, 2, 0, 216, 214, 2, 1, 23, 0, 160, 217, 214, 5, 226, 232, 2, 2, 0, 216, 214, 4, 1, 23, 0, 160, 217, 214, 5, 226, 228, 2, 2, 0, 216, 214, 6, 1, 23, 0, 160, 217, 214, 5, 226, 239, 2, 2, 0, 216, 214, 8, 1, 23, 0, 160, 217, 214, 5, 226, 249, 2, 2, 0, 216, 214, 10, 1, 23, 0, 160, 217, 214, 5, 226, 245, 2, 2, 0, 216, 214, 12, 1, 23, 0, 160, 217, 214, 5, 226, 0, 3, 2, 0, 216, 214, 14, 1, 23, 0, 160, 217, 214, 5, 226, 10, 3, 2, 0, 216, 214, 16, 1, 23, 0, 160, 217, 214, 5, 226, 6, 3, 2, 0, 216, 214, 18, 1, 23, 0, 160, 217, 214, 5, 226, 17, 3, 2, 0, 216, 214, 20, 1, 23, 0, 160, 217, 214, 5, 226, 27, 3, 2, 0, 216, 214, 22, 1, 23, 0, 160, 217, 214, 5, 226, 23, 3, 2, 0, 216, 214, 24, 1, 23, 0, 160, 217, 214, 5, 226, 34, 3, 2, 0, 216, 214, 26, 1, 23, 0, 160, 217, 214, 5, 226, ",", 3, 2, 0, 216, 214, 28, 1, 23, 0, 160, 217, 214, 5, 226, "(", 3, 2, 0, 216, 214, 30, 1, 23, 0, 160, 217, 214, 5, 226, "3", 3, 2, 0, 216, 214, " ", 1, 23, 0, 160, 217, 214, 5, 226, "=", 3, 2, 0, 216, 214, 34, 1, 23, 0, 160, 217, 214, 5, 226, "9", 3, 2, 0, 216, 214, "$", 1, 23, 0, 160, 217, 214, 5, 226, "D", 3, 2, 0, 216, 214, "&", 1, 23, 0, 160, 217, 214, 5, 226, "N", 3, 2, 0, 216, 214, "(", 1, 23, 0, 160, 217, 214, 5, 226, "J", 3, 2, 0, 216, 214, "*", 1, 23, 0, 160, 217, 214, 5, 226, "U", 3, 2, 0, 216, 214, ",", 1, 23, 0, 160, 217, 214, 5, 226, "_", 3, 2, 0, 216, 214, ".", 1, 23, 0, 160, 217, 214, 5, 226, "[", 3, 2, 0, 216, 214, "0", 1, 23, 0, 160, 217, 214, 5, 226, "f", 3, 2, 0, 216, 214, "2", 1, 23, 0, 160, 217, 214, 5, 226, "p", 3, 2, 0, 216, 214, "4", 1, 23, 0, 160, 217, 214, 5, 226, "l", 3, 2, 0, 216, 214, "6", 1, 23, 0, 160, 217, 214, 5, 226, "w", 3, 2, 0, 216, 214, "8", 1, 23, 0, 160, 217, 214, 5, 226, 129, 3, 2, 0, 216, 214, ":", 1, 23, 0, 160, 217, 214, 5, 226, "}", 3, 2, 0, 216, 214, "<", 1, 23, 0, 160, 217, 214, 5, 226, 136, 3, 2, 0, 216, 214, ">", 1, 23, 0, 160, 217, 214, 5, 226, 146, 3, 2, 0, 216, 214, "@", 1, 23, 0, 160, 217, 214, 5, 226, 142, 3, 2, 0, 216, 214, "B", 1, 23, 0, 160, 217, 214, 5, 226, 153, 3, 2, 0, 216, 214, "D", 1, 23, 0, 160, 217, 214, 5, 226, 163, 3, 2, 0, 216, 214, "F", 1, 23, 0, 160, 217, 214, 5, 226, 159, 3, 2, 0, 216, 214, "H", 1, 23, 0, 160, 217, 214, 5, 226, 170, 3, 2, 0, 216, 214, "J", 1, 23, 0, 160, 217, 214, 5, 226, 180, 3, 2, 0, 216, 214, "L", 1, 23, 0, 160, 217, 214, 5, 226, 176, 3, 2, 0, 216, 214, "N", 1, 23, 0, 160, 217, 214, 5, 226, 187, 3, 2, 0, 216, 214, "P", 1, 23, 0, 160, 217, 214, 5, 226, 197, 3, 2, 0, 216, 214, "R", 1, 23, 0, 160, 217, 214, 5, 226, 193, 3, 2, 0, 216, 214, "T", 1, 23, 0, 160, 217, 214, 5, 226, 204, 3, 2, 0, 216, 214, "V", 1, 23, 0, 160, 217, 214, 5, 226, 214, 3, 2, 0, 216, 214, "X", 1, 23, 0, 160, 217, 214, 5, 226, 210, 3, 2, 0, 216, 214, "Z", 1, 23, 0, 160, 217, 214, 5, 226, 221, 3, 2, 0, 216, 214, 92, 1, 23, 0, 160, 217, 214, 5, 226, 231, 3, 2, 0, 216, 214, "^", 1, 23, 0, 160, 217, 214, 5, 226, 227, 3, 2, 0, 216, 214, "`", 1, 23, 0, 160, 217, 214, 5, 226, 238, 3, 2, 0, 216, 214, "b", 1, 23, 0, 160, 217, 214, 5, 226, 248, 3, 2, 0, 216, 214, "d", 1, 23, 0, 160, 217, 214, 5, 226, 244, 3, 2, 0, 216, 214, "f", 1, 23, 0, 160, 217, 214, 5, 226, 255, 3, 2, 0, 216, 214, "h", 1, 23, 0, 160, 217, 214, 5, 226, 9, 4, 2, 0, 216, 214, "j", 1, 23, 0, 160, 217, 214, 5, 226, 5, 4, 2, 0, 216, 214, "l", 1, 23, 0, 160, 217, 214, 5, 226, 16, 4, 2, 0, 216, 214, "n", 1, 23, 0, 160, 217, 214, 5, 226, 26, 4, 2, 0, 216, 214, "p", 1, 23, 0, 160, 217, 214, 5, 226, 22, 4, 2, 0, 216, 214, "r", 1, 23, 0, 160, 217, 214, 5, 226, "!", 4, 2, 0, 216, 214, "t", 1, 23, 0, 160, 217, 214, 5, 226, "+", 4, 2, 0, 216, 214, "v", 1, 23, 0, 160, 217, 214, 5, 226, "'", 4, 2, 0, 216, 214, "x", 1, 23, 0, 160, 217, 214, 5, 226, "2", 4, 2, 0, 216, 214, "z", 1, 23, 0, 160, 217, 214, 5, 226, "<", 4, 2, 0, 216, 214, "|", 1, 23, 0, 160, 217, 214, 5, 226, "8", 4, 2, 0, 216, 214, "~", 1, 23, 0, 160, 217, 214, 5, 226, "C", 4, 2, 0, 216, 214, 128, 1, 23, 0, 160, 217, 214, 5, 226, "M", 4, 2, 0, 216, 214, 130, 1, 23, 0, 160, 217, 214, 5, 226, "I", 4, 2, 0, 216, 214, 132, 1, 23, 0, 160, 217, 214, 5, 226, "T", 4, 2, 0, 216, 214, 134, 1, 23, 0, 160, 217, 214, 5, 226, "^", 4, 2, 0, 216, 214, 136, 1, 23, 0, 160, 217, 214, 5, 226, "Z", 4, 2, 0, 216, 214, 138, 1, 23, 0, 160, 217, 214, 5, 226, "e", 4, 2, 0, 216, 214, 140, 1, 23, 0, 160, 217, 214, 5, 226, "o", 4, 2, 0, 216, 214, 142, 1, 23, 0, 160, 217, 214, 5, 226, "k", 4, 2, 0, 216, 214, 144, 1, 23, 0, 160, 217, 214, 5, 226, "v", 4, 2, 0, 216, 214, 146, 1, 23, 0, 160, 217, 214, 5, 226, 128, 4, 2, 0, 216, 214, 148, 1, 23, 0, 160, 217, 214, 5, 226, "|", 4, 2, 0, 216, 214, 150, 1, 23, 0, 160, 217, 214, 5, 226, 135, 4, 2, 0, 216, 214, 152, 1, 23, 0, 160, 217, 214, 5, 226, 145, 4, 2, 0, 216, 214, 154, 1, 23, 0, 160, 217, 214, 5, 226, 141, 4, 2, 0, 216, 214, 156, 1, 23, 0, 160, 217, 214, 5, 226, 152, 4, 2, 0, 216, 214, 158, 1, 23, 0, 160, 217, 214, 5, 226, 162, 4, 2, 0, 216, 214, 160, 1, 23, 0, 160, 217, 214, 5, 226, 158, 4, 2, 0, 216, 214, 162, 1, 23, 0, 160, 217, 214, 5, 226, 169, 4, 2, 0, 216, 214, 164, 1, 23, 0, 160, 217, 214, 5, 226, 179, 4, 2, 0, 216, 214, 166, 1, 23, 0, 160, 217, 214, 5, 226, 175, 4, 2, 0, 216, 214, 168, 1, 23, 0, 160, 217, 214, 5, 226, 186, 4, 2, 0, 216, 214, 170, 1, 23, 0, 160, 217, 214, 5, 226, 196, 4, 2, 0, 216, 214, 172, 1, 23, 0, 160, 217, 214, 5, 226, 192, 4, 2, 0, 216, 214, 174, 1, 23, 0, 160, 217, 214, 5, 226, 203, 4, 2, 0, 216, 214, 176, 1, 23, 0, 160, 217, 214, 5, 226, 213, 4, 2, 0, 216, 214, 178, 1, 23, 0, 160, 217, 214, 5, 226, 209, 4, 2, 0, 216, 214, 180, 1, 23, 0, 160, 217, 214, 5, 226, 220, 4, 2, 0, 216, 214, 182, 1, 23, 0, 160, 217, 214, 5, 226, 230, 4, 2, 0, 216, 214, 184, 1, 23, 0, 160, 217, 214, 5, 226, 226, 4, 2, 0, 216, 214, 186, 1, 23, 0, 160, 217, 214, 5, 226, 237, 4, 2, 0, 216, 214, 188, 1, 23, 0, 160, 217, 214, 5, 226, 247, 4, 2, 0, 216, 214, 190, 1, 23, 0, 160, 217, 214, 5, 226, 243, 4, 2, 0, 216, 214, 192, 1, 23, 0, 160, 217, 214, 5, 226, 254, 4, 2, 0, 216, 214, 194, 1, 23, 0, 160, 217, 214, 5, 226, 8, 5, 2, 0, 216, 214, 196, 1, 23, 0, 160, 217, 214, 5, 226, 4, 5, 2, 0, 216, 214, 198, 1, 23, 0, 160, 217, 214, 5, 226, 15, 5, 2, 0, 216, 214, 200, 1, 23, 0, 160, 217, 214, 5, 226, 25, 5, 2, 0, 216, 214, 202, 1, 23, 0, 160, 217, 214, 5, 226, 21, 5, 2, 0, 216, 214, 204, 1, 23, 0, 160, 217, 214, 5, 226, " ", 5, 2, 0, 216, 214, 206, 1, 23, 0, 160, 217, 214, 5, 226, "*", 5, 2, 0, 216, 214, 208, 1, 23, 0, 160, 217, 214, 5, 226, "&", 5, 2, 0, 216, 214, 210, 1, 23, 0, 160, 217, 214, 5, 226, "1", 5, 2, 0, 216, 214, 212, 1, 23, 0, 160, 217, 214, 5, 226, ";", 5, 2, 0, 216, 214, 214, 1, 23, 0, 160, 217, 214, 5, 226, "7", 5, 2, 0, 216, 214, 216, 1, 23, 0, 160, 217, 214, 5, 226, "B", 5, 2, 0, 216, 214, 218, 1, 23, 0, 160, 217, 214, 5, 226, "L", 5, 2, 0, 216, 214, 220, 1, 23, 0, 160, 217, 214, 5, 226, "H", 5, 2, 0, 216, 214, 222, 1, 23, 0, 160, 217, 214, 5, 226, "S", 5, 2, 0, 216, 214, 224, 1, 23, 0, 160, 217, 214, 5, 226, "]", 5, 2, 0, 216, 214, 226, 1, 23, 0, 160, 217, 214, 5, 226, "Y", 5, 2, 0, 216, 214, 228, 1, 23, 0, 160, 217, 214, 5, 226, "d", 5, 2, 0, 216, 214, 230, 1, 23, 0, 160, 217, 214, 5, 226, "n", 5, 2, 0, 216, 214, 232, 1, 23, 0, 160, 217, 214, 5, 226, "j", 5, 2, 0, 216, 214, 234, 1, 23, 0, 160, 217, 214, 5, 226, "u", 5, 2, 0, 216, 214, 236, 1, 23, 0, 160, 217, 214, 5, 226, 127, 5, 2, 0, 216, 214, 238, 1, 23, 0, 160, 217, 214, 5, 226, "{", 5, 2, 0, 216, 214, 240, 1, 23, 0, 160, 217, 214, 5, 226, 134, 5, 2, 0, 216, 214, 242, 1, 23, 0, 160, 217, 214, 5, 226, 144, 5, 2, 0, 216, 214, 244, 1, 23, 0, 160, 217, 214, 5, 226, 140, 5, 2, 0, 216, 214, 246, 1, 23, 0, 160, 217, 214, 5, 226, 151, 5, 2, 0, 216, 214, 248, 1, 23, 0, 160, 217, 214, 5, 226, 161, 5, 2, 0, 216, 214, 250, 1, 23, 0, 160, 217, 214, 5, 226, 157, 5, 2, 0, 216, 214, 252, 1, 23, 0, 160, 217, 214, 5, 226, 168, 5, 2, 0, 216, 214, 254, 1, 23, 0, 160, 217, 214, 5, 226, 178, 5, 2, 0, 216, 214, 0, 2, 23, 0, 160, 217, 214, 5, 226, 174, 5, 2, 0, 216, 214, 2, 2, 23, 0, 160, 217, 214, 5, 226, 185, 5, 2, 0, 216, 214, 4, 2, 23, 0, 160, 217, 214, 5, 226, 195, 5, 2, 0, 216, 214, 6, 2, 23, 0, 160, 217, 214, 5, 226, 191, 5, 2, 0, 216, 214, 8, 2, 23, 0, 160, 217, 214, 5, 226, 202, 5, 2, 0, 216, 214, 10, 2, 23, 0, 160, 217, 214, 5, 226, 212, 5, 2, 0, 216, 214, 12, 2, 23, 0, 160, 217, 214, 5, 226, 208, 5, 2, 0, 216, 214, 14, 2, 23, 0, 160, 217, 214, 5, 226, 219, 5, 2, 0, 216, 214, 16, 2, 23, 0, 160, 217, 214, 5, 226, 229, 5, 2, 0, 216, 214, 18, 2, 23, 0, 160, 217, 214, 5, 226, 225, 5, 2, 0, 216, 214, 20, 2, 23, 0, 160, 217, 214, 5, 226, 236, 5, 2, 0, 216, 214, 22, 2, 23, 0, 160, 217, 214, 5, 226, 246, 5, 2, 0, 216, 214, 24, 2, 23, 0, 160, 217, 214, 5, 226, 242, 5, 2, 0, 216, 214, 26, 2, 23, 0, 160, 217, 214, 5, 226, 253, 5, 2, 0, 216, 214, 28, 2, 23, 0, 160, 217, 214, 5, 226, 7, 6, 2, 0, 216, 214, 30, 2, 23, 0, 160, 217, 214, 5, 226, 3, 6, 2, 0, 216, 214, " ", 2, 23, 0, 160, 217, 214, 5, 226, 14, 6, 2, 0, 216, 214, 34, 2, 23, 0, 160, 217, 214, 5, 226, 24, 6, 2, 0, 216, 214, "$", 2, 23, 0, 160, 217, 214, 5, 226, 20, 6, 2, 0, 216, 214, "&", 2, 23, 0, 160, 217, 214, 5, 226, 31, 6, 2, 0, 216, 214, "(", 2, 23, 0, 160, 217, 214, 5, 226, ")", 6, 2, 0, 216, 214, "*", 2, 23, 0, 160, 217, 214, 5, 226, "%", 6, 2, 0, 216, 214, ",", 2, 23, 0, 160, 217, 214, 5, 226, "0", 6, 2, 0, 216, 214, ".", 2, 23, 0, 160, 217, 214, 5, 226, ":", 6, 2, 0, 216, 214, "0", 2, 23, 0, 160, 217, 214, 5, 226, "6", 6, 2, 0, 216, 214, "2", 2, 23, 0, 160, 217, 214, 5, 226, "A", 6, 2, 0, 216, 214, "4", 2, 23, 0, 160, 217, 214, 5, 226, "K", 6, 2, 0, 216, 214, "6", 2, 23, 0, 160, 217, 214, 5, 226, "G", 6, 2, 0, 216, 214, "8", 2, 23, 0, 160, 217, 214, 5, 226, "R", 6, 2, 0, 216, 214, ":", 2, 23, 0, 160, 217, 214, 5, 226, 92, 6, 2, 0, 216, 214, "<", 2, 23, 0, 160, 217, 214, 5, 226, "X", 6, 2, 0, 216, 214, ">", 2, 23, 0, 160, 217, 214, 5, 226, "c", 6, 2, 0, 216, 214, "@", 2, 23, 0, 160, 217, 214, 5, 226, "m", 6, 2, 0, 216, 214, "B", 2, 23, 0, 160, 217, 214, 5, 226, "i", 6, 2, 0, 216, 214, "D", 2, 23, 0, 160, 217, 214, 5, 226, "t", 6, 2, 0, 216, 214, "F", 2, 23, 0, 160, 217, 214, 5, 226, "~", 6, 2, 0, 216, 214, "H", 2, 23, 0, 160, 217, 214, 5, 226, "z", 6, 2, 0, 216, 214, "J", 2, 23, 0, 160, 217, 214, 5, 226, 133, 6, 2, 0, 216, 214, "L", 2, 23, 0, 160, 217, 214, 5, 226, 143, 6, 2, 0, 216, 214, "N", 2, 23, 0, 160, 217, 214, 5, 226, 139, 6, 2, 0, 216, 214, "P", 2, 23, 0, 160, 217, 214, 5, 226, 150, 6, 2, 0, 216, 214, "R", 2, 23, 0, 160, 217, 214, 5, 226, 160, 6, 2, 0, 216, 214, "T", 2, 23, 0, 160, 217, 214, 5, 226, 156, 6, 2, 0, 216, 214, "V", 2, 23, 0, 160, 217, 214, 5, 226, 167, 6, 2, 0, 216, 214, "X", 2, 23, 0, 160, 217, 214, 5, 226, 177, 6, 2, 0, 216, 214, "Z", 2, 23, 0, 160, 217, 214, 5, 226, 173, 6, 2, 0, 216, 214, 92, 2, 23, 0, 160, 217, 214, 5, 226, 184, 6, 2, 0, 216, 214, "^", 2, 23, 0, 160, 217, 214, 5, 226, 194, 6, 2, 0, 216, 214, "`", 2, 23, 0, 160, 217, 214, 5, 226, 190, 6, 2, 0, 216, 214, "b", 2, 23, 0, 160, 217, 214, 5, 226, 201, 6, 2, 0, 216, 214, "d", 2, 23, 0, 160, 217, 214, 5, 226, 211, 6, 2, 0, 216, 214, "f", 2, 23, 0, 160, 217, 214, 5, 226, 207, 6, 2, 0, 216, 214, "h", 2, 23, 0, 160, 217, 214, 5, 226, 218, 6, 2, 0, 216, 214, "j", 2, 23, 0, 160, 217, 214, 5, 226, 228, 6, 2, 0, 216, 214, "l", 2, 23, 0, 160, 217, 214, 5, 226, 224, 6, 2, 0, 216, 214, "n", 2, 23, 0, 160, 217, 214, 5, 226, 235, 6, 2, 0, 216, 214, "p", 2, 23, 0, 160, 217, 214, 5, 226, 245, 6, 2, 0, 216, 214, "r", 2, 23, 0, 160, 217, 214, 5, 226, 241, 6, 2, 0, 216, 214, "t", 2, 23, 0, 160, 217, 214, 5, 226, 252, 6, 2, 0, 216, 214, "v", 2, 23, 0, 160, 217, 214, 5, 226, 6, 7, 2, 0, 216, 214, "x", 2, 23, 0, 160, 217, 214, 5, 226, 2, 7, 2, 0, 216, 214, "z", 2, 23, 0, 160, 217, 214, 5, 226, 13, 7, 2, 0, 216, 214, "|", 2, 23, 0, 160, 217, 214, 5, 226, 23, 7, 2, 0, 216, 214, "~", 2, 23, 0, 160, 217, 214, 5, 226, 19, 7, 2, 0, 216, 214, 128, 2, 23, 0, 160, 217, 214, 5, 226, 30, 7, 2, 0, 216, 214, 130, 2, 23, 0, 160, 217, 214, 5, 226, "(", 7, 2, 0, 216, 214, 132, 2, 23, 0, 160, 217, 214, 5, 226, "$", 7, 2, 0, 216, 214, 134, 2, 23, 0, 160, 217, 214, 5, 226, "/", 7, 2, 0, 216, 214, 136, 2, 23, 0, 160, 217, 214, 5, 226, "9", 7, 2, 0, 216, 214, 138, 2, 23, 0, 160, 217, 214, 5, 226, "5", 7, 2, 0, 216, 214, 140, 2, 23, 0, 160, 217, 214, 5, 226, "@", 7, 2, 0, 216, 214, 142, 2, 23, 0, 160, 217, 214, 5, 226, "J", 7, 2, 0, 216, 214, 144, 2, 23, 0, 160, 217, 214, 5, 226, "F", 7, 2, 0, 216, 214, 146, 2, 23, 0, 160, 217, 214, 5, 226, "Q", 7, 2, 0, 216, 214, 148, 2, 23, 0, 160, 217, 214, 5, 226, "[", 7, 2, 0, 216, 214, 150, 2, 23, 0, 160, 217, 214, 5, 226, "W", 7, 2, 0, 216, 214, 152, 2, 23, 0, 160, 217, 214, 5, 226, "b", 7, 2, 0, 216, 214, 154, 2, 23, 0, 160, 217, 214, 5, 226, "l", 7, 2, 0, 216, 214, 156, 2, 23, 0, 160, 217, 214, 5, 226, "h", 7, 2, 0, 216, 214, 158, 2, 23, 0, 160, 217, 214, 5, 226, "s", 7, 2, 0, 216, 214, 160, 2, 23, 0, 160, 217, 214, 5, 226, "}", 7, 2, 0, 216, 214, 162, 2, 23, 0, 160, 217, 214, 5, 226, "y", 7, 2, 0, 216, 214, 164, 2, 23, 0, 160, 217, 214, 5, 226, 132, 7, 2, 0, 216, 214, 166, 2, 23, 0, 160, 217, 214, 5, 226, 142, 7, 2, 0, 216, 214, 168, 2, 23, 0, 160, 217, 214, 5, 226, 138, 7, 2, 0, 216, 214, 170, 2, 23, 0, 160, 217, 214, 5, 226, 149, 7, 2, 0, 216, 214, 172, 2, 23, 0, 160, 217, 214, 5, 226, 159, 7, 2, 0, 216, 214, 174, 2, 23, 0, 160, 217, 214, 5, 226, 155, 7, 2, 0, 216, 214, 176, 2, 23, 0, 160, 217, 214, 5, 226, 166, 7, 2, 0, 216, 214, 178, 2, 23, 0, 160, 217, 214, 5, 226, 176, 7, 2, 0, 216, 214, 180, 2, 23, 0, 160, 217, 214, 5, 226, 172, 7, 2, 0, 216, 214, 182, 2, 23, 0, 160, 217, 214, 5, 226, 183, 7, 2, 0, 216, 214, 184, 2, 23, 0, 160, 217, 214, 5, 226, 193, 7, 2, 0, 216, 214, 186, 2, 23, 0, 160, 217, 214, 5, 226, 189, 7, 2, 0, 216, 214, 188, 2, 23, 0, 160, 217, 214, 5, 226, 200, 7, 2, 0, 216, 214, 190, 2, 23, 0, 160, 217, 214, 5, 226, 210, 7, 2, 0, 216, 214, 192, 2, 23, 0, 160, 217, 214, 5, 226, 206, 7, 2, 0, 216, 214, 194, 2, 23, 0, 160, 217, 214, 5, 226, 217, 7, 2, 0, 216, 214, 196, 2, 23, 0, 160, 217, 214, 5, 226, 227, 7, 2, 0, 216, 214, 198, 2, 23, 0, 160, 217, 214, 5, 226, 223, 7, 2, 0, 216, 214, 200, 2, 23, 0, 160, 217, 214, 5, 226, 234, 7, 2, 0, 216, 214, 202, 2, 23, 0, 160, 217, 214, 5, 226, 244, 7, 2, 0, 216, 214, 204, 2, 23, 0, 160, 217, 214, 5, 226, 240, 7, 2, 0, 216, 214, 206, 2, 23, 0, 160, 217, 214, 1, 23, 0, 150, 1, 255, 255, 23, 0, 202, 23, 0, 128, 224

	.local	_.str
_.str:
	db	"setup timeout", 0

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_17failureE
__ZN12_GLOBAL__N_17failureE:
	d24	_.str.1

	.section	.rodata,"a",@progbits
	.local	_.str.1
_.str.1:
	db	"none", 0

	.local	_.str.2
_.str.2:
	db	"draw timeout", 0

	.local	___const.main.ys
___const.main.ys:
	d24	104                             ; 0x68
	d24	115                             ; 0x73
	d24	116                             ; 0x74
	d24	140                             ; 0x8c
	d24	160                             ; 0xa0
	d24	180                             ; 0xb4
	d24	200                             ; 0xc8
	d24	223                             ; 0xdf

	.local	_.str.3
_.str.3:
	db	"pixel mismatch", 0

	.local	_.str.4
_.str.4:
	db	"outer edge mismatch", 0

	.local	_.str.5
_.str.5:
	db	"kerb mismatch", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_19completedE
__ZN12_GLOBAL__N_19completedE:
	.skip	3

	.section	.rodata,"a",@progbits
	.local	_.str.6
_.str.6:
	db	"summary.txt", 0

	.local	_.str.7
_.str.7:
	db	"views=%u", 13, 10, "pixel_checks=%u", 13, 10, "source_width=35", 13, 10, "parameter_bytes=720", 13, 10, "road_update_call_bytes=737", 13, 10, "road_writes=%u", 13, 10, "application_bytes_before_save=%lu", 13, 10, "failure=%s", 13, 10, 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_15countE
__ZN12_GLOBAL__N_15countE:
	.skip	3

	.local	__ZN12_GLOBAL__N_111road_writesE
__ZN12_GLOBAL__N_111road_writesE:
	.skip	3

	.local	__ZN12_GLOBAL__N_14wireE
__ZN12_GLOBAL__N_14wireE:
	.skip	4

	.section	.rodata,"a",@progbits
	.local	_.str.8
_.str.8:
	db	"pixels.csv", 0

	.local	_.str.9
_.str.9:
	db	"view,x,y,expected,actual,r,g,b", 13, 10, 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_16pixelsE
__ZN12_GLOBAL__N_16pixelsE:
	.skip	2304

	.section	.rodata,"a",@progbits
	.local	_.str.10
_.str.10:
	db	"%u,%u,%u,%u,%u,%u,%u,%u", 13, 10, 0

	.local	_.str.11
_.str.11:
	db	"command.bin", 0

	.section	.data,"aw",@progbits
	.local	__ZL11RoadCommand
__ZL11RoadCommand:
	db	23, 0, 160, 216, 214, 5, 194, 0, 0, 208, 2, "<", 215, 160, 0, 160, 215, "<", 215, 160, 0, 161, 215, "<", 215, 160, 0, 162, 215, "<", 215, 160, 0, 163, 215, "<", 215, 160, 0, 164, 215, "<", 215, 160, 0, 165, 215, "<", 215, 160, 0, 166, 215, "<", 215, 160, 0, 167, 215, "<", 215, 160, 0, 168, 215, "<", 215, 160, 0, 169, 215, "<", 215, 160, 0, 170, 215, "<", 215, 160, 0, 171, 215, "<", 215, 160, 0, 172, 215, "<", 215, 160, 0, 173, 215, "<", 215, 160, 0, 174, 215, "<", 215, 160, 0, 175, 215, "<", 215, 160, 0, 176, 215, "<", 215, 160, 0, 177, 215, "<", 215, 160, 0, 178, 215, "<", 215, 160, 0, 179, 215, "<", 215, 160, 0, 180, 215, "<", 215, 160, 0, 181, 215, "<", 215, 160, 0, 182, 215, "<", 215, 160, 0, 183, 215, "<", 215, 160, 0, 184, 215, "<", 215, 160, 0, 185, 215, "<", 215, 160, 0, 186, 215, "<", 215, 160, 0, 187, 215, "<", 215, 160, 0, 188, 215, "<", 215, 160, 0, 189, 215, "<", 215, 160, 0, 190, 215, "<", 215, 160, 0, 191, 215, "<", 215, 160, 0, 192, 215, "<", 215, 160, 0, 193, 215, "<", 215, 160, 0, 194, 215, "<", 215, 160, 0, 195, 215, "<", 215, 160, 0, 196, 215, "<", 215, 160, 0, 197, 215, "<", 215, 160, 0, 198, 215, "<", 215, 160, 0, 199, 215, "<", 215, 160, 0, 200, 215, "<", 215, 160, 0, 201, 215, "<", 215, 160, 0, 202, 215, "<", 215, 160, 0, 203, 215, "<", 215, 160, 0, 204, 215, "<", 215, 160, 0, 205, 215, "<", 215, 160, 0, 206, 215, "<", 215, 160, 0, 207, 215, "<", 215, 160, 0, 208, 215, "<", 215, 160, 0, 209, 215, "<", 215, 160, 0, 210, 215, "<", 215, 160, 0, 211, 215, "<", 215, 160, 0, 212, 215, "<", 215, 160, 0, 213, 215, "<", 215, 160, 0, 214, 215, "<", 215, 160, 0, 215, 215, "<", 215, 160, 0, 216, 215, "<", 215, 160, 0, 217, 215, "<", 215, 160, 0, 218, 215, "<", 215, 160, 0, 219, 215, "<", 215, 160, 0, 220, 215, "<", 215, 160, 0, 221, 215, "<", 215, 160, 0, 222, 215, "<", 215, 160, 0, 223, 215, "<", 215, 160, 0, 224, 215, "<", 215, 160, 0, 225, 215, "<", 215, 160, 0, 226, 215, "<", 215, 160, 0, 227, 215, "<", 215, 160, 0, 228, 215, "<", 215, 160, 0, 229, 215, "<", 215, 160, 0, 230, 215, "<", 215, 160, 0, 231, 215, "<", 215, 160, 0, 232, 215, "<", 215, 160, 0, 233, 215, "<", 215, 160, 0, 234, 215, "<", 215, 160, 0, 235, 215, "<", 215, 160, 0, 236, 215, "<", 215, 160, 0, 237, 215, "<", 215, 160, 0, 238, 215, "<", 215, 160, 0, 239, 215, "<", 215, 160, 0, 240, 215, "<", 215, 160, 0, 241, 215, "<", 215, 160, 0, 242, 215, "<", 215, 160, 0, 243, 215, "<", 215, 160, 0, 244, 215, "<", 215, 160, 0, 245, 215, "<", 215, 160, 0, 246, 215, "<", 215, 160, 0, 247, 215, "<", 215, 160, 0, 248, 215, "<", 215, 160, 0, 249, 215, "<", 215, 160, 0, 250, 215, "<", 215, 160, 0, 251, 215, "<", 215, 160, 0, 252, 215, "<", 215, 160, 0, 253, 215, "<", 215, 160, 0, 254, 215, "<", 215, 160, 0, 255, 215, "<", 215, 160, 0, 0, 216, "<", 215, 160, 0, 1, 216, "<", 215, 160, 0, 2, 216, "<", 215, 160, 0, 3, 216, "<", 215, 160, 0, 4, 216, "<", 215, 160, 0, 5, 216, "<", 215, 160, 0, 6, 216, "<", 215, 160, 0, 7, 216, "<", 215, 160, 0, 8, 216, "<", 215, 160, 0, 9, 216, "<", 215, 160, 0, 10, 216, "<", 215, 160, 0, 11, 216, "<", 215, 160, 0, 12, 216, "<", 215, 160, 0, 13, 216, "<", 215, 160, 0, 14, 216, "<", 215, 160, 0, 15, 216, "<", 215, 160, 0, 16, 216, "<", 215, 160, 0, 17, 216, "<", 215, 160, 0, 18, 216, "<", 215, 160, 0, 19, 216, "<", 215, 160, 0, 20, 216, "<", 215, 160, 0, 21, 216, "<", 215, 160, 0, 22, 216, "<", 215, 160, 0, 23, 216, 23, 0, 160, 218, 214, 1

	.section	.rodata,"a",@progbits
	.local	_.str.12
_.str.12:
	db	"done.txt", 0

	.local	_.str.13
_.str.13:
	db	"done", 10, 0

	.local	_.str.14
_.str.14:
	db	"FAIL: %s", 13, 10, 0

	.local	___const.main.end
___const.main.end:
	db	23, 0, 150, 1, 255, 255, 23, 1, 1, 22, 0

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_15tokenE
__ZN12_GLOBAL__N_15tokenE:
	db	1                               ; 0x1

	.section	.rodata,"a",@progbits
	.local	___const._ZN12_GLOBAL__N_15labelEjij.pos
___const._ZN12_GLOBAL__N_15labelEjij.pos:
	db	31, 0, 0

	.local	_.str.16
_.str.16:
	db	"R28 BITMAP ROAD / VIEW %u OF 6       ", 13, 10, "Centre %d  stripe phase %u          ", 13, 10, "35x1 source; resident plots         ", 13, 10, "Normal widths/stripes, thin lines   ", 13, 10, "quantized. No game physics.         ", 13, 10, 0

	.local	___const._ZN12_GLOBAL__N_14drawEij.clear
___const._ZN12_GLOBAL__N_14drawEij.clear:
	db	18, 0, 2, 25, 4, 0, 0, "h", 0, 25, "e?", 1, 223, 0

	.local	_str
_str:
	db	13, 10, "Passed. SPACE: next view; Q: quit.", 13, 0

	.ident	"clang version 15.0.7 (https://github.com/AgonPlatform/agon-llvm-project.git c76386c0083e6a6236ff774275227e2389f85538)"
	.extern	_mos_fopen
	.extern	__Unwind_SjLj_Register
	.extern	__frameset
	.extern	__bremu
	.extern	__lremu
	.extern	_mos_sysvars
	.extern	__lsub
	.extern	_strcmp
	.extern	_snprintf
	.extern	_puts
	.extern	__ladd
	.extern	_strlen
	.extern	__idivu
	.extern	__setflag
	.extern	_mos_puts
	.extern	_printf
	.extern	__iremu
	.extern	_mos_fwrite
	.extern	__imulu
	.extern	_mos_fclose
	.extern	__Unwind_SjLj_Unregister
	.extern	__lcmpu
	.extern	__frameset0
	.extern	_getsysvar_time
	.extern	_getchar
