	.section	.text,"ax",@progbits
	.assume	ADL = 1
	.file	"main.cpp"
	.globl	__ZN2fs3nowEv                   ; -- Begin function _ZN2fs3nowEv
	.type	__ZN2fs3nowEv,@function
__ZN2fs3nowEv:                          ; @_ZN2fs3nowEv
; %bb.0:
	ld	hl, -6
	call	__frameset
	call	_mos_sysvars
	push	hl
	pop	iy
	ld	(ix - 6), iy
	lea	hl, iy + 3
	ld	(ix - 3), hl
	.local	.LBB0_1
.LBB0_1:                                ; =>This Inner Loop Header: Depth=1
	ld	iy, (ix - 6)
	ld	hl, (iy)
	lea	bc, iy + 0
	ld	iy, (ix - 3)
	ld	e, (iy)
	push	bc
	pop	iy
	ld	bc, (iy)
	ld	a, (iy + 3)
	call	__lcmpu
	jr	nz, .LBB0_1
; %bb.2:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end0
.Lfunc_end0:
	.size	__ZN2fs3nowEv, .Lfunc_end0-__ZN2fs3nowEv
                                        ; -- End function
	.globl	__ZN2fs5timerEv                 ; -- Begin function _ZN2fs5timerEv
	.type	__ZN2fs5timerEv,@function
__ZN2fs5timerEv:                        ; @_ZN2fs5timerEv
; %bb.0:
	or	a, a
	sbc	hl, hl
	ld	e, h
	ld	a, (__ZN2fs3prtE)
	bit	0, a
	jr	z, .LBB1_2
; %bb.1:
	call	_timing_ticks
	ld	e, 0
	.local	.LBB1_2
.LBB1_2:
	ret
	.local	.Lfunc_end1
.Lfunc_end1:
	.size	__ZN2fs5timerEv, .Lfunc_end1-__ZN2fs5timerEv
                                        ; -- End function
	.globl	__ZN2fs10differenceEmm          ; -- Begin function _ZN2fs10differenceEmm
	.type	__ZN2fs10differenceEmm,@function
__ZN2fs10differenceEmm:                 ; @_ZN2fs10differenceEmm
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 6)
	ld	bc, (ix + 12)
	ld	iy, -1
	ld	d, 0
	ld	e, (ix + 9)
	ld	a, (ix + 15)
	call	__lsub
	lea	bc, iy + 0
	ld	a, d
	call	__land
	pop	ix
	ret
	.local	.Lfunc_end2
.Lfunc_end2:
	.size	__ZN2fs10differenceEmm, .Lfunc_end2-__ZN2fs10differenceEmm
                                        ; -- End function
	.globl	__ZN2fs4failEPKc                ; -- Begin function _ZN2fs4failEPKc
	.type	__ZN2fs4failEPKc,@function
__ZN2fs4failEPKc:                       ; @_ZN2fs4failEPKc
; %bb.0:
	call	__frameset0
	ld	l, 0
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB3_2
; %bb.1:
	ld	de, (ix + 6)
	ld	(__ZN2fs7failureE), de
	.local	.LBB3_2
.LBB3_2:
	ld	a, l
	ld	(__ZN2fs7healthyE), a
	pop	ix
	ret
	.local	.Lfunc_end3
.Lfunc_end3:
	.size	__ZN2fs4failEPKc, .Lfunc_end3-__ZN2fs4failEPKc
                                        ; -- End function
	.globl	__ZN2fs5put16EPht               ; -- Begin function _ZN2fs5put16EPht
	.type	__ZN2fs5put16EPht,@function
__ZN2fs5put16EPht:                      ; @_ZN2fs5put16EPht
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	a, l
	ld	(iy), a
	ld	a, h
	ld	(iy + 1), a
	pop	ix
	ret
	.local	.Lfunc_end4
.Lfunc_end4:
	.size	__ZN2fs5put16EPht, .Lfunc_end4-__ZN2fs5put16EPht
                                        ; -- End function
	.globl	__ZN2fs5put32EPhm               ; -- Begin function _ZN2fs5put32EPhm
	.type	__ZN2fs5put32EPhm,@function
__ZN2fs5put32EPhm:                      ; @_ZN2fs5put32EPhm
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	de, (ix + 9)
	ld	h, (ix + 12)
	ld	a, e
	ld	(iy), a
	ld	a, d
	ld	(iy + 1), a
	ld	l, 16
	push	de
	pop	bc
	ld	a, h
	call	__lshru
	ld	a, c
	ld	(iy + 2), a
	ld	l, 24
	push	de
	pop	bc
	ld	a, h
	call	__lshru
	ld	a, c
	ld	(iy + 3), a
	pop	ix
	ret
	.local	.Lfunc_end5
.Lfunc_end5:
	.size	__ZN2fs5put32EPhm, .Lfunc_end5-__ZN2fs5put32EPhm
                                        ; -- End function
	.globl	__ZN2fs5get16EPKh               ; -- Begin function _ZN2fs5get16EPKh
	.type	__ZN2fs5get16EPKh,@function
__ZN2fs5get16EPKh:                      ; @_ZN2fs5get16EPKh
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	e, (iy)
	ld	d, 0
	ld	h, d
	ld	l, (iy + 1)
	ld	h, l
	ld	l, d
	add.sis	hl, de
	pop	ix
	ret
	.local	.Lfunc_end6
.Lfunc_end6:
	.size	__ZN2fs5get16EPKh, .Lfunc_end6-__ZN2fs5get16EPKh
                                        ; -- End function
	.globl	__ZN2fs5get32EPKh               ; -- Begin function _ZN2fs5get32EPKh
	.type	__ZN2fs5get32EPKh,@function
__ZN2fs5get32EPKh:                      ; @_ZN2fs5get32EPKh
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	iy, (ix + 6)
	ld	e, (iy)
	ld	d, 0
	ld	h, d
	ld	l, (iy + 1)
	ld	h, l
	ld	l, d
	add.sis	hl, de
	ld	de, 0
	ld	e, l
	ld	d, h
	ld	(ix - 6), de
	ld	d, 0
	ld	e, (iy + 2)
	ld	h, d
	ld	l, (iy + 3)
	ld	h, l
	ld	l, d
	add.sis	hl, de
	ld	(ix - 3), de
	ld	bc, 0
	ld	c, l
	ld	b, h
	ld	l, 16
	ld	a, d
	call	__lshl
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 6)
	ld	iy, (ix - 3)
	ld	a, iyh
	call	__ladd
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end7
.Lfunc_end7:
	.size	__ZN2fs5get32EPKh, .Lfunc_end7-__ZN2fs5get32EPKh
                                        ; -- End function
	.globl	__ZN2fs4sendEPKhj               ; -- Begin function _ZN2fs4sendEPKhj
	.type	__ZN2fs4sendEPKhj,@function
__ZN2fs4sendEPKhj:                      ; @_ZN2fs4sendEPKhj
; %bb.0:
	ld	hl, -4
	call	__frameset
	ld	hl, (ix + 9)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB8_2
; %bb.1:
	call	__ZN2fs5timerEv
	ld	(ix - 3), hl
	ld	(ix - 4), e                     ; 1-byte Folded Spill
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	_mos_puts
	pop	hl
	pop	hl
	pop	hl
	call	__ZN2fs5timerEv
	ld	bc, (ix - 3)
	ld	a, (ix - 4)                     ; 1-byte Folded Reload
	call	__lsub
	ld	bc, -1
	xor	a, a
	call	__land
	ld	bc, (__ZN2fs6sendMsE)
	ld	iy, __ZN2fs6sendMsE
	lea	iy, iy + 3
	ld	a, (iy)
	call	__ladd
	ld	a, e
	ld	(__ZN2fs6sendMsE), hl
	ld	(__ZN2fs6sendMsE+3), a
	xor	a, a
	ld	hl, (__ZN2fs9wireBytesE)
	ld	iy, __ZN2fs9wireBytesE
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix + 9)
	call	__ladd
	ld	a, e
	ld	(__ZN2fs9wireBytesE), hl
	ld	(__ZN2fs9wireBytesE+3), a
	.local	.LBB8_2
.LBB8_2:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end8
.Lfunc_end8:
	.size	__ZN2fs4sendEPKhj, .Lfunc_end8-__ZN2fs4sendEPKhj
                                        ; -- End function
	.globl	__ZN2fs7commandEth              ; -- Begin function _ZN2fs7commandEth
	.type	__ZN2fs7commandEth,@function
__ZN2fs7commandEth:                     ; @_ZN2fs7commandEth
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	de, (ix + 6)
	ld	a, (ix + 9)
	ld	hl, 6
	ld	(ix - 6), 23
	ld	(ix - 5), h
	ld	(ix - 4), -96
	ld	c, e
	ld	(ix - 3), c
	ld	e, d
	ld	(ix - 2), e
	ld	(ix - 1), a
	push	hl
	pea	ix - 6
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end9
.Lfunc_end9:
	.size	__ZN2fs7commandEth, .Lfunc_end9-__ZN2fs7commandEth
                                        ; -- End function
	.globl	__ZN2fs6updateEttPKhj           ; -- Begin function _ZN2fs6updateEttPKhj
	.type	__ZN2fs6updateEttPKhj,@function
__ZN2fs6updateEttPKhj:                  ; @_ZN2fs6updateEttPKhj
; %bb.0:
	ld	hl, -5
	call	__frameset
	ld	hl, (ix + 6)
	ld	de, 5
	push	de
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	(ix - 5), -62
	ld	hl, (ix + 9)
	ld	a, l
	ld	(ix - 4), a
	ld	a, h
	ld	(ix - 3), a
	ld	hl, (ix + 15)
	ld	a, l
	ld	(ix - 2), a
	ld	a, h
	ld	(ix - 1), a
	ld	hl, 5
	push	hl
	pea	ix - 5
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	ld	hl, (ix + 15)
	push	hl
	ld	hl, (ix + 12)
	push	hl
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end10
.Lfunc_end10:
	.size	__ZN2fs6updateEttPKhj, .Lfunc_end10-__ZN2fs6updateEttPKhj
                                        ; -- End function
	.globl	__ZN2fs5set16Ettt               ; -- Begin function _ZN2fs5set16Ettt
	.type	__ZN2fs5set16Ettt,@function
__ZN2fs5set16Ettt:                      ; @_ZN2fs5set16Ettt
; %bb.0:
	ld	hl, -2
	call	__frameset
	ld	iy, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, (ix + 12)
	ld	hl, 2
	ld	a, c
	ld	(ix - 2), a
	ld	a, b
	ld	(ix - 1), a
	push	hl
	pea	ix - 2
	push	de
	push	iy
	call	__ZN2fs6updateEttPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end11
.Lfunc_end11:
	.size	__ZN2fs5set16Ettt, .Lfunc_end11-__ZN2fs5set16Ettt
                                        ; -- End function
	.globl	__ZN2fs5set32Ettm               ; -- Begin function _ZN2fs5set32Ettm
	.type	__ZN2fs5set32Ettm,@function
__ZN2fs5set32Ettm:                      ; @_ZN2fs5set32Ettm
; %bb.0:
	ld	hl, -4
	call	__frameset
	ld	de, (ix + 12)
	ld	h, (ix + 15)
	ld	iy, 4
	ld	a, e
	ld	(ix - 4), a
	ld	a, d
	ld	(ix - 3), a
	ld	l, 16
	push	de
	pop	bc
	ld	a, h
	call	__lshru
	ld	a, c
	ld	(ix - 2), a
	ld	l, 24
	push	de
	pop	bc
	ld	a, h
	call	__lshru
	ld	a, c
	ld	(ix - 1), a
	push	iy
	pea	ix - 4
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZN2fs6updateEttPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end12
.Lfunc_end12:
	.size	__ZN2fs5set32Ettm, .Lfunc_end12-__ZN2fs5set32Ettm
                                        ; -- End function
	.globl	__ZN2fs11transactionEhPKhjh     ; -- Begin function _ZN2fs11transactionEhPKhjh
	.type	__ZN2fs11transactionEhPKhjh,@function
__ZN2fs11transactionEhPKhjh:            ; @_ZN2fs11transactionEhPKhjh
; %bb.0:
	ld	hl, -42
	call	__frameset
	ld.sis	iy, 0
	ld	a, (__ZN2fs7pendingE)
	ld	l, a
	ld	a, (__ZN2fs7healthyE)
	bit	0, l
	jp	nz, .LBB13_22
; %bb.1:
	or	a, a
	jp	z, .LBB13_22
; %bb.2:
	ld	a, (ix + 6)
	lea	hl, ix - 32
	ld	(ix - 35), hl
	ld	iy, (ix - 35)
	inc	iy
	ld	(ix - 31), 0
	ld	(ix - 38), iy
	ld	hl, (ix - 38)
	inc	hl
	ld	(ix - 38), hl
	ld	bc, 30
	ld	de, (ix - 38)
	lea	hl, iy + 0
	ldir
	ld	(ix - 32), 23
	ld	(ix - 30), -40
	ld	(ix - 27), 1
	ld	(ix - 26), a
	ld	(ix - 23), 1
	ld	de, (ix + 12)
	ld	l, e
	ld	h, d
	ld.sis	bc, 6
	add.sis	hl, bc
	ld	a, l
	ld	(ix - 29), a
	ld	a, h
	ld	(ix - 28), a
	ld	iy, __ZN2fs5tokenE
	ld	hl, (iy)
	inc.sis	hl
	ld	(iy), l
	ld	(iy + 1), h
	ld	a, l
	ld	(ix - 25), a
	ld	a, h
	ld	(ix - 24), a
	push	de
	ld	hl, (ix + 9)
	push	hl
	ld	iy, (ix - 35)
	pea	iy + 11
	call	_memcpy
	pop	hl
	pop	hl
	pop	hl
	ld	h, 0
	ld	a, h
	ld	(_fs_ready), a
	ld	a, 1
	ld	(__ZN2fs7pendingE), a
	ld	hl, (ix + 12)
	ld	de, 11
	add	hl, de
	push	hl
	ld	hl, (ix - 35)
	push	hl
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	call	__ZN2fs3nowEv
	ld	(ix - 35), hl
	ld	(ix - 38), e                    ; 1-byte Folded Spill
	call	__ZN2fs5timerEv
	ld	(ix - 41), hl
	ld	(ix - 42), e                    ; 1-byte Folded Spill
	.local	.LBB13_3
.LBB13_3:                               ; =>This Inner Loop Header: Depth=1
	ld	a, (_fs_ready)
	or	a, a
	jr	nz, .LBB13_8
; %bb.4:                                ;   in Loop: Header=BB13_3 Depth=1
	call	__ZN2fs3nowEv
	ld	bc, (ix - 35)
	ld	a, (ix - 38)                    ; 1-byte Folded Reload
	call	__lsub
	push	hl
	pop	bc
	ld	a, e
	ld	hl, 599
	ld	d, 0
	ld	e, d
	call	__lcmpu
	jr	nc, .LBB13_3
; %bb.5:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld.sis	iy, 0
	jr	z, .LBB13_7
; %bb.6:
	ld	hl, _.str.1
	ld	(__ZN2fs7failureE), hl
	.local	.LBB13_7
.LBB13_7:
	ld	h, 0
	ld	a, h
	ld	(__ZN2fs7healthyE), a
	jp	.LBB13_22
	.local	.LBB13_8
.LBB13_8:
	call	__ZN2fs5timerEv
	ld	bc, (ix - 41)
	ld	a, (ix - 42)                    ; 1-byte Folded Reload
	call	__lsub
	ld	bc, -1
	ld	iyh, 0
	ld	a, iyh
	call	__land
	ld	bc, (__ZN2fs6waitMsE)
	ld	iy, __ZN2fs6waitMsE
	lea	iy, iy + 3
	ld	a, (iy)
	call	__ladd
	ld	b, 0
	ld	a, e
	ld	(__ZN2fs6waitMsE), hl
	ld	(__ZN2fs6waitMsE+3), a
	ld	a, b
	ld	(__ZN2fs7pendingE), a
	ld	a, (_fs_reply)
	cp	a, 86
	jr	nz, .LBB13_18
; %bb.9:
	ld	a, (_fs_reply+1)
	cp	a, 68
	jr	nz, .LBB13_18
; %bb.10:
	ld	a, (_fs_reply+2)
	cp	a, 80
	jr	nz, .LBB13_18
; %bb.11:
	ld	a, (_fs_reply+3)
	cp	a, 76
	jr	nz, .LBB13_18
; %bb.12:
	ld	a, (_fs_reply+4)
	cp	a, 1
	jr	nz, .LBB13_18
; %bb.13:
	ld	a, (_fs_reply+5)
	ld	l, (ix + 15)
	cp	a, l
	jr	nz, .LBB13_18
; %bb.14:
	ld	a, (_fs_reply+6)
	ld	de, 0
	push	de
	pop	hl
	ld	l, a
	push	hl
	pop	iy
	ld	a, (_fs_reply+7)
	ld	e, a
	ld	c, 8
	push	de
	pop	hl
	call	__ishl
	lea	bc, iy + 0
	add	hl, bc
	ld	iy, __ZN2fs5tokenE
	ld	bc, (iy)
	ld	e, c
	ld	d, b
	ld	b, 0
	or	a, a
	sbc	hl, de
	jr	nz, .LBB13_18
; %bb.15:
	ld	iy, (__ZN2fs15transcriptBytesE)
	lea	hl, iy + 0
	ld	de, -99991
	add	hl, de
	ld	de, -100001
	or	a, a
	sbc	hl, de
	jr	nc, .LBB13_23
; %bb.16:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB13_21
; %bb.17:
	ld	hl, _.str.3
	jr	.LBB13_20
	.local	.LBB13_18
.LBB13_18:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB13_21
; %bb.19:
	ld	hl, _.str.2
	.local	.LBB13_20
.LBB13_20:
	ld	(__ZN2fs7failureE), hl
	.local	.LBB13_21
.LBB13_21:
	ld	a, b
	ld	(__ZN2fs7healthyE), a
	ld.sis	iy, 0
	.local	.LBB13_22
.LBB13_22:
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB13_23
.LBB13_23:
	ld	(ix - 38), iy
	lea	de, iy + 0
	ld	hl, __ZN2fs10transcriptE
	add	hl, de
	ld	(ix - 35), hl
	ld	de, 0
	.local	.LBB13_24
.LBB13_24:                              ; =>This Inner Loop Header: Depth=1
	push	de
	pop	iy
	ex	de, hl
	ld	de, 10
	or	a, a
	sbc	hl, de
	jr	z, .LBB13_26
; %bb.25:                               ;   in Loop: Header=BB13_24 Depth=1
	ld	hl, _fs_reply
	lea	de, iy + 0
	add	hl, de
	ld	a, (hl)
	ld	hl, (ix - 35)
	add	hl, de
	ld	(hl), a
	inc	de
	jr	.LBB13_24
	.local	.LBB13_26
.LBB13_26:
	ld	hl, (ix - 38)
	lea	de, iy + 0
	add	hl, de
	ld	(__ZN2fs15transcriptBytesE), hl
	ld	a, (_fs_reply+8)
	ld	c, a
	ld	a, (_fs_reply+9)
	ld	l, a
	ld	h, b
	ex	de, hl
	ld	iyh, e
	ex	de, hl
	ld	iyl, b
	add.sis	iy, bc
	jr	.LBB13_22
	.local	.Lfunc_end13
.Lfunc_end13:
	.size	__ZN2fs11transactionEhPKhjh, .Lfunc_end13-__ZN2fs11transactionEhPKhjh
                                        ; -- End function
	.globl	__ZN2fs6read16Etm               ; -- Begin function _ZN2fs6read16Etm
	.type	__ZN2fs6read16Etm,@function
__ZN2fs6read16Etm:                      ; @_ZN2fs6read16Etm
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	bc, (ix + 6)
	ld	de, (ix + 9)
	ld	h, (ix + 12)
	ld	iy, 6
	ld	a, c
	ld	(ix - 6), a
	ld	a, b
	ld	(ix - 5), a
	ld	a, e
	ld	(ix - 4), a
	ld	a, d
	ld	(ix - 3), a
	ld	l, 16
	push	de
	pop	bc
	ld	a, h
	call	__lshru
	ld	a, c
	ld	(ix - 2), a
	ld	l, 24
	push	de
	pop	bc
	ld	a, h
	call	__lshru
	ld	a, c
	ld	(ix - 1), a
	ld	hl, 4
	push	hl
	push	iy
	pea	ix - 6
	inc	hl
	push	hl
	call	__ZN2fs11transactionEhPKhjh
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end14
.Lfunc_end14:
	.size	__ZN2fs6read16Etm, .Lfunc_end14-__ZN2fs6read16Etm
                                        ; -- End function
	.globl	__ZN2fs6read32Etm               ; -- Begin function _ZN2fs6read32Etm
	.type	__ZN2fs6read32Etm,@function
__ZN2fs6read32Etm:                      ; @_ZN2fs6read32Etm
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	de, (ix + 6)
	ld	bc, (ix + 9)
	ld	l, (ix + 12)
	push	hl
	push	bc
	push	de
	call	__ZN2fs6read16Etm
	pop	de
	pop	de
	pop	de
	ld	de, 0
	ld	e, l
	ld	d, h
	ld	(ix - 3), de
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	ld	bc, 2
	xor	a, a
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZN2fs6read16Etm
	pop	de
	pop	de
	pop	de
	ld	bc, 0
	ld	c, l
	ld	b, h
	ld	l, 16
	xor	a, a
	call	__lshl
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 3)
	xor	a, a
	call	__ladd
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end15
.Lfunc_end15:
	.size	__ZN2fs6read32Etm, .Lfunc_end15-__ZN2fs6read32Etm
                                        ; -- End function
	.globl	__ZN2fs6expectEttt              ; -- Begin function _ZN2fs6expectEttt
	.type	__ZN2fs6expectEttt,@function
__ZN2fs6expectEttt:                     ; @_ZN2fs6expectEttt
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, 0
	push	bc
	ld	c, e
	ld	b, d
	push	bc
	push	hl
	call	__ZN2fs6read16Etm
	pop	de
	pop	de
	pop	de
	ld	de, (ix + 12)
	or	a, a
	sbc.sis	hl, de
	jr	z, .LBB16_4
; %bb.1:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB16_3
; %bb.2:
	ld	hl, _.str.4
	ld	(__ZN2fs7failureE), hl
	.local	.LBB16_3
.LBB16_3:
	xor	a, a
	ld	(__ZN2fs7healthyE), a
	.local	.LBB16_4
.LBB16_4:
	pop	ix
	ret
	.local	.Lfunc_end16
.Lfunc_end16:
	.size	__ZN2fs6expectEttt, .Lfunc_end16-__ZN2fs6expectEttt
                                        ; -- End function
	.globl	__ZN2fs6invokeEt                ; -- Begin function _ZN2fs6invokeEt
	.type	__ZN2fs6invokeEt,@function
__ZN2fs6invokeEt:                       ; @_ZN2fs6invokeEt
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB17_6
; %bb.1:
	ld	hl, (ix + 6)
	ld	de, 1
	push	hl
	ld	hl, 28
	push	hl
	push	de
	call	__ZN2fs5set16Ettt
	pop	hl
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 44
	push	hl
	ld	hl, -15232
	push	hl
	call	__ZN2fs5set16Ettt
	pop	hl
	pop	hl
	pop	hl
	ld	hl, __ZN2fs6handleE
	ld	hl, (hl)
	ld	a, l
	ld	(ix - 6), a
	ld	a, h
	ld	(ix - 5), a
	ld	hl, (ix + 6)
	ld	a, l
	ld	(ix - 4), a
	ld	a, h
	ld	(ix - 3), a
	ld	(ix - 2), 9
	ld	(ix - 1), 0
	ld	hl, 3
	push	hl
	ld	hl, 6
	push	hl
	pea	ix - 6
	ld	hl, 2
	push	hl
	call	__ZN2fs11transactionEhPKhjh
	pop	de
	pop	de
	pop	de
	pop	de
	ld	d, 0
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	z, .LBB17_5
; %bb.2:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB17_4
; %bb.3:
	ld	hl, _.str.5
	ld	(__ZN2fs7failureE), hl
	.local	.LBB17_4
.LBB17_4:
	ld	a, d
	ld	(__ZN2fs7healthyE), a
	.local	.LBB17_5
.LBB17_5:
	ld	hl, (__ZN2fs10generationE)
	ld	iy, __ZN2fs10generationE
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	ld	a, d
	call	__ladd
	ld	a, e
	ld	(__ZN2fs10generationE), hl
	ld	(__ZN2fs10generationE+3), a
	.local	.LBB17_6
.LBB17_6:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end17
.Lfunc_end17:
	.size	__ZN2fs6invokeEt, .Lfunc_end17-__ZN2fs6invokeEt
                                        ; -- End function
	.globl	__ZN2fs4fileEPKc                ; -- Begin function _ZN2fs4fileEPKc
	.type	__ZN2fs4fileEPKc,@function
__ZN2fs4fileEPKc:                       ; @_ZN2fs4fileEPKc
; %bb.0:
	ld	hl, -1036
	call	__frameset
	ld	hl, (ix + 6)
	ld	de, _.str.6
	push	de
	push	hl
	call	_fopen
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB18_4
; %bb.1:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB18_3
; %bb.2:
	ld	hl, _.str.7
	ld	(__ZN2fs7failureE), hl
	.local	.LBB18_3
.LBB18_3:
	xor	a, a
	ld	(__ZN2fs7healthyE), a
	jp	.LBB18_15
	.local	.LBB18_4
.LBB18_4:
	ld	iy, 1
	ld	bc, 1024
	ld	(ix - 3), bc
	push	ix
	ld	bc, -1030
	add	ix, bc
	lea	de, ix + 0
	pop	ix
	push	ix
	ld	bc, -1036
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	push	ix
	ld	de, -1033
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	bc, (ix - 3)
	.local	.LBB18_5
.LBB18_5:                               ; =>This Inner Loop Header: Depth=1
	push	hl
	push	bc
	push	iy
	ld	bc, -1036
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	push	de
	call	_fread
	pop	de
	pop	de
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB18_7
; %bb.6:                                ;   in Loop: Header=BB18_5 Depth=1
	push	hl
	ld	bc, -1036
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	ld	de, -1033
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	iy, 1
	ld	bc, 1024
	jr	.LBB18_5
	.local	.LBB18_7
.LBB18_7:
	ld	bc, -1033
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_ferror
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB18_9
; %bb.8:
	ld	a, 0
	jr	.LBB18_10
	.local	.LBB18_9
.LBB18_9:
	ld	a, -1
	.local	.LBB18_10
.LBB18_10:
	ld	bc, -1036
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a
	ld	bc, -1033
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	ld	bc, -1036
	lea	hl, ix + 0
	add	hl, bc
	ld	e, (hl)                         ; 1-byte Folded Reload
	bit	0, e
	jr	nz, .LBB18_14
; %bb.11:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB18_13
; %bb.12:
	ld	hl, _.str.8
	ld	(__ZN2fs7failureE), hl
	.local	.LBB18_13
.LBB18_13:
	xor	a, a
	ld	(__ZN2fs7healthyE), a
	.local	.LBB18_14
.LBB18_14:
	ld	a, e
	.local	.LBB18_15
.LBB18_15:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end18
.Lfunc_end18:
	.size	__ZN2fs4fileEPKc, .Lfunc_end18-__ZN2fs4fileEPKc
                                        ; -- End function
	.globl	__ZN2fs6configEv                ; -- Begin function _ZN2fs6configEv
	.type	__ZN2fs6configEv,@function
__ZN2fs6configEv:                       ; @_ZN2fs6configEv
; %bb.0:
	ld	hl, -25
	call	__frameset
	ld	hl, _.str.9
	ld	de, _.str.6
	push	de
	push	hl
	call	_fopen
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB19_3
; %bb.1:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	a, 0
	jp	z, .LBB19_16
; %bb.2:
	ld	hl, _.str.10
	jp	.LBB19_15
	.local	.LBB19_3
.LBB19_3:
	ld	iy, 1
	ld	de, 16
	lea	bc, ix - 16
	ld	(ix - 19), hl
	push	hl
	push	de
	push	iy
	ld	(ix - 22), bc
	push	bc
	call	_fread
	pop	de
	pop	de
	pop	de
	pop	de
	ld	de, 16
	or	a, a
	sbc	hl, de
	jp	nz, .LBB19_12
; %bb.4:
	ld	hl, (ix - 19)
	push	hl
	call	_fgetc
	ld	(ix - 25), hl
	pop	hl
	ld	hl, (ix - 19)
	push	hl
	call	_fclose
	pop	hl
	ld	de, -1
	ld	hl, (ix - 25)
	or	a, a
	sbc	hl, de
	jp	nz, .LBB19_13
; %bb.5:
	ld	hl, _.str.11
	ld	de, 4
	push	de
	push	hl
	ld	hl, (ix - 22)
	push	hl
	call	_memcmp
	pop	de
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB19_13
; %bb.6:
	ld	c, (ix - 12)
	ld	b, 0
	ld	h, b
	ld	l, (ix - 11)
	ld	h, l
	ld	l, b
	add.sis	hl, bc
	ld.sis	de, 1
	or	a, a
	sbc.sis	hl, de
	jr	nz, .LBB19_13
; %bb.7:
	ld	e, (ix - 10)
	ld	d, b
	ld	h, b
	ld	l, (ix - 9)
	ex	de, hl
	ld	iyh, e
	ex	de, hl
	ld	iyl, b
	add.sis	iy, de
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld.sis	de, -901
	add.sis	hl, de
	inc.sis	de
	or	a, a
	sbc.sis	hl, de
	jr	c, .LBB19_13
; %bb.8:
	ld	e, (ix - 4)
	ld	d, b
	ld	h, b
	ld	l, (ix - 3)
	ld	h, l
	ld	l, b
	add.sis	hl, de
	ld.sis	de, 2
	ld	(ix - 19), hl
	or	a, a
	sbc.sis	hl, de
	jr	nc, .LBB19_13
; %bb.9:
	ld	c, (ix - 2)
	ld	h, b
	ld	l, (ix - 1)
	ld	h, l
	ld	l, b
	add.sis	hl, bc
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB19_13
; %bb.10:
	ld	hl, (ix - 19)
	ld.sis	de, 1
	or	a, a
	sbc.sis	hl, de
	jr	z, .LBB19_18
; %bb.11:
	ld	a, 0
	jr	.LBB19_19
	.local	.LBB19_12
.LBB19_12:
	ld	hl, (ix - 19)
	push	hl
	call	_fclose
	pop	hl
	.local	.LBB19_13
.LBB19_13:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	a, 0
	jr	z, .LBB19_16
; %bb.14:
	ld	hl, _.str.12
	.local	.LBB19_15
.LBB19_15:
	ld	(__ZN2fs7failureE), hl
	.local	.LBB19_16
.LBB19_16:
	ld	(__ZN2fs7healthyE), a
	.local	.LBB19_17
.LBB19_17:
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB19_18
.LBB19_18:
	ld	a, 1
	.local	.LBB19_19
.LBB19_19:
	ld	(__ZN2fs17compactConfiguredE), a
	or	a, a
	sbc	hl, hl
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld	(__ZN2fs10frameCountE), hl
	ld	iy, (ix - 22)
	pea	iy + 8
	call	__ZN2fs5get32EPKh
	pop	bc
	ld	(__ZN2fs11moduleBytesE), hl
	ld	a, e
	ld	(__ZN2fs11moduleBytesE+3), a
	ld	bc, -65537
	ld	a, b
	call	__ladd
	ld	bc, -65473
	call	__lcmpu
	jr	nc, .LBB19_22
; %bb.20:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	a, 0
	jr	z, .LBB19_16
; %bb.21:
	ld	hl, _.str.13
	jr	.LBB19_15
	.local	.LBB19_22
.LBB19_22:
	ld	a, 1
	jr	.LBB19_17
	.local	.Lfunc_end19
.Lfunc_end19:
	.size	__ZN2fs6configEv, .Lfunc_end19-__ZN2fs6configEv
                                        ; -- End function
	.globl	__ZN2fs4tickEv                  ; -- Begin function _ZN2fs4tickEv
	.type	__ZN2fs4tickEv,@function
__ZN2fs4tickEv:                         ; @_ZN2fs4tickEv
; %bb.0:
	ld	hl, 1
	push	hl
	ld	hl, 13
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	hl, (__ZN2fs5worldE)
	ld	iy, __ZN2fs5worldE
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN2fs5worldE), hl
	ld	(__ZN2fs5worldE+3), a
	ld	hl, (__ZN2fs10generationE)
	ld	iy, __ZN2fs10generationE
	lea	iy, iy + 3
	ld	e, (iy)
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN2fs10generationE), hl
	ld	(__ZN2fs10generationE+3), a
	ret
	.local	.Lfunc_end20
.Lfunc_end20:
	.size	__ZN2fs4tickEv, .Lfunc_end20-__ZN2fs4tickEv
                                        ; -- End function
	.globl	__ZN2fs6renderEv                ; -- Begin function _ZN2fs6renderEv
	.type	__ZN2fs6renderEv,@function
__ZN2fs6renderEv:                       ; @_ZN2fs6renderEv
; %bb.0:
	ld	hl, 15
	push	hl
	call	__ZN2fs6invokeEt
	pop	hl
	ld	hl, (__ZN2fs7requestE)
	ld	iy, __ZN2fs7requestE
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	push	bc
	pop	iy
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN2fs7requestE), hl
	ld	(__ZN2fs7requestE+3), a
	ld	a, (__ZN2fs12reducedReadsE)
	bit	0, a
	jr	nz, .LBB21_2
; %bb.1:
	push	iy
	ld	hl, 44
	push	hl
	ld	hl, -15232
	push	hl
	call	__ZN2fs6expectEttt
	pop	hl
	pop	hl
	pop	hl
	ld	hl, __ZN2fs7requestE
	ld	hl, (hl)
	push	hl
	ld	hl, 16
	push	hl
	ld	hl, -15232
	push	hl
	call	__ZN2fs6expectEttt
	pop	hl
	pop	hl
	pop	hl
	ld	hl, __ZN2fs5worldE
	ld	hl, (hl)
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, -15232
	push	hl
	call	__ZN2fs6expectEttt
	pop	hl
	pop	hl
	pop	hl
	ld	hl, __ZN2fs10generationE
	ld	hl, (hl)
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, 1
	push	hl
	call	__ZN2fs6expectEttt
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB21_2
.LBB21_2:
	ret
	.local	.Lfunc_end21
.Lfunc_end21:
	.size	__ZN2fs6renderEv, .Lfunc_end21-__ZN2fs6renderEv
                                        ; -- End function
	.globl	__ZN2fs5fenceEv                 ; -- Begin function _ZN2fs5fenceEv
	.type	__ZN2fs5fenceEv,@function
__ZN2fs5fenceEv:                        ; @_ZN2fs5fenceEv
; %bb.0:
	ld	hl, __ZN2fs10generationE
	ld	hl, (hl)
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, 1
	push	hl
	call	__ZN2fs6expectEttt
	pop	hl
	pop	hl
	pop	hl
	ret
	.local	.Lfunc_end22
.Lfunc_end22:
	.size	__ZN2fs5fenceEv, .Lfunc_end22-__ZN2fs5fenceEv
                                        ; -- End function
	.globl	__ZN2fs5setupEv                 ; -- Begin function _ZN2fs5setupEv
	.type	__ZN2fs5setupEv,@function
__ZN2fs5setupEv:                        ; @_ZN2fs5setupEv
; %bb.0:
	ld	hl, -1105
	call	__frameset
	ld	hl, _fs_callback
	ld	de, 0
	push	de
	push	hl
	call	_mos_setkbvector
	pop	hl
	pop	hl
	ld	a, 1
	ld	(__ZN2fs9installedE), a
	call	__ZN2fs6configEv
	bit	0, a
	jp	z, .LBB23_10
; %bb.1:
	ld	hl, _.str.14
	push	hl
	call	__ZN2fs4fileEPKc
	pop	hl
	bit	0, a
	jp	z, .LBB23_10
; %bb.2:
	ld	iy, 2
	ld	(ix - 14), -127
	ld	(ix - 13), -60
	ld	de, (__ZN2fs11moduleBytesE)
	ld	a, (__ZN2fs11moduleBytesE+3)
	ld	h, a
	ld	a, e
	ld	(ix - 12), a
	ld	a, d
	ld	(ix - 11), a
	ld	l, 16
	push	de
	pop	bc
	ld	a, h
	call	__lshru
	ld	a, c
	ld	(ix - 10), a
	ld	l, 24
	push	de
	pop	bc
	ld	a, h
	call	__lshru
	ld	a, c
	ld	(ix - 9), a
	ld	(ix - 8), 0
	ld	(ix - 7), 0
	push	iy
	ld	hl, 8
	push	hl
	pea	ix - 14
	ld	hl, 1
	push	hl
	call	__ZN2fs11transactionEhPKhjh
	pop	de
	pop	de
	pop	de
	pop	de
	ld	iy, __ZN2fs6handleE
	ld	(iy), l
	ld	(iy + 1), h
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB23_5
; %bb.3:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB23_9
; %bb.4:
	ld	hl, _.str.15
	jr	.LBB23_8
	.local	.LBB23_5
.LBB23_5:
	ld	hl, 136
	push	hl
	call	_vdp_mode
	pop	de
	ld	de, 0
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB23_12
; %bb.6:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB23_9
; %bb.7:
	ld	hl, _.str.16
	.local	.LBB23_8
.LBB23_8:
	ld	(__ZN2fs7failureE), hl
	.local	.LBB23_9
.LBB23_9:
	xor	a, a
	ld	(__ZN2fs7healthyE), a
	.local	.LBB23_10
.LBB23_10:
	xor	a, a
	.local	.LBB23_11
.LBB23_11:
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB23_12
.LBB23_12:
	call	_vdp_set_pixel_coordinates
	call	_vdp_reset_sprites
	or	a, a
	sbc	hl, hl
	push	hl
	call	_vdp_cursor_enable
	pop	hl
	ld	hl, _.str.17
	push	hl
	call	__ZN2fs4fileEPKc
	pop	hl
	bit	0, a
	jr	z, .LBB23_10
; %bb.13:
	ld	hl, _.str.18
	push	hl
	call	__ZN2fs4fileEPKc
	pop	hl
	bit	0, a
	jr	z, .LBB23_10
; %bb.14:
	ld	hl, _.str.19
	push	hl
	call	__ZN2fs4fileEPKc
	pop	hl
	bit	0, a
	jr	z, .LBB23_10
; %bb.15:
	ld	hl, _.str.20
	push	hl
	call	__ZN2fs4fileEPKc
	pop	hl
	bit	0, a
	jr	z, .LBB23_10
; %bb.16:
	ld	hl, _.str.21
	push	hl
	call	__ZN2fs4fileEPKc
	pop	hl
	bit	0, a
	ld	a, 0
	jr	z, .LBB23_11
; %bb.17:
	ld	bc, -1090
	lea	iy, ix + 0
	add	iy, bc
	lea	hl, ix - 62
	push	ix
	ld	bc, -1099
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, -1093
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	lea	hl, iy + 2
	ld	bc, -1096
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	de, 34
	or	a, a
	sbc	hl, hl
	.local	.LBB23_18
.LBB23_18:                              ; =>This Inner Loop Header: Depth=1
	push	hl
	pop	bc
	or	a, a
	sbc	hl, de
	ld	iy, __ZN2fs6handleE
	jr	z, .LBB23_20
; %bb.19:                               ;   in Loop: Header=BB23_18 Depth=1
	push	bc
	pop	de
	ld	bc, -1102
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ld	hl, __ZN2fsL8WrappersE
	add	hl, de
	ld	hl, (hl)
	ld	de, (iy)
	push	de
	ld	de, 37
	push	de
	push	hl
	call	__ZN2fs5set16Ettt
	ld	bc, -1102
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	pop	de
	pop	de
	pop	de
	ld	de, 2
	add	hl, de
	ld	de, 34
	jr	.LBB23_18
	.local	.LBB23_20
.LBB23_20:
	ld	(ix - 62), 0
	ld	bc, -1099
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	pop	de
	inc	de
	ld	bc, 47
	ldir
	ld	hl, 2
	push	hl
	ld	hl, -15232
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, -15232
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld.sis	hl, 48
	ld	(ix - 64), l
	ld	(ix - 63), h
	ld	hl, 2
	push	hl
	pea	ix - 64
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	ld	hl, 48
	push	hl
	ld	bc, -1099
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	ld	bc, -1093
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	(iy + 2), 0
	ld	bc, -1096
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	push	hl
	pop	de
	inc	de
	ld	bc, 1023
	ldir
	ld	de, 0
	.local	.LBB23_21
.LBB23_21:                              ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB23_23 Depth 2
	ld	iy, 1
	push	de
	pop	hl
	ld	bc, 3
	or	a, a
	sbc	hl, bc
	jp	z, .LBB23_28
; %bb.22:                               ;   in Loop: Header=BB23_21 Depth=1
	ld	bc, -1099
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ex	de, hl
	ld	c, 1
	call	__ishl
	push	hl
	pop	de
	ld	(ix - 3), bc
	ld	bc, -1102
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), de
	ld	hl, __ZN2fsL7OutputsE
	add	hl, de
	ld	de, (hl)
	ld	bc, -1105
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ld	hl, 2
	push	hl
	push	de
	ld	bc, (ix - 3)
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	bc, -1105
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	hl, ___const._ZN2fs5setupEv.capacities
	ld	bc, -1102
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	add	hl, de
	ld	hl, (hl)
	push	ix
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, l
	push	ix
	ld	bc, -1093
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 0), a
	ld	a, h
	ld	(iy + 1), a
	ld	hl, 2
	push	hl
	push	iy
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	ld	bc, 0
	ld	de, -1102
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	c, l
	ld	b, h
	.local	.LBB23_23
.LBB23_23:                              ;   Parent Loop BB23_21 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	push	bc
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB23_27
; %bb.24:                               ;   in Loop: Header=BB23_23 Depth=2
	push	bc
	pop	hl
	ld	de, 1024
	or	a, a
	sbc	hl, de
	ld	de, -1102
	lea	hl, ix + 0
	push	af
	add	hl, de
	pop	af
	ld	(hl), bc
	jr	c, .LBB23_26
; %bb.25:                               ;   in Loop: Header=BB23_23 Depth=2
	ld	bc, 1024
	.local	.LBB23_26
.LBB23_26:                              ;   in Loop: Header=BB23_23 Depth=2
	ld	de, -1105
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	push	bc
	ld	bc, -1096
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	push	hl
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	ld	bc, -1102
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -1105
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	or	a, a
	sbc	hl, de
	push	hl
	pop	bc
	jr	.LBB23_23
	.local	.LBB23_27
.LBB23_27:                              ;   in Loop: Header=BB23_21 Depth=1
	ld	bc, -1099
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	inc	de
	jp	.LBB23_21
	.local	.LBB23_28
.LBB23_28:
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 7
	push	hl
	inc	hl
	push	hl
	push	iy
	call	__ZN2fs5set32Ettm
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 13
	push	hl
	call	__ZN2fs6invokeEt
	pop	hl
	ld	a, (__ZN2fs7healthyE)
	jp	.LBB23_11
	.local	.Lfunc_end23
.Lfunc_end23:
	.size	__ZN2fs5setupEv, .Lfunc_end23-__ZN2fs5setupEv
                                        ; -- End function
	.globl	__ZN2fs10startTimerEv           ; -- Begin function _ZN2fs10startTimerEv
	.type	__ZN2fs10startTimerEv,@function
__ZN2fs10startTimerEv:                  ; @_ZN2fs10startTimerEv
; %bb.0:
	call	_timing_claim
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB24_4
; %bb.1:
	ld	e, 0
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB24_3
; %bb.2:
	ld	hl, _.str.22
	ld	(__ZN2fs7failureE), hl
	.local	.LBB24_3
.LBB24_3:
	ld	a, e
	ld	(__ZN2fs7healthyE), a
	ret
	.local	.LBB24_4
.LBB24_4:
	ld	hl, _timing_irq
	push	hl
	ld	hl, 12
	push	hl
	call	_mos_setintvector
	pop	de
	pop	de
	ld	(__ZN2fs13previousTimerE), hl
	ld	a, 1
	ld	(__ZN2fs3prtE), a
	call	_timing_start
	ret
	.local	.Lfunc_end24
.Lfunc_end24:
	.size	__ZN2fs10startTimerEv, .Lfunc_end24-__ZN2fs10startTimerEv
                                        ; -- End function
	.globl	__ZN2fs9stopTimerEv             ; -- Begin function _ZN2fs9stopTimerEv
	.type	__ZN2fs9stopTimerEv,@function
__ZN2fs9stopTimerEv:                    ; @_ZN2fs9stopTimerEv
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	a, (__ZN2fs3prtE)
	bit	0, a
	jr	z, .LBB25_8
; %bb.1:
	call	_timing_stop
	ld	hl, (__ZN2fs13previousTimerE)
	push	hl
	ld	hl, 12
	push	hl
	call	_mos_setintvector
	ld	(ix - 3), hl
	pop	hl
	pop	hl
	call	_timing_release
	ld	e, 0
	ld	a, e
	ld	(__ZN2fs3prtE), a
	ld	hl, (ix - 3)
	ld	bc, _timing_irq
	or	a, a
	sbc	hl, bc
	jr	z, .LBB25_3
; %bb.2:
	ld	l, 0
	jr	.LBB25_4
	.local	.LBB25_3
.LBB25_3:
	ld	l, -1
	.local	.LBB25_4
.LBB25_4:
	ld	a, l
	and	a, 1
	ld	(__ZN2fs13timerRestoredE), a
	bit	0, l
	jr	nz, .LBB25_8
; %bb.5:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB25_7
; %bb.6:
	ld	hl, _.str.23
	ld	(__ZN2fs7failureE), hl
	.local	.LBB25_7
.LBB25_7:
	ld	a, e
	ld	(__ZN2fs7healthyE), a
	.local	.LBB25_8
.LBB25_8:
	pop	hl
	pop	ix
	ret
	.local	.Lfunc_end25
.Lfunc_end25:
	.size	__ZN2fs9stopTimerEv, .Lfunc_end25-__ZN2fs9stopTimerEv
                                        ; -- End function
	.globl	__ZN2fs4stopEv                  ; -- Begin function _ZN2fs4stopEv
	.type	__ZN2fs4stopEv,@function
__ZN2fs4stopEv:                         ; @_ZN2fs4stopEv
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	a, (__ZN2fs7pendingE)
	ld	e, a
	bit	0, e
	jp	nz, .LBB26_8
; %bb.1:
	ld	hl, __ZN2fs6handleE
	ld	hl, (hl)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	z, .LBB26_8
; %bb.2:
	ld	l, 1
	ld	a, (__ZN2fs7healthyE)
	ld	(ix - 3), a                     ; 1-byte Folded Spill
	ld	a, l
	ld	(__ZN2fs7healthyE), a
	ld	hl, 16
	push	hl
	call	__ZN2fs6invokeEt
	ld	c, 0
	pop	hl
	ld	hl, __ZN2fs6handleE
	ld	hl, (hl)
	ld	a, l
	ld	(ix - 2), a
	ld	a, h
	ld	(ix - 1), a
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	a, c
	jr	z, .LBB26_7
; %bb.3:
	ld	hl, 2
	ld	de, 3
	push	de
	push	hl
	pea	ix - 2
	push	de
	call	__ZN2fs11transactionEhPKhjh
	pop	de
	pop	de
	pop	de
	pop	de
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB26_5
; %bb.4:
	ld.sis	de, 0
	ld	a, 1
	ld	(__ZN2fs8unloadedE), a
	ld	hl, __ZN2fs6handleE
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ld	a, (__ZN2fs7healthyE)
	and	a, (ix - 3)                     ; 1-byte Folded Reload
	and	a, 1
	jr	.LBB26_7
	.local	.LBB26_5
.LBB26_5:
	ld	a, (__ZN2fs7healthyE)
	or	a, a
	ld	c, 0
	ld	a, c
	jr	z, .LBB26_7
; %bb.6:
	ld	hl, _.str.24
	ld	(__ZN2fs7failureE), hl
	ld	a, c
	.local	.LBB26_7
.LBB26_7:
	ld	(__ZN2fs7healthyE), a
	ld	a, (__ZN2fs7pendingE)
	ld	e, a
	.local	.LBB26_8
.LBB26_8:
	ld	a, (__ZN2fs9installedE)
	bit	0, a
	jr	z, .LBB26_11
; %bb.9:
	ld	a, e
	or	a, a
	jr	nz, .LBB26_11
; %bb.10:
	ld	hl, 0
	ld	de, 0
	push	de
	push	hl
	call	_mos_setkbvector
	pop	hl
	pop	hl
	xor	a, a
	ld	(__ZN2fs9installedE), a
	.local	.LBB26_11
.LBB26_11:
	pop	hl
	pop	ix
	jp	__ZN2fs9stopTimerEv
	.local	.Lfunc_end26
.Lfunc_end26:
	.size	__ZN2fs4stopEv, .Lfunc_end26-__ZN2fs4stopEv
                                        ; -- End function
	.globl	__ZN2fs4saveEPKcPKvj            ; -- Begin function _ZN2fs4saveEPKcPKvj
	.type	__ZN2fs4saveEPKcPKvj,@function
__ZN2fs4saveEPKcPKvj:                   ; @_ZN2fs4saveEPKcPKvj
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	hl, (ix + 6)
	ld	de, _.str.25
	push	de
	push	hl
	call	_fopen
	xor	a, a
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB27_6
; %bb.1:
	ld	iy, (ix + 9)
	ld	bc, (ix + 12)
	ld	de, 1
	push	hl
	push	bc
	push	de
	push	iy
	ld	(ix - 6), hl
	call	_fwrite
	ld	(ix - 3), hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (ix - 6)
	push	hl
	call	_fclose
	push	hl
	pop	de
	pop	hl
	ld	hl, (ix - 3)
	ld	bc, (ix + 12)
	or	a, a
	sbc	hl, bc
	ld	c, -1
	ld	b, 0
	ld	a, c
	jr	z, .LBB27_3
; %bb.2:
	ld	a, b
	.local	.LBB27_3
.LBB27_3:
	ex	de, hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB27_5
; %bb.4:
	ld	c, b
	.local	.LBB27_5
.LBB27_5:
	and	a, c
	.local	.LBB27_6
.LBB27_6:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end27
.Lfunc_end27:
	.size	__ZN2fs4saveEPKcPKvj, .Lfunc_end27-__ZN2fs4saveEPKcPKvj
                                        ; -- End function
	.globl	_vdp_scroll_screen_extent       ; -- Begin function vdp_scroll_screen_extent
	.type	_vdp_scroll_screen_extent,@function
_vdp_scroll_screen_extent:              ; @vdp_scroll_screen_extent
; %bb.0:
	ld	hl, -5
	call	__frameset
	ld	a, (ix + 6)
	ld	l, (ix + 9)
	ld	e, (ix + 12)
	ld	bc, 5
	ld	(ix - 5), 23
	ld	(ix - 4), 7
	ld	(ix - 3), a
	ld	(ix - 2), l
	ld	(ix - 1), e
	push	bc
	pea	ix - 5
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end28
.Lfunc_end28:
	.size	_vdp_scroll_screen_extent, .Lfunc_end28-_vdp_scroll_screen_extent
                                        ; -- End function
	.globl	_vdp_select_bitmap              ; -- Begin function vdp_select_bitmap
	.type	_vdp_select_bitmap,@function
_vdp_select_bitmap:                     ; @vdp_select_bitmap
; %bb.0:
	ld	hl, -4
	call	__frameset
	ld	a, (ix + 6)
	ld	hl, 4
	ld	(ix - 4), 23
	ld	(ix - 3), 27
	ld	(ix - 2), h
	ld	(ix - 1), a
	push	hl
	pea	ix - 4
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end29
.Lfunc_end29:
	.size	_vdp_select_bitmap, .Lfunc_end29-_vdp_select_bitmap
                                        ; -- End function
	.globl	_vdp_draw_bitmap                ; -- Begin function vdp_draw_bitmap
	.type	_vdp_draw_bitmap,@function
_vdp_draw_bitmap:                       ; @vdp_draw_bitmap
; %bb.0:
	ld	hl, -7
	call	__frameset
	ld	de, (ix + 6)
	ld	bc, (ix + 9)
	ld	iy, ___const.vdp_draw_bitmap.b
	lea	hl, ix - 7
	ld	a, (iy)
	ld	(hl), a
	ld	a, (___const.vdp_draw_bitmap.b+1)
	ld	(ix - 6), a
	ld	a, (___const.vdp_draw_bitmap.b+2)
	ld	(ix - 5), a
	ld	a, e
	ld	(ix - 4), a
	ld	a, d
	ld	(ix - 3), a
	ld	a, c
	ld	(ix - 2), a
	ld	a, b
	ld	(ix - 1), a
	ld	de, 7
	push	de
	push	hl
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end30
.Lfunc_end30:
	.size	_vdp_draw_bitmap, .Lfunc_end30-_vdp_draw_bitmap
                                        ; -- End function
	.globl	_vdp_adv_use_affine_matrix      ; -- Begin function vdp_adv_use_affine_matrix
	.type	_vdp_adv_use_affine_matrix,@function
_vdp_adv_use_affine_matrix:             ; @vdp_adv_use_affine_matrix
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	a, (ix + 6)
	ld	de, (ix + 9)
	ld	hl, 6
	ld	(ix - 6), 23
	ld	(ix - 5), h
	ld	(ix - 4), -106
	ld	(ix - 3), a
	ld	a, e
	ld	(ix - 2), a
	ld	a, d
	ld	(ix - 1), a
	push	hl
	pea	ix - 6
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end31
.Lfunc_end31:
	.size	_vdp_adv_use_affine_matrix, .Lfunc_end31-_vdp_adv_use_affine_matrix
                                        ; -- End function
	.globl	_vdp_set_text_colour            ; -- Begin function vdp_set_text_colour
	.type	_vdp_set_text_colour,@function
_vdp_set_text_colour:                   ; @vdp_set_text_colour
; %bb.0:
	ld	hl, -2
	call	__frameset
	ld	a, (ix + 6)
	ld	hl, 2
	ld	(ix - 2), 17
	ld	(ix - 1), a
	push	hl
	pea	ix - 2
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end32
.Lfunc_end32:
	.size	_vdp_set_text_colour, .Lfunc_end32-_vdp_set_text_colour
                                        ; -- End function
	.globl	_vdp_set_text_bg_colour         ; -- Begin function vdp_set_text_bg_colour
	.type	_vdp_set_text_bg_colour,@function
_vdp_set_text_bg_colour:                ; @vdp_set_text_bg_colour
; %bb.0:
	ld	hl, -2
	call	__frameset
	ld	a, (ix + 6)
	ld	hl, 2
	ld	(ix - 2), 17
	xor	a, -128
	ld	(ix - 1), a
	push	hl
	pea	ix - 2
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end33
.Lfunc_end33:
	.size	_vdp_set_text_bg_colour, .Lfunc_end33-_vdp_set_text_bg_colour
                                        ; -- End function
	.globl	_vdp_cursor_tab                 ; -- Begin function vdp_cursor_tab
	.type	_vdp_cursor_tab,@function
_vdp_cursor_tab:                        ; @vdp_cursor_tab
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	a, (ix + 6)
	ld	l, (ix + 9)
	ld	de, 3
	ld	(ix - 3), 31
	ld	(ix - 2), a
	ld	(ix - 1), l
	push	de
	pea	ix - 3
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end34
.Lfunc_end34:
	.size	_vdp_cursor_tab, .Lfunc_end34-_vdp_cursor_tab
                                        ; -- End function
	.globl	_vdp_swap                       ; -- Begin function vdp_swap
	.type	_vdp_swap,@function
_vdp_swap:                              ; @vdp_swap
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	iy, ___const.vdp_swap.b
	ld	de, 3
	lea	hl, ix - 3
	ld	a, (iy)
	ld	(hl), a
	ld	a, (___const.vdp_swap.b+1)
	ld	(ix - 2), a
	ld	a, (___const.vdp_swap.b+2)
	ld	(ix - 1), a
	push	de
	push	hl
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end35
.Lfunc_end35:
	.size	_vdp_swap, .Lfunc_end35-_vdp_swap
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.type	_main,@function
_main:                                  ; @main
; %bb.0:
	ld	hl, -275
	call	__frameset
	ld	bc, -143
	lea	hl, ix + 0
	add	hl, bc
	ld	bc, -158
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	iy, 0
	ld	hl, 1
	push	ix
	ld	bc, -149
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	hl, 50
	push	ix
	ld	bc, -167
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld.sis	hl, -1
	push	ix
	ld	de, -170
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, _.str.67
	push	ix
	ld	de, -173
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	(ix - 7), 0
	ld	(ix - 10), iy
	ld	(ix - 13), iy
	ld	(ix - 16), iy
	ld	(ix - 20), iy
	ld	(ix - 17), 0
	ld	(ix - 24), iy
	ld	(ix - 21), 0
	ld	(ix - 28), iy
	ld	(ix - 25), 0
	ld	(ix - 32), iy
	ld	(ix - 29), 0
	ld	(ix - 36), iy
	ld	(ix - 33), 0
	ld	de, -132
	lea	hl, ix + 0
	add	hl, de
	push	ix
	ld	de, -146
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	lea	hl, ix - 67
	push	ix
	ld	de, -164
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -132
	lea	hl, ix + 0
	add	hl, de
	push	ix
	ld	de, -161
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -134
	lea	hl, ix + 0
	add	hl, de
	push	ix
	ld	de, -155
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	bc, 30
	.local	.LBB36_1
.LBB36_1:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jr	z, .LBB36_3
; %bb.2:                                ;   in Loop: Header=BB36_1 Depth=1
	lea	de, iy + 0
	ld	hl, ___const._ZN12_GLOBAL__N_112clearOutputsEv.names
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	bc, -152
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	call	_mos_del
	ld	de, -152
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	ld	bc, 30
	pop	hl
	ld	de, 3
	add	iy, de
	jr	.LBB36_1
	.local	.LBB36_3
.LBB36_3:
	ld	iy, __ZN12_GLOBAL__N_15rulesE
	lea	de, iy + 0
	ld	hl, __ZN5rally4gameL9FujiRulesE
	ld	bc, 9
	ldir
	xor	a, a
	ld	(__ZN12_GLOBAL__N_15rulesE+9), a
	ld	hl, 3276800
	ld	(__ZN12_GLOBAL__N_15rulesE+47), hl
	ld	(__ZN12_GLOBAL__N_15rulesE+50), a
	ld	hl, 200
	ld	(__ZN12_GLOBAL__N_15rulesE+62), hl
	push	iy
	call	__ZN5rally4game5Rules9raceReadyEv
	pop	hl
	ld	a, 6
	ld	(__ZN12_GLOBAL__N_15rulesE+10), a
	ld	de, 0
	ld	(__ZN12_GLOBAL__N_15rulesE+11), de
	xor	a, a
	ld	(__ZN12_GLOBAL__N_15rulesE+14), a
	ld	hl, __ZN12_GLOBAL__N_15rulesE+55
	push	hl
	pop	iy
	ld	hl, (iy)
	inc.sis	hl
	ld	(iy), l
	ld	(iy + 1), h
	ld	hl, __ZN5rallyL4FujiE
	ld	(__ZN12_GLOBAL__N_16motionE), hl
	ld	hl, 200
	ld	(__ZN12_GLOBAL__N_16motionE+27), hl
	ld	hl, 3246800
	ld	(__ZN12_GLOBAL__N_16motionE+7), hl
	ld	(__ZN12_GLOBAL__N_16motionE+10), a
	ld	hl, 6800
	ld	(__ZN12_GLOBAL__N_16motionE+3), hl
	ld	(__ZN12_GLOBAL__N_16motionE+6), a
	ld	(__ZN12_GLOBAL__N_16motionE+15), de
	ld	(__ZN12_GLOBAL__N_16motionE+18), a
	ld	hl, __ZN12_GLOBAL__N_16motionE+23
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ld	(__ZN12_GLOBAL__N_16motionE+30), a
	call	__ZN2fs5setupEv
	bit	0, a
	jp	z, .LBB36_54
; %bb.4:
	ld	hl, _.str.6
	push	hl
	ld	hl, _.str.41
	push	hl
	call	_fopen
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB36_6
; %bb.5:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	hl, _.str.42
	jp	nz, .LBB36_52
	jp	.LBB36_53
	.local	.LBB36_6
.LBB36_6:
	ld	bc, -152
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	hl
	ld	hl, 21600
	push	hl
	ld	hl, 1
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111motionBytesE
	push	hl
	call	_fread
	pop	de
	pop	de
	pop	de
	pop	de
	ld	de, 21600
	ld	bc, -152
	or	a, a
	sbc	hl, de
	jp	nz, .LBB36_50
; %bb.7:
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fgetc
	ld	bc, -176
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	pop	hl
	ld	bc, -152
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	ld	de, -1
	ld	bc, -176
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	jp	nz, .LBB36_51
; %bb.8:
	ld	hl, _.str.6
	push	hl
	ld	hl, _.str.44
	push	hl
	call	_fopen
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB36_62
	.local	.LBB36_9
.LBB36_9:
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 198
	push	hl
	ld	hl, 1
	push	hl
	call	__ZN2fs6read32Etm
	pop	bc
	pop	bc
	pop	bc
	ld	bc, 3246800
	xor	a, a
	call	__lcmpu
	jp	nz, .LBB36_66
; %bb.10:
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 304
	push	hl
	ld	hl, 1
	push	hl
	call	__ZN2fs6read16Etm
	pop	de
	pop	de
	pop	de
	ld.sis	de, 6800
	or	a, a
	sbc.sis	hl, de
	jp	nz, .LBB36_66
; %bb.11:
	ld	hl, 63940
	push	hl
	call	__ZN12_GLOBAL__N_14fontEj
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_14sendEPKhj
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16engineE
	push	hl
	call	__ZN5rally4game6Engine5startIPFvPKhjEEEvT_
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_19warmLowerEv
	call	__ZN12_GLOBAL__N_15paintEv
	call	__ZN12_GLOBAL__N_19warmLowerEv
	call	__ZN12_GLOBAL__N_15paintEv
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB36_54
; %bb.12:
	call	__ZN2fs10startTimerEv
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB36_54
; %bb.13:
	ld.sis	hl, 17
	ld	bc, -134
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), l
	ld	(iy + 1), h
	ld	de, 4
	push	de
	ld	hl, 2
	push	hl
	ld	bc, -155
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	push	de
	call	__ZN2fs11transactionEhPKhjh
	ld	bc, -206
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -158
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	(iy + 0), 0
	ld.sis	hl, 60
	ld	(iy + 1), l
	ld	(iy + 2), h
	ld.sis	hl, 0
	ld	(iy + 3), l
	ld	(iy + 4), h
	or	a, a
	sbc	hl, hl
	ld	(iy + 5), hl
	ld	(iy + 8), h
	ld	(__ZN2fs9wireBytesE), hl
	xor	a, a
	ld	(__ZN2fs9wireBytesE+3), a
	ld	(__ZN2fs6waitMsE), hl
	ld	(__ZN2fs6waitMsE+3), a
	ld	(__ZN2fs6sendMsE), hl
	ld	(__ZN2fs6sendMsE+3), a
	ld	(__ZN2fs11footerCallsE), hl
	ld	(__ZN2fs11footerCallsE+3), a
	ld	(__ZN2fs8hudBytesE), hl
	ld	(__ZN2fs8hudBytesE+3), a
	ld	(__ZN2fs14skyRepairCallsE), hl
	ld	(__ZN2fs14skyRepairCallsE+3), a
	ld	(__ZN2fs12repaintCallsE), hl
	ld	(__ZN2fs12repaintCallsE+3), a
	ld	(__ZN2fs11scrollCallsE), hl
	ld	(__ZN2fs11scrollCallsE+3), a
	ld	(__ZN12_GLOBAL__N_112finishFramesE), hl
	ld	(__ZN12_GLOBAL__N_112finishFramesE+3), a
	ld	a, (__ZN2fs17compactConfiguredE)
	ld	(__ZN2fs12reducedReadsE), a
	call	__ZN2fs3nowEv
	ld	a, e
	ld	(__ZN12_GLOBAL__N_15timesE), hl
	ld	(__ZN12_GLOBAL__N_15timesE+3), a
	call	__ZN2fs5timerEv
	ld	a, e
	ld	(__ZN12_GLOBAL__N_14prtsE), hl
	ld	(__ZN12_GLOBAL__N_14prtsE+3), a
	ld	iy, __ZN12_GLOBAL__N_110inputPollsE
	lea	hl, iy + 3
	ld	bc, -182
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	iy, __ZN12_GLOBAL__N_112audioChangesE
	lea	hl, iy + 3
	ld	bc, -203
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	iy, __ZN12_GLOBAL__N_16motionE+7
	lea	hl, iy + 3
	ld	bc, -197
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	iy, __ZN12_GLOBAL__N_16motionE+3
	lea	hl, iy + 3
	ld	bc, -200
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	hl, __ZN12_GLOBAL__N_111motionBytesE
	push	ix
	ld	bc, -185
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	or	a, a
	sbc	hl, hl
	push	hl
	pop	iy
	push	ix
	ld	bc, -191
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ex	de, hl
	xor	a, a
	ld	l, a
	push	ix
	ld	bc, -194
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -176
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	push	ix
	ld	bc, -179
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	.local	.LBB36_14
.LBB36_14:                              ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB36_17 Depth 2
                                        ;     Child Loop BB36_20 Depth 2
                                        ;     Child Loop BB36_23 Depth 2
                                        ;     Child Loop BB36_26 Depth 2
	ld	bc, (__ZN2fs10frameCountE)
	ld	a, (__ZN2fs7healthyE)
	ld	e, a
	and	a, 1
	ld	(ix - 3), de
	ld	de, -152
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	ld	de, (ix - 3)
	jp	nc, .LBB36_74
; %bb.15:                               ;   in Loop: Header=BB36_14 Depth=1
	bit	0, a
	jp	z, .LBB36_74
; %bb.16:                               ;   in Loop: Header=BB36_14 Depth=1
	xor	a, a
	ld	e, a
	ld	hl, 16
	ld	bc, -182
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	.local	.LBB36_17
.LBB36_17:                              ;   Parent Loop BB36_14 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB36_19
; %bb.18:                               ;   in Loop: Header=BB36_17 Depth=2
	push	de
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), de
	push	ix
	ld	bc, -209
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	call	_vdp_getKeyMap
	ld	bc, -209
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	ix
	ld	bc, -182
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	pop	bc
	dec	hl
	inc	e
	jr	.LBB36_17
	.local	.LBB36_19
.LBB36_19:                              ;   in Loop: Header=BB36_14 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_110inputPollsE)
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN12_GLOBAL__N_110inputPollsE), hl
	ld	(__ZN12_GLOBAL__N_110inputPollsE+3), a
	call	__ZN2fs5timerEv
	ld	bc, -209
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	ld	bc, -212
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	ld	de, 4
	.local	.LBB36_20
.LBB36_20:                              ;   Parent Loop BB36_14 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	push	de
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB36_22
; %bb.21:                               ;   in Loop: Header=BB36_20 Depth=2
	ld	bc, -158
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -215
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	call	__ZN5rally4game11RouteCursor4tickEv
	ld	e, l
	ld	d, h
	pop	hl
	ld	l, e
	ld	h, d
	ld	c, 1
	call	__sshru
	ld	bc, 0
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(__ZN12_GLOBAL__N_16motionE+11), bc
	ld	(__ZN12_GLOBAL__N_16motionE+14), a
	ld	hl, (__ZN12_GLOBAL__N_16motionE+7)
	ld	bc, 0
	ld	c, e
	ld	b, d
	ld	de, -188
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	push	ix
	ld	bc, -197
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	ld	e, (iy)
	ld	(ix - 3), de
	ld	de, -188
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	ld	de, (ix - 3)
	call	__ladd
	ld	bc, 3276800
	ld	d, a
	ld	a, d
	call	__lrems
	ld	a, e
	ld	(__ZN12_GLOBAL__N_16motionE+7), hl
	ld	(__ZN12_GLOBAL__N_16motionE+10), a
	ld	hl, (__ZN12_GLOBAL__N_16motionE+3)
	ld	(ix - 3), bc
	push	ix
	ld	bc, -200
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	ld	e, (iy)
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	bc, (ix - 3)
	lea	bc, iy + 0
	xor	a, a
	call	__ladd
	ld	bc, 8000
	ld	a, d
	call	__lrems
	ld	a, e
	ld	(__ZN12_GLOBAL__N_16motionE+3), hl
	ld	(__ZN12_GLOBAL__N_16motionE+6), a
	or	a, a
	sbc	hl, hl
	push	hl
	push	iy
	ld	hl, __ZN12_GLOBAL__N_15rulesE
	push	hl
	call	__ZN5rally4game5Rules4tickEm
	pop	hl
	pop	hl
	pop	hl
	call	__ZN2fs4tickEv
	ld	bc, -215
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	dec	de
	jp	.LBB36_20
	.local	.LBB36_22
.LBB36_22:                              ;   in Loop: Header=BB36_14 Depth=1
	call	__ZN2fs5timerEv
	ld	(ix - 3), de
	ld	de, -209
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -212
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lsub
	ld	bc, -1
	xor	a, a
	call	__land
	ld	(ix - 3), bc
	push	ix
	ld	bc, -212
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -215
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	push	ix
	ld	bc, -152
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	ld	bc, (ix - 3)
	ld	bc, 24
	call	__imulu
	push	hl
	pop	de
	ld	hl, __ZN12_GLOBAL__N_111motionBytesE
	add	hl, de
	push	bc
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 4
	push	hl
	call	__ZN2fs6updateEttPKhj
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	.local	.LBB36_23
.LBB36_23:                              ;   Parent Loop BB36_14 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	push	hl
	pop	bc
	ld	de, 24
	or	a, a
	sbc	hl, de
	jp	z, .LBB36_25
; %bb.24:                               ;   in Loop: Header=BB36_23 Depth=2
	push	bc
	pop	de
	ld	bc, -209
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ld	bc, -161
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	add	hl, de
	push	ix
	ld	bc, -188
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	iy, ___const._ZN12_GLOBAL__N_115scriptedTrafficEj.lanes
	add	iy, de
	ld	de, (iy)
	ld	a, (iy + 3)
	ld	bc, -218
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a
	ld	a, e
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	ld	(hl), a
	ld	a, d
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	(iy + 1), a
	push	de
	pop	bc
	ld	(ix - 3), de
	ld	de, -218
	lea	iy, ix + 0
	add	iy, de
	ld	h, (iy + 0)                     ; 1-byte Folded Reload
	ld	a, h
	ld	l, 16
	call	__lshru
	ld	a, c
	push	ix
	ld	bc, -188
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy + 2), a
	ld	de, (ix - 3)
	push	de
	pop	bc
	ld	a, h
	ld	l, 24
	call	__lshru
	ld	a, c
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	(iy + 3), a
	ld	de, 4
	ld	bc, -209
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	add	hl, de
	jp	.LBB36_23
	.local	.LBB36_25
.LBB36_25:                              ;   in Loop: Header=BB36_14 Depth=1
	ld	hl, 24
	push	hl
	ld	bc, -161
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 5
	push	hl
	call	__ZN2fs6updateEttPKhj
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_16motionE+7)
	ld	bc, -218
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, (__ZN12_GLOBAL__N_16motionE+10)
	ld	bc, -221
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	or	a, a
	sbc	hl, hl
	push	hl
	pop	iy
	push	ix
	ld	bc, -188
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	.local	.LBB36_26
.LBB36_26:                              ;   Parent Loop BB36_14 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	lea	hl, iy + 0
	ld	de, 24
	or	a, a
	sbc	hl, de
	jp	z, .LBB36_42
; %bb.27:                               ;   in Loop: Header=BB36_26 Depth=2
	ld	bc, -224
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	lea	de, iy + 0
	ld	bc, -185
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	add	hl, de
	push	hl
	call	__ZN2fs5get32EPKh
	pop	bc
	ld	(ix - 3), de
	ld	de, -218
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -221
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lsub
	push	hl
	pop	iy
	ld	a, e
	ld	hl, 1638400
	ld	e, h
	lea	bc, iy + 0
	ld	(ix - 3), bc
	push	ix
	ld	bc, -209
	add	ix, bc
	ld	(ix + 0), a                     ; 1-byte Folded Spill
	pop	ix
	ld	bc, (ix - 3)
	call	__lcmps
	call	pe, __setflag
	ld	d, 1
	ld	a, d
	jp	m, .LBB36_29
; %bb.28:                               ;   in Loop: Header=BB36_26 Depth=2
	ld	a, 0
	.local	.LBB36_29
.LBB36_29:                              ;   in Loop: Header=BB36_26 Depth=2
	ld	bc, -227
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a
	lea	hl, iy + 0
	push	ix
	ld	bc, -209
	add	ix, bc
	ld	d, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	e, d
	ld	bc, -3276800
	ld	a, -1
	call	__ladd
	ld	(ix - 3), bc
	push	ix
	ld	bc, -230
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -233
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	lea	hl, iy + 0
	ld	e, d
	ld	bc, (ix - 3)
	ld	bc, -1638400
	call	__lcmps
	call	pe, __setflag
	ld	d, 1
	jp	m, .LBB36_31
; %bb.30:                               ;   in Loop: Header=BB36_26 Depth=2
	ld	d, 0
	.local	.LBB36_31
.LBB36_31:                              ;   in Loop: Header=BB36_26 Depth=2
	lea	hl, iy + 0
	push	ix
	ld	bc, -209
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, 3276800
	xor	a, a
	call	__ladd
	bit	0, d
	jr	nz, .LBB36_33
; %bb.32:                               ;   in Loop: Header=BB36_26 Depth=2
	lea	hl, iy + 0
	.local	.LBB36_33
.LBB36_33:                              ;   in Loop: Header=BB36_26 Depth=2
	bit	0, d
	ld	bc, -227
	lea	iy, ix + 0
	push	af
	add	iy, bc
	pop	af
	ld	a, (iy + 0)                     ; 1-byte Folded Reload
	ld	(ix - 3), de
	push	ix
	ld	de, -230
	push	af
	add	ix, de
	pop	af
	ld	bc, (ix + 0)
	pop	ix
	ld	de, (ix - 3)
	jr	nz, .LBB36_35
; %bb.34:                               ;   in Loop: Header=BB36_26 Depth=2
	ld	(ix - 3), bc
	ld	bc, -209
	lea	iy, ix + 0
	add	iy, bc
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	ld	bc, (ix - 3)
	.local	.LBB36_35
.LBB36_35:                              ;   in Loop: Header=BB36_26 Depth=2
	bit	0, a
	ld	(ix - 3), bc
	ld	bc, -224
	lea	iy, ix + 0
	push	af
	add	iy, bc
	pop	af
	ld	iy, (iy + 0)
	ld	bc, (ix - 3)
	jr	nz, .LBB36_37
; %bb.36:                               ;   in Loop: Header=BB36_26 Depth=2
	push	hl
	pop	bc
	.local	.LBB36_37
.LBB36_37:                              ;   in Loop: Header=BB36_26 Depth=2
	bit	0, a
	ld	(ix - 3), bc
	ld	bc, -233
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	a, (hl)                         ; 1-byte Folded Reload
	ld	bc, (ix - 3)
	jr	nz, .LBB36_39
; %bb.38:                               ;   in Loop: Header=BB36_26 Depth=2
	ld	a, e
	.local	.LBB36_39
.LBB36_39:                              ;   in Loop: Header=BB36_26 Depth=2
	or	a, a
	sbc	hl, hl
	ld	e, h
	call	__lcmps
	call	pe, __setflag
	ld	de, 1
	jp	m, .LBB36_41
; %bb.40:                               ;   in Loop: Header=BB36_26 Depth=2
	ld	de, 0
	.local	.LBB36_41
.LBB36_41:                              ;   in Loop: Header=BB36_26 Depth=2
	ld	bc, -188
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	add	hl, de
	push	ix
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	de, 4
	add	iy, de
	jp	.LBB36_26
	.local	.LBB36_42
.LBB36_42:                              ;   in Loop: Header=BB36_14 Depth=1
	ld	bc, -212
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -215
	lea	iy, ix + 0
	add	iy, bc
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	ld	(ix - 3), de
	push	ix
	ld	de, -176
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -179
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	a, iyl
	ld	de, (ix - 3)
	call	__ladd
	ld	(ix - 3), bc
	ld	bc, -176
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
                                        ; kill: def $e killed $e def $ude
	push	ix
	ld	bc, -179
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	push	ix
	ld	bc, -188
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	inc	l
	ld	a, l
	ld	(__ZN12_GLOBAL__N_15rulesE+61), a
	ld	hl, (__ZN12_GLOBAL__N_16engineE+1)
	push	ix
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_16motionE+11)
	ld	a, (__ZN12_GLOBAL__N_16motionE+14)
	ld	e, a
	ld	bc, (ix - 3)
	ld	bc, __ZN12_GLOBAL__N_14sendEPKhj
	push	bc
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16engineE
	push	hl
	call	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_16engineE+1)
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	or	a, a
	sbc	hl, de
	jr	z, .LBB36_44
; %bb.43:                               ;   in Loop: Header=BB36_14 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_112audioChangesE)
	ld	bc, -203
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN12_GLOBAL__N_112audioChangesE), hl
	ld	(__ZN12_GLOBAL__N_112audioChangesE+3), a
	.local	.LBB36_44
.LBB36_44:                              ;   in Loop: Header=BB36_14 Depth=1
	call	__ZN2fs5timerEv
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	ld	bc, -209
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	ld	hl, (__ZN2fs6sendMsE)
	push	ix
	ld	bc, -212
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs6sendMsE+3)
	ld	bc, -215
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	ld	hl, (__ZN2fs6waitMsE)
	push	ix
	ld	bc, -218
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs6waitMsE+3)
	ld	bc, -221
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	call	__ZN12_GLOBAL__N_15paintEv
	call	__ZN2fs5timerEv
	push	hl
	pop	iy
	ld	d, e
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB36_54
; %bb.45:                               ;   in Loop: Header=BB36_14 Depth=1
	ld	hl, (__ZN2fs6sendMsE)
	push	ix
	ld	bc, -230
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs6sendMsE+3)
	ld	bc, -233
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	ld	hl, (__ZN2fs6waitMsE)
	push	ix
	ld	bc, -224
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs6waitMsE+3)
	ld	bc, -227
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	push	ix
	ld	bc, -218
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -221
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	(ix - 3), de
	push	ix
	ld	de, -212
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -215
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__ladd
	push	hl
	pop	bc
	ld	a, e
	ld	(ix - 3), bc
	push	ix
	ld	bc, -230
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -233
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, (ix - 3)
	call	__lsub
	ld	(ix - 3), de
	push	ix
	ld	de, -224
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -227
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__ladd
	ld	(ix - 3), bc
	push	ix
	ld	bc, -215
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -212
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	lea	hl, iy + 0
	ld	e, d
	ld	bc, (ix - 3)
	ld	(ix - 3), de
	ld	de, -188
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -209
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lsub
	ld	bc, -1
	xor	a, a
	call	__land
	ld	a, e
	or	a, a
	ld	(ix - 3), bc
	push	ix
	ld	bc, -215
	push	af
	add	ix, bc
	pop	af
	ld	de, (ix + 0)
	pop	ix
	sbc	hl, de
	push	ix
	ld	bc, -212
	push	af
	add	ix, bc
	pop	af
	sbc	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	d, a
                                        ; kill: def $a killed $a
	sbc	a, a
	bit	0, a
	ld	bc, (ix - 3)
	ld	bc, 0
	jr	nz, .LBB36_47
; %bb.46:                               ;   in Loop: Header=BB36_14 Depth=1
	push	hl
	pop	bc
	.local	.LBB36_47
.LBB36_47:                              ;   in Loop: Header=BB36_14 Depth=1
	bit	0, a
	ld	e, 0
	jr	nz, .LBB36_49
; %bb.48:                               ;   in Loop: Header=BB36_14 Depth=1
	ld	e, d
	.local	.LBB36_49
.LBB36_49:                              ;   in Loop: Header=BB36_14 Depth=1
	push	bc
	pop	hl
	ld	(ix - 3), de
	ld	de, -191
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -194
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	a, iyl
	ld	de, (ix - 3)
	call	__ladd
	ld	(ix - 3), bc
	ld	bc, -191
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
                                        ; kill: def $e killed $e def $ude
	push	ix
	ld	bc, -194
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	ld	bc, (ix - 3)
	call	__ZN2fs3nowEv
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	ld	bc, -152
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	inc	hl
	push	ix
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, 2
	ld	c, a
	call	__ishl
	push	hl
	pop	bc
	ld	(ix - 3), de
	push	ix
	ld	de, -209
	add	ix, de
	ld	(ix + 0), bc
	pop	ix
	ld	iy, __ZN12_GLOBAL__N_15timesE
	add	iy, bc
	push	ix
	ld	bc, -188
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	ld	(iy), hl
	ld	de, (ix - 3)
	ld	(iy + 3), e
	call	__ZN2fs5timerEv
	ld	iy, __ZN12_GLOBAL__N_14prtsE
	ld	(ix - 3), de
	push	ix
	ld	de, -209
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	add	iy, bc
	ld	(iy), hl
	ld	de, (ix - 3)
	ld	(iy + 3), e
	ld	bc, -152
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	__ZN12_GLOBAL__N_17captureEjj
	pop	hl
	pop	hl
	ld	bc, -185
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	lea	iy, iy + 24
	push	ix
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	bc, -152
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	jp	.LBB36_14
	.local	.LBB36_50
.LBB36_50:
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	.local	.LBB36_51
.LBB36_51:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	hl, _.str.43
	jr	z, .LBB36_53
	.local	.LBB36_52
.LBB36_52:
	ld	(__ZN2fs7failureE), hl
	.local	.LBB36_53
.LBB36_53:
	xor	a, a
	ld	(__ZN2fs7healthyE), a
	.local	.LBB36_54
.LBB36_54:
	ld	a, (__ZN12_GLOBAL__N_16engineE)
	bit	0, a
	jr	z, .LBB36_56
; %bb.55:
	ld	bc, -146
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	ld	hl, ___const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute
	ld	iy, 6
	lea	bc, iy + 0
	ldir
	push	iy
	ld	bc, -146
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	xor	a, a
	ld	(__ZN12_GLOBAL__N_16engineE), a
	.local	.LBB36_56
.LBB36_56:
	call	__ZN2fs4stopEv
	ld	a, (__ZN2fs7pendingE)
	bit	0, a
	jr	nz, .LBB36_58
; %bb.57:
	call	__ZN12_GLOBAL__N_115releaseGraphicsEv
	call	__ZN12_GLOBAL__N_111restoreTextEv
	.local	.LBB36_58
.LBB36_58:
	ld	hl, _.str.25
	push	hl
	ld	hl, _.str.29
	push	hl
	call	_fopen
	push	hl
	pop	de
	pop	hl
	pop	hl
	push	de
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB36_60
; %bb.59:
	ld	hl, (__ZN2fs7failureE)
	push	hl
	ld	hl, _.str.30
	push	hl
	push	de
	ld	bc, -146
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	call	_fprintf
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -146
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	.local	.LBB36_60
.LBB36_60:
	ld	hl, (__ZN2fs7failureE)
	push	hl
	ld	hl, _.str.31
	push	hl
	call	_printf
	pop	hl
	pop	hl
	.local	.LBB36_61
.LBB36_61:
	ld	bc, -149
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB36_62
.LBB36_62:
	ld	bc, -152
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	hl
	ld	hl, 4
	push	hl
	ld	hl, 1
	push	hl
	ld	bc, -132
	lea	hl, ix + 0
	add	hl, bc
	push	hl
	call	_fread
	pop	de
	pop	de
	pop	de
	pop	de
	ld	de, 4
	ld	bc, -152
	or	a, a
	sbc	hl, de
	jp	nz, .LBB36_68
; %bb.63:
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fgetc
	ld	bc, -176
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	pop	hl
	ld	bc, -152
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	ld	bc, -176
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	de, -1
	or	a, a
	sbc	hl, de
	jp	nz, .LBB36_69
; %bb.64:
	ld	bc, -132
	lea	hl, ix + 0
	add	hl, bc
	ld	e, (hl)
	ld	d, 0
	ld	h, d
	inc	bc
	lea	iy, ix + 0
	add	iy, bc
	ld	l, (iy + 0)
	ex	de, hl
	ld	iyh, e
	ex	de, hl
	ld	iyl, d
	add.sis	iy, de
	ld	hl, __ZN12_GLOBAL__N_112captureStageE
	push	de
	ld	e, iyl
	ld	d, iyh
	ld	(hl), e
	inc	hl
	ld	(hl), d
	pop	de
	ld	c, iyl
	ld	b, iyh
	ld	(ix - 3), bc
	ld	bc, -130
	lea	hl, ix + 0
	add	hl, bc
	ld	e, (hl)
	ld	h, d
	inc	bc
	lea	iy, ix + 0
	add	iy, bc
	ld	l, (iy + 0)
	ex	de, hl
	ld	iyh, e
	ex	de, hl
	ld	iyl, d
	add.sis	iy, de
	ld	hl, __ZN12_GLOBAL__N_112captureFrameE
	push	ix
	ld	de, -152
	add	ix, de
	ld	(ix + 0), iy
	pop	ix
	push	de
	ld	e, iyl
	ld	d, iyh
	ld	(hl), e
	inc	hl
	ld	(hl), d
	pop	de
	ld.sis	iy, 2
	ld	bc, (ix - 3)
	ld	e, c
	ld	d, b
	ld	l, c
	ld	h, b
	ld	c, iyl
	ld	b, iyh
	or	a, a
	sbc.sis	hl, bc
	jr	c, .LBB36_70
	.local	.LBB36_65
.LBB36_65:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	hl, _.str.46
	jp	nz, .LBB36_52
	jp	.LBB36_53
	.local	.LBB36_66
.LBB36_66:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB36_53
; %bb.67:
	ld	hl, _.str.26
	jp	.LBB36_52
	.local	.LBB36_68
.LBB36_68:
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	.local	.LBB36_69
.LBB36_69:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	hl, _.str.45
	jp	nz, .LBB36_52
	jp	.LBB36_53
	.local	.LBB36_70
.LBB36_70:
	ld	(ix - 3), de
	ld	de, -152
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	ld	de, (ix - 3)
	ld	l, e
	ld	h, d
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB36_73
; %bb.71:
	ld	l, c
	ld	h, b
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	z, .LBB36_65
; %bb.72:
	ld	de, 0
	ld	e, c
	ld	d, b
	ld	hl, (__ZN2fs10frameCountE)
	or	a, a
	sbc	hl, de
	jp	nc, .LBB36_9
	jr	.LBB36_65
	.local	.LBB36_73
.LBB36_73:
	ld.sis	de, 272
	ld	l, c
	ld	h, b
	or	a, a
	sbc.sis	hl, de
	jp	c, .LBB36_9
	jp	.LBB36_65
	.local	.LBB36_74
.LBB36_74:
	ld	a, e
	or	a, a
	jp	z, .LBB36_54
; %bb.75:
	ld	a, 2
	push	bc
	pop	hl
	ld	c, a
	call	__ishl
	push	hl
	pop	de
	ld	iy, __ZN12_GLOBAL__N_15timesE
	add	iy, de
	ld	hl, (iy)
	ld	(ix - 3), bc
	push	ix
	ld	bc, -185
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (iy + 3)
	ld	bc, -188
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a
	ld	hl, (__ZN12_GLOBAL__N_15timesE)
	ld	bc, -182
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, (__ZN12_GLOBAL__N_15timesE+3)
	ld	bc, -197
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	ld	iy, __ZN12_GLOBAL__N_14prtsE
	add	iy, de
	ld	hl, (iy)
	ld	bc, (ix - 3)
	ld	bc, (__ZN12_GLOBAL__N_14prtsE)
	ld	a, (__ZN12_GLOBAL__N_14prtsE+3)
	ld	e, (iy + 3)
	call	__lsub
	ld	(ix - 3), bc
	ld	bc, -200
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	ld	bc, -203
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	xor	a, a
	ld	(__ZN2fs12reducedReadsE), a
	ld	hl, (__ZN2fs6sendMsE)
	ld	a, (__ZN2fs6sendMsE+3)
	ld	(ix - 36), hl
	ld	(ix - 33), a
	ld	hl, (__ZN2fs6waitMsE)
	ld	a, (__ZN2fs6waitMsE+3)
	ld	(ix - 32), hl
	ld	(ix - 29), a
	ld	hl, (__ZN2fs9wireBytesE)
	ld	a, (__ZN2fs9wireBytesE+3)
	ld	(ix - 28), hl
	ld	(ix - 25), a
	ld	hl, (__ZN2fs7requestE)
	ld	a, (__ZN2fs7requestE+3)
	ld	(ix - 24), hl
	ld	(ix - 21), a
	ld	hl, (__ZN2fs10generationE)
	ld	a, (__ZN2fs10generationE+3)
	ld	(ix - 20), hl
	ld	(ix - 17), a
	ld	hl, 4
	ld	bc, (ix - 3)
	ex	de, hl
	push	de
	ld	hl, 2
	push	hl
	ld	(ix - 3), bc
	ld	bc, -155
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	push	de
	ld	bc, (ix - 3)
	call	__ZN2fs11transactionEhPKhjh
	ld	de, -218
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	ix
	ld	de, -158
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	bc, 0
	ld	iy, __ZN2fsL7BuffersE
	.local	.LBB36_76
.LBB36_76:                              ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB36_78 Depth 2
	lea	hl, iy + 0
	ld	de, __ZN2fsL7BuffersE+36
	or	a, a
	sbc	hl, de
	jp	z, .LBB36_81
; %bb.77:                               ;   in Loop: Header=BB36_76 Depth=1
	ld	(ix - 3), bc
	ld	bc, -158
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	ld	hl, __ZN12_GLOBAL__N_110finalStateE
	add	hl, de
	push	ix
	ld	de, -209
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	or	a, a
	sbc	hl, hl
	push	ix
	ld	de, -155
	add	ix, de
	ld	(ix + 0), iy
	pop	ix
	.local	.LBB36_78
.LBB36_78:                              ;   Parent Loop BB36_76 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	bc, (ix - 3)
	push	bc
	pop	de
	ld	bc, -152
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	bc, -155
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy + 4)
	push	de
	pop	bc
	ld	e, l
	ld	d, h
	ld	(ix - 3), bc
	ld	bc, -152
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	ld	bc, (ix - 3)
	jp	nc, .LBB36_80
; %bb.79:                               ;   in Loop: Header=BB36_78 Depth=2
	ld	bc, -152
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	push	de
	pop	bc
	ld	(ix - 3), bc
	ld	bc, -152
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), de
	push	ix
	ld	bc, -209
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	ld	bc, (ix - 3)
	add	hl, bc
	push	ix
	ld	bc, -212
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, -155
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	push	ix
	ld	bc, -215
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, -155
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy + 2)
	ld	bc, 0
	ld	c, l
	ld	b, h
	ex	de, hl
	add	hl, bc
	ld	de, 0
	push	de
	push	hl
	ld	bc, -215
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN2fs6read16Etm
	ld	bc, 0
	pop	de
	pop	de
	pop	de
	ld	a, l
	ld	de, -212
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	ld	(iy), a
	ld	a, h
	ld	(iy + 1), a
	ld	de, 2
	ld	(ix - 3), bc
	ld	bc, -152
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	add	hl, de
	jp	.LBB36_78
	.local	.LBB36_80
.LBB36_80:                              ;   in Loop: Header=BB36_76 Depth=1
	ld	de, -155
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	lea	iy, iy + 6
	ld	(ix - 3), bc
	push	ix
	ld	bc, -152
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -158
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	add	hl, de
	push	ix
	ld	de, -158
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	bc, (ix - 3)
	jp	.LBB36_76
	.local	.LBB36_81
.LBB36_81:
	ld	bc, -185
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -188
	lea	iy, ix + 0
	add	iy, bc
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	ld	(ix - 3), de
	push	ix
	ld	de, -182
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -197
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lsub
	ld	(ix - 3), bc
	push	ix
	ld	bc, -158
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
                                        ; kill: def $e killed $e def $ude
	push	ix
	ld	bc, -182
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	push	ix
	ld	bc, -200
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -203
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, (ix - 3)
	ld	bc, -1
	xor	a, a
	call	__land
	ld	(ix - 3), bc
	push	ix
	ld	bc, -152
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
                                        ; kill: def $e killed $e def $ude
	push	ix
	ld	bc, -155
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	bc, (ix - 3)
	jp	z, .LBB36_54
; %bb.82:
	ld	hl, _.str.6
	push	hl
	ld	hl, _.str.64
	push	hl
	call	_fopen
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB36_124
; %bb.83:
	push	hl
	call	_fclose
	pop	hl
	ld	bc, -164
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	ld	hl, __ZN12_GLOBAL__N_16motionE
	ld	bc, 31
	ldir
	ld	hl, (__ZN12_GLOBAL__N_15crashE)
	ld	bc, -203
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, (__ZN12_GLOBAL__N_15crashE+3)
	ld	bc, -221
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	push	ix
	ld	bc, -161
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
	ld	hl, __ZN12_GLOBAL__N_15rulesE
	ld	bc, 65
	ldir
	ld	hl, (__ZN2fs11scrollCallsE)
	push	ix
	ld	bc, -200
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs11scrollCallsE+3)
	ld	bc, -215
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	ld	hl, (__ZN2fs12repaintCallsE)
	push	ix
	ld	bc, -197
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs12repaintCallsE+3)
	ld	bc, -212
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	ld	hl, (__ZN2fs14skyRepairCallsE)
	push	ix
	ld	bc, -188
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs14skyRepairCallsE+3)
	ld	bc, -209
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	ld	hl, 2
	push	hl
	ld	hl, 7
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	de, 3276800
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_115coverageTrafficE
	push	hl
	call	__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	de, 174
	ld	iy, 0
	.local	.LBB36_84
.LBB36_84:                              ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jr	z, .LBB36_86
; %bb.85:                               ;   in Loop: Header=BB36_84 Depth=1
	lea	bc, iy + 0
	ld	hl, __ZN12_GLOBAL__N_115coverageTrafficE
	add	hl, bc
	ld	(hl), 0
	ld	bc, 29
	add	iy, bc
	jr	.LBB36_84
	.local	.LBB36_86
.LBB36_86:
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 2
	push	hl
	ld	hl, -15233
	push	hl
	call	__ZN2fs6read16Etm
	pop	de
	pop	de
	pop	de
	ld	d, 0
	ld	e, h
	or	a, a
	sbc	hl, hl
	ld	l, e
	ld	h, d
	ld	(ix - 16), hl
	sbc	hl, hl
	push	hl
	ld	hl, 8
	push	hl
	ld	hl, -15233
	push	hl
	call	__ZN2fs6read16Etm
	pop	de
	pop	de
	pop	de
	ld.sis	de, -1552
	or	a, a
	sbc.sis	hl, de
	jr	z, .LBB36_88
; %bb.87:
	ld	a, 0
	jr	.LBB36_89
	.local	.LBB36_88
.LBB36_88:
	ld	a, -1
	.local	.LBB36_89
.LBB36_89:
	ld	de, 13
	ld	bc, -185
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a
	and	a, 1
	ld	(ix - 7), a
	or	a, a
	sbc	hl, hl
	push	hl
	push	de
	ld	hl, -15233
	push	hl
	call	__ZN2fs6read16Etm
	ld	e, l
	ld	d, h
	pop	hl
	pop	hl
	pop	hl
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	bc
	ld	b, a
	ld	c, e
	ld	(ix - 13), bc
	ld	de, -185
	lea	iy, ix + 0
	add	iy, de
	bit	0, (iy + 0)                     ; 1-byte Folded Reload
	jr	nz, .LBB36_91
; %bb.90:
	ld	hl, 51
	ld	de, -167
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	.local	.LBB36_91
.LBB36_91:
	ld	de, -167
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	add	hl, bc
	ld	(ix - 10), hl
	ld	hl, __ZN12_GLOBAL__N_15crashE
	ld.sis	de, 150
	ld	(hl), e
	inc	hl
	ld	(hl), d
	or	a, a
	sbc	hl, hl
	ld	(__ZN12_GLOBAL__N_16motionE+11), hl
	xor	a, a
	ld	(__ZN12_GLOBAL__N_16motionE+14), a
	ld	(__ZN12_GLOBAL__N_16motionE+19), hl
	ld	(__ZN12_GLOBAL__N_16motionE+22), a
	ld	bc, (ix - 10)
	push	bc
	pop	iy
	lea	hl, iy + 0
	ld	de, -6
	add	hl, de
	push	ix
	ld	de, -233
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, 6
	add	iy, de
	ld	a, (ix - 7)
	or	a, a
	jp	z, .LBB36_93
; %bb.92:
	ld.sis	hl, -1552
                                        ; kill: def $hl killed $hl def $uhl
	push	ix
	ld	de, -170
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	.local	.LBB36_93
.LBB36_93:
	ld	hl, (ix - 16)
	push	ix
	ld	de, -236
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (ix - 13)
	push	ix
	ld	de, -239
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, 272
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), bc
	push	ix
	ld	bc, -224
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -227
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -167
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, (ix - 3)
	.local	.LBB36_94
.LBB36_94:                              ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB36_110 Depth 2
	ld	a, (__ZN2fs7healthyE)
	and	a, 1
	ld	(ix - 3), bc
	push	ix
	ld	bc, -185
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	or	a, a
	sbc	hl, de
	ld	bc, (ix - 3)
	jp	nc, .LBB36_120
; %bb.95:                               ;   in Loop: Header=BB36_94 Depth=1
	bit	0, a
	jp	z, .LBB36_120
; %bb.96:                               ;   in Loop: Header=BB36_94 Depth=1
	ld	de, -245
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	ld	de, -242
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	call	__ZN12_GLOBAL__N_110prepareSkyEv
	call	__ZN2fs6renderEv
	ld	hl, 239
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 104
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, 1
	push	hl
	ld	hl, -15235
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	hl, 223
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 24
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, 1
	push	hl
	ld	hl, -15234
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_15crashE
	ld	hl, (hl)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	nz, .LBB36_99
; %bb.97:                               ;   in Loop: Header=BB36_94 Depth=1
	ld	hl, __ZN12_GLOBAL__N_15crashE+2
	ld	hl, (hl)
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	z, .LBB36_100
; %bb.98:                               ;   in Loop: Header=BB36_94 Depth=1
                                        ; kill: def $hl killed $hl killed $uhl
	ld.sis	bc, 10
	call	__sdivu
	ld.sis	bc, 1
	call	__sand
	ld	de, 0
	ld	e, l
	ld	d, h
	ld	(ix - 3), bc
	ld	bc, -227
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	add	hl, de
	ld	de, -227
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	bc, (ix - 3)
	jr	.LBB36_100
	.local	.LBB36_99
.LBB36_99:                              ;   in Loop: Header=BB36_94 Depth=1
	ld	bc, -224
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	inc	hl
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	.local	.LBB36_100
.LBB36_100:                             ;   in Loop: Header=BB36_94 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_16motionE+11)
	ld	a, (__ZN12_GLOBAL__N_16motionE+14)
	ld	e, a
	ld	bc, __ZN12_GLOBAL__N_14sendEPKhj
	push	bc
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16engineE
	push	hl
	call	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_15crashE
	ld	bc, (hl)
	ld	l, c
	ld	h, b
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	nz, .LBB36_104
; %bb.101:                              ;   in Loop: Header=BB36_94 Depth=1
	ld	hl, __ZN12_GLOBAL__N_15crashE+2
	ld	hl, (hl)
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	z, .LBB36_103
; %bb.102:                              ;   in Loop: Header=BB36_94 Depth=1
                                        ; kill: def $hl killed $hl killed $uhl
	ld.sis	bc, 10
	call	__sdivu
	ld.sis	bc, 1
	call	__sand
	bit	0, l
	jp	nz, .LBB36_117
	.local	.LBB36_103
.LBB36_103:                             ;   in Loop: Header=BB36_94 Depth=1
	ld	bc, -236
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	bc, -170
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 1
	push	hl
	call	_vdp_adv_use_affine_matrix
	pop	hl
	pop	hl
	ld	hl, 154
	push	hl
	ld	bc, -239
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_vdp_draw_bitmap
	pop	hl
	pop	hl
	scf
	sbc	hl, hl
	push	hl
	ld	hl, 1
	push	hl
	call	_vdp_adv_use_affine_matrix
	pop	hl
	pop	hl
	jp	.LBB36_117
	.local	.LBB36_104
.LBB36_104:                             ;   in Loop: Header=BB36_94 Depth=1
	ld	de, 0
	ld	e, c
	ld	d, b
	ld	hl, 150
	or	a, a
	sbc	hl, de
	ld	(ix - 3), de
	ld	de, -230
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	l, c
	ld	h, b
	ld.sis	bc, 91
	or	a, a
	sbc.sis	hl, bc
	ld	de, (ix - 3)
	jr	c, .LBB36_106
; %bb.105:                              ;   in Loop: Header=BB36_94 Depth=1
	ld	de, -230
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	bc, 3
	call	__idivs
	push	hl
	pop	iy
	jr	.LBB36_107
	.local	.LBB36_106
.LBB36_106:                             ;   in Loop: Header=BB36_94 Depth=1
	ld	hl, 90
	or	a, a
	sbc	hl, de
	ld	bc, -5
	call	__idivs
	push	hl
	pop	iy
	ld	de, 20
	add	iy, de
	.local	.LBB36_107
.LBB36_107:                             ;   in Loop: Header=BB36_94 Depth=1
	lea	hl, iy + 0
	ld	de, -3
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB36_109
; %bb.108:                              ;   in Loop: Header=BB36_94 Depth=1
	ld	iy, -4
	.local	.LBB36_109
.LBB36_109:                             ;   in Loop: Header=BB36_94 Depth=1
	ld	bc, 8
	add	iy, bc
	ld	de, -266
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	ld	(ix - 3), bc
	ld	bc, -230
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	pop	hl
	ld	bc, (ix - 3)
	call	__idivs
	ld	(ix - 3), bc
	push	ix
	ld	bc, -269
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ex	de, hl
	ld	bc, (ix - 3)
	ld	bc, 6
	call	__idivs
	push	hl
	pop	de
	ld	hl, ___const._ZN12_GLOBAL__N_110drawPlayerEv.dx
	ld	(ix - 3), bc
	push	ix
	ld	bc, -248
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	hl, ___const._ZN12_GLOBAL__N_110drawPlayerEv.dy
	push	ix
	ld	bc, -251
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, -257
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	or	a, a
	sbc	hl, hl
	push	ix
	ld	bc, -230
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, (ix - 3)
	.local	.LBB36_110
.LBB36_110:                             ;   Parent Loop BB36_94 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	bc, -260
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ex	de, hl
	ld	bc, 3
	call	__idivu
	call	__imulu
	ld	(ix - 3), bc
	ld	bc, -257
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	or	a, a
	sbc	hl, de
	push	ix
	ld	de, -263
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	de, -230
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	ld	bc, (ix - 3)
	ld	bc, 8
	or	a, a
	sbc	hl, bc
	jp	z, .LBB36_116
; %bb.111:                              ;   in Loop: Header=BB36_110 Depth=2
	ld	bc, -248
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	bc, -266
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	pop	bc
	call	__imulu
	ld	iy, 10
	lea	bc, iy + 0
	call	__idivs
	ld	(ix - 3), de
	push	ix
	ld	de, -242
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	add	hl, bc
	push	ix
	ld	bc, -254
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, -251
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, (ix - 3)
	push	de
	pop	bc
	call	__imulu
	lea	bc, iy + 0
	call	__idivs
	push	hl
	pop	iy
	ld	bc, 193
	add	iy, bc
	push	ix
	ld	de, -269
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	de, -230
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	add	hl, bc
	ld	bc, 6
	call	__irems
	ld	bc, 3
	add	hl, bc
	push	hl
	pop	bc
	ld	(ix - 3), bc
	ld	bc, -254
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	push	de
	pop	hl
	ld	bc, (ix - 3)
	or	a, a
	sbc	hl, bc
	ld	(ix - 3), de
	push	ix
	ld	de, -272
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	push	ix
	ld	de, -275
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, (ix - 3)
	ex	de, hl
	add	hl, bc
	push	ix
	ld	de, -254
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	add	iy, bc
	ld	de, -230
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	bc, 1
	call	__iand
	bit	0, l
	ld	bc, 9
	jr	z, .LBB36_113
; %bb.112:                              ;   in Loop: Header=BB36_110 Depth=2
	ld	bc, 11
	.local	.LBB36_113
.LBB36_113:                             ;   in Loop: Header=BB36_110 Depth=2
	ld	de, -263
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	(ix - 3), bc
	push	ix
	ld	bc, -230
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
	or	a, a
	sbc	hl, de
	ld	hl, 15
	ld	bc, (ix - 3)
	jr	z, .LBB36_115
; %bb.114:                              ;   in Loop: Header=BB36_110 Depth=2
	push	bc
	pop	hl
	.local	.LBB36_115
.LBB36_115:                             ;   in Loop: Header=BB36_110 Depth=2
	push	hl
	push	iy
	ld	bc, -254
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -275
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -272
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally6Stream4rectEiiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -230
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	inc	hl
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	bc, -260
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	inc	de
	push	ix
	ld	bc, -251
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	lea	iy, iy + 3
	push	ix
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	bc, -248
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	lea	iy, iy + 3
	push	ix
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	jp	.LBB36_110
	.local	.LBB36_116
.LBB36_116:                             ;   in Loop: Header=BB36_94 Depth=1
	ld	hl, 15
	push	hl
	ld	hl, 199
	push	hl
	ld	bc, -245
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 187
	push	hl
	ld	bc, -233
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally6Stream4rectEiiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	.local	.LBB36_117
.LBB36_117:                             ;   in Loop: Header=BB36_94 Depth=1
	ld	hl, 239
	push	hl
	ld	hl, 319
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	call	__ZN12_GLOBAL__N_17drawHudEm
	call	__ZN12_GLOBAL__N_16bottomEv
	call	_vdp_swap
	ld	hl, (__ZN12_GLOBAL__N_114sceneryHistoryE+8)
	ld	de, 1
	push	de
	pop	bc
	call	__ixor
	ld	(__ZN12_GLOBAL__N_114sceneryHistoryE+8), hl
	call	__ZN2fs5fenceEv
	ld	bc, -185
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 1
	push	hl
	call	__ZN12_GLOBAL__N_17captureEjj
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_115coverageTrafficE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16motionE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_15crashE
	push	hl
	call	__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_15crashE
	ld	hl, (hl)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	ld	l, -1
	jr	z, .LBB36_119
; %bb.118:                              ;   in Loop: Header=BB36_94 Depth=1
	ld	l, 0
	.local	.LBB36_119
.LBB36_119:                             ;   in Loop: Header=BB36_94 Depth=1
	and	a, l
	ld	l, a
	ld	bc, 1
	call	__iand
	push	hl
	pop	de
	ld	(ix - 3), bc
	ld	bc, -167
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	add	hl, de
	push	ix
	ld	de, -167
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -185
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	inc	hl
	ld	bc, (ix - 3)
	push	ix
	ld	de, -242
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -245
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	de, 272
	jp	.LBB36_94
	.local	.LBB36_120
.LBB36_120:
	ld	de, __ZN12_GLOBAL__N_16motionE
	ld	bc, -164
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, 31
	ldir
	ld	bc, -203
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	(__ZN12_GLOBAL__N_15crashE), hl
	ld	bc, -221
	lea	hl, ix + 0
	add	hl, bc
	ld	a, (hl)                         ; 1-byte Folded Reload
	ld	(__ZN12_GLOBAL__N_15crashE+3), a
	ld	de, __ZN12_GLOBAL__N_15rulesE
	ld	bc, -161
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	ld	bc, 65
	ldir
	ld	bc, -200
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	(__ZN2fs11scrollCallsE), hl
	ld	bc, -215
	lea	hl, ix + 0
	add	hl, bc
	ld	a, (hl)                         ; 1-byte Folded Reload
	ld	(__ZN2fs11scrollCallsE+3), a
	push	ix
	ld	bc, -197
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	ld	(__ZN2fs12repaintCallsE), hl
	ld	bc, -212
	lea	hl, ix + 0
	add	hl, bc
	ld	a, (hl)                         ; 1-byte Folded Reload
	ld	(__ZN2fs12repaintCallsE+3), a
	push	ix
	ld	bc, -188
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	ld	(__ZN2fs14skyRepairCallsE), hl
	ld	bc, -209
	lea	hl, ix + 0
	add	hl, bc
	ld	a, (hl)                         ; 1-byte Folded Reload
	ld	(__ZN2fs14skyRepairCallsE+3), a
	ld	hl, _.str.25
	push	hl
	ld	hl, _.str.39
	push	hl
	call	_fopen
	push	hl
	pop	de
	pop	hl
	pop	hl
	push	de
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB36_124
; %bb.121:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	ld	hl, _.str.67
	jr	z, .LBB36_123
; %bb.122:
	ld	hl, _.str.66
	.local	.LBB36_123
.LBB36_123:
	push	hl
	ld	bc, -167
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -227
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -224
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.65
	push	hl
	push	de
	ld	bc, -161
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	call	_fprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -161
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	.local	.LBB36_124
.LBB36_124:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB36_54
; %bb.125:
	ld	a, (__ZN12_GLOBAL__N_16engineE)
	bit	0, a
	jr	z, .LBB36_127
; %bb.126:
	ld	bc, -146
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	ld	hl, ___const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute
	ld	iy, 6
	lea	bc, iy + 0
	ldir
	push	iy
	ld	bc, -146
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	xor	a, a
	ld	(__ZN12_GLOBAL__N_16engineE), a
	.local	.LBB36_127
.LBB36_127:
	call	__ZN2fs4stopEv
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB36_54
; %bb.128:
	call	__ZN12_GLOBAL__N_115releaseGraphicsEv
	call	__ZN12_GLOBAL__N_111restoreTextEv
	ld	hl, 406
	push	hl
	ld	hl, __ZN12_GLOBAL__N_110finalStateE
	push	hl
	ld	hl, _.str.33
	push	hl
	call	__ZN2fs4saveEPKcPKvj
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	jp	z, .LBB36_143
; %bb.129:
	ld	hl, (__ZN2fs10frameCountE)
	ld	c, 2
	call	__ishl
	ld	de, 4
	add	hl, de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_15timesE
	push	hl
	ld	hl, _.str.34
	push	hl
	call	__ZN2fs4saveEPKcPKvj
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	jp	z, .LBB36_143
; %bb.130:
	ld	hl, (__ZN2fs10frameCountE)
	ld	c, 2
	call	__ishl
	ld	de, 4
	add	hl, de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_14prtsE
	push	hl
	ld	hl, _.str.35
	push	hl
	call	__ZN2fs4saveEPKcPKvj
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	jp	z, .LBB36_143
; %bb.131:
	ld	hl, (__ZN2fs15transcriptBytesE)
	push	hl
	ld	hl, __ZN2fs10transcriptE
	push	hl
	ld	hl, _.str.36
	push	hl
	call	__ZN2fs4saveEPKcPKvj
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	jp	z, .LBB36_143
; %bb.132:
	ld	hl, _.str.25
	push	hl
	ld	hl, _.str.37
	push	hl
	call	_fopen
	pop	de
	pop	de
	push	hl
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB36_143
; %bb.133:
	ld	hl, (ix - 36)
	ld	bc, -161
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, (ix - 33)
	ld	hl, (ix - 32)
	push	ix
	ld	bc, -164
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	c, (ix - 29)
	ld	hl, (ix - 28)
	push	af
	ld	a, (ix - 25)
	ld	iyl, a
	pop	af
	push	iy
	push	hl
	ld	(ix - 3), de
	ld	de, -155
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -152
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	l, c
	push	hl
	ld	bc, -164
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	l, a
	push	hl
	ld	bc, -161
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -194
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -191
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -179
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -176
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.68
	push	hl
	ld	de, (ix - 3)
	ld	bc, -167
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	push	de
	call	_fprintf
	ld	hl, 42
	add	hl, sp
	ld	sp, hl
	ld	bc, -167
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB36_143
; %bb.134:
	ld	hl, _.str.25
	push	hl
	ld	hl, _.str.38
	push	hl
	call	_fopen
	pop	de
	pop	de
	ld	bc, -161
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB36_143
; %bb.135:
	ld	hl, (__ZN12_GLOBAL__N_16motionE+7)
	ld	bc, -164
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, (__ZN12_GLOBAL__N_16motionE+10)
	ld	l, a
	push	ix
	ld	bc, -167
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_16motionE+3)
	push	ix
	ld	bc, -170
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_16motionE+6)
	ld	l, a
	push	ix
	ld	bc, -176
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_16motionE+11)
	push	ix
	ld	bc, -179
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_16motionE+14)
	ld	l, a
	push	ix
	ld	bc, -185
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_16motionE+15)
	push	ix
	ld	bc, -188
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_16motionE+18)
	ld	l, a
	push	ix
	ld	bc, -191
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	hl, __ZN12_GLOBAL__N_16motionE+23
	ld	de, (hl)
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	bc
	ld	b, a
	ld	c, e
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+11)
	push	ix
	ld	de, -194
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_15rulesE+14)
	ld	l, a
	push	ix
	ld	de, -197
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+39)
	push	ix
	ld	de, -200
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_15rulesE+42)
	ld	l, a
	push	ix
	ld	de, -203
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+19)
	push	ix
	ld	de, -209
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_15rulesE+22)
	ld	iyl, a
	ld	a, (__ZN12_GLOBAL__N_15rulesE+61)
	ld	de, 0
	ld	e, a
	ld	a, (__ZN12_GLOBAL__N_15rulesE+59)
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), bc
	push	ix
	ld	bc, -212
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	l, a
	push	hl
	push	de
	push	iy
	ld	de, -209
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -203
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -200
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -197
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -194
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	bc, (ix - 3)
	push	bc
	ld	bc, -191
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -188
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -185
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -179
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -176
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -170
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -167
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -164
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.69
	push	hl
	ld	bc, -161
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fprintf
	ld	hl, 57
	add	hl, sp
	ld	sp, hl
	ld	bc, -161
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB36_143
; %bb.136:
	ld	hl, _.str.25
	push	hl
	ld	hl, _.str.32
	push	hl
	call	_fopen
	pop	de
	pop	de
	ld	bc, -161
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB36_143
; %bb.137:
	ld	hl, (__ZN2fs10frameCountE)
	ld	c, 2
	ld	de, -167
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	call	__ishl
	push	ix
	ld	de, -170
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	or	a, a
	sbc	hl, hl
	push	ix
	ld	de, -164
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN2fs11scrollCallsE)
	push	ix
	ld	de, -176
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs11scrollCallsE+3)
	ld	l, a
	push	ix
	ld	de, -179
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN2fs12repaintCallsE)
	push	ix
	ld	de, -185
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs12repaintCallsE+3)
	ld	l, a
	push	ix
	ld	de, -188
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN2fs14skyRepairCallsE)
	push	ix
	ld	de, -191
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs14skyRepairCallsE+3)
	ld	l, a
	push	ix
	ld	de, -194
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN2fs8hudBytesE)
	push	ix
	ld	de, -197
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs8hudBytesE+3)
	ld	l, a
	push	ix
	ld	de, -200
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN2fs11footerCallsE)
	push	ix
	ld	de, -203
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs11footerCallsE+3)
	ld	l, a
	push	ix
	ld	de, -209
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_112audioChangesE)
	push	ix
	ld	de, -215
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_112audioChangesE+3)
	ld	l, a
	push	ix
	ld	de, -221
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_112finishFramesE)
	push	ix
	ld	de, -224
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_112finishFramesE+3)
	ld	l, a
	push	ix
	ld	de, -227
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_110inputPollsE)
	push	ix
	ld	de, -230
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN12_GLOBAL__N_110inputPollsE+3)
	ld	l, a
	push	ix
	ld	de, -233
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (ix - 24)
	push	ix
	ld	de, -236
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (ix - 21)
	ld	de, -239
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), a
	ld	hl, (ix - 20)
	push	ix
	ld	de, -242
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (ix - 17)
	ld	de, -245
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), a
	ld	hl, (ix - 28)
	push	ix
	ld	de, -248
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (ix - 25)
	ld	de, -251
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), a
	ld	hl, (__ZN2fs15transcriptBytesE)
	push	ix
	ld	de, -254
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	bc, 10
	call	__idivu
	push	ix
	ld	de, -257
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (__ZN2fs13timerRestoredE)
	bit	0, a
	ld	hl, _.str.67
	jr	z, .LBB36_139
; %bb.138:
	ld	hl, _.str.66
	.local	.LBB36_139
.LBB36_139:
	ld	bc, -206
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	ix
	ld	bc, -212
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	ld	iyl, e
	ld	iyh, d
	push	ix
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	bc, -218
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	ld	(ix - 3), de
	push	ix
	ld	de, -164
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	ld	de, (ix - 3)
	ld	c, e
	ld	b, d
	push	ix
	ld	de, -164
	add	ix, de
	ld	(ix + 0), bc
	pop	ix
	ld	a, (__ZN2fs8unloadedE)
	bit	0, a
	jr	z, .LBB36_141
; %bb.140:
	ld	de, _.str.66
	ld	bc, -173
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), de
	.local	.LBB36_141
.LBB36_141:
	ld	bc, -173
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	ld	bc, -254
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -257
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -251
	lea	hl, ix + 0
	add	hl, bc
	ld	l, (hl)                         ; 1-byte Folded Reload
	push	hl
	ld	bc, -248
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -245
	lea	hl, ix + 0
	add	hl, bc
	ld	l, (hl)                         ; 1-byte Folded Reload
	push	hl
	ld	bc, -242
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -239
	lea	hl, ix + 0
	add	hl, bc
	ld	l, (hl)                         ; 1-byte Folded Reload
	push	hl
	ld	bc, -236
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -233
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -230
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -227
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -224
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -221
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -215
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -209
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -203
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -200
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -197
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -194
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -191
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -188
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -185
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -179
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -176
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -164
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -212
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -155
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -152
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -182
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -158
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -170
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -167
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.70
	push	hl
	ld	bc, -161
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fprintf
	ld	hl, 108
	add	hl, sp
	ld	sp, hl
	ld	bc, -161
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB36_143
; %bb.142:
	ld	hl, _str
	push	hl
	call	_puts
	pop	hl
	or	a, a
	sbc	hl, hl
	ld	bc, -149
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	jp	.LBB36_61
	.local	.LBB36_143
.LBB36_143:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB36_53
; %bb.144:
	ld	hl, _.str.27
	jp	.LBB36_52
	.local	.Lfunc_end36
.Lfunc_end36:
	.size	_main, .Lfunc_end36-_main
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_14fontEj,@function ; -- Begin function _ZN12_GLOBAL__N_14fontEj
__ZN12_GLOBAL__N_14fontEj:              ; @_ZN12_GLOBAL__N_14fontEj
; %bb.0:
	ld	hl, -7
	call	__frameset
	ld	de, (ix + 6)
	ld	hl, 7
	ld	(ix - 7), 23
	ld	(ix - 6), h
	ld	(ix - 5), -107
	ld	(ix - 4), h
	ld	a, e
	ld	(ix - 3), a
	ld	a, d
	ld	(ix - 2), a
	ld	(ix - 1), h
	push	hl
	pea	ix - 7
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end37
.Lfunc_end37:
	.size	__ZN12_GLOBAL__N_14fontEj, .Lfunc_end37-__ZN12_GLOBAL__N_14fontEj
                                        ; -- End function
	.weak	__ZN5rally4game6Engine5startIPFvPKhjEEEvT_ ; -- Begin function _ZN5rally4game6Engine5startIPFvPKhjEEEvT_
	.type	__ZN5rally4game6Engine5startIPFvPKhjEEEvT_,@function
__ZN5rally4game6Engine5startIPFvPKhjEEEvT_: ; @_ZN5rally4game6Engine5startIPFvPKhjEEEvT_
; %bb.0:
	ld	hl, -25
	call	__frameset
	ld	hl, ___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.setup
	lea	iy, ix - 16
	lea	de, ix - 22
	ld	(ix - 25), de
	lea	de, iy + 0
	ld	bc, 16
	ldir
	ld	hl, 16
	push	hl
	push	iy
	ld	hl, (ix + 9)
	call	__indcallhl
	pop	hl
	pop	hl
	ld	iy, (ix + 6)
	ld	(iy), 1
	ld	de, 0
	ld	(iy + 1), de
	ld	hl, (ix + 9)
	push	hl
	push	de
	push	de
	push	iy
	call	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	iy, (ix - 25)
	lea	de, iy + 0
	ld	hl, ___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.volume
	ld	bc, 6
	ldir
	ld	hl, 6
	push	hl
	push	iy
	ld	hl, (ix + 9)
	call	__indcallhl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end38
.Lfunc_end38:
	.size	__ZN5rally4game6Engine5startIPFvPKhjEEEvT_, .Lfunc_end38-__ZN5rally4game6Engine5startIPFvPKhjEEEvT_
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_14sendEPKhj,@function ; -- Begin function _ZN12_GLOBAL__N_14sendEPKhj
__ZN12_GLOBAL__N_14sendEPKhj:           ; @_ZN12_GLOBAL__N_14sendEPKhj
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	ld	(ix + 6), hl
	ld	(ix + 9), de
	pop	ix
	jp	__ZN2fs4sendEPKhj
	.local	.Lfunc_end39
.Lfunc_end39:
	.size	__ZN12_GLOBAL__N_14sendEPKhj, .Lfunc_end39-__ZN12_GLOBAL__N_14sendEPKhj
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_19warmLowerEv,@function ; -- Begin function _ZN12_GLOBAL__N_19warmLowerEv
__ZN12_GLOBAL__N_19warmLowerEv:         ; @_ZN12_GLOBAL__N_19warmLowerEv
; %bb.0:
	ld	iy, __ZN12_GLOBAL__N_16streamE
	ld	de, 0
	ld	bc, 319
	ld	hl, 239
	push	hl
	push	bc
	push	de
	push	de
	push	iy
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	de, 0
	push	de
	ld	hl, 239
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 224
	push	hl
	push	de
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally6Stream4rectEiiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	jp	__ZN12_GLOBAL__N_15flushEv
	.local	.Lfunc_end40
.Lfunc_end40:
	.size	__ZN12_GLOBAL__N_19warmLowerEv, .Lfunc_end40-__ZN12_GLOBAL__N_19warmLowerEv
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_15paintEv,@function ; -- Begin function _ZN12_GLOBAL__N_15paintEv
__ZN12_GLOBAL__N_15paintEv:             ; @_ZN12_GLOBAL__N_15paintEv
; %bb.0:
	ld	hl, -4
	call	__frameset
	call	__ZN12_GLOBAL__N_110prepareSkyEv
	call	__ZN2fs6renderEv
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB41_3
; %bb.1:
	ld	de, __ZN12_GLOBAL__N_16streamE
	ld	iy, 104
	ld	bc, 319
	ld	hl, 239
	push	hl
	push	bc
	push	iy
	or	a, a
	sbc	hl, hl
	push	hl
	push	de
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, 1
	push	hl
	ld	hl, -15235
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	hl, 223
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 24
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, 1
	push	hl
	ld	hl, -15234
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	hl, 1
	push	hl
	ld	hl, -15233
	push	hl
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	hl, 239
	push	hl
	ld	hl, 319
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, (__ZN2fs9wireBytesE)
	ld	(ix - 3), hl
	ld	iy, __ZN2fs9wireBytesE
	lea	hl, iy + 3
	ld	a, (hl)
	ld	(ix - 4), a
	call	__ZN12_GLOBAL__N_17drawHudEm
	ld	hl, (__ZN2fs9wireBytesE)
	ld	a, (__ZN2fs9wireBytesE+3)
	ld	e, a
	ld	bc, (ix - 3)
	ld	a, (ix - 4)                     ; 1-byte Folded Reload
	call	__lsub
	ld	bc, (__ZN2fs8hudBytesE)
	ld	iy, __ZN2fs8hudBytesE
	lea	iy, iy + 3
	ld	a, (iy)
	call	__ladd
	ld	a, e
	ld	(__ZN2fs8hudBytesE), hl
	ld	(__ZN2fs8hudBytesE+3), a
	call	__ZN12_GLOBAL__N_16bottomEv
	ld	hl, (__ZN2fs11footerCallsE)
	ld	iy, __ZN2fs11footerCallsE
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN2fs11footerCallsE), hl
	ld	(__ZN2fs11footerCallsE+3), a
	call	_vdp_swap
	ld	hl, (__ZN12_GLOBAL__N_114sceneryHistoryE+8)
	ld	bc, 1
	call	__ixor
	ld	(__ZN12_GLOBAL__N_114sceneryHistoryE+8), hl
	call	__ZN2fs5fenceEv
	ld	bc, (__ZN12_GLOBAL__N_16motionE+7)
	ld	a, (__ZN12_GLOBAL__N_16motionE+10)
	ld	hl, 3276800
	ld	e, h
	call	__lsub
	ld	bc, 3276800
	xor	a, a
	call	__lrems
	ld	bc, -6400
	dec	a
	call	__ladd
	ld	bc, 93700
	inc	a
	call	__lcmpu
	jr	nc, .LBB41_3
; %bb.2:
	ld	iy, __ZN12_GLOBAL__N_112finishFramesE
	ld	hl, (__ZN12_GLOBAL__N_112finishFramesE)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN12_GLOBAL__N_112finishFramesE), hl
	ld	(__ZN12_GLOBAL__N_112finishFramesE+3), a
	.local	.LBB41_3
.LBB41_3:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end41
.Lfunc_end41:
	.size	__ZN12_GLOBAL__N_15paintEv, .Lfunc_end41-__ZN12_GLOBAL__N_15paintEv
                                        ; -- End function
	.weak	__ZN5rally4game11RouteCursor4tickEv ; -- Begin function _ZN5rally4game11RouteCursor4tickEv
	.type	__ZN5rally4game11RouteCursor4tickEv,@function
__ZN5rally4game11RouteCursor4tickEv:    ; @_ZN5rally4game11RouteCursor4tickEv
; %bb.0:
	ld	hl, -7
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (iy + 1)
	ld	a, (iy)
	ld	de, 0
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB42_2
; %bb.1:
	ld.sis	bc, 6
	ld	h, b
	ld	l, a
	inc.sis	hl
	call	__sremu
	ex	de, hl
	ld	iyl, e
	ld	iyh, d
	ex	de, hl
	ld	a, iyl
	ld.sis	bc, 255
	call	__sand
	ld	e, l
	ld	d, h
	ld	hl, (ix + 6)
	ld	(hl), a
	or	a, a
	sbc	hl, hl
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld	c, 3
	call	__ishl
	push	hl
	pop	bc
	ld	iy, __ZN5rally4gameL5RouteE
	add	iy, bc
	ld	hl, (iy)
	lea	bc, iy + 0
	ld	iy, (ix + 6)
	ld	(iy + 1), l
	ld	(iy + 2), h
	push	bc
	pop	iy
	lea	hl, iy + 4
	jr	.LBB42_3
	.local	.LBB42_2
.LBB42_2:
	ld	e, a
	lea	hl, iy + 3
	.local	.LBB42_3
.LBB42_3:
	ld	hl, (hl)
	ld	(ix - 3), hl
	ld	c, 3
	ex	de, hl
	call	__ishl
	push	hl
	pop	de
	ld	iy, __ZN5rally4gameL5RouteE
	add	iy, de
	ld	de, (iy + 6)
	lea	bc, iy + 0
	ld	hl, (ix - 3)
	add.sis	hl, de
	ld	iy, (ix + 6)
	ld	(iy + 3), l
	ld	(iy + 4), h
	ex	de, hl
	push	bc
	pop	iy
	ld	hl, (iy + 2)
	ld	(ix - 3), hl
	ld	bc, 0
	ld	c, l
	ld	b, h
	xor	a, a
	ld	l, 1
	call	__lshl
	ld	(ix - 6), bc
	ld	(ix - 7), a                     ; 1-byte Folded Spill
	push	de
	call	__ZN5rally4game9routeSineEs
	ld	e, l
	ld	d, h
	pop	hl
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	bc
	ld	b, a
	ld	c, e
	push	bc
	pop	hl
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	iy
	ld	hl, (ix - 6)
	ld	e, (ix - 7)                     ; 1-byte Folded Reload
	ld	a, iyl
	call	__lmulu
	ld	bc, 12800
	xor	a, a
	call	__ldivs
	ld	a, e
	ld	iy, (ix + 6)
	lea	de, iy + 5
	ld	bc, (iy + 5)
	push	de
	pop	iy
	lea	iy, iy + 3
	ld	e, a
	ld	a, (iy)
	call	__ladd
	ld	iy, (ix + 6)
	ld	(iy + 5), hl
	ld	(iy + 8), e
	ld	hl, (iy + 1)
	dec.sis	hl
	ld	(iy + 1), l
	ld	(iy + 2), h
	ld	hl, (ix - 3)
                                        ; kill: def $hl killed $hl killed $uhl
	ld	c, 1
	call	__sshl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end42
.Lfunc_end42:
	.size	__ZN5rally4game11RouteCursor4tickEv, .Lfunc_end42-__ZN5rally4game11RouteCursor4tickEv
                                        ; -- End function
	.weak	__ZN5rally4game5Rules4tickEm    ; -- Begin function _ZN5rally4game5Rules4tickEm
	.type	__ZN5rally4game5Rules4tickEm,@function
__ZN5rally4game5Rules4tickEm:           ; @_ZN5rally4game5Rules4tickEm
; %bb.0:
	ld	hl, -34
	call	__frameset
	ld	hl, (ix + 6)
	ld	bc, 1
	xor	a, a
	push	hl
	pop	iy
	lea	de, iy + 11
	ld	hl, (iy + 11)
	push	de
	pop	iy
	lea	iy, iy + 3
	ld	e, (iy)
	ld	iy, (ix + 6)
	call	__ladd
	push	hl
	pop	bc
	ld	(iy + 11), hl
	ld	(iy + 14), e
	ld	hl, (iy + 57)
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	z, .LBB43_2
; %bb.1:
	dec.sis	hl
	ld	(iy + 57), l
	ld	(iy + 58), h
	.local	.LBB43_2
.LBB43_2:
	ld	d, (iy + 10)
	ld	a, d
	cp	a, 2
	jr	nz, .LBB43_6
	.local	.LBB43_3
.LBB43_3:
	ld	iy, 360
	push	bc
	pop	hl
	lea	bc, iy + 0
	xor	a, a
	call	__lcmpu
	jr	nz, .LBB43_16
; %bb.4:
	ld	a, d
	cp	a, 2
	jr	z, .LBB43_12
; %bb.5:
	ld	a, 6
	jr	.LBB43_13
	.local	.LBB43_6
.LBB43_6:
	ld	a, d
	cp	a, 4
	jr	nz, .LBB43_8
; %bb.7:
	ld	iy, 480
	push	bc
	pop	hl
	lea	bc, iy + 0
	xor	a, a
	call	__lcmpu
	ld	hl, (ix + 6)
	push	hl
	call	z, __ZN5rally4game5Rules9raceReadyEv
	pop	hl
	jr	.LBB43_16
	.local	.LBB43_8
.LBB43_8:
	ld	a, d
	cp	a, 5
	jr	z, .LBB43_3
; %bb.9:
	ld	a, d
	add	a, -7
	cp	a, 3
	jr	nc, .LBB43_17
; %bb.10:
	ld	iy, 1440
	push	bc
	pop	hl
	lea	bc, iy + 0
	xor	a, a
	call	__lcmpu
	jr	nz, .LBB43_16
; %bb.11:
	ld	iy, (ix + 6)
	ld	(iy + 10), 0
	jr	.LBB43_15
	.local	.LBB43_12
.LBB43_12:
	ld	a, 3
	.local	.LBB43_13
.LBB43_13:
	ld	iy, (ix + 6)
	.local	.LBB43_14
.LBB43_14:
	ld	(iy + 10), a
	.local	.LBB43_15
.LBB43_15:
	or	a, a
	sbc	hl, hl
	ld	(iy + 11), hl
	ld	(iy + 14), h
	ld	hl, (iy + 55)
	inc.sis	hl
	ld	(iy + 55), l
	ld	(iy + 56), h
	.local	.LBB43_16
.LBB43_16:
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB43_17
.LBB43_17:
	ld	a, d
	cp	a, 3
	jr	z, .LBB43_19
; %bb.18:
	ld	a, d
	cp	a, 6
	jr	nz, .LBB43_16
	.local	.LBB43_19
.LBB43_19:
	ld	iy, (ix + 6)
	lea	bc, iy + 15
	ld	iy, (ix + 6)
	ld	hl, (iy + 15)
	push	bc
	pop	iy
	lea	iy, iy + 3
	ld	e, (iy)
	ld	iy, (ix + 6)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	(ix - 15), hl
	ld	(iy + 15), hl
	ld	(ix - 16), e                    ; 1-byte Folded Spill
	ld	(iy + 18), e
	ld	hl, (iy + 19)
	ld	e, (iy + 22)
	call	__lcmpzero
	dec	bc
	jr	z, .LBB43_21
; %bb.20:
	ld	bc, -1
	ld	a, b
	call	__ladd
	push	hl
	pop	bc
	ld	a, e
	ld	(iy + 19), bc
	ld	(iy + 22), a
	.local	.LBB43_21
.LBB43_21:
	ld	(ix - 28), a
	ld	(ix - 27), bc
	lea	bc, iy + 43
	ld	hl, (iy + 43)
	push	bc
	pop	iy
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix + 9)
	ld	a, (ix + 12)
	call	__ladd
	ld	(ix - 19), hl
	ld	iy, (ix + 6)
	ld	(iy + 43), hl
	ld	(ix - 20), e                    ; 1-byte Folded Spill
	ld	(iy + 46), e
	lea	hl, iy + 51
	ld	bc, (iy + 51)
	push	hl
	pop	iy
	lea	iy, iy + 3
	push	bc
	pop	hl
	ld	e, (iy)
	ld	bc, (ix + 9)
	call	__ladd
	ld	(ix - 23), hl
	ld	(ix - 24), e                    ; 1-byte Folded Spill
	ld	bc, 1600
	xor	a, a
	call	__ldivu
	ld	(ix - 3), hl
	ld	(ix - 6), e                     ; 1-byte Folded Spill
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	lea	bc, iy + 39
	ld	hl, (iy + 39)
	ld	(ix - 9), hl
	push	bc
	pop	iy
	lea	hl, iy + 3
	ld	(ix - 34), hl
	ld	l, (hl)
	ld	(ix - 12), l
	ld	iy, -6777217
	lea	hl, iy + 0
	ld	e, a
	ld	bc, (ix - 9)
	ld	a, (ix - 12)                    ; 1-byte Folded Reload
	call	__lsub
	ld	bc, (ix - 3)
	push	af
	ld	a, (ix - 6)                     ; 1-byte Folded Reload
	ld	iyl, a
	pop	af
	ld	a, iyl
	call	__lcmpu
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	iyh, a
	inc	iyh
	ld	hl, (ix - 9)
	ld	e, (ix - 12)                    ; 1-byte Folded Reload
	ld	a, iyl
	call	__ladd
	ld	a, iyh
	bit	0, a
	ld	iy, -6777217
	lea	bc, iy + 0
	jr	nz, .LBB43_23
; %bb.22:
	push	hl
	pop	bc
	.local	.LBB43_23
.LBB43_23:
	ld	(ix - 9), bc
	ld	(ix - 31), iy
	bit	0, a
	ld	a, 0
	jr	nz, .LBB43_25
; %bb.24:
	ld	a, e
	.local	.LBB43_25
.LBB43_25:
	ld	(ix - 12), a
	ld	iy, (ix + 6)
	ld	hl, (ix - 9)
	ld	(iy + 39), hl
	ld	(iy + 42), a
	ld	hl, (ix - 3)
	ld	e, (ix - 6)                     ; 1-byte Folded Reload
	ld	bc, 1600
	xor	a, a
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 23)
	ld	e, (ix - 24)                    ; 1-byte Folded Reload
	call	__lsub
	ld	(iy + 51), hl
	ld	(iy + 54), e
	ld	a, (iy + 59)
	ld	bc, 0
	ld	(ix - 3), a                     ; 1-byte Folded Spill
	ld	c, a
	inc	bc
	xor	a, a
	ld	hl, (iy + 47)
	ld	e, (iy + 50)
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 19)
	ld	e, (ix - 20)                    ; 1-byte Folded Reload
	call	__lcmpu
	jr	nc, .LBB43_30
; %bb.26:
	ld	hl, (ix - 27)
	ld	e, (ix - 28)                    ; 1-byte Folded Reload
	.local	.LBB43_27
.LBB43_27:
	call	__lcmpzero
	jp	nz, .LBB43_16
; %bb.28:
	ld	a, d
	cp	a, 3
	jp	z, .LBB43_49
; %bb.29:
	ld	a, 8
	jp	.LBB43_14
	.local	.LBB43_30
.LBB43_30:
	ld	a, (ix - 3)                     ; 1-byte Folded Reload
	inc	a
	ld	(ix - 3), a                     ; 1-byte Folded Spill
	ld	(iy + 59), a
	ld	iy, (ix + 6)
	lea	hl, iy + 23
	ld	iy, (ix + 6)
	ld	bc, (iy + 23)
	push	hl
	pop	iy
	lea	iy, iy + 3
	ld	hl, (ix - 15)
	ld	e, (ix - 16)                    ; 1-byte Folded Reload
	ld	a, (iy)
	ld	iy, (ix + 6)
	call	__lsub
	ld	(ix - 6), hl
	ld	(iy + 27), hl
	ld	(ix - 19), e                    ; 1-byte Folded Spill
	ld	(iy + 30), e
	ld	hl, (ix - 15)
	ld	(iy + 23), hl
	ld	a, (ix - 16)
	ld	(iy + 26), a
	ld	bc, (iy + 31)
	ld	a, (iy + 34)
	push	bc
	pop	hl
	ld	e, a
	call	__lcmpzero
	jr	z, .LBB43_32
; %bb.31:
	ld	hl, (ix - 6)
	ld	e, (ix - 19)                    ; 1-byte Folded Reload
	call	__lcmpu
	jr	nc, .LBB43_33
	.local	.LBB43_32
.LBB43_32:
	ld	hl, (ix - 6)
	ld	(iy + 31), hl
	ld	a, (ix - 19)
	ld	(iy + 34), a
	.local	.LBB43_33
.LBB43_33:
	ld	hl, (ix - 9)
	push	af
	ld	a, (ix - 12)                    ; 1-byte Folded Reload
	ld	iyh, a
	pop	af
	ld	e, iyh
	ld	bc, 6778216
	ld	a, -1
	call	__ladd
	ld	bc, 1000
	ld	iyl, 0
	ld	a, iyl
	call	__lcmpu
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	iyl, a
	inc	iyl
	ld	hl, (ix - 9)
	ld	e, iyh
	xor	a, a
	call	__ladd
	ld	c, iyl
	bit	0, c
	ld	bc, -6777217
	jr	nz, .LBB43_35
; %bb.34:
	push	hl
	pop	bc
	.local	.LBB43_35
.LBB43_35:
	ex	de, hl
	ld	e, iyl
	ex	de, hl
	bit	0, l
	jr	nz, .LBB43_37
; %bb.36:
	ld	a, e
	.local	.LBB43_37
.LBB43_37:
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	ld	(iy + 39), bc
	ld	(iy + 42), a
	ld	l, a
	ld	a, d
	cp	a, 3
	jp	nz, .LBB43_43
; %bb.38:
	ld	de, (ix - 15)
	ld	(iy + 35), de
	ld	a, (ix - 16)                    ; 1-byte Folded Reload
	ld	(iy + 38), a
	ld	l, a
	push	hl
	push	de
	push	iy
	call	__ZNK5rally4game5Rules14qualifyingGridEm
	ld	de, 0
	ld	e, a
	pop	hl
	pop	hl
	pop	hl
	ld	iy, (ix + 6)
	ld	(iy + 60), e
	ld	(iy + 61), e
	ld	hl, 8
	or	a, a
	sbc	hl, de
	ld	bc, 500
	call	__imulu
	ld	(ix - 12), hl
	push	hl
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	(ix - 3), hl
	ld	iy, (ix + 6)
	ld	bc, (iy + 39)
	ld	(ix - 9), bc
	ld	hl, (ix - 34)
	ld	a, (hl)
	ld	(ix - 6), a
	ld	hl, -6777217
	ld	e, d
	call	__lsub
	ld	bc, (ix - 12)
	ld	iy, (ix - 3)
	ld	a, iyl
	call	__lcmpu
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	d, a
	inc	d
	ld	hl, (ix - 9)
	ld	e, (ix - 6)                     ; 1-byte Folded Reload
	ld	iy, (ix - 3)
	ld	a, iyl
	call	__ladd
	bit	0, d
	ld	iy, (ix + 6)
	jr	nz, .LBB43_40
; %bb.39:
	ld	(ix - 31), hl
	.local	.LBB43_40
.LBB43_40:
	bit	0, d
	ld	a, 0
	jr	nz, .LBB43_42
; %bb.41:
	ld	a, e
	.local	.LBB43_42
.LBB43_42:
	ld	hl, (ix - 31)
	ld	(iy + 39), hl
	ld	(iy + 42), a
	ld	(iy + 10), 4
	jp	.LBB43_15
	.local	.LBB43_43
.LBB43_43:
	ld	(ix - 6), l                     ; 1-byte Folded Spill
	ld	(ix - 9), bc
	ld	bc, 120
	ld	l, (iy + 8)
	ld	a, (ix - 3)                     ; 1-byte Folded Reload
	cp	a, l
	jp	nz, .LBB43_50
; %bb.44:
	ld	iy, 100
	ld	hl, (ix - 27)
	ld	e, (ix - 28)                    ; 1-byte Folded Reload
	xor	a, a
	call	__ldivu
	lea	bc, iy + 0
	call	__lmulu
	ld	(ix - 3), hl
	ld	d, e
	ld	(ix - 12), d
	ld	iy, -6777217
	lea	hl, iy + 0
	ld	e, a
	ld	iy, (ix - 9)
	lea	bc, iy + 0
	ld	a, (ix - 6)                     ; 1-byte Folded Reload
	call	__lsub
	ld	bc, (ix - 3)
	ld	a, d
	call	__lcmpu
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	d, a
	inc	d
	push	bc
	pop	hl
	ld	e, (ix - 12)                    ; 1-byte Folded Reload
	lea	bc, iy + 0
	ld	a, (ix - 6)                     ; 1-byte Folded Reload
	call	__ladd
	ld	bc, -6777217
	bit	0, d
	jr	nz, .LBB43_46
; %bb.45:
	push	hl
	pop	bc
	.local	.LBB43_46
.LBB43_46:
	push	bc
	pop	hl
	bit	0, d
	ld	iy, (ix + 6)
	ld	a, 0
	jr	nz, .LBB43_48
; %bb.47:
	ld	a, e
	.local	.LBB43_48
.LBB43_48:
	ld	(iy + 39), hl
	ld	(iy + 42), a
	ld	(iy + 10), 7
	jp	.LBB43_15
	.local	.LBB43_49
.LBB43_49:
	ld	a, 9
	jp	.LBB43_14
	.local	.LBB43_50
.LBB43_50:
	ld	a, d
	ld	de, (iy + 6)
	or	a, a
	sbc	hl, hl
	ld	l, e
	ld	h, d
	ld	d, a
	ld	e, 0
	xor	a, a
	call	__lmulu
	ld	bc, (ix - 27)
	ld	a, (ix - 28)                    ; 1-byte Folded Reload
	call	__ladd
	ld	(iy + 19), hl
	ld	(iy + 22), e
	ld.sis	bc, 240
	ld	(iy + 57), c
	ld	(iy + 58), b
	jp	.LBB43_27
	.local	.Lfunc_end43
.Lfunc_end43:
	.size	__ZN5rally4game5Rules4tickEm, .Lfunc_end43-__ZN5rally4game5Rules4tickEm
                                        ; -- End function
	.weak	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_ ; -- Begin function _ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
	.type	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_,@function
__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_: ; @_ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
; %bb.0:
	ld	hl, -10
	call	__frameset
	ld	iy, (ix + 6)
	ld	d, 0
	or	a, a
	sbc	hl, hl
	bit	0, (iy)
	jp	z, .LBB44_12
; %bb.1:
	ld	iy, (ix + 9)
	ld	a, (ix + 12)
	ld	e, d
	lea	bc, iy + 0
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB44_3
; %bb.2:
	ld	e, 0
	jr	.LBB44_4
	.local	.LBB44_3
.LBB44_3:
	ld	e, 1
	.local	.LBB44_4
.LBB44_4:
	bit	0, e
	jr	nz, .LBB44_6
; %bb.5:
	push	hl
	pop	iy
	.local	.LBB44_6
.LBB44_6:
	ld	bc, 300
	bit	0, e
	jr	nz, .LBB44_8
; %bb.7:
	ld	a, d
	.local	.LBB44_8
.LBB44_8:
	lea	hl, iy + 0
	ld	e, a
	ld	a, d
	call	__lcmpu
	jr	c, .LBB44_10
; %bb.9:
	push	bc
	pop	iy
	.local	.LBB44_10
.LBB44_10:
	ld	c, 1
	lea	hl, iy + 0
	call	__ishl
	ld	bc, 1020
	call	__iand
	ld	de, 80
	add	hl, de
	ld	iy, (ix + 6)
	ld	de, (iy + 1)
	push	hl
	pop	bc
	or	a, a
	sbc	hl, de
	jr	z, .LBB44_12
; %bb.11:
	ld	hl, (ix + 15)
	ld	de, 7
	ld	(ix - 7), 23
	ld	(ix - 6), d
	ld	(ix - 5), -123
	ld	(ix - 4), d
	ld	(ix - 3), 3
	ld	(ix - 10), bc
	ld	(ix - 2), c
	ld	a, b
	ld	(ix - 1), a
	push	de
	pea	ix - 7
	call	__indcallhl
	pop	hl
	pop	hl
	ld	hl, (ix - 10)
	ld	iy, (ix + 6)
	ld	(iy + 1), hl
	.local	.LBB44_12
.LBB44_12:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end44
.Lfunc_end44:
	.size	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_, .Lfunc_end44-__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_17captureEjj,@function ; -- Begin function _ZN12_GLOBAL__N_17captureEjj
__ZN12_GLOBAL__N_17captureEjj:          ; @_ZN12_GLOBAL__N_17captureEjj
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, __ZN12_GLOBAL__N_112captureStageE
	ld	bc, (hl)
	ld	de, 0
	push	de
	pop	hl
	ld	l, c
	ld	h, b
	lea	bc, iy + 0
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB45_13
; %bb.1:
	ld	bc, (ix + 9)
	ld	hl, __ZN12_GLOBAL__N_112captureFrameE
	ld	hl, (hl)
	ld	e, l
	ld	d, h
	ex	de, hl
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB45_13
; %bb.2:
	ld	hl, _.str.40
	ld	de, _.str.25
	push	de
	push	hl
	call	_fopen
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB45_5
; %bb.3:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jp	z, .LBB45_12
; %bb.4:
	ld	hl, _.str.61
	jp	.LBB45_11
	.local	.LBB45_5
.LBB45_5:
	ld	de, (__ZN2fs10generationE)
	ld	(ix - 3), de
	ld	a, (__ZN2fs10generationE+3)
	ld	e, a
	ld	(ix - 6), de
	ld	de, (__ZN2fs7requestE)
	ld	(ix - 9), de
	ld	a, (__ZN2fs7requestE+3)
	ld	iyl, a
	ex	de, hl
	ld	(ix - 12), de
	ld	bc, (__ZN2fs5worldE)
	ld	a, (__ZN2fs5worldE+3)
	ld	l, a
	push	hl
	push	bc
	push	iy
	ld	hl, (ix - 9)
	push	hl
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	ld	hl, _.str.62
	push	hl
	push	de
	call	_fprintf
	ld	hl, 30
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 12)
	push	hl
	call	_fclose
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB45_9
; %bb.6:
	call	__ZN2fs3nowEv
	ld	(ix - 3), hl
	ld	(ix - 6), e                     ; 1-byte Folded Spill
	.local	.LBB45_7
.LBB45_7:                               ; =>This Inner Loop Header: Depth=1
	call	__ZN2fs3nowEv
	ld	bc, (ix - 3)
	ld	a, (ix - 6)                     ; 1-byte Folded Reload
	call	__lsub
	ld	bc, 24000
	xor	a, a
	call	__lcmpu
	jr	c, .LBB45_7
; %bb.8:
	ld	hl, __ZN12_GLOBAL__N_112captureStageE
	ld.sis	de, -1
	ld	(hl), e
	inc	hl
	ld	(hl), d
	jr	.LBB45_13
	.local	.LBB45_9
.LBB45_9:
	ld	a, (__ZN2fs7healthyE)
	bit	0, a
	jr	z, .LBB45_12
; %bb.10:
	ld	hl, _.str.63
	.local	.LBB45_11
.LBB45_11:
	ld	(__ZN2fs7failureE), hl
	.local	.LBB45_12
.LBB45_12:
	xor	a, a
	ld	(__ZN2fs7healthyE), a
	.local	.LBB45_13
.LBB45_13:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end45
.Lfunc_end45:
	.size	__ZN12_GLOBAL__N_17captureEjj, .Lfunc_end45-__ZN12_GLOBAL__N_17captureEjj
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_115releaseGraphicsEv,@function ; -- Begin function _ZN12_GLOBAL__N_115releaseGraphicsEv
__ZN12_GLOBAL__N_115releaseGraphicsEv:  ; @_ZN12_GLOBAL__N_115releaseGraphicsEv
; %bb.0:
	ld	hl, -15
	call	__frameset
	ld	iy, 0
	ld.sis	hl, 1
	ld	(ix - 3), hl
	ld.sis	de, -1536
	ld	bc, 35
	ld.sis	hl, -1416
	ld	(ix - 9), hl
	ld.sis	hl, -14826
	ld	(ix - 6), hl
	.local	.LBB46_1
.LBB46_1:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB46_3
; %bb.2:                                ;   in Loop: Header=BB46_1 Depth=1
	ld	hl, 2
	push	hl
	push	de
	ld	(ix - 12), de
	ld	(ix - 15), bc
	call	__ZN2fs7commandEth
	ld	bc, (ix - 15)
	ld	de, (ix - 12)
	ld	iy, 0
	pop	hl
	pop	hl
	dec	bc
	inc.sis	de
	jr	.LBB46_1
	.local	.LBB46_3
.LBB46_3:
	ld	de, 8
	.local	.LBB46_4
.LBB46_4:                               ; =>This Inner Loop Header: Depth=1
	push	de
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB46_6
; %bb.5:                                ;   in Loop: Header=BB46_4 Depth=1
	ld	hl, 2
	push	hl
	ld	hl, (ix - 9)
	push	hl
	ld	(ix - 12), de
	call	__ZN2fs7commandEth
	ld	de, (ix - 12)
	ld	iy, 0
	pop	hl
	pop	hl
	dec	de
	ld	hl, (ix - 9)
	inc.sis	hl
	ld	(ix - 9), hl
	jr	.LBB46_4
	.local	.LBB46_6
.LBB46_6:
	ld	de, 26
	.local	.LBB46_7
.LBB46_7:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jr	z, .LBB46_9
; %bb.8:                                ;   in Loop: Header=BB46_7 Depth=1
	lea	de, iy + 0
	ld	hl, ___const._ZN12_GLOBAL__N_115releaseGraphicsEv.ids
	add	hl, de
	ld	hl, (hl)
	ld	de, 2
	push	de
	push	hl
	ld	(ix - 9), iy
	call	__ZN2fs7commandEth
	ld	de, 26
	ld	iy, (ix - 9)
	pop	hl
	pop	hl
	ld	bc, 2
	add	iy, bc
	jr	.LBB46_7
	.local	.LBB46_9
.LBB46_9:
	ld	de, 8
	.local	.LBB46_10
.LBB46_10:                              ; =>This Inner Loop Header: Depth=1
	push	de
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB46_12
; %bb.11:                               ;   in Loop: Header=BB46_10 Depth=1
	ld	hl, 2
	push	hl
	ld	hl, (ix - 6)
	push	hl
	ld	(ix - 9), de
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	hl, (ix - 9)
	dec	hl
	ld	de, (ix - 6)
	inc.sis	de
	ld	(ix - 6), de
	ex	de, hl
	jr	.LBB46_10
	.local	.LBB46_12
.LBB46_12:
	ld	de, 26
	.local	.LBB46_13
.LBB46_13:                              ; =>This Inner Loop Header: Depth=1
	push	de
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB46_15
; %bb.14:                               ;   in Loop: Header=BB46_13 Depth=1
	ld	hl, 2
	push	hl
	ld	hl, (ix - 3)
	push	hl
	ld	(ix - 6), de
	call	__ZN2fs7commandEth
	pop	hl
	pop	hl
	ld	de, (ix - 6)
	dec	de
	ld	hl, (ix - 3)
	inc.sis	hl
	ld	(ix - 3), hl
	jr	.LBB46_13
	.local	.LBB46_15
.LBB46_15:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end46
.Lfunc_end46:
	.size	__ZN12_GLOBAL__N_115releaseGraphicsEv, .Lfunc_end46-__ZN12_GLOBAL__N_115releaseGraphicsEv
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_111restoreTextEv,@function ; -- Begin function _ZN12_GLOBAL__N_111restoreTextEv
__ZN12_GLOBAL__N_111restoreTextEv:      ; @_ZN12_GLOBAL__N_111restoreTextEv
; %bb.0:
	ld	hl, -14
	call	__frameset
	ld	hl, 65535
	lea	de, ix - 11
	ld	(ix - 14), de
	push	hl
	call	__ZN12_GLOBAL__N_14fontEj
	pop	hl
	ld	iy, (ix - 14)
	lea	de, iy + 0
	ld	hl, ___const._ZN12_GLOBAL__N_111restoreTextEv.p
	ld	bc, 11
	ldir
	ld	hl, 11
	push	hl
	push	iy
	call	__ZN2fs4sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end47
.Lfunc_end47:
	.size	__ZN12_GLOBAL__N_111restoreTextEv, .Lfunc_end47-__ZN12_GLOBAL__N_111restoreTextEv
                                        ; -- End function
	.weak	__ZN5rally4game5Rules9raceReadyEv ; -- Begin function _ZN5rally4game5Rules9raceReadyEv
	.type	__ZN5rally4game5Rules9raceReadyEv,@function
__ZN5rally4game5Rules9raceReadyEv:      ; @_ZN5rally4game5Rules9raceReadyEv
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	de, 0
	xor	a, a
	ld.sis	hl, 0
	ld	bc, 120
	ld	(iy + 43), de
	ld	(iy + 46), a
	ld	(iy + 15), de
	ld	(iy + 18), a
	ld	(iy + 23), de
	ld	(iy + 26), a
	ld	(iy + 59), a
	ld	(iy + 51), de
	ld	(iy + 54), a
	ld	(iy + 57), l
	ld	(iy + 58), h
	ld	de, (iy + 4)
	sbc	hl, hl
	ld	l, e
	ld	h, d
	ld	e, a
	call	__lmulu
	ld	(iy + 19), hl
	ld	(iy + 22), e
	ld	a, (iy + 60)
	ld	(iy + 61), a
	ld	(iy + 10), 5
	or	a, a
	sbc	hl, hl
	ld	(iy + 11), hl
	ld	(iy + 14), b
	ld	hl, (iy + 55)
	inc.sis	hl
	ld	(iy + 55), l
	ld	(iy + 56), h
	pop	ix
	ret
	.local	.Lfunc_end48
.Lfunc_end48:
	.size	__ZN5rally4game5Rules9raceReadyEv, .Lfunc_end48-__ZN5rally4game5Rules9raceReadyEv
                                        ; -- End function
	.weak	__ZN5rally4game8viewportERNS_6StreamEiiii ; -- Begin function _ZN5rally4game8viewportERNS_6StreamEiiii
	.type	__ZN5rally4game8viewportERNS_6StreamEiiii,@function
__ZN5rally4game8viewportERNS_6StreamEiiii: ; @_ZN5rally4game8viewportERNS_6StreamEiiii
; %bb.0:
	ld	hl, -18
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	(ix - 9), hl
	ld	hl, (ix + 12)
	ld	(ix - 6), hl
	ld	hl, (ix + 15)
	ld	(ix - 12), hl
	ld	hl, (ix + 18)
	ld	(ix - 15), hl
	ld	de, 4096
	ld	(ix - 3), iy
	add	iy, de
	ld	(ix - 18), iy
	ld	de, (iy)
	ld	bc, 4096
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB49_2
; %bb.1:
	ld	hl, (ix - 3)
	add	hl, de
	push	hl
	pop	iy
	inc	de
	ld	hl, (ix - 18)
	ld	(hl), de
	ld	(iy), 24
	jr	.LBB49_3
	.local	.LBB49_2
.LBB49_2:
	ld	de, 4099
	ld	hl, (ix - 3)
	add	hl, de
	ld	(hl), 1
	.local	.LBB49_3
.LBB49_3:
	ld	hl, (ix - 9)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, (ix - 15)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, (ix - 12)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, (ix - 3)
	ld	(ix + 6), hl
	ld	hl, 4
	ld	(ix + 9), hl
	ld	hl, (ix - 9)
	ld	(ix + 12), hl
	ld	hl, (ix - 6)
	ld	(ix + 15), hl
	ld	sp, ix
	pop	ix
	jp	__ZN5rally6Stream4plotEiii
	.local	.Lfunc_end49
.Lfunc_end49:
	.size	__ZN5rally4game8viewportERNS_6StreamEiiii, .Lfunc_end49-__ZN5rally4game8viewportERNS_6StreamEiiii
                                        ; -- End function
	.weak	__ZN5rally6Stream4rectEiiiii    ; -- Begin function _ZN5rally6Stream4rectEiiiii
	.type	__ZN5rally6Stream4rectEiiiii,@function
__ZN5rally6Stream4rectEiiiii:           ; @_ZN5rally6Stream4rectEiiiii
; %bb.0:
	ld	hl, -15
	call	__frameset
	ld	de, (ix + 6)
	ld	(ix - 3), de
	ld	hl, (ix + 9)
	ld	(ix - 12), hl
	ld	hl, (ix + 12)
	ld	(ix - 15), hl
	ld	hl, (ix + 15)
	ld	(ix - 6), hl
	ld	hl, (ix + 18)
	ld	(ix - 9), hl
	ld	hl, (ix + 21)
	push	hl
	push	de
	call	__ZN5rally6Stream5colorEi
	pop	hl
	pop	hl
	ld	hl, (ix - 15)
	push	hl
	ld	hl, (ix - 12)
	push	hl
	ld	hl, 4
	push	hl
	ld	hl, (ix - 3)
	push	hl
	call	__ZN5rally6Stream4plotEiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (ix - 3)
	ld	(ix + 6), hl
	ld	hl, 101
	ld	(ix + 9), hl
	ld	hl, (ix - 6)
	ld	(ix + 12), hl
	ld	hl, (ix - 9)
	ld	(ix + 15), hl
	ld	sp, ix
	pop	ix
	jp	__ZN5rally6Stream4plotEiii
	.local	.Lfunc_end50
.Lfunc_end50:
	.size	__ZN5rally6Stream4rectEiiiii, .Lfunc_end50-__ZN5rally6Stream4rectEiiiii
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_15flushEv,@function ; -- Begin function _ZN12_GLOBAL__N_15flushEv
__ZN12_GLOBAL__N_15flushEv:             ; @_ZN12_GLOBAL__N_15flushEv
; %bb.0:
	ld	hl, __ZN12_GLOBAL__N_16streamE
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	push	hl
	call	__ZN2fs4sendEPKhj
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	ld	(__ZN12_GLOBAL__N_16streamE+4096), hl
	xor	a, a
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	ret
	.local	.Lfunc_end51
.Lfunc_end51:
	.size	__ZN12_GLOBAL__N_15flushEv, .Lfunc_end51-__ZN12_GLOBAL__N_15flushEv
                                        ; -- End function
	.weak	__ZN5rally6Stream4wordEi        ; -- Begin function _ZN5rally6Stream4wordEi
	.type	__ZN5rally6Stream4wordEi,@function
__ZN5rally6Stream4wordEi:               ; @_ZN5rally6Stream4wordEi
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	de, 4096
	add	iy, de
	ld	bc, (iy)
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	nc, .LBB52_3
; %bb.1:
	ld	hl, (ix + 9)
	ld	a, l
	ld	hl, (ix + 6)
	add	hl, bc
	inc	bc
	ld	(iy), bc
	ld	(hl), a
	ld	bc, (iy)
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	nc, .LBB52_3
; %bb.2:
	ld	hl, (ix + 9)
	ld	a, h
	ld	hl, (ix + 6)
	add	hl, bc
	inc	bc
	ld	(iy), bc
	ld	(hl), a
	jr	.LBB52_4
	.local	.LBB52_3
.LBB52_3:
	ld	de, 4099
	ld	hl, (ix + 6)
	add	hl, de
	ld	(hl), 1
	.local	.LBB52_4
.LBB52_4:
	pop	ix
	ret
	.local	.Lfunc_end52
.Lfunc_end52:
	.size	__ZN5rally6Stream4wordEi, .Lfunc_end52-__ZN5rally6Stream4wordEi
                                        ; -- End function
	.weak	__ZN5rally6Stream4plotEiii      ; -- Begin function _ZN5rally6Stream4plotEiii
	.type	__ZN5rally6Stream4plotEiii,@function
__ZN5rally6Stream4plotEiii:             ; @_ZN5rally6Stream4plotEiii
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	hl, (ix + 6)
	ld	de, (ix + 12)
	ld	(ix - 9), de
	ld	de, (ix + 15)
	ld	(ix - 6), de
	ld	de, 4096
	ld	(ix - 3), hl
	add	hl, de
	ld	(ix - 12), hl
	ld	de, (hl)
	ld	bc, 4096
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB53_3
; %bb.1:
	ld	a, (ix + 9)
	ld	hl, (ix - 3)
	add	hl, de
	inc	de
	ld	bc, (ix - 12)
	push	bc
	pop	iy
	ld	(iy), de
	ld	(hl), 25
	push	bc
	pop	hl
	ld	de, (hl)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB53_3
; %bb.2:
	ld	hl, (ix - 3)
	add	hl, de
	push	hl
	pop	iy
	inc	de
	ld	hl, (ix - 12)
	ld	(hl), de
	ld	(iy), a
	jr	.LBB53_4
	.local	.LBB53_3
.LBB53_3:
	ld	de, 4099
	ld	hl, (ix - 3)
	add	hl, de
	ld	(hl), 1
	.local	.LBB53_4
.LBB53_4:
	ld	hl, (ix - 9)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, (ix - 3)
	ld	(ix + 6), hl
	ld	hl, (ix - 6)
	ld	(ix + 9), hl
	ld	sp, ix
	pop	ix
	jp	__ZN5rally6Stream4wordEi
	.local	.Lfunc_end53
.Lfunc_end53:
	.size	__ZN5rally6Stream4plotEiii, .Lfunc_end53-__ZN5rally6Stream4plotEiii
                                        ; -- End function
	.weak	__ZN5rally6Stream5colorEi       ; -- Begin function _ZN5rally6Stream5colorEi
	.type	__ZN5rally6Stream5colorEi,@function
__ZN5rally6Stream5colorEi:              ; @_ZN5rally6Stream5colorEi
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	de, 4096
	add	iy, de
	ld	bc, (iy)
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	nc, .LBB54_4
; %bb.1:
	ld	hl, (ix + 6)
	add	hl, bc
	inc	bc
	ld	(iy), bc
	ld	(hl), 18
	ld	bc, (iy)
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	nc, .LBB54_4
; %bb.2:
	ld	hl, (ix + 6)
	add	hl, bc
	inc	bc
	ld	(iy), bc
	ld	(hl), 0
	ld	bc, (iy)
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	nc, .LBB54_4
; %bb.3:
	ld	a, (ix + 9)
	ld	hl, (ix + 6)
	add	hl, bc
	inc	bc
	ld	(iy), bc
	ld	(hl), a
	jr	.LBB54_5
	.local	.LBB54_4
.LBB54_4:
	ld	de, 4099
	ld	hl, (ix + 6)
	add	hl, de
	ld	(hl), 1
	.local	.LBB54_5
.LBB54_5:
	pop	ix
	ret
	.local	.Lfunc_end54
.Lfunc_end54:
	.size	__ZN5rally6Stream5colorEi, .Lfunc_end54-__ZN5rally6Stream5colorEi
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_110prepareSkyEv,@function ; -- Begin function _ZN12_GLOBAL__N_110prepareSkyEv
__ZN12_GLOBAL__N_110prepareSkyEv:       ; @_ZN12_GLOBAL__N_110prepareSkyEv
; %bb.0:
	ld	hl, -35
	call	__frameset
	ld	bc, 100
	ld	iyl, b
	ld	hl, (__ZN12_GLOBAL__N_16motionE+7)
	ld	(ix - 35), hl
	ld	a, (__ZN12_GLOBAL__N_16motionE+10)
	ld	d, a
	ld	e, d
	ld	a, iyl
	call	__ldivs
	push	hl
	pop	iy
	ld	l, 8
	lea	bc, iy + 0
	ld	a, e
	call	__lshl
	ld	(ix - 29), bc
	ld	(ix - 32), a                    ; 1-byte Folded Spill
	lea	hl, iy + 0
	ld	iy, 100
	lea	bc, iy + 0
	xor	a, a
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 35)
	ld	e, d
	call	__lsub
	push	hl
	pop	bc
	ld	a, e
	ld	l, 8
	call	__lshl
	push	bc
	pop	hl
	ld	e, a
	lea	bc, iy + 0
	xor	a, a
	call	__ldivs
	ld	bc, (ix - 29)
	ld	a, (ix - 32)                    ; 1-byte Folded Reload
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	ld	bc, (__ZN12_GLOBAL__N_16motionE)
	push	bc
	push	de
	push	hl
	pea	ix - 16
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (ix - 8)
	ld	a, (ix - 5)
	ld	de, (ix - 4)
	ld	c, (ix - 1)
	push	bc
	push	de
	ld	e, a
	push	de
	push	hl
	call	__ZN5rally14sceneryHeadingEll
	pop	de
	pop	de
	pop	de
	pop	de
	ld	(ix - 29), hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_114sceneryHistoryE
	push	hl
	pea	ix - 26
	call	__ZN5rally14SceneryHistory7prepareEi
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (ix - 26)
	ld	(__ZN12_GLOBAL__N_15sceneE.1), hl
	ld	hl, (ix - 23)
	ld	(__ZN12_GLOBAL__N_15sceneE.2), hl
	ld	hl, (ix - 20)
	ld	(__ZN12_GLOBAL__N_15sceneE.3), hl
	ld	a, (ix - 17)
	ld	(__ZN12_GLOBAL__N_15sceneE.4), a
	scf
	sbc	hl, hl
	push	hl
	ld	hl, 1
	push	hl
	call	_vdp_adv_use_affine_matrix
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_15sceneE.1)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB55_4
; %bb.1:
	ld	iy, __ZN2fs11scrollCallsE
	ld	hl, (__ZN2fs11scrollCallsE)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN2fs11scrollCallsE), hl
	ld	(__ZN2fs11scrollCallsE+3), a
	ld	hl, 103
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 24
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	bc, (__ZN12_GLOBAL__N_15sceneE.1)
	ld	de, 1
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB55_3
; %bb.2:
	ld	de, 0
	.local	.LBB55_3
.LBB55_3:
	ld	(ix - 32), de
	push	bc
	pop	hl
	push	bc
	pop	de
	push	de
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	bc
	ex	de, hl
	add	hl, bc
	call	__ixor
	push	hl
	ld	hl, (ix - 32)
	push	hl
	ld	hl, 2
	push	hl
	call	_vdp_scroll_screen_extent
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB55_4
.LBB55_4:
	ld	hl, 100
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15sceneE.4)
	bit	0, a
	jp	z, .LBB55_8
; %bb.5:
	ld	iy, __ZN2fs12repaintCallsE
	ld	hl, (__ZN2fs12repaintCallsE)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN2fs12repaintCallsE), hl
	ld	(__ZN2fs12repaintCallsE+3), a
	ld	hl, (__ZN12_GLOBAL__N_15sceneE.2)
	ld	de, (__ZN12_GLOBAL__N_15sceneE.3)
	ld	bc, 103
	push	bc
	push	de
	ld	de, 24
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, 1024
	ld	de, (ix - 29)
	or	a, a
	sbc	hl, de
	push	hl
	pop	de
	ld	hl, (__ZN12_GLOBAL__N_15sceneE.2)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB55_7
; %bb.6:
	ld	hl, (ix - 29)
	call	__ineg
	ld	(ix - 32), de
	ld	de, 0
	push	de
	push	hl
	call	_vdp_draw_bitmap
	ld	de, (ix - 32)
	pop	hl
	pop	hl
	.local	.LBB55_7
.LBB55_7:
	ld	hl, (__ZN12_GLOBAL__N_15sceneE.3)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	ld	hl, 0
	push	hl
	push	de
	call	p, _vdp_draw_bitmap
	pop	hl
	pop	hl
	.local	.LBB55_8
.LBB55_8:
	ld	a, (__ZN12_GLOBAL__N_15sceneE.4)
	bit	0, a
	jr	z, .LBB55_10
; %bb.9:
	ld	hl, (__ZN12_GLOBAL__N_15sceneE.1)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB55_12
	.local	.LBB55_10
.LBB55_10:
	ld	iy, __ZN2fs14skyRepairCallsE
	ld	hl, (__ZN2fs14skyRepairCallsE)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 1
	xor	a, a
	call	__ladd
	ld	a, e
	ld	(__ZN2fs14skyRepairCallsE), hl
	ld	(__ZN2fs14skyRepairCallsE+3), a
	ld	hl, 103
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 88
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, (ix - 29)
	call	__ineg
	ld	de, 0
	push	de
	push	hl
	call	_vdp_draw_bitmap
	pop	hl
	pop	hl
	ld	de, 705
	ld	hl, (ix - 29)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	m, .LBB55_12
; %bb.11:
	ld	hl, 1024
	ld	de, (ix - 29)
	or	a, a
	sbc	hl, de
	ld	de, 0
	push	de
	push	hl
	call	_vdp_draw_bitmap
	pop	hl
	pop	hl
	.local	.LBB55_12
.LBB55_12:
	ld	hl, 239
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 104
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end55
.Lfunc_end55:
	.size	__ZN12_GLOBAL__N_110prepareSkyEv, .Lfunc_end55-__ZN12_GLOBAL__N_110prepareSkyEv
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_17drawHudEm,@function ; -- Begin function _ZN12_GLOBAL__N_17drawHudEm
__ZN12_GLOBAL__N_17drawHudEm:           ; @_ZN12_GLOBAL__N_17drawHudEm
; %bb.0:
	ld	hl, -336
	call	__frameset
	ld	bc, -314
	lea	iy, ix + 0
	add	iy, bc
	lea	de, iy + 68
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	lea	hl, iy + 20
	push	ix
	ld	bc, -317
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	lea	hl, iy + 0
	ld	bc, -323
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	de
	call	__ZN5rally4game8HudImageC2Ev
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	ld	hl, _.str.47
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 11
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally4game8HudImage3putEjjPKch
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+19)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+22)
	ld	e, a
	ld	bc, 119
	xor	a, a
	call	__ladd
	inc	bc
	call	__ldivu
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	ld	hl, _.str.48
	push	hl
	ld	hl, 48
	push	hl
	ld	de, -317
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	call	_snprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 11
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 14
	push	hl
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally4game8HudImage3putEjjPKch
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	cp	a, 3
	jr	z, .LBB56_2
; %bb.1:
	cp	a, 6
	jr	nz, .LBB56_3
	.local	.LBB56_2
.LBB56_2:
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+15)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+18)
	ld	e, a
	ld	bc, (__ZN12_GLOBAL__N_15rulesE+23)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+26)
	call	__lsub
	jr	.LBB56_4
	.local	.LBB56_3
.LBB56_3:
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+27)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+30)
	ld	e, a
	.local	.LBB56_4
.LBB56_4:
	ld	bc, 100
	xor	a, a
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	(ix - 3), bc
	push	ix
	ld	bc, -336
	add	ix, bc
	ld	(ix + 0), d
	pop	ix
	ld	bc, (ix - 3)
	ld	bc, 120
	call	__ldivu
	ld	(ix - 3), bc
	push	ix
	ld	bc, -332
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	dec	bc
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	lea	hl, iy + 0
	ld	e, d
	ld	bc, (ix - 3)
	ld	bc, 720000
	call	__ldivu
	ld	(ix - 3), bc
	push	ix
	ld	bc, -326
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
                                        ; kill: def $e killed $e def $ude
	push	ix
	ld	bc, -329
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	lea	hl, iy + 0
	ld	bc, -336
	lea	iy, ix + 0
	add	iy, bc
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	ld	bc, (ix - 3)
	ld	bc, 12000
	call	__ldivu
	ld	bc, 60
	call	__lremu
	ld	(ix - 3), bc
	push	ix
	ld	bc, -336
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	iyl, e
	push	ix
	ld	bc, -332
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	dec	bc
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, (ix - 3)
	ld	bc, 100
	call	__lremu
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	push	iy
	ld	de, -336
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -329
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -326
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.54
	push	hl
	ld	hl, 20
	push	hl
	ld	de, -323
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	call	_snprintf
	ld	hl, 27
	add	hl, sp
	ld	sp, hl
	ld	bc, -323
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.49
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 15
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 25
	push	hl
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally4game8HudImage3putEjjPKch
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+39)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+42)
	ld	e, a
	push	de
	push	hl
	ld	hl, _.str.50
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 15
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 1
	push	hl
	dec	hl
	push	hl
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally4game8HudImage3putEjjPKch
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_16motionE+11)
	ld	a, (__ZN12_GLOBAL__N_16motionE+14)
	ld	e, a
	push	de
	push	hl
	ld	hl, _.str.51
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 15
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 1
	push	hl
	ld	hl, 16
	push	hl
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally4game8HudImage3putEjjPKch
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	or	a, a
	jr	nz, .LBB56_7
; %bb.5:
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	add	a, -6
	cp	a, 3
	jr	nc, .LBB56_7
; %bb.6:
	ld	hl, _.str.52
	ld	a, (__ZN12_GLOBAL__N_15rulesE+61)
	ld	de, 0
	ld	e, a
	push	de
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 11
	push	hl
	ld	bc, -317
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 1
	push	hl
	ld	hl, 30
	push	hl
	ld	bc, -320
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally4game8HudImage3putEjjPKch
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB56_7
.LBB56_7:
	ld	hl, (__ZN12_GLOBAL__N_114sceneryHistoryE+8)
	ld	bc, -320
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_13hudE
	push	hl
	call	__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end56
.Lfunc_end56:
	.size	__ZN12_GLOBAL__N_17drawHudEm, .Lfunc_end56-__ZN12_GLOBAL__N_17drawHudEm
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_16bottomEv,@function ; -- Begin function _ZN12_GLOBAL__N_16bottomEv
__ZN12_GLOBAL__N_16bottomEv:            ; @_ZN12_GLOBAL__N_16bottomEv
; %bb.0:
	ld	hl, -43
	call	__frameset
	ld	bc, 15
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	l, a
	or	a, a
	jr	nz, .LBB57_3
; %bb.1:
	ld	hl, 2
	ld	de, _.str.55
	.local	.LBB57_2
.LBB57_2:
	push	bc
	push	de
	push	hl
	jr	.LBB57_5
	.local	.LBB57_3
.LBB57_3:
	ld	bc, 1
	ld	de, 11
	ld	a, l
	cp	a, 3
	jr	nz, .LBB57_7
; %bb.4:
	ld	hl, _.str.56
	push	de
	push	hl
	push	bc
	.local	.LBB57_5
.LBB57_5:
	call	__ZN12_GLOBAL__N_14textEiiPKcii
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB57_6
.LBB57_6:
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB57_7
.LBB57_7:
	ld	a, l
	cp	a, 6
	jr	nz, .LBB57_6
; %bb.8:
	lea	de, ix - 40
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	or	a, a
	jr	z, .LBB57_10
; %bb.9:
	ld	bc, _.str.59
	jr	.LBB57_11
	.local	.LBB57_10
.LBB57_10:
	ld	bc, _.str.58
	.local	.LBB57_11
.LBB57_11:
	ld	a, (__ZN12_GLOBAL__N_15rulesE+59)
	ld	iy, 0
	lea	hl, iy + 0
	ld	l, a
	inc	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+8)
	ld	iyl, a
	push	iy
	push	hl
	push	bc
	ld	hl, _.str.57
	push	hl
	ld	hl, 40
	push	hl
	ld	(ix - 43), de
	push	de
	call	_snprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 15
	push	hl
	ld	hl, (ix - 43)
	push	hl
	ld	hl, 1
	push	hl
	call	__ZN12_GLOBAL__N_14textEiiPKcii
	pop	hl
	pop	hl
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_15rulesE+57
	ld	hl, (hl)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	z, .LBB57_6
; %bb.12:
	ld	hl, 23
	ld	de, _.str.60
	ld	bc, 11
	jp	.LBB57_2
	.local	.Lfunc_end57
.Lfunc_end57:
	.size	__ZN12_GLOBAL__N_16bottomEv, .Lfunc_end57-__ZN12_GLOBAL__N_16bottomEv
                                        ; -- End function
	.weak	__ZN5rally11trackSampleElRKNS_8TrackDefE ; -- Begin function _ZN5rally11trackSampleElRKNS_8TrackDefE
	.type	__ZN5rally11trackSampleElRKNS_8TrackDefE,@function
__ZN5rally11trackSampleElRKNS_8TrackDefE: ; @_ZN5rally11trackSampleElRKNS_8TrackDefE
; %bb.0:
	ld	hl, -16
	call	__frameset
	ld	bc, (ix + 9)
	ld	iy, (ix + 15)
	ld	l, 14
	ld	a, (ix + 12)
	call	__lshrs
	ld	de, (iy + 3)
	push	bc
	pop	iy
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	ld	(ix - 13), de
	jr	c, .LBB58_2
; %bb.1:
	lea	hl, iy + 0
	push	de
	pop	bc
	call	__iremu
	push	hl
	pop	iy
	.local	.LBB58_2
.LBB58_2:
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	ld	bc, 16383
	xor	a, a
	call	__land
	ld	(ix - 6), hl
	ld	(ix - 7), e                     ; 1-byte Folded Spill
	ld	hl, (ix + 15)
	ld	de, (hl)
	ld	a, 3
	lea	hl, iy + 0
	ld	c, a
	call	__ishl
	push	hl
	pop	bc
	ld	(ix - 3), de
	ex	de, hl
	add	hl, bc
	ld	(ix - 10), hl
	inc	iy
	lea	hl, iy + 0
	ld	de, (ix - 13)
	or	a, a
	sbc	hl, de
	ld	hl, 0
	jr	z, .LBB58_4
; %bb.3:
	lea	hl, iy + 0
	.local	.LBB58_4
.LBB58_4:
	ld	c, a
	call	__ishl
	push	hl
	pop	de
	ld	hl, (ix - 3)
	add	hl, de
	ld	(ix - 3), hl
	ld	hl, (ix - 10)
	ld	bc, (hl)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	de
	ld	d, a
	ld	e, c
	push	de
	pop	hl
	push	de
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	iyl, 8
	push	de
	pop	bc
	ld	a, l
	ex	de, hl
	ld	e, iyl
	ex	de, hl
	call	__lshl
	ld	(ix - 13), bc
	ld	(ix - 16), a                    ; 1-byte Folded Spill
	ld	hl, (ix - 3)
	ld	bc, (hl)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, c
	or	a, a
	sbc	hl, de
	push	hl
	pop	bc
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	iy
	ld	hl, (ix - 6)
	ld	e, (ix - 7)                     ; 1-byte Folded Reload
	ld	a, iyl
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	l, 6
	call	__lshrs
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 13)
	ld	a, (ix - 16)                    ; 1-byte Folded Reload
	call	__ladd
	ld	bc, (ix + 6)
	push	bc
	pop	iy
	ld	(iy), hl
	ld	(iy + 3), e
	ld	iy, (ix - 10)
	ld	bc, (iy + 2)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	de
	ld	d, a
	ld	e, c
	push	de
	pop	hl
	push	de
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	de
	pop	bc
	ld	a, l
	ld	l, 8
	call	__lshl
	ld	(ix - 13), bc
	ld	(ix - 16), a                    ; 1-byte Folded Spill
	ld	iy, (ix - 3)
	ld	bc, (iy + 2)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, c
	or	a, a
	sbc	hl, de
	push	hl
	pop	bc
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	iy
	ld	hl, (ix - 6)
	ld	e, (ix - 7)                     ; 1-byte Folded Reload
	ld	a, iyl
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	l, 6
	call	__lshrs
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 13)
	ld	a, (ix - 16)                    ; 1-byte Folded Reload
	call	__ladd
	ld	iy, (ix + 6)
	ld	(iy + 4), hl
	ld	(iy + 7), e
	ld	iy, (ix - 10)
	ld	de, (iy + 4)
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, e
	push	hl
	pop	iy
	push	hl
	pop	bc
	ld	(ix - 16), bc
	add	iy, iy
	sbc	hl, hl
	ld	(ix - 13), hl
	ld	iy, (ix - 3)
	ld	de, (iy + 4)
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, e
	or	a, a
	sbc	hl, bc
	push	hl
	pop	bc
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	iy
	ld	hl, (ix - 6)
	ld	e, (ix - 7)                     ; 1-byte Folded Reload
	ld	a, iyl
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	l, 14
	call	__lshrs
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 16)
	ld	iy, (ix - 13)
	ld	a, iyl
	call	__ladd
	ld	iy, (ix + 6)
	ld	(iy + 8), hl
	ld	(iy + 11), e
	ld	iy, (ix - 10)
	ld	de, (iy + 6)
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, e
	push	hl
	pop	iy
	push	hl
	pop	bc
	ld	(ix - 13), bc
	add	iy, iy
	sbc	hl, hl
	ld	(ix - 10), hl
	ld	iy, (ix - 3)
	ld	de, (iy + 6)
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, e
	or	a, a
	sbc	hl, bc
	push	hl
	pop	bc
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	iy
	ld	hl, (ix - 6)
	ld	e, (ix - 7)                     ; 1-byte Folded Reload
	ld	a, iyl
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	l, 14
	call	__lshrs
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 13)
	ld	iy, (ix - 10)
	ld	a, iyl
	call	__ladd
	ld	iy, (ix + 6)
	ld	(iy + 12), hl
	ld	(iy + 15), e
	lea	hl, iy + 0
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end58
.Lfunc_end58:
	.size	__ZN5rally11trackSampleElRKNS_8TrackDefE, .Lfunc_end58-__ZN5rally11trackSampleElRKNS_8TrackDefE
                                        ; -- End function
	.weak	__ZN5rally14sceneryHeadingEll   ; -- Begin function _ZN5rally14sceneryHeadingEll
	.type	__ZN5rally14sceneryHeadingEll,@function
__ZN5rally14sceneryHeadingEll:          ; @_ZN5rally14sceneryHeadingEll
; %bb.0:
	ld	hl, -7
	call	__frameset
	ld	iy, (ix + 6)
	ld	e, (ix + 9)
	ld	d, (ix + 15)
	ld	l, 31
	lea	bc, iy + 0
	ld	a, e
	call	__lshrs
	lea	hl, iy + 0
	call	__ladd
	call	__lxor
	ld	(ix - 3), hl
	ld	(ix - 7), e                     ; 1-byte Folded Spill
	ld	iy, (ix + 12)
	lea	bc, iy + 0
	ld	a, d
	ld	l, 31
	call	__lshrs
	lea	hl, iy + 0
	ld	e, d
	ld	iyl, d
	call	__ladd
	call	__lxor
	ld	(ix - 6), hl
	ld	d, e
	ld	hl, (ix + 12)
	ld	e, iyl
	ld	bc, (ix + 6)
	ld	a, (ix + 9)
	call	__lor
	call	__lcmpzero
	ld	hl, 0
	jp	z, .LBB59_13
; %bb.1:
	ld	hl, (ix - 3)
	push	af
	ld	a, (ix - 7)                     ; 1-byte Folded Reload
	ld	iyh, a
	pop	af
	ld	e, iyh
	ld	bc, (ix - 6)
	ld	a, d
	call	__lcmpu
	ld	l, 8
	jr	nc, .LBB59_3
; %bb.2:
	ld	bc, (ix - 3)
	ld	a, iyh
	call	__lshl
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 6)
	ld	a, d
	call	__ldivu
	push	hl
	pop	de
	ld	hl, __ZN5rallyL11HeadingAtanE
	add	hl, de
	ld	de, 0
	ld	e, (hl)
	ld	hl, 256
	or	a, a
	sbc	hl, de
	push	hl
	pop	bc
	jr	.LBB59_4
	.local	.LBB59_3
.LBB59_3:
	ld	bc, (ix - 6)
	ld	a, d
	call	__lshl
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 3)
	ld	a, iyh
	call	__ldivu
	push	hl
	pop	de
	ld	hl, __ZN5rallyL11HeadingAtanE
	add	hl, de
	ld	bc, 0
	ld	c, (hl)
	.local	.LBB59_4
.LBB59_4:
	ld	hl, (ix + 12)
	ld	e, iyl
	call	__lcmpzero
	ld	a, 1
	ld	d, 0
	ld	iyl, a
	jp	m, .LBB59_6
; %bb.5:
	ld	iyl, d
	.local	.LBB59_6
.LBB59_6:
	ld	hl, (ix + 6)
	ld	e, (ix + 9)
	call	__lcmpzero
	jp	m, .LBB59_8
; %bb.7:
	ld	a, d
	.local	.LBB59_8
.LBB59_8:
	ld	hl, 512
	or	a, a
	sbc	hl, bc
	push	hl
	pop	de
	bit	0, a
	jr	nz, .LBB59_10
; %bb.9:
	push	bc
	pop	de
	.local	.LBB59_10
.LBB59_10:
	ld	bc, 1023
	push	de
	pop	hl
	call	__ineg
	ld	a, iyl
	bit	0, a
	jr	nz, .LBB59_12
; %bb.11:
	ex	de, hl
	.local	.LBB59_12
.LBB59_12:
	call	__iand
	.local	.LBB59_13
.LBB59_13:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end59
.Lfunc_end59:
	.size	__ZN5rally14sceneryHeadingEll, .Lfunc_end59-__ZN5rally14sceneryHeadingEll
                                        ; -- End function
	.weak	__ZN5rally14SceneryHistory7prepareEi ; -- Begin function _ZN5rally14SceneryHistory7prepareEi
	.type	__ZN5rally14SceneryHistory7prepareEi,@function
__ZN5rally14SceneryHistory7prepareEi:   ; @_ZN5rally14SceneryHistory7prepareEi
; %bb.0:
	ld	hl, -15
	call	__frameset
	ld	iy, (ix + 9)
	ld	hl, (ix + 12)
	ld	bc, 1023
	call	__iand
	push	hl
	pop	de
	ld	hl, (iy + 8)
	ld	(ix - 3), hl
	ld	bc, 3
	call	__imulu
	push	hl
	pop	bc
	add	iy, bc
	ld	(ix - 6), iy
	ld	iy, (iy)
	push	de
	pop	hl
	ld	bc, 1536
	add	hl, bc
	lea	bc, iy + 0
	or	a, a
	sbc	hl, bc
	ld	bc, 1024
	call	__irems
	ld	(ix - 12), hl
	push	hl
	pop	iy
	ld	bc, -512
	add	iy, bc
	ld	(ix - 15), iy
	ld	iy, (ix + 9)
	lea	hl, iy + 6
	ld	(ix - 9), hl
	ld	bc, (ix - 3)
	add	hl, bc
	ld	a, (hl)
	ld	hl, (ix - 6)
	ld	(hl), de
	ld	iy, (ix + 9)
	ld	de, (iy + 8)
	ld	hl, (ix - 9)
	add	hl, de
	ld	(hl), 1
	bit	0, a
	jr	z, .LBB60_3
; %bb.1:
	ld	de, 768
	ld	hl, (ix - 12)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB60_3
; %bb.2:
	ld	de, 257
	ld	hl, (ix - 12)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB60_7
	.local	.LBB60_3
.LBB60_3:
	ld	iy, (ix + 6)
	or	a, a
	sbc	hl, hl
	ld	(iy), hl
	.local	.LBB60_4
.LBB60_4:
	ld	(iy + 3), hl
	ld	hl, 319
	.local	.LBB60_5
.LBB60_5:
	ld	(iy + 6), hl
	ld	(iy + 9), 1
	.local	.LBB60_6
.LBB60_6:
	lea	hl, iy + 0
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB60_7
.LBB60_7:
	ld	hl, (ix - 15)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB60_9
; %bb.8:
	ld	hl, (ix + 6)
	ld	(hl), 0
	push	hl
	pop	iy
	inc	iy
	ld	bc, 9
	lea	de, iy + 0
	push	hl
	pop	iy
	ldir
	jr	.LBB60_6
	.local	.LBB60_9
.LBB60_9:
	ld	iy, (ix + 6)
	ld	(iy), hl
	ld	de, 513
	ld	hl, (ix - 12)
	or	a, a
	sbc	hl, de
	jr	c, .LBB60_11
; %bb.10:
	ld	hl, 832
	ld	de, (ix - 12)
	or	a, a
	sbc	hl, de
	jr	.LBB60_4
	.local	.LBB60_11
.LBB60_11:
	ld	hl, 511
	ld	de, 0
	ld	(iy + 3), de
	ld	de, (ix - 12)
	or	a, a
	sbc	hl, de
	jr	.LBB60_5
	.local	.Lfunc_end60
.Lfunc_end60:
	.size	__ZN5rally14SceneryHistory7prepareEi, .Lfunc_end60-__ZN5rally14SceneryHistory7prepareEi
                                        ; -- End function
	.weak	__ZN5rally4game8HudImageC2Ev    ; -- Begin function _ZN5rally4game8HudImageC2Ev
	.type	__ZN5rally4game8HudImageC2Ev,@function
__ZN5rally4game8HudImageC2Ev:           ; @_ZN5rally4game8HudImageC2Ev
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 6)
	ld	(hl), 0
	push	hl
	pop	iy
	inc	iy
	ld	bc, 239
	lea	de, iy + 0
	ldir
	ld	bc, 0
	ld	de, 120
	.local	.LBB61_1
.LBB61_1:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	z, .LBB61_3
; %bb.2:                                ;   in Loop: Header=BB61_1 Depth=1
	ld	iy, (ix + 6)
	add	iy, bc
	ld	(iy), 32
	ld	(iy + 120), 15
	inc	bc
	jr	.LBB61_1
	.local	.LBB61_3
.LBB61_3:
	pop	ix
	ret
	.local	.Lfunc_end61
.Lfunc_end61:
	.size	__ZN5rally4game8HudImageC2Ev, .Lfunc_end61-__ZN5rally4game8HudImageC2Ev
                                        ; -- End function
	.weak	__ZN5rally4game8HudImage3putEjjPKch ; -- Begin function _ZN5rally4game8HudImage3putEjjPKch
	.type	__ZN5rally4game8HudImage3putEjjPKch,@function
__ZN5rally4game8HudImage3putEjjPKch:    ; @_ZN5rally4game8HudImage3putEjjPKch
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	de, (ix + 12)
	ld	bc, 40
	push	de
	pop	hl
	call	__imulu
	push	hl
	pop	bc
	ld	iy, 3
	ex	de, hl
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
	jr	nc, .LBB62_5
; %bb.1:
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	(ix - 3), hl
	ld	hl, (ix + 15)
	add	iy, bc
	push	hl
	pop	bc
	.local	.LBB62_2
.LBB62_2:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	ld	e, (hl)
	ld	a, e
	or	a, a
	jr	z, .LBB62_5
; %bb.3:                                ;   in Loop: Header=BB62_2 Depth=1
	ld	(ix - 9), bc
	ld	hl, (ix - 3)
	ld	bc, 40
	or	a, a
	sbc	hl, bc
	ld	bc, (ix - 9)
	jr	nc, .LBB62_5
; %bb.4:                                ;   in Loop: Header=BB62_2 Depth=1
	ld	(ix - 6), iy
	ld	(ix - 12), iy
	ld	iy, (ix - 6)
	ld	a, e
	ld	de, (ix - 3)
	add	iy, de
	ld	(ix - 6), iy
	ld	hl, (ix - 6)
	ld	(hl), a
	ld	a, (ix + 18)
	ld	iy, (ix - 6)
	ld	(iy + 120), a
	ld	iy, (ix - 12)
	inc	bc
	ld	hl, (ix - 3)
	inc	hl
	ld	(ix - 3), hl
	jr	.LBB62_2
	.local	.LBB62_5
.LBB62_5:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end62
.Lfunc_end62:
	.size	__ZN5rally4game8HudImage3putEjjPKch, .Lfunc_end62-__ZN5rally4game8HudImage3putEjjPKch
                                        ; -- End function
	.weak	__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE ; -- Begin function _ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE
	.type	__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE,@function
__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE: ; @_ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE
; %bb.0:
	ld	hl, -29
	call	__frameset
	ld	hl, (ix + 6)
	ld	iy, (ix + 9)
	ld	bc, (ix + 12)
	ld	de, 480
	add	hl, bc
	add	hl, de
	ld	(ix - 6), hl
	bit	0, (hl)
	jr	nz, .LBB63_2
; %bb.1:
	ld	bc, 319
	ld	de, 23
	ld	hl, 20
	push	hl
	push	de
	push	bc
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	push	iy
	call	__ZN5rally6Stream4rectEiiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB63_2
.LBB63_2:
	ld	iy, (ix + 15)
	ld	bc, 240
	ld	hl, (ix + 12)
	call	__imulu
	push	hl
	pop	de
	ld	hl, (ix + 6)
	add	hl, de
	ld	bc, 3
	ld	(ix - 3), iy
	ld	(ix - 18), hl
	ld	(ix - 9), hl
	ld	de, 0
	push	de
	pop	iy
	.local	.LBB63_3
.LBB63_3:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB63_5 Depth 2
                                        ;       Child Loop BB63_24 Depth 3
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	z, .LBB63_35
; %bb.4:                                ;   in Loop: Header=BB63_3 Depth=1
	lea	hl, iy + 0
	ld	bc, 40
	call	__imulu
	ld	(ix - 24), hl
	ld	(ix - 21), iy
	push	af
	ld	a, iyl
	ld	(ix - 29), a                    ; 1-byte Folded Spill
	pop	af
	push	de
	pop	iy
	.local	.LBB63_5
.LBB63_5:                               ;   Parent Loop BB63_3 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB63_24 Depth 3
	lea	hl, iy + 0
	ld	de, 40
	or	a, a
	sbc	hl, de
	jp	nc, .LBB63_34
; %bb.6:                                ;   in Loop: Header=BB63_5 Depth=2
	ld	(ix - 12), iy
	ld	de, (ix - 24)
	add	iy, de
	lea	de, iy + 0
	ld	hl, (ix - 6)
	bit	0, (hl)
	jr	z, .LBB63_10
; %bb.7:                                ;   in Loop: Header=BB63_5 Depth=2
	ld	hl, (ix - 18)
	add	hl, de
	ld	iy, (ix + 15)
	add	iy, de
	ld	c, (iy)
	ld	a, (hl)
	cp	a, c
	jr	nz, .LBB63_10
; %bb.8:                                ;   in Loop: Header=BB63_5 Depth=2
	ld	hl, (ix + 12)
	ld	bc, 240
	call	__imulu
	push	hl
	pop	bc
	ld	hl, (ix + 6)
	add	hl, bc
	add	hl, de
	push	hl
	pop	bc
	ld	l, (iy + 120)
	push	bc
	pop	iy
	ld	a, (iy + 120)
	cp	a, l
	jr	nz, .LBB63_10
; %bb.9:                                ;   in Loop: Header=BB63_5 Depth=2
	ld	iy, (ix - 12)
	inc	iy
	jr	.LBB63_5
	.local	.LBB63_10
.LBB63_10:                              ;   in Loop: Header=BB63_5 Depth=2
	ld	iy, (ix + 15)
	add	iy, de
	ld	a, (iy + 120)
	ld	(ix - 25), a
	ld	iy, (ix + 9)
	ld	de, 4096
	add	iy, de
	ld	de, (iy)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	ld	(ix - 15), iy
	jp	nc, .LBB63_18
; %bb.11:                               ;   in Loop: Header=BB63_5 Depth=2
	ld	hl, (ix + 9)
	add	hl, de
	inc	de
	ld	(iy), de
	ld	(hl), 17
	ld	de, (iy)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jp	nc, .LBB63_18
; %bb.12:                               ;   in Loop: Header=BB63_5 Depth=2
	ld	hl, (ix + 9)
	add	hl, de
	inc	de
	ld	(iy), de
	ld	(hl), -108
	ld	de, (iy)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jp	nc, .LBB63_18
; %bb.13:                               ;   in Loop: Header=BB63_5 Depth=2
	ld	bc, (ix + 9)
	push	bc
	pop	hl
	add	hl, de
	inc	de
	ld	(iy), de
	ld	(hl), 17
	ld	de, (iy)
	push	bc
	pop	iy
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	ld	bc, 4099
	jp	nc, .LBB63_19
; %bb.14:                               ;   in Loop: Header=BB63_5 Depth=2
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	iy, (ix - 15)
	ld	(iy), de
	ld	a, (ix - 25)
	ld	(hl), a
	ld	hl, (iy)
	ld	iy, (ix + 9)
	ld	(ix - 28), hl
	ld	de, 4096
	or	a, a
	sbc	hl, de
	jr	nc, .LBB63_19
; %bb.15:                               ;   in Loop: Header=BB63_5 Depth=2
	lea	hl, iy + 0
	ld	de, (ix - 28)
	add	hl, de
	inc	de
	ld	iy, (ix - 15)
	ld	(iy), de
	ld	(hl), 31
	ld	hl, (iy)
	ld	iy, (ix + 9)
	ld	(ix - 28), hl
	ld	de, 4096
	or	a, a
	sbc	hl, de
	jr	nc, .LBB63_20
; %bb.16:                               ;   in Loop: Header=BB63_5 Depth=2
	ld	hl, (ix - 12)
	ld	a, l
	lea	hl, iy + 0
	ld	de, (ix - 28)
	add	hl, de
	inc	de
	ld	iy, (ix - 15)
	ld	(iy), de
	ld	(hl), a
	ld	hl, (iy)
	ld	iy, (ix + 9)
	ld	(ix - 28), hl
	ld	de, 4096
	or	a, a
	sbc	hl, de
	jr	nc, .LBB63_20
; %bb.17:                               ;   in Loop: Header=BB63_5 Depth=2
	ld	de, (ix - 28)
	add	iy, de
	inc	de
	ld	hl, (ix - 15)
	ld	(hl), de
	ld	a, (ix - 29)
	ld	(iy), a
	jr	.LBB63_21
	.local	.LBB63_18
.LBB63_18:                              ;   in Loop: Header=BB63_5 Depth=2
	ld	iy, (ix + 9)
	lea	hl, iy + 0
	ld	bc, 4099
	add	hl, bc
	ld	(hl), 1
	.local	.LBB63_19
.LBB63_19:                              ;   in Loop: Header=BB63_5 Depth=2
	lea	hl, iy + 0
	add	hl, bc
	ld	(hl), 1
	.local	.LBB63_20
.LBB63_20:                              ;   in Loop: Header=BB63_5 Depth=2
	lea	hl, iy + 0
	add	hl, bc
	ld	(hl), 1
	.local	.LBB63_21
.LBB63_21:                              ;   in Loop: Header=BB63_5 Depth=2
	ld	bc, (ix - 12)
	push	bc
	pop	hl
	ld	de, 40
	or	a, a
	sbc	hl, de
	push	bc
	pop	hl
	jr	nc, .LBB63_23
; %bb.22:                               ;   in Loop: Header=BB63_5 Depth=2
	ld	hl, 39
	.local	.LBB63_23
.LBB63_23:                              ;   in Loop: Header=BB63_5 Depth=2
	inc	hl
	ld	(ix - 28), hl
	.local	.LBB63_24
.LBB63_24:                              ;   Parent Loop BB63_3 Depth=1
                                        ;     Parent Loop BB63_5 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ld	(ix - 12), bc
	ld	hl, (ix - 15)
	ld	bc, (hl)
	push	bc
	pop	hl
	ld	de, 4096
	or	a, a
	sbc	hl, de
	jr	nc, .LBB63_26
; %bb.25:                               ;   in Loop: Header=BB63_24 Depth=3
	ld	iy, (ix - 3)
	ld	de, (ix - 12)
	add	iy, de
	ld	a, (iy)
	ld	hl, (ix + 9)
	push	hl
	pop	iy
	add	iy, bc
	inc	bc
	ld	hl, (ix - 15)
	ld	(hl), bc
	ld	(iy), a
	push	de
	pop	bc
	jr	.LBB63_27
	.local	.LBB63_26
.LBB63_26:                              ;   in Loop: Header=BB63_24 Depth=3
	ld	hl, (ix + 9)
	ld	de, 4099
	add	hl, de
	ld	(hl), 1
	ld	bc, (ix - 12)
	.local	.LBB63_27
.LBB63_27:                              ;   in Loop: Header=BB63_24 Depth=3
	inc	bc
	push	bc
	pop	hl
	ld	de, 40
	or	a, a
	sbc	hl, de
	jr	nc, .LBB63_32
; %bb.28:                               ;   in Loop: Header=BB63_24 Depth=3
	ld	iy, (ix - 3)
	ld	de, (ix - 12)
	add	iy, de
	ld	a, (iy + 121)
	ld	l, (ix - 25)
	cp	a, l
	jr	nz, .LBB63_33
; %bb.29:                               ;   in Loop: Header=BB63_24 Depth=3
	ld	hl, (ix - 6)
	bit	0, (hl)
	jr	z, .LBB63_24
; %bb.30:                               ;   in Loop: Header=BB63_24 Depth=3
	ld	hl, (ix - 9)
	add	hl, de
	ld	e, (iy + 1)
	push	hl
	pop	iy
	ld	a, (iy + 1)
	cp	a, e
	jr	nz, .LBB63_24
; %bb.31:                               ;   in Loop: Header=BB63_24 Depth=3
	ld	a, (iy + 121)
	ld	l, (ix - 25)
	cp	a, l
	push	bc
	pop	iy
	jp	z, .LBB63_5
	jp	.LBB63_24
	.local	.LBB63_32
.LBB63_32:                              ;   in Loop: Header=BB63_5 Depth=2
	ld	iy, (ix - 28)
	jp	.LBB63_5
	.local	.LBB63_33
.LBB63_33:                              ;   in Loop: Header=BB63_5 Depth=2
	push	bc
	pop	iy
	jp	.LBB63_5
	.local	.LBB63_34
.LBB63_34:                              ;   in Loop: Header=BB63_3 Depth=1
	ld	hl, (ix - 21)
	inc	hl
	ld	iy, (ix - 9)
	lea	iy, iy + 40
	ld	(ix - 9), iy
	ld	iy, (ix - 3)
	lea	iy, iy + 40
	ld	(ix - 3), iy
	push	hl
	pop	iy
	ld	de, 0
	ld	bc, 3
	jp	.LBB63_3
	.local	.LBB63_35
.LBB63_35:
	ld	de, (ix - 18)
	ld	hl, (ix + 15)
	ld	bc, 240
	ldir
	ld	hl, (ix - 6)
	ld	(hl), 1
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end63
.Lfunc_end63:
	.size	__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE, .Lfunc_end63-__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_14textEiiPKcii,@function ; -- Begin function _ZN12_GLOBAL__N_14textEiiPKcii
__ZN12_GLOBAL__N_14textEiiPKcii:        ; @_ZN12_GLOBAL__N_14textEiiPKcii
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	hl, (ix + 6)
	ld	(ix - 6), hl
	ld	hl, (ix + 9)
	ld	(ix - 3), hl
	ld	hl, (ix + 12)
	push	hl
	call	_vdp_set_text_colour
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_vdp_set_text_bg_colour
	pop	hl
	ld	hl, 28
	push	hl
	ld	hl, (ix - 6)
	push	hl
	call	_vdp_cursor_tab
	pop	hl
	pop	hl
	ld	hl, (ix - 3)
	push	hl
	call	_strlen
	pop	de
	ld	de, (ix - 3)
	ld	(ix + 6), de
	ld	(ix + 9), hl
	ld	sp, ix
	pop	ix
	jp	__ZN2fs4sendEPKhj
	.local	.Lfunc_end64
.Lfunc_end64:
	.size	__ZN12_GLOBAL__N_14textEiiPKcii, .Lfunc_end64-__ZN12_GLOBAL__N_14textEiiPKcii
                                        ; -- End function
	.weak	__ZN5rally4game9routeSineEs     ; -- Begin function _ZN5rally4game9routeSineEs
	.type	__ZN5rally4game9routeSineEs,@function
__ZN5rally4game9routeSineEs:            ; @_ZN5rally4game9routeSineEs
; %bb.0:
	ld	hl, -16
	call	__frameset
	ld	de, (ix + 6)
	ld	l, e
	ld	h, d
	ld	iyl, e
	ld	iyh, d
	add.sis	iy, iy
	sbc.sis	hl, hl
	ld	c, l
	ld	b, h
	ld	l, e
	ld	h, d
	add.sis	hl, bc
	call	__sxor
	ld	bc, 0
	ld	c, l
	ld	b, h
	ld.sis	de, 16385
	or	a, a
	sbc.sis	hl, de
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	d, a
	ld	hl, 32768
	xor	a, a
	ld	e, a
	call	__lsub
	ld	a, e
	bit	0, d
	jr	nz, .LBB65_2
; %bb.1:
	push	bc
	pop	hl
	.local	.LBB65_2
.LBB65_2:
	ld	iy, __ZN5rally4gameL9RouteSineE
	bit	0, d
	jr	nz, .LBB65_4
; %bb.3:
	xor	a, a
	.local	.LBB65_4
.LBB65_4:
	ld	c, 6
	push	hl
	pop	de
	call	__ishru
	ld	c, 1
	ld	(ix - 3), hl
	call	__ishl
	push	hl
	pop	bc
	lea	hl, iy + 0
	add	hl, bc
	ld	iy, (hl)
	ld	bc, 16384
	ld	(ix - 6), de
	ex	de, hl
	or	a, a
	sbc	hl, bc
	jp	nc, .LBB65_6
; %bb.5:
	ld	bc, 63
	ld	e, a
	ld	a, iyh
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ex	de, hl
	ld	e, iyl
	ex	de, hl
	ld	(ix - 12), hl
	ld	(ix - 9), iy
	push	hl
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	(ix - 16), hl
	ld	hl, (ix - 6)
	xor	a, a
	call	__land
	ld	(ix - 6), hl
	ld	(ix - 13), e                    ; 1-byte Folded Spill
	ld	hl, (ix - 3)
	inc	hl
	ld	c, 1
	call	__ishl
	push	hl
	pop	de
	ld	hl, __ZN5rally4gameL9RouteSineE
	add	hl, de
	ld	de, (hl)
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	bc
	ld	b, a
	ld	c, e
	push	bc
	pop	hl
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	de
	push	bc
	pop	hl
                                        ; kill: def $e killed $e killed $ude
	ld	bc, (ix - 12)
	ld	iy, (ix - 16)
	ld	a, iyl
	call	__lsub
	ld	bc, (ix - 6)
	ld	a, (ix - 13)                    ; 1-byte Folded Reload
	call	__lmulu
	ld	bc, 64
	xor	a, a
	call	__ldivs
	push	hl
	pop	de
	ld	iy, (ix - 9)
	add.sis	iy, de
	.local	.LBB65_6
.LBB65_6:
	lea	hl, iy + 0
                                        ; kill: def $hl killed $hl killed $uhl
	call	__sneg
	ld	e, l
	ld	d, h
	ld.sis	bc, 0
	ld	hl, (ix + 6)
                                        ; kill: def $hl killed $hl killed $uhl
	or	a, a
	sbc.sis	hl, bc
	call	pe, __setflag
	jp	m, .LBB65_8
; %bb.7:
	ld	e, iyl
	ld	d, iyh
	.local	.LBB65_8
.LBB65_8:
	ld	l, e
	ld	h, d
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end65
.Lfunc_end65:
	.size	__ZN5rally4game9routeSineEs, .Lfunc_end65-__ZN5rally4game9routeSineEs
                                        ; -- End function
	.weak	__ZNK5rally4game5Rules14qualifyingGridEm ; -- Begin function _ZNK5rally4game5Rules14qualifyingGridEm
	.type	__ZNK5rally4game5Rules14qualifyingGridEm,@function
__ZNK5rally4game5Rules14qualifyingGridEm: ; @_ZNK5rally4game5Rules14qualifyingGridEm
; %bb.0:
	ld	hl, -11
	call	__frameset
	ld	iy, (ix + 6)
	ld	bc, 120
	xor	a, a
	ld	de, (iy + 2)
	ld	iy, 0
	lea	hl, iy + 0
	ld	l, e
	ld	h, d
	ld	e, a
	call	__lmulu
	ld	d, e
	ld	(ix - 3), hl
	ld	bc, (ix + 9)
	ld	a, (ix + 12)
	call	__lcmpu
	jr	nc, .LBB66_2
; %bb.1:
	ld	hl, (ix + 6)
	ld	hl, (hl)
	ex	de, hl
	ld	iyl, e
	ld	iyh, d
	ex	de, hl
	ld	e, 0
	lea	hl, iy + 0
	ld	bc, 120
	xor	a, a
	call	__lmulu
	ld	(ix - 6), hl
	ld	(ix - 7), e                     ; 1-byte Folded Spill
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	ld	iy, (ix - 3)
	lea	bc, iy + 0
	ld	a, d
	call	__lsub
	ld	bc, 6
	xor	a, a
	call	__lmulu
	ld	(ix - 10), hl
	ld	(ix - 11), e                    ; 1-byte Folded Spill
	ld	hl, (ix - 6)
	ld	e, (ix - 7)                     ; 1-byte Folded Reload
	lea	bc, iy + 0
	ld	a, d
	call	__lsub
	push	hl
	pop	iy
	ld	d, e
	ld	hl, (ix - 10)
	ld	e, (ix - 11)                    ; 1-byte Folded Reload
	ld	bc, -1
	ld	a, b
	call	__ladd
	lea	bc, iy + 0
	ld	a, d
	call	__ladd
	call	__ldivu
	inc	l
	jr	.LBB66_3
	.local	.LBB66_2
.LBB66_2:
	ld	l, 1
	.local	.LBB66_3
.LBB66_3:
	ld	a, l
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end66
.Lfunc_end66:
	.size	__ZNK5rally4game5Rules14qualifyingGridEm, .Lfunc_end66-__ZNK5rally4game5Rules14qualifyingGridEm
                                        ; -- End function
	.weak	__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh ; -- Begin function _ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh
	.type	__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh,@function
__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh: ; @_ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh
; %bb.0:
	ld	hl, -15
	call	__frameset
	ld	bc, (ix + 6)
	ld	a, (ix + 9)
	ld	de, 183
	push	bc
	pop	hl
	push	bc
	pop	iy
	add	hl, de
	ld	(hl), a
	inc	de
	add	iy, de
	ld	hl, (ix + 12)
	ld	(iy), hl
	lea	hl, iy + 3
	ld	a, (ix + 15)
	ld	(hl), a
	or	a, a
	sbc	hl, hl
	ld	l, (ix + 21)
	ld	e, d
	ld	bc, (ix + 12)
	ld	a, (ix + 15)
	call	__lmulu
	ld	bc, (ix + 6)
	push	bc
	pop	iy
	ld	bc, 188
	add	iy, bc
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), e
	ld	de, 192
	ld	iy, (ix + 6)
	add	iy, de
	ld	bc, 0
	ld	(iy), bc
	lea	hl, iy + 3
	ld	(hl), b
	ld	de, 196
	ld	iy, (ix + 6)
	lea	hl, iy + 0
	add	hl, de
	ld	a, (ix + 18)
	ld	(hl), a
	ld	de, 174
	lea	hl, iy + 0
	add	hl, de
	ld	(hl), b
	inc	de
	lea	hl, iy + 0
	add	hl, de
	ld.sis	de, 60
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ld	de, 177
	lea	hl, iy + 0
	add	hl, de
	ld.sis	de, 0
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ld	de, 179
	add	iy, de
	ld	(iy), bc
	lea	hl, iy + 3
	ld	(hl), b
	or	a, a
	sbc	hl, hl
	ld	l, a
	ld	(ix - 6), hl
	ld	de, 6
	ld	bc, 29
	ld	iy, 0
	.local	.LBB67_1
.LBB67_1:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jp	z, .LBB67_14
; %bb.2:                                ;   in Loop: Header=BB67_1 Depth=1
	lea	hl, iy + 0
	call	__imulu
	push	hl
	pop	de
	ld	hl, (ix + 6)
	add	hl, de
	ld	(hl), 0
	ld	(ix - 3), iy
	push	hl
	pop	iy
	inc	iy
	lea	de, iy + 0
	push	hl
	pop	iy
	ld	bc, 20
	ldir
	ld.sis	hl, 60
	ld	(iy + 21), l
	ld	(iy + 22), h
	ld.sis	hl, 0
	ld	(iy + 23), l
	ld	(iy + 24), h
	or	a, a
	sbc	hl, hl
	ld	(iy + 25), hl
	ld	(iy + 28), h
	ld	a, (ix + 9)
	or	a, a
	jp	nz, .LBB67_12
; %bb.3:                                ;   in Loop: Header=BB67_1 Depth=1
	ld	(iy), 1
	ld	hl, (ix - 3)
	push	hl
	pop	de
	ld	bc, 29
	call	__imulu
	push	hl
	pop	bc
	ld	iy, (ix + 6)
	add	iy, bc
	ld.sis	hl, 1
	ld	(iy + 1), l
	ld	(iy + 2), h
	push	de
	pop	bc
	inc	bc
	push	bc
	pop	hl
	ld	de, (ix - 6)
	or	a, a
	sbc	hl, de
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	l, a
	inc	l
	ld	(ix - 12), bc
	ld	a, c
	add	a, l
	ld	(ix - 9), iy
	ld	(iy + 3), a
	ld	hl, (ix - 3)
	call	__inot
	push	hl
	pop	iy
	add	iy, de
	lea	hl, iy + 0
	ld	de, 1
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	ld	de, -1
	jp	m, .LBB67_5
; %bb.4:                                ;   in Loop: Header=BB67_1 Depth=1
	ld	de, 0
	.local	.LBB67_5
.LBB67_5:                               ;   in Loop: Header=BB67_1 Depth=1
	add	iy, de
	lea	hl, iy + 0
	lea	bc, iy + 0
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	de
	push	bc
	pop	hl
                                        ; kill: def $e killed $e killed $ude
	ld	bc, 10000
	xor	a, a
	call	__lmulu
	ld	iy, (ix - 9)
	ld	(iy + 4), hl
	ld	(iy + 7), e
	ld	iy, (ix + 6)
	ld	bc, 184
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lrems
	ld	d, e
	ld	(ix - 15), hl
	call	__lcmpzero
	ld	l, 1
	jp	m, .LBB67_7
; %bb.6:                                ;   in Loop: Header=BB67_1 Depth=1
	ld	l, 0
	.local	.LBB67_7
.LBB67_7:                               ;   in Loop: Header=BB67_1 Depth=1
	bit	0, l
	jr	nz, .LBB67_9
; %bb.8:                                ;   in Loop: Header=BB67_1 Depth=1
	ld	bc, 0
	.local	.LBB67_9
.LBB67_9:                               ;   in Loop: Header=BB67_1 Depth=1
	bit	0, l
	jr	nz, .LBB67_11
; %bb.10:                               ;   in Loop: Header=BB67_1 Depth=1
	xor	a, a
	.local	.LBB67_11
.LBB67_11:                              ;   in Loop: Header=BB67_1 Depth=1
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 15)
	ld	a, d
	call	__ladd
	ld	iy, (ix - 9)
	ld	(iy + 8), hl
	ld	(iy + 11), e
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZN5rally4game11RaceTraffic5placeEj
	pop	hl
	pop	hl
	ld	iy, (ix - 12)
	jr	.LBB67_13
	.local	.LBB67_12
.LBB67_12:                              ;   in Loop: Header=BB67_1 Depth=1
	ld	iy, (ix - 3)
	inc	iy
	.local	.LBB67_13
.LBB67_13:                              ;   in Loop: Header=BB67_1 Depth=1
	ld	de, 6
	ld	bc, 29
	jp	.LBB67_1
	.local	.LBB67_14
.LBB67_14:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end67
.Lfunc_end67:
	.size	__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh, .Lfunc_end67-__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh
                                        ; -- End function
	.weak	__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm ; -- Begin function _ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm
	.type	__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm,@function
__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm: ; @_ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm
; %bb.0:
	ld	hl, -10
	call	__frameset
	ld	iy, (ix + 6)
	ld	bc, 0
	ld	hl, (iy)
	ld	(ix - 3), hl
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB68_3
; %bb.1:
	ld	hl, (iy + 2)
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	z, .LBB68_8
; %bb.2:
	dec.sis	hl
	ld	(iy + 2), l
	ld	(iy + 3), h
	jp	.LBB68_8
	.local	.LBB68_3
.LBB68_3:
	ld	iy, (ix + 9)
	ld	(iy + 11), bc
	ld	(iy + 14), 0
	ld	(iy + 19), bc
	ld	(iy + 22), 0
	ld.sis	de, 1
	ld	hl, (ix - 3)
                                        ; kill: def $hl killed $hl killed $uhl
	or	a, a
	sbc.sis	hl, de
	jp	nz, .LBB68_7
	.local	.LBB68_4
.LBB68_4:                               ; =>This Inner Loop Header: Depth=1
	ld	(ix - 6), bc
	push	bc
	pop	iy
	ld	bc, 3
	add	iy, bc
	lea	hl, iy + 0
	ld	bc, 18
	or	a, a
	sbc	hl, bc
	jp	z, .LBB68_8
; %bb.5:                                ;   in Loop: Header=BB68_4 Depth=1
	ld	hl, ___const._ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm.lanes
	ld	bc, (ix - 6)
	add	hl, bc
	ld	bc, (hl)
	push	bc
	pop	hl
	ld	(ix - 6), iy
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	a, l
	ld	l, 8
	call	__lshl
	ld	(ix - 10), a                    ; 1-byte Folded Spill
	ld	l, a
	push	hl
	ld	(ix - 9), bc
	push	bc
	ld	l, (ix + 18)
	push	hl
	ld	hl, (ix + 15)
	push	hl
	ld	hl, (ix + 12)
	push	hl
	call	__ZNK5rally4game11RaceTraffic7contactEml
	ld	iy, (ix + 6)
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	ld	bc, (ix - 6)
	jr	nz, .LBB68_4
; %bb.6:
	ld	hl, (ix + 9)
	ex	de, hl
	ld	hl, (ix - 9)
	lea	bc, iy + 0
	push	de
	pop	iy
	ld	(iy + 15), hl
	ex	de, hl
	ld	a, (ix - 10)
	push	hl
	pop	iy
	ld	(iy + 18), a
	ld.sis	hl, 0
	ld	(iy + 23), l
	ld	(iy + 24), h
	push	bc
	pop	iy
	ld	(iy), l
	ld	(iy + 1), h
	ld.sis	hl, 120
	ld	(iy + 2), l
	ld	(iy + 3), h
	jp	.LBB68_8
	.local	.LBB68_7
.LBB68_7:
	ld	hl, (ix - 3)
                                        ; kill: def $hl killed $hl killed $uhl
	dec.sis	hl
	ld	iy, (ix + 6)
	ld	(iy), l
	ld	(iy + 1), h
	.local	.LBB68_8
.LBB68_8:
	ld	hl, (ix - 3)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB68_10
; %bb.9:
	ld	a, 0
	jr	.LBB68_11
	.local	.LBB68_10
.LBB68_10:
	ld	a, -1
	.local	.LBB68_11
.LBB68_11:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end68
.Lfunc_end68:
	.size	__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm, .Lfunc_end68-__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm
                                        ; -- End function
	.weak	__ZN5rally4game11RaceTraffic5placeEj ; -- Begin function _ZN5rally4game11RaceTraffic5placeEj
	.type	__ZN5rally4game11RaceTraffic5placeEj,@function
__ZN5rally4game11RaceTraffic5placeEj:   ; @_ZN5rally4game11RaceTraffic5placeEj
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	bc, 1
	ld	de, -1
	call	__iand
	bit	0, l
	jr	z, .LBB69_2
; %bb.1:
	push	de
	pop	bc
	.local	.LBB69_2
.LBB69_2:
	ld	(ix - 3), bc
	ld	de, 174
	add	iy, de
	ld	(ix - 9), iy
	ld	bc, 29
	ld	hl, (ix + 9)
	call	__imulu
	push	hl
	pop	de
	ld	iy, (ix + 6)
	add	iy, de
	ld	(ix - 6), iy
	lea	de, iy + 20
	ld	hl, (ix - 9)
	ld	bc, 9
	ldir
	ld	hl, (ix + 9)
	ld	bc, 3
	call	__iremu
	ld	bc, 36
	call	__imulu
	ld	de, -36
	add	hl, de
	push	hl
	pop	bc
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	e, 8
	ld	a, l
	ld	l, e
	call	__lshl
	ld	(ix - 9), bc
	ld	d, a
	ld	hl, (ix - 3)
	push	hl
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	(ix - 12), hl
	ld	bc, 179
	ld	iy, (ix + 6)
	add	iy, bc
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, -5044
	ld	a, -1
	call	__ladd
	ld	bc, (ix - 3)
	ld	iy, (ix - 12)
	ld	a, iyl
	call	__lmulu
	ld	bc, (ix - 9)
	ld	a, d
	call	__ladd
	ld	iy, (ix - 6)
	ld	(iy + 12), hl
	ld	(iy + 15), e
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end69
.Lfunc_end69:
	.size	__ZN5rally4game11RaceTraffic5placeEj, .Lfunc_end69-__ZN5rally4game11RaceTraffic5placeEj
                                        ; -- End function
	.weak	__ZNK5rally4game11RaceTraffic7contactEml ; -- Begin function _ZNK5rally4game11RaceTraffic7contactEml
	.type	__ZNK5rally4game11RaceTraffic7contactEml,@function
__ZNK5rally4game11RaceTraffic7contactEml: ; @_ZNK5rally4game11RaceTraffic7contactEml
; %bb.0:
	ld	hl, -7
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	de, (ix + 15)
	ld	(ix - 3), de
	ld	a, (ix + 18)
	ld	(ix - 4), a
	ld	de, 184
	ld	(ix - 7), iy
	add	iy, de
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	ld	e, (ix + 12)
	call	__lrems
	push	hl
	pop	iy
	ld	d, e
	call	__lcmpzero
	jp	m, .LBB70_2
; %bb.1:
	ld	l, 0
	jr	.LBB70_3
	.local	.LBB70_2
.LBB70_2:
	ld	l, 1
	.local	.LBB70_3
.LBB70_3:
	bit	0, l
	jr	nz, .LBB70_5
; %bb.4:
	ld	bc, 0
	.local	.LBB70_5
.LBB70_5:
	bit	0, l
	jr	nz, .LBB70_7
; %bb.6:
	xor	a, a
	.local	.LBB70_7
.LBB70_7:
	push	bc
	pop	hl
	ld	e, a
	lea	bc, iy + 0
	ld	a, d
	call	__ladd
	ld	bc, (ix - 7)
	ld	(ix + 6), bc
	ld	(ix + 9), hl
	ld	(ix + 12), e
	ld	hl, (ix - 3)
	ld	(ix + 15), hl
	ld	a, (ix - 4)
	ld	(ix + 18), a
	ld	sp, ix
	pop	ix
	jp	__ZNK5rally4game11RaceTraffic14contactStationEll
	.local	.Lfunc_end70
.Lfunc_end70:
	.size	__ZNK5rally4game11RaceTraffic7contactEml, .Lfunc_end70-__ZNK5rally4game11RaceTraffic7contactEml
                                        ; -- End function
	.weak	__ZNK5rally4game11RaceTraffic14contactStationEll ; -- Begin function _ZNK5rally4game11RaceTraffic14contactStationEll
	.type	__ZNK5rally4game11RaceTraffic14contactStationEll,@function
__ZNK5rally4game11RaceTraffic14contactStationEll: ; @_ZNK5rally4game11RaceTraffic14contactStationEll
; %bb.0:
	ld	hl, -22
	call	__frameset
	ld	iy, (ix + 6)
	xor	a, a
	ld	de, 184
	add	iy, de
	ld	bc, (iy)
	lea	hl, iy + 3
	ld	d, (hl)
	push	bc
	pop	iy
	lea	hl, iy + 0
	ld	e, d
	ld	bc, 2
	call	__ldivs
	ld	(ix - 7), hl
	ld	(ix - 8), e                     ; 1-byte Folded Spill
	lea	hl, iy + 0
	ld	e, d
	ld	bc, -2
	dec	a
	call	__ldivs
	ld	(ix - 11), hl
	ld	(ix - 12), e                    ; 1-byte Folded Spill
	ld	(ix - 3), iy
	lea	hl, iy + 0
	ld	(ix - 4), d                     ; 1-byte Folded Spill
	ld	e, d
	call	__lneg
	ld	(ix - 15), hl
	ld	(ix - 16), e                    ; 1-byte Folded Spill
	ld	bc, 174
	ld	iy, 0
	.local	.LBB71_1
.LBB71_1:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	z, .LBB71_18
; %bb.2:                                ;   in Loop: Header=BB71_1 Depth=1
	lea	de, iy + 0
	ld	hl, (ix + 6)
	add	hl, de
	bit	0, (hl)
	jp	z, .LBB71_17
; %bb.3:                                ;   in Loop: Header=BB71_1 Depth=1
	ld	(ix - 22), iy
	lea	de, iy + 0
	ld	iy, (ix + 6)
	add	iy, de
	ld	hl, (iy + 8)
	ld	e, (iy + 11)
	ld	bc, (ix + 9)
	ld	a, (ix + 12)
	call	__lsub
	push	hl
	pop	bc
	ld	iyl, e
	ld	hl, (ix - 7)
	ld	e, (ix - 8)                     ; 1-byte Folded Reload
	ld	(ix - 19), bc
	ld	a, iyl
	call	__lcmps
	call	pe, __setflag
	ld	d, 1
	jp	m, .LBB71_5
; %bb.4:                                ;   in Loop: Header=BB71_1 Depth=1
	ld	d, 0
	.local	.LBB71_5
.LBB71_5:                               ;   in Loop: Header=BB71_1 Depth=1
	ld	hl, (ix - 19)
	ld	e, iyl
	ld	bc, (ix - 11)
	ld	a, (ix - 12)                    ; 1-byte Folded Reload
	call	__lcmps
	call	pe, __setflag
	ld	a, 1
	jp	m, .LBB71_7
; %bb.6:                                ;   in Loop: Header=BB71_1 Depth=1
	ld	a, 0
	.local	.LBB71_7
.LBB71_7:                               ;   in Loop: Header=BB71_1 Depth=1
	bit	0, a
	ld	hl, (ix - 3)
	jr	nz, .LBB71_9
; %bb.8:                                ;   in Loop: Header=BB71_1 Depth=1
	or	a, a
	sbc	hl, hl
	.local	.LBB71_9
.LBB71_9:                               ;   in Loop: Header=BB71_1 Depth=1
	bit	0, a
	ld	e, (ix - 4)                     ; 1-byte Folded Reload
	jr	nz, .LBB71_11
; %bb.10:                               ;   in Loop: Header=BB71_1 Depth=1
	ld	e, 0
	.local	.LBB71_11
.LBB71_11:                              ;   in Loop: Header=BB71_1 Depth=1
	bit	0, d
	ld	bc, (ix - 15)
	jr	nz, .LBB71_13
; %bb.12:                               ;   in Loop: Header=BB71_1 Depth=1
	push	hl
	pop	bc
	.local	.LBB71_13
.LBB71_13:                              ;   in Loop: Header=BB71_1 Depth=1
	bit	0, d
	ld	a, (ix - 16)                    ; 1-byte Folded Reload
	jr	nz, .LBB71_15
; %bb.14:                               ;   in Loop: Header=BB71_1 Depth=1
	ld	a, e
	.local	.LBB71_15
.LBB71_15:                              ;   in Loop: Header=BB71_1 Depth=1
	ld	hl, (ix - 19)
	ld	e, iyl
	call	__ladd
	push	hl
	pop	iy
	lea	bc, iy + 0
	ld	a, e
	ld	l, 31
	call	__lshrs
	lea	hl, iy + 0
	call	__ladd
	call	__lxor
	ld	bc, 3200
	xor	a, a
	call	__lcmpu
	ld	bc, 174
	ld	iy, (ix - 22)
	jr	nc, .LBB71_17
; %bb.16:                               ;   in Loop: Header=BB71_1 Depth=1
	lea	de, iy + 0
	ld	iy, (ix + 6)
	add	iy, de
	ld	hl, (iy + 12)
	ld	e, (iy + 15)
	ld	iy, (ix - 22)
	ld	bc, (ix + 15)
	ld	a, (ix + 18)
	call	__lsub
	push	hl
	pop	bc
	ld	(ix - 19), bc
	ld	a, e
	ld	l, 31
	call	__lshrs
	ld	hl, (ix - 19)
	call	__ladd
	call	__lxor
	ld	bc, 6144
	xor	a, a
	call	__lcmpu
	ld	bc, 174
	jr	c, .LBB71_18
	.local	.LBB71_17
.LBB71_17:                              ;   in Loop: Header=BB71_1 Depth=1
	ld	de, 29
	add	iy, de
	jp	.LBB71_1
	.local	.LBB71_18
.LBB71_18:
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB71_20
; %bb.19:
	ld	a, 0
	jr	.LBB71_21
	.local	.LBB71_20
.LBB71_20:
	ld	a, -1
	.local	.LBB71_21
.LBB71_21:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end71
.Lfunc_end71:
	.size	__ZNK5rally4game11RaceTraffic14contactStationEll, .Lfunc_end71-__ZNK5rally4game11RaceTraffic14contactStationEll
                                        ; -- End function
	.section	.bss,"aw",@nobits
	.global	_fs_reply
_fs_reply:
	.skip	10

	.global	_fs_ready
_fs_ready:
	.skip	1

	.global	_ticks
_ticks:
	.skip	3

	.global	_elapsed
_elapsed:
	.skip	3

	.global	__ZN2fs6handleE
__ZN2fs6handleE:
	.skip	2

	.global	__ZN2fs5tokenE
__ZN2fs5tokenE:
	.skip	2

	.global	__ZN2fs10generationE
__ZN2fs10generationE:
	.skip	4

	.global	__ZN2fs7requestE
__ZN2fs7requestE:
	.skip	4

	.global	__ZN2fs5worldE
__ZN2fs5worldE:
	.skip	4

	.global	__ZN2fs6sendMsE
__ZN2fs6sendMsE:
	.skip	4

	.global	__ZN2fs6waitMsE
__ZN2fs6waitMsE:
	.skip	4

	.global	__ZN2fs9wireBytesE
__ZN2fs9wireBytesE:
	.skip	4

	.global	__ZN2fs11scrollCallsE
__ZN2fs11scrollCallsE:
	.skip	4

	.global	__ZN2fs12repaintCallsE
__ZN2fs12repaintCallsE:
	.skip	4

	.global	__ZN2fs14skyRepairCallsE
__ZN2fs14skyRepairCallsE:
	.skip	4

	.global	__ZN2fs8hudBytesE
__ZN2fs8hudBytesE:
	.skip	4

	.global	__ZN2fs11footerCallsE
__ZN2fs11footerCallsE:
	.skip	4

	.global	__ZN2fs11moduleBytesE
__ZN2fs11moduleBytesE:
	.skip	4

	.section	.data,"aw",@progbits
	.global	__ZN2fs10frameCountE
__ZN2fs10frameCountE:
	d24	900                             ; 0x384

	.section	.bss,"aw",@nobits
	.global	__ZN2fs10transcriptE
__ZN2fs10transcriptE:
	.skip	100000

	.global	__ZN2fs15transcriptBytesE
__ZN2fs15transcriptBytesE:
	.skip	3

	.global	__ZN2fs17compactConfiguredE
__ZN2fs17compactConfiguredE:
	.skip	1

	.global	__ZN2fs12reducedReadsE
__ZN2fs12reducedReadsE:
	.skip	1

	.global	__ZN2fs7pendingE
__ZN2fs7pendingE:
	.skip	1

	.global	__ZN2fs9installedE
__ZN2fs9installedE:
	.skip	1

	.global	__ZN2fs3prtE
__ZN2fs3prtE:
	.skip	1

	.section	.data,"aw",@progbits
	.global	__ZN2fs7healthyE
__ZN2fs7healthyE:
	db	1                               ; 0x1

	.section	.bss,"aw",@nobits
	.global	__ZN2fs13timerRestoredE
__ZN2fs13timerRestoredE:
	.skip	1

	.global	__ZN2fs8unloadedE
__ZN2fs8unloadedE:
	.skip	1

	.global	__ZN2fs13previousTimerE
__ZN2fs13previousTimerE:
	.skip	3

	.section	.rodata,"a",@progbits
	.local	_.str
_.str:
	db	"none", 0

	.section	.data,"aw",@progbits
	.global	__ZN2fs7failureE
__ZN2fs7failureE:
	d24	_.str

	.section	.rodata,"a",@progbits
	.local	_.str.1
_.str.1:
	db	"VDPL callback timeout", 0

	.local	_.str.2
_.str.2:
	db	"VDPL reply identity", 0

	.local	_.str.3
_.str.3:
	db	"Transcript capacity", 0

	.local	_.str.4
_.str.4:
	db	"VDPL retained-state check", 0

	.local	_.str.5
_.str.5:
	db	"VDPL RUN status", 0

	.local	_.str.6
_.str.6:
	db	"rb", 0

	.local	_.str.7
_.str.7:
	db	"Input file open", 0

	.local	_.str.8
_.str.8:
	db	"Input file read", 0

	.local	_.str.9
_.str.9:
	db	"config.bin", 0

	.local	_.str.10
_.str.10:
	db	"Configuration open", 0

	.local	_.str.11
_.str.11:
	db	"R28F", 0

	.local	_.str.12
_.str.12:
	db	"Configuration identity", 0

	.local	_.str.13
_.str.13:
	db	"Configuration module bounds", 0

	.local	_.str.14
_.str.14:
	db	"module.vdu", 0

	.local	_.str.15
_.str.15:
	db	"Native LOAD", 0

	.local	_.str.16
_.str.16:
	db	"Video mode", 0

	.local	_.str.17
_.str.17:
	db	"assets.vdu", 0

	.local	_.str.18
_.str.18:
	db	"artwork.vdu", 0

	.local	_.str.19
_.str.19:
	db	"presentation.vdu", 0

	.local	_.str.20
_.str.20:
	db	"common.vdu", 0

	.local	_.str.21
_.str.21:
	db	"native.vdu", 0

	.local	__ZN2fsL8WrappersE
__ZN2fsL8WrappersE:
	dw	10                              ; 0xa
	dw	11                              ; 0xb
	dw	12                              ; 0xc
	dw	13                              ; 0xd
	dw	14                              ; 0xe
	dw	15                              ; 0xf
	dw	16                              ; 0x10
	dw	17                              ; 0x11
	dw	18                              ; 0x12
	dw	19                              ; 0x13
	dw	20                              ; 0x14
	dw	21                              ; 0x15
	dw	22                              ; 0x16
	dw	23                              ; 0x17
	dw	24                              ; 0x18
	dw	25                              ; 0x19
	dw	26                              ; 0x1a

	.local	___const._ZN2fs5setupEv.capacities
___const._ZN2fs5setupEv.capacities:
	dw	20480                           ; 0x5000
	dw	2048                            ; 0x800
	dw	256                             ; 0x100

	.local	__ZN2fsL7OutputsE
__ZN2fsL7OutputsE:
	dw	50301                           ; 0xc47d
	dw	50302                           ; 0xc47e
	dw	50303                           ; 0xc47f

	.local	_.str.22
_.str.22:
	db	"PRT1 busy", 0

	.local	_.str.23
_.str.23:
	db	"PRT vector restoration mismatch", 0

	.local	_.str.24
_.str.24:
	db	"Native UNLOAD", 0

	.local	_.str.25
_.str.25:
	db	"wb", 0

	.local	___const.vdp_draw_bitmap.b
___const.vdp_draw_bitmap.b:
	db	23, 27, 3, 0, 0, 0, 0

	.local	___const.vdp_swap.b
___const.vdp_swap.b:
	db	23, 0, 195

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_16streamE
__ZN12_GLOBAL__N_16streamE:
	.skip	4100

	.section	.rodata,"a",@progbits
	.local	_.str.26
_.str.26:
	db	"Initial native pose", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_16engineE
__ZN12_GLOBAL__N_16engineE:
	.skip	4

	.local	__ZN12_GLOBAL__N_112finishFramesE
__ZN12_GLOBAL__N_112finishFramesE:
	.skip	4

	.local	__ZN12_GLOBAL__N_15timesE
__ZN12_GLOBAL__N_15timesE:
	.skip	3604

	.local	__ZN12_GLOBAL__N_14prtsE
__ZN12_GLOBAL__N_14prtsE:
	.skip	3604

	.local	__ZN12_GLOBAL__N_110inputPollsE
__ZN12_GLOBAL__N_110inputPollsE:
	.skip	4

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_16motionE
__ZN12_GLOBAL__N_16motionE:
	d24	__ZN5rallyL4FujiE
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	dw	0                               ; 0x0
	dw	0                               ; 0x0
	d24	60                              ; 0x3c
	db	1                               ; 0x1

	.local	__ZN12_GLOBAL__N_15rulesE
__ZN12_GLOBAL__N_15rulesE:
	dw	20                              ; 0x14
	dw	11                              ; 0xb
	dw	20                              ; 0x14
	dw	16                              ; 0x10
	db	6                               ; 0x6
	db	0                               ; 0x0
	db	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	dw	0                               ; 0x0
	dw	0                               ; 0x0
	db	0                               ; 0x0
	db	7                               ; 0x7
	db	7                               ; 0x7
	d24	60                              ; 0x3c

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_112audioChangesE
__ZN12_GLOBAL__N_112audioChangesE:
	.skip	4

	.section	.rodata,"a",@progbits
	.local	__ZN2fsL7BuffersE
__ZN2fsL7BuffersE:
	dw	1                               ; 0x1
	dw	0                               ; 0x0
	dw	310                             ; 0x136
	dw	2                               ; 0x2
	dw	0                               ; 0x0
	dw	12                              ; 0xc
	dw	3                               ; 0x3
	dw	0                               ; 0x0
	dw	24                              ; 0x18
	dw	4                               ; 0x4
	dw	0                               ; 0x0
	dw	24                              ; 0x18
	dw	5                               ; 0x5
	dw	0                               ; 0x0
	dw	24                              ; 0x18
	dw	6                               ; 0x6
	dw	0                               ; 0x0
	dw	12                              ; 0xc

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_110finalStateE
__ZN12_GLOBAL__N_110finalStateE:
	.skip	406

	.section	.rodata,"a",@progbits
	.local	_.str.27
_.str.27:
	db	"Result file write", 0

	.local	_.str.29
_.str.29:
	db	"failure.txt", 0

	.local	_.str.30
_.str.30:
	db	"%s", 10, 0

	.local	_.str.31
_.str.31:
	db	"RALLY-28 FULL RACE FAILED: %s", 10, 0

	.local	_.str.32
_.str.32:
	db	"result.json", 0

	.local	_.str.33
_.str.33:
	db	"state.bin", 0

	.local	_.str.34
_.str.34:
	db	"ticks.bin", 0

	.local	_.str.35
_.str.35:
	db	"prt.bin", 0

	.local	_.str.36
_.str.36:
	db	"replies.bin", 0

	.local	_.str.37
_.str.37:
	db	"stages.csv", 0

	.local	_.str.38
_.str.38:
	db	"player.csv", 0

	.local	_.str.39
_.str.39:
	db	"coverage.json", 0

	.local	_.str.40
_.str.40:
	db	"capture.ready", 0

	.local	___const._ZN12_GLOBAL__N_112clearOutputsEv.names
___const._ZN12_GLOBAL__N_112clearOutputsEv.names:
	d24	_.str.32
	d24	_.str.29
	d24	_.str.33
	d24	_.str.34
	d24	_.str.35
	d24	_.str.36
	d24	_.str.37
	d24	_.str.38
	d24	_.str.39
	d24	_.str.40

	.local	__ZN5rally4gameL9FujiRulesE
__ZN5rally4gameL9FujiRulesE:
	dw	90                              ; 0x5a
	dw	60                              ; 0x3c
	dw	85                              ; 0x55
	dw	75                              ; 0x4b
	db	2                               ; 0x2

	.local	_.str.41
_.str.41:
	db	"motion.bin", 0

	.local	_.str.42
_.str.42:
	db	"Motion open", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_111motionBytesE
__ZN12_GLOBAL__N_111motionBytesE:
	.skip	21600

	.section	.rodata,"a",@progbits
	.local	_.str.43
_.str.43:
	db	"Motion input size", 0

	.local	_.str.44
_.str.44:
	db	"capture.req", 0

	.local	_.str.45
_.str.45:
	db	"Capture request size", 0

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_112captureStageE
__ZN12_GLOBAL__N_112captureStageE:
	dw	65535                           ; 0xffff

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_112captureFrameE
__ZN12_GLOBAL__N_112captureFrameE:
	.skip	2

	.section	.rodata,"a",@progbits
	.local	_.str.46
_.str.46:
	db	"Capture request bounds", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_114sceneryHistoryE
__ZN12_GLOBAL__N_114sceneryHistoryE:
	.skip	11

	.local	__ZN12_GLOBAL__N_15sceneE.1
__ZN12_GLOBAL__N_15sceneE.1:
	.skip	3

	.local	__ZN12_GLOBAL__N_15sceneE.2
__ZN12_GLOBAL__N_15sceneE.2:
	.skip	3

	.local	__ZN12_GLOBAL__N_15sceneE.3
__ZN12_GLOBAL__N_15sceneE.3:
	.skip	3

	.local	__ZN12_GLOBAL__N_15sceneE.4
__ZN12_GLOBAL__N_15sceneE.4:
	.skip	1

	.section	.rodata,"a",@progbits
	.local	__ZN5rallyL11HeadingAtanE
__ZN5rallyL11HeadingAtanE:
	db	0, 1, 1, 2, 3, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 27, 27, 28, 28, 29, 30, 30, 31, 31, " !!", 34, 34, "#$$%&&''())**+,,--../001123344556778899::;<<==>>??@AABBCCDDEEFFGGHHIJJKKLLMMNNOOPPQQRRSSTTTUUVVWWXXYYZZ[[[", 92, 92, "]]^^__```aabbcccddeefffgghhhiijjjkklllmmnnnoopppqqqrrssstttuuvvvwwwxxxyyyzzz{{{|||}}}~~~", 127, 127, 127, 128, 128

	.local	__ZN5rallyL4FujiE
__ZN5rallyL4FujiE:
	d24	__ZN5rallyL10FujiPointsE
	d24	512                             ; 0x200
	d32	32768                           ; 0x8000
	d24	_.str.53

	.local	_.str.47
_.str.47:
	db	"TOP %07lu", 0

	.local	_.str.48
_.str.48:
	db	"TIME %03lu", 0

	.local	_.str.49
_.str.49:
	db	"LAP %s", 0

	.local	_.str.50
_.str.50:
	db	"SCORE %07lu", 0

	.local	_.str.51
_.str.51:
	db	"SPEED %03ld", 0

	.local	_.str.52
_.str.52:
	db	"POS %d/7", 0

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_13hudE
__ZN12_GLOBAL__N_13hudE:
	.zero	120,32
	.zero	120,15
	.zero	120,32
	.zero	120,15
	.zero	2

	.section	.rodata,"a",@progbits
	.local	__ZN5rallyL10FujiPointsE
__ZN5rallyL10FujiPointsE:
	dw	0                               ; 0x0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64                              ; 0x40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	128                             ; 0x80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	192                             ; 0xc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	256                             ; 0x100
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	320                             ; 0x140
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	384                             ; 0x180
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	448                             ; 0x1c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	512                             ; 0x200
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	576                             ; 0x240
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	640                             ; 0x280
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	704                             ; 0x2c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	768                             ; 0x300
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	832                             ; 0x340
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	896                             ; 0x380
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	960                             ; 0x3c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1024                            ; 0x400
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1088                            ; 0x440
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1152                            ; 0x480
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1216                            ; 0x4c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1280                            ; 0x500
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1344                            ; 0x540
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1408                            ; 0x580
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1472                            ; 0x5c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1536                            ; 0x600
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1600                            ; 0x640
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1664                            ; 0x680
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1728                            ; 0x6c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1792                            ; 0x700
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1856                            ; 0x740
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1920                            ; 0x780
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	1984                            ; 0x7c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2048                            ; 0x800
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2112                            ; 0x840
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2176                            ; 0x880
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2240                            ; 0x8c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2304                            ; 0x900
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2368                            ; 0x940
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2432                            ; 0x980
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2496                            ; 0x9c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2560                            ; 0xa00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2624                            ; 0xa40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2688                            ; 0xa80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2752                            ; 0xac0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2816                            ; 0xb00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2880                            ; 0xb40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	2944                            ; 0xb80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3008                            ; 0xbc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3072                            ; 0xc00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3136                            ; 0xc40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3200                            ; 0xc80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3264                            ; 0xcc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3328                            ; 0xd00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3392                            ; 0xd40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3456                            ; 0xd80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3520                            ; 0xdc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3584                            ; 0xe00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3648                            ; 0xe40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3712                            ; 0xe80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3776                            ; 0xec0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3840                            ; 0xf00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3904                            ; 0xf40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	3968                            ; 0xf80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4032                            ; 0xfc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4160                            ; 0x1040
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4224                            ; 0x1080
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4288                            ; 0x10c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4352                            ; 0x1100
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4416                            ; 0x1140
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4480                            ; 0x1180
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4544                            ; 0x11c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4608                            ; 0x1200
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4672                            ; 0x1240
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4736                            ; 0x1280
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4800                            ; 0x12c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4864                            ; 0x1300
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4928                            ; 0x1340
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	4992                            ; 0x1380
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	5056                            ; 0x13c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	5120                            ; 0x1400
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	5184                            ; 0x1440
	dw	1                               ; 0x1
	dw	4089                            ; 0xff9
	dw	246                             ; 0xf6
	dw	5248                            ; 0x1480
	dw	8                               ; 0x8
	dw	4046                            ; 0xfce
	dw	638                             ; 0x27e
	dw	5310                            ; 0x14be
	dw	21                              ; 0x15
	dw	3959                            ; 0xf77
	dw	1052                            ; 0x41c
	dw	5371                            ; 0x14fb
	dw	41                              ; 0x29
	dw	3820                            ; 0xeec
	dw	1479                            ; 0x5c7
	dw	5429                            ; 0x1535
	dw	68                              ; 0x44
	dw	3627                            ; 0xe2b
	dw	1903                            ; 0x76f
	dw	5484                            ; 0x156c
	dw	100                             ; 0x64
	dw	3381                            ; 0xd35
	dw	2312                            ; 0x908
	dw	5535                            ; 0x159f
	dw	140                             ; 0x8c
	dw	3085                            ; 0xc0d
	dw	2694                            ; 0xa86
	dw	5580                            ; 0x15cc
	dw	184                             ; 0xb8
	dw	2747                            ; 0xabb
	dw	3038                            ; 0xbde
	dw	5620                            ; 0x15f4
	dw	234                             ; 0xea
	dw	2375                            ; 0x947
	dw	3337                            ; 0xd09
	dw	5654                            ; 0x1616
	dw	289                             ; 0x121
	dw	1974                            ; 0x7b6
	dw	3589                            ; 0xe05
	dw	5682                            ; 0x1632
	dw	346                             ; 0x15a
	dw	1551                            ; 0x60f
	dw	3791                            ; 0xecf
	dw	5703                            ; 0x1647
	dw	407                             ; 0x197
	dw	1109                            ; 0x455
	dw	3943                            ; 0xf67
	dw	5716                            ; 0x1654
	dw	469                             ; 0x1d5
	dw	652                             ; 0x28c
	dw	4044                            ; 0xfcc
	dw	5723                            ; 0x165b
	dw	533                             ; 0x215
	dw	179                             ; 0xb3
	dw	4092                            ; 0xffc
	dw	5722                            ; 0x165a
	dw	597                             ; 0x255
	dw	65231                           ; 0xfecf
	dw	4085                            ; 0xff5
	dw	5713                            ; 0x1651
	dw	660                             ; 0x294
	dw	64741                           ; 0xfce5
	dw	4018                            ; 0xfb2
	dw	5697                            ; 0x1641
	dw	722                             ; 0x2d2
	dw	64251                           ; 0xfafb
	dw	3889                            ; 0xf31
	dw	5673                            ; 0x1629
	dw	781                             ; 0x30d
	dw	63772                           ; 0xf91c
	dw	3697                            ; 0xe71
	dw	5642                            ; 0x160a
	dw	837                             ; 0x345
	dw	63318                           ; 0xf756
	dw	3444                            ; 0xd74
	dw	5604                            ; 0x15e4
	dw	889                             ; 0x379
	dw	62904                           ; 0xf5b8
	dw	3138                            ; 0xc42
	dw	5560                            ; 0x15b8
	dw	935                             ; 0x3a7
	dw	62541                           ; 0xf44d
	dw	2794                            ; 0xaea
	dw	5511                            ; 0x1587
	dw	976                             ; 0x3d0
	dw	62237                           ; 0xf31d
	dw	2428                            ; 0x97c
	dw	5457                            ; 0x1551
	dw	1011                            ; 0x3f3
	dw	61993                           ; 0xf229
	dw	2056                            ; 0x808
	dw	5401                            ; 0x1519
	dw	1040                            ; 0x410
	dw	61806                           ; 0xf16e
	dw	1692                            ; 0x69c
	dw	5341                            ; 0x14dd
	dw	1064                            ; 0x428
	dw	61668                           ; 0xf0e4
	dw	1347                            ; 0x543
	dw	5280                            ; 0x14a0
	dw	1082                            ; 0x43a
	dw	61570                           ; 0xf082
	dw	1026                            ; 0x402
	dw	5217                            ; 0x1461
	dw	1097                            ; 0x449
	dw	61526                           ; 0xf056
	dw	837                             ; 0x345
	dw	5155                            ; 0x1423
	dw	1108                            ; 0x454
	dw	61496                           ; 0xf038
	dw	676                             ; 0x2a4
	dw	5091                            ; 0x13e3
	dw	1118                            ; 0x45e
	dw	61477                           ; 0xf025
	dw	549                             ; 0x225
	dw	5028                            ; 0x13a4
	dw	1126                            ; 0x466
	dw	61464                           ; 0xf018
	dw	447                             ; 0x1bf
	dw	4964                            ; 0x1364
	dw	1132                            ; 0x46c
	dw	61456                           ; 0xf010
	dw	366                             ; 0x16e
	dw	4900                            ; 0x1324
	dw	1137                            ; 0x471
	dw	61451                           ; 0xf00b
	dw	302                             ; 0x12e
	dw	4836                            ; 0x12e4
	dw	1142                            ; 0x476
	dw	61448                           ; 0xf008
	dw	251                             ; 0xfb
	dw	4773                            ; 0x12a5
	dw	1145                            ; 0x479
	dw	61445                           ; 0xf005
	dw	212                             ; 0xd4
	dw	4709                            ; 0x1265
	dw	1148                            ; 0x47c
	dw	61444                           ; 0xf004
	dw	182                             ; 0xb6
	dw	4645                            ; 0x1225
	dw	1151                            ; 0x47f
	dw	61443                           ; 0xf003
	dw	161                             ; 0xa1
	dw	4581                            ; 0x11e5
	dw	1153                            ; 0x481
	dw	61443                           ; 0xf003
	dw	147                             ; 0x93
	dw	4517                            ; 0x11a5
	dw	1155                            ; 0x483
	dw	61442                           ; 0xf002
	dw	141                             ; 0x8d
	dw	4453                            ; 0x1165
	dw	1158                            ; 0x486
	dw	61442                           ; 0xf002
	dw	141                             ; 0x8d
	dw	4389                            ; 0x1125
	dw	1160                            ; 0x488
	dw	61443                           ; 0xf003
	dw	147                             ; 0x93
	dw	4325                            ; 0x10e5
	dw	1162                            ; 0x48a
	dw	61443                           ; 0xf003
	dw	158                             ; 0x9e
	dw	4261                            ; 0x10a5
	dw	1165                            ; 0x48d
	dw	61444                           ; 0xf004
	dw	176                             ; 0xb0
	dw	4197                            ; 0x1065
	dw	1168                            ; 0x490
	dw	61445                           ; 0xf005
	dw	198                             ; 0xc6
	dw	4133                            ; 0x1025
	dw	1171                            ; 0x493
	dw	61446                           ; 0xf006
	dw	227                             ; 0xe3
	dw	4069                            ; 0xfe5
	dw	1175                            ; 0x497
	dw	61448                           ; 0xf008
	dw	261                             ; 0x105
	dw	4005                            ; 0xfa5
	dw	1179                            ; 0x49b
	dw	61451                           ; 0xf00b
	dw	302                             ; 0x12e
	dw	3942                            ; 0xf66
	dw	1184                            ; 0x4a0
	dw	61455                           ; 0xf00f
	dw	348                             ; 0x15c
	dw	3878                            ; 0xf26
	dw	1190                            ; 0x4a6
	dw	61460                           ; 0xf014
	dw	401                             ; 0x191
	dw	3814                            ; 0xee6
	dw	1197                            ; 0x4ad
	dw	61466                           ; 0xf01a
	dw	461                             ; 0x1cd
	dw	3751                            ; 0xea7
	dw	1205                            ; 0x4b5
	dw	61474                           ; 0xf022
	dw	529                             ; 0x211
	dw	3687                            ; 0xe67
	dw	1214                            ; 0x4be
	dw	61485                           ; 0xf02d
	dw	605                             ; 0x25d
	dw	3624                            ; 0xe28
	dw	1224                            ; 0x4c8
	dw	61498                           ; 0xf03a
	dw	689                             ; 0x2b1
	dw	3561                            ; 0xde9
	dw	1235                            ; 0x4d3
	dw	61516                           ; 0xf04c
	dw	784                             ; 0x310
	dw	3498                            ; 0xdaa
	dw	1248                            ; 0x4e0
	dw	61538                           ; 0xf062
	dw	889                             ; 0x379
	dw	3436                            ; 0xd6c
	dw	1263                            ; 0x4ef
	dw	61565                           ; 0xf07d
	dw	1006                            ; 0x3ee
	dw	3374                            ; 0xd2e
	dw	1280                            ; 0x500
	dw	61601                           ; 0xf0a1
	dw	1136                            ; 0x470
	dw	3313                            ; 0xcf1
	dw	1299                            ; 0x513
	dw	61645                           ; 0xf0cd
	dw	1279                            ; 0x4ff
	dw	3253                            ; 0xcb5
	dw	1320                            ; 0x528
	dw	61700                           ; 0xf104
	dw	1437                            ; 0x59d
	dw	3193                            ; 0xc79
	dw	1343                            ; 0x53f
	dw	61770                           ; 0xf14a
	dw	1611                            ; 0x64b
	dw	3135                            ; 0xc3f
	dw	1370                            ; 0x55a
	dw	61856                           ; 0xf1a0
	dw	1800                            ; 0x708
	dw	3079                            ; 0xc07
	dw	1400                            ; 0x578
	dw	61963                           ; 0xf20b
	dw	2003                            ; 0x7d3
	dw	3024                            ; 0xbd0
	dw	1433                            ; 0x599
	dw	62094                           ; 0xf28e
	dw	2220                            ; 0x8ac
	dw	2971                            ; 0xb9b
	dw	1469                            ; 0x5bd
	dw	62253                           ; 0xf32d
	dw	2449                            ; 0x991
	dw	2921                            ; 0xb69
	dw	1509                            ; 0x5e5
	dw	62440                           ; 0xf3e8
	dw	2681                            ; 0xa79
	dw	2875                            ; 0xb3b
	dw	1553                            ; 0x611
	dw	62657                           ; 0xf4c1
	dw	2914                            ; 0xb62
	dw	2831                            ; 0xb0f
	dw	1600                            ; 0x640
	dw	62903                           ; 0xf5b7
	dw	3138                            ; 0xc42
	dw	2792                            ; 0xae8
	dw	1651                            ; 0x673
	dw	63171                           ; 0xf6c3
	dw	3345                            ; 0xd11
	dw	2758                            ; 0xac6
	dw	1705                            ; 0x6a9
	dw	63455                           ; 0xf7df
	dw	3528                            ; 0xdc8
	dw	2726                            ; 0xaa6
	dw	1760                            ; 0x6e0
	dw	63543                           ; 0xf837
	dw	3578                            ; 0xdfa
	dw	2695                            ; 0xa87
	dw	1817                            ; 0x719
	dw	63652                           ; 0xf8a4
	dw	3637                            ; 0xe35
	dw	2667                            ; 0xa6b
	dw	1874                            ; 0x752
	dw	63738                           ; 0xf8fa
	dw	3680                            ; 0xe60
	dw	2639                            ; 0xa4f
	dw	1931                            ; 0x78b
	dw	63807                           ; 0xf93f
	dw	3713                            ; 0xe81
	dw	2613                            ; 0xa35
	dw	1990                            ; 0x7c6
	dw	63862                           ; 0xf976
	dw	3739                            ; 0xe9b
	dw	2587                            ; 0xa1b
	dw	2048                            ; 0x800
	dw	63908                           ; 0xf9a4
	dw	3759                            ; 0xeaf
	dw	2562                            ; 0xa02
	dw	2107                            ; 0x83b
	dw	63945                           ; 0xf9c9
	dw	3774                            ; 0xebe
	dw	2537                            ; 0x9e9
	dw	2166                            ; 0x876
	dw	63975                           ; 0xf9e7
	dw	3787                            ; 0xecb
	dw	2513                            ; 0x9d1
	dw	2225                            ; 0x8b1
	dw	63999                           ; 0xf9ff
	dw	3797                            ; 0xed5
	dw	2489                            ; 0x9b9
	dw	2285                            ; 0x8ed
	dw	64018                           ; 0xfa12
	dw	3804                            ; 0xedc
	dw	2465                            ; 0x9a1
	dw	2344                            ; 0x928
	dw	64033                           ; 0xfa21
	dw	3810                            ; 0xee2
	dw	2442                            ; 0x98a
	dw	2404                            ; 0x964
	dw	64044                           ; 0xfa2c
	dw	3815                            ; 0xee7
	dw	2419                            ; 0x973
	dw	2464                            ; 0x9a0
	dw	64051                           ; 0xfa33
	dw	3817                            ; 0xee9
	dw	2396                            ; 0x95c
	dw	2523                            ; 0x9db
	dw	64055                           ; 0xfa37
	dw	3819                            ; 0xeeb
	dw	2372                            ; 0x944
	dw	2583                            ; 0xa17
	dw	64056                           ; 0xfa38
	dw	3819                            ; 0xeeb
	dw	2349                            ; 0x92d
	dw	2643                            ; 0xa53
	dw	64054                           ; 0xfa36
	dw	3818                            ; 0xeea
	dw	2326                            ; 0x916
	dw	2702                            ; 0xa8e
	dw	64049                           ; 0xfa31
	dw	3817                            ; 0xee9
	dw	2303                            ; 0x8ff
	dw	2762                            ; 0xaca
	dw	64042                           ; 0xfa2a
	dw	3814                            ; 0xee6
	dw	2279                            ; 0x8e7
	dw	2821                            ; 0xb05
	dw	64032                           ; 0xfa20
	dw	3810                            ; 0xee2
	dw	2256                            ; 0x8d0
	dw	2881                            ; 0xb41
	dw	64019                           ; 0xfa13
	dw	3805                            ; 0xedd
	dw	2232                            ; 0x8b8
	dw	2940                            ; 0xb7c
	dw	64003                           ; 0xfa03
	dw	3798                            ; 0xed6
	dw	2208                            ; 0x8a0
	dw	3000                            ; 0xbb8
	dw	63985                           ; 0xf9f1
	dw	3791                            ; 0xecf
	dw	2183                            ; 0x887
	dw	3059                            ; 0xbf3
	dw	63964                           ; 0xf9dc
	dw	3782                            ; 0xec6
	dw	2159                            ; 0x86f
	dw	3118                            ; 0xc2e
	dw	63940                           ; 0xf9c4
	dw	3772                            ; 0xebc
	dw	2134                            ; 0x856
	dw	3177                            ; 0xc69
	dw	63912                           ; 0xf9a8
	dw	3760                            ; 0xeb0
	dw	2108                            ; 0x83c
	dw	3235                            ; 0xca3
	dw	63882                           ; 0xf98a
	dw	3747                            ; 0xea3
	dw	2082                            ; 0x822
	dw	3294                            ; 0xcde
	dw	63847                           ; 0xf967
	dw	3732                            ; 0xe94
	dw	2055                            ; 0x807
	dw	3352                            ; 0xd18
	dw	63809                           ; 0xf941
	dw	3714                            ; 0xe82
	dw	2028                            ; 0x7ec
	dw	3410                            ; 0xd52
	dw	63766                           ; 0xf916
	dw	3694                            ; 0xe6e
	dw	2000                            ; 0x7d0
	dw	3467                            ; 0xd8b
	dw	63718                           ; 0xf8e6
	dw	3670                            ; 0xe56
	dw	1971                            ; 0x7b3
	dw	3524                            ; 0xdc4
	dw	63665                           ; 0xf8b1
	dw	3644                            ; 0xe3c
	dw	1941                            ; 0x795
	dw	3581                            ; 0xdfd
	dw	63605                           ; 0xf875
	dw	3612                            ; 0xe1c
	dw	1911                            ; 0x777
	dw	3637                            ; 0xe35
	dw	63539                           ; 0xf833
	dw	3576                            ; 0xdf8
	dw	1879                            ; 0x757
	dw	3693                            ; 0xe6d
	dw	63465                           ; 0xf7e9
	dw	3534                            ; 0xdce
	dw	1846                            ; 0x736
	dw	3748                            ; 0xea4
	dw	63382                           ; 0xf796
	dw	3484                            ; 0xd9c
	dw	1811                            ; 0x713
	dw	3802                            ; 0xeda
	dw	63288                           ; 0xf738
	dw	3424                            ; 0xd60
	dw	1776                            ; 0x6f0
	dw	3855                            ; 0xf0f
	dw	63183                           ; 0xf6cf
	dw	3352                            ; 0xd18
	dw	1738                            ; 0x6ca
	dw	3906                            ; 0xf42
	dw	63063                           ; 0xf657
	dw	3265                            ; 0xcc1
	dw	1698                            ; 0x6a2
	dw	3957                            ; 0xf75
	dw	62928                           ; 0xf5d0
	dw	3158                            ; 0xc56
	dw	1656                            ; 0x678
	dw	4005                            ; 0xfa5
	dw	62615                           ; 0xf497
	dw	2872                            ; 0xb38
	dw	1608                            ; 0x648
	dw	4047                            ; 0xfcf
	dw	62311                           ; 0xf367
	dw	2525                            ; 0x9dd
	dw	1555                            ; 0x613
	dw	4083                            ; 0xff3
	dw	62059                           ; 0xf26b
	dw	2165                            ; 0x875
	dw	1499                            ; 0x5db
	dw	4114                            ; 0x1012
	dw	61850                           ; 0xf19a
	dw	1786                            ; 0x6fa
	dw	1440                            ; 0x5a0
	dw	4139                            ; 0x102b
	dw	61685                           ; 0xf0f5
	dw	1395                            ; 0x573
	dw	1379                            ; 0x563
	dw	4158                            ; 0x103e
	dw	61564                           ; 0xf07c
	dw	1000                            ; 0x3e8
	dw	1316                            ; 0x524
	dw	4170                            ; 0x104a
	dw	61485                           ; 0xf02d
	dw	605                             ; 0x25d
	dw	1253                            ; 0x4e5
	dw	4177                            ; 0x1051
	dw	61446                           ; 0xf006
	dw	214                             ; 0xd6
	dw	1189                            ; 0x4a5
	dw	4177                            ; 0x1051
	dw	61444                           ; 0xf004
	dw	65364                           ; 0xff54
	dw	1125                            ; 0x465
	dw	4171                            ; 0x104b
	dw	61478                           ; 0xf026
	dw	64982                           ; 0xfdd6
	dw	1062                            ; 0x426
	dw	4160                            ; 0x1040
	dw	61547                           ; 0xf06b
	dw	64606                           ; 0xfc5e
	dw	1001                            ; 0x3e9
	dw	4142                            ; 0x102e
	dw	61652                           ; 0xf0d4
	dw	64234                           ; 0xfaea
	dw	941                             ; 0x3ad
	dw	4119                            ; 0x1017
	dw	61795                           ; 0xf163
	dw	63869                           ; 0xf97d
	dw	884                             ; 0x374
	dw	4090                            ; 0xffa
	dw	61976                           ; 0xf218
	dw	63511                           ; 0xf817
	dw	830                             ; 0x33e
	dw	4056                            ; 0xfd8
	dw	62197                           ; 0xf2f5
	dw	63163                           ; 0xf6bb
	dw	780                             ; 0x30c
	dw	4016                            ; 0xfb0
	dw	62459                           ; 0xf3fb
	dw	62832                           ; 0xf570
	dw	734                             ; 0x2de
	dw	3972                            ; 0xf84
	dw	62762                           ; 0xf52a
	dw	62523                           ; 0xf43b
	dw	693                             ; 0x2b5
	dw	3922                            ; 0xf52
	dw	63100                           ; 0xf67c
	dw	62243                           ; 0xf323
	dw	658                             ; 0x292
	dw	3869                            ; 0xf1d
	dw	63467                           ; 0xf7eb
	dw	62001                           ; 0xf231
	dw	629                             ; 0x275
	dw	3812                            ; 0xee4
	dw	63853                           ; 0xf96d
	dw	61802                           ; 0xf16a
	dw	606                             ; 0x25e
	dw	3752                            ; 0xea8
	dw	64247                           ; 0xfaf7
	dw	61648                           ; 0xf0d0
	dw	588                             ; 0x24c
	dw	3691                            ; 0xe6b
	dw	64636                           ; 0xfc7c
	dw	61540                           ; 0xf064
	dw	577                             ; 0x241
	dw	3628                            ; 0xe2c
	dw	65012                           ; 0xfdf4
	dw	61474                           ; 0xf022
	dw	572                             ; 0x23c
	dw	3564                            ; 0xdec
	dw	65366                           ; 0xff56
	dw	61444                           ; 0xf004
	dw	569                             ; 0x239
	dw	3500                            ; 0xdac
	dw	65265                           ; 0xfef1
	dw	61449                           ; 0xf009
	dw	566                             ; 0x236
	dw	3436                            ; 0xd6c
	dw	65436                           ; 0xff9c
	dw	61441                           ; 0xf001
	dw	566                             ; 0x236
	dw	3372                            ; 0xd2c
	dw	37                              ; 0x25
	dw	61440                           ; 0xf000
	dw	567                             ; 0x237
	dw	3308                            ; 0xcec
	dw	150                             ; 0x96
	dw	61443                           ; 0xf003
	dw	570                             ; 0x23a
	dw	3244                            ; 0xcac
	dw	244                             ; 0xf4
	dw	61447                           ; 0xf007
	dw	575                             ; 0x23f
	dw	3180                            ; 0xc6c
	dw	323                             ; 0x143
	dw	61453                           ; 0xf00d
	dw	580                             ; 0x244
	dw	3117                            ; 0xc2d
	dw	390                             ; 0x186
	dw	61459                           ; 0xf013
	dw	587                             ; 0x24b
	dw	3053                            ; 0xbed
	dw	448                             ; 0x1c0
	dw	61465                           ; 0xf019
	dw	594                             ; 0x252
	dw	2989                            ; 0xbad
	dw	498                             ; 0x1f2
	dw	61470                           ; 0xf01e
	dw	602                             ; 0x25a
	dw	2926                            ; 0xb6e
	dw	541                             ; 0x21d
	dw	61476                           ; 0xf024
	dw	611                             ; 0x263
	dw	2863                            ; 0xb2f
	dw	579                             ; 0x243
	dw	61481                           ; 0xf029
	dw	620                             ; 0x26c
	dw	2799                            ; 0xaef
	dw	612                             ; 0x264
	dw	61486                           ; 0xf02e
	dw	630                             ; 0x276
	dw	2736                            ; 0xab0
	dw	640                             ; 0x280
	dw	61490                           ; 0xf032
	dw	640                             ; 0x280
	dw	2673                            ; 0xa71
	dw	665                             ; 0x299
	dw	61494                           ; 0xf036
	dw	651                             ; 0x28b
	dw	2610                            ; 0xa32
	dw	686                             ; 0x2ae
	dw	61498                           ; 0xf03a
	dw	662                             ; 0x296
	dw	2547                            ; 0x9f3
	dw	703                             ; 0x2bf
	dw	61501                           ; 0xf03d
	dw	673                             ; 0x2a1
	dw	2484                            ; 0x9b4
	dw	718                             ; 0x2ce
	dw	61503                           ; 0xf03f
	dw	684                             ; 0x2ac
	dw	2421                            ; 0x975
	dw	729                             ; 0x2d9
	dw	61505                           ; 0xf041
	dw	696                             ; 0x2b8
	dw	2358                            ; 0x936
	dw	737                             ; 0x2e1
	dw	61507                           ; 0xf043
	dw	707                             ; 0x2c3
	dw	2295                            ; 0x8f7
	dw	743                             ; 0x2e7
	dw	61508                           ; 0xf044
	dw	719                             ; 0x2cf
	dw	2232                            ; 0x8b8
	dw	745                             ; 0x2e9
	dw	61508                           ; 0xf044
	dw	730                             ; 0x2da
	dw	2169                            ; 0x879
	dw	743                             ; 0x2e7
	dw	61508                           ; 0xf044
	dw	742                             ; 0x2e6
	dw	2106                            ; 0x83a
	dw	738                             ; 0x2e2
	dw	61507                           ; 0xf043
	dw	753                             ; 0x2f1
	dw	2043                            ; 0x7fb
	dw	729                             ; 0x2d9
	dw	61505                           ; 0xf041
	dw	765                             ; 0x2fd
	dw	1980                            ; 0x7bc
	dw	714                             ; 0x2ca
	dw	61503                           ; 0xf03f
	dw	776                             ; 0x308
	dw	1917                            ; 0x77d
	dw	694                             ; 0x2b6
	dw	61499                           ; 0xf03b
	dw	786                             ; 0x312
	dw	1854                            ; 0x73e
	dw	667                             ; 0x29b
	dw	61495                           ; 0xf037
	dw	797                             ; 0x31d
	dw	1791                            ; 0x6ff
	dw	631                             ; 0x277
	dw	61489                           ; 0xf031
	dw	806                             ; 0x326
	dw	1727                            ; 0x6bf
	dw	582                             ; 0x246
	dw	61482                           ; 0xf02a
	dw	815                             ; 0x32f
	dw	1664                            ; 0x680
	dw	516                             ; 0x204
	dw	61473                           ; 0xf021
	dw	822                             ; 0x336
	dw	1600                            ; 0x640
	dw	424                             ; 0x1a8
	dw	61462                           ; 0xf016
	dw	828                             ; 0x33c
	dw	1536                            ; 0x600
	dw	291                             ; 0x123
	dw	61450                           ; 0xf00a
	dw	831                             ; 0x33f
	dw	1473                            ; 0x5c1
	dw	83                              ; 0x53
	dw	61441                           ; 0xf001
	dw	829                             ; 0x33d
	dw	1409                            ; 0x581
	dw	65098                           ; 0xfe4a
	dw	61463                           ; 0xf017
	dw	816                             ; 0x330
	dw	1346                            ; 0x542
	dw	64300                           ; 0xfb2c
	dw	61631                           ; 0xf0bf
	dw	789                             ; 0x315
	dw	1288                            ; 0x508
	dw	63295                           ; 0xf73f
	dw	62107                           ; 0xf29b
	dw	746                             ; 0x2ea
	dw	1241                            ; 0x4d9
	dw	62293                           ; 0xf355
	dw	63035                           ; 0xf63b
	dw	689                             ; 0x2b1
	dw	1212                            ; 0x4bc
	dw	61647                           ; 0xf0cf
	dw	64250                           ; 0xfafa
	dw	627                             ; 0x273
	dw	1201                            ; 0x4b1
	dw	61442                           ; 0xf002
	dw	65394                           ; 0xff72
	dw	563                             ; 0x233
	dw	1206                            ; 0x4b6
	dw	61515                           ; 0xf04b
	dw	780                             ; 0x30c
	dw	502                             ; 0x1f6
	dw	1224                            ; 0x4c8
	dw	61726                           ; 0xf11e
	dw	1505                            ; 0x5e1
	dw	444                             ; 0x1bc
	dw	1252                            ; 0x4e4
	dw	62012                           ; 0xf23c
	dw	2087                            ; 0x827
	dw	392                             ; 0x188
	dw	1289                            ; 0x509
	dw	62346                           ; 0xf38a
	dw	2569                            ; 0xa09
	dw	345                             ; 0x159
	dw	1332                            ; 0x534
	dw	62718                           ; 0xf4fe
	dw	2973                            ; 0xb9d
	dw	304                             ; 0x130
	dw	1381                            ; 0x565
	dw	63124                           ; 0xf694
	dw	3310                            ; 0xcee
	dw	270                             ; 0x10e
	dw	1435                            ; 0x59b
	dw	63556                           ; 0xf844
	dw	3586                            ; 0xe02
	dw	237                             ; 0xed
	dw	1490                            ; 0x5d2
	dw	63382                           ; 0xf796
	dw	3484                            ; 0xd9c
	dw	204                             ; 0xcc
	dw	1545                            ; 0x609
	dw	63434                           ; 0xf7ca
	dw	3516                            ; 0xdbc
	dw	171                             ; 0xab
	dw	1600                            ; 0x640
	dw	63471                           ; 0xf7ef
	dw	3538                            ; 0xdd2
	dw	139                             ; 0x8b
	dw	1656                            ; 0x678
	dw	63499                           ; 0xf80b
	dw	3553                            ; 0xde1
	dw	107                             ; 0x6b
	dw	1711                            ; 0x6af
	dw	63519                           ; 0xf81f
	dw	3565                            ; 0xded
	dw	76                              ; 0x4c
	dw	1767                            ; 0x6e7
	dw	63533                           ; 0xf82d
	dw	3573                            ; 0xdf5
	dw	45                              ; 0x2d
	dw	1823                            ; 0x71f
	dw	63543                           ; 0xf837
	dw	3579                            ; 0xdfb
	dw	14                              ; 0xe
	dw	1879                            ; 0x757
	dw	63549                           ; 0xf83d
	dw	3582                            ; 0xdfe
	dw	65519                           ; 0xffef
	dw	1935                            ; 0x78f
	dw	63553                           ; 0xf841
	dw	3584                            ; 0xe00
	dw	65488                           ; 0xffd0
	dw	1991                            ; 0x7c7
	dw	63553                           ; 0xf841
	dw	3584                            ; 0xe00
	dw	65457                           ; 0xffb1
	dw	2047                            ; 0x7ff
	dw	63551                           ; 0xf83f
	dw	3583                            ; 0xdff
	dw	65426                           ; 0xff92
	dw	2103                            ; 0x837
	dw	63547                           ; 0xf83b
	dw	3581                            ; 0xdfd
	dw	65395                           ; 0xff73
	dw	2159                            ; 0x86f
	dw	63542                           ; 0xf836
	dw	3578                            ; 0xdfa
	dw	65363                           ; 0xff53
	dw	2215                            ; 0x8a7
	dw	63534                           ; 0xf82e
	dw	3574                            ; 0xdf6
	dw	65332                           ; 0xff34
	dw	2270                            ; 0x8de
	dw	63525                           ; 0xf825
	dw	3568                            ; 0xdf0
	dw	65301                           ; 0xff15
	dw	2326                            ; 0x916
	dw	63514                           ; 0xf81a
	dw	3562                            ; 0xdea
	dw	65269                           ; 0xfef5
	dw	2382                            ; 0x94e
	dw	63502                           ; 0xf80e
	dw	3555                            ; 0xde3
	dw	65237                           ; 0xfed5
	dw	2437                            ; 0x985
	dw	63489                           ; 0xf801
	dw	3548                            ; 0xddc
	dw	65205                           ; 0xfeb5
	dw	2492                            ; 0x9bc
	dw	63473                           ; 0xf7f1
	dw	3539                            ; 0xdd3
	dw	65173                           ; 0xfe95
	dw	2548                            ; 0x9f4
	dw	63457                           ; 0xf7e1
	dw	3529                            ; 0xdc9
	dw	65140                           ; 0xfe74
	dw	2603                            ; 0xa2b
	dw	63439                           ; 0xf7cf
	dw	3518                            ; 0xdbe
	dw	65107                           ; 0xfe53
	dw	2658                            ; 0xa62
	dw	63419                           ; 0xf7bb
	dw	3507                            ; 0xdb3
	dw	65074                           ; 0xfe32
	dw	2712                            ; 0xa98
	dw	63398                           ; 0xf7a6
	dw	3494                            ; 0xda6
	dw	65040                           ; 0xfe10
	dw	2767                            ; 0xacf
	dw	63375                           ; 0xf78f
	dw	3480                            ; 0xd98
	dw	65006                           ; 0xfdee
	dw	2821                            ; 0xb05
	dw	63351                           ; 0xf777
	dw	3464                            ; 0xd88
	dw	64972                           ; 0xfdcc
	dw	2875                            ; 0xb3b
	dw	63325                           ; 0xf75d
	dw	3448                            ; 0xd78
	dw	64937                           ; 0xfda9
	dw	2929                            ; 0xb71
	dw	63297                           ; 0xf741
	dw	3430                            ; 0xd66
	dw	64902                           ; 0xfd86
	dw	2982                            ; 0xba6
	dw	63267                           ; 0xf723
	dw	3410                            ; 0xd52
	dw	64866                           ; 0xfd62
	dw	3035                            ; 0xbdb
	dw	63235                           ; 0xf703
	dw	3388                            ; 0xd3c
	dw	64830                           ; 0xfd3e
	dw	3088                            ; 0xc10
	dw	63200                           ; 0xf6e0
	dw	3365                            ; 0xd25
	dw	64793                           ; 0xfd19
	dw	3140                            ; 0xc44
	dw	63164                           ; 0xf6bc
	dw	3339                            ; 0xd0b
	dw	64756                           ; 0xfcf4
	dw	3192                            ; 0xc78
	dw	63124                           ; 0xf694
	dw	3310                            ; 0xcee
	dw	64718                           ; 0xfcce
	dw	3244                            ; 0xcac
	dw	63081                           ; 0xf669
	dw	3279                            ; 0xccf
	dw	64679                           ; 0xfca7
	dw	3295                            ; 0xcdf
	dw	63036                           ; 0xf63c
	dw	3245                            ; 0xcad
	dw	64640                           ; 0xfc80
	dw	3345                            ; 0xd11
	dw	62987                           ; 0xf60b
	dw	3206                            ; 0xc86
	dw	64599                           ; 0xfc57
	dw	3395                            ; 0xd43
	dw	62934                           ; 0xf5d6
	dw	3164                            ; 0xc5c
	dw	64558                           ; 0xfc2e
	dw	3444                            ; 0xd74
	dw	62878                           ; 0xf59e
	dw	3116                            ; 0xc2c
	dw	64516                           ; 0xfc04
	dw	3492                            ; 0xda4
	dw	62816                           ; 0xf560
	dw	3063                            ; 0xbf7
	dw	64473                           ; 0xfbd9
	dw	3540                            ; 0xdd4
	dw	62750                           ; 0xf51e
	dw	3002                            ; 0xbba
	dw	64429                           ; 0xfbad
	dw	3586                            ; 0xe02
	dw	62678                           ; 0xf4d6
	dw	2934                            ; 0xb76
	dw	64384                           ; 0xfb80
	dw	3631                            ; 0xe2f
	dw	62600                           ; 0xf488
	dw	2856                            ; 0xb28
	dw	64337                           ; 0xfb51
	dw	3675                            ; 0xe5b
	dw	62515                           ; 0xf433
	dw	2766                            ; 0xace
	dw	64290                           ; 0xfb22
	dw	3718                            ; 0xe86
	dw	62424                           ; 0xf3d8
	dw	2663                            ; 0xa67
	dw	64240                           ; 0xfaf0
	dw	3759                            ; 0xeaf
	dw	62325                           ; 0xf375
	dw	2543                            ; 0x9ef
	dw	64189                           ; 0xfabd
	dw	3797                            ; 0xed5
	dw	62219                           ; 0xf30b
	dw	2402                            ; 0x962
	dw	64136                           ; 0xfa88
	dw	3833                            ; 0xef9
	dw	62106                           ; 0xf29a
	dw	2238                            ; 0x8be
	dw	64082                           ; 0xfa52
	dw	3867                            ; 0xf1b
	dw	61986                           ; 0xf222
	dw	2043                            ; 0x7fb
	dw	64026                           ; 0xfa1a
	dw	3898                            ; 0xf3a
	dw	61993                           ; 0xf229
	dw	2056                            ; 0x808
	dw	63970                           ; 0xf9e2
	dw	3930                            ; 0xf5a
	dw	61957                           ; 0xf205
	dw	1992                            ; 0x7c8
	dw	63914                           ; 0xf9aa
	dw	3960                            ; 0xf78
	dw	61883                           ; 0xf1bb
	dw	1854                            ; 0x73e
	dw	63856                           ; 0xf970
	dw	3988                            ; 0xf94
	dw	61818                           ; 0xf17a
	dw	1719                            ; 0x6b7
	dw	63798                           ; 0xf936
	dw	4014                            ; 0xfae
	dw	61762                           ; 0xf142
	dw	1592                            ; 0x638
	dw	63738                           ; 0xf8fa
	dw	4037                            ; 0xfc5
	dw	61712                           ; 0xf110
	dw	1468                            ; 0x5bc
	dw	63678                           ; 0xf8be
	dw	4059                            ; 0xfdb
	dw	61669                           ; 0xf0e5
	dw	1350                            ; 0x546
	dw	63618                           ; 0xf882
	dw	4080                            ; 0xff0
	dw	61631                           ; 0xf0bf
	dw	1237                            ; 0x4d5
	dw	63556                           ; 0xf844
	dw	4098                            ; 0x1002
	dw	61599                           ; 0xf09f
	dw	1129                            ; 0x469
	dw	63495                           ; 0xf807
	dw	4115                            ; 0x1013
	dw	61570                           ; 0xf082
	dw	1025                            ; 0x401
	dw	63432                           ; 0xf7c8
	dw	4130                            ; 0x1022
	dw	61546                           ; 0xf06a
	dw	925                             ; 0x39d
	dw	63370                           ; 0xf78a
	dw	4144                            ; 0x1030
	dw	61525                           ; 0xf055
	dw	829                             ; 0x33d
	dw	63307                           ; 0xf74b
	dw	4156                            ; 0x103c
	dw	61507                           ; 0xf043
	dw	737                             ; 0x2e1
	dw	63244                           ; 0xf70c
	dw	4167                            ; 0x1047
	dw	61492                           ; 0xf034
	dw	649                             ; 0x289
	dw	63181                           ; 0xf6cd
	dw	4176                            ; 0x1050
	dw	61479                           ; 0xf027
	dw	563                             ; 0x233
	dw	63117                           ; 0xf68d
	dw	4185                            ; 0x1059
	dw	61468                           ; 0xf01c
	dw	481                             ; 0x1e1
	dw	63054                           ; 0xf64e
	dw	4191                            ; 0x105f
	dw	61460                           ; 0xf014
	dw	401                             ; 0x191
	dw	62990                           ; 0xf60e
	dw	4197                            ; 0x1065
	dw	61453                           ; 0xf00d
	dw	323                             ; 0x143
	dw	62926                           ; 0xf5ce
	dw	4202                            ; 0x106a
	dw	61448                           ; 0xf008
	dw	248                             ; 0xf8
	dw	62862                           ; 0xf58e
	dw	4205                            ; 0x106d
	dw	61444                           ; 0xf004
	dw	174                             ; 0xae
	dw	62798                           ; 0xf54e
	dw	4207                            ; 0x106f
	dw	61441                           ; 0xf001
	dw	102                             ; 0x66
	dw	62734                           ; 0xf50e
	dw	4208                            ; 0x1070
	dw	61440                           ; 0xf000
	dw	31                              ; 0x1f
	dw	62670                           ; 0xf4ce
	dw	4208                            ; 0x1070
	dw	61440                           ; 0xf000
	dw	65498                           ; 0xffda
	dw	62606                           ; 0xf48e
	dw	4207                            ; 0x106f
	dw	61441                           ; 0xf001
	dw	65430                           ; 0xff96
	dw	62542                           ; 0xf44e
	dw	4205                            ; 0x106d
	dw	61444                           ; 0xf004
	dw	65362                           ; 0xff52
	dw	62478                           ; 0xf40e
	dw	4201                            ; 0x1069
	dw	61447                           ; 0xf007
	dw	65294                           ; 0xff0e
	dw	62414                           ; 0xf3ce
	dw	4197                            ; 0x1065
	dw	61452                           ; 0xf00c
	dw	65227                           ; 0xfecb
	dw	62351                           ; 0xf38f
	dw	4192                            ; 0x1060
	dw	61457                           ; 0xf011
	dw	65159                           ; 0xfe87
	dw	62287                           ; 0xf34f
	dw	4185                            ; 0x1059
	dw	61464                           ; 0xf018
	dw	65091                           ; 0xfe43
	dw	62223                           ; 0xf30f
	dw	4178                            ; 0x1052
	dw	61472                           ; 0xf020
	dw	65023                           ; 0xfdff
	dw	62160                           ; 0xf2d0
	dw	4169                            ; 0x1049
	dw	61482                           ; 0xf02a
	dw	64952                           ; 0xfdb8
	dw	62097                           ; 0xf291
	dw	4160                            ; 0x1040
	dw	61493                           ; 0xf035
	dw	64881                           ; 0xfd71
	dw	62034                           ; 0xf252
	dw	4149                            ; 0x1035
	dw	61505                           ; 0xf041
	dw	64808                           ; 0xfd28
	dw	61971                           ; 0xf213
	dw	4137                            ; 0x1029
	dw	61520                           ; 0xf050
	dw	64731                           ; 0xfcdb
	dw	61908                           ; 0xf1d4
	dw	4124                            ; 0x101c
	dw	61537                           ; 0xf061
	dw	64652                           ; 0xfc8c
	dw	61846                           ; 0xf196
	dw	4109                            ; 0x100d
	dw	61556                           ; 0xf074
	dw	64568                           ; 0xfc38
	dw	61784                           ; 0xf158
	dw	4093                            ; 0xffd
	dw	61579                           ; 0xf08b
	dw	64478                           ; 0xfbde
	dw	61722                           ; 0xf11a
	dw	4076                            ; 0xfec
	dw	61606                           ; 0xf0a6
	dw	64382                           ; 0xfb7e
	dw	61661                           ; 0xf0dd
	dw	4057                            ; 0xfd9
	dw	61638                           ; 0xf0c6
	dw	64277                           ; 0xfb15
	dw	61601                           ; 0xf0a1
	dw	4036                            ; 0xfc4
	dw	61676                           ; 0xf0ec
	dw	64165                           ; 0xfaa5
	dw	61540                           ; 0xf064
	dw	4015                            ; 0xfaf
	dw	61681                           ; 0xf0f1
	dw	64152                           ; 0xfa98
	dw	61480                           ; 0xf028
	dw	3993                            ; 0xf99
	dw	61686                           ; 0xf0f6
	dw	64137                           ; 0xfa89
	dw	61420                           ; 0xefec
	dw	3971                            ; 0xf83
	dw	61693                           ; 0xf0fd
	dw	64118                           ; 0xfa76
	dw	61360                           ; 0xefb0
	dw	3949                            ; 0xf6d
	dw	61701                           ; 0xf105
	dw	64096                           ; 0xfa60
	dw	61300                           ; 0xef74
	dw	3926                            ; 0xf56
	dw	61711                           ; 0xf10f
	dw	64072                           ; 0xfa48
	dw	61240                           ; 0xef38
	dw	3903                            ; 0xf3f
	dw	61722                           ; 0xf11a
	dw	64043                           ; 0xfa2b
	dw	61181                           ; 0xeefd
	dw	3879                            ; 0xf27
	dw	61734                           ; 0xf126
	dw	64011                           ; 0xfa0b
	dw	61122                           ; 0xeec2
	dw	3855                            ; 0xf0f
	dw	61749                           ; 0xf135
	dw	63975                           ; 0xf9e7
	dw	61063                           ; 0xee87
	dw	3831                            ; 0xef7
	dw	61766                           ; 0xf146
	dw	63934                           ; 0xf9be
	dw	61004                           ; 0xee4c
	dw	3805                            ; 0xedd
	dw	61786                           ; 0xf15a
	dw	63889                           ; 0xf991
	dw	60945                           ; 0xee11
	dw	3779                            ; 0xec3
	dw	61808                           ; 0xf170
	dw	63838                           ; 0xf95e
	dw	60887                           ; 0xedd7
	dw	3752                            ; 0xea8
	dw	61834                           ; 0xf18a
	dw	63783                           ; 0xf927
	dw	60830                           ; 0xed9e
	dw	3724                            ; 0xe8c
	dw	61864                           ; 0xf1a8
	dw	63721                           ; 0xf8e9
	dw	60773                           ; 0xed65
	dw	3695                            ; 0xe6f
	dw	61898                           ; 0xf1ca
	dw	63654                           ; 0xf8a6
	dw	60716                           ; 0xed2c
	dw	3665                            ; 0xe51
	dw	61936                           ; 0xf1f0
	dw	63582                           ; 0xf85e
	dw	60660                           ; 0xecf4
	dw	3634                            ; 0xe32
	dw	61980                           ; 0xf21c
	dw	63503                           ; 0xf80f
	dw	60605                           ; 0xecbd
	dw	3602                            ; 0xe12
	dw	62030                           ; 0xf24e
	dw	63419                           ; 0xf7bb
	dw	60551                           ; 0xec87
	dw	3568                            ; 0xdf0
	dw	62086                           ; 0xf286
	dw	63329                           ; 0xf761
	dw	60497                           ; 0xec51
	dw	3533                            ; 0xdcd
	dw	62149                           ; 0xf2c5
	dw	63233                           ; 0xf701
	dw	60445                           ; 0xec1d
	dw	3496                            ; 0xda8
	dw	62219                           ; 0xf30b
	dw	63133                           ; 0xf69d
	dw	60394                           ; 0xebea
	dw	3458                            ; 0xd82
	dw	62297                           ; 0xf359
	dw	63029                           ; 0xf635
	dw	60344                           ; 0xebb8
	dw	3418                            ; 0xd5a
	dw	62383                           ; 0xf3af
	dw	62921                           ; 0xf5c9
	dw	60295                           ; 0xeb87
	dw	3376                            ; 0xd30
	dw	62477                           ; 0xf40d
	dw	62812                           ; 0xf55c
	dw	60248                           ; 0xeb58
	dw	3333                            ; 0xd05
	dw	62579                           ; 0xf473
	dw	62702                           ; 0xf4ee
	dw	60203                           ; 0xeb2b
	dw	3288                            ; 0xcd8
	dw	62687                           ; 0xf4df
	dw	62593                           ; 0xf481
	dw	60159                           ; 0xeaff
	dw	3241                            ; 0xca9
	dw	62802                           ; 0xf552
	dw	62486                           ; 0xf416
	dw	60117                           ; 0xead5
	dw	3192                            ; 0xc78
	dw	62922                           ; 0xf5ca
	dw	62382                           ; 0xf3ae
	dw	60077                           ; 0xeaad
	dw	3142                            ; 0xc46
	dw	63047                           ; 0xf647
	dw	62283                           ; 0xf34b
	dw	60040                           ; 0xea88
	dw	3091                            ; 0xc13
	dw	63173                           ; 0xf6c5
	dw	62190                           ; 0xf2ee
	dw	60004                           ; 0xea64
	dw	3038                            ; 0xbde
	dw	63302                           ; 0xf746
	dw	62103                           ; 0xf297
	dw	59970                           ; 0xea42
	dw	2983                            ; 0xba7
	dw	63430                           ; 0xf7c6
	dw	62023                           ; 0xf247
	dw	59938                           ; 0xea22
	dw	2928                            ; 0xb70
	dw	63556                           ; 0xf844
	dw	61950                           ; 0xf1fe
	dw	59908                           ; 0xea04
	dw	2871                            ; 0xb37
	dw	63680                           ; 0xf8c0
	dw	61885                           ; 0xf1bd
	dw	59880                           ; 0xe9e8
	dw	2814                            ; 0xafe
	dw	63800                           ; 0xf938
	dw	61826                           ; 0xf182
	dw	59850                           ; 0xe9ca
	dw	2757                            ; 0xac5
	dw	63651                           ; 0xf8a3
	dw	61900                           ; 0xf1cc
	dw	59821                           ; 0xe9ad
	dw	2700                            ; 0xa8c
	dw	63716                           ; 0xf8e4
	dw	61867                           ; 0xf1ab
	dw	59793                           ; 0xe991
	dw	2642                            ; 0xa52
	dw	63779                           ; 0xf923
	dw	61836                           ; 0xf18c
	dw	59767                           ; 0xe977
	dw	2584                            ; 0xa18
	dw	63841                           ; 0xf961
	dw	61807                           ; 0xf16f
	dw	59741                           ; 0xe95d
	dw	2526                            ; 0x9de
	dw	63901                           ; 0xf99d
	dw	61780                           ; 0xf154
	dw	59715                           ; 0xe943
	dw	2467                            ; 0x9a3
	dw	63960                           ; 0xf9d8
	dw	61755                           ; 0xf13b
	dw	59691                           ; 0xe92b
	dw	2408                            ; 0x968
	dw	64019                           ; 0xfa13
	dw	61731                           ; 0xf123
	dw	59668                           ; 0xe914
	dw	2348                            ; 0x92c
	dw	64077                           ; 0xfa4d
	dw	61709                           ; 0xf10d
	dw	59646                           ; 0xe8fe
	dw	2288                            ; 0x8f0
	dw	64136                           ; 0xfa88
	dw	61687                           ; 0xf0f7
	dw	59624                           ; 0xe8e8
	dw	2228                            ; 0x8b4
	dw	64195                           ; 0xfac3
	dw	61666                           ; 0xf0e2
	dw	59604                           ; 0xe8d4
	dw	2167                            ; 0x877
	dw	64254                           ; 0xfafe
	dw	61646                           ; 0xf0ce
	dw	59584                           ; 0xe8c0
	dw	2106                            ; 0x83a
	dw	64314                           ; 0xfb3a
	dw	61626                           ; 0xf0ba
	dw	59566                           ; 0xe8ae
	dw	2045                            ; 0x7fd
	dw	64375                           ; 0xfb77
	dw	61608                           ; 0xf0a8
	dw	59548                           ; 0xe89c
	dw	1983                            ; 0x7bf
	dw	64438                           ; 0xfbb6
	dw	61590                           ; 0xf096
	dw	59531                           ; 0xe88b
	dw	1922                            ; 0x782
	dw	64502                           ; 0xfbf6
	dw	61573                           ; 0xf085
	dw	59516                           ; 0xe87c
	dw	1860                            ; 0x744
	dw	64569                           ; 0xfc39
	dw	61556                           ; 0xf074
	dw	59501                           ; 0xe86d
	dw	1797                            ; 0x705
	dw	64637                           ; 0xfc7d
	dw	61540                           ; 0xf064
	dw	59488                           ; 0xe860
	dw	1735                            ; 0x6c7
	dw	64708                           ; 0xfcc4
	dw	61525                           ; 0xf055
	dw	59475                           ; 0xe853
	dw	1672                            ; 0x688
	dw	64782                           ; 0xfd0e
	dw	61510                           ; 0xf046
	dw	59464                           ; 0xe848
	dw	1609                            ; 0x649
	dw	64859                           ; 0xfd5b
	dw	61496                           ; 0xf038
	dw	59454                           ; 0xe83e
	dw	1546                            ; 0x60a
	dw	64941                           ; 0xfdad
	dw	61483                           ; 0xf02b
	dw	59445                           ; 0xe835
	dw	1482                            ; 0x5ca
	dw	65027                           ; 0xfe03
	dw	61472                           ; 0xf020
	dw	59438                           ; 0xe82e
	dw	1419                            ; 0x58b
	dw	65117                           ; 0xfe5d
	dw	61461                           ; 0xf015
	dw	59432                           ; 0xe828
	dw	1355                            ; 0x54b
	dw	65214                           ; 0xfebe
	dw	61453                           ; 0xf00d
	dw	59428                           ; 0xe824
	dw	1291                            ; 0x50b
	dw	65316                           ; 0xff24
	dw	61446                           ; 0xf006
	dw	59426                           ; 0xe822
	dw	1227                            ; 0x4cb
	dw	65426                           ; 0xff92
	dw	61441                           ; 0xf001
	dw	59425                           ; 0xe821
	dw	1163                            ; 0x48b
	dw	7                               ; 0x7
	dw	61440                           ; 0xf000
	dw	59426                           ; 0xe822
	dw	1099                            ; 0x44b
	dw	134                             ; 0x86
	dw	61442                           ; 0xf002
	dw	59429                           ; 0xe825
	dw	1035                            ; 0x40b
	dw	271                             ; 0x10f
	dw	61449                           ; 0xf009
	dw	59434                           ; 0xe82a
	dw	971                             ; 0x3cb
	dw	418                             ; 0x1a2
	dw	61461                           ; 0xf015
	dw	59442                           ; 0xe832
	dw	908                             ; 0x38c
	dw	579                             ; 0x243
	dw	61481                           ; 0xf029
	dw	59453                           ; 0xe83d
	dw	845                             ; 0x34d
	dw	753                             ; 0x2f1
	dw	61510                           ; 0xf046
	dw	59466                           ; 0xe84a
	dw	782                             ; 0x30e
	dw	942                             ; 0x3ae
	dw	61550                           ; 0xf06e
	dw	59482                           ; 0xe85a
	dw	720                             ; 0x2d0
	dw	1147                            ; 0x47b
	dw	61604                           ; 0xf0a4
	dw	59502                           ; 0xe86e
	dw	659                             ; 0x293
	dw	1369                            ; 0x559
	dw	61675                           ; 0xf0eb
	dw	59525                           ; 0xe885
	dw	600                             ; 0x258
	dw	1606                            ; 0x646
	dw	61768                           ; 0xf148
	dw	59552                           ; 0xe8a0
	dw	542                             ; 0x21e
	dw	1858                            ; 0x742
	dw	61885                           ; 0xf1bd
	dw	59580                           ; 0xe8bc
	dw	484                             ; 0x1e4
	dw	1756                            ; 0x6dc
	dw	61835                           ; 0xf18b
	dw	59609                           ; 0xe8d9
	dw	427                             ; 0x1ab
	dw	2001                            ; 0x7d1
	dw	61962                           ; 0xf20a
	dw	59642                           ; 0xe8fa
	dw	373                             ; 0x175
	dw	2256                            ; 0x8d0
	dw	62117                           ; 0xf2a5
	dw	59680                           ; 0xe920
	dw	321                             ; 0x141
	dw	2514                            ; 0x9d2
	dw	62303                           ; 0xf35f
	dw	59721                           ; 0xe949
	dw	272                             ; 0x110
	dw	2769                            ; 0xad1
	dw	62518                           ; 0xf436
	dw	59766                           ; 0xe976
	dw	226                             ; 0xe2
	dw	3013                            ; 0xbc5
	dw	62761                           ; 0xf529
	dw	59815                           ; 0xe9a7
	dw	185                             ; 0xb9
	dw	3237                            ; 0xca5
	dw	63027                           ; 0xf633
	dw	59867                           ; 0xe9db
	dw	148                             ; 0x94
	dw	3436                            ; 0xd6c
	dw	63307                           ; 0xf74b
	dw	59922                           ; 0xea12
	dw	115                             ; 0x73
	dw	3606                            ; 0xe16
	dw	63593                           ; 0xf869
	dw	59980                           ; 0xea4c
	dw	87                              ; 0x57
	dw	3746                            ; 0xea2
	dw	63878                           ; 0xf986
	dw	60039                           ; 0xea87
	dw	64                              ; 0x40
	dw	3856                            ; 0xf10
	dw	64154                           ; 0xfa9a
	dw	60100                           ; 0xeac4
	dw	44                              ; 0x2c
	dw	3940                            ; 0xf64
	dw	64416                           ; 0xfba0
	dw	60162                           ; 0xeb02
	dw	29                              ; 0x1d
	dw	4001                            ; 0xfa1
	dw	64661                           ; 0xfc95
	dw	60225                           ; 0xeb41
	dw	17                              ; 0x11
	dw	4044                            ; 0xfcc
	dw	64888                           ; 0xfd78
	dw	60288                           ; 0xeb80
	dw	8                               ; 0x8
	dw	4072                            ; 0xfe8
	dw	65096                           ; 0xfe48
	dw	60352                           ; 0xebc0
	dw	3                               ; 0x3
	dw	4088                            ; 0xff8
	dw	65286                           ; 0xff06
	dw	60416                           ; 0xec00
	dw	0                               ; 0x0
	dw	4095                            ; 0xfff
	dw	65459                           ; 0xffb3
	dw	60480                           ; 0xec40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	60544                           ; 0xec80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	60608                           ; 0xecc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	60672                           ; 0xed00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	60736                           ; 0xed40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	60800                           ; 0xed80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	60864                           ; 0xedc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	60928                           ; 0xee00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	60992                           ; 0xee40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61056                           ; 0xee80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61120                           ; 0xeec0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61184                           ; 0xef00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61248                           ; 0xef40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61312                           ; 0xef80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61376                           ; 0xefc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61504                           ; 0xf040
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61568                           ; 0xf080
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61632                           ; 0xf0c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61696                           ; 0xf100
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61760                           ; 0xf140
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61824                           ; 0xf180
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61888                           ; 0xf1c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	61952                           ; 0xf200
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62016                           ; 0xf240
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62080                           ; 0xf280
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62144                           ; 0xf2c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62208                           ; 0xf300
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62272                           ; 0xf340
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62336                           ; 0xf380
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62400                           ; 0xf3c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62464                           ; 0xf400
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62528                           ; 0xf440
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62592                           ; 0xf480
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62656                           ; 0xf4c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62720                           ; 0xf500
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62784                           ; 0xf540
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62848                           ; 0xf580
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62912                           ; 0xf5c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	62976                           ; 0xf600
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63040                           ; 0xf640
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63104                           ; 0xf680
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63168                           ; 0xf6c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63232                           ; 0xf700
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63296                           ; 0xf740
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63360                           ; 0xf780
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63424                           ; 0xf7c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63488                           ; 0xf800
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63552                           ; 0xf840
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63616                           ; 0xf880
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63680                           ; 0xf8c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63744                           ; 0xf900
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63808                           ; 0xf940
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63872                           ; 0xf980
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	63936                           ; 0xf9c0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64000                           ; 0xfa00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64064                           ; 0xfa40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64128                           ; 0xfa80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64192                           ; 0xfac0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64256                           ; 0xfb00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64320                           ; 0xfb40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64384                           ; 0xfb80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64448                           ; 0xfbc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64512                           ; 0xfc00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64576                           ; 0xfc40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64640                           ; 0xfc80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64704                           ; 0xfcc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64768                           ; 0xfd00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64832                           ; 0xfd40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64896                           ; 0xfd80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64960                           ; 0xfdc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	65024                           ; 0xfe00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	65088                           ; 0xfe40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	65152                           ; 0xfe80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	65216                           ; 0xfec0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	65280                           ; 0xff00
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	65344                           ; 0xff40
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	65408                           ; 0xff80
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	65472                           ; 0xffc0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0

	.local	_.str.53
_.str.53:
	db	"Fuji reference", 0

	.local	_.str.54
_.str.54:
	db	"%01lu'%02lu", 34, "%02lu", 0

	.local	_.str.55
_.str.55:
	db	"ARROWS DRIVE   -= GRIP   M MUTE", 0

	.local	_.str.56
_.str.56:
	db	"QUALIFYING LAP", 0

	.local	_.str.57
_.str.57:
	db	"%s  LAP %u/%u", 0

	.local	_.str.58
_.str.58:
	db	"RACE", 0

	.local	_.str.59
_.str.59:
	db	"ARCADE", 0

	.local	_.str.60
_.str.60:
	db	"TIME EXTENDED!", 0

	.local	__ZN5rally4gameL5RouteE
__ZN5rally4gameL5RouteE:
	dw	60                              ; 0x3c
	dw	180                             ; 0xb4
	dw	0                               ; 0x0
	dw	32                              ; 0x20
	dw	60                              ; 0x3c
	dw	180                             ; 0xb4
	dw	1920                            ; 0x780
	dw	65504                           ; 0xffe0
	dw	180                             ; 0xb4
	dw	170                             ; 0xaa
	dw	0                               ; 0x0
	dw	0                               ; 0x0
	dw	60                              ; 0x3c
	dw	180                             ; 0xb4
	dw	0                               ; 0x0
	dw	65504                           ; 0xffe0
	dw	60                              ; 0x3c
	dw	180                             ; 0xb4
	dw	63616                           ; 0xf880
	dw	32                              ; 0x20
	dw	180                             ; 0xb4
	dw	150                             ; 0x96
	dw	0                               ; 0x0
	dw	0                               ; 0x0

	.local	__ZN5rally4gameL9RouteSineE
__ZN5rally4gameL9RouteSineE:
	dw	0                               ; 0x0
	dw	201                             ; 0xc9
	dw	402                             ; 0x192
	dw	603                             ; 0x25b
	dw	804                             ; 0x324
	dw	1005                            ; 0x3ed
	dw	1206                            ; 0x4b6
	dw	1407                            ; 0x57f
	dw	1608                            ; 0x648
	dw	1809                            ; 0x711
	dw	2009                            ; 0x7d9
	dw	2210                            ; 0x8a2
	dw	2410                            ; 0x96a
	dw	2611                            ; 0xa33
	dw	2811                            ; 0xafb
	dw	3012                            ; 0xbc4
	dw	3212                            ; 0xc8c
	dw	3412                            ; 0xd54
	dw	3612                            ; 0xe1c
	dw	3811                            ; 0xee3
	dw	4011                            ; 0xfab
	dw	4210                            ; 0x1072
	dw	4410                            ; 0x113a
	dw	4609                            ; 0x1201
	dw	4808                            ; 0x12c8
	dw	5007                            ; 0x138f
	dw	5205                            ; 0x1455
	dw	5404                            ; 0x151c
	dw	5602                            ; 0x15e2
	dw	5800                            ; 0x16a8
	dw	5998                            ; 0x176e
	dw	6195                            ; 0x1833
	dw	6393                            ; 0x18f9
	dw	6590                            ; 0x19be
	dw	6786                            ; 0x1a82
	dw	6983                            ; 0x1b47
	dw	7179                            ; 0x1c0b
	dw	7375                            ; 0x1ccf
	dw	7571                            ; 0x1d93
	dw	7767                            ; 0x1e57
	dw	7962                            ; 0x1f1a
	dw	8157                            ; 0x1fdd
	dw	8351                            ; 0x209f
	dw	8545                            ; 0x2161
	dw	8739                            ; 0x2223
	dw	8933                            ; 0x22e5
	dw	9126                            ; 0x23a6
	dw	9319                            ; 0x2467
	dw	9512                            ; 0x2528
	dw	9704                            ; 0x25e8
	dw	9896                            ; 0x26a8
	dw	10087                           ; 0x2767
	dw	10278                           ; 0x2826
	dw	10469                           ; 0x28e5
	dw	10659                           ; 0x29a3
	dw	10849                           ; 0x2a61
	dw	11039                           ; 0x2b1f
	dw	11228                           ; 0x2bdc
	dw	11417                           ; 0x2c99
	dw	11605                           ; 0x2d55
	dw	11793                           ; 0x2e11
	dw	11980                           ; 0x2ecc
	dw	12167                           ; 0x2f87
	dw	12353                           ; 0x3041
	dw	12539                           ; 0x30fb
	dw	12725                           ; 0x31b5
	dw	12910                           ; 0x326e
	dw	13094                           ; 0x3326
	dw	13279                           ; 0x33df
	dw	13462                           ; 0x3496
	dw	13645                           ; 0x354d
	dw	13828                           ; 0x3604
	dw	14010                           ; 0x36ba
	dw	14191                           ; 0x376f
	dw	14372                           ; 0x3824
	dw	14553                           ; 0x38d9
	dw	14732                           ; 0x398c
	dw	14912                           ; 0x3a40
	dw	15090                           ; 0x3af2
	dw	15269                           ; 0x3ba5
	dw	15446                           ; 0x3c56
	dw	15623                           ; 0x3d07
	dw	15800                           ; 0x3db8
	dw	15976                           ; 0x3e68
	dw	16151                           ; 0x3f17
	dw	16325                           ; 0x3fc5
	dw	16499                           ; 0x4073
	dw	16673                           ; 0x4121
	dw	16846                           ; 0x41ce
	dw	17018                           ; 0x427a
	dw	17189                           ; 0x4325
	dw	17360                           ; 0x43d0
	dw	17530                           ; 0x447a
	dw	17700                           ; 0x4524
	dw	17869                           ; 0x45cd
	dw	18037                           ; 0x4675
	dw	18204                           ; 0x471c
	dw	18371                           ; 0x47c3
	dw	18537                           ; 0x4869
	dw	18703                           ; 0x490f
	dw	18868                           ; 0x49b4
	dw	19032                           ; 0x4a58
	dw	19195                           ; 0x4afb
	dw	19357                           ; 0x4b9d
	dw	19519                           ; 0x4c3f
	dw	19680                           ; 0x4ce0
	dw	19841                           ; 0x4d81
	dw	20000                           ; 0x4e20
	dw	20159                           ; 0x4ebf
	dw	20317                           ; 0x4f5d
	dw	20475                           ; 0x4ffb
	dw	20631                           ; 0x5097
	dw	20787                           ; 0x5133
	dw	20942                           ; 0x51ce
	dw	21096                           ; 0x5268
	dw	21250                           ; 0x5302
	dw	21403                           ; 0x539b
	dw	21554                           ; 0x5432
	dw	21705                           ; 0x54c9
	dw	21856                           ; 0x5560
	dw	22005                           ; 0x55f5
	dw	22154                           ; 0x568a
	dw	22301                           ; 0x571d
	dw	22448                           ; 0x57b0
	dw	22594                           ; 0x5842
	dw	22739                           ; 0x58d3
	dw	22884                           ; 0x5964
	dw	23027                           ; 0x59f3
	dw	23170                           ; 0x5a82
	dw	23311                           ; 0x5b0f
	dw	23452                           ; 0x5b9c
	dw	23592                           ; 0x5c28
	dw	23731                           ; 0x5cb3
	dw	23870                           ; 0x5d3e
	dw	24007                           ; 0x5dc7
	dw	24143                           ; 0x5e4f
	dw	24279                           ; 0x5ed7
	dw	24413                           ; 0x5f5d
	dw	24547                           ; 0x5fe3
	dw	24680                           ; 0x6068
	dw	24811                           ; 0x60eb
	dw	24942                           ; 0x616e
	dw	25072                           ; 0x61f0
	dw	25201                           ; 0x6271
	dw	25329                           ; 0x62f1
	dw	25456                           ; 0x6370
	dw	25582                           ; 0x63ee
	dw	25708                           ; 0x646c
	dw	25832                           ; 0x64e8
	dw	25955                           ; 0x6563
	dw	26077                           ; 0x65dd
	dw	26198                           ; 0x6656
	dw	26319                           ; 0x66cf
	dw	26438                           ; 0x6746
	dw	26556                           ; 0x67bc
	dw	26674                           ; 0x6832
	dw	26790                           ; 0x68a6
	dw	26905                           ; 0x6919
	dw	27019                           ; 0x698b
	dw	27133                           ; 0x69fd
	dw	27245                           ; 0x6a6d
	dw	27356                           ; 0x6adc
	dw	27466                           ; 0x6b4a
	dw	27575                           ; 0x6bb7
	dw	27683                           ; 0x6c23
	dw	27790                           ; 0x6c8e
	dw	27896                           ; 0x6cf8
	dw	28001                           ; 0x6d61
	dw	28105                           ; 0x6dc9
	dw	28208                           ; 0x6e30
	dw	28310                           ; 0x6e96
	dw	28411                           ; 0x6efb
	dw	28510                           ; 0x6f5e
	dw	28609                           ; 0x6fc1
	dw	28706                           ; 0x7022
	dw	28803                           ; 0x7083
	dw	28898                           ; 0x70e2
	dw	28992                           ; 0x7140
	dw	29085                           ; 0x719d
	dw	29177                           ; 0x71f9
	dw	29268                           ; 0x7254
	dw	29358                           ; 0x72ae
	dw	29447                           ; 0x7307
	dw	29534                           ; 0x735e
	dw	29621                           ; 0x73b5
	dw	29706                           ; 0x740a
	dw	29791                           ; 0x745f
	dw	29874                           ; 0x74b2
	dw	29956                           ; 0x7504
	dw	30037                           ; 0x7555
	dw	30117                           ; 0x75a5
	dw	30195                           ; 0x75f3
	dw	30273                           ; 0x7641
	dw	30349                           ; 0x768d
	dw	30424                           ; 0x76d8
	dw	30498                           ; 0x7722
	dw	30571                           ; 0x776b
	dw	30643                           ; 0x77b3
	dw	30714                           ; 0x77fa
	dw	30783                           ; 0x783f
	dw	30852                           ; 0x7884
	dw	30919                           ; 0x78c7
	dw	30985                           ; 0x7909
	dw	31050                           ; 0x794a
	dw	31113                           ; 0x7989
	dw	31176                           ; 0x79c8
	dw	31237                           ; 0x7a05
	dw	31297                           ; 0x7a41
	dw	31356                           ; 0x7a7c
	dw	31414                           ; 0x7ab6
	dw	31470                           ; 0x7aee
	dw	31526                           ; 0x7b26
	dw	31580                           ; 0x7b5c
	dw	31633                           ; 0x7b91
	dw	31685                           ; 0x7bc5
	dw	31736                           ; 0x7bf8
	dw	31785                           ; 0x7c29
	dw	31833                           ; 0x7c59
	dw	31880                           ; 0x7c88
	dw	31926                           ; 0x7cb6
	dw	31971                           ; 0x7ce3
	dw	32014                           ; 0x7d0e
	dw	32057                           ; 0x7d39
	dw	32098                           ; 0x7d62
	dw	32137                           ; 0x7d89
	dw	32176                           ; 0x7db0
	dw	32213                           ; 0x7dd5
	dw	32250                           ; 0x7dfa
	dw	32285                           ; 0x7e1d
	dw	32318                           ; 0x7e3e
	dw	32351                           ; 0x7e5f
	dw	32382                           ; 0x7e7e
	dw	32412                           ; 0x7e9c
	dw	32441                           ; 0x7eb9
	dw	32469                           ; 0x7ed5
	dw	32495                           ; 0x7eef
	dw	32521                           ; 0x7f09
	dw	32545                           ; 0x7f21
	dw	32567                           ; 0x7f37
	dw	32589                           ; 0x7f4d
	dw	32609                           ; 0x7f61
	dw	32628                           ; 0x7f74
	dw	32646                           ; 0x7f86
	dw	32663                           ; 0x7f97
	dw	32678                           ; 0x7fa6
	dw	32692                           ; 0x7fb4
	dw	32705                           ; 0x7fc1
	dw	32717                           ; 0x7fcd
	dw	32728                           ; 0x7fd8
	dw	32737                           ; 0x7fe1
	dw	32745                           ; 0x7fe9
	dw	32752                           ; 0x7ff0
	dw	32757                           ; 0x7ff5
	dw	32761                           ; 0x7ff9
	dw	32765                           ; 0x7ffd
	dw	32766                           ; 0x7ffe
	dw	32767                           ; 0x7fff

	.local	___const._ZN12_GLOBAL__N_115scriptedTrafficEj.lanes
___const._ZN12_GLOBAL__N_115scriptedTrafficEj.lanes:
	d32	4294958080                      ; 0xffffdc00
	d32	0                               ; 0x0
	d32	9216                            ; 0x2400
	d32	4294958080                      ; 0xffffdc00
	d32	0                               ; 0x0
	d32	9216                            ; 0x2400

	.local	_.str.61
_.str.61:
	db	"Capture ready open", 0

	.local	_.str.62
_.str.62:
	db	"{", 34, "schema", 34, ":1,", 34, "timing_excluded", 34, ":true,", 34, "stage", 34, ":%u,", 34, "frame", 34, ":%u,", 34, "generation", 34, ":%lu,", 34, "request", 34, ":%lu,", 34, "physics_ticks", 34, ":%lu,", 34, "post_swap_fenced", 34, ":true}", 10, 0

	.local	_.str.63
_.str.63:
	db	"Capture ready write", 0

	.local	_.str.64
_.str.64:
	db	"coverage.req", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_15crashE
__ZN12_GLOBAL__N_15crashE:
	.skip	4

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_115coverageTrafficE
__ZN12_GLOBAL__N_115coverageTrafficE:
	db	0                               ; 0x0
	dw	0                               ; 0x0
	db	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	60                              ; 0x3c
	dw	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	0                               ; 0x0
	db	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	60                              ; 0x3c
	dw	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	0                               ; 0x0
	db	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	60                              ; 0x3c
	dw	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	0                               ; 0x0
	db	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	60                              ; 0x3c
	dw	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	0                               ; 0x0
	db	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	60                              ; 0x3c
	dw	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	0                               ; 0x0
	db	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	60                              ; 0x3c
	dw	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	dw	60                              ; 0x3c
	dw	0                               ; 0x0
	d32	0                               ; 0x0
	db	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	db	1                               ; 0x1

	.section	.rodata,"a",@progbits
	.local	_.str.65
_.str.65:
	db	"{", 34, "schema", 34, ":1,", 34, "separate_from_throughput", 34, ":true,", 34, "frames", 34, ":272,", 34, "explosion_frames", 34, ":%u,", 34, "blink_hidden_frames", 34, ":%u,", 34, "recovery_transitions", 34, ":%u,", 34, "camera_frozen", 34, ":true,", 34, "native_physics_ticks", 34, ":0,", 34, "healthy", 34, ":%s}", 10, 0

	.local	_.str.66
_.str.66:
	db	"true", 0

	.local	_.str.67
_.str.67:
	db	"false", 0

	.local	___const._ZN12_GLOBAL__N_110drawPlayerEv.dx
___const._ZN12_GLOBAL__N_110drawPlayerEv.dx:
	d24	0                               ; 0x0
	d24	7                               ; 0x7
	d24	10                              ; 0xa
	d24	7                               ; 0x7
	d24	0                               ; 0x0
	d24	16777209                        ; 0xfffff9
	d24	16777206                        ; 0xfffff6
	d24	16777209                        ; 0xfffff9

	.local	___const._ZN12_GLOBAL__N_110drawPlayerEv.dy
___const._ZN12_GLOBAL__N_110drawPlayerEv.dy:
	d24	16777206                        ; 0xfffff6
	d24	16777209                        ; 0xfffff9
	d24	0                               ; 0x0
	d24	7                               ; 0x7
	d24	10                              ; 0xa
	d24	7                               ; 0x7
	d24	0                               ; 0x0
	d24	16777209                        ; 0xfffff9

	.local	___const._ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm.lanes
___const._ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm.lanes:
	d24	0                               ; 0x0
	d24	16777180                        ; 0xffffdc
	d24	36                              ; 0x24
	d24	16777151                        ; 0xffffbf
	d24	65                              ; 0x41

	.local	___const._ZN12_GLOBAL__N_115releaseGraphicsEv.ids
___const._ZN12_GLOBAL__N_115releaseGraphicsEv.ids:
	dw	64100                           ; 0xfa64
	dw	63940                           ; 0xf9c4
	dw	63941                           ; 0xf9c5
	dw	63984                           ; 0xf9f0
	dw	63960                           ; 0xf9d8
	dw	63800                           ; 0xf938
	dw	50300                           ; 0xc47c
	dw	50301                           ; 0xc47d
	dw	50302                           ; 0xc47e
	dw	50303                           ; 0xc47f
	dw	50304                           ; 0xc480
	dw	50305                           ; 0xc481
	dw	50700                           ; 0xc60c

	.local	___const._ZN12_GLOBAL__N_111restoreTextEv.p
___const._ZN12_GLOBAL__N_111restoreTextEv.p:
	db	22, 8, 23, 0, 192, 0, 23, 1, 1, 26, 12

	.local	_.str.68
_.str.68:
	db	"player_rules_and_tick_submission_prt_ms,presentation_cpu_estimate_prt_ms,submission_prt_ms,reply_wait_prt_ms,loop_prt_ms,wire_bytes", 13, 10, "%lu,%lu,%lu,%lu,%lu,%lu", 13, 10, 0

	.local	_.str.69
_.str.69:
	db	"station,phase,speed,lateral,steering,rules_ticks,score,remaining,rank,laps", 13, 10, "%ld,%ld,%ld,%ld,%d,%lu,%lu,%lu,%u,%u", 13, 10, 0

	.local	_.str.70
_.str.70:
	db	"{", 34, "schema", 34, ":1,", 34, "valid", 34, ":true,", 34, "frames", 34, ":%u,", 34, "warm_frames", 34, ":2,", 34, "physics_ticks", 34, ":%u,", 34, "mos_tick_hz", 34, ":120,", 34, "elapsed_mos_ticks", 34, ":%lu,", 34, "prt_ticks", 34, ":%lu,", 34, "stack_before", 34, ":%u,", 34, "stack_after", 34, ":%u,", 34, "scroll_calls", 34, ":%lu,", 34, "repaint_calls", 34, ":%lu,", 34, "sky_repair_calls", 34, ":%lu,", 34, "hud_bytes", 34, ":%lu,", 34, "footer_calls", 34, ":%lu,", 34, "audio_changes", 34, ":%lu,", 34, "finish_frames", 34, ":%lu,", 34, "input_polls", 34, ":%lu,", 34, "request", 34, ":%lu,", 34, "generation", 34, ":%lu,", 34, "timed_wire_bytes", 34, ":%lu,", 34, "retained_replies", 34, ":%u,", 34, "transcript_bytes", 34, ":%u,", 34, "timer_restored", 34, ":%s,", 34, "unloaded", 34, ":%s,", 34, "race_view", 34, ":true,", 34, "damage_enabled", 34, ":false,", 34, "post_swap_fenced", 34, ":true,", 34, "clean_text_exit", 34, ":true}", 10, 0

	.local	___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.setup
___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.setup:
	db	23, 0, 133, 0, 8, 23, 0, 133, 0, 10, 23, 0, 133, 0, 4, 3

	.local	___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.volume
___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.volume:
	db	23, 0, 133, 0, 2, "("

	.local	___const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute
___const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute:
	db	23, 0, 133, 0, 2, 0

	.local	_str
_str:
	db	"RALLY-28 FULL RACE DONE: logs saved.", 0

	.ident	"clang version 15.0.7 (https://github.com/AgonPlatform/agon-llvm-project.git c76386c0083e6a6236ff774275227e2389f85538)"
	.extern	__Unwind_SjLj_Register
	.extern	_timing_stop
	.extern	__lcmpzero
	.extern	_mos_del
	.extern	_memcpy
	.extern	__sxor
	.extern	__idivs
	.extern	__idivu
	.extern	_timing_release
	.extern	__sneg
	.extern	_mos_setintvector
	.extern	__ixor
	.extern	__sremu
	.extern	__ineg
	.extern	_fread
	.extern	_fwrite
	.extern	__lrems
	.extern	__lremu
	.extern	_mos_sysvars
	.extern	__lsub
	.extern	__indcallhl
	.extern	_timing_irq
	.extern	__ishru
	.extern	_vdp_set_pixel_coordinates
	.extern	_fs_callback
	.extern	_ferror
	.extern	__sdivu
	.extern	__imulu
	.extern	__lxor
	.extern	_vdp_getKeyMap
	.extern	__lcmps
	.extern	__lcmpu
	.extern	__frameset0
	.extern	_fclose
	.extern	__ldivs
	.extern	__ldivu
	.extern	__lor
	.extern	__inot
	.extern	__lneg
	.extern	__sshl
	.extern	_snprintf
	.extern	__sand
	.extern	_timing_claim
	.extern	__ishl
	.extern	__ladd
	.extern	__sshru
	.extern	__setflag
	.extern	_printf
	.extern	_mos_puts
	.extern	__iand
	.extern	_timing_ticks
	.extern	_timing_start
	.extern	_strlen
	.extern	__lshrs
	.extern	__lshru
	.extern	_vdp_cursor_enable
	.extern	__frameset
	.extern	_fopen
	.extern	_fgetc
	.extern	__lmulu
	.extern	_fprintf
	.extern	_puts
	.extern	_vdp_mode
	.extern	__Unwind_SjLj_Unregister
	.extern	__lshl
	.extern	__irems
	.extern	__iremu
	.extern	__land
	.extern	_mos_setkbvector
	.extern	_vdp_reset_sprites
	.extern	_memcmp
