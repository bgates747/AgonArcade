# Compiler assembly excerpts

Exact excerpts from ordinary same-flags `-S -fverbose-asm` output. No debug flag, no hand-written replacement.

## sample-before — (anonymous namespace)::draw(int, unsigned int)

Compiler emitted; static instructions 99.

```asm
	.type	__ZN12_GLOBAL__N_14drawEij,@function ; -- Begin function _ZN12_GLOBAL__N_14drawEij
__ZN12_GLOBAL__N_14drawEij:             ; @_ZN12_GLOBAL__N_14drawEij
; %bb.0:
	ld	hl, -49
	call	__frameset
	ld	hl, ___const._ZN12_GLOBAL__N_14drawEij.clear
	ld	de, __ZN12_GLOBAL__N_16paramsE+2
	ld	(ix - 44), de
	ld	de, 0
	ld	(ix - 35), de
	lea	iy, ix - 15
	lea	de, ix - 26
	ld	(ix - 41), de
	lea	de, ix - 32
	ld	(ix - 38), de
	lea	de, iy + 0
	ld	bc, 15
	ldir
	ld	hl, 15
	push	hl
	push	iy
	call	__ZN12_GLOBAL__N_14sendEPKhj
	ld	de, 55200
	pop	hl
	pop	hl
	ld	hl, (ix + 6)
	ld	(ix - 48), l                    ; 1-byte Folded Spill
	ld	a, h
	ld	(ix - 49), a
	.local	.LBB4_1
.LBB4_1:                                ; =>This Inner Loop Header: Depth=1
	ld	bc, 55320
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	z, .LBB4_5
; %bb.2:                                ;   in Loop: Header=BB4_1 Depth=1
	ld	(ix - 47), de
	ld	hl, (ix - 35)
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
	ld	iy, (ix - 44)
	ld	(iy - 2), a
	ld	(iy - 1), -41
	ld	a, (ix - 48)
	ld	(iy), a
	ld	a, (ix - 49)
	ld	(iy + 1), a
	ld	hl, (ix - 35)
	ld	a, l
	add	a, -96
	ld	(iy + 2), a
	ld	de, (ix - 47)
	ld	a, d
	ld	(iy + 3), a
	inc	hl
	ld	(ix - 35), hl
	inc	de
	lea	iy, iy + 6
	ld	(ix - 44), iy
	jr	.LBB4_1
	.local	.LBB4_5
.LBB4_5:
	ld	de, (ix - 41)
	ld	hl, ___const._ZN12_GLOBAL__N_14drawEij.patch
	ld	iy, 11
	lea	bc, iy + 0
	ldir
	push	iy
	ld	hl, (ix - 41)
	push	hl
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	ld	hl, 720
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16paramsE
	push	hl
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	ld	de, (ix - 38)
	ld	hl, ___const._ZN12_GLOBAL__N_14drawEij.call
	ld	iy, 6
	lea	bc, iy + 0
	ldir
	push	iy
	ld	hl, (ix - 38)
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
```

## sample-before — (anonymous namespace)::painted(int, unsigned int)

Compiler emitted; static instructions 28.

```asm
	.type	__ZN12_GLOBAL__N_17paintedEij,@function ; -- Begin function _ZN12_GLOBAL__N_17paintedEij
__ZN12_GLOBAL__N_17paintedEij:          ; @_ZN12_GLOBAL__N_17paintedEij
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
```

## sample — (anonymous namespace)::draw(int, unsigned int)

Compiler emitted; static instructions 72.

```asm
	.type	__ZN12_GLOBAL__N_14drawEij,@function ; -- Begin function _ZN12_GLOBAL__N_14drawEij
__ZN12_GLOBAL__N_14drawEij:             ; @_ZN12_GLOBAL__N_14drawEij
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
```

## sample — (anonymous namespace)::painted(int, unsigned int)

Compiler emitted; static instructions 28.

```asm
	.type	__ZN12_GLOBAL__N_17paintedEij,@function ; -- Begin function _ZN12_GLOBAL__N_17paintedEij
__ZN12_GLOBAL__N_17paintedEij:          ; @_ZN12_GLOBAL__N_17paintedEij
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
```
