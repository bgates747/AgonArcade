	.section	.text,"ax",@progbits
	.assume	ADL = 1
	.file	"main.cpp"
	.globl	__Z8gameMainiPPc                ; -- Begin function _Z8gameMainiPPc
	.type	__Z8gameMainiPPc,@function
__Z8gameMainiPPc:                       ; @_Z8gameMainiPPc
	.local	.Lfunc_begin0
.Lfunc_begin0:
; %bb.0:
	ld	hl, -4264
	call	__frameset
	ld	de, -4174
	lea	hl, ix + 0
	add	hl, de
	ld	de, -4180
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	bc, (ix + 6)
	ld	hl, 200
	ld	(__ZN12_GLOBAL__N_16motionE+27), hl
	ld	de, 2
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB0_2
; %bb.1:
	ld	bc, 1
	.local	.LBB0_2
.LBB0_2:
	ld	de, -4180
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	lea	hl, iy + 0
	lea	de, ix - 54
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4195
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	lea	de, ix - 74
	push	ix
	ld	bc, -4198
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	lea	de, iy + 0
	ld	bc, (ix - 3)
	dec	bc
	ld	iy, (ix + 9)
	lea	iy, iy + 3
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4186
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	.local	.LBB0_3
.LBB0_3:                                ; =>This Inner Loop Header: Depth=1
	ld	bc, (ix - 3)
	push	bc
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_24
; %bb.4:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	ld	hl, (iy)
	ld	de, _.str
	push	de
	push	hl
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB0_6
; %bb.5:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, __ZN5rallyL7TriOvalE
	jr	.LBB0_8
	.local	.LBB0_6
.LBB0_6:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, _.str.3
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB0_10
; %bb.7:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	hl, __ZN5rallyL4FujiE
	.local	.LBB0_8
.LBB0_8:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	(__ZN12_GLOBAL__N_18selectedE), hl
	.local	.LBB0_9
.LBB0_9:                                ;   in Loop: Header=BB0_3 Depth=1
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	dec	bc
	ld	de, -4183
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	lea	iy, iy + 3
	push	ix
	ld	de, -4186
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	ld	(ix - 3), bc
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	jp	.LBB0_3
	.local	.LBB0_10
.LBB0_10:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, _.str.4
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB0_12
; %bb.11:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_15mutedE), a
	jr	.LBB0_9
	.local	.LBB0_12
.LBB0_12:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, _.str.5
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB0_14
; %bb.13:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	a, 1
	jr	.LBB0_16
	.local	.LBB0_14
.LBB0_14:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, _.str.6
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB0_17
; %bb.15:                               ;   in Loop: Header=BB0_3 Depth=1
	xor	a, a
	.local	.LBB0_16
.LBB0_16:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	(__ZN12_GLOBAL__N_112steeringStepE), a
	jp	.LBB0_9
	.local	.LBB0_17
.LBB0_17:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, _.str.7
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB0_19
; %bb.18:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	a, 1
	jr	.LBB0_21
	.local	.LBB0_19
.LBB0_19:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, _.str.8
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB0_22
; %bb.20:                               ;   in Loop: Header=BB0_3 Depth=1
	xor	a, a
	.local	.LBB0_21
.LBB0_21:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	(__ZN12_GLOBAL__N_15rulesE+9), a
	jp	.LBB0_9
	.local	.LBB0_22
.LBB0_22:                               ;   in Loop: Header=BB0_3 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, _.str.9
	push	de
	push	hl
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_9
; %bb.23:
	ld	hl, _str
	push	hl
	call	_puts
	pop	hl
	jr	.LBB0_25
	.local	.LBB0_24
.LBB0_24:
	ld	hl, __ZN12_GLOBAL__N_17recordsE
	push	hl
	ld	hl, _.str.11
	push	hl
	call	__ZN5rally4game11readRecordsEPKcRNS0_7RecordsE
	pop	hl
	pop	hl
	bit	0, a
	ld	hl, __ZN12_GLOBAL__N_17recordsE
	push	hl
	ld	hl, _.str.12
	push	hl
	call	z, __ZN5rally4game11readRecordsEPKcRNS0_7RecordsE
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_19loadTrackEv
	ld	hl, 136
	push	hl
	call	_vdp_mode
	pop	de
	ld	de, 0
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB0_26
	.local	.LBB0_25
.LBB0_25:
	ld	hl, 1
	jp	.LBB0_395
	.local	.LBB0_26
.LBB0_26:
	call	_vdp_set_pixel_coordinates
	call	_vdp_reset_sprites
	or	a, a
	sbc	hl, hl
	push	hl
	call	_vdp_cursor_enable
	pop	hl
	ld	bc, 5
	ld	de, 0
	push	de
	pop	iy
	.local	.LBB0_27
.LBB0_27:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_29 Depth 2
                                        ;       Child Loop BB0_31 Depth 3
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_35
; %bb.28:                               ;   in Loop: Header=BB0_27 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	ld	de, 64000
	add	iy, de
	push	ix
	ld	bc, -4201
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	push	iy
	call	_vdp_adv_clear_buffer
	ld	iy, 0
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_19carUploadE
	push	ix
	ld	de, -4189
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	lea	bc, iy + 0
	.local	.LBB0_29
.LBB0_29:                               ;   Parent Loop BB0_27 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB0_31 Depth 3
	push	bc
	pop	hl
	ld	de, 77
	or	a, a
	sbc	hl, de
	jp	z, .LBB0_34
; %bb.30:                               ;   in Loop: Header=BB0_29 Depth=2
	ld	de, -4204
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	push	bc
	pop	hl
	ld	bc, 48
	call	__imulu
	ld	bc, 77
	call	__idivu
	ld	c, 6
	call	__ishl
	push	ix
	ld	de, -4207
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld.sis	hl, 0
	push	ix
	ld	de, -4192
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	lea	de, iy + 0
	.local	.LBB0_31
.LBB0_31:                               ;   Parent Loop BB0_27 Depth=1
                                        ;     Parent Loop BB0_29 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	push	de
	pop	hl
	ld	bc, 102
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_33
; %bb.32:                               ;   in Loop: Header=BB0_31 Depth=3
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld.sis	bc, 102
	call	__sdivu
	ld	bc, 0
	ld	c, l
	ld	b, h
	ld	(ix - 3), de
	ld	de, -4207
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	add	hl, bc
	push	hl
	pop	iy
	ld	de, -4183
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	bc, 3072
	call	__imulu
	push	hl
	pop	bc
	ld	hl, __ZN5rallyL9CarPixelsE
	add	hl, bc
	lea	bc, iy + 0
	add	hl, bc
	ld	a, (hl)
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	de, (ix - 3)
	add	iy, de
	ld	(iy), a
	ld	iy, 0
	inc	de
	ld.sis	bc, 64
	ld	(ix - 3), de
	push	ix
	ld	de, -4192
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	add.sis	hl, bc
	push	ix
	ld	bc, -4192
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	de, (ix - 3)
	jp	.LBB0_31
	.local	.LBB0_33
.LBB0_33:                               ;   in Loop: Header=BB0_29 Depth=2
	ld	de, -4204
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	inc	bc
	lea	hl, iy + 0
	ld	de, -4189
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	lea	iy, iy + 102
	push	ix
	add	ix, de
	ld	(ix + 0), iy
	pop	ix
	push	hl
	pop	iy
	jp	.LBB0_29
	.local	.LBB0_34
.LBB0_34:                               ;   in Loop: Header=BB0_27 Depth=1
	ld	hl, __ZN12_GLOBAL__N_19carUploadE
	push	hl
	ld	hl, 7854
	push	hl
	ld	bc, -4201
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_vdp_adv_write_block_data
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	hl, 1
	push	hl
	ld	hl, 77
	push	hl
	ld	hl, 102
	push	hl
	call	_vdp_adv_bitmap_from_buffer
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	de, 0
	pop	hl
	pop	hl
	pop	hl
	inc	iy
	ld	bc, 5
	jp	.LBB0_27
	.local	.LBB0_35
.LBB0_35:
	ld	bc, 7
	ld	(ix - 3), bc
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ld	iy, 1
	ld	bc, (ix - 3)
	.local	.LBB0_36
.LBB0_36:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_37 Depth 2
                                        ;     Child Loop BB0_40 Depth 2
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	ld	a, 0
	ld	c, a
	jp	z, .LBB0_47
	.local	.LBB0_37
.LBB0_37:                               ;   Parent Loop BB0_36 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	(ix - 3), bc
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ex	de, hl
	ld	de, 256
	or	a, a
	sbc	hl, de
	ld	de, -4183
	lea	hl, ix + 0
	push	af
	add	hl, de
	pop	af
	ld	(hl), iy
	ld	bc, (ix - 3)
	jr	z, .LBB0_39
; %bb.38:                               ;   in Loop: Header=BB0_37 Depth=2
	push	iy
	push	bc
	ld	de, -4201
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	call	__ZN5rally9carColourEhj
	ld	de, -4201
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	ld	de, -4183
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	pop	hl
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_19carUploadE
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4192
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
	add	hl, de
	ld	(hl), a
	inc	de
	ld	bc, (ix - 3)
	inc	c
	jr	.LBB0_37
	.local	.LBB0_39
.LBB0_39:                               ;   in Loop: Header=BB0_36 Depth=1
	ld	hl, 63960
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_19carUploadE
	push	hl
	ld	hl, 256
	push	hl
	ld	hl, 63960
	push	hl
	call	_vdp_adv_write_block_data
	pop	hl
	pop	hl
	pop	hl
	ld	hl, -5
	push	hl
	pop	bc
	ld	de, 0
	ld	(ix - 3), bc
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ld	bc, (ix - 3)
	.local	.LBB0_40
.LBB0_40:                               ;   Parent Loop BB0_36 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	push	bc
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_46
; %bb.41:                               ;   in Loop: Header=BB0_40 Depth=2
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	de, -4201
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	add	hl, bc
	push	hl
	pop	iy
	ld	de, 10
	add	iy, de
	push	ix
	ld	bc, -4204
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	de, 64010
	add	hl, de
	ld	bc, -4207
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	(ix - 75), 0
	ld	bc, -4180
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	(iy + 0), 23
	ld	(iy + 1), 0
	ld	hl, 3
	ld	(ix - 78), hl
	ld	(iy + 2), -96
	ld	bc, -4207
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally6Stream4wordEi
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	pop	hl
	pop	hl
	ld	de, (ix - 78)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_44
; %bb.42:                               ;   in Loop: Header=BB0_40 Depth=2
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(ix - 78), de
	ld	(hl), 72
	ld	de, (ix - 78)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_44
; %bb.43:                               ;   in Loop: Header=BB0_40 Depth=2
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(ix - 78), de
	ld	(hl), 16
	jr	.LBB0_45
	.local	.LBB0_44
.LBB0_44:                               ;   in Loop: Header=BB0_40 Depth=2
	ld	(ix - 75), 1
	.local	.LBB0_45
.LBB0_45:                               ;   in Loop: Header=BB0_40 Depth=2
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	de, 64000
	add	hl, de
	push	hl
	push	iy
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, 63960
	push	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, (ix - 78)
	ld	de, 0
	push	de
	push	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_mos_puts
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4204
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	hl, 1
	push	hl
	ld	hl, 77
	push	hl
	ld	hl, 102
	push	hl
	call	_vdp_adv_bitmap_from_buffer
	pop	hl
	pop	hl
	pop	hl
	ld	de, -4192
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	inc	hl
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	de, -4201
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	inc	bc
	ld	de, 0
	jp	.LBB0_40
	.local	.LBB0_46
.LBB0_46:                               ;   in Loop: Header=BB0_36 Depth=1
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	inc	iy
	ld	bc, 5
	ld	(ix - 3), de
	push	ix
	ld	de, -4189
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	add	hl, bc
	push	ix
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	bc, 7
	ld	de, (ix - 3)
	jp	.LBB0_36
	.local	.LBB0_47
.LBB0_47:
	ld	hl, 63960
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	lea	de, iy + 0
	ld	hl, ___const._ZN12_GLOBAL__N_18loadCarsEv.mirrorCommands
	ld	bc, 34
	ldir
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 34
	push	hl
	push	iy
	call	_mos_puts
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 63800
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	hl, __ZN5rallyL13SceneryPixelsE
	push	hl
	ld	hl, 53248
	push	hl
	ld	hl, 63800
	push	hl
	call	_vdp_adv_write_block_data
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 64100
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	ld	bc, __ZN12_GLOBAL__N_16streamE
	push	bc
	pop	iy
	jr	nc, .LBB0_51
; %bb.48:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 23
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_51
; %bb.49:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 0
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_51
; %bb.50:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), -96
	jr	.LBB0_52
	.local	.LBB0_51
.LBB0_51:
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	.local	.LBB0_52
.LBB0_52:
	ld	hl, 64100
	push	hl
	push	iy
	call	__ZN5rally6Stream4wordEi
	ld	bc, __ZN12_GLOBAL__N_16streamE
	push	bc
	pop	iy
	pop	hl
	pop	hl
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_55
; %bb.53:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 72
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_55
; %bb.54:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 4
	jr	.LBB0_56
	.local	.LBB0_55
.LBB0_55:
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	.local	.LBB0_56
.LBB0_56:
	ld	hl, 63800
	push	hl
	push	iy
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	bc, 16
	ld	de, 0
	.local	.LBB0_57
.LBB0_57:                               ; =>This Inner Loop Header: Depth=1
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	z, .LBB0_62
; %bb.58:                               ;   in Loop: Header=BB0_57 Depth=1
	push	de
	pop	iy
	ld	bc, (__ZN12_GLOBAL__N_16streamE+4096)
	push	bc
	pop	hl
	ld	de, 4096
	or	a, a
	sbc	hl, de
	jr	nc, .LBB0_60
; %bb.59:                               ;   in Loop: Header=BB0_57 Depth=1
	ld	hl, __ZN5rallyL14SceneryPaletteE
	lea	de, iy + 0
	add	hl, de
	ld	a, (hl)
	ld	hl, __ZN12_GLOBAL__N_16streamE
	add	hl, bc
	inc	bc
	ld	(__ZN12_GLOBAL__N_16streamE+4096), bc
	ld	(hl), a
	jr	.LBB0_61
	.local	.LBB0_60
.LBB0_60:                               ;   in Loop: Header=BB0_57 Depth=1
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	lea	de, iy + 0
	.local	.LBB0_61
.LBB0_61:                               ;   in Loop: Header=BB0_57 Depth=1
	inc	de
	ld	bc, 16
	jr	.LBB0_57
	.local	.LBB0_62
.LBB0_62:
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, 100
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	hl, 1
	push	hl
	ld	hl, 104
	push	hl
	ld	hl, 1024
	push	hl
	call	_vdp_adv_bitmap_from_buffer
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 63800
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	hl, 15
	push	hl
	call	_vdp_set_text_colour
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	call	_vdp_set_text_bg_colour
	pop	hl
	ld	hl, 63940
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	hl, __ZN5rally4gameL10FontPixelsE
	push	hl
	ld	hl, 2048
	push	hl
	ld	hl, 63940
	push	hl
	call	_vdp_adv_write_block_data
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 8
	push	hl
	ld	hl, 63940
	push	hl
	call	__ZN12_GLOBAL__N_110fontCreateEjj
	pop	hl
	pop	hl
	ld	hl, 63941
	push	hl
	call	_vdp_adv_clear_buffer
	ld	bc, 0
	pop	hl
	.local	.LBB0_63
.LBB0_63:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_65 Depth 2
                                        ;       Child Loop BB0_67 Depth 3
	push	bc
	pop	hl
	ld	de, 256
	or	a, a
	sbc	hl, de
	jp	z, .LBB0_73
; %bb.64:                               ;   in Loop: Header=BB0_63 Depth=1
	ld	de, -4183
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	push	bc
	pop	hl
	ld	c, 3
	call	__ishl
	ld	de, -4189
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	bc, 0
	.local	.LBB0_65
.LBB0_65:                               ;   Parent Loop BB0_63 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB0_67 Depth 3
	push	bc
	pop	hl
	ld	de, 8
	or	a, a
	sbc	hl, de
	jp	z, .LBB0_72
; %bb.66:                               ;   in Loop: Header=BB0_65 Depth=2
	ld	de, -4192
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	push	bc
	pop	hl
	ld	bc, -4189
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	add	hl, de
	ex	de, hl
	ld	hl, __ZN5rally4gameL10FontPixelsE
	add	hl, de
	ld	a, (hl)
	ld	bc, -4201
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a
	ld	de, 0
	push	de
	pop	iy
	.local	.LBB0_67
.LBB0_67:                               ;   Parent Loop BB0_63 Depth=1
                                        ;     Parent Loop BB0_65 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	push	de
	pop	hl
	ld	bc, 8
	or	a, a
	sbc	hl, bc
	jr	z, .LBB0_71
; %bb.68:                               ;   in Loop: Header=BB0_67 Depth=3
	lea	hl, iy + 0
	ld	c, 2
	call	__ishl
	ld	(ix - 3), bc
	ld	bc, -4204
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	hl, 128
	ld	bc, (ix - 3)
	ld	c, e
	call	__ishru
	ld	a, l
	ld	(ix - 3), bc
	ld	bc, -4201
	lea	hl, ix + 0
	add	hl, bc
	and	a, (hl)                         ; 1-byte Folded Reload
	or	a, a
	ld	iy, 0
	ld	bc, (ix - 3)
	jr	z, .LBB0_70
; %bb.69:                               ;   in Loop: Header=BB0_67 Depth=3
	ld	iy, 3
	.local	.LBB0_70
.LBB0_70:                               ;   in Loop: Header=BB0_67 Depth=3
	ld	(ix - 3), de
	ld	de, -4204
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	add	iy, bc
	ld	de, (ix - 3)
	inc	de
	jr	.LBB0_67
	.local	.LBB0_71
.LBB0_71:                               ;   in Loop: Header=BB0_65 Depth=2
	ld	bc, -4204
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	ld	a, iyh
	ld	bc, -4192
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	pop	hl
	ld	c, 2
	call	__ishl
	push	de
	pop	bc
	push	hl
	pop	de
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4177
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	add	iy, de
	ld	(iy + 2), a
	ld	(iy), a
	push	ix
	ld	de, -4204
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	ld	a, l
	ld	(iy + 3), a
	ld	(iy + 1), a
	ld	bc, (ix - 3)
	inc	bc
	jp	.LBB0_65
	.local	.LBB0_72
.LBB0_72:                               ;   in Loop: Header=BB0_63 Depth=1
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 32
	push	hl
	ld	hl, 63941
	push	hl
	call	_vdp_adv_write_block_data
	pop	hl
	pop	hl
	pop	hl
	ld	de, -4183
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	inc	bc
	jp	.LBB0_63
	.local	.LBB0_73
.LBB0_73:
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	lea	de, iy + 0
	ld	hl, ___const._ZN12_GLOBAL__N_18loadFontEv.consolidate
	ld	bc, 6
	ldir
	ld	hl, 6
	push	hl
	push	iy
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	ld	hl, 16
	push	hl
	ld	hl, 63941
	push	hl
	call	__ZN12_GLOBAL__N_110fontCreateEjj
	pop	hl
	pop	hl
	ld	hl, 63940
	push	hl
	call	__ZN12_GLOBAL__N_14fontEj
	pop	hl
	ld	hl, __ZN5rally4gameL11SignArtworkE
	push	hl
	pop	iy
	ld	bc, 0
	.local	.LBB0_74
.LBB0_74:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_85 Depth 2
	push	bc
	pop	hl
	ld	de, 8
	or	a, a
	sbc	hl, de
	jp	z, .LBB0_91
; %bb.75:                               ;   in Loop: Header=BB0_74 Depth=1
	ld	de, -4183
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	push	bc
	pop	hl
	ld	de, 120
	add	hl, de
	ld	de, -4189
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	hl, 63800
	push	hl
	ld	de, -4177
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	de, -4177
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	bc, 2064
	call	__imulu
	push	hl
	pop	de
	ld	iy, __ZN5rally4gameL11SignArtworkE
	add	iy, de
	pea	iy + 16
	ld	hl, 2048
	push	hl
	ld	hl, 63800
	push	hl
	call	_vdp_adv_write_block_data
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	de, 64120
	add	hl, de
	ld	bc, -4192
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	ld	bc, __ZN12_GLOBAL__N_16streamE
	push	bc
	pop	iy
	jr	nc, .LBB0_79
; %bb.76:                               ;   in Loop: Header=BB0_74 Depth=1
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 23
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_79
; %bb.77:                               ;   in Loop: Header=BB0_74 Depth=1
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 0
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_79
; %bb.78:                               ;   in Loop: Header=BB0_74 Depth=1
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), -96
	jr	.LBB0_80
	.local	.LBB0_79
.LBB0_79:                               ;   in Loop: Header=BB0_74 Depth=1
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	.local	.LBB0_80
.LBB0_80:                               ;   in Loop: Header=BB0_74 Depth=1
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	push	iy
	call	__ZN5rally6Stream4wordEi
	ld	bc, __ZN12_GLOBAL__N_16streamE
	push	bc
	pop	iy
	pop	hl
	pop	hl
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_83
; %bb.81:                               ;   in Loop: Header=BB0_74 Depth=1
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 72
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB0_83
; %bb.82:                               ;   in Loop: Header=BB0_74 Depth=1
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 4
	jr	.LBB0_84
	.local	.LBB0_83
.LBB0_83:                               ;   in Loop: Header=BB0_74 Depth=1
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	.local	.LBB0_84
.LBB0_84:                               ;   in Loop: Header=BB0_74 Depth=1
	ld	hl, 63800
	push	hl
	push	iy
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	de, 0
	.local	.LBB0_85
.LBB0_85:                               ;   Parent Loop BB0_74 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	bc, 16
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	z, .LBB0_90
; %bb.86:                               ;   in Loop: Header=BB0_85 Depth=2
	push	de
	pop	iy
	ld	bc, (__ZN12_GLOBAL__N_16streamE+4096)
	push	bc
	pop	hl
	ld	de, 4096
	or	a, a
	sbc	hl, de
	jr	nc, .LBB0_88
; %bb.87:                               ;   in Loop: Header=BB0_85 Depth=2
	ld	de, -4183
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	lea	de, iy + 0
	add	hl, de
	ld	a, (hl)
	ld	hl, __ZN12_GLOBAL__N_16streamE
	add	hl, bc
	inc	bc
	ld	(__ZN12_GLOBAL__N_16streamE+4096), bc
	ld	(hl), a
	jr	.LBB0_89
	.local	.LBB0_88
.LBB0_88:                               ;   in Loop: Header=BB0_85 Depth=2
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	lea	de, iy + 0
	.local	.LBB0_89
.LBB0_89:                               ;   in Loop: Header=BB0_85 Depth=2
	inc	de
	jr	.LBB0_85
	.local	.LBB0_90
.LBB0_90:                               ;   in Loop: Header=BB0_74 Depth=1
	call	__ZN12_GLOBAL__N_15flushEv
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	hl, 1
	push	hl
	ld	hl, 64
	push	hl
	push	hl
	call	_vdp_adv_bitmap_from_buffer
	pop	hl
	pop	hl
	pop	hl
	ld	de, -4177
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	inc	bc
	ld	de, 2064
	ld	(ix - 3), bc
	ld	bc, -4183
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	add	iy, de
	ld	bc, (ix - 3)
	jp	.LBB0_74
	.local	.LBB0_91
.LBB0_91:
	ld	hl, 63800
	push	hl
	call	_vdp_adv_clear_buffer
	pop	hl
	call	__ZN12_GLOBAL__N_111resetMotionEv
	call	__ZN12_GLOBAL__N_112phaseChangedEv
	ld	a, (__ZN12_GLOBAL__N_15mutedE)
	bit	0, a
	ld	hl, __ZN12_GLOBAL__N_14sendEPKhj
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16engineE
	push	hl
	call	z, __ZN5rally4game6Engine5startIPFvPKhjEEEvT_
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_18rawClockEv
	push	hl
	pop	bc
	ld	d, e
	ld	iy, __ZN12_GLOBAL__N_115attractProgressE
	lea	hl, iy + 3
	ld	(ix - 3), de
	ld	de, -4207
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	de, -4177
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	ld	de, (ix - 3)
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4192
	add	ix, bc
	ld	(ix + 0), d                     ; 1-byte Folded Spill
	pop	ix
	.local	.LBB0_92
.LBB0_92:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_93 Depth 2
                                        ;     Child Loop BB0_96 Depth 2
                                        ;     Child Loop BB0_99 Depth 2
                                        ;     Child Loop BB0_162 Depth 2
                                        ;       Child Loop BB0_177 Depth 3
                                        ;       Child Loop BB0_221 Depth 3
                                        ;       Child Loop BB0_166 Depth 3
                                        ;     Child Loop BB0_271 Depth 2
                                        ;       Child Loop BB0_276 Depth 3
                                        ;     Child Loop BB0_289 Depth 2
                                        ;       Child Loop BB0_290 Depth 3
                                        ;     Child Loop BB0_316 Depth 2
	ld	bc, (ix - 3)
	ld	(ix - 3), de
	ld	de, -4183
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	ld	de, (ix - 3)
	.local	.LBB0_93
.LBB0_93:                               ;   Parent Loop BB0_92 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	a, (__ZN12_GLOBAL__N_14quitE)
	bit	0, a
	jp	nz, .LBB0_391
; %bb.94:                               ;   in Loop: Header=BB0_93 Depth=2
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), d                         ; 1-byte Folded Spill
	call	__ZN12_GLOBAL__N_18rawClockEv
	ld	bc, -4189
	lea	iy, ix + 0
	add	iy, bc
	ld	d, (iy + 0)                     ; 1-byte Folded Reload
	push	ix
	ld	bc, -4204
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -4201
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	ld	(ix - 3), de
	push	ix
	ld	de, -4177
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	ld	de, (ix - 3)
	ld	a, d
	call	__lsub
	push	hl
	pop	bc
	ld	a, e
	scf
	sbc	hl, hl
	ld	e, h
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB0_93
; %bb.95:                               ;   in Loop: Header=BB0_92 Depth=1
	ld	de, __ZN12_GLOBAL__N_112previousKeysE
	ld	hl, __ZN12_GLOBAL__N_18heldKeysE
	ld	bc, 16
	ldir
	xor	a, a
	ld	iyl, a
	ld	de, 0
	push	de
	pop	bc
	.local	.LBB0_96
.LBB0_96:                               ;   Parent Loop BB0_92 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	(ix - 3), de
	ld	de, -4177
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	push	bc
	pop	hl
	ld	bc, 16
	or	a, a
	sbc	hl, bc
	ld	de, (ix - 3)
	jr	z, .LBB0_98
; %bb.97:                               ;   in Loop: Header=BB0_96 Depth=2
	push	iy
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	call	_vdp_getKeyMap
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	de, 0
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_18heldKeysE
	ld	(ix - 3), de
	push	ix
	ld	de, -4177
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	add	hl, bc
	ld	(hl), a
	inc	bc
	inc	iyl
	ld	de, (ix - 3)
	jr	.LBB0_96
	.local	.LBB0_98
.LBB0_98:                               ;   in Loop: Header=BB0_92 Depth=1
	xor	a, a
	.local	.LBB0_99
.LBB0_99:                               ;   Parent Loop BB0_92 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	z, .LBB0_104
; %bb.100:                              ;   in Loop: Header=BB0_99 Depth=2
	bit	0, a
	ld	a, 1
	jr	nz, .LBB0_103
; %bb.101:                              ;   in Loop: Header=BB0_99 Depth=2
	ld	hl, __ZN12_GLOBAL__N_18heldKeysE
	add	hl, de
	ld	a, (hl)
	or	a, a
	ld	a, -1
	jr	nz, .LBB0_103
; %bb.102:                              ;   in Loop: Header=BB0_99 Depth=2
	ld	a, 0
	.local	.LBB0_103
.LBB0_103:                              ;   in Loop: Header=BB0_99 Depth=2
	and	a, 1
	inc	de
	jr	.LBB0_99
	.local	.LBB0_104
.LBB0_104:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, -4204
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -4201
	lea	iy, ix + 0
	add	iy, bc
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	ld	(ix - 3), de
	push	ix
	ld	de, -4183
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	ld	de, (ix - 3)
	ld	d, a
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4192
	add	ix, bc
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, (ix - 3)
	call	__lsub
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4177
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -4183
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	(ix + 0), d                     ; 1-byte Folded Spill
	pop	ix
	bit	0, d
	ld	bc, (ix - 3)
	jr	nz, .LBB0_106
; %bb.105:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_110inputArmedE), a
	.local	.LBB0_106
.LBB0_106:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 102
	push	hl
	call	__ZN12_GLOBAL__N_17pressedEi
	pop	hl
	bit	0, a
	jr	z, .LBB0_111
; %bb.107:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15mutedE)
	ld	l, a
	xor	a, 1
	ld	(__ZN12_GLOBAL__N_15mutedE), a
	bit	0, l
	jr	nz, .LBB0_109
; %bb.108:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, __ZN12_GLOBAL__N_14sendEPKhj
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16engineE
	push	hl
	call	__ZN5rally4game6Engine4stopIPFvPKhjEEEvT_
	jr	.LBB0_110
	.local	.LBB0_109
.LBB0_109:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, __ZN12_GLOBAL__N_14sendEPKhj
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16engineE
	push	hl
	call	__ZN5rally4game6Engine5startIPFvPKhjEEEvT_
	.local	.LBB0_110
.LBB0_110:                              ;   in Loop: Header=BB0_92 Depth=1
	pop	hl
	pop	hl
	.local	.LBB0_111
.LBB0_111:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 113
	push	hl
	call	__ZN12_GLOBAL__N_17pressedEi
	ld	e, a
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	l, a
	bit	0, e
	jr	z, .LBB0_115
; %bb.112:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	or	a, a
	jr	nz, .LBB0_114
; %bb.113:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_110inputArmedE)
	bit	0, a
	jp	nz, .LBB0_390
	.local	.LBB0_114
.LBB0_114:                              ;   in Loop: Header=BB0_92 Depth=1
	xor	a, a
	ld	(__ZN12_GLOBAL__N_15rulesE+10), a
	sbc	hl, hl
	ld	(__ZN12_GLOBAL__N_15rulesE+11), hl
	ld	(__ZN12_GLOBAL__N_15rulesE+14), a
	ld	hl, __ZN12_GLOBAL__N_15rulesE+55
	push	hl
	pop	iy
	ld	hl, (iy)
	inc.sis	hl
	ld	(iy), l
	ld	(iy + 1), h
	jp	.LBB0_160
	.local	.LBB0_115
.LBB0_115:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	or	a, a
	jr	nz, .LBB0_119
; %bb.116:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_110inputArmedE)
	bit	0, a
	jp	z, .LBB0_137
; %bb.117:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	bit	0, (hl)                         ; 1-byte Folded Reload
	jp	z, .LBB0_137
; %bb.118:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_15rulesE+10), a
	or	a, a
	sbc	hl, hl
	ld	(__ZN12_GLOBAL__N_15rulesE+11), hl
	dec	a
	ld	(__ZN12_GLOBAL__N_15rulesE+14), a
	ld	hl, __ZN12_GLOBAL__N_15rulesE+55
	push	hl
	pop	iy
	ld	hl, (iy)
	inc.sis	hl
	ld	(iy), l
	ld	(iy + 1), h
	jp	.LBB0_137
	.local	.LBB0_119
.LBB0_119:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	cp	a, 1
	jr	nz, .LBB0_130
; %bb.120:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 26
	push	hl
	call	__ZN12_GLOBAL__N_17pressedEi
	pop	hl
	bit	0, a
	jr	nz, .LBB0_122
; %bb.121:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 122
	push	hl
	call	__ZN12_GLOBAL__N_17pressedEi
	pop	hl
	bit	0, a
	jr	z, .LBB0_125
	.local	.LBB0_122
.LBB0_122:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_18selectedE)
	ld	de, __ZN5rallyL4FujiE
	or	a, a
	sbc	hl, de
	ld	hl, __ZN5rallyL7TriOvalE
	jr	z, .LBB0_124
; %bb.123:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, __ZN5rallyL4FujiE
	.local	.LBB0_124
.LBB0_124:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	(__ZN12_GLOBAL__N_18selectedE), hl
	call	__ZN12_GLOBAL__N_19loadTrackEv
	call	__ZN12_GLOBAL__N_111resetMotionEv
	xor	a, a
	ld	(__ZN12_GLOBAL__N_114sceneryHistoryE+7), a
	ld	(__ZN12_GLOBAL__N_114sceneryHistoryE+6), a
	.local	.LBB0_125
.LBB0_125:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 58
	push	hl
	call	__ZN12_GLOBAL__N_17pressedEi
	pop	hl
	bit	0, a
	jr	nz, .LBB0_127
; %bb.126:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 42
	push	hl
	call	__ZN12_GLOBAL__N_17pressedEi
	pop	hl
	bit	0, a
	jr	z, .LBB0_131
	.local	.LBB0_127
.LBB0_127:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	or	a, a
	ld	a, 1
	jr	z, .LBB0_129
; %bb.128:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, 0
	.local	.LBB0_129
.LBB0_129:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	(__ZN12_GLOBAL__N_15rulesE+9), a
	jr	.LBB0_131
	.local	.LBB0_130
.LBB0_130:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	add	a, -7
	cp	a, 3
	jp	nc, .LBB0_137
	.local	.LBB0_131
.LBB0_131:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_110inputArmedE)
	bit	0, a
	jp	z, .LBB0_137
; %bb.132:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 99
	push	hl
	call	__ZN12_GLOBAL__N_17pressedEi
	pop	hl
	bit	0, a
	jr	nz, .LBB0_134
; %bb.133:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 74
	push	hl
	call	__ZN12_GLOBAL__N_17pressedEi
	pop	hl
	bit	0, a
	jp	z, .LBB0_137
	.local	.LBB0_134
.LBB0_134:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	iy, (__ZN12_GLOBAL__N_18selectedE)
	ld	hl, (iy + 6)
	ld	e, (iy + 9)
	ld	bc, 100
	xor	a, a
	call	__lmulu
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
                                        ; kill: def $e killed $e def $ude
	push	ix
	ld	bc, -4192
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	lea	hl, iy + 0
	ld	de, __ZN5rallyL4FujiE
	or	a, a
	sbc	hl, de
	ld	hl, __ZN5rally4gameL9FujiRulesE
	ld	bc, (ix - 3)
	jr	z, .LBB0_136
; %bb.135:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, __ZN5rally4gameL9OvalRulesE
	.local	.LBB0_136
.LBB0_136:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, (__ZN12_GLOBAL__N_16motionE+27)
	ld	bc, -4210
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), de
	push	de
	push	de
	push	de
	push	de
	ld	iy, 0
	add	iy, sp
	lea	de, iy + 0
	ld	bc, 9
	ldir
	ld	bc, -4210
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	(iy + 9), hl
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_15rulesE
	push	hl
	call	__ZN5rally4game5Rules7attemptEmNS0_8SettingsEi
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	.local	.LBB0_137
.LBB0_137:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	hl, __ZN12_GLOBAL__N_15crashE
	ld	hl, (hl)
	cp	a, 3
	jr	z, .LBB0_139
; %bb.138:                              ;   in Loop: Header=BB0_92 Depth=1
	cp	a, 6
	jp	nz, .LBB0_154
	.local	.LBB0_139
.LBB0_139:                              ;   in Loop: Header=BB0_92 Depth=1
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	nz, .LBB0_154
; %bb.140:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_18heldKeysE+3)
	ld	l, a
	ld	a, (__ZN12_GLOBAL__N_18heldKeysE+15)
	and	a, 2
	ld	e, a
	bit	1, l
	ld	l, -1
	jr	nz, .LBB0_142
; %bb.141:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	l, 0
	.local	.LBB0_142
.LBB0_142:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, e
	or	a, a
	ld	c, -1
	jr	nz, .LBB0_144
; %bb.143:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	c, 0
	.local	.LBB0_144
.LBB0_144:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	xor	a, c
	bit	0, a
	jr	z, .LBB0_154
; %bb.145:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_112steeringStepE)
	bit	0, a
	ld	bc, 1
	jr	nz, .LBB0_147
; %bb.146:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, 2
	.local	.LBB0_147
.LBB0_147:                              ;   in Loop: Header=BB0_92 Depth=1
	push	bc
	pop	hl
	call	__ineg
	ld	a, e
	or	a, a
	jr	nz, .LBB0_149
; %bb.148:                              ;   in Loop: Header=BB0_92 Depth=1
	push	hl
	pop	bc
	.local	.LBB0_149
.LBB0_149:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, __ZN12_GLOBAL__N_16motionE+23
	ld	iy, (hl)
	add.sis	iy, bc
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld.sis	de, 21
	or	a, a
	sbc.sis	hl, de
	call	pe, __setflag
	jp	m, .LBB0_151
; %bb.150:                              ;   in Loop: Header=BB0_92 Depth=1
	ld.sis	hl, 21
	ex	de, hl
	ld	iyl, e
	ld	iyh, d
	ex	de, hl
	.local	.LBB0_151
.LBB0_151:                              ;   in Loop: Header=BB0_92 Depth=1
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld.sis	de, -20
	or	a, a
	sbc.sis	hl, de
	call	pe, __setflag
	jp	p, .LBB0_153
; %bb.152:                              ;   in Loop: Header=BB0_92 Depth=1
	ld.sis	hl, -21
	ex	de, hl
	ld	iyl, e
	ld	iyh, d
	ex	de, hl
	.local	.LBB0_153
.LBB0_153:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, __ZN12_GLOBAL__N_16motionE+23
	push	de
	ld	e, iyl
	ld	d, iyh
	ld	(hl), e
	inc	hl
	ld	(hl), d
	pop	de
	.local	.LBB0_154
.LBB0_154:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_18heldKeysE+2)
	ld	l, a
	ld	a, (__ZN12_GLOBAL__N_18heldKeysE+11)
	bit	5, a
	ld	de, -1
	jr	nz, .LBB0_156
; %bb.155:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, 0
	.local	.LBB0_156
.LBB0_156:                              ;   in Loop: Header=BB0_92 Depth=1
	push	de
	ld	a, l
	cp	a, 0
	call	pe, __setflag
	ld	hl, -1
	jp	m, .LBB0_158
; %bb.157:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 0
	.local	.LBB0_158
.LBB0_158:                              ;   in Loop: Header=BB0_92 Depth=1
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16motionE
	push	hl
	call	__ZN5rally6Motion9gripFrameEbb
	pop	hl
	pop	hl
	pop	hl
	ld	de, (__ZN12_GLOBAL__N_16motionE+27)
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+62)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB0_160
; %bb.159:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	(__ZN12_GLOBAL__N_15rulesE+62), de
	.local	.LBB0_160
.LBB0_160:                              ;   in Loop: Header=BB0_92 Depth=1
	call	__ZN12_GLOBAL__N_112phaseChangedEv
	ld	a, (__ZN12_GLOBAL__N_14quitE)
	bit	0, a
	jp	nz, .LBB0_391
; %bb.161:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	or	a, a
	ld	hl, __ZN12_GLOBAL__N_16motionE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_110demoDriverE
	push	hl
	call	z, __ZN5rally10DemoDriver5frameERNS_6MotionE
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	xor	a, a
	ld	e, a
	.local	.LBB0_162
.LBB0_162:                              ;   Parent Loop BB0_92 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB0_177 Depth 3
                                        ;       Child Loop BB0_221 Depth 3
                                        ;       Child Loop BB0_166 Depth 3
	ld	(ix - 3), de
	ld	de, -4177
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -4183
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lcmpu
	jp	nc, .LBB0_246
; %bb.163:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	bc, -4210
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), e                     ; 1-byte Folded Spill
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	e, a
	or	a, a
	push	ix
	ld	bc, -4192
	push	af
	add	ix, bc
	pop	af
	ld	(ix + 0), hl
	pop	ix
	jp	nz, .LBB0_168
; %bb.164:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16motionE+30), a
	ld	hl, __ZN12_GLOBAL__N_16motionE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_110demoDriverE
	push	hl
	call	__ZNK5rally10DemoDriver4tickERNS_6MotionE
	pop	hl
	pop	hl
	ld	bc, (__ZN12_GLOBAL__N_16motionE+11)
	ld	a, (__ZN12_GLOBAL__N_16motionE+14)
	ld	l, 1
	call	__lshl
	ld	hl, (__ZN12_GLOBAL__N_115attractProgressE)
	ld	de, -4207
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	ld	e, (iy)
	call	__ladd
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	(__ZN12_GLOBAL__N_115attractProgressE), hl
	ld	(iy), e
	ld	iyl, e
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+11)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+14)
	ld	e, a
	ld	bc, (ix - 3)
	ld	bc, 1
	xor	a, a
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	ex	de, hl
	ld	e, iyl
	ex	de, hl
	push	hl
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	call	__ZN5rally4game11RaceTraffic4tickEmm
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	iy, (__ZN12_GLOBAL__N_18selectedE)
	ld	hl, (iy + 6)
	ld	e, (iy + 9)
	ld	bc, 100
	xor	a, a
	call	__lmulu
	push	hl
	pop	bc
	ld	d, e
	ld	hl, (__ZN12_GLOBAL__N_115attractProgressE)
	ld	a, (__ZN12_GLOBAL__N_115attractProgressE+3)
	ld	e, a
	ld	(ix - 3), de
	ld	de, -4189
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	ld	de, (ix - 3)
	ld	a, d
	call	__lcmpu
	ld	bc, 0
	ld	a, b
	ld	iyl, a
	jp	c, .LBB0_216
; %bb.165:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	(ix - 3), de
	ld	de, -4189
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	ld	de, (ix - 3)
	ld	a, d
	call	__lsub
	ld	a, e
	ld	(__ZN12_GLOBAL__N_115attractProgressE), hl
	ld	(__ZN12_GLOBAL__N_115attractProgressE+3), a
	ld	hl, 174
	ld	iy, __ZN12_GLOBAL__N_111raceTrafficE
	.local	.LBB0_166
.LBB0_166:                              ;   Parent Loop BB0_92 Depth=1
                                        ;     Parent Loop BB0_162 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_215
; %bb.167:                              ;   in Loop: Header=BB0_166 Depth=3
	ld	de, (iy + 8)
	ld	a, (iy + 11)
	ld	(iy + 4), de
	ld	(iy + 7), a
	ld	de, 0
	ld	(iy + 16), de
	ld	(iy + 19), d
	lea	iy, iy + 29
	ld	de, -29
	add	hl, de
	jr	.LBB0_166
	.local	.LBB0_168
.LBB0_168:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	a, e
	cp	a, 3
	jr	z, .LBB0_170
; %bb.169:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	a, e
	cp	a, 6
	ld	bc, 0
	ld	a, b
	ld	iyl, a
	jp	nz, .LBB0_216
	.local	.LBB0_170
.LBB0_170:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+43)
	ld	bc, -4225
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+46)
	ld	l, a
	push	ix
	ld	bc, -4228
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	iy, (__ZN12_GLOBAL__N_18selectedE)
	ld	hl, (iy + 6)
	ld	e, (iy + 9)
	ld	bc, -4189
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	ld	bc, -4219
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	ld	bc, 100
	ld	iyl, b
	ld	a, iyl
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	hl, (__ZN12_GLOBAL__N_16motionE+7)
	ld	a, (__ZN12_GLOBAL__N_16motionE+10)
	ld	e, a
	ld	bc, 6800
	xor	a, a
	call	__ladd
	ld	(ix - 3), de
	push	ix
	ld	de, -4213
	add	ix, de
	ld	(ix + 0), iy
	pop	ix
	lea	bc, iy + 0
	ld	de, (ix - 3)
	ld	(ix - 3), bc
	ld	bc, -4216
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), d                     ; 1-byte Folded Spill
	ld	a, d
	ld	bc, (ix - 3)
	call	__lcmps
	call	pe, __setflag
	ld	a, 1
	jp	m, .LBB0_172
; %bb.171:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	a, 0
	.local	.LBB0_172
.LBB0_172:                              ;   in Loop: Header=BB0_162 Depth=2
	bit	0, a
	ld	bc, 0
	jr	nz, .LBB0_174
; %bb.173:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	(ix - 3), de
	ld	de, -4213
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	ld	de, (ix - 3)
	.local	.LBB0_174
.LBB0_174:                              ;   in Loop: Header=BB0_162 Depth=2
	bit	0, a
	ld	a, 0
	jr	nz, .LBB0_176
; %bb.175:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	(ix - 3), bc
	ld	bc, -4216
	lea	iy, ix + 0
	add	iy, bc
	ld	a, (iy + 0)                     ; 1-byte Folded Reload
	ld	bc, (ix - 3)
	.local	.LBB0_176
.LBB0_176:                              ;   in Loop: Header=BB0_162 Depth=2
	call	__lsub
	ld	(ix - 3), bc
	ld	bc, -4231
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	ld	bc, -4234
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	lea	hl, iy + 0
	push	ix
	ld	bc, -4219
	add	ix, bc
	ld	d, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	e, d
	ld	bc, (ix - 3)
	ld	bc, 50
	xor	a, a
	call	__lmulu
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4237
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
	ld	bc, -50
	dec	a
	call	__lmulu
	ld	(ix - 3), bc
	ld	bc, -4241
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	dec	bc
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	push	ix
	ld	bc, -4213
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -4216
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	call	__lneg
	push	ix
	ld	bc, -4245
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	dec	bc
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	push	ix
	ld	bc, -4186
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -4219
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	iy, 0
	ld	bc, (ix - 3)
	.local	.LBB0_177
.LBB0_177:                              ;   Parent Loop BB0_92 Depth=1
                                        ;     Parent Loop BB0_162 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	lea	hl, iy + 0
	ld	de, 12
	or	a, a
	sbc	hl, de
	jp	z, .LBB0_193
; %bb.178:                              ;   in Loop: Header=BB0_177 Depth=3
	ld	bc, -4249
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	ld	bc, -4189
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	hl, (iy + 8)
	ld	e, (iy + 11)
	ld	(ix - 3), de
	ld	de, -4231
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -4234
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lsub
	push	hl
	pop	iy
	ld	a, e
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4237
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	dec	bc
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, (ix - 3)
	lea	bc, iy + 0
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4222
	add	ix, bc
	ld	(ix + 0), a                     ; 1-byte Folded Spill
	pop	ix
	ld	bc, (ix - 3)
	call	__lcmps
	call	pe, __setflag
	ld	d, 1
	jp	m, .LBB0_180
; %bb.179:                              ;   in Loop: Header=BB0_177 Depth=3
	ld	d, 0
	.local	.LBB0_180
.LBB0_180:                              ;   in Loop: Header=BB0_177 Depth=3
	lea	hl, iy + 0
	push	ix
	ld	bc, -4222
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	(ix - 3), de
	push	ix
	ld	de, -4241
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	dec	de
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lcmps
	call	pe, __setflag
	ld	a, 1
	jp	m, .LBB0_182
; %bb.181:                              ;   in Loop: Header=BB0_177 Depth=3
	ld	a, 0
	.local	.LBB0_182
.LBB0_182:                              ;   in Loop: Header=BB0_177 Depth=3
	bit	0, a
	ld	(ix - 3), de
	ld	de, -4213
	lea	hl, ix + 0
	push	af
	add	hl, de
	pop	af
	ld	bc, (hl)
	ld	l, 0
	ld	de, (ix - 3)
	jr	nz, .LBB0_184
; %bb.183:                              ;   in Loop: Header=BB0_177 Depth=3
	ld	bc, 0
	.local	.LBB0_184
.LBB0_184:                              ;   in Loop: Header=BB0_177 Depth=3
	bit	0, a
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4216
	push	af
	add	ix, bc
	pop	af
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, (ix - 3)
	jr	nz, .LBB0_186
; %bb.185:                              ;   in Loop: Header=BB0_177 Depth=3
	ld	a, l
	.local	.LBB0_186
.LBB0_186:                              ;   in Loop: Header=BB0_177 Depth=3
	bit	0, d
	ld	(ix - 3), bc
	ld	bc, -4245
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	hl, (hl)
	ld	bc, (ix - 3)
	jr	nz, .LBB0_188
; %bb.187:                              ;   in Loop: Header=BB0_177 Depth=3
	push	bc
	pop	hl
	.local	.LBB0_188
.LBB0_188:                              ;   in Loop: Header=BB0_177 Depth=3
	bit	0, d
	push	ix
	ld	bc, -4246
	push	af
	add	ix, bc
	pop	af
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	jr	nz, .LBB0_190
; %bb.189:                              ;   in Loop: Header=BB0_177 Depth=3
	ld	e, a
	.local	.LBB0_190
.LBB0_190:                              ;   in Loop: Header=BB0_177 Depth=3
	lea	bc, iy + 0
	ld	(ix - 3), bc
	ld	bc, -4222
	lea	iy, ix + 0
	add	iy, bc
	ld	a, (iy + 0)                     ; 1-byte Folded Reload
	ld	bc, (ix - 3)
	call	__ladd
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4219
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	ld	(iy), hl
	ld	(iy + 3), e
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	bit	0, (iy)
	ld.sis	hl, 0
	ld	bc, (ix - 3)
	ld	c, l
	ld	b, h
	jr	z, .LBB0_192
; %bb.191:                              ;   in Loop: Header=BB0_177 Depth=3
	ld	bc, (iy + 1)
	.local	.LBB0_192
.LBB0_192:                              ;   in Loop: Header=BB0_177 Depth=3
	ld	de, -4249
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	pop	de
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	bc, -4195
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	add	iy, de
	ld	bc, (ix - 3)
	ld	(iy), c
	ld	(iy + 1), b
	ld	de, 2
	add	hl, de
	ld	bc, -4189
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	lea	iy, iy + 29
	push	ix
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	bc, -4219
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	lea	iy, iy + 4
	push	ix
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	push	hl
	pop	iy
	jp	.LBB0_177
	.local	.LBB0_193
.LBB0_193:                              ;   in Loop: Header=BB0_162 Depth=2
	xor	a, a
	ld	(__ZN12_GLOBAL__N_16motionE+30), a
	ld.sis	hl, 0
	ld	iy, __ZN12_GLOBAL__N_16motionE+25
	ld	(iy), l
	ld	(iy + 1), h
	ld	bc, -4228
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -4225
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
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
	ld	de, -4222
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), a                         ; 1-byte Folded Spill
	bit	0, a
	ld	bc, 0
	ld	a, b
	ld	l, a
	jr	nz, .LBB0_199
; %bb.194:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	a, (__ZN12_GLOBAL__N_18heldKeysE+7)
	ld	l, a
	ld	a, (__ZN12_GLOBAL__N_18heldKeysE+5)
	bit	1, a
	ld	de, -1
	jr	nz, .LBB0_196
; %bb.195:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	de, 0
	.local	.LBB0_196
.LBB0_196:                              ;   in Loop: Header=BB0_162 Depth=2
	push	de
	bit	1, l
	ld	hl, -1
	jr	nz, .LBB0_198
; %bb.197:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	hl, 0
	.local	.LBB0_198
.LBB0_198:                              ;   in Loop: Header=BB0_162 Depth=2
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16motionE
	push	hl
	call	__ZN5rally6Motion4tickEbb
	pop	hl
	pop	hl
	pop	hl
	ld	bc, (__ZN12_GLOBAL__N_16motionE+11)
	ld	a, (__ZN12_GLOBAL__N_16motionE+14)
	ld	l, 1
	call	__lshl
	ld	l, a
	.local	.LBB0_199
.LBB0_199:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	de, -4189
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	cp	a, 6
	jp	nz, .LBB0_214
; %bb.200:                              ;   in Loop: Header=BB0_162 Depth=2
	push	bc
	pop	hl
	ld	(ix - 3), bc
	ld	bc, -4189
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
                                        ; kill: def $e killed $e killed $ude
	ld	bc, (ix - 3)
	ld	(ix - 3), de
	push	ix
	ld	de, -4219
	add	ix, de
	ld	(ix + 0), bc
	pop	ix
	push	ix
	ld	de, -4225
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -4228
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	a, iyl
	ld	de, (ix - 3)
	call	__ladd
	ld	(ix - 3), bc
	ld	bc, -4225
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
                                        ; kill: def $e killed $e def $ude
	push	ix
	ld	bc, -4228
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	push	ix
	ld	bc, -4219
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
                                        ; kill: def $e killed $e killed $ude
	ld	bc, (ix - 3)
	ld	(ix - 3), de
	push	ix
	ld	de, -4231
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -4234
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__ladd
	ld	(ix - 3), de
	push	ix
	ld	de, -4213
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -4216
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lcmps
	call	pe, __setflag
	ld	a, 1
	jp	m, .LBB0_202
; %bb.201:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	a, 0
	.local	.LBB0_202
.LBB0_202:                              ;   in Loop: Header=BB0_162 Depth=2
	bit	0, a
	ld	bc, 0
	jr	nz, .LBB0_204
; %bb.203:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	(ix - 3), de
	ld	de, -4213
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	ld	de, (ix - 3)
	.local	.LBB0_204
.LBB0_204:                              ;   in Loop: Header=BB0_162 Depth=2
	bit	0, a
	ld	a, 0
	jr	nz, .LBB0_206
; %bb.205:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	(ix - 3), bc
	ld	bc, -4216
	lea	iy, ix + 0
	add	iy, bc
	ld	a, (iy + 0)                     ; 1-byte Folded Reload
	ld	bc, (ix - 3)
	.local	.LBB0_206
.LBB0_206:                              ;   in Loop: Header=BB0_162 Depth=2
	call	__lsub
	ld	(ix - 3), bc
	ld	bc, -4231
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
                                        ; kill: def $e killed $e def $ude
	push	ix
	ld	bc, -4234
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+15)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+18)
	ld	e, a
	ld	bc, (ix - 3)
	ld	bc, 1
	xor	a, a
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	ld	de, -4228
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -4225
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	call	__ZN5rally4game11RaceTraffic4tickEmm
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4222
	lea	hl, ix + 0
	add	hl, bc
	ld	a, (hl)                         ; 1-byte Folded Reload
	bit	0, a
	jp	nz, .LBB0_210
; %bb.207:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	hl, __ZN12_GLOBAL__N_15crashE+2
	ld	hl, (hl)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB0_210
; %bb.208:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	hl, (__ZN12_GLOBAL__N_16motionE+15)
	ld	a, (__ZN12_GLOBAL__N_16motionE+18)
	ld	e, a
	push	de
	push	hl
	ld	bc, -4234
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -4231
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	call	__ZNK5rally4game11RaceTraffic14contactStationEll
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	bit	0, a
	ld	bc, -4222
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	a, (hl)                         ; 1-byte Folded Reload
	jr	z, .LBB0_210
; %bb.209:                              ;   in Loop: Header=BB0_162 Depth=2
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
	ld	bc, -4222
	lea	hl, ix + 0
	add	hl, bc
	ld	a, (hl)                         ; 1-byte Folded Reload
	.local	.LBB0_210
.LBB0_210:                              ;   in Loop: Header=BB0_162 Depth=2
	bit	0, a
	jp	nz, .LBB0_212
; %bb.211:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	hl, __ZN12_GLOBAL__N_15crashE
	ld	hl, (hl)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	z, .LBB0_220
	.local	.LBB0_212
.LBB0_212:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	or	a, a
	ld	de, -4219
	lea	hl, ix + 0
	push	af
	add	hl, de
	pop	af
	ld	bc, (hl)
	jr	nz, .LBB0_214
; %bb.213:                              ;   in Loop: Header=BB0_162 Depth=2
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	ld	bc, -4228
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -4225
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	call	__ZNK5rally4game11RaceTraffic4rankEmm
	ld	de, -4219
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	(__ZN12_GLOBAL__N_15rulesE+61), a
	.local	.LBB0_214
.LBB0_214:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	jr	.LBB0_216
	.local	.LBB0_215
.LBB0_215:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	bc, 0
	xor	a, a
	ld	iyl, a
	.local	.LBB0_216
.LBB0_216:                              ;   in Loop: Header=BB0_162 Depth=2
	push	iy
	push	bc
	ld	hl, __ZN12_GLOBAL__N_15rulesE
	push	hl
	call	__ZN5rally4game5Rules4tickEm
	pop	hl
	pop	hl
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	e, a
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	ld	l, a
	ld	a, e
	cp	a, 7
	jr	nz, .LBB0_219
; %bb.217:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	a, l
	or	a, a
	jr	nz, .LBB0_219
; %bb.218:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	iy, (__ZN12_GLOBAL__N_15rulesE+43)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+46)
	ld	e, a
	ld	bc, (__ZN12_GLOBAL__N_15rulesE+15)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+18)
	ld	l, a
	push	hl
	push	bc
	push	de
	push	iy
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	call	__ZNK5rally4game11RaceTraffic4rankEmm
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	(__ZN12_GLOBAL__N_15rulesE+61), a
	.local	.LBB0_219
.LBB0_219:                              ;   in Loop: Header=BB0_162 Depth=2
	call	__ZN12_GLOBAL__N_112phaseChangedEv
	ld	hl, (__ZN12_GLOBAL__N_16motionE+7)
	ld	a, (__ZN12_GLOBAL__N_16motionE+10)
	ld	e, a
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_17trafficE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	call	__ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -4210
	lea	iy, ix + 0
	add	iy, bc
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	ld	bc, 1
	xor	a, a
	call	__ladd
	jp	.LBB0_162
	.local	.LBB0_220
.LBB0_220:                              ;   in Loop: Header=BB0_162 Depth=2
	ld	bc, (__ZN12_GLOBAL__N_15rulesE+39)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+42)
	ld	iy, 0
	lea	de, iy + 0
	ld	(ix - 3), bc
	ld	bc, -4186
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -4249
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	pop	iy
	ex	de, hl
	.local	.LBB0_221
.LBB0_221:                              ;   Parent Loop BB0_92 Depth=1
                                        ;     Parent Loop BB0_162 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ld	bc, (ix - 3)
	push	ix
	ld	de, -4222
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, 12
	or	a, a
	sbc	hl, de
	jp	z, .LBB0_212
; %bb.222:                              ;   in Loop: Header=BB0_221 Depth=3
	bit	0, (iy)
	jp	z, .LBB0_245
; %bb.223:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	(ix - 3), bc
	ld	bc, -4222
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	push	ix
	ld	bc, -4195
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	add	hl, de
	ld	hl, (hl)
	ld	de, (iy + 1)
                                        ; kill: def $hl killed $hl killed $uhl
	or	a, a
	sbc.sis	hl, de
	ld	bc, (ix - 3)
	jp	nz, .LBB0_245
; %bb.224:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	de, -4253
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), a                         ; 1-byte Folded Spill
	push	ix
	ld	de, -4264
	add	ix, de
	ld	(ix + 0), bc
	pop	ix
	lea	bc, iy + 0
	ld	de, -4249
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	lea	hl, iy + 0
	ld	hl, (hl)
	push	ix
	ld	de, -4256
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	a, (iy + 3)
	dec	de
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), a
	push	bc
	pop	iy
	ld	hl, (iy + 8)
	push	ix
	ld	bc, -4252
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	e, (iy + 11)
	ld	(ix - 3), de
	ld	de, -4231
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -4234
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	a, iyl
	ld	de, (ix - 3)
	call	__lsub
	push	hl
	pop	bc
	ld	a, e
	ld	(ix - 3), bc
	ld	bc, -4237
	lea	iy, ix + 0
	add	iy, bc
	ld	hl, (iy + 0)
	push	ix
	dec	bc
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, (ix - 3)
	call	__lcmps
	call	pe, __setflag
	ld	d, 1
	jp	m, .LBB0_226
; %bb.225:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	d, 0
	.local	.LBB0_226
.LBB0_226:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	(ix - 3), de
	ld	de, -4260
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	push	bc
	pop	hl
	ld	bc, -4261
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), a                     ; 1-byte Folded Spill
	ld	de, (ix - 3)
	ld	e, a
	ld	(ix - 3), de
	push	ix
	ld	de, -4241
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	dec	de
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lcmps
	call	pe, __setflag
	ld	a, 1
	jp	m, .LBB0_228
; %bb.227:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	a, 0
	.local	.LBB0_228
.LBB0_228:                              ;   in Loop: Header=BB0_221 Depth=3
	bit	0, a
	ld	(ix - 3), de
	ld	de, -4213
	lea	hl, ix + 0
	push	af
	add	hl, de
	pop	af
	ld	bc, (hl)
	ld	l, 0
	ld	de, -4252
	lea	iy, ix + 0
	push	af
	add	iy, de
	pop	af
	ld	iy, (iy + 0)
	ld	de, (ix - 3)
	jr	nz, .LBB0_230
; %bb.229:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	bc, 0
	.local	.LBB0_230
.LBB0_230:                              ;   in Loop: Header=BB0_221 Depth=3
	bit	0, a
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4216
	push	af
	add	ix, bc
	pop	af
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, (ix - 3)
	jr	nz, .LBB0_232
; %bb.231:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	a, l
	.local	.LBB0_232
.LBB0_232:                              ;   in Loop: Header=BB0_221 Depth=3
	bit	0, d
	ld	(ix - 3), bc
	ld	bc, -4245
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	hl, (hl)
	ld	bc, (ix - 3)
	jr	nz, .LBB0_234
; %bb.233:                              ;   in Loop: Header=BB0_221 Depth=3
	push	bc
	pop	hl
	.local	.LBB0_234
.LBB0_234:                              ;   in Loop: Header=BB0_221 Depth=3
	bit	0, d
	push	ix
	ld	bc, -4246
	push	af
	add	ix, bc
	pop	af
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	jr	nz, .LBB0_236
; %bb.235:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	e, a
	.local	.LBB0_236
.LBB0_236:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	(ix - 3), de
	push	ix
	ld	de, -4260
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	dec	de
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__ladd
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4260
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	d, e
	or	a, a
	sbc	hl, hl
	ld	e, h
	ld	bc, (ix - 3)
	ld	(ix - 3), de
	push	ix
	ld	de, -4256
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	dec	de
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB0_244
; %bb.237:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	(ix - 3), bc
	ld	bc, -4261
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), d                         ; 1-byte Folded Spill
	push	ix
	ld	bc, -4219
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
                                        ; kill: def $e killed $e killed $ude
	ld	bc, (ix - 3)
	call	__lcmpu
	jp	c, .LBB0_244
; %bb.238:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	bc, -4260
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	ix
	dec	bc
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, 1
	ld	d, b
	ld	a, d
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB0_244
; %bb.239:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	bc, -4264
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	lea	hl, iy + 0
	push	ix
	ld	bc, -4253
	add	ix, bc
	ld	e, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	bc, 6777316
	ld	a, -1
	call	__ladd
	ld	bc, 100
	ld	a, d
	call	__lcmpu
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	d, a
	inc	d
	lea	hl, iy + 0
	ld	(ix - 3), bc
	ld	bc, -4253
	lea	iy, ix + 0
	add	iy, bc
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	xor	a, a
	ld	bc, (ix - 3)
	call	__ladd
	bit	0, d
	ld	bc, -6777217
	jr	nz, .LBB0_241
; %bb.240:                              ;   in Loop: Header=BB0_221 Depth=3
	push	hl
	pop	bc
	.local	.LBB0_241
.LBB0_241:                              ;   in Loop: Header=BB0_221 Depth=3
	bit	0, d
	ld	a, 0
	jr	nz, .LBB0_243
; %bb.242:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	a, e
	.local	.LBB0_243
.LBB0_243:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	(__ZN12_GLOBAL__N_15rulesE+39), bc
	ld	(__ZN12_GLOBAL__N_15rulesE+42), a
	ld	de, -4252
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	jr	.LBB0_245
	.local	.LBB0_244
.LBB0_244:                              ;   in Loop: Header=BB0_221 Depth=3
	ld	de, -4264
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	push	ix
	ld	de, -4253
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	.local	.LBB0_245
.LBB0_245:                              ;   in Loop: Header=BB0_221 Depth=3
	lea	iy, iy + 29
	lea	hl, iy + 0
	ld	de, -4249
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	lea	iy, iy + 4
	push	ix
	add	ix, de
	ld	(ix + 0), iy
	pop	ix
	push	hl
	pop	iy
	ld	de, 2
	ld	(ix - 3), bc
	ld	bc, -4222
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	add	hl, de
	jp	.LBB0_221
	.local	.LBB0_246
.LBB0_246:                              ;   in Loop: Header=BB0_92 Depth=1
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
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_15sceneE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_114sceneryHistoryE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_14roadE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_17trafficE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16motionE
	push	hl
	call	__ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	ld	hl, __ZN12_GLOBAL__N_14roadE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16motionE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_110billboardsE
	push	hl
	call	__ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_
	pop	hl
	pop	hl
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	l, a
	or	a, a
	ld	de, 0
	jr	z, .LBB0_249
; %bb.247:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	cp	a, 6
	jr	z, .LBB0_249
; %bb.248:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	(__ZN12_GLOBAL__N_15sceneE+23), de
	.local	.LBB0_249
.LBB0_249:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	cp	a, 3
	ld	e, -1
	jr	nz, .LBB0_251
; %bb.250:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	e, 0
	.local	.LBB0_251
.LBB0_251:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	cp	a, 6
	ld	l, -1
	jr	nz, .LBB0_253
; %bb.252:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	l, 0
	.local	.LBB0_253
.LBB0_253:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, e
	and	a, l
	bit	0, a
	ld	hl, 88
	ld	bc, -4183
	lea	iy, ix + 0
	push	af
	add	iy, bc
	pop	af
	ld	(iy + 0), hl
	jr	nz, .LBB0_255
; %bb.254:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 24
	ld	bc, -4183
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	.local	.LBB0_255
.LBB0_255:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_15sceneE)
	ld	bc, -4177
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	scf
	sbc	hl, hl
	push	hl
	ld	hl, 1
	push	hl
	call	_vdp_adv_use_affine_matrix
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_15sceneE+3)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_259
; %bb.256:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 103
	push	hl
	ld	hl, 319
	push	hl
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game11skyViewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	bc, (__ZN12_GLOBAL__N_15sceneE+3)
	push	bc
	pop	hl
	ld	de, 1
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB0_258
; %bb.257:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, 0
	.local	.LBB0_258
.LBB0_258:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	(ix - 3), bc
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ld	bc, (ix - 3)
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
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	hl, 2
	push	hl
	call	_vdp_scroll_screen_extent
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB0_259
.LBB0_259:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 100
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15sceneE+12)
	bit	0, a
	jp	z, .LBB0_263
; %bb.260:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_15sceneE+6)
	ld	de, (__ZN12_GLOBAL__N_15sceneE+9)
	ld	bc, 103
	push	bc
	push	de
	ld	bc, -4183
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally4game11skyViewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	hl, 1024
	ld	bc, -4177
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	or	a, a
	sbc	hl, de
	push	hl
	pop	de
	ld	hl, (__ZN12_GLOBAL__N_15sceneE+6)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB0_262
; %bb.261:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	call	__ineg
	ld	bc, -4183
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), de
	ld	de, 0
	push	de
	push	hl
	call	_vdp_draw_bitmap
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	pop	hl
	pop	hl
	.local	.LBB0_262
.LBB0_262:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_15sceneE+9)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	or	a, a
	sbc	hl, hl
	push	hl
	push	de
	call	p, _vdp_draw_bitmap
	pop	hl
	pop	hl
	.local	.LBB0_263
.LBB0_263:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15sceneE+12)
	bit	0, a
	ld	de, __ZN12_GLOBAL__N_16streamE
	jr	z, .LBB0_265
; %bb.264:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_15sceneE+3)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB0_267
	.local	.LBB0_265
.LBB0_265:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 103
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 88
	push	hl
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
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	call	__ineg
	ld	de, 0
	push	de
	push	hl
	call	_vdp_draw_bitmap
	ld	de, __ZN12_GLOBAL__N_16streamE
	pop	hl
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, 705
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	m, .LBB0_267
; %bb.266:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 1024
	ld	bc, -4177
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	or	a, a
	sbc	hl, de
	ld	de, 0
	push	de
	push	hl
	call	_vdp_draw_bitmap
	ld	de, __ZN12_GLOBAL__N_16streamE
	pop	hl
	pop	hl
	.local	.LBB0_267
.LBB0_267:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 239
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 104
	push	hl
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
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_14sendEPKhj
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_14roadE
	push	hl
	call	__ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_16motionE+7)
	ld	bc, -4177
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, (__ZN12_GLOBAL__N_16motionE+10)
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	ld	iy, (__ZN12_GLOBAL__N_18selectedE)
	ld	hl, (iy + 6)
	ld	e, (iy + 9)
	ld	bc, 100
	xor	a, a
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	(ix - 3), de
	push	ix
	ld	de, -4177
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	push	ix
	ld	de, -4183
	add	ix, de
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	de, (ix - 3)
	call	__lsub
	lea	bc, iy + 0
	ld	a, d
	call	__lrems
	push	hl
	pop	iy
	ld	d, e
	ld	bc, -100100
	ld	a, -1
	call	__ladd
	ld	bc, -93700
	call	__lcmpu
	jp	c, .LBB0_282
; %bb.268:                              ;   in Loop: Header=BB0_92 Depth=1
	lea	hl, iy + 0
	ld	e, d
	ld	bc, 100
	xor	a, a
	call	__ldivu
	push	hl
	pop	bc
	ld.sis	hl, 8000
                                        ; kill: def $bc killed $bc killed $ubc
	call	__sdivu
	ld	e, l
	ld	d, h
	ld	c, 4
	call	__sshru
	ld	bc, 0
	ld	c, l
	ld	b, h
	ld	(ix - 3), de
	ld	de, -4177
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	push	bc
	pop	hl
	ld	bc, 2
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	ld	de, (ix - 3)
	jp	p, .LBB0_270
; %bb.269:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 1
	ld	bc, -4177
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	.local	.LBB0_270
.LBB0_270:                              ;   in Loop: Header=BB0_92 Depth=1
	or	a, a
	sbc	hl, hl
	ld	l, e
	ld	h, d
	ld	bc, -4189
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	iy, 0
	.local	.LBB0_271
.LBB0_271:                              ;   Parent Loop BB0_92 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB0_276 Depth 3
	lea	hl, iy + 0
	ld	de, 2
	or	a, a
	sbc	hl, de
	jp	z, .LBB0_281
; %bb.272:                              ;   in Loop: Header=BB0_271 Depth=2
	lea	hl, iy + 0
	push	ix
	ld	de, -4177
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	call	__imulu
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4189
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
	add	hl, de
	push	ix
	ld	bc, -4183
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	push	hl
	pop	iy
	ld	de, 96
	add	iy, de
	push	ix
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
	push	ix
	ld	bc, -4210
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	de, 128
	or	a, a
	sbc	hl, de
	ld	bc, (ix - 3)
	jp	nc, .LBB0_281
; %bb.273:                              ;   in Loop: Header=BB0_271 Depth=2
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	push	iy
	ld	hl, __ZN12_GLOBAL__N_14roadE
	push	hl
	call	__ZNK5rally10DirectRoad8centerAtEi
	push	hl
	pop	de
	pop	hl
	pop	hl
	ld	bc, -4210
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
                                        ; kill: def $hl killed $hl killed $uhl
	ld.sis	bc, 90
	call	__smulu
	ld.sis	bc, 50
	call	__sdivu
	ld	bc, 0
	ld	c, l
	ld	b, h
	ex	de, hl
	or	a, a
	sbc	hl, bc
	ld	de, -4210
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	push	bc
	pop	hl
	ld	c, 1
	call	__ishl
	push	ix
	ld	de, -4213
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	de, -4192
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4177
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
	add	iy, de
	lea	hl, iy + 0
	ld	de, 224
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	ld	bc, (ix - 3)
	jp	m, .LBB0_275
; %bb.274:                              ;   in Loop: Header=BB0_271 Depth=2
	ld	iy, 224
	.local	.LBB0_275
.LBB0_275:                              ;   in Loop: Header=BB0_271 Depth=2
	ld	bc, -4210
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	dec	hl
	push	ix
	ld	bc, -4219
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	dec	iy
	ld	bc, -4216
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	ld	iy, 0
	lea	de, iy + 0
	.local	.LBB0_276
.LBB0_276:                              ;   Parent Loop BB0_92 Depth=1
                                        ;     Parent Loop BB0_271 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	push	de
	pop	hl
	ld	bc, 12
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_280
; %bb.277:                              ;   in Loop: Header=BB0_276 Depth=3
	push	de
	pop	hl
	ld	bc, -4213
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	lea	bc, iy + 0
	call	__imulu
	ld	bc, 12
	call	__idivu
	ld	(ix - 3), de
	push	ix
	ld	de, -4210
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	add	hl, bc
	push	ix
	ld	bc, -4225
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	de, (ix - 3)
	push	de
	pop	hl
	inc	hl
	push	ix
	ld	bc, -4222
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	lea	bc, iy + 0
	call	__imulu
	ld	bc, 12
	call	__idivu
	push	hl
	pop	bc
	ld	(ix - 3), de
	ld	de, -4219
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	add	iy, bc
	push	ix
	ld	bc, -4183
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	ld	de, (ix - 3)
	add	hl, de
	ld	bc, 1
	call	__iand
	bit	0, l
	ld	hl, 0
	jr	z, .LBB0_279
; %bb.278:                              ;   in Loop: Header=BB0_276 Depth=3
	ld	hl, 15
	.local	.LBB0_279
.LBB0_279:                              ;   in Loop: Header=BB0_276 Depth=3
	push	hl
	ld	bc, -4216
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	push	iy
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -4225
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
	ld	bc, -4222
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	jp	.LBB0_276
	.local	.LBB0_280
.LBB0_280:                              ;   in Loop: Header=BB0_271 Depth=2
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	inc	iy
	jp	.LBB0_271
	.local	.LBB0_281
.LBB0_281:                              ;   in Loop: Header=BB0_92 Depth=1
	call	__ZN12_GLOBAL__N_15flushEv
	.local	.LBB0_282
.LBB0_282:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	cp	a, 3
	ld	l, -1
	jr	nz, .LBB0_284
; %bb.283:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	l, 0
	.local	.LBB0_284
.LBB0_284:                              ;   in Loop: Header=BB0_92 Depth=1
	cp	a, 6
	ld	e, -1
	ld	bc, 0
	ld	iy, __ZN12_GLOBAL__N_16streamE
	jr	nz, .LBB0_286
; %bb.285:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	e, 0
	.local	.LBB0_286
.LBB0_286:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	and	a, e
	bit	0, a
	ld	hl, 88
	jr	nz, .LBB0_288
; %bb.287:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 24
	.local	.LBB0_288
.LBB0_288:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, 223
	push	de
	ld	de, 319
	push	de
	push	hl
	push	bc
	push	iy
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	de, 0
	push	de
	pop	hl
	.local	.LBB0_289
.LBB0_289:                              ;   Parent Loop BB0_92 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB0_290 Depth 3
	ld	bc, -4189
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	bc, 12
	call	__imulu
	push	hl
	pop	bc
	ld	hl, __ZN12_GLOBAL__N_110billboardsE
	add	hl, bc
	push	ix
	ld	bc, -4210
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	ex	de, hl
	ld	bc, 22
	call	__imulu
	push	hl
	pop	de
	ld	hl, __ZN12_GLOBAL__N_15sceneE+26
	push	hl
	pop	iy
	add	iy, de
	.local	.LBB0_290
.LBB0_290:                              ;   Parent Loop BB0_92 Depth=1
                                        ;     Parent Loop BB0_289 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ld	de, (__ZN12_GLOBAL__N_15sceneE+23)
	ld	bc, (__ZN12_GLOBAL__N_110billboardsE+24)
	ld	(ix - 3), bc
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	ld	bc, (ix - 3)
	jr	c, .LBB0_292
; %bb.291:                              ;   in Loop: Header=BB0_290 Depth=3
	ld	(ix - 3), de
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	or	a, a
	sbc	hl, bc
	ld	de, (ix - 3)
	jp	nc, .LBB0_304
	.local	.LBB0_292
.LBB0_292:                              ;   in Loop: Header=BB0_290 Depth=3
	ld	(ix - 3), de
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	or	a, a
	sbc	hl, bc
	ld	de, (ix - 3)
	jr	nc, .LBB0_295
; %bb.293:                              ;   in Loop: Header=BB0_290 Depth=3
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	jp	z, .LBB0_297
; %bb.294:                              ;   in Loop: Header=BB0_290 Depth=3
	lea	hl, iy + 0
	ld	de, -4210
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	ld	bc, (iy + 6)
	push	hl
	pop	iy
	ld	de, (iy + 6)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	ld	bc, -4183
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	hl, (hl)
	call	pe, __setflag
	jp	m, .LBB0_296
	jp	.LBB0_297
	.local	.LBB0_295
.LBB0_295:                              ;   in Loop: Header=BB0_290 Depth=3
	ld	de, (iy + 6)
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	.local	.LBB0_296
.LBB0_296:                              ;   in Loop: Header=BB0_290 Depth=3
	push	ix
	ld	bc, -4177
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	inc	hl
	ld	bc, -4183
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy + 3)
	ld	bc, -4192
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	bc, (iy + 9)
	ld	(ix - 3), bc
	ld	bc, -4177
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	hl, (iy + 12)
	push	hl
	push	de
	ld	bc, (ix - 3)
	push	bc
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_113trafficMatrixEjiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy + 3)
	push	hl
	ld	hl, 1
	push	hl
	call	_vdp_adv_use_affine_matrix
	pop	hl
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy + 15)
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	de, (iy + 18)
	push	de
	push	hl
	call	_vdp_draw_bitmap
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	pop	hl
	pop	hl
	lea	iy, iy + 22
	jp	.LBB0_290
	.local	.LBB0_297
.LBB0_297:                              ;   in Loop: Header=BB0_289 Depth=2
	ld	de, -4189
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	bc, 12
	call	__imulu
	push	hl
	pop	de
	ld	hl, __ZN12_GLOBAL__N_110billboardsE
	add	hl, de
	ld	de, -4177
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	hl, 223
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
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy + 6)
	ld	de, 0
	push	de
	push	hl
	push	hl
	ld	hl, 63930
	push	hl
	call	__ZN12_GLOBAL__N_113trafficMatrixEjiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy + 9)
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	hl, -1606
	push	hl
	ld	hl, 1
	push	hl
	call	_vdp_adv_use_affine_matrix
	pop	hl
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy)
	ld	de, (iy + 3)
	push	de
	push	hl
	call	_vdp_draw_bitmap
	pop	hl
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	cp	a, 3
	ld	l, -1
	jr	nz, .LBB0_299
; %bb.298:                              ;   in Loop: Header=BB0_289 Depth=2
	ld	l, 0
	.local	.LBB0_299
.LBB0_299:                              ;   in Loop: Header=BB0_289 Depth=2
	cp	a, 6
	ld	e, -1
	jr	nz, .LBB0_301
; %bb.300:                              ;   in Loop: Header=BB0_289 Depth=2
	ld	e, 0
	.local	.LBB0_301
.LBB0_301:                              ;   in Loop: Header=BB0_289 Depth=2
	ld	a, l
	and	a, e
	bit	0, a
	ld	hl, 88
	ld	de, 0
	ld	bc, __ZN12_GLOBAL__N_16streamE
	push	bc
	pop	iy
	jr	nz, .LBB0_303
; %bb.302:                              ;   in Loop: Header=BB0_289 Depth=2
	ld	hl, 24
	.local	.LBB0_303
.LBB0_303:                              ;   in Loop: Header=BB0_289 Depth=2
	ld	(ix - 3), de
	push	ix
	ld	de, -4189
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	inc	bc
	push	ix
	add	ix, de
	ld	(ix + 0), bc
	pop	ix
	ld	bc, 223
	push	bc
	ld	bc, 319
	push	bc
	push	hl
	ld	de, (ix - 3)
	push	de
	push	iy
	call	__ZN5rally4game8viewportERNS_6StreamEiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -4183
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	jp	.LBB0_289
	.local	.LBB0_304
.LBB0_304:                              ;   in Loop: Header=BB0_92 Depth=1
	scf
	sbc	hl, hl
	push	hl
	ld	hl, 1
	push	hl
	call	_vdp_adv_use_affine_matrix
	pop	hl
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_15crashE
	ld	bc, (hl)
	ld	l, c
	ld	h, b
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	nz, .LBB0_310
; %bb.305:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, __ZN12_GLOBAL__N_15crashE+2
	ld	hl, (hl)
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	z, .LBB0_307
; %bb.306:                              ;   in Loop: Header=BB0_92 Depth=1
                                        ; kill: def $hl killed $hl killed $uhl
	ld.sis	bc, 10
	call	__sdivu
	ld.sis	bc, 1
	call	__sand
	bit	0, l
	jp	nz, .LBB0_323
	.local	.LBB0_307
.LBB0_307:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_15sceneE+13)
	push	hl
	call	_vdp_select_bitmap
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15sceneE+22)
	bit	0, a
	ld.sis	hl, -1
                                        ; kill: def $hl killed $hl def $uhl
	jp	z, .LBB0_309
; %bb.308:                              ;   in Loop: Header=BB0_92 Depth=1
	ld.sis	hl, -1552
                                        ; kill: def $hl killed $hl def $uhl
	.local	.LBB0_309
.LBB0_309:                              ;   in Loop: Header=BB0_92 Depth=1
	push	hl
	ld	hl, 1
	push	hl
	call	_vdp_adv_use_affine_matrix
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_15sceneE+16)
	ld	de, 154
	push	de
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
	jp	.LBB0_323
	.local	.LBB0_310
.LBB0_310:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, 0
	ld	e, c
	ld	d, b
	ld	hl, 150
	or	a, a
	sbc	hl, de
	push	hl
	pop	iy
	ld	hl, (__ZN12_GLOBAL__N_15sceneE+19)
	ld	(ix - 3), de
	push	ix
	ld	de, -4192
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	l, c
	ld	h, b
	ld.sis	bc, 91
	or	a, a
	sbc.sis	hl, bc
	ld	bc, -4177
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	(hl), iy
	ld	de, (ix - 3)
	jr	c, .LBB0_312
; %bb.311:                              ;   in Loop: Header=BB0_92 Depth=1
	lea	hl, iy + 0
	ld	de, 3
	push	de
	pop	bc
	call	__idivs
	push	hl
	pop	iy
	jr	.LBB0_313
	.local	.LBB0_312
.LBB0_312:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 90
	or	a, a
	sbc	hl, de
	ld	bc, -5
	call	__idivs
	push	hl
	pop	iy
	ld	de, 20
	add	iy, de
	.local	.LBB0_313
.LBB0_313:                              ;   in Loop: Header=BB0_92 Depth=1
	lea	hl, iy + 0
	ld	bc, -3
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	p, .LBB0_315
; %bb.314:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	iy, -4
	.local	.LBB0_315
.LBB0_315:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, 8
	add	iy, bc
	ld	de, -4210
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	ld	(ix - 3), bc
	ld	bc, -4177
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	pop	hl
	ld	bc, (ix - 3)
	call	__idivs
	ld	(ix - 3), bc
	push	ix
	ld	bc, -4222
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ex	de, hl
	ld	bc, (ix - 3)
	ld	bc, 6
	call	__idivs
	push	hl
	pop	bc
	ld	hl, ___const._ZN12_GLOBAL__N_110drawPlayerEv.dx
	push	hl
	pop	iy
	ld	hl, ___const._ZN12_GLOBAL__N_110drawPlayerEv.dy
	push	ix
	ld	de, -4183
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -4213
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	or	a, a
	sbc	hl, hl
	push	ix
	ld	de, -4177
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	.local	.LBB0_316
.LBB0_316:                              ;   Parent Loop BB0_92 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	de, 3
	ld	(ix - 3), de
	ld	de, -4216
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	push	bc
	pop	hl
	ld	de, (ix - 3)
	push	de
	pop	bc
	call	__idivu
	call	__imulu
	ld	(ix - 3), de
	push	ix
	ld	de, -4213
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	or	a, a
	sbc	hl, bc
	push	ix
	ld	de, -4219
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	de, -4177
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	ld	bc, 8
	or	a, a
	sbc	hl, bc
	ld	de, (ix - 3)
	jp	z, .LBB0_322
; %bb.317:                              ;   in Loop: Header=BB0_316 Depth=2
	ld	bc, -4225
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	ld	hl, (iy)
	ld	(ix - 3), de
	ld	de, -4210
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	call	__imulu
	ld	iy, 10
	lea	bc, iy + 0
	call	__idivs
	push	ix
	ld	de, -4192
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	add	hl, bc
	push	ix
	ld	de, -4189
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -4183
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	hl, (hl)
	push	ix
	ld	de, -4210
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	call	__imulu
	lea	bc, iy + 0
	call	__idivs
	push	hl
	pop	iy
	ld	bc, 193
	add	iy, bc
	push	ix
	ld	de, -4222
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	push	ix
	ld	de, -4177
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	add	hl, bc
	ld	bc, 6
	call	__irems
	ld	de, (ix - 3)
	add	hl, de
	push	hl
	pop	bc
	ld	(ix - 3), bc
	ld	bc, -4189
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
	ld	de, -4228
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	push	ix
	ld	de, -4231
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, (ix - 3)
	ex	de, hl
	add	hl, bc
	push	ix
	ld	de, -4189
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	add	iy, bc
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	push	de
	pop	hl
	ld	bc, 1
	call	__iand
	bit	0, l
	ld	bc, 9
	jr	z, .LBB0_319
; %bb.318:                              ;   in Loop: Header=BB0_316 Depth=2
	ld	bc, 11
	.local	.LBB0_319
.LBB0_319:                              ;   in Loop: Header=BB0_316 Depth=2
	ld	(ix - 3), bc
	ld	bc, -4219
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	ld	hl, 15
	ld	bc, (ix - 3)
	jr	z, .LBB0_321
; %bb.320:                              ;   in Loop: Header=BB0_316 Depth=2
	push	bc
	pop	hl
	.local	.LBB0_321
.LBB0_321:                              ;   in Loop: Header=BB0_316 Depth=2
	push	hl
	push	iy
	ld	bc, -4189
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -4231
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -4228
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
	ld	de, -4177
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	inc	hl
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	de, -4216
	lea	hl, ix + 0
	add	hl, de
	ld	bc, (hl)
	inc	bc
	push	ix
	ld	de, -4183
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	lea	iy, iy + 3
	push	ix
	add	ix, de
	ld	(ix + 0), iy
	pop	ix
	ld	de, -4225
	lea	iy, ix + 0
	add	iy, de
	ld	iy, (iy + 0)
	lea	iy, iy + 3
	jp	.LBB0_316
	.local	.LBB0_322
.LBB0_322:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, -4192
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	pop	iy
	ld	de, -6
	add	iy, de
	ld	de, 6
	add	hl, de
	ld	de, 15
	push	de
	ld	de, 199
	push	de
	push	hl
	ld	de, 187
	push	de
	push	iy
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
	.local	.LBB0_323
.LBB0_323:                              ;   in Loop: Header=BB0_92 Depth=1
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
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	d, a
	cp	a, 3
	jp	z, .LBB0_354
; %bb.324:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, d
	cp	a, 6
	jp	z, .LBB0_354
; %bb.325:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, (__ZN12_GLOBAL__N_15rulesE+11)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+14)
	ld	hl, 479
	ld	iyl, 0
	ld	e, iyl
	call	__lsub
	ld	bc, 120
	ld	a, iyl
	call	__ldivu
	ld	(ix - 3), de
	ld	de, -4177
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	hl, (__ZN12_GLOBAL__N_18selectedE)
	ld	bc, __ZN5rallyL4FujiE
	or	a, a
	sbc	hl, bc
	ld	hl, _.str.21
	ld	de, (ix - 3)
	jr	z, .LBB0_327
; %bb.326:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, _.str.22
	.local	.LBB0_327
.LBB0_327:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, -4183
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	ld	l, a
	ld	a, d
	cp	a, 2
	ld	e, -1
	jr	z, .LBB0_329
; %bb.328:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	e, 0
	.local	.LBB0_329
.LBB0_329:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, d
	cp	a, 5
	ld	h, -1
	jr	z, .LBB0_331
; %bb.330:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	h, 0
	.local	.LBB0_331
.LBB0_331:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	iy, 0
	lea	bc, iy + 0
	ld	c, d
	ex	de, hl
	ld	iyl, e
	ex	de, hl
	ld	a, e
	or	a, h
	bit	0, a
	ld	de, -4177
	lea	hl, ix + 0
	push	af
	add	hl, de
	pop	af
	ld	hl, (hl)
	jr	nz, .LBB0_333
; %bb.332:                              ;   in Loop: Header=BB0_92 Depth=1
	or	a, a
	sbc	hl, hl
	.local	.LBB0_333
.LBB0_333:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+60)
	ld	de, 0
	ld	e, a
	push	de
	push	hl
	push	iy
	ld	de, -4183
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	push	bc
	ld	hl, _.str.20
	push	hl
	ld	hl, 160
	push	hl
	ld	bc, -4186
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	ld	hl, 24
	add	hl, sp
	ld	sp, hl
	ld	hl, (__ZN12_GLOBAL__N_114sceneryHistoryE+8)
	ld	bc, 160
	call	__imulu
	push	hl
	pop	de
	ld	hl, __ZN12_GLOBAL__N_110panelCacheE
	add	hl, de
	ld	(ix - 3), bc
	ld	bc, -4186
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	ld	bc, (ix - 3)
	call	_strcmp
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_354
; %bb.334:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_114sceneryHistoryE+8)
	ld	bc, 160
	call	__imulu
	push	hl
	pop	de
	ld	hl, __ZN12_GLOBAL__N_110panelCacheE
	add	hl, de
	ld	(ix - 3), bc
	ld	bc, -4186
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	ld	bc, (ix - 3)
	call	_strcpy
	pop	hl
	pop	hl
	ld	hl, 20
	push	hl
	ld	hl, 87
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
	call	__ZN5rally6Stream4rectEiiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	call	__ZN12_GLOBAL__N_15flushEv
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	cp	a, 10
	jp	nc, .LBB0_354
; %bb.335:                              ;   in Loop: Header=BB0_92 Depth=1
	or	a, a
	sbc	hl, hl
	ex	de, hl
	ld	e, a
	ld	hl, JTI0_0
	add	hl, de
	add	hl, de
	add	hl, de
	ld	hl, (hl)
	jp	(hl)
	.local	.LBB0_336
.LBB0_336:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 63941
	push	hl
	call	__ZN12_GLOBAL__N_14fontEj
	pop	hl
	ld	hl, 20
	push	hl
	ld	hl, 11
	push	hl
	ld	hl, _.str.23
	push	hl
	ld	hl, 2
	push	hl
	ld	hl, 5
	push	hl
	call	__ZN12_GLOBAL__N_14textEiiPKcii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 63940
	push	hl
	call	__ZN12_GLOBAL__N_14fontEj
	pop	hl
	ld	hl, 15
	push	hl
	ld	hl, _.str.24
	push	hl
	ld	hl, 7
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 11
	push	hl
	ld	hl, _.str.25
	jp	.LBB0_346
	.local	.LBB0_337
.LBB0_337:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 11
	push	hl
	ld	hl, _.str.26
	push	hl
	ld	hl, 4
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_18selectedE)
	ld	de, __ZN5rallyL4FujiE
	or	a, a
	sbc	hl, de
	ld	hl, _.str.27
	jr	z, .LBB0_339
; %bb.338:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, _.str.28
	.local	.LBB0_339
.LBB0_339:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, 15
	push	de
	push	hl
	ld	hl, 6
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	or	a, a
	ld	hl, _.str.29
	jr	z, .LBB0_341
; %bb.340:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, _.str.30
	.local	.LBB0_341
.LBB0_341:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, 15
	push	de
	push	hl
	ld	hl, 8
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 11
	push	hl
	ld	hl, _.str.31
	jp	.LBB0_352
	.local	.LBB0_342
.LBB0_342:                              ;   in Loop: Header=BB0_92 Depth=1
	cp	a, 2
	ld	hl, _.str.32
	jr	z, .LBB0_344
; %bb.343:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, _.str.33
	.local	.LBB0_344
.LBB0_344:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, 11
	push	de
	push	hl
	ld	hl, 4
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.34
	push	hl
	ld	hl, 160
	push	hl
	ld	bc, -4186
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_snprintf
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 63941
	push	hl
	call	__ZN12_GLOBAL__N_14fontEj
	pop	hl
	ld	hl, 20
	push	hl
	ld	hl, 15
	push	hl
	ld	bc, -4186
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 3
	push	hl
	ld	hl, 9
	push	hl
	call	__ZN12_GLOBAL__N_14textEiiPKcii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 63940
	push	hl
	call	__ZN12_GLOBAL__N_14fontEj
	pop	hl
	ld	hl, 15
	push	hl
	ld	hl, _.str.35
	jp	.LBB0_352
	.local	.LBB0_345
.LBB0_345:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 11
	push	hl
	ld	hl, _.str.36
	push	hl
	ld	hl, 4
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+60)
	or	a, a
	sbc	hl, hl
	ld	l, a
	push	hl
	ld	hl, _.str.37
	push	hl
	ld	hl, 160
	push	hl
	ld	bc, -4186
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
	ld	bc, -4186
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 7
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 15
	push	hl
	ld	hl, _.str.38
	.local	.LBB0_346
.LBB0_346:                              ;   in Loop: Header=BB0_92 Depth=1
	push	hl
	ld	hl, 9
	jp	.LBB0_353
	.local	.LBB0_347
.LBB0_347:                              ;   in Loop: Header=BB0_92 Depth=1
	cp	a, 8
	ld	hl, _.str.40
	jr	z, .LBB0_349
; %bb.348:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, _.str.41
	.local	.LBB0_349
.LBB0_349:                              ;   in Loop: Header=BB0_92 Depth=1
	cp	a, 7
	ld	de, _.str.39
	jr	z, .LBB0_351
; %bb.350:                              ;   in Loop: Header=BB0_92 Depth=1
	ex	de, hl
	.local	.LBB0_351
.LBB0_351:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, 11
	push	hl
	push	de
	ld	hl, 4
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+31)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+34)
	ld	e, a
	push	de
	push	hl
	ld	bc, -4195
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_19clockTextEPcjm
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4195
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.42
	push	hl
	ld	hl, 160
	push	hl
	ld	bc, -4186
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
	ld	bc, -4186
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 6
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 15
	push	hl
	ld	hl, _.str.43
	push	hl
	ld	hl, 8
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	ld	hl, 14
	push	hl
	ld	hl, _.str.44
	.local	.LBB0_352
.LBB0_352:                              ;   in Loop: Header=BB0_92 Depth=1
	push	hl
	ld	hl, 10
	.local	.LBB0_353
.LBB0_353:                              ;   in Loop: Header=BB0_92 Depth=1
	push	hl
	call	__ZN12_GLOBAL__N_16centreEiPKci
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB0_354
.LBB0_354:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, -4186
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN5rally4game8HudImageC2Ev
	pop	hl
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	l, a
	cp	a, 3
	ld	c, 1
	jp	z, .LBB0_359
; %bb.355:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	cp	a, 6
	ld	c, 1
	jp	z, .LBB0_359
; %bb.356:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	add	a, -7
	ld	e, a
	ld	a, l
	cp	a, 4
	ld	l, -1
	jr	z, .LBB0_358
; %bb.357:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	l, 0
	.local	.LBB0_358
.LBB0_358:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, e
	cp	a, 3
                                        ; kill: def $a killed $a
	sbc	a, a
	ld	e, a
	ld	a, l
	or	a, e
	ld	c, a
	.local	.LBB0_359
.LBB0_359:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_18selectedE)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	ld	de, -4177
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), a                     ; 1-byte Folded Spill
	ld	a, (__ZN12_GLOBAL__N_112steeringStepE)
	bit	0, a
	ld	de, 1
	jr	nz, .LBB0_361
; %bb.360:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	de, 2
	.local	.LBB0_361
.LBB0_361:                              ;   in Loop: Header=BB0_92 Depth=1
	bit	0, c
	jr	nz, .LBB0_363
; %bb.362:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	iy, (__ZN12_GLOBAL__N_16motionE+27)
	jr	.LBB0_364
	.local	.LBB0_363
.LBB0_363:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	iy, (__ZN12_GLOBAL__N_15rulesE+62)
	.local	.LBB0_364
.LBB0_364:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, __ZN5rallyL4FujiE
	or	a, a
	sbc	hl, bc
	ld	hl, 2
	jr	z, .LBB0_366
; %bb.365:                              ;   in Loop: Header=BB0_92 Depth=1
	or	a, a
	sbc	hl, hl
	.local	.LBB0_366
.LBB0_366:                              ;   in Loop: Header=BB0_92 Depth=1
	push	ix
	ld	bc, -4177
	add	ix, bc
	ld	a, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	cp	a, 1
	ld	bc, 1
	jr	z, .LBB0_368
; %bb.367:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, 0
	.local	.LBB0_368
.LBB0_368:                              ;   in Loop: Header=BB0_92 Depth=1
	add	hl, bc
	ld	c, 1
	call	__ishl
	add	hl, de
	ld	bc, 36
	call	__imulu
	push	hl
	pop	de
	ld	bc, -25
	add	iy, bc
	lea	hl, iy + 0
	ld	bc, 5
	call	__idivs
	ld	bc, -36
	add	hl, bc
	add	hl, de
	ld	c, 3
	call	__ishl
	push	hl
	pop	de
	ld	iy, __ZN12_GLOBAL__N_17recordsE
	add	iy, de
	ld	hl, (iy)
	ld	e, (iy + 3)
	push	de
	push	hl
	ld	hl, _.str.46
	push	hl
	ld	hl, 48
	push	hl
	ld	de, -4195
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
	ld	bc, -4195
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	push	hl
	ld	bc, -4186
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
	ld	hl, _.str.47
	push	hl
	ld	hl, 48
	push	hl
	ld	de, -4195
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
	ld	bc, -4195
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 14
	push	hl
	ld	bc, -4186
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
	jr	z, .LBB0_370
; %bb.369:                              ;   in Loop: Header=BB0_92 Depth=1
	cp	a, 6
	jp	nz, .LBB0_371
	.local	.LBB0_370
.LBB0_370:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+15)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+18)
	ld	e, a
	ld	bc, (__ZN12_GLOBAL__N_15rulesE+23)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+26)
	call	__lsub
                                        ; kill: def $e killed $e def $ude
	jr	.LBB0_372
	.local	.LBB0_371
.LBB0_371:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+27)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+30)
	ld	e, a
	.local	.LBB0_372
.LBB0_372:                              ;   in Loop: Header=BB0_92 Depth=1
	push	de
	push	hl
	ld	bc, -4198
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	__ZN12_GLOBAL__N_19clockTextEPcjm
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4198
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, _.str.48
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -4195
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
	ld	bc, -4195
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 25
	push	hl
	ld	bc, -4186
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
	ld	hl, _.str.49
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -4195
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
	ld	bc, -4195
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 1
	push	hl
	dec	hl
	push	hl
	ld	bc, -4186
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
	ld	hl, _.str.50
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -4195
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
	ld	bc, -4195
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 1
	push	hl
	ld	hl, 16
	push	hl
	ld	bc, -4186
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
	jr	nz, .LBB0_375
; %bb.373:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	add	a, -6
	cp	a, 3
	jr	nc, .LBB0_375
; %bb.374:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+61)
	or	a, a
	sbc	hl, hl
	ld	l, a
	push	hl
	ld	hl, _.str.51
	push	hl
	ld	hl, 48
	push	hl
	ld	bc, -4195
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
	ld	bc, -4195
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 1
	push	hl
	ld	hl, 30
	push	hl
	ld	bc, -4186
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
	.local	.LBB0_375
.LBB0_375:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, (__ZN12_GLOBAL__N_114sceneryHistoryE+8)
	ld	bc, -4186
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
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	l, a
	or	a, a
	jr	nz, .LBB0_377
; %bb.376:                              ;   in Loop: Header=BB0_92 Depth=1
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 15
	push	hl
	ld	hl, _.str.52
	push	hl
	ld	hl, 28
	push	hl
	ld	hl, 2
	jr	.LBB0_379
	.local	.LBB0_377
.LBB0_377:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	cp	a, 3
	jp	nz, .LBB0_386
; %bb.378:                              ;   in Loop: Header=BB0_92 Depth=1
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 11
	push	hl
	ld	hl, _.str.53
	push	hl
	ld	hl, 28
	push	hl
	ld	hl, 1
	.local	.LBB0_379
.LBB0_379:                              ;   in Loop: Header=BB0_92 Depth=1
	push	hl
	call	__ZN12_GLOBAL__N_14textEiiPKcii
	.local	.LBB0_380
.LBB0_380:                              ;   in Loop: Header=BB0_92 Depth=1
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB0_381
.LBB0_381:                              ;   in Loop: Header=BB0_92 Depth=1
	call	_vdp_swap
	ld	hl, (__ZN12_GLOBAL__N_114sceneryHistoryE+8)
	ld	bc, 1
	call	__ixor
	ld	(__ZN12_GLOBAL__N_114sceneryHistoryE+8), hl
	ld	a, (__ZN12_GLOBAL__N_111savePendingE)
	bit	0, a
	jr	nz, .LBB0_383
; %bb.382:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, -4204
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -4201
	lea	iy, ix + 0
	add	iy, bc
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	jr	.LBB0_385
	.local	.LBB0_383
.LBB0_383:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	add	a, -7
	cp	a, 3
	ld	bc, -4204
	lea	hl, ix + 0
	push	af
	add	hl, bc
	pop	af
	ld	hl, (hl)
	ld	bc, -4201
	lea	iy, ix + 0
	push	af
	add	iy, bc
	pop	af
	ld	e, (iy + 0)                     ; 1-byte Folded Reload
	jr	nc, .LBB0_385
; %bb.384:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, __ZN12_GLOBAL__N_17recordsE
	push	hl
	call	__ZN5rally4game11saveRecordsERKNS0_7RecordsE
	pop	hl
	xor	a, a
	ld	(__ZN12_GLOBAL__N_111savePendingE), a
	call	__ZN12_GLOBAL__N_18rawClockEv
	.local	.LBB0_385
.LBB0_385:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	bc, -4192
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), e                     ; 1-byte Folded Spill
	push	hl
	pop	iy
	ld	bc, 4
	xor	a, a
	call	__ladd
	lea	bc, iy + 0
	ld	(ix - 3), bc
	ld	bc, -4177
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	d, e
	jp	.LBB0_92
	.local	.LBB0_386
.LBB0_386:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, l
	cp	a, 6
	jp	nz, .LBB0_381
; %bb.387:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	or	a, a
	ld	hl, _.str.55
	jr	z, .LBB0_389
; %bb.388:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	hl, _.str.56
	.local	.LBB0_389
.LBB0_389:                              ;   in Loop: Header=BB0_92 Depth=1
	ld	a, (__ZN12_GLOBAL__N_15rulesE+59)
	ld	de, 0
	push	de
	pop	bc
	ld	c, a
	inc	bc
	ld	a, (__ZN12_GLOBAL__N_15rulesE+8)
	ld	e, a
	push	de
	push	bc
	push	hl
	ld	hl, _.str.54
	push	hl
	ld	hl, 40
	push	hl
	ld	bc, -4186
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
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 15
	push	hl
	ld	bc, -4186
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	hl, 28
	push	hl
	ld	hl, 1
	push	hl
	call	__ZN12_GLOBAL__N_14textEiiPKcii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_15rulesE+57
	ld	hl, (hl)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	ld	hl, 0
	push	hl
	ld	hl, 11
	push	hl
	ld	hl, _.str.57
	push	hl
	ld	hl, 28
	push	hl
	ld	hl, 23
	push	hl
	call	nz, __ZN12_GLOBAL__N_14textEiiPKcii
	jp	.LBB0_380
	.local	.LBB0_390
.LBB0_390:
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_14quitE), a
	.local	.LBB0_391
.LBB0_391:
	ld	hl, __ZN12_GLOBAL__N_14sendEPKhj
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16engineE
	push	hl
	call	__ZN5rally4game6Engine4stopIPFvPKhjEEEvT_
	pop	hl
	pop	hl
	ld	hl, 65535
	push	hl
	call	__ZN12_GLOBAL__N_14fontEj
	pop	hl
	ld	bc, 6
	ld	de, 0
	push	de
	pop	iy
	.local	.LBB0_392
.LBB0_392:                              ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	z, .LBB0_394
; %bb.393:                              ;   in Loop: Header=BB0_392 Depth=1
	lea	de, iy + 0
	ld	hl, ___const._Z8gameMainiPPc.fonts
	add	hl, de
	ld	hl, (hl)
	push	ix
	ld	bc, -4183
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	bc, -4177
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	bc, -4180
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	(iy + 0), 23
	ld	(iy + 1), 0
	ld	(iy + 2), -107
	ld	(iy + 3), 4
	ld	a, l
	ld	(iy + 4), a
	ld	a, h
	ld	(iy + 5), a
	ld	hl, 6
	push	hl
	push	iy
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	ld	bc, -4183
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_vdp_adv_clear_buffer
	ld	bc, -4177
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	de, 0
	pop	hl
	ld	bc, 3
	add	iy, bc
	ld	bc, 6
	jp	.LBB0_392
	.local	.LBB0_394
.LBB0_394:
	push	de
	call	_vdp_mode
	pop	hl
	call	_vdp_set_logical_coordinates
	ld	hl, 1
	push	hl
	call	_vdp_cursor_enable
	pop	hl
	or	a, a
	sbc	hl, hl
	.local	.LBB0_395
.LBB0_395:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end0
.Lfunc_end0:
	.size	__Z8gameMainiPPc, .Lfunc_end0-__Z8gameMainiPPc
	.section	.rodata,"a",@progbits
JTI0_0:
	d24	.LBB0_336
	d24	.LBB0_337
	d24	.LBB0_342
	d24	.LBB0_354
	d24	.LBB0_345
	d24	.LBB0_342
	d24	.LBB0_354
	d24	.LBB0_347
	d24	.LBB0_347
	d24	.LBB0_347
                                        ; -- End function
	.section	.text,"ax",@progbits
	.weak	__ZN5rally4game11readRecordsEPKcRNS0_7RecordsE ; -- Begin function _ZN5rally4game11readRecordsEPKcRNS0_7RecordsE
	.type	__ZN5rally4game11readRecordsEPKcRNS0_7RecordsE,@function
__ZN5rally4game11readRecordsEPKcRNS0_7RecordsE: ; @_ZN5rally4game11readRecordsEPKcRNS0_7RecordsE
	.local	.Lfunc_begin1
.Lfunc_begin1:
; %bb.0:
	ld	hl, -2335
	call	__frameset
	ld	hl, (ix + 6)
	ld	de, _.str.15
	push	de
	push	hl
	call	_fopen
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB1_5
; %bb.1:
	ld	bc, 1
	ld	iy, 2320
	ld	(ix - 3), bc
	push	ix
	ld	bc, -2326
	add	ix, bc
	lea	de, ix + 0
	pop	ix
	push	ix
	ld	bc, -2329
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	push	hl
	push	iy
	ld	bc, (ix - 3)
	push	bc
	ld	bc, -2332
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	push	de
	call	_fread
	pop	de
	pop	de
	pop	de
	pop	de
	ld	de, 2320
	ld	bc, -2329
	or	a, a
	sbc	hl, de
	jr	nz, .LBB1_4
; %bb.2:
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fgetc
	ld	bc, -2335
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	pop	hl
	ld	bc, -2329
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	ld	de, -1
	ld	bc, -2335
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	or	a, a
	sbc	hl, de
	ld	a, 0
	jr	nz, .LBB1_6
; %bb.3:
	ld	hl, (ix + 9)
	ld	de, 2320
	push	de
	ld	bc, -2332
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	call	__ZN5rally4game7Records6decodeEPKhj
	pop	hl
	pop	hl
	pop	hl
	jr	.LBB1_6
	.local	.LBB1_4
.LBB1_4:
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	pop	hl
	.local	.LBB1_5
.LBB1_5:
	xor	a, a
	.local	.LBB1_6
.LBB1_6:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end1
.Lfunc_end1:
	.size	__ZN5rally4game11readRecordsEPKcRNS0_7RecordsE, .Lfunc_end1-__ZN5rally4game11readRecordsEPKcRNS0_7RecordsE
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_19loadTrackEv,@function ; -- Begin function _ZN12_GLOBAL__N_19loadTrackEv
__ZN12_GLOBAL__N_19loadTrackEv:         ; @_ZN12_GLOBAL__N_19loadTrackEv
	.local	.Lfunc_begin2
.Lfunc_begin2:
; %bb.0:
	ld	hl, __ZN12_GLOBAL__N_14roadE
	ld	de, (__ZN12_GLOBAL__N_18selectedE)
	ld	(__ZN12_GLOBAL__N_14roadE), de
	push	hl
	call	__ZN5rally4Road4initEv
	pop	hl
	ret
	.local	.Lfunc_end2
.Lfunc_end2:
	.size	__ZN12_GLOBAL__N_19loadTrackEv, .Lfunc_end2-__ZN12_GLOBAL__N_19loadTrackEv
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_111resetMotionEv,@function ; -- Begin function _ZN12_GLOBAL__N_111resetMotionEv
__ZN12_GLOBAL__N_111resetMotionEv:      ; @_ZN12_GLOBAL__N_111resetMotionEv
	.local	.Lfunc_begin3
.Lfunc_begin3:
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	hl, __ZN12_GLOBAL__N_16motionE+3
	ld	e, 0
	ld	iyl, 1
	ld	a, e
	ld	(__ZN12_GLOBAL__N_16motionE+3), a
	push	hl
	pop	de
	inc	de
	ld	bc, 23
	ldir
	ld	a, iyl
	ld	(__ZN12_GLOBAL__N_16motionE+30), a
	ld	iy, (__ZN12_GLOBAL__N_18selectedE)
	ld	(__ZN12_GLOBAL__N_16motionE), iy
	ld	hl, (iy + 6)
	ld	e, (iy + 9)
	ld	iyl, 0
	ld	bc, 100
	ld	a, iyl
	call	__lmulu
                                        ; kill: def $e killed $e def $ude
	ld	(ix - 3), hl
	ld	(ix - 6), de
                                        ; kill: def $e killed $e killed $ude
	ld	bc, -6800
	ld	a, -1
	call	__ladd
	ld	(__ZN12_GLOBAL__N_16motionE+7), hl
	ld	iy, __ZN12_GLOBAL__N_16motionE+7
	lea	hl, iy + 3
	ld	(hl), e
	ld	c, 0
	ld	a, c
	ld	(__ZN12_GLOBAL__N_16motionE+30), a
	ld.sis	hl, 0
	ld	e, l
	ld	d, h
	ld	hl, __ZN12_GLOBAL__N_15crashE
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ld	hl, __ZN12_GLOBAL__N_15crashE+2
	ld	(hl), e
	inc	hl
	ld	(hl), d
	or	a, a
	sbc	hl, hl
	ld	(__ZN12_GLOBAL__N_115attractProgressE), hl
	push	bc
	pop	iy
	ld	(__ZN12_GLOBAL__N_115attractProgressE+3), a
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	or	a, a
	jr	z, .LBB3_2
; %bb.1:
	ld	c, 0
	jr	.LBB3_3
	.local	.LBB3_2
.LBB3_2:
	ld	c, -1
	.local	.LBB3_3
.LBB3_3:
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	ld	l, a
	ld	a, (__ZN12_GLOBAL__N_15rulesE+60)
	ld	e, a
	bit	0, c
	jr	nz, .LBB3_5
; %bb.4:
	ex	de, hl
	ld	iyl, e
	ex	de, hl
	.local	.LBB3_5
.LBB3_5:
	bit	0, c
	jr	z, .LBB3_7
; %bb.6:
	ld	e, 7
	.local	.LBB3_7
.LBB3_7:
	ld	a, (__ZN12_GLOBAL__N_15rulesE+8)
	ld	l, a
	push	hl
	push	de
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	push	iy
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	call	__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (__ZN12_GLOBAL__N_16motionE+7)
	ld	a, (__ZN12_GLOBAL__N_16motionE+10)
	ld	e, a
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_17trafficE
	push	hl
	ld	hl, __ZN12_GLOBAL__N_111raceTrafficE
	push	hl
	call	__ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end3
.Lfunc_end3:
	.size	__ZN12_GLOBAL__N_111resetMotionEv, .Lfunc_end3-__ZN12_GLOBAL__N_111resetMotionEv
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_112phaseChangedEv,@function ; -- Begin function _ZN12_GLOBAL__N_112phaseChangedEv
__ZN12_GLOBAL__N_112phaseChangedEv:     ; @_ZN12_GLOBAL__N_112phaseChangedEv
	.local	.Lfunc_begin4
.Lfunc_begin4:
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	hl, __ZN12_GLOBAL__N_113shownRevisionE
	ld	iy, __ZN12_GLOBAL__N_15rulesE+55
	ld	c, 0
	ld	hl, (hl)
	ld	de, (iy)
                                        ; kill: def $hl killed $hl killed $uhl
	or	a, a
	sbc.sis	hl, de
	jp	z, .LBB4_19
; %bb.1:
	ld	hl, __ZN12_GLOBAL__N_113shownRevisionE
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ld	a, c
	ld	(__ZN12_GLOBAL__N_114sceneryHistoryE+7), a
	ld	(__ZN12_GLOBAL__N_114sceneryHistoryE+6), a
	ld	(__ZN12_GLOBAL__N_110panelCacheE+160), a
	ld	(__ZN12_GLOBAL__N_110panelCacheE), a
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	e, a
	or	a, a
	jr	z, .LBB4_4
; %bb.2:
	ld	a, e
	cp	a, 2
	jr	z, .LBB4_4
; %bb.3:
	ld	a, e
	cp	a, 5
	jr	nz, .LBB4_5
	.local	.LBB4_4
.LBB4_4:
	call	__ZN12_GLOBAL__N_111resetMotionEv
	ld	c, 0
	ld	a, (__ZN12_GLOBAL__N_15rulesE+10)
	ld	e, a
	or	a, a
	ld	l, c
	jr	z, .LBB4_8
	.local	.LBB4_5
.LBB4_5:
	ld	a, e
	dec	a
	cp	a, 9
	jr	nc, .LBB4_9
; %bb.6:
	ld.sis	hl, 449
	ld.sis	iy, 1
	ld	d, c
	ld	c, a
	call	__sshru
	ld	c, iyl
	ld	b, iyh
	call	__sand
	ld	c, d
	bit	0, l
	jr	z, .LBB4_9
; %bb.7:
	ld	iy, _switch.table._ZN12_GLOBAL__N_112phaseChangedEv
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	de
	ld	e, a
	add	iy, de
	ld	l, (iy)
	.local	.LBB4_8
.LBB4_8:
	xor	a, a
	ld	(__ZN12_GLOBAL__N_110inputArmedE), a
	ld	e, l
	.local	.LBB4_9
.LBB4_9:
	ld	a, e
	add	a, -7
	cp	a, 3
	jp	nc, .LBB4_19
; %bb.10:
	ld	iy, 2
	or	a, a
	sbc	hl, hl
	ld	(__ZN12_GLOBAL__N_16motionE+11), hl
	ld	a, c
	ld	(__ZN12_GLOBAL__N_16motionE+14), a
	ld	hl, (__ZN12_GLOBAL__N_18selectedE)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+9)
	ld	c, a
	ld	a, (__ZN12_GLOBAL__N_112steeringStepE)
	bit	0, a
	jr	nz, .LBB4_12
; %bb.11:
	ld	(ix - 6), iy
	jr	.LBB4_13
	.local	.LBB4_12
.LBB4_12:
	ld	de, 1
	ld	(ix - 6), de
	.local	.LBB4_13
.LBB4_13:
	ld	de, __ZN5rallyL4FujiE
	or	a, a
	sbc	hl, de
	jr	z, .LBB4_15
; %bb.14:
	ld	iy, 0
	.local	.LBB4_15
.LBB4_15:
	ld	hl, (__ZN12_GLOBAL__N_15rulesE+62)
	ld	(ix - 3), hl
	ld	a, c
	cp	a, 1
	jr	z, .LBB4_17
; %bb.16:
	ld	bc, 0
	jr	.LBB4_18
	.local	.LBB4_17
.LBB4_17:
	ld	bc, 1
	.local	.LBB4_18
.LBB4_18:
	add	iy, bc
	ld	c, 1
	lea	hl, iy + 0
	call	__ishl
	ld	de, (ix - 6)
	add	hl, de
	ld	bc, 36
	call	__imulu
	push	hl
	pop	de
	ld	bc, -25
	ld	hl, (ix - 3)
	add	hl, bc
	ld	bc, 5
	call	__idivs
	ld	bc, -36
	add	hl, bc
	add	hl, de
	ld	de, (__ZN12_GLOBAL__N_15rulesE+39)
	ld	(ix - 3), de
	ld	a, (__ZN12_GLOBAL__N_15rulesE+42)
	ld	iyl, a
	ld	bc, (__ZN12_GLOBAL__N_15rulesE+31)
	ld	a, (__ZN12_GLOBAL__N_15rulesE+34)
	ld	e, a
	push	de
	push	bc
	push	iy
	ld	de, (ix - 3)
	push	de
	push	hl
	ld	hl, __ZN12_GLOBAL__N_17recordsE
	push	hl
	call	__ZN5rally4game7Records6updateEjmm
	ld	l, a
	pop	de
	pop	de
	pop	de
	pop	de
	pop	de
	pop	de
	ld	a, (__ZN12_GLOBAL__N_111savePendingE)
	and	a, 1
	ld	e, a
	ld	a, l
	or	a, e
	and	a, 1
	ld	(__ZN12_GLOBAL__N_111savePendingE), a
	.local	.LBB4_19
.LBB4_19:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end4
.Lfunc_end4:
	.size	__ZN12_GLOBAL__N_112phaseChangedEv, .Lfunc_end4-__ZN12_GLOBAL__N_112phaseChangedEv
                                        ; -- End function
	.weak	__ZN5rally4game6Engine5startIPFvPKhjEEEvT_ ; -- Begin function _ZN5rally4game6Engine5startIPFvPKhjEEEvT_
	.type	__ZN5rally4game6Engine5startIPFvPKhjEEEvT_,@function
__ZN5rally4game6Engine5startIPFvPKhjEEEvT_: ; @_ZN5rally4game6Engine5startIPFvPKhjEEEvT_
	.local	.Lfunc_begin5
.Lfunc_begin5:
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
	.local	.Lfunc_end5
.Lfunc_end5:
	.size	__ZN5rally4game6Engine5startIPFvPKhjEEEvT_, .Lfunc_end5-__ZN5rally4game6Engine5startIPFvPKhjEEEvT_
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_14sendEPKhj,@function ; -- Begin function _ZN12_GLOBAL__N_14sendEPKhj
__ZN12_GLOBAL__N_14sendEPKhj:           ; @_ZN12_GLOBAL__N_14sendEPKhj
	.local	.Lfunc_begin6
.Lfunc_begin6:
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 9)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB6_2
; %bb.1:
	ld	de, (ix + 6)
	ld	bc, 0
	push	bc
	push	hl
	push	de
	call	_mos_puts
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB6_2
.LBB6_2:
	pop	ix
	ret
	.local	.Lfunc_end6
.Lfunc_end6:
	.size	__ZN12_GLOBAL__N_14sendEPKhj, .Lfunc_end6-__ZN12_GLOBAL__N_14sendEPKhj
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_18rawClockEv,@function ; -- Begin function _ZN12_GLOBAL__N_18rawClockEv
__ZN12_GLOBAL__N_18rawClockEv:          ; @_ZN12_GLOBAL__N_18rawClockEv
	.local	.Lfunc_begin7
.Lfunc_begin7:
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	iy, (_sys_vars)
	ld	(ix - 6), iy
	lea	hl, iy + 3
	ld	(ix - 3), hl
	.local	.LBB7_1
.LBB7_1:                                ; =>This Inner Loop Header: Depth=1
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
	jr	nz, .LBB7_1
; %bb.2:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end7
.Lfunc_end7:
	.size	__ZN12_GLOBAL__N_18rawClockEv, .Lfunc_end7-__ZN12_GLOBAL__N_18rawClockEv
                                        ; -- End function
	.weak	__ZN5rally10DemoDriver5frameERNS_6MotionE ; -- Begin function _ZN5rally10DemoDriver5frameERNS_6MotionE
	.type	__ZN5rally10DemoDriver5frameERNS_6MotionE,@function
__ZN5rally10DemoDriver5frameERNS_6MotionE: ; @_ZN5rally10DemoDriver5frameERNS_6MotionE
	.local	.Lfunc_begin8
.Lfunc_begin8:
; %bb.0:
	ld	hl, -92
	call	__frameset
	ld	iy, (ix + 9)
	ld	bc, 100
	xor	a, a
	sbc	hl, hl
	ld	(ix - 82), hl
	ld	hl, (iy + 7)
	ld	e, (iy + 10)
	call	__ldivs
	push	hl
	pop	bc
	ld	a, e
	ld	l, 8
	ld	(ix - 76), bc
	ld	(ix - 79), a                    ; 1-byte Folded Spill
	call	__lshl
	ld	(ix - 70), bc
	ld	e, a
	ld	(ix - 67), de
	ld	hl, (ix + 9)
	ld	hl, (hl)
	push	hl
	push	de
	push	bc
	pea	ix - 16
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (ix - 70)
	ld	de, (ix - 67)
                                        ; kill: def $e killed $e killed $ude
	ld	bc, 16384
	xor	a, a
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	ld	iy, (ix + 9)
	ld	bc, (iy)
	push	bc
	push	de
	push	hl
	pea	ix - 32
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	ld	iy, (ix + 9)
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, (iy + 11)
	ld	hl, 10
	ld	e, h
	ld	a, (iy + 14)
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB8_2
; %bb.1:
	ld	bc, (ix - 8)
	ld	hl, (ix - 20)
	ld	e, (ix - 17)
	ld	a, (ix - 5)
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	bc, (ix - 4)
	ld	hl, (ix - 24)
	ld	e, (ix - 21)
	ld	a, (ix - 1)
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	lea	hl, iy + 0
	ld	iy, (ix + 9)
	ld	e, d
	call	__lsub
	ld	bc, 4096
	xor	a, a
	call	__ldivs
	ld	bc, 27
	call	__lmulu
	ld	bc, 4096
	call	__ldivs
	jr	.LBB8_3
	.local	.LBB8_2
.LBB8_2:
	ld.sis	hl, 0
	xor	a, a
	.local	.LBB8_3
.LBB8_3:
	ld	de, 200
	ld	(ix - 85), de
	ld	(iy + 25), l
	ld	(iy + 26), h
	ld	de, 513
	or	a, a
	sbc	hl, hl
	push	hl
	pop	iy
	ld	(ix - 70), hl
	ld	(ix - 67), a                    ; 1-byte Folded Spill
	.local	.LBB8_4
.LBB8_4:                                ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jp	nc, .LBB8_18
; %bb.5:                                ;   in Loop: Header=BB8_4 Depth=1
	xor	a, a
	ld	hl, (ix - 76)
	ld	e, (ix - 79)                    ; 1-byte Folded Reload
	ld	(ix - 73), iy
	lea	bc, iy + 0
	call	__ladd
	push	hl
	pop	bc
	ld	a, e
	ld	l, 8
	call	__lshl
	ld	iyl, a
	ld	hl, (ix + 9)
	ld	de, (hl)
	push	de
	push	iy
	push	bc
	pea	ix - 48
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, (ix - 73)
	push	bc
	pop	iy
	ld	hl, 64
	ex	de, hl
	add	iy, de
	ld	(ix - 88), iy
	push	bc
	pop	iy
	add	iy, de
	ld	hl, (ix - 76)
	ld	e, (ix - 79)                    ; 1-byte Folded Reload
	lea	bc, iy + 0
	xor	a, a
	call	__ladd
	push	hl
	pop	bc
	ld	a, e
	ld	l, 8
	call	__lshl
	ld	iyl, a
	ld	hl, (ix + 9)
	ld	de, (hl)
	push	de
	push	iy
	push	bc
	pea	ix - 64
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, (ix - 40)
	ld	hl, (ix - 52)
	ld	e, (ix - 49)
	ld	a, (ix - 37)
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	bc, (ix - 36)
	ld	hl, (ix - 56)
	ld	e, (ix - 53)
	ld	a, (ix - 33)
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	lea	hl, iy + 0
	ld	e, d
	call	__lsub
	push	hl
	pop	iy
	ld	d, e
	ld	bc, 4096
	xor	a, a
	call	__ldivs
	ld	(ix - 91), hl
	ld	(ix - 92), e                    ; 1-byte Folded Spill
	lea	hl, iy + 0
	ld	e, d
	ld	bc, -4095
	dec	a
	call	__lcmps
	call	pe, __setflag
	ld	a, c
	jp	m, .LBB8_7
; %bb.6:                                ;   in Loop: Header=BB8_4 Depth=1
	ld	a, 0
	.local	.LBB8_7
.LBB8_7:                                ;   in Loop: Header=BB8_4 Depth=1
	ld	iy, (ix - 91)
	lea	hl, iy + 0
	ld	d, (ix - 92)                    ; 1-byte Folded Reload
	ld	e, d
	call	__lneg
	push	hl
	pop	bc
	ld	(ix - 73), e                    ; 1-byte Folded Spill
	bit	0, a
	jr	nz, .LBB8_9
; %bb.8:                                ;   in Loop: Header=BB8_4 Depth=1
	lea	bc, iy + 0
	.local	.LBB8_9
.LBB8_9:                                ;   in Loop: Header=BB8_4 Depth=1
	bit	0, a
	jr	nz, .LBB8_11
; %bb.10:                               ;   in Loop: Header=BB8_4 Depth=1
	ld	(ix - 73), d                    ; 1-byte Folded Spill
	.local	.LBB8_11
.LBB8_11:                               ;   in Loop: Header=BB8_4 Depth=1
	ld	hl, (ix - 70)
	ld	e, (ix - 67)                    ; 1-byte Folded Reload
	ld	a, (ix - 73)                    ; 1-byte Folded Reload
	call	__lcmps
	call	pe, __setflag
	ld	l, 1
	jp	m, .LBB8_13
; %bb.12:                               ;   in Loop: Header=BB8_4 Depth=1
	ld	l, 0
	.local	.LBB8_13
.LBB8_13:                               ;   in Loop: Header=BB8_4 Depth=1
	bit	0, l
	ld	de, 513
	jr	nz, .LBB8_15
; %bb.14:                               ;   in Loop: Header=BB8_4 Depth=1
	ld	bc, (ix - 70)
	.local	.LBB8_15
.LBB8_15:                               ;   in Loop: Header=BB8_4 Depth=1
	bit	0, l
	jr	nz, .LBB8_17
; %bb.16:                               ;   in Loop: Header=BB8_4 Depth=1
	ld	a, (ix - 67)                    ; 1-byte Folded Reload
	ld	(ix - 73), a
	.local	.LBB8_17
.LBB8_17:                               ;   in Loop: Header=BB8_4 Depth=1
	ld	iy, (ix - 88)
	ld	(ix - 70), bc
	ld	a, (ix - 73)
	ld	(ix - 67), a                    ; 1-byte Folded Spill
	xor	a, a
	jp	.LBB8_4
	.local	.LBB8_18
.LBB8_18:
	ld	hl, (ix + 9)
	push	hl
	pop	iy
	ld	bc, (iy + 27)
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
	ld	bc, 46080
	ld	d, a
	call	__lmulu
	ld	bc, 100
	call	__ldivs
	ld	bc, 60
	call	__lmulu
	ld	(ix - 73), hl
	ld	(ix - 76), e                    ; 1-byte Folded Spill
	ld	iy, (ix + 9)
	ld	bc, (iy + 15)
	ld	iy, (ix + 9)
	ld	e, (iy + 18)
	ld	l, 31
	push	bc
	pop	iy
	ld	a, e
	call	__lshrs
	ld	(ix - 79), iy
	lea	hl, iy + 0
	ld	(ix - 88), e                    ; 1-byte Folded Spill
	call	__ladd
	call	__lxor
	push	hl
	pop	bc
	ld	a, e
	ld	hl, 24064
	ld	e, d
	call	__lcmpu
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	inc	a
	bit	0, a
	jr	nz, .LBB8_20
; %bb.19:
	ld	hl, 100
	ld	(ix - 85), hl
	.local	.LBB8_20
.LBB8_20:
	bit	0, a
	ld	hl, (ix - 73)
	ld	e, (ix - 76)                    ; 1-byte Folded Reload
	ld	bc, (ix - 85)
	xor	a, a
	call	__ldivs
	ld	(ix - 73), hl
	ld	d, e
	ld	bc, 41
	ld	iy, 224
	.local	.LBB8_21
.LBB8_21:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jr	c, .LBB8_24
; %bb.22:                               ;   in Loop: Header=BB8_21 Depth=1
	xor	a, a
	ld	hl, (ix - 70)
	ld	e, (ix - 67)                    ; 1-byte Folded Reload
	lea	bc, iy + 0
	call	__lmulu
	call	__lmulu
	ld	bc, 1024
	call	__ldivs
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 73)
	ld	e, d
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB8_25
; %bb.23:                               ;   in Loop: Header=BB8_21 Depth=1
	ld	bc, -4
	add	iy, bc
	ld	bc, 41
	jr	.LBB8_21
	.local	.LBB8_24
.LBB8_24:
	ld	de, 40
	jr	.LBB8_26
	.local	.LBB8_25
.LBB8_25:
	lea	de, iy + 0
	.local	.LBB8_26
.LBB8_26:
	ld	hl, (ix + 6)
	ld	(hl), de
	ld	iy, (ix + 9)
	ld	bc, (iy + 11)
	ld	a, (iy + 14)
	ld	hl, 10
	ld	d, h
	ld	e, d
	ld	(ix - 67), bc
	ld	(ix - 70), a                    ; 1-byte Folded Spill
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB8_28
; %bb.27:
	ld	hl, (ix - 79)
	ld	e, (ix - 88)                    ; 1-byte Folded Reload
	ld	bc, -2
	ld	a, b
	call	__lmulu
	ld	(ix - 73), hl
	ld	(ix - 76), e                    ; 1-byte Folded Spill
	ld	iy, (ix + 9)
	ld	hl, (iy + 19)
	ld	e, (iy + 22)
	call	__ldivs
	ld	bc, (ix - 73)
	ld	a, (ix - 76)                    ; 1-byte Folded Reload
	call	__ladd
	ld	bc, 63
	ld	a, d
	call	__lmulu
	push	hl
	pop	iy
	ld	l, 9
	ld	bc, (ix - 67)
	ld	a, (ix - 70)                    ; 1-byte Folded Reload
	call	__lshl
	lea	hl, iy + 0
	call	__ldivs
	ld	(ix - 82), hl
	.local	.LBB8_28
.LBB8_28:
	ld	hl, (ix + 9)
	push	hl
	pop	iy
	ld	de, (iy + 25)
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	bc
	ld	b, a
	ld	c, e
	ld	iy, (ix - 82)
	add	iy, bc
	ld	de, 21
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	m, .LBB8_30
; %bb.29:
	ld	iy, 21
	.local	.LBB8_30
.LBB8_30:
	ld	de, -20
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB8_32
; %bb.31:
	ld	iy, -21
	.local	.LBB8_32
.LBB8_32:
	lea	bc, iy + 0
	ld	iy, (ix + 9)
	ld	iy, (iy + 23)
	ld	a, iyh
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	de
	ld	d, a
	ld	e, iyl
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	push	hl
	pop	de
	ld	bc, 3
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	m, .LBB8_34
; %bb.33:
	ld	de, 3
	.local	.LBB8_34
.LBB8_34:
	ld	bc, -2
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	p, .LBB8_36
; %bb.35:
	ld	de, -3
	.local	.LBB8_36
.LBB8_36:
	add.sis	iy, de
	lea	hl, iy + 0
	ld	iy, (ix + 9)
	ld	(iy + 23), l
	ld	(iy + 24), h
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end8
.Lfunc_end8:
	.size	__ZN5rally10DemoDriver5frameERNS_6MotionE, .Lfunc_end8-__ZN5rally10DemoDriver5frameERNS_6MotionE
                                        ; -- End function
	.weak	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_ ; -- Begin function _ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
	.type	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_,@function
__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_: ; @_ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
	.local	.Lfunc_begin9
.Lfunc_begin9:
; %bb.0:
	ld	hl, -10
	call	__frameset
	ld	iy, (ix + 6)
	ld	d, 0
	or	a, a
	sbc	hl, hl
	bit	0, (iy)
	jp	z, .LBB9_12
; %bb.1:
	ld	iy, (ix + 9)
	ld	a, (ix + 12)
	ld	e, d
	lea	bc, iy + 0
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB9_3
; %bb.2:
	ld	e, 0
	jr	.LBB9_4
	.local	.LBB9_3
.LBB9_3:
	ld	e, 1
	.local	.LBB9_4
.LBB9_4:
	bit	0, e
	jr	nz, .LBB9_6
; %bb.5:
	push	hl
	pop	iy
	.local	.LBB9_6
.LBB9_6:
	ld	bc, 300
	bit	0, e
	jr	nz, .LBB9_8
; %bb.7:
	ld	a, d
	.local	.LBB9_8
.LBB9_8:
	lea	hl, iy + 0
	ld	e, a
	ld	a, d
	call	__lcmpu
	jr	c, .LBB9_10
; %bb.9:
	push	bc
	pop	iy
	.local	.LBB9_10
.LBB9_10:
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
	jr	z, .LBB9_12
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
	.local	.LBB9_12
.LBB9_12:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end9
.Lfunc_end9:
	.size	__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_, .Lfunc_end9-__ZN5rally4game6Engine6updateIPFvPKhjEEEvlT_
                                        ; -- End function
	.weak	__ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb ; -- Begin function _ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb
	.type	__ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb,@function
__ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb: ; @_ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb
	.local	.Lfunc_begin10
.Lfunc_begin10:
; %bb.0:
	ld	hl, -148
	call	__frameset
	ld	hl, (ix + 6)
	lea	de, ix - 50
	ld	(ix - 112), de
	lea	de, ix - 74
	ld	(ix - 121), de
	push	hl
	pop	iy
	lea	de, iy + 7
	ld	hl, (iy + 7)
	lea	bc, iy + 0
	ld	(ix - 115), hl
	push	de
	pop	iy
	lea	hl, iy + 3
	ld	(ix - 109), hl
	ld	a, (hl)
	push	bc
	pop	iy
	ld	de, (iy + 3)
	ld	c, (iy + 6)
	ld	iy, 0
	push	iy
	or	a, a
	sbc	hl, hl
	push	hl
                                        ; kill: def $c killed $c def $ubc
	push	bc
	push	de
	ld	e, a
	push	de
	ld	hl, (ix - 115)
	push	hl
	ld	hl, (ix + 15)
	push	hl
	call	__ZN5rally10DirectRoad7projectElll
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	ld	iy, (ix + 6)
	ld	hl, (iy + 7)
	ld	(ix - 118), hl
	ld	iy, (ix - 109)
	ld	d, (iy)
	ld	e, d
	ld	bc, 100
	ld	iyh, b
	ld	a, iyh
	call	__ldivs
	push	hl
	pop	iy
	ld	l, 8
	lea	bc, iy + 0
	ld	a, e
	call	__lshl
	ld	(ix - 109), bc
	ld	(ix - 115), a                   ; 1-byte Folded Spill
	lea	hl, iy + 0
	ld	bc, 100
	ld	iyh, b
	ld	a, iyh
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 118)
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
	ld	bc, 100
	ld	a, iyh
	call	__ldivs
	ld	bc, (ix - 109)
	ld	a, (ix - 115)                   ; 1-byte Folded Reload
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	ld	iy, (ix + 6)
	ld	bc, (iy)
	push	bc
	push	de
	push	hl
	pea	ix - 22
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (ix - 14)
	ld	a, (ix - 11)
	ld	de, (ix - 10)
	ld	c, (ix - 7)
	push	bc
	push	de
	ld	e, a
	push	de
	push	hl
	call	__ZN5rally14sceneryHeadingEll
	ld	(ix - 109), hl
	pop	de
	pop	de
	pop	de
	pop	de
	push	hl
	ld	hl, (ix + 18)
	push	hl
	pea	ix - 32
	call	__ZN5rally14SceneryHistory7prepareEi
	pop	hl
	pop	hl
	pop	hl
	ld	iy, (ix + 21)
	ld	hl, (ix - 109)
	ld	(iy), hl
	ld	hl, (ix - 32)
	ld	(iy + 3), hl
	ld	hl, (ix - 29)
	ld	(iy + 6), hl
	ld	hl, (ix - 26)
	ld	(iy + 9), hl
	ld	a, (ix - 23)
	ld	(iy + 12), a
	ld	hl, (ix + 6)
	ld	iy, (hl)
	ld	hl, (iy + 6)
	push	ix
	ld	bc, -136
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	e, (iy + 9)
	ld	bc, 100
	ld	iyh, b
	ld	(ix - 109), iy
	ld	a, iyh
	call	__lmulu
	ld	(ix - 3), bc
	ld	bc, -133
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	push	ix
	ld	bc, -139
	add	ix, bc
	ld	(ix + 0), e                     ; 1-byte Folded Spill
	pop	ix
	ld	iy, (ix + 6)
	ld	hl, (iy + 7)
	ld	(ix - 124), hl
	ld	a, (iy + 10)
	ld	(ix - 127), a
	ld	hl, (ix - 121)
	ld	(ix - 118), hl
	ld	hl, (ix + 9)
	ld	(ix - 115), hl
	ld	de, (ix - 112)
	ld	iy, 0
	ld	bc, (ix - 3)
	.local	.LBB10_1
.LBB10_1:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	ld	bc, 6
	or	a, a
	sbc	hl, bc
	jp	z, .LBB10_3
; %bb.2:                                ;   in Loop: Header=BB10_1 Depth=1
	ld	bc, -130
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), de
	push	ix
	ld	bc, -142
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	push	ix
	ld	bc, -130
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	ld	(hl), iy
	ld	iy, (ix - 115)
	ld	hl, (iy)
	ld	e, (iy + 3)
	ld	bc, -133
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	lea	bc, iy + 0
	ld	(ix - 3), bc
	push	ix
	ld	bc, -139
	add	ix, bc
	ld	d, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	ld	a, d
	ld	bc, (ix - 3)
	call	__ladd
	ld	bc, (ix - 124)
	ld	a, (ix - 127)                   ; 1-byte Folded Reload
	call	__lsub
	lea	bc, iy + 0
	ld	a, d
	call	__lrems
	ld	(ix - 3), de
	ld	de, -142
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	ld	iy, (ix - 118)
	ld	(iy), hl
	ld	de, (ix - 3)
	ld	(iy + 3), e
	lea	hl, iy + 0
	inc	bc
	ld	(ix - 3), bc
	ld	bc, -130
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	lea	iy, iy + 3
	lea	de, iy + 0
	ld	iy, (ix - 115)
	lea	iy, iy + 10
	ld	(ix - 115), iy
	push	hl
	pop	iy
	lea	iy, iy + 4
	ld	(ix - 118), iy
	ld	bc, (ix - 3)
	push	bc
	pop	iy
	jp	.LBB10_1
	.local	.LBB10_3
.LBB10_3:
	ld	iy, (ix - 112)
	lea	hl, iy + 3
	ld	de, -130
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	bc, 5
	ld	iy, 3
	ld	de, 0
	ld	(ix - 118), de
	.local	.LBB10_4
.LBB10_4:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB10_6 Depth 2
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jp	z, .LBB10_11
; %bb.5:                                ;   in Loop: Header=BB10_4 Depth=1
	push	de
	pop	hl
	inc	hl
	push	ix
	ld	bc, -139
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ex	de, hl
	lea	bc, iy + 0
	call	__imulu
	push	hl
	pop	de
	ld	hl, (ix - 112)
	add	hl, de
	push	ix
	ld	de, -133
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (ix - 118)
	.local	.LBB10_6
.LBB10_6:                               ;   Parent Loop BB10_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	(ix - 115), hl
	ld	de, 15
	or	a, a
	sbc	hl, de
	ld	bc, 5
	jp	z, .LBB10_10
; %bb.7:                                ;   in Loop: Header=BB10_6 Depth=2
	ld	de, -133
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld	hl, (hl)
	ld	de, -145
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	a, 2
	ld	c, a
	call	__ishl
	push	hl
	pop	bc
	ld	de, (ix - 121)
	push	de
	pop	iy
	add	iy, bc
	ld	hl, (iy)
	push	ix
	ld	bc, -142
	add	ix, bc
	ld	(ix + 0), hl
	pop	ix
	ld	a, (iy + 3)
	ld	bc, (ix - 115)
	ld	(ix - 3), de
	ld	de, -130
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	add	hl, bc
	ld	hl, (hl)
	ld	de, -148
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	c, 2
	call	__ishl
	push	hl
	pop	bc
	ld	de, (ix - 3)
	push	de
	pop	iy
	add	iy, bc
	ld	bc, (iy)
	push	ix
	ld	de, -142
	add	ix, de
	ld	hl, (ix + 0)
	pop	ix
	ld	e, a
	ld	a, (iy + 3)
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB10_9
; %bb.8:                                ;   in Loop: Header=BB10_6 Depth=2
	ld	bc, -133
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	bc, -148
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	ld	(hl), de
	ld	de, (ix - 115)
	ld	bc, -130
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	add	hl, de
	push	ix
	ld	bc, -145
	add	ix, bc
	ld	de, (ix + 0)
	pop	ix
	ld	(hl), de
	.local	.LBB10_9
.LBB10_9:                               ;   in Loop: Header=BB10_6 Depth=2
	ld	de, 3
	ld	hl, (ix - 115)
	add	hl, de
	ld	iy, 3
	jp	.LBB10_6
	.local	.LBB10_10
.LBB10_10:                              ;   in Loop: Header=BB10_4 Depth=1
	ld	de, 3
	ld	hl, (ix - 118)
	add	hl, de
	ld	(ix - 118), hl
	ld	(ix - 3), bc
	ld	bc, -139
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	ld	bc, (ix - 3)
	jp	.LBB10_4
	.local	.LBB10_11
.LBB10_11:
	ld	hl, (ix - 124)
	ld	e, (ix - 127)                   ; 1-byte Folded Reload
	ld	bc, 100
	ld	iyh, b
	ld	a, iyh
	call	__ldivs
	push	hl
	pop	bc
	ld	a, e
	ld	l, 8
	call	__lshl
	ld	l, a
	ld	(ix - 3), bc
	ld	bc, -136
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	ld	bc, (ix - 3)
	push	bc
	pea	ix - 90
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	de, 18
	or	a, a
	sbc	hl, hl
	push	hl
	pop	iy
	ld	(ix - 115), hl
	.local	.LBB10_12
.LBB10_12:                              ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jp	z, .LBB10_28
; %bb.13:                               ;   in Loop: Header=BB10_12 Depth=1
	ld	(ix - 124), iy
	lea	de, iy + 0
	ld	iy, (ix - 112)
	add	iy, de
	ld	hl, (iy)
	ld	(ix - 118), hl
	ld	c, 2
	call	__ishl
	push	hl
	pop	de
	ld	iy, (ix - 121)
	add	iy, de
	ld	hl, (iy)
	ld	d, (iy + 3)
	push	hl
	pop	iy
	ld	e, d
	ld	bc, -110100
	ld	a, -1
	call	__ladd
	ld	bc, -103700
	call	__lcmpu
	jp	c, .LBB10_27
; %bb.14:                               ;   in Loop: Header=BB10_12 Depth=1
	lea	hl, iy + 0
	ld	e, d
	ld	bc, 100
	ld	iy, (ix - 109)
	ld	a, iyh
	call	__ldivu
	push	hl
	pop	bc
	ld.sis	hl, 8000
                                        ; kill: def $bc killed $bc killed $ubc
	call	__sdivu
	ld	e, l
	ld	d, h
	or	a, a
	sbc	hl, hl
	ld	(ix - 3), bc
	ld	bc, -130
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), de
	ld	l, e
	ld	h, d
	ld	(ix - 127), hl
	push	hl
	pop	iy
	ld	de, 96
	add	iy, de
	ld	hl, (ix - 118)
	ld	bc, (ix - 3)
	ld	bc, 10
	call	__imulu
	push	hl
	pop	de
	ld	hl, (ix + 9)
	add	hl, de
	push	ix
	ld	de, -133
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	de, -139
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), iy
	push	iy
	ld	hl, (ix + 15)
	push	hl
	call	__ZNK5rally10DirectRoad8centerAtEi
	push	hl
	pop	de
	pop	hl
	pop	hl
	ld	bc, -133
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy + 7)
	ld	bc, (ix - 127)
	call	__imulu
	ld	bc, 50
	call	__idivs
	add	hl, de
	ld	de, -136
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	hl, (ix - 127)
	ld	c, 1
	call	__ishl
	push	ix
	ld	de, -142
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	push	ix
	ld	de, -133
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	hl, (iy)
	ld	e, (iy + 3)
	ld	bc, 100
	ld	iy, (ix - 109)
	ld	a, iyh
	call	__ldivs
	push	hl
	pop	bc
	ld	a, e
	ld	l, 8
	call	__lshl
	ld	iyl, a
	ld	hl, (ix + 6)
	ld	de, (hl)
	push	de
	push	iy
	push	bc
	pea	ix - 106
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, (ix - 82)
	ld	hl, (ix - 94)
	ld	e, (ix - 91)
	ld	a, (ix - 79)
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	bc, (ix - 78)
	ld	hl, (ix - 98)
	ld	e, (ix - 95)
	ld	a, (ix - 75)
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	lea	hl, iy + 0
	ld	e, d
	call	__lsub
	ld	bc, 4096
	ld	iy, (ix - 109)
	ld	a, iyh
	call	__ldivs
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	call	__ZN5rally3r1816headingFromCrossEl
	pop	de
	pop	de
	ld	bc, -133
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	ld	l, h
	push	ix
	ld	bc, -145
	add	ix, bc
	ld	(ix + 0), l                     ; 1-byte Folded Spill
	pop	ix
	rlc	l
	sbc	hl, hl
	push	hl
	pop	de
	ld	hl, (ix - 118)
	ld	bc, 1
	call	__iand
	ld	(ix - 3), de
	push	ix
	ld	de, -148
	add	ix, de
	ld	(ix + 0), hl
	pop	ix
	ld	hl, (ix - 118)
	ld	bc, 29
	call	__imulu
	push	hl
	pop	bc
	ld	iy, (ix + 12)
	add	iy, bc
	ld	bc, (iy + 23)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	iy
	ld	iyh, a
	ld	iyl, c
	lea	hl, iy + 0
	call	__ineg
	push	ix
	add	ix, de
	ld	bc, (ix + 0)
	pop	ix
	bit	0, c
	ld	de, (ix - 3)
	jr	z, .LBB10_16
; %bb.15:                               ;   in Loop: Header=BB10_12 Depth=1
	push	hl
	pop	iy
	.local	.LBB10_16
.LBB10_16:                              ;   in Loop: Header=BB10_12 Depth=1
	ld	bc, -145
	lea	hl, ix + 0
	add	hl, bc
	ld	d, (hl)                         ; 1-byte Folded Reload
	push	ix
	ld	bc, -133
	add	ix, bc
	ld	hl, (ix + 0)
	pop	ix
	ld	e, l
	add	iy, de
	bit	0, (ix + 24)
	jr	z, .LBB10_18
; %bb.17:                               ;   in Loop: Header=BB10_12 Depth=1
	ld	bc, -136
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	ld	bc, -133
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	call	__ZN5rally3r1814viewingBearingEi
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
	ld	de, -133
	lea	iy, ix + 0
	add	iy, de
	ld	hl, (iy + 0)
	or	a, a
	sbc	hl, bc
	push	hl
	pop	iy
	.local	.LBB10_18
.LBB10_18:                              ;   in Loop: Header=BB10_12 Depth=1
	lea	hl, iy + 0
	ld	de, 1
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	ld	a, -1
	jp	p, .LBB10_20
; %bb.19:                               ;   in Loop: Header=BB10_12 Depth=1
	ld	a, 0
	.local	.LBB10_20
.LBB10_20:                              ;   in Loop: Header=BB10_12 Depth=1
	ld	bc, -133
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a                         ; 1-byte Folded Spill
	and	a, 1
	lea	hl, iy + 0
	lea	de, iy + 0
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	bc
	ex	de, hl
	add	hl, bc
	call	__ixor
	ld	de, 672
	add	hl, de
	ld	bc, 1344
	call	__idivu
	push	hl
	pop	de
	ld	bc, 4
	or	a, a
	sbc	hl, bc
	jr	c, .LBB10_22
; %bb.21:                               ;   in Loop: Header=BB10_12 Depth=1
	ld	de, 4
	.local	.LBB10_22
.LBB10_22:                              ;   in Loop: Header=BB10_12 Depth=1
	ld	hl, (ix - 115)
	ld	bc, 22
	call	__imulu
	push	hl
	pop	bc
	ld	iy, (ix + 21)
	add	iy, bc
	ld	hl, (ix - 118)
	ld	bc, 5
	call	__imulu
	add	hl, bc
	add	hl, de
	ld	(iy + 26), hl
	ld	de, 63970
	ld	hl, (ix - 118)
	add	hl, de
	ld	(iy + 29), hl
	ld	bc, -142
	lea	hl, ix + 0
	add	hl, bc
	ld	de, (hl)
	ld	(iy + 32), de
	push	de
	pop	hl
	call	__ineg
	push	ix
	ld	bc, -133
	add	ix, bc
	bit	0, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	jr	nz, .LBB10_24
; %bb.23:                               ;   in Loop: Header=BB10_12 Depth=1
	ex	de, hl
	.local	.LBB10_24
.LBB10_24:                              ;   in Loop: Header=BB10_12 Depth=1
	ld	(iy + 35), hl
	ld	hl, (ix - 127)
	ld	bc, 202
	call	__imulu
	push	ix
	ld	de, -133
	add	ix, de
	bit	0, (ix + 0)                     ; 1-byte Folded Reload
	pop	ix
	jr	nz, .LBB10_26
; %bb.25:                               ;   in Loop: Header=BB10_12 Depth=1
	or	a, a
	sbc	hl, hl
	.local	.LBB10_26
.LBB10_26:                              ;   in Loop: Header=BB10_12 Depth=1
	ld	de, (ix - 115)
	inc	de
	ld	(ix - 115), de
	ld	(iy + 38), hl
	ld	(iy + 47), a
	ld	(ix - 118), iy
	ld	de, -130
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld.sis	bc, 102
	call	__smulu
	ld	de, (ix - 109)
	ld	e, h
	or	a, a
	sbc	hl, hl
	push	hl
	pop	bc
	ld	c, e
	ld	b, d
	ld	(ix - 3), de
	ld	de, -136
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	or	a, a
	sbc	hl, bc
	ld	iy, (ix - 118)
	ld	(iy + 41), hl
	ld	de, -130
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	ld.sis	bc, 140
	call	__smulu
	ld	de, (ix - 3)
	ld	(ix - 109), de
                                        ; kill: def $d killed $d killed $de def $de
	ld	e, h
	ld	bc, 0
	ld	c, e
	ld	b, d
	ld	de, -139
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	or	a, a
	sbc	hl, bc
	ld	iy, (ix - 118)
	ld	(iy + 44), hl
	.local	.LBB10_27
.LBB10_27:                              ;   in Loop: Header=BB10_12 Depth=1
	ld	de, 3
	ld	iy, (ix - 124)
	add	iy, de
	ld	de, 18
	jp	.LBB10_12
	.local	.LBB10_28
.LBB10_28:
	ld	hl, (ix + 21)
	push	hl
	pop	iy
	ld	hl, (ix - 115)
	ld	(iy + 23), hl
	ld	de, 1895
	ld	hl, (ix + 15)
	push	hl
	pop	iy
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, 256
	ld	iy, (ix - 109)
	ld	a, iyh
	call	__ldivs
	ld	(ix - 112), hl
	ld	iy, (ix + 6)
	ld	hl, (iy + 15)
	ld	e, (iy + 18)
	ld	bc, 118
	ld	iy, (ix - 109)
	ld	a, iyh
	call	__lmulu
	ld	bc, 12800
	call	__ldivs
	ld	de, (ix - 112)
	add	hl, de
	push	hl
	pop	bc
	ld	(ix - 109), bc
	ld	iy, (ix + 6)
	ld	de, (iy + 23)
	ld	a, d
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, e
	ld	e, (ix + 24)
	push	de
	push	bc
	push	hl
	pea	ix - 106
	call	__ZN5rally3r1810playerPoseEiib
	ld	de, (ix - 109)
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	iy, (ix + 21)
	ld	(iy + 19), de
	or	a, a
	sbc	hl, hl
	ld	l, (ix - 106)
	ld	(iy + 13), hl
	ld	a, (ix - 105)
	ld	(iy + 22), a
	bit	0, a
	ld	hl, -51
	jr	z, .LBB10_30
; %bb.29:
	ld	hl, -50
	.local	.LBB10_30
.LBB10_30:
	add	hl, de
	ld	iy, (ix + 21)
	ld	(iy + 16), hl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end10
.Lfunc_end10:
	.size	__ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb, .Lfunc_end10-__ZN5rally4game16prepareGameSceneINS_10DirectRoadEEEvRNS_6MotionERNS_7TrafficERKNS0_11RaceTrafficERT_RNS_14SceneryHistoryERVNS_3r1810SceneStateEb
                                        ; -- End function
	.weak	__ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_ ; -- Begin function _ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_
	.type	__ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_,@function
__ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_: ; @_ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_
	.local	.Lfunc_begin11
.Lfunc_begin11:
; %bb.0:
	ld	hl, -50
	call	__frameset
	ld	iy, (ix + 6)
	ld	de, 0
	ld	bc, 100
	xor	a, a
	lea	hl, ix - 12
	ld	(ix - 41), hl
	ld	(iy + 24), de
	ld	hl, (ix + 9)
	ld	iy, (hl)
	ld	hl, (iy + 6)
	ld	d, (iy + 9)
	push	hl
	pop	iy
	ld	e, d
	call	__lmulu
	ld	(ix - 15), hl
	ld	(ix - 16), e                    ; 1-byte Folded Spill
	lea	hl, iy + 0
	ld	e, d
	ld	bc, 480
	call	__ldivs
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix + 9)
	ex	de, hl
	push	de
	pop	iy
	ld	hl, (iy + 7)
	ld	e, (iy + 10)
	push	bc
	pop	iy
	ld	(ix - 23), a                    ; 1-byte Folded Spill
	call	__lmulu
	ld	bc, (ix - 15)
	ld	a, (ix - 16)                    ; 1-byte Folded Reload
	call	__ldivs
	ld	de, -1
	lea	bc, iy + 0
	ld	(ix - 19), bc
	add	hl, bc
	ld	(ix - 26), hl
	.local	.LBB11_1
.LBB11_1:                               ; =>This Inner Loop Header: Depth=1
	ld	bc, 3
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jp	z, .LBB11_17
; %bb.2:                                ;   in Loop: Header=BB11_1 Depth=1
	ld	hl, (ix - 26)
	ld	(ix - 22), de
	add	hl, de
	ld	bc, (ix - 19)
	call	__irems
	push	hl
	pop	bc
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	iy
	ld	hl, (ix - 15)
	ld	d, (ix - 16)                    ; 1-byte Folded Reload
	ld	e, d
	ld	(ix - 44), bc
	ld	a, iyl
	call	__lmulu
	ld	bc, (ix - 19)
	ld	a, (ix - 23)                    ; 1-byte Folded Reload
	call	__ldivs
	ld	bc, 24000
	xor	a, a
	call	__ladd
	ld	bc, (ix - 15)
	ld	a, d
	call	__lrems
	call	__lcmpzero
	ld	a, 1
	jp	m, .LBB11_4
; %bb.3:                                ;   in Loop: Header=BB11_1 Depth=1
	ld	a, 0
	.local	.LBB11_4
.LBB11_4:                               ;   in Loop: Header=BB11_1 Depth=1
	bit	0, a
	ld	bc, (ix - 15)
	jr	nz, .LBB11_6
; %bb.5:                                ;   in Loop: Header=BB11_1 Depth=1
	ld	bc, 0
	.local	.LBB11_6
.LBB11_6:                               ;   in Loop: Header=BB11_1 Depth=1
	ld	(ix - 29), bc
	bit	0, a
	ld	a, (ix - 16)                    ; 1-byte Folded Reload
	jr	nz, .LBB11_8
; %bb.7:                                ;   in Loop: Header=BB11_1 Depth=1
	xor	a, a
	.local	.LBB11_8
.LBB11_8:                               ;   in Loop: Header=BB11_1 Depth=1
	ld	(ix - 32), a
	ld	iy, (ix + 9)
	ld	bc, (iy + 7)
	ld	(ix - 35), bc
	ld	a, (iy + 10)
	ld	(ix - 38), a
	ld	iy, (ix - 15)
	lea	bc, iy + 0
	ld	d, (ix - 16)                    ; 1-byte Folded Reload
	ld	a, d
	call	__ladd
	ld	bc, (ix - 35)
	ld	a, (ix - 38)                    ; 1-byte Folded Reload
	call	__lsub
	ld	bc, (ix - 29)
	ld	a, (ix - 32)                    ; 1-byte Folded Reload
	call	__ladd
	lea	bc, iy + 0
	ld	a, d
	call	__lrems
	push	hl
	pop	iy
	ld	bc, -50100
	ld	a, -1
	call	__ladd
	ld	bc, -43700
	call	__lcmpu
	jp	c, .LBB11_16
; %bb.9:                                ;   in Loop: Header=BB11_1 Depth=1
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld.sis	bc, 100
	call	__sdivu
	ld	c, l
	ld	b, h
	ld.sis	hl, 8000
	call	__sdivu
	ld	e, l
	ld	d, h
	ld	(ix - 29), de
	or	a, a
	sbc	hl, hl
	ld	l, e
	ld	h, d
	push	hl
	pop	iy
	ld	de, 96
	add	iy, de
	ld	c, 1
	call	__ishl
	ld	(ix - 32), hl
	ld	hl, (ix - 29)
	call	__sshru
	ld	bc, 0
	ld	c, l
	ld	b, h
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	ld	(ix - 35), hl
	ld	de, 104
	or	a, a
	sbc	hl, de
	jp	c, .LBB11_16
; %bb.10:                               ;   in Loop: Header=BB11_1 Depth=1
	ld	(ix - 38), bc
	ld	hl, (ix - 44)
	ld	bc, 1
	call	__iand
	ld	(ix - 50), hl
	push	iy
	ld	hl, (ix + 12)
	push	hl
	call	__ZNK5rally10DirectRoad8centerAtEi
	ld	(ix - 47), hl
	pop	hl
	pop	hl
	ld	hl, (ix - 50)
	bit	0, l
	ld.sis	bc, 134
	jr	z, .LBB11_12
; %bb.11:                               ;   in Loop: Header=BB11_1 Depth=1
	ld.sis	bc, -134
	.local	.LBB11_12
.LBB11_12:                              ;   in Loop: Header=BB11_1 Depth=1
	ld	iy, (ix - 29)
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	call	__smulu
	ld.sis	bc, 50
	call	__sdivs
	ld	c, l
	ld	b, h
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	de
	ld	d, a
	ld	e, c
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld	c, 2
	call	__sshru
	ld	bc, 0
	ld	c, l
	ld	b, h
	ex	de, hl
	or	a, a
	sbc	hl, bc
	ld	de, (ix - 47)
	add	hl, de
	push	hl
	pop	iy
	ld	de, (ix - 38)
	add	iy, de
	ld	(ix - 29), hl
	ld	de, 320
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB11_16
; %bb.13:                               ;   in Loop: Header=BB11_1 Depth=1
	lea	hl, iy + 0
	ld	de, 1
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	m, .LBB11_16
; %bb.14:                               ;   in Loop: Header=BB11_1 Depth=1
	ld	iy, (ix + 6)
	ld	de, (iy + 24)
	push	de
	pop	hl
	ld	bc, 2
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB11_16
; %bb.15:                               ;   in Loop: Header=BB11_1 Depth=1
	ld	hl, (ix - 44)
	ld	bc, 8
	call	__irems
	ld	bc, 120
	add	hl, bc
	ld	(ix - 38), hl
	push	de
	pop	hl
	inc	hl
	ld	iy, (ix + 6)
	ld	(iy + 24), hl
	ex	de, hl
	ld	bc, 12
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	ld	hl, (ix - 29)
	ld	(iy), hl
	ld	hl, (ix - 35)
	ld	(iy + 3), hl
	ld	hl, (ix - 32)
	ld	(iy + 6), hl
	ld	hl, (ix - 38)
	ld	(iy + 9), hl
	.local	.LBB11_16
.LBB11_16:                              ;   in Loop: Header=BB11_1 Depth=1
	ld	de, (ix - 22)
	inc	de
	jp	.LBB11_1
	.local	.LBB11_17
.LBB11_17:
	ld	iy, (ix + 6)
	ld	hl, (iy + 24)
	ld	de, 2
	or	a, a
	sbc	hl, de
	jr	nz, .LBB11_20
; %bb.18:
	ld	de, (iy + 6)
	ld	hl, (iy + 18)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB11_20
; %bb.19:
	lea	hl, iy + 0
	lea	iy, iy + 12
	ld	de, (ix - 41)
	ld	bc, 12
	ldir
	ld	de, (ix + 6)
	lea	hl, iy + 0
	ld	bc, 12
	ldir
	lea	de, iy + 0
	ld	hl, (ix - 41)
	ld	bc, 12
	ldir
	.local	.LBB11_20
.LBB11_20:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end11
.Lfunc_end11:
	.size	__ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_, .Lfunc_end11-__ZN5rally4game10Billboards7prepareINS_10DirectRoadEEEvRKNS_6MotionERKT_
                                        ; -- End function
	.weak	__ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b ; -- Begin function _ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b
	.type	__ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b,@function
__ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b: ; @_ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b
	.local	.Lfunc_begin12
.Lfunc_begin12:
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	iy, (ix + 9)
	ld	a, (ix + 15)
	ld	de, 0
	ld	bc, 4096
	lea	hl, iy + 0
	add	hl, bc
	ld	(ix - 9), hl
	ld	(hl), de
	lea	hl, iy + 0
	ld	bc, 4099
	add	hl, bc
	ld	(hl), d
	ld	bc, 2164
	ld	hl, (ix + 6)
	add	hl, bc
	ld	(hl), de
	bit	0, a
	jr	z, .LBB12_2
; %bb.1:
	ld	bc, 103
	ld	hl, 4
	push	hl
	push	bc
	ld	hl, 319
	push	hl
	push	de
	push	de
	push	iy
	call	__ZN5rally6Stream4rectEiiiii
	ld	de, 0
	ld	iy, (ix + 9)
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB12_2
.LBB12_2:
	ld	hl, 2
	push	hl
	ld	hl, 223
	push	hl
	ld	hl, 319
	push	hl
	ld	hl, 104
	push	hl
	push	de
	push	iy
	call	__ZN5rally6Stream4rectEiiiii
	ld	de, 104
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB12_3
.LBB12_3:                               ; =>This Inner Loop Header: Depth=1
	ld	bc, 224
	ld	hl, (ix - 9)
	ld	iy, (hl)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	lea	hl, iy + 0
	jp	p, .LBB12_13
; %bb.4:                                ;   in Loop: Header=BB12_3 Depth=1
	ld	bc, -3942
	add	hl, bc
	ld	bc, -4097
	or	a, a
	sbc	hl, bc
	ld	(ix - 3), de
	jr	nc, .LBB12_6
; %bb.5:                                ;   in Loop: Header=BB12_3 Depth=1
	push	iy
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 12)
	call	__indcallhl
	pop	hl
	pop	hl
	ld	hl, (ix + 9)
	ld	de, 4096
	add	hl, de
	ld	de, 0
	ld	(hl), de
	ld	de, (ix - 3)
	.local	.LBB12_6
.LBB12_6:                               ;   in Loop: Header=BB12_3 Depth=1
	push	de
	ld	hl, (ix + 6)
	push	hl
	call	__ZNK5rally4Road7bandEndEi
	ld	iy, (ix + 6)
	push	hl
	pop	de
	pop	hl
	pop	hl
	inc	de
	lea	hl, iy + 0
	ld	bc, (ix - 3)
	add	hl, bc
	ld	bc, 1939
	add	hl, bc
	ld	(ix - 12), hl
	bit	0, (hl)
	ld	hl, 15
	jr	z, .LBB12_8
; %bb.7:                                ;   in Loop: Header=BB12_3 Depth=1
	ld	hl, 9
	.local	.LBB12_8
.LBB12_8:                               ;   in Loop: Header=BB12_3 Depth=1
	push	hl
	ld	hl, 106
	push	hl
	ld	hl, -106
	push	hl
	push	de
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 9)
	push	hl
	push	iy
	ld	(ix - 6), de
	call	__ZNK5rally4Road5stripERNS_6StreamEiiiii
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	ld	hl, 8
	push	hl
	ld	hl, 90
	push	hl
	ld	hl, -90
	push	hl
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZNK5rally4Road5stripERNS_6StreamEiiiii
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 12)
	bit	0, (hl)
	ld	hl, 15
	jr	z, .LBB12_10
; %bb.9:                                ;   in Loop: Header=BB12_3 Depth=1
	ld	hl, 11
	.local	.LBB12_10
.LBB12_10:                              ;   in Loop: Header=BB12_3 Depth=1
	push	hl
	ld	hl, -84
	push	hl
	ld	hl, -86
	push	hl
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZNK5rally4Road5stripERNS_6StreamEiiiii
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 12)
	bit	0, (hl)
	ld	hl, 15
	jr	z, .LBB12_12
; %bb.11:                               ;   in Loop: Header=BB12_3 Depth=1
	ld	hl, 11
	.local	.LBB12_12
.LBB12_12:                              ;   in Loop: Header=BB12_3 Depth=1
	push	hl
	ld	hl, 86
	push	hl
	ld	hl, 84
	push	hl
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZNK5rally4Road5stripERNS_6StreamEiiiii
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix - 12)
	bit	0, (hl)
	ld	hl, 11
	push	hl
	ld	hl, 2
	push	hl
	ld	hl, -2
	push	hl
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	nz, __ZNK5rally4Road5stripERNS_6StreamEiiiii
	ld	hl, 21
	add	hl, sp
	ld	sp, hl
	ld	hl, (ix + 6)
	ld	de, 2164
	add	hl, de
	ld	de, (hl)
	inc	de
	ld	(hl), de
	ld	de, (ix - 6)
	jp	.LBB12_3
	.local	.LBB12_13
.LBB12_13:
	ld	de, -4082
	add	hl, de
	ld	de, -4097
	or	a, a
	sbc	hl, de
	jr	nc, .LBB12_15
; %bb.14:
	push	iy
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 12)
	call	__indcallhl
	pop	hl
	pop	hl
	ld	hl, (ix + 9)
	ld	de, 4096
	add	hl, de
	ld	de, 0
	ld	(hl), de
	.local	.LBB12_15
.LBB12_15:
	or	a, a
	sbc	hl, hl
	push	hl
	ld	de, 239
	push	de
	ld	de, 319
	push	de
	ld	de, 224
	push	de
	push	hl
	ld	hl, (ix + 9)
	push	hl
	call	__ZN5rally6Stream4rectEiiiii
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (ix - 9)
	ld	hl, (hl)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB12_17
; %bb.16:
	push	hl
	ld	hl, (ix + 9)
	push	hl
	ld	hl, (ix + 12)
	call	__indcallhl
	pop	hl
	pop	hl
	.local	.LBB12_17
.LBB12_17:
	ld	de, 4096
	ld	hl, (ix + 9)
	push	hl
	pop	iy
	add	iy, de
	or	a, a
	sbc	hl, hl
	ld	(iy), hl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end12
.Lfunc_end12:
	.size	__ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b, .Lfunc_end12-__ZN5rally10DirectRoad6emitToIPFvPKhjEEEvRNS_6StreamET_b
                                        ; -- End function
	.weak	__ZN5rally4game8viewportERNS_6StreamEiiii ; -- Begin function _ZN5rally4game8viewportERNS_6StreamEiiii
	.type	__ZN5rally4game8viewportERNS_6StreamEiiii,@function
__ZN5rally4game8viewportERNS_6StreamEiiii: ; @_ZN5rally4game8viewportERNS_6StreamEiiii
	.local	.Lfunc_begin13
.Lfunc_begin13:
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
	jr	nc, .LBB13_2
; %bb.1:
	ld	hl, (ix - 3)
	add	hl, de
	push	hl
	pop	iy
	inc	de
	ld	hl, (ix - 18)
	ld	(hl), de
	ld	(iy), 24
	jr	.LBB13_3
	.local	.LBB13_2
.LBB13_2:
	ld	de, 4099
	ld	hl, (ix - 3)
	add	hl, de
	ld	(hl), 1
	.local	.LBB13_3
.LBB13_3:
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
	.local	.Lfunc_end13
.Lfunc_end13:
	.size	__ZN5rally4game8viewportERNS_6StreamEiiii, .Lfunc_end13-__ZN5rally4game8viewportERNS_6StreamEiiii
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_15flushEv,@function ; -- Begin function _ZN12_GLOBAL__N_15flushEv
__ZN12_GLOBAL__N_15flushEv:             ; @_ZN12_GLOBAL__N_15flushEv
	.local	.Lfunc_begin14
.Lfunc_begin14:
; %bb.0:
	ld	hl, __ZN12_GLOBAL__N_16streamE
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	push	hl
	call	__ZN12_GLOBAL__N_14sendEPKhj
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	ld	(__ZN12_GLOBAL__N_16streamE+4096), hl
	xor	a, a
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	ret
	.local	.Lfunc_end14
.Lfunc_end14:
	.size	__ZN12_GLOBAL__N_15flushEv, .Lfunc_end14-__ZN12_GLOBAL__N_15flushEv
                                        ; -- End function
	.weak	__ZN5rally4game11saveRecordsERKNS0_7RecordsE ; -- Begin function _ZN5rally4game11saveRecordsERKNS0_7RecordsE
	.type	__ZN5rally4game11saveRecordsERKNS0_7RecordsE,@function
__ZN5rally4game11saveRecordsERKNS0_7RecordsE: ; @_ZN5rally4game11saveRecordsERKNS0_7RecordsE
	.local	.Lfunc_begin15
.Lfunc_begin15:
; %bb.0:
	ld	hl, -2314
	call	__frameset
	ld	hl, (ix + 6)
	ld	de, _.str.58
	xor	a, a
	ld	bc, -2311
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), a
	push	hl
	push	de
	call	__ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE
	pop	hl
	pop	hl
	bit	0, a
	jp	z, .LBB15_7
; %bb.1:
	ld	bc, -2310
	lea	hl, ix + 0
	add	hl, bc
	push	hl
	pop	iy
	lea	de, iy + 0
	ld	(iy + 0), 0
	push	de
	pop	iy
	inc	de
	ld	bc, 2303
	lea	hl, iy + 0
	ldir
	ld	bc, -2314
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	push	iy
	ld	hl, _.str.11
	push	hl
	call	__ZN5rally4game11readRecordsEPKcRNS0_7RecordsE
	pop	hl
	pop	hl
	bit	0, a
	jr	z, .LBB15_3
; %bb.2:
	ld	hl, _.str.12
	ld	bc, -2314
	lea	iy, ix + 0
	add	iy, bc
	ld	de, (iy + 0)
	push	de
	push	hl
	call	__ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE
	pop	hl
	pop	hl
	bit	0, a
	jr	z, .LBB15_10
	.local	.LBB15_3
.LBB15_3:
	ld	hl, _.str.15
	push	hl
	ld	hl, _.str.11
	push	hl
	call	_fopen
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB15_5
; %bb.4:
	push	hl
	call	_fclose
	pop	hl
	ld	hl, _.str.11
	push	hl
	call	_remove
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB15_10
	.local	.LBB15_5
.LBB15_5:
	ld	hl, _.str.11
	push	hl
	ld	hl, _.str.58
	push	hl
	call	_mos_ren
	pop	hl
	pop	hl
	or	a, a
	jr	z, .LBB15_8
; %bb.6:
	ld	a, 0
	jr	.LBB15_9
	.local	.LBB15_7
.LBB15_7:
	xor	a, a
	jr	.LBB15_11
	.local	.LBB15_8
.LBB15_8:
	ld	a, -1
	.local	.LBB15_9
.LBB15_9:
	ld	bc, -2311
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), a
	.local	.LBB15_10
.LBB15_10:
	ld	bc, -2311
	lea	hl, ix + 0
	add	hl, bc
	ld	a, (hl)                         ; 1-byte Folded Reload
	.local	.LBB15_11
.LBB15_11:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end15
.Lfunc_end15:
	.size	__ZN5rally4game11saveRecordsERKNS0_7RecordsE, .Lfunc_end15-__ZN5rally4game11saveRecordsERKNS0_7RecordsE
                                        ; -- End function
	.weak	__ZN5rally4game6Engine4stopIPFvPKhjEEEvT_ ; -- Begin function _ZN5rally4game6Engine4stopIPFvPKhjEEEvT_
	.type	__ZN5rally4game6Engine4stopIPFvPKhjEEEvT_,@function
__ZN5rally4game6Engine4stopIPFvPKhjEEEvT_: ; @_ZN5rally4game6Engine4stopIPFvPKhjEEEvT_
	.local	.Lfunc_begin16
.Lfunc_begin16:
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	hl, (ix + 6)
	bit	0, (hl)
	jr	z, .LBB16_2
; %bb.1:
	ld	hl, ___const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute
	ld	bc, 6
	lea	iy, ix - 6
	lea	de, iy + 0
	ldir
	ld	hl, 6
	push	hl
	push	iy
	ld	hl, (ix + 9)
	call	__indcallhl
	pop	hl
	pop	hl
	ld	hl, (ix + 6)
	ld	(hl), 0
	.local	.LBB16_2
.LBB16_2:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end16
.Lfunc_end16:
	.size	__ZN5rally4game6Engine4stopIPFvPKhjEEEvT_, .Lfunc_end16-__ZN5rally4game6Engine4stopIPFvPKhjEEEvT_
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_14fontEj,@function ; -- Begin function _ZN12_GLOBAL__N_14fontEj
__ZN12_GLOBAL__N_14fontEj:              ; @_ZN12_GLOBAL__N_14fontEj
	.local	.Lfunc_begin17
.Lfunc_begin17:
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
	call	__ZN12_GLOBAL__N_14sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end17
.Lfunc_end17:
	.size	__ZN12_GLOBAL__N_14fontEj, .Lfunc_end17-__ZN12_GLOBAL__N_14fontEj
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.type	_main,@function
_main:                                  ; @main
	.local	.Lfunc_begin18
.Lfunc_begin18:
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	hl, (ix + 6)
	ld	de, (ix + 9)
	push	de
	push	hl
	call	__Z8gameMainiPPc
	ld	(ix - 3), hl
	pop	hl
	pop	hl
	ld	hl, __ZN12_GLOBAL__N_14sendEPKhj
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16engineE
	push	hl
	call	__ZN5rally4game6Engine4stopIPFvPKhjEEEvT_
	pop	hl
	pop	hl
	ld	hl, (ix - 3)
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end18
.Lfunc_end18:
	.size	_main, .Lfunc_end18-_main
                                        ; -- End function
	.weak	__ZN5rally4game7Records6decodeEPKhj ; -- Begin function _ZN5rally4game7Records6decodeEPKhj
	.type	__ZN5rally4game7Records6decodeEPKhj,@function
__ZN5rally4game7Records6decodeEPKhj:    ; @_ZN5rally4game7Records6decodeEPKhj
	.local	.Lfunc_begin19
.Lfunc_begin19:
; %bb.0:
	ld	hl, -13
	call	__frameset
	ld	hl, (ix + 12)
	ld	d, 0
	ld	bc, 2320
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB19_9
; %bb.1:
	ld	bc, (ix + 9)
	ld	hl, _.str.16
	ld	de, 8
	push	de
	push	hl
	push	bc
	call	_memcmp
	pop	de
	pop	de
	pop	de
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB19_8
; %bb.2:
	ld	iy, (ix + 9)
	pea	iy + 8
	call	__ZN5rally4game7Records5get32EPKh
	pop	bc
	ld	bc, 288
	ld	d, 0
	ld	a, d
	call	__lcmpu
	jp	nz, .LBB19_9
; %bb.3:
	ld	hl, (ix + 9)
	push	hl
	pop	iy
	pea	iy + 12
	call	__ZN5rally4game7Records5get32EPKh
	ld	(ix - 3), hl
	ld	(ix - 6), e                     ; 1-byte Folded Spill
	pop	hl
	ld	hl, 2304
	push	hl
	ld	iy, (ix + 9)
	pea	iy + 16
	call	__ZN5rally4game7Records4hashEPKhj
	push	hl
	pop	bc
	ld	a, e
	pop	hl
	pop	hl
	ld	hl, (ix - 3)
	ld	e, (ix - 6)                     ; 1-byte Folded Reload
	call	__lcmpu
	jr	nz, .LBB19_8
; %bb.4:
	ld	de, -2312
	.local	.LBB19_5
.LBB19_5:                               ; =>This Inner Loop Header: Depth=1
	push	de
	pop	hl
	ld	bc, 8
	add	hl, bc
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB19_10
; %bb.6:                                ;   in Loop: Header=BB19_5 Depth=1
	ld	(ix - 3), hl
	ld	hl, (ix + 9)
	push	hl
	pop	iy
	add	iy, de
	ld	(ix - 6), iy
	ld	de, 2328
	add	iy, de
	push	iy
	call	__ZN5rally4game7Records5get32EPKh
	push	hl
	pop	bc
	ld	a, e
	pop	hl
	ld	hl, -6777217
	ld	d, 0
	ld	e, d
	call	__lcmpu
	jr	c, .LBB19_9
; %bb.7:                                ;   in Loop: Header=BB19_5 Depth=1
	ld	bc, 2332
	ld	hl, (ix - 6)
	add	hl, bc
	push	hl
	call	__ZN5rally4game7Records5get32EPKh
	push	hl
	pop	bc
	ld	a, e
	pop	hl
	ld	hl, 216000
	ld	e, 0
	call	__lcmpu
	ld	de, (ix - 3)
	jr	nc, .LBB19_5
	.local	.LBB19_8
.LBB19_8:
	ld	d, 0
	.local	.LBB19_9
.LBB19_9:
	ld	a, d
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB19_10
.LBB19_10:
	ld	de, 2304
	ld	iy, 0
	.local	.LBB19_11
.LBB19_11:                              ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jr	z, .LBB19_13
; %bb.12:                               ;   in Loop: Header=BB19_11 Depth=1
	lea	de, iy + 0
	ld	(ix - 9), de
	ld	hl, (ix + 9)
	add	hl, de
	ld	(ix - 3), hl
	lea	hl, iy + 0
	ld	iy, (ix - 3)
	pea	iy + 16
	ld	(ix - 6), hl
	call	__ZN5rally4game7Records5get32EPKh
	ld	(ix - 12), hl
	ld	(ix - 13), e                    ; 1-byte Folded Spill
	pop	hl
	ld	iy, (ix - 3)
	pea	iy + 20
	call	__ZN5rally4game7Records5get32EPKh
	pop	bc
	ld	iy, (ix + 6)
	ld	bc, (ix - 9)
	add	iy, bc
	ld	bc, (ix - 12)
	ld	(iy), bc
	ld	a, (ix - 13)
	ld	(iy + 3), a
	ld	(iy + 4), hl
	ld	(iy + 7), e
	ld	iy, (ix - 6)
	ld	de, 8
	add	iy, de
	ld	de, 2304
	jr	.LBB19_11
	.local	.LBB19_13
.LBB19_13:
	ld	d, 1
	jp	.LBB19_9
	.local	.Lfunc_end19
.Lfunc_end19:
	.size	__ZN5rally4game7Records6decodeEPKhj, .Lfunc_end19-__ZN5rally4game7Records6decodeEPKhj
                                        ; -- End function
	.weak	__ZN5rally4game7Records5get32EPKh ; -- Begin function _ZN5rally4game7Records5get32EPKh
	.type	__ZN5rally4game7Records5get32EPKh,@function
__ZN5rally4game7Records5get32EPKh:      ; @_ZN5rally4game7Records5get32EPKh
	.local	.Lfunc_begin20
.Lfunc_begin20:
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	de, (ix + 6)
	ld	iy, 0
	xor	a, a
	ld	bc, 32
	ld	(ix - 3), iy
	.local	.LBB20_1
.LBB20_1:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jr	z, .LBB20_3
; %bb.2:                                ;   in Loop: Header=BB20_1 Depth=1
	ld	bc, 0
	ex	de, hl
	ld	(ix - 6), hl
	ld	c, (hl)
	ld	d, a
	xor	a, a
	ex	de, hl
	ld	e, iyl
	ex	de, hl
	call	__lshl
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 3)
	ld	a, d
	call	__lor
	ld	bc, 32
	ld	(ix - 3), hl
	ld	a, e
	ld	de, 8
	add	iy, de
	ld	de, (ix - 6)
	inc	de
	jr	.LBB20_1
	.local	.LBB20_3
.LBB20_3:
	ld	hl, (ix - 3)
	ld	e, a
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end20
.Lfunc_end20:
	.size	__ZN5rally4game7Records5get32EPKh, .Lfunc_end20-__ZN5rally4game7Records5get32EPKh
                                        ; -- End function
	.weak	__ZN5rally4game7Records4hashEPKhj ; -- Begin function _ZN5rally4game7Records4hashEPKhj
	.type	__ZN5rally4game7Records4hashEPKhj,@function
__ZN5rally4game7Records4hashEPKhj:      ; @_ZN5rally4game7Records4hashEPKhj
	.local	.Lfunc_begin21
.Lfunc_begin21:
; %bb.0:
	ld	hl, -6
	call	__frameset
	ld	iy, (ix + 6)
	ld	bc, (ix + 9)
	ld	d, 1
	ld	hl, 1875397
	ld	(ix - 3), hl
	ld	e, -127
	.local	.LBB21_1
.LBB21_1:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	z, .LBB21_3
; %bb.2:                                ;   in Loop: Header=BB21_1 Depth=1
	ld	(ix - 6), bc
	ld	bc, 0
	ld	c, (iy)
	xor	a, a
	ld	hl, (ix - 3)
	call	__lxor
	ld	bc, 403
	ld	a, d
	call	__lmulu
	ld	bc, (ix - 6)
	ld	(ix - 3), hl
	dec	bc
	inc	iy
	jr	.LBB21_1
	.local	.LBB21_3
.LBB21_3:
	ld	hl, (ix - 3)
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end21
.Lfunc_end21:
	.size	__ZN5rally4game7Records4hashEPKhj, .Lfunc_end21-__ZN5rally4game7Records4hashEPKhj
                                        ; -- End function
	.weak	__ZN5rally4Road4initEv          ; -- Begin function _ZN5rally4Road4initEv
	.type	__ZN5rally4Road4initEv,@function
__ZN5rally4Road4initEv:                 ; @_ZN5rally4Road4initEv
	.local	.Lfunc_begin22
.Lfunc_begin22:
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	iy, (ix + 6)
	ld	bc, 1
	ld	de, 523
	add	iy, de
	ld	de, 0
	ld	(iy), de
	lea	hl, iy + 3
	ld	(hl), b
	ld	iy, (ix + 6)
	ld	(iy + 7), de
	ld	(iy + 10), b
	ld	de, 527
	add	iy, de
	ld	de, 129
	.local	.LBB22_1
.LBB22_1:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	z, .LBB22_3
; %bb.2:                                ;   in Loop: Header=BB22_1 Depth=1
	xor	a, a
	ld	hl, 800000
	ld	d, a
	ld	e, d
	call	__ldivu
	ld	a, e
	ld	(ix - 3), iy
	ld	de, -516
	add	iy, de
	ld	(iy), hl
	lea	hl, iy + 3
	ld	(hl), a
	ld	hl, 2048000
	ld	e, l
	xor	a, a
	call	__ldivu
	ld	iy, (ix - 3)
	ld	(iy), hl
	ld	(iy + 3), e
	ld	de, 129
	inc	bc
	lea	iy, iy + 4
	jr	.LBB22_1
	.local	.LBB22_3
.LBB22_3:
	pop	hl
	pop	ix
	ret
	.local	.Lfunc_end22
.Lfunc_end22:
	.size	__ZN5rally4Road4initEv, .Lfunc_end22-__ZN5rally4Road4initEv
                                        ; -- End function
	.weak	__ZN5rally9carColourEhj         ; -- Begin function _ZN5rally9carColourEhj
	.type	__ZN5rally9carColourEhj,@function
__ZN5rally9carColourEhj:                ; @_ZN5rally9carColourEhj
	.local	.Lfunc_begin23
.Lfunc_begin23:
; %bb.0:
	call	__frameset0
	ld	a, (ix + 6)
	ld	de, (ix + 9)
	ld	bc, -7
	push	de
	pop	hl
	add	hl, bc
	inc	bc
	or	a, a
	sbc	hl, bc
	jp	c, .LBB23_14
; %bb.1:
	ld	iy, __ZZN5rally9carColourEhjE7colours
	dec	de
	cp	a, -62
	jr	nz, .LBB23_3
; %bb.2:
	ld	bc, 6
	ex	de, hl
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	jr	.LBB23_13
	.local	.LBB23_3
.LBB23_3:
	cp	a, -61
	jr	nz, .LBB23_5
; %bb.4:
	ld	bc, 6
	ex	de, hl
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	inc	iy
	jr	.LBB23_13
	.local	.LBB23_5
.LBB23_5:
	cp	a, -57
	jr	nz, .LBB23_7
; %bb.6:
	ld	bc, 6
	ex	de, hl
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	lea	iy, iy + 2
	jr	.LBB23_13
	.local	.LBB23_7
.LBB23_7:
	cp	a, -49
	jr	nz, .LBB23_9
; %bb.8:
	ld	bc, 6
	ex	de, hl
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	lea	iy, iy + 3
	jr	.LBB23_13
	.local	.LBB23_9
.LBB23_9:
	cp	a, -17
	jr	nz, .LBB23_11
; %bb.10:
	ld	bc, 6
	ex	de, hl
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	lea	iy, iy + 4
	jr	.LBB23_13
	.local	.LBB23_11
.LBB23_11:
	cp	a, -8
	jr	nz, .LBB23_14
; %bb.12:
	ld	bc, 6
	ex	de, hl
	call	__imulu
	push	hl
	pop	de
	add	iy, de
	lea	iy, iy + 5
	.local	.LBB23_13
.LBB23_13:
	ld	a, (iy)
	.local	.LBB23_14
.LBB23_14:
	pop	ix
	ret
	.local	.Lfunc_end23
.Lfunc_end23:
	.size	__ZN5rally9carColourEhj, .Lfunc_end23-__ZN5rally9carColourEhj
                                        ; -- End function
	.weak	__ZN5rally6Stream4wordEi        ; -- Begin function _ZN5rally6Stream4wordEi
	.type	__ZN5rally6Stream4wordEi,@function
__ZN5rally6Stream4wordEi:               ; @_ZN5rally6Stream4wordEi
	.local	.Lfunc_begin24
.Lfunc_begin24:
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
	jr	nc, .LBB24_3
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
	jr	nc, .LBB24_3
; %bb.2:
	ld	hl, (ix + 9)
	ld	a, h
	ld	hl, (ix + 6)
	add	hl, bc
	inc	bc
	ld	(iy), bc
	ld	(hl), a
	jr	.LBB24_4
	.local	.LBB24_3
.LBB24_3:
	ld	de, 4099
	ld	hl, (ix + 6)
	add	hl, de
	ld	(hl), 1
	.local	.LBB24_4
.LBB24_4:
	pop	ix
	ret
	.local	.Lfunc_end24
.Lfunc_end24:
	.size	__ZN5rally6Stream4wordEi, .Lfunc_end24-__ZN5rally6Stream4wordEi
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_110fontCreateEjj,@function ; -- Begin function _ZN12_GLOBAL__N_110fontCreateEjj
__ZN12_GLOBAL__N_110fontCreateEjj:      ; @_ZN12_GLOBAL__N_110fontCreateEjj
	.local	.Lfunc_begin25
.Lfunc_begin25:
; %bb.0:
	ld	hl, -10
	call	__frameset
	ld	a, (ix + 6)
	ld	e, (ix + 9)
	ld	hl, 10
	ld	(ix - 10), 23
	ld	(ix - 9), h
	ld	(ix - 8), -107
	ld	(ix - 7), 1
	ld	(ix - 6), a
	ld	(ix - 5), -7
	ld	(ix - 4), e
	ld	(ix - 3), e
	dec	e
	ld	(ix - 2), e
	ld	(ix - 1), h
	push	hl
	pea	ix - 10
	call	__ZN12_GLOBAL__N_14sendEPKhj
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end25
.Lfunc_end25:
	.size	__ZN12_GLOBAL__N_110fontCreateEjj, .Lfunc_end25-__ZN12_GLOBAL__N_110fontCreateEjj
                                        ; -- End function
	.weak	__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh ; -- Begin function _ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh
	.type	__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh,@function
__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh: ; @_ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh
	.local	.Lfunc_begin26
.Lfunc_begin26:
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
	.local	.LBB26_1
.LBB26_1:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jp	z, .LBB26_14
; %bb.2:                                ;   in Loop: Header=BB26_1 Depth=1
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
	jp	nz, .LBB26_12
; %bb.3:                                ;   in Loop: Header=BB26_1 Depth=1
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
	jp	m, .LBB26_5
; %bb.4:                                ;   in Loop: Header=BB26_1 Depth=1
	ld	de, 0
	.local	.LBB26_5
.LBB26_5:                               ;   in Loop: Header=BB26_1 Depth=1
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
	jp	m, .LBB26_7
; %bb.6:                                ;   in Loop: Header=BB26_1 Depth=1
	ld	l, 0
	.local	.LBB26_7
.LBB26_7:                               ;   in Loop: Header=BB26_1 Depth=1
	bit	0, l
	jr	nz, .LBB26_9
; %bb.8:                                ;   in Loop: Header=BB26_1 Depth=1
	ld	bc, 0
	.local	.LBB26_9
.LBB26_9:                               ;   in Loop: Header=BB26_1 Depth=1
	bit	0, l
	jr	nz, .LBB26_11
; %bb.10:                               ;   in Loop: Header=BB26_1 Depth=1
	xor	a, a
	.local	.LBB26_11
.LBB26_11:                              ;   in Loop: Header=BB26_1 Depth=1
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
	jr	.LBB26_13
	.local	.LBB26_12
.LBB26_12:                              ;   in Loop: Header=BB26_1 Depth=1
	ld	iy, (ix - 3)
	inc	iy
	.local	.LBB26_13
.LBB26_13:                              ;   in Loop: Header=BB26_1 Depth=1
	ld	de, 6
	ld	bc, 29
	jp	.LBB26_1
	.local	.LBB26_14
.LBB26_14:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end26
.Lfunc_end26:
	.size	__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh, .Lfunc_end26-__ZN5rally4game11RaceTraffic5resetENS0_6PolicyElhh
                                        ; -- End function
	.weak	__ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl ; -- Begin function _ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl
	.type	__ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl,@function
__ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl: ; @_ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl
	.local	.Lfunc_begin27
.Lfunc_begin27:
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	iy, (ix + 6)
	xor	a, a
	sbc	hl, hl
	lea	iy, iy + 8
	.local	.LBB27_1
.LBB27_1:                               ; =>This Inner Loop Header: Depth=1
	ld	bc, 60
	push	hl
	pop	de
	or	a, a
	sbc	hl, bc
	jr	z, .LBB27_5
; %bb.2:                                ;   in Loop: Header=BB27_1 Depth=1
	bit	0, (iy - 8)
	ld	bc, (ix + 12)
	ld	l, (ix + 15)
	jr	z, .LBB27_4
; %bb.3:                                ;   in Loop: Header=BB27_1 Depth=1
	ld	bc, (iy)
	ld	l, (iy + 3)
	.local	.LBB27_4
.LBB27_4:                               ;   in Loop: Header=BB27_1 Depth=1
	ld	(ix - 12), bc
	push	de
	pop	bc
	ld	(ix - 6), bc
	ld	(ix - 3), iy
	ld	iy, (ix + 9)
	add	iy, bc
	ld	(ix - 9), iy
	ld	de, (ix - 12)
	ld	(iy), de
	ld	(iy + 3), l
	ld	iy, (ix - 3)
	ld	hl, (iy + 4)
	ld	iy, (ix - 3)
	ld	e, (iy + 7)
	ld	bc, 256
	call	__ldivs
	ld	iy, (ix - 9)
	ld	(iy + 7), hl
	ld	iy, (ix - 3)
	ld	hl, (ix - 6)
	ld	de, 10
	add	hl, de
	lea	iy, iy + 29
	jr	.LBB27_1
	.local	.LBB27_5
.LBB27_5:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end27
.Lfunc_end27:
	.size	__ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl, .Lfunc_end27-__ZNK5rally4game11RaceTraffic4viewERNS_7TrafficEl
                                        ; -- End function
	.weak	__ZN5rally4game11RaceTraffic5placeEj ; -- Begin function _ZN5rally4game11RaceTraffic5placeEj
	.type	__ZN5rally4game11RaceTraffic5placeEj,@function
__ZN5rally4game11RaceTraffic5placeEj:   ; @_ZN5rally4game11RaceTraffic5placeEj
	.local	.Lfunc_begin28
.Lfunc_begin28:
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	bc, 1
	ld	de, -1
	call	__iand
	bit	0, l
	jr	z, .LBB28_2
; %bb.1:
	push	de
	pop	bc
	.local	.LBB28_2
.LBB28_2:
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
	.local	.Lfunc_end28
.Lfunc_end28:
	.size	__ZN5rally4game11RaceTraffic5placeEj, .Lfunc_end28-__ZN5rally4game11RaceTraffic5placeEj
                                        ; -- End function
	.weak	__ZN5rally4game7Records6updateEjmm ; -- Begin function _ZN5rally4game7Records6updateEjmm
	.type	__ZN5rally4game7Records6updateEjmm,@function
__ZN5rally4game7Records6updateEjmm:     ; @_ZN5rally4game7Records6updateEjmm
	.local	.Lfunc_begin29
.Lfunc_begin29:
; %bb.0:
	ld	hl, -1
	call	__frameset
	ld	iy, (ix + 9)
	ld	e, 0
	ld	d, e
	ld	bc, 288
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	nc, .LBB29_9
; %bb.1:
	ld	bc, (ix + 12)
	ld	hl, -6777217
	ld	a, (ix + 15)
	call	__lcmpu
	jp	c, .LBB29_9
; %bb.2:
	ld	bc, (ix + 18)
	ld	hl, 216000
	ld	a, (ix + 21)
	call	__lcmpu
	jr	c, .LBB29_9
; %bb.3:
	ld	(ix - 1), e                     ; 1-byte Folded Spill
	ld	c, 3
	lea	hl, iy + 0
	call	__ishl
	push	hl
	pop	de
	ld	iy, (ix + 6)
	add	iy, de
	ld	hl, (iy)
	ld	e, (iy + 3)
	ld	bc, (ix + 12)
	ld	a, (ix + 15)
	call	__lcmpu
	jr	nc, .LBB29_5
; %bb.4:
	ld	(iy), bc
	ld	(iy + 3), a
	ld	a, 1
	ld	(ix - 1), a                     ; 1-byte Folded Spill
	.local	.LBB29_5
.LBB29_5:
	ld	hl, (ix + 18)
	ld	e, (ix + 21)
	call	__lcmpzero
	jr	nz, .LBB29_7
; %bb.6:
	ld	d, (ix - 1)                     ; 1-byte Folded Reload
	jr	.LBB29_9
	.local	.LBB29_7
.LBB29_7:
	ld	a, -1
	ld	c, 3
	ld	hl, (ix + 9)
	call	__ishl
	push	hl
	pop	de
	ld	iy, (ix + 6)
	add	iy, de
	ld	hl, (iy + 4)
	ld	e, (iy + 7)
	ld	bc, -1
	call	__ladd
	ld	bc, (ix + 18)
	ld	a, (ix + 21)
	call	__lcmpu
	ld	d, (ix - 1)                     ; 1-byte Folded Reload
	jr	c, .LBB29_9
; %bb.8:
	ld	hl, (ix + 18)
	ld	(iy + 4), hl
	ld	a, (ix + 21)
	ld	(iy + 7), a
	ld	d, 1
	.local	.LBB29_9
.LBB29_9:
	ld	a, d
	inc	sp
	pop	ix
	ret
	.local	.Lfunc_end29
.Lfunc_end29:
	.size	__ZN5rally4game7Records6updateEjmm, .Lfunc_end29-__ZN5rally4game7Records6updateEjmm
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_17pressedEi,@function ; -- Begin function _ZN12_GLOBAL__N_17pressedEi
__ZN12_GLOBAL__N_17pressedEi:           ; @_ZN12_GLOBAL__N_17pressedEi
	.local	.Lfunc_begin30
.Lfunc_begin30:
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 6)
	push	hl
	call	__ZN12_GLOBAL__N_13keyEi
	pop	hl
	bit	0, a
	ld	a, 0
	jr	z, .LBB30_4
; %bb.1:
	ld	bc, 8
	ld	iy, __ZN12_GLOBAL__N_112previousKeysE
	ld	de, (ix + 6)
	dec	de
	push	de
	pop	hl
	call	__idivs
	push	hl
	pop	bc
	add	iy, bc
	ld	a, (iy)
	ld	iyl, a
	ex	de, hl
	ld	bc, 7
	call	__iand
	ld	a, 1
	ld	b, l
	call	__bshl
	and	a, iyl
	or	a, a
	jr	z, .LBB30_3
; %bb.2:
	ld	a, 0
	jr	.LBB30_4
	.local	.LBB30_3
.LBB30_3:
	ld	a, -1
	.local	.LBB30_4
.LBB30_4:
	pop	ix
	ret
	.local	.Lfunc_end30
.Lfunc_end30:
	.size	__ZN12_GLOBAL__N_17pressedEi, .Lfunc_end30-__ZN12_GLOBAL__N_17pressedEi
                                        ; -- End function
	.weak	__ZN5rally4game5Rules7attemptEmNS0_8SettingsEi ; -- Begin function _ZN5rally4game5Rules7attemptEmNS0_8SettingsEi
	.type	__ZN5rally4game5Rules7attemptEmNS0_8SettingsEi,@function
__ZN5rally4game5Rules7attemptEmNS0_8SettingsEi: ; @_ZN5rally4game5Rules7attemptEmNS0_8SettingsEi
	.local	.Lfunc_begin31
.Lfunc_begin31:
; %bb.0:
	call	__frameset0
	ld	iy, (ix + 6)
	ld	a, (ix + 12)
	lea	hl, ix + 15
	ld	bc, 9
	lea	de, iy + 0
	ldir
	ld	hl, (ix + 9)
	ld	(iy + 47), hl
	ld	(iy + 50), a
	lea	hl, iy + 27
	ld	(iy + 27), 0
	push	hl
	pop	de
	inc	de
	ld	bc, 15
	ldir
	ld	(iy + 61), 7
	ld	(iy + 60), 7
	ld	hl, (ix + 24)
	ld	(iy + 62), hl
	or	a, a
	sbc	hl, hl
	ld	(iy + 43), hl
	ld	(iy + 46), h
	ld	(iy + 15), hl
	ld	(iy + 18), h
	ld	(iy + 23), hl
	ld	(iy + 26), h
	ld	(iy + 59), h
	ld	(iy + 51), hl
	ld	(iy + 54), h
	ld	(iy + 57), l
	ld	(iy + 58), h
	ld	de, (iy)
	ld	l, e
	ld	h, d
	xor	a, a
	ld	e, a
	ld	bc, 120
	call	__lmulu
	ld	(iy + 19), hl
	ld	(iy + 22), e
	ld	(iy + 10), 2
	or	a, a
	sbc	hl, hl
	ld	(iy + 11), hl
	ld	(iy + 14), a
	ld	hl, (iy + 55)
	inc.sis	hl
	ld	(iy + 55), l
	ld	(iy + 56), h
	pop	ix
	ret
	.local	.Lfunc_end31
.Lfunc_end31:
	.size	__ZN5rally4game5Rules7attemptEmNS0_8SettingsEi, .Lfunc_end31-__ZN5rally4game5Rules7attemptEmNS0_8SettingsEi
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_13keyEi,@function ; -- Begin function _ZN12_GLOBAL__N_13keyEi
__ZN12_GLOBAL__N_13keyEi:               ; @_ZN12_GLOBAL__N_13keyEi
	.local	.Lfunc_begin32
.Lfunc_begin32:
; %bb.0:
	call	__frameset0
	ld	de, (ix + 6)
	ld	bc, 8
	ld	iy, __ZN12_GLOBAL__N_18heldKeysE
	dec	de
	push	de
	pop	hl
	call	__idivs
	push	hl
	pop	bc
	add	iy, bc
	ld	a, (iy)
	ld	iyl, a
	ex	de, hl
	ld	bc, 7
	call	__iand
	ld	a, 1
	ld	b, l
	call	__bshl
	and	a, iyl
	or	a, a
	jr	nz, .LBB32_2
; %bb.1:
	ld	a, 0
	jr	.LBB32_3
	.local	.LBB32_2
.LBB32_2:
	ld	a, -1
	.local	.LBB32_3
.LBB32_3:
	pop	ix
	ret
	.local	.Lfunc_end32
.Lfunc_end32:
	.size	__ZN12_GLOBAL__N_13keyEi, .Lfunc_end32-__ZN12_GLOBAL__N_13keyEi
                                        ; -- End function
	.weak	__ZN5rally6Motion9gripFrameEbb  ; -- Begin function _ZN5rally6Motion9gripFrameEbb
	.type	__ZN5rally6Motion9gripFrameEbb,@function
__ZN5rally6Motion9gripFrameEbb:         ; @_ZN5rally6Motion9gripFrameEbb
	.local	.Lfunc_begin33
.Lfunc_begin33:
; %bb.0:
	call	__frameset0
	ld	de, (ix + 6)
	ld	l, (ix + 12)
	ld	a, (ix + 9)
	xor	a, l
	bit	0, a
	jr	z, .LBB33_3
; %bb.1:
	bit	0, l
	jr	nz, .LBB33_4
; %bb.2:
	ld	bc, -5
	jr	.LBB33_5
	.local	.LBB33_3
.LBB33_3:
	push	de
	pop	iy
	ld	de, (iy + 27)
	jr	.LBB33_6
	.local	.LBB33_4
.LBB33_4:
	ld	bc, 5
	.local	.LBB33_5
.LBB33_5:
	push	de
	pop	iy
	ld	hl, (iy + 27)
	add	hl, bc
	ld	(iy + 27), hl
	ex	de, hl
	.local	.LBB33_6
.LBB33_6:
	ld	bc, 25
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	p, .LBB33_8
; %bb.7:
	ld	hl, 25
	jr	.LBB33_10
	.local	.LBB33_8
.LBB33_8:
	ld	iy, 201
	ex	de, hl
	lea	de, iy + 0
	or	a, a
	sbc	hl, de
	jr	c, .LBB33_11
; %bb.9:
	ld	hl, 200
	.local	.LBB33_10
.LBB33_10:
	ld	iy, (ix + 6)
	ld	(iy + 27), hl
	.local	.LBB33_11
.LBB33_11:
	pop	ix
	ret
	.local	.Lfunc_end33
.Lfunc_end33:
	.size	__ZN5rally6Motion9gripFrameEbb, .Lfunc_end33-__ZN5rally6Motion9gripFrameEbb
                                        ; -- End function
	.weak	__ZN5rally11trackSampleElRKNS_8TrackDefE ; -- Begin function _ZN5rally11trackSampleElRKNS_8TrackDefE
	.type	__ZN5rally11trackSampleElRKNS_8TrackDefE,@function
__ZN5rally11trackSampleElRKNS_8TrackDefE: ; @_ZN5rally11trackSampleElRKNS_8TrackDefE
	.local	.Lfunc_begin34
.Lfunc_begin34:
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
	jr	c, .LBB34_2
; %bb.1:
	lea	hl, iy + 0
	push	de
	pop	bc
	call	__iremu
	push	hl
	pop	iy
	.local	.LBB34_2
.LBB34_2:
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
	jr	z, .LBB34_4
; %bb.3:
	lea	hl, iy + 0
	.local	.LBB34_4
.LBB34_4:
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
	.local	.Lfunc_end34
.Lfunc_end34:
	.size	__ZN5rally11trackSampleElRKNS_8TrackDefE, .Lfunc_end34-__ZN5rally11trackSampleElRKNS_8TrackDefE
                                        ; -- End function
	.weak	__ZNK5rally10DemoDriver4tickERNS_6MotionE ; -- Begin function _ZNK5rally10DemoDriver4tickERNS_6MotionE
	.type	__ZNK5rally10DemoDriver4tickERNS_6MotionE,@function
__ZNK5rally10DemoDriver4tickERNS_6MotionE: ; @_ZNK5rally10DemoDriver4tickERNS_6MotionE
	.local	.Lfunc_begin35
.Lfunc_begin35:
; %bb.0:
	ld	hl, -10
	call	__frameset
	ld	hl, (ix + 6)
	ld	iy, (ix + 9)
	ld	de, (iy + 11)
	ld	(ix - 3), de
	ld	e, (iy + 14)
	ld	bc, (hl)
	push	bc
	pop	hl
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	(ix - 7), hl
	ld	hl, (ix - 3)
	ld	(ix - 4), e                     ; 1-byte Folded Spill
	ld	(ix - 10), bc
	ld	iy, (ix - 7)
	ld	a, iyl
	call	__lcmps
	call	pe, __setflag
	ld	a, 1
	ld	l, 0
	jp	m, .LBB35_2
; %bb.1:
	ld	a, l
	.local	.LBB35_2
.LBB35_2:
	ld	(ix - 7), a
	ld	hl, (ix - 10)
	ld	bc, 2
	add	hl, bc
	push	hl
	pop	bc
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	de
	push	bc
	pop	hl
                                        ; kill: def $e killed $e killed $ude
	ld	bc, (ix - 3)
	ld	a, (ix - 4)                     ; 1-byte Folded Reload
	call	__lcmps
	call	pe, __setflag
	ld	d, 1
	jp	m, .LBB35_4
; %bb.3:
	ld	d, 0
	.local	.LBB35_4
.LBB35_4:
	rrc	d
	sbc	hl, hl
	push	hl
	ld	a, (ix - 7)
	rrc	a
	sbc	hl, hl
	push	hl
	ld	hl, (ix + 9)
	push	hl
	call	__ZN5rally6Motion4tickEbb
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end35
.Lfunc_end35:
	.size	__ZNK5rally10DemoDriver4tickERNS_6MotionE, .Lfunc_end35-__ZNK5rally10DemoDriver4tickERNS_6MotionE
                                        ; -- End function
	.weak	__ZN5rally4game11RaceTraffic4tickEmm ; -- Begin function _ZN5rally4game11RaceTraffic4tickEmm
	.type	__ZN5rally4game11RaceTraffic4tickEmm,@function
__ZN5rally4game11RaceTraffic4tickEmm:   ; @_ZN5rally4game11RaceTraffic4tickEmm
	.local	.Lfunc_begin36
.Lfunc_begin36:
; %bb.0:
	ld	hl, -16
	call	__frameset
	ld	iy, (ix + 6)
	ld	de, 174
	add	iy, de
	push	iy
	call	__ZN5rally4game11RouteCursor4tickEv
	ld	(ix - 9), hl
	pop	hl
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	ld	bc, -12000
	ld	a, -1
	call	__ladd
	ld	(ix - 12), hl
	ld	(ix - 13), e                    ; 1-byte Folded Spill
	ld	de, 0
	ld	iy, (ix + 6)
	lea	hl, iy + 8
	ld	(ix - 3), hl
	.local	.LBB36_1
.LBB36_1:                               ; =>This Inner Loop Header: Depth=1
	ld	bc, 6
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jp	z, .LBB36_13
; %bb.2:                                ;   in Loop: Header=BB36_1 Depth=1
	ld	iy, (ix - 3)
	bit	0, (iy - 8)
	jp	z, .LBB36_12
; %bb.3:                                ;   in Loop: Header=BB36_1 Depth=1
	ld	(ix - 6), de
	ld	bc, 0
	ld	hl, (ix - 9)
	ld	c, l
	ld	b, h
	xor	a, a
	ld	iy, (ix - 3)
	lea	de, iy - 4
	ld	hl, (iy - 4)
	push	de
	pop	iy
	lea	iy, iy + 3
	ld	e, (iy)
	call	__ladd
	ld	iy, (ix - 3)
	ld	(iy - 4), hl
	ld	(iy - 1), e
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	call	__ladd
	ld	iy, (ix - 3)
	ld	(iy), hl
	ld	(iy + 3), e
	ld	iy, (ix + 6)
	ld	bc, 184
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB36_5
; %bb.4:                                ;   in Loop: Header=BB36_1 Depth=1
	call	__lsub
	ld	iy, (ix - 3)
	ld	(iy), hl
	ld	(iy + 3), e
	.local	.LBB36_5
.LBB36_5:                               ;   in Loop: Header=BB36_1 Depth=1
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZN5rally4game11RaceTraffic5placeEj
	pop	hl
	pop	hl
	ld	iy, (ix + 6)
	ld	bc, 183
	add	iy, bc
	ld	l, (iy)
	ld	a, l
	or	a, a
	jr	nz, .LBB36_9
; %bb.6:                                ;   in Loop: Header=BB36_1 Depth=1
	ld	iy, (ix - 3)
	ld	hl, (iy + 8)
	ld	e, (iy + 11)
	call	__lcmpzero
	ld	de, (ix - 6)
	jr	nz, .LBB36_12
; %bb.7:                                ;   in Loop: Header=BB36_1 Depth=1
	ld	iy, (ix - 3)
	ld	hl, (iy - 4)
	ld	iy, (ix + 6)
	ld	de, 188
	add	iy, de
	ld	bc, (iy)
	lea	de, iy + 3
	ld	(ix - 16), de
	ld	iy, (ix - 3)
	ld	e, (iy - 1)
	ld	iy, (ix - 16)
	ld	a, (iy)
	call	__lcmps
	ld	de, (ix - 6)
	call	pe, __setflag
	jp	m, .LBB36_12
; %bb.8:                                ;   in Loop: Header=BB36_1 Depth=1
	ld	hl, (ix + 15)
	ld	iy, (ix - 3)
	ld	(iy + 8), hl
	ld	a, (ix + 18)
	ld	(iy + 11), a
	jr	.LBB36_12
	.local	.LBB36_9
.LBB36_9:                               ;   in Loop: Header=BB36_1 Depth=1
	ld	a, l
	cp	a, 1
	ld	de, (ix - 6)
	jr	nz, .LBB36_12
; %bb.10:                               ;   in Loop: Header=BB36_1 Depth=1
	ld	iy, (ix - 3)
	ld	hl, (iy - 4)
	ld	e, (iy - 1)
	ld	bc, (ix - 12)
	ld	a, (ix - 13)                    ; 1-byte Folded Reload
	call	__lcmps
	ld	de, (ix - 6)
	call	pe, __setflag
	jp	p, .LBB36_12
; %bb.11:                               ;   in Loop: Header=BB36_1 Depth=1
	ld	iy, (ix - 3)
	ld	(iy - 8), 0
	.local	.LBB36_12
.LBB36_12:                              ;   in Loop: Header=BB36_1 Depth=1
	inc	de
	ld	iy, (ix - 3)
	lea	iy, iy + 29
	ld	(ix - 3), iy
	jp	.LBB36_1
	.local	.LBB36_13
.LBB36_13:
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	ld	de, 183
	add	iy, de
	ld	a, (iy)
	cp	a, 1
	jp	nz, .LBB36_16
; %bb.14:
	ld	de, 192
	ld	iy, (ix + 6)
	add	iy, de
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	ld	a, (iy)
	call	__lcmpu
	jp	c, .LBB36_16
; %bb.15:
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	ld	bc, 60000
	xor	a, a
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZN5rally4game11RaceTraffic5spawnEl
	pop	hl
	pop	hl
	pop	hl
	ld	de, 192
	ld	iy, (ix + 6)
	add	iy, de
	ld	hl, (iy)
	ld	(ix - 3), iy
	lea	iy, iy + 3
	ld	(ix - 6), iy
	ld	e, (iy)
	ld	bc, 90000
	xor	a, a
	call	__ladd
	ld	iy, (ix - 3)
	ld	(iy), hl
	ld	hl, (ix - 6)
	ld	(hl), e
	.local	.LBB36_16
.LBB36_16:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end36
.Lfunc_end36:
	.size	__ZN5rally4game11RaceTraffic4tickEmm, .Lfunc_end36-__ZN5rally4game11RaceTraffic4tickEmm
                                        ; -- End function
	.weak	__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm ; -- Begin function _ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm
	.type	__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm,@function
__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm: ; @_ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm
	.local	.Lfunc_begin37
.Lfunc_begin37:
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
	jr	nz, .LBB37_3
; %bb.1:
	ld	hl, (iy + 2)
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jp	z, .LBB37_8
; %bb.2:
	dec.sis	hl
	ld	(iy + 2), l
	ld	(iy + 3), h
	jp	.LBB37_8
	.local	.LBB37_3
.LBB37_3:
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
	jp	nz, .LBB37_7
	.local	.LBB37_4
.LBB37_4:                               ; =>This Inner Loop Header: Depth=1
	ld	(ix - 6), bc
	push	bc
	pop	iy
	ld	bc, 3
	add	iy, bc
	lea	hl, iy + 0
	ld	bc, 18
	or	a, a
	sbc	hl, bc
	jp	z, .LBB37_8
; %bb.5:                                ;   in Loop: Header=BB37_4 Depth=1
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
	jr	nz, .LBB37_4
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
	jp	.LBB37_8
	.local	.LBB37_7
.LBB37_7:
	ld	hl, (ix - 3)
                                        ; kill: def $hl killed $hl killed $uhl
	dec.sis	hl
	ld	iy, (ix + 6)
	ld	(iy), l
	ld	(iy + 1), h
	.local	.LBB37_8
.LBB37_8:
	ld	hl, (ix - 3)
                                        ; kill: def $hl killed $hl killed $uhl
	add.sis	hl, bc
	or	a, a
	sbc.sis	hl, bc
	jr	nz, .LBB37_10
; %bb.9:
	ld	a, 0
	jr	.LBB37_11
	.local	.LBB37_10
.LBB37_10:
	ld	a, -1
	.local	.LBB37_11
.LBB37_11:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end37
.Lfunc_end37:
	.size	__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm, .Lfunc_end37-__ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm
                                        ; -- End function
	.weak	__ZN5rally6Motion4tickEbb       ; -- Begin function _ZN5rally6Motion4tickEbb
	.type	__ZN5rally6Motion4tickEbb,@function
__ZN5rally6Motion4tickEbb:              ; @_ZN5rally6Motion4tickEbb
	.local	.Lfunc_begin38
.Lfunc_begin38:
; %bb.0:
	ld	hl, -41
	call	__frameset
	ld	de, (ix + 6)
	ld	a, (ix + 9)
	ld	l, (ix + 12)
	push	hl
	ld	l, a
	push	hl
	push	de
	call	__ZN5rally6Motion9speedStepEbb
	pop	hl
	pop	hl
	pop	hl
	ld	iy, (ix + 6)
	ld	hl, (iy + 7)
	ld	(ix - 41), hl
	ld	d, (iy + 10)
	ld	e, d
	ld	bc, 100
	xor	a, a
	call	__ldivs
	push	hl
	pop	iy
	ld	l, 8
	lea	bc, iy + 0
	ld	a, e
	call	__lshl
	ld	(ix - 35), bc
	ld	(ix - 38), a                    ; 1-byte Folded Spill
	lea	hl, iy + 0
	ld	bc, 100
	xor	a, a
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 41)
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
	ld	bc, 100
	xor	a, a
	call	__ldivs
	ld	bc, (ix - 35)
	ld	a, (ix - 38)                    ; 1-byte Folded Reload
	call	__ladd
	push	hl
	pop	bc
	ld	(ix - 38), bc
                                        ; kill: def $e killed $e def $ude
	ld	(ix - 35), de
	ld	hl, (ix + 6)
	ld	hl, (hl)
	push	hl
	push	de
	push	bc
	pea	ix - 16
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	hl, (ix - 38)
	ld	de, (ix - 35)
                                        ; kill: def $e killed $e killed $ude
	ld	bc, 16384
	xor	a, a
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	ld	iy, (ix + 6)
	ld	bc, (iy)
	push	bc
	push	de
	push	hl
	pea	ix - 32
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, (ix - 8)
	ld	hl, (ix - 20)
	ld	e, (ix - 17)
	ld	a, (ix - 5)
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	bc, (ix - 4)
	ld	hl, (ix - 24)
	ld	e, (ix - 21)
	ld	a, (ix - 1)
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	lea	hl, iy + 0
	ld	e, d
	call	__lsub
	ld	bc, 4096
	xor	a, a
	call	__ldivs
	ld	(ix - 35), hl
	ld	d, e
	ld	iy, (ix + 6)
	ld	bc, (iy + 11)
	ld	a, (iy + 14)
	push	bc
	pop	hl
	ld	e, a
	call	__lmulu
	ld	bc, (ix - 35)
	ld	a, d
	call	__lmulu
	ld	bc, 1024
	xor	a, a
	call	__ldivs
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZN5rally6Motion11lateralStepEl
	pop	hl
	pop	hl
	pop	hl
	ld	iy, (ix + 6)
	ld	hl, (iy + 19)
	ld	e, (iy + 22)
	ld	bc, 100
	xor	a, a
	call	__ldivs
	push	hl
	pop	bc
	ld	a, e
	ld	iy, (ix + 6)
	lea	de, iy + 15
	ld	iy, (ix + 6)
	ld	hl, (iy + 15)
	push	de
	pop	iy
	lea	iy, iy + 3
	ld	e, (iy)
	ld	iy, (ix + 6)
	call	__ladd
	push	hl
	pop	bc
	ld	d, e
	ld	(iy + 15), bc
	ld	(iy + 18), d
	ld	hl, 38400
	ld	(ix - 35), hl
	ld	e, l
	ld	a, d
	call	__lcmps
	call	pe, __setflag
	ld	a, e
	jp	m, .LBB38_2
; %bb.1:
	ld	a, -1
	push	bc
	pop	hl
	ld	e, d
	ld	bc, -38400
	ld	(ix - 35), bc
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB38_3
	.local	.LBB38_2
.LBB38_2:
	ld	hl, (ix - 35)
	ld	(iy + 15), hl
	ld	(iy + 18), a
	or	a, a
	sbc	hl, hl
	ld	(iy + 19), hl
	ld	(iy + 22), h
	.local	.LBB38_3
.LBB38_3:
	lea	de, iy + 7
	ld	hl, (iy + 7)
	lea	bc, iy + 0
	ld	(ix - 41), hl
	push	de
	pop	iy
	lea	hl, iy + 3
	ld	d, (hl)
	push	bc
	pop	iy
	ld	bc, (iy + 11)
	ld	l, 1
	ld	a, (iy + 14)
	call	__lshl
	ld	(ix - 35), bc
	ld	(ix - 38), a
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 41)
	ld	a, d
	call	__ladd
	ld	(ix - 41), hl
	ld	d, e
	ld	hl, (ix + 6)
	ld	iy, (hl)
	ld	hl, (iy + 6)
	ld	e, (iy + 9)
	ld	bc, 100
	xor	a, a
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 41)
	ld	e, d
	call	__lrems
	ld	iy, (ix + 6)
	ld	(iy + 7), hl
	ld	(iy + 10), e
	lea	de, iy + 3
	ld	hl, (iy + 3)
	push	de
	pop	iy
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix - 35)
	ld	a, (ix - 38)                    ; 1-byte Folded Reload
	call	__ladd
	ld	bc, 8000
	xor	a, a
	call	__lrems
	ld	iy, (ix + 6)
	ld	(iy + 3), hl
	ld	(iy + 6), e
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end38
.Lfunc_end38:
	.size	__ZN5rally6Motion4tickEbb, .Lfunc_end38-__ZN5rally6Motion4tickEbb
                                        ; -- End function
	.weak	__ZNK5rally4game11RaceTraffic14contactStationEll ; -- Begin function _ZNK5rally4game11RaceTraffic14contactStationEll
	.type	__ZNK5rally4game11RaceTraffic14contactStationEll,@function
__ZNK5rally4game11RaceTraffic14contactStationEll: ; @_ZNK5rally4game11RaceTraffic14contactStationEll
	.local	.Lfunc_begin39
.Lfunc_begin39:
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
	.local	.LBB39_1
.LBB39_1:                               ; =>This Inner Loop Header: Depth=1
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	z, .LBB39_18
; %bb.2:                                ;   in Loop: Header=BB39_1 Depth=1
	lea	de, iy + 0
	ld	hl, (ix + 6)
	add	hl, de
	bit	0, (hl)
	jp	z, .LBB39_17
; %bb.3:                                ;   in Loop: Header=BB39_1 Depth=1
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
	jp	m, .LBB39_5
; %bb.4:                                ;   in Loop: Header=BB39_1 Depth=1
	ld	d, 0
	.local	.LBB39_5
.LBB39_5:                               ;   in Loop: Header=BB39_1 Depth=1
	ld	hl, (ix - 19)
	ld	e, iyl
	ld	bc, (ix - 11)
	ld	a, (ix - 12)                    ; 1-byte Folded Reload
	call	__lcmps
	call	pe, __setflag
	ld	a, 1
	jp	m, .LBB39_7
; %bb.6:                                ;   in Loop: Header=BB39_1 Depth=1
	ld	a, 0
	.local	.LBB39_7
.LBB39_7:                               ;   in Loop: Header=BB39_1 Depth=1
	bit	0, a
	ld	hl, (ix - 3)
	jr	nz, .LBB39_9
; %bb.8:                                ;   in Loop: Header=BB39_1 Depth=1
	or	a, a
	sbc	hl, hl
	.local	.LBB39_9
.LBB39_9:                               ;   in Loop: Header=BB39_1 Depth=1
	bit	0, a
	ld	e, (ix - 4)                     ; 1-byte Folded Reload
	jr	nz, .LBB39_11
; %bb.10:                               ;   in Loop: Header=BB39_1 Depth=1
	ld	e, 0
	.local	.LBB39_11
.LBB39_11:                              ;   in Loop: Header=BB39_1 Depth=1
	bit	0, d
	ld	bc, (ix - 15)
	jr	nz, .LBB39_13
; %bb.12:                               ;   in Loop: Header=BB39_1 Depth=1
	push	hl
	pop	bc
	.local	.LBB39_13
.LBB39_13:                              ;   in Loop: Header=BB39_1 Depth=1
	bit	0, d
	ld	a, (ix - 16)                    ; 1-byte Folded Reload
	jr	nz, .LBB39_15
; %bb.14:                               ;   in Loop: Header=BB39_1 Depth=1
	ld	a, e
	.local	.LBB39_15
.LBB39_15:                              ;   in Loop: Header=BB39_1 Depth=1
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
	jr	nc, .LBB39_17
; %bb.16:                               ;   in Loop: Header=BB39_1 Depth=1
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
	jr	c, .LBB39_18
	.local	.LBB39_17
.LBB39_17:                              ;   in Loop: Header=BB39_1 Depth=1
	ld	de, 29
	add	iy, de
	jp	.LBB39_1
	.local	.LBB39_18
.LBB39_18:
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB39_20
; %bb.19:
	ld	a, 0
	jr	.LBB39_21
	.local	.LBB39_20
.LBB39_20:
	ld	a, -1
	.local	.LBB39_21
.LBB39_21:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end39
.Lfunc_end39:
	.size	__ZNK5rally4game11RaceTraffic14contactStationEll, .Lfunc_end39-__ZNK5rally4game11RaceTraffic14contactStationEll
                                        ; -- End function
	.weak	__ZNK5rally4game11RaceTraffic4rankEmm ; -- Begin function _ZNK5rally4game11RaceTraffic4rankEmm
	.type	__ZNK5rally4game11RaceTraffic4rankEmm,@function
__ZNK5rally4game11RaceTraffic4rankEmm:  ; @_ZNK5rally4game11RaceTraffic4rankEmm
	.local	.Lfunc_begin40
.Lfunc_begin40:
; %bb.0:
	ld	hl, -7
	call	__frameset
	ld	hl, (ix + 6)
	ld	a, (ix + 12)
	ld	iy, 1
	ld	bc, 0
	ld	de, 196
	add	hl, de
	ld	l, (hl)
	ld	(ix - 7), l
	push	bc
	pop	hl
	.local	.LBB40_1
.LBB40_1:                               ; =>This Inner Loop Header: Depth=1
	ld	bc, 174
	push	hl
	pop	de
	or	a, a
	sbc	hl, bc
	jp	z, .LBB40_13
; %bb.2:                                ;   in Loop: Header=BB40_1 Depth=1
	ld	(ix - 6), iy
	ld	(ix - 3), de
	ld	hl, (ix + 6)
	add	hl, de
	bit	0, (hl)
	jr	z, .LBB40_11
; %bb.3:                                ;   in Loop: Header=BB40_1 Depth=1
	ld	hl, (ix + 15)
	ld	e, (ix + 18)
	call	__lcmpzero
	jr	nz, .LBB40_5
; %bb.4:                                ;   in Loop: Header=BB40_1 Depth=1
	ld	bc, (ix - 3)
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	add	iy, bc
	ld	bc, (iy + 4)
	ld	hl, (ix + 9)
	ld	d, a
	ld	e, a
	ld	a, (iy + 7)
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB40_9
	jr	.LBB40_10
	.local	.LBB40_5
.LBB40_5:                               ;   in Loop: Header=BB40_1 Depth=1
	ld	bc, (ix - 3)
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	add	iy, bc
	ld	hl, (iy + 16)
	ld	e, (iy + 19)
	call	__lcmpzero
	jr	z, .LBB40_11
; %bb.6:                                ;   in Loop: Header=BB40_1 Depth=1
	ld	d, a
	ld	bc, (ix + 15)
	ld	a, (ix + 18)
	call	__lcmpu
	jr	c, .LBB40_9
; %bb.7:                                ;   in Loop: Header=BB40_1 Depth=1
	ld	bc, (ix + 15)
	ld	a, (ix + 18)
	call	__lcmpu
	jr	nz, .LBB40_10
; %bb.8:                                ;   in Loop: Header=BB40_1 Depth=1
	ld	bc, (ix - 3)
	ld	iy, (ix + 6)
	add	iy, bc
	ld	a, (iy + 3)
	ld	l, (ix - 7)
	cp	a, l
	jr	nc, .LBB40_10
	.local	.LBB40_9
.LBB40_9:                               ;   in Loop: Header=BB40_1 Depth=1
	ld	iy, (ix - 6)
	inc	iy
	ld	a, d
	jr	.LBB40_12
	.local	.LBB40_10
.LBB40_10:                              ;   in Loop: Header=BB40_1 Depth=1
	ld	a, d
	.local	.LBB40_11
.LBB40_11:                              ;   in Loop: Header=BB40_1 Depth=1
	ld	iy, (ix - 6)
	.local	.LBB40_12
.LBB40_12:                              ;   in Loop: Header=BB40_1 Depth=1
	ld	hl, (ix - 3)
	ld	de, 29
	add	hl, de
	jp	.LBB40_1
	.local	.LBB40_13
.LBB40_13:
	ld	a, iyl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end40
.Lfunc_end40:
	.size	__ZNK5rally4game11RaceTraffic4rankEmm, .Lfunc_end40-__ZNK5rally4game11RaceTraffic4rankEmm
                                        ; -- End function
	.weak	__ZN5rally4game5Rules4tickEm    ; -- Begin function _ZN5rally4game5Rules4tickEm
	.type	__ZN5rally4game5Rules4tickEm,@function
__ZN5rally4game5Rules4tickEm:           ; @_ZN5rally4game5Rules4tickEm
	.local	.Lfunc_begin41
.Lfunc_begin41:
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
	jr	z, .LBB41_2
; %bb.1:
	dec.sis	hl
	ld	(iy + 57), l
	ld	(iy + 58), h
	.local	.LBB41_2
.LBB41_2:
	ld	d, (iy + 10)
	ld	a, d
	cp	a, 2
	jr	nz, .LBB41_6
	.local	.LBB41_3
.LBB41_3:
	ld	iy, 360
	push	bc
	pop	hl
	lea	bc, iy + 0
	xor	a, a
	call	__lcmpu
	jr	nz, .LBB41_16
; %bb.4:
	ld	a, d
	cp	a, 2
	jr	z, .LBB41_12
; %bb.5:
	ld	a, 6
	jr	.LBB41_13
	.local	.LBB41_6
.LBB41_6:
	ld	a, d
	cp	a, 4
	jr	nz, .LBB41_8
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
	jr	.LBB41_16
	.local	.LBB41_8
.LBB41_8:
	ld	a, d
	cp	a, 5
	jr	z, .LBB41_3
; %bb.9:
	ld	a, d
	add	a, -7
	cp	a, 3
	jp	nc, .LBB41_17
; %bb.10:
	ld	iy, 1440
	push	bc
	pop	hl
	lea	bc, iy + 0
	xor	a, a
	call	__lcmpu
	jr	nz, .LBB41_16
; %bb.11:
	ld	iy, (ix + 6)
	ld	(iy + 10), 0
	jr	.LBB41_15
	.local	.LBB41_12
.LBB41_12:
	ld	a, 3
	.local	.LBB41_13
.LBB41_13:
	ld	iy, (ix + 6)
	.local	.LBB41_14
.LBB41_14:
	ld	(iy + 10), a
	.local	.LBB41_15
.LBB41_15:
	or	a, a
	sbc	hl, hl
	ld	(iy + 11), hl
	ld	(iy + 14), h
	ld	hl, (iy + 55)
	inc.sis	hl
	ld	(iy + 55), l
	ld	(iy + 56), h
	.local	.LBB41_16
.LBB41_16:
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB41_17
.LBB41_17:
	ld	a, d
	cp	a, 3
	jr	z, .LBB41_19
; %bb.18:
	ld	a, d
	cp	a, 6
	jp	nz, .LBB41_16
	.local	.LBB41_19
.LBB41_19:
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
	jr	z, .LBB41_21
; %bb.20:
	ld	bc, -1
	ld	a, b
	call	__ladd
	push	hl
	pop	bc
	ld	a, e
	ld	(iy + 19), bc
	ld	(iy + 22), a
	.local	.LBB41_21
.LBB41_21:
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
	jr	nz, .LBB41_23
; %bb.22:
	push	hl
	pop	bc
	.local	.LBB41_23
.LBB41_23:
	ld	(ix - 9), bc
	ld	(ix - 31), iy
	bit	0, a
	ld	a, 0
	jr	nz, .LBB41_25
; %bb.24:
	ld	a, e
	.local	.LBB41_25
.LBB41_25:
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
	jr	nc, .LBB41_30
; %bb.26:
	ld	hl, (ix - 27)
	ld	e, (ix - 28)                    ; 1-byte Folded Reload
	.local	.LBB41_27
.LBB41_27:
	call	__lcmpzero
	jp	nz, .LBB41_16
; %bb.28:
	ld	a, d
	cp	a, 3
	jp	z, .LBB41_49
; %bb.29:
	ld	a, 8
	jp	.LBB41_14
	.local	.LBB41_30
.LBB41_30:
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
	jr	z, .LBB41_32
; %bb.31:
	ld	hl, (ix - 6)
	ld	e, (ix - 19)                    ; 1-byte Folded Reload
	call	__lcmpu
	jr	nc, .LBB41_33
	.local	.LBB41_32
.LBB41_32:
	ld	hl, (ix - 6)
	ld	(iy + 31), hl
	ld	a, (ix - 19)
	ld	(iy + 34), a
	.local	.LBB41_33
.LBB41_33:
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
	jr	nz, .LBB41_35
; %bb.34:
	push	hl
	pop	bc
	.local	.LBB41_35
.LBB41_35:
	ex	de, hl
	ld	e, iyl
	ex	de, hl
	bit	0, l
	jr	nz, .LBB41_37
; %bb.36:
	ld	a, e
	.local	.LBB41_37
.LBB41_37:
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	ld	(iy + 39), bc
	ld	(iy + 42), a
	ld	l, a
	ld	a, d
	cp	a, 3
	jp	nz, .LBB41_43
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
	jr	nz, .LBB41_40
; %bb.39:
	ld	(ix - 31), hl
	.local	.LBB41_40
.LBB41_40:
	bit	0, d
	ld	a, 0
	jr	nz, .LBB41_42
; %bb.41:
	ld	a, e
	.local	.LBB41_42
.LBB41_42:
	ld	hl, (ix - 31)
	ld	(iy + 39), hl
	ld	(iy + 42), a
	ld	(iy + 10), 4
	jp	.LBB41_15
	.local	.LBB41_43
.LBB41_43:
	ld	(ix - 6), l                     ; 1-byte Folded Spill
	ld	(ix - 9), bc
	ld	bc, 120
	ld	l, (iy + 8)
	ld	a, (ix - 3)                     ; 1-byte Folded Reload
	cp	a, l
	jp	nz, .LBB41_50
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
	jr	nz, .LBB41_46
; %bb.45:
	push	hl
	pop	bc
	.local	.LBB41_46
.LBB41_46:
	push	bc
	pop	hl
	bit	0, d
	ld	iy, (ix + 6)
	ld	a, 0
	jr	nz, .LBB41_48
; %bb.47:
	ld	a, e
	.local	.LBB41_48
.LBB41_48:
	ld	(iy + 39), hl
	ld	(iy + 42), a
	ld	(iy + 10), 7
	jp	.LBB41_15
	.local	.LBB41_49
.LBB41_49:
	ld	a, 9
	jp	.LBB41_14
	.local	.LBB41_50
.LBB41_50:
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
	jp	.LBB41_27
	.local	.Lfunc_end41
.Lfunc_end41:
	.size	__ZN5rally4game5Rules4tickEm, .Lfunc_end41-__ZN5rally4game5Rules4tickEm
                                        ; -- End function
	.weak	__ZN5rally4game11RouteCursor4tickEv ; -- Begin function _ZN5rally4game11RouteCursor4tickEv
	.type	__ZN5rally4game11RouteCursor4tickEv,@function
__ZN5rally4game11RouteCursor4tickEv:    ; @_ZN5rally4game11RouteCursor4tickEv
	.local	.Lfunc_begin42
.Lfunc_begin42:
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
	.weak	__ZN5rally4game11RaceTraffic5spawnEl ; -- Begin function _ZN5rally4game11RaceTraffic5spawnEl
	.type	__ZN5rally4game11RaceTraffic5spawnEl,@function
__ZN5rally4game11RaceTraffic5spawnEl:   ; @_ZN5rally4game11RaceTraffic5spawnEl
	.local	.Lfunc_begin43
.Lfunc_begin43:
; %bb.0:
	ld	hl, -20
	call	__frameset
	ld	iy, (ix + 6)
	ld	c, 0
	ld	de, 183
	add	iy, de
	ld	a, (iy)
	cp	a, 1
	jp	nz, .LBB43_21
; %bb.1:
	ld	a, c
	ld	bc, 2
	ld	de, 184
	ld	iy, (ix + 6)
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	(ix - 10), hl
	ld	(ix - 7), e                     ; 1-byte Folded Spill
	call	__ldivs
	ld	bc, -1
	ld	(ix - 3), bc
	ld	(ix - 16), hl
	ld	(ix - 17), e                    ; 1-byte Folded Spill
	ld	iy, (ix + 6)
	lea	hl, iy + 4
	ld	(ix - 6), hl
	ld	de, 6
	inc	bc
	.local	.LBB43_2
.LBB43_2:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jp	z, .LBB43_22
; %bb.3:                                ;   in Loop: Header=BB43_2 Depth=1
	ld	hl, (ix - 3)
	ld	(ix - 13), bc
	ld	iy, (ix - 6)
	bit	0, (iy - 4)
	jr	nz, .LBB43_7
; %bb.4:                                ;   in Loop: Header=BB43_2 Depth=1
	push	hl
	pop	iy
	ld	de, 0
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	ld	bc, (ix - 13)
	push	bc
	pop	hl
	jp	m, .LBB43_6
; %bb.5:                                ;   in Loop: Header=BB43_2 Depth=1
	lea	hl, iy + 0
	.local	.LBB43_6
.LBB43_6:                               ;   in Loop: Header=BB43_2 Depth=1
	ld	de, 6
	jp	.LBB43_20
	.local	.LBB43_7
.LBB43_7:                               ;   in Loop: Header=BB43_2 Depth=1
	ld	hl, (iy)
	ld	e, (iy + 3)
	ld	bc, (ix + 9)
	ld	a, (ix + 12)
	call	__lsub
	ld	iy, (ix - 10)
	lea	bc, iy + 0
	ld	a, (ix - 7)                     ; 1-byte Folded Reload
	call	__lrems
	push	hl
	pop	bc
	ld	d, e
	call	__lcmpzero
	ld	e, 1
	jp	m, .LBB43_9
; %bb.8:                                ;   in Loop: Header=BB43_2 Depth=1
	ld	e, 0
	.local	.LBB43_9
.LBB43_9:                               ;   in Loop: Header=BB43_2 Depth=1
	bit	0, e
	lea	hl, iy + 0
	jr	nz, .LBB43_11
; %bb.10:                               ;   in Loop: Header=BB43_2 Depth=1
	or	a, a
	sbc	hl, hl
	.local	.LBB43_11
.LBB43_11:                              ;   in Loop: Header=BB43_2 Depth=1
	bit	0, e
	ld	e, a
	jr	nz, .LBB43_13
; %bb.12:                               ;   in Loop: Header=BB43_2 Depth=1
	ld	e, 0
	.local	.LBB43_13
.LBB43_13:                              ;   in Loop: Header=BB43_2 Depth=1
	ld	a, d
	call	__ladd
	push	hl
	pop	bc
	ld	d, e
	ld	hl, (ix - 16)
	ld	e, (ix - 17)                    ; 1-byte Folded Reload
	ld	(ix - 20), bc
	ld	a, d
	call	__lcmps
	call	pe, __setflag
	ld	a, 1
	jp	m, .LBB43_15
; %bb.14:                               ;   in Loop: Header=BB43_2 Depth=1
	ld	a, 0
	.local	.LBB43_15
.LBB43_15:                              ;   in Loop: Header=BB43_2 Depth=1
	bit	0, a
	lea	bc, iy + 0
	jr	nz, .LBB43_17
; %bb.16:                               ;   in Loop: Header=BB43_2 Depth=1
	ld	bc, 0
	.local	.LBB43_17
.LBB43_17:                              ;   in Loop: Header=BB43_2 Depth=1
	bit	0, a
	ld	a, (ix - 7)                     ; 1-byte Folded Reload
	jr	nz, .LBB43_19
; %bb.18:                               ;   in Loop: Header=BB43_2 Depth=1
	xor	a, a
	.local	.LBB43_19
.LBB43_19:                              ;   in Loop: Header=BB43_2 Depth=1
	ld	hl, (ix - 20)
	ld	e, d
	call	__lsub
	push	hl
	pop	iy
	lea	bc, iy + 0
	ld	a, e
	ld	l, 31
	call	__lshrs
	lea	hl, iy + 0
	call	__ladd
	call	__lxor
	ld	bc, 9600
	xor	a, a
	call	__lcmpu
	ld	hl, (ix - 3)
	ld	de, 6
	ld	bc, (ix - 13)
	jr	c, .LBB43_23
	.local	.LBB43_20
.LBB43_20:                              ;   in Loop: Header=BB43_2 Depth=1
	ld	(ix - 3), hl
	inc	bc
	ld	iy, (ix - 6)
	lea	iy, iy + 29
	ld	(ix - 6), iy
	jp	.LBB43_2
	.local	.LBB43_21
.LBB43_21:
	ld	a, c
	jp	.LBB43_32
	.local	.LBB43_22
.LBB43_22:
	ld	bc, (ix - 3)
	push	bc
	pop	hl
	ld	de, 0
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB43_24
	.local	.LBB43_23
.LBB43_23:
	xor	a, a
	jp	.LBB43_32
	.local	.LBB43_24
.LBB43_24:
	push	bc
	pop	hl
	ld	bc, 29
	call	__imulu
	push	hl
	pop	de
	ld	iy, (ix + 6)
	add	iy, de
	ld	a, (ix - 7)                     ; 1-byte Folded Reload
	ld	hl, (iy + 1)
	inc.sis	hl
	ld	(iy + 1), l
	ld	(iy + 2), h
	ld	(iy), 1
	ld	hl, (ix + 9)
	ld	(iy + 4), hl
	ld	e, (ix + 12)
	ld	(iy + 7), e
	ld	bc, (ix - 10)
	call	__lrems
	push	hl
	pop	bc
	ld	d, e
	call	__lcmpzero
	jp	m, .LBB43_26
; %bb.25:
	ld	l, 0
	jr	.LBB43_27
	.local	.LBB43_26
.LBB43_26:
	ld	l, 1
	.local	.LBB43_27
.LBB43_27:
	bit	0, l
	jr	nz, .LBB43_29
; %bb.28:
	ld	a, d
	ld	de, 0
	ld	(ix - 10), de
	ld	d, a
	ld	a, (ix - 7)                     ; 1-byte Folded Reload
	.local	.LBB43_29
.LBB43_29:
	bit	0, l
	jr	nz, .LBB43_31
; %bb.30:
	ld	l, 0
	ld	a, l
	.local	.LBB43_31
.LBB43_31:
	ld	hl, (ix - 10)
	ld	e, a
	ld	a, d
	call	__ladd
	ld	(iy + 8), hl
	ld	(iy + 11), e
	or	a, a
	sbc	hl, hl
	ld	(iy + 16), hl
	ld	(iy + 19), h
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	__ZN5rally4game11RaceTraffic5placeEj
	pop	hl
	pop	hl
	ld	a, 1
	.local	.LBB43_32
.LBB43_32:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end43
.Lfunc_end43:
	.size	__ZN5rally4game11RaceTraffic5spawnEl, .Lfunc_end43-__ZN5rally4game11RaceTraffic5spawnEl
                                        ; -- End function
	.weak	__ZN5rally4game9routeSineEs     ; -- Begin function _ZN5rally4game9routeSineEs
	.type	__ZN5rally4game9routeSineEs,@function
__ZN5rally4game9routeSineEs:            ; @_ZN5rally4game9routeSineEs
	.local	.Lfunc_begin44
.Lfunc_begin44:
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
	jr	nz, .LBB44_2
; %bb.1:
	push	bc
	pop	hl
	.local	.LBB44_2
.LBB44_2:
	ld	iy, __ZN5rally4gameL9RouteSineE
	bit	0, d
	jr	nz, .LBB44_4
; %bb.3:
	xor	a, a
	.local	.LBB44_4
.LBB44_4:
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
	jp	nc, .LBB44_6
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
	.local	.LBB44_6
.LBB44_6:
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
	jp	m, .LBB44_8
; %bb.7:
	ld	e, iyl
	ld	d, iyh
	.local	.LBB44_8
.LBB44_8:
	ld	l, e
	ld	h, d
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end44
.Lfunc_end44:
	.size	__ZN5rally4game9routeSineEs, .Lfunc_end44-__ZN5rally4game9routeSineEs
                                        ; -- End function
	.weak	__ZNK5rally4game11RaceTraffic7contactEml ; -- Begin function _ZNK5rally4game11RaceTraffic7contactEml
	.type	__ZNK5rally4game11RaceTraffic7contactEml,@function
__ZNK5rally4game11RaceTraffic7contactEml: ; @_ZNK5rally4game11RaceTraffic7contactEml
	.local	.Lfunc_begin45
.Lfunc_begin45:
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
	jp	m, .LBB45_2
; %bb.1:
	ld	l, 0
	jr	.LBB45_3
	.local	.LBB45_2
.LBB45_2:
	ld	l, 1
	.local	.LBB45_3
.LBB45_3:
	bit	0, l
	jr	nz, .LBB45_5
; %bb.4:
	ld	bc, 0
	.local	.LBB45_5
.LBB45_5:
	bit	0, l
	jr	nz, .LBB45_7
; %bb.6:
	xor	a, a
	.local	.LBB45_7
.LBB45_7:
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
	.local	.Lfunc_end45
.Lfunc_end45:
	.size	__ZNK5rally4game11RaceTraffic7contactEml, .Lfunc_end45-__ZNK5rally4game11RaceTraffic7contactEml
                                        ; -- End function
	.weak	__ZN5rally6Motion9speedStepEbb  ; -- Begin function _ZN5rally6Motion9speedStepEbb
	.type	__ZN5rally6Motion9speedStepEbb,@function
__ZN5rally6Motion9speedStepEbb:         ; @_ZN5rally6Motion9speedStepEbb
	.local	.Lfunc_begin46
.Lfunc_begin46:
; %bb.0:
	ld	hl, -10
	call	__frameset
	ld	e, (ix + 9)
	ld	d, 0
	or	a, a
	sbc	hl, hl
	bit	0, e
	ld	(ix - 7), hl
	jr	z, .LBB46_2
; %bb.1:
	ld	hl, 2
	.local	.LBB46_2
.LBB46_2:
	ld	a, (ix + 12)
	bit	0, e
	ld	bc, -4
	bit	0, a
	jr	nz, .LBB46_4
; %bb.3:
	push	hl
	pop	bc
	.local	.LBB46_4
.LBB46_4:
	ld	l, -1
	bit	0, a
	ld	a, l
	jr	nz, .LBB46_6
; %bb.5:
	ld	a, d
	.local	.LBB46_6
.LBB46_6:
	ld	iy, (ix + 6)
	lea	de, iy + 11
	ld	hl, (iy + 11)
	push	de
	pop	iy
	lea	iy, iy + 3
	ld	e, (iy)
	call	__ladd
	ld	(ix - 4), hl
	ld	iy, (ix + 6)
	ld	(iy + 11), hl
	ld	(ix - 1), e                     ; 1-byte Folded Spill
	ld	(iy + 14), e
	ld	de, (iy + 15)
	ld	a, (iy + 18)
	ld	l, 31
	push	de
	pop	bc
	ld	iyl, a
	call	__lshrs
	ex	de, hl
	ld	e, iyl
	call	__ladd
	call	__lxor
	push	hl
	pop	iy
	ld	d, e
	ld	bc, 19969
	xor	a, a
	call	__lcmpu
	jp	c, .LBB46_15
; %bb.7:
	ld	hl, 24064
	ld	e, l
	lea	bc, iy + 0
	ld	a, d
	call	__lcmpu
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	inc	a
	bit	0, a
	jr	nz, .LBB46_9
; %bb.8:
	ld	hl, 160
	jr	.LBB46_10
	.local	.LBB46_9
.LBB46_9:
	ld	hl, 90
	.local	.LBB46_10
.LBB46_10:
	ld	bc, (ix - 4)
	bit	0, a
	ld	(ix - 10), hl
	xor	a, a
	ld	e, a
	ld	a, (ix - 1)                     ; 1-byte Folded Reload
	call	__lcmps
	call	pe, __setflag
	jp	p, .LBB46_15
; %bb.11:
	ld	hl, 24064
	ld	e, l
	lea	bc, iy + 0
	ld	a, d
	call	__lcmpu
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	inc	a
	bit	0, a
	ld	hl, -4
	jr	nz, .LBB46_13
; %bb.12:
	ld	hl, -3
	.local	.LBB46_13
.LBB46_13:
	bit	0, a
	ld	bc, (ix - 4)
	ld	a, (ix - 1)                     ; 1-byte Folded Reload
	ld	e, -1
	call	__ladd
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 10)
	ld	e, 0
	push	bc
	pop	iy
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB46_16
; %bb.14:
	ld	l, 0
	jr	.LBB46_17
	.local	.LBB46_15
.LBB46_15:
	ld	hl, (ix - 4)
	ld	a, (ix - 1)                     ; 1-byte Folded Reload
	ld	e, a
	call	__lcmpzero
	ld	e, 0
	push	hl
	pop	bc
	jp	p, .LBB46_22
	jr	.LBB46_23
	.local	.LBB46_16
.LBB46_16:
	ld	l, 1
	.local	.LBB46_17
.LBB46_17:
	bit	0, l
	lea	bc, iy + 0
	jr	nz, .LBB46_19
; %bb.18:
	ld	bc, (ix - 10)
	.local	.LBB46_19
.LBB46_19:
	bit	0, l
	jr	nz, .LBB46_21
; %bb.20:
	ld	a, e
	.local	.LBB46_21
.LBB46_21:
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	ld	(iy + 11), bc
	ld	(iy + 14), a
	.local	.LBB46_22
.LBB46_22:
	ld	hl, 300
	ld	(ix - 7), hl
	call	__lcmpu
	jr	nc, .LBB46_24
	.local	.LBB46_23
.LBB46_23:
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	ld	hl, (ix - 7)
	ld	(iy + 11), hl
	ld	(iy + 14), e
	.local	.LBB46_24
.LBB46_24:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end46
.Lfunc_end46:
	.size	__ZN5rally6Motion9speedStepEbb, .Lfunc_end46-__ZN5rally6Motion9speedStepEbb
                                        ; -- End function
	.weak	__ZN5rally6Motion11lateralStepEl ; -- Begin function _ZN5rally6Motion11lateralStepEl
	.type	__ZN5rally6Motion11lateralStepEl,@function
__ZN5rally6Motion11lateralStepEl:       ; @_ZN5rally6Motion11lateralStepEl
	.local	.Lfunc_begin47
.Lfunc_begin47:
; %bb.0:
	ld	hl, -26
	call	__frameset
	ld	iy, (ix + 6)
	or	a, a
	sbc	hl, hl
	ld	(ix - 15), hl
	ld	hl, (iy + 23)
	ld	(ix - 21), hl
	ld	hl, (iy + 25)
	ld	(ix - 18), hl
	ld	hl, (iy + 11)
	ld	(ix - 7), hl
	ld	a, (iy + 14)
	ld	(ix - 8), a
	ld	hl, (iy + 19)
	ld	(ix - 11), hl
	ld	a, (iy + 22)
	ld	(ix - 12), a
	ld	a, (iy + 30)
	ld	(ix - 22), a
	ld	bc, (iy + 27)
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
	ld	bc, 46080
	xor	a, a
	call	__lmulu
	ld	(ix - 26), hl
	ld	(ix - 23), e                    ; 1-byte Folded Spill
	ld	bc, 100
	call	__ldivs
	ld	(ix - 3), hl
	ld	(ix - 4), e                     ; 1-byte Folded Spill
	ld	iy, (ix + 6)
	ld	de, (iy + 15)
	ld	a, (iy + 18)
	ld	l, 31
	push	de
	pop	bc
	ld	iyl, a
	call	__lshrs
	ex	de, hl
	ld	d, 0
	ld	e, iyl
	call	__ladd
	call	__lxor
	push	hl
	pop	bc
	ld	a, e
	ld	hl, 24064
	ld	e, d
	call	__lcmpu
	jr	nc, .LBB47_2
; %bb.1:
	ld	bc, 200
	ld	hl, (ix - 26)
	ld	e, (ix - 23)                    ; 1-byte Folded Reload
	ld	a, d
	jr	.LBB47_4
	.local	.LBB47_2
.LBB47_2:
	ld	hl, 19968
	ld	e, d
	call	__lcmpu
	jr	nc, .LBB47_5
; %bb.3:
	ld	bc, 115
	ld	hl, (ix - 3)
	ld	e, (ix - 4)                     ; 1-byte Folded Reload
	ld	a, d
	call	__lmulu
	ld	bc, 100
	.local	.LBB47_4
.LBB47_4:
	call	__ldivs
	ld	(ix - 3), hl
	ld	(ix - 4), e                     ; 1-byte Folded Spill
	.local	.LBB47_5
.LBB47_5:
	ld	a, (ix - 22)                    ; 1-byte Folded Reload
	xor	a, 1
	ld	(ix - 22), a                    ; 1-byte Folded Spill
	ld	bc, (ix - 21)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	de
	ld	d, a
	ld	e, c
	ld	iy, (ix - 18)
	ld	a, iyh
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	bc
	ld	b, a
	ld	c, iyl
	ex	de, hl
	or	a, a
	sbc	hl, bc
	ld	(ix - 18), hl
	push	hl
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	iy
	ld	l, 9
	ld	bc, (ix - 7)
	ld	a, (ix - 8)                     ; 1-byte Folded Reload
	call	__lshl
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 18)
	ld	a, iyl
	call	__lmulu
	ld	bc, 63
	ld	d, b
	ld	a, d
	call	__ldivs
	ld	bc, (ix - 11)
	ld	a, (ix - 12)                    ; 1-byte Folded Reload
	call	__lsub
	ld	bc, 100
	ld	a, d
	call	__lmulu
	ld	bc, 12
	call	__ldivs
	ld	a, (ix - 22)                    ; 1-byte Folded Reload
	ld	iyl, a
	bit	0, a
	ld	bc, 0
	ld	a, d
	jr	nz, .LBB47_7
; %bb.6:
	ld	bc, (ix + 9)
	.local	.LBB47_7
.LBB47_7:
	ld	d, iyl
	bit	0, d
	jr	nz, .LBB47_9
; %bb.8:
	ld	a, (ix + 12)
	.local	.LBB47_9
.LBB47_9:
	call	__ladd
	push	hl
	pop	iy
	ld	d, e
	ld	bc, (ix - 3)
	ld	a, (ix - 4)                     ; 1-byte Folded Reload
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB47_11
; %bb.10:
	ld	a, 0
	jr	.LBB47_12
	.local	.LBB47_11
.LBB47_11:
	ld	a, 1
	.local	.LBB47_12
.LBB47_12:
	bit	0, a
	jr	nz, .LBB47_14
; %bb.13:
	ld	iy, (ix - 3)
	.local	.LBB47_14
.LBB47_14:
	bit	0, a
	jr	nz, .LBB47_16
; %bb.15:
	ld	d, (ix - 4)                     ; 1-byte Folded Reload
	.local	.LBB47_16
.LBB47_16:
	ld	hl, (ix - 3)
	ld	e, (ix - 4)                     ; 1-byte Folded Reload
	call	__lneg
	lea	bc, iy + 0
	ld	a, d
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB47_18
; %bb.17:
	ld	a, 0
	jr	.LBB47_19
	.local	.LBB47_18
.LBB47_18:
	ld	a, 1
	.local	.LBB47_19
.LBB47_19:
	bit	0, a
	jr	nz, .LBB47_21
; %bb.20:
	push	hl
	pop	iy
	.local	.LBB47_21
.LBB47_21:
	bit	0, a
	jr	nz, .LBB47_23
; %bb.22:
	ld	d, e
	.local	.LBB47_23
.LBB47_23:
	lea	hl, iy + 0
	ld	e, d
	ld	bc, (ix + 9)
	ld	a, (ix + 12)
	call	__lsub
	ld	bc, 100
	ld	d, b
	ld	a, d
	call	__ldivs
	ld	bc, (ix - 11)
	ld	a, (ix - 12)                    ; 1-byte Folded Reload
	call	__ladd
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 7)
	ld	e, (ix - 8)                     ; 1-byte Folded Reload
	call	__lcmpzero
	jr	z, .LBB47_25
; %bb.24:
	ld	l, 0
	jr	.LBB47_26
	.local	.LBB47_25
.LBB47_25:
	ld	l, 1
	.local	.LBB47_26
.LBB47_26:
	bit	0, l
	jr	nz, .LBB47_28
; %bb.27:
	ld	(ix - 15), bc
	.local	.LBB47_28
.LBB47_28:
	bit	0, l
	jr	nz, .LBB47_30
; %bb.29:
	ld	d, a
	.local	.LBB47_30
.LBB47_30:
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	ld	hl, (ix - 15)
	ld	(iy + 19), hl
	ld	(iy + 22), d
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end47
.Lfunc_end47:
	.size	__ZN5rally6Motion11lateralStepEl, .Lfunc_end47-__ZN5rally6Motion11lateralStepEl
                                        ; -- End function
	.weak	__ZN5rally4game5Rules9raceReadyEv ; -- Begin function _ZN5rally4game5Rules9raceReadyEv
	.type	__ZN5rally4game5Rules9raceReadyEv,@function
__ZN5rally4game5Rules9raceReadyEv:      ; @_ZN5rally4game5Rules9raceReadyEv
	.local	.Lfunc_begin48
.Lfunc_begin48:
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
	.weak	__ZNK5rally4game5Rules14qualifyingGridEm ; -- Begin function _ZNK5rally4game5Rules14qualifyingGridEm
	.type	__ZNK5rally4game5Rules14qualifyingGridEm,@function
__ZNK5rally4game5Rules14qualifyingGridEm: ; @_ZNK5rally4game5Rules14qualifyingGridEm
	.local	.Lfunc_begin49
.Lfunc_begin49:
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
	jr	nc, .LBB49_2
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
	jr	.LBB49_3
	.local	.LBB49_2
.LBB49_2:
	ld	l, 1
	.local	.LBB49_3
.LBB49_3:
	ld	a, l
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end49
.Lfunc_end49:
	.size	__ZNK5rally4game5Rules14qualifyingGridEm, .Lfunc_end49-__ZNK5rally4game5Rules14qualifyingGridEm
                                        ; -- End function
	.weak	__ZN5rally4game11skyViewportERNS_6StreamEiiii ; -- Begin function _ZN5rally4game11skyViewportERNS_6StreamEiiii
	.type	__ZN5rally4game11skyViewportERNS_6StreamEiiii,@function
__ZN5rally4game11skyViewportERNS_6StreamEiiii: ; @_ZN5rally4game11skyViewportERNS_6StreamEiiii
	.local	.Lfunc_begin50
.Lfunc_begin50:
; %bb.0:
	ld	hl, -9
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	(ix - 9), hl
	ld	bc, (ix + 12)
	ld	hl, (ix + 15)
	ld	(ix - 3), hl
	ld	hl, (ix + 18)
	ld	(ix - 6), hl
	push	bc
	pop	hl
	ld	de, 25
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB50_2
; %bb.1:
	ld	bc, 24
	.local	.LBB50_2
.LBB50_2:
	ld	(ix + 6), iy
	ld	hl, (ix - 9)
	ld	(ix + 9), hl
	ld	(ix + 12), bc
	ld	hl, (ix - 3)
	ld	(ix + 15), hl
	ld	hl, (ix - 6)
	ld	(ix + 18), hl
	ld	sp, ix
	pop	ix
	jp	__ZN5rally4game8viewportERNS_6StreamEiiii
	.local	.Lfunc_end50
.Lfunc_end50:
	.size	__ZN5rally4game11skyViewportERNS_6StreamEiiii, .Lfunc_end50-__ZN5rally4game11skyViewportERNS_6StreamEiiii
                                        ; -- End function
	.weak	__ZNK5rally10DirectRoad8centerAtEi ; -- Begin function _ZNK5rally10DirectRoad8centerAtEi
	.type	__ZNK5rally10DirectRoad8centerAtEi,@function
__ZNK5rally10DirectRoad8centerAtEi:     ; @_ZNK5rally10DirectRoad8centerAtEi
	.local	.Lfunc_begin51
.Lfunc_begin51:
; %bb.0:
	ld	hl, -27
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	de, -104
	push	hl
	pop	bc
	add	hl, de
	ld	de, 121
	or	a, a
	sbc	hl, de
	jr	nc, .LBB51_2
; %bb.1:
	ld	de, 1039
	ld	a, 2
	push	bc
	pop	hl
	ld	c, a
	call	__ishl
	push	hl
	pop	bc
	add	iy, bc
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	jp	.LBB51_5
	.local	.LBB51_2
.LBB51_2:
	ld	de, 97
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB51_4
; %bb.3:
	ld	hl, 160
	jp	.LBB51_6
	.local	.LBB51_4
.LBB51_4:
	ld	de, -96
	ld	hl, 2048000
	push	bc
	pop	iy
	add	iy, de
	ld	(ix - 19), iy
	xor	a, a
	ld	e, a
	lea	bc, iy + 0
	call	__ldivu
	push	hl
	pop	bc
	ld	a, e
	ld	de, 2167
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	ld	iy, (ix + 6)
	ld	bc, (iy)
	push	bc
	push	de
	push	hl
	pea	ix - 16
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, (ix - 16)
	ld	de, 2175
	ld	iy, (ix + 6)
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	a, (ix - 13)
	call	__lsub
	ld	(ix - 22), hl
	ld	(ix - 23), e                    ; 1-byte Folded Spill
	ld	hl, (ix - 12)
	ld	de, 2179
	ld	iy, (ix + 6)
	add	iy, de
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	e, (ix - 9)
	ld	a, (iy)
	call	__lsub
	ld	(ix - 26), hl
	ld	(ix - 27), e                    ; 1-byte Folded Spill
	ld	de, 2187
	ld	iy, (ix + 6)
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix - 22)
	ld	a, (ix - 23)                    ; 1-byte Folded Reload
	call	__lmulu
	ld	(ix - 22), hl
	ld	d, e
	ld	bc, 2183
	ld	iy, (ix + 6)
	add	iy, bc
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix - 26)
	ld	a, (ix - 27)                    ; 1-byte Folded Reload
	call	__lmulu
	ld	bc, (ix - 22)
	ld	a, d
	call	__ladd
	ld	bc, 4096
	xor	a, a
	call	__ldivs
	ld	bc, 2171
	ld	iy, (ix + 6)
	add	iy, bc
	ld	bc, (iy)
	lea	iy, iy + 3
	ld	a, (iy)
	call	__lsub
	ld	bc, (ix - 19)
	xor	a, a
	call	__lmulu
	ld	bc, 50
	call	__ldivs
	ld	bc, 40960
	call	__ladd
	.local	.LBB51_5
.LBB51_5:
	ld	bc, 256
	xor	a, a
	call	__ldivs
	.local	.LBB51_6
.LBB51_6:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end51
.Lfunc_end51:
	.size	__ZNK5rally10DirectRoad8centerAtEi, .Lfunc_end51-__ZNK5rally10DirectRoad8centerAtEi
                                        ; -- End function
	.weak	__ZN5rally6Stream4rectEiiiii    ; -- Begin function _ZN5rally6Stream4rectEiiiii
	.type	__ZN5rally6Stream4rectEiiiii,@function
__ZN5rally6Stream4rectEiiiii:           ; @_ZN5rally6Stream4rectEiiiii
	.local	.Lfunc_begin52
.Lfunc_begin52:
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
	.local	.Lfunc_end52
.Lfunc_end52:
	.size	__ZN5rally6Stream4rectEiiiii, .Lfunc_end52-__ZN5rally6Stream4rectEiiiii
                                        ; -- End function
	.weak	__ZN5rally6Stream5colorEi       ; -- Begin function _ZN5rally6Stream5colorEi
	.type	__ZN5rally6Stream5colorEi,@function
__ZN5rally6Stream5colorEi:              ; @_ZN5rally6Stream5colorEi
	.local	.Lfunc_begin53
.Lfunc_begin53:
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
	jr	nc, .LBB53_4
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
	jr	nc, .LBB53_4
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
	jr	nc, .LBB53_4
; %bb.3:
	ld	a, (ix + 9)
	ld	hl, (ix + 6)
	add	hl, bc
	inc	bc
	ld	(iy), bc
	ld	(hl), a
	jr	.LBB53_5
	.local	.LBB53_4
.LBB53_4:
	ld	de, 4099
	ld	hl, (ix + 6)
	add	hl, de
	ld	(hl), 1
	.local	.LBB53_5
.LBB53_5:
	pop	ix
	ret
	.local	.Lfunc_end53
.Lfunc_end53:
	.size	__ZN5rally6Stream5colorEi, .Lfunc_end53-__ZN5rally6Stream5colorEi
                                        ; -- End function
	.weak	__ZN5rally6Stream4plotEiii      ; -- Begin function _ZN5rally6Stream4plotEiii
	.type	__ZN5rally6Stream4plotEiii,@function
__ZN5rally6Stream4plotEiii:             ; @_ZN5rally6Stream4plotEiii
	.local	.Lfunc_begin54
.Lfunc_begin54:
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
	jr	nc, .LBB54_3
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
	jr	nc, .LBB54_3
; %bb.2:
	ld	hl, (ix - 3)
	add	hl, de
	push	hl
	pop	iy
	inc	de
	ld	hl, (ix - 12)
	ld	(hl), de
	ld	(iy), a
	jr	.LBB54_4
	.local	.LBB54_3
.LBB54_3:
	ld	de, 4099
	ld	hl, (ix - 3)
	add	hl, de
	ld	(hl), 1
	.local	.LBB54_4
.LBB54_4:
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
	.local	.Lfunc_end54
.Lfunc_end54:
	.size	__ZN5rally6Stream4plotEiii, .Lfunc_end54-__ZN5rally6Stream4plotEiii
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_113trafficMatrixEjiii,@function ; -- Begin function _ZN12_GLOBAL__N_113trafficMatrixEjiii
__ZN12_GLOBAL__N_113trafficMatrixEjiii: ; @_ZN12_GLOBAL__N_113trafficMatrixEjiii
	.local	.Lfunc_begin55
.Lfunc_begin55:
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	hl, (ix + 6)
	ld	(ix - 3), hl
	ld	hl, (ix + 9)
	ld	(ix - 12), hl
	ld	iy, (ix + 12)
	ld	hl, (ix + 15)
	ld	(ix - 9), hl
	ld	a, 1
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	ld	bc, 4096
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	ld	(ix - 6), iy
	jr	nc, .LBB55_4
; %bb.1:
	ld	hl, __ZN12_GLOBAL__N_16streamE
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 23
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_4
; %bb.2:
	ld	hl, __ZN12_GLOBAL__N_16streamE
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 0
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_4
; %bb.3:
	ld	bc, __ZN12_GLOBAL__N_16streamE
	push	bc
	pop	hl
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), -96
	push	bc
	pop	de
	jr	.LBB55_5
	.local	.LBB55_4
.LBB55_4:
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	ld	de, __ZN12_GLOBAL__N_16streamE
	.local	.LBB55_5
.LBB55_5:
	ld	hl, (ix - 3)
	push	hl
	push	de
	call	__ZN5rally6Stream4wordEi
	ld	bc, __ZN12_GLOBAL__N_16streamE
	push	bc
	pop	iy
	pop	hl
	pop	hl
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_11
; %bb.6:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 32
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_11
; %bb.7:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 0
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_11
; %bb.8:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 23
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	ld	a, 1
	jr	nc, .LBB55_12
; %bb.9:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 0
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_12
; %bb.10:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), -96
	jr	.LBB55_13
	.local	.LBB55_11
.LBB55_11:
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	.local	.LBB55_12
.LBB55_12:
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	.local	.LBB55_13
.LBB55_13:
	ld	hl, (ix - 3)
	push	hl
	push	iy
	call	__ZN5rally6Stream4wordEi
	ld	bc, __ZN12_GLOBAL__N_16streamE
	push	bc
	pop	iy
	pop	hl
	pop	hl
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	ld	bc, 4096
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_17
; %bb.14:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 32
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_17
; %bb.15:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), 11
	ld	de, (__ZN12_GLOBAL__N_16streamE+4096)
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	nc, .LBB55_17
; %bb.16:
	lea	hl, iy + 0
	add	hl, de
	inc	de
	ld	(__ZN12_GLOBAL__N_16streamE+4096), de
	ld	(hl), -56
	jr	.LBB55_18
	.local	.LBB55_17
.LBB55_17:
	ld	a, 1
	ld	(__ZN12_GLOBAL__N_16streamE+4099), a
	.local	.LBB55_18
.LBB55_18:
	ld	hl, (ix - 12)
	push	hl
	push	iy
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, (ix - 9)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	ld	hl, (ix - 6)
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally6Stream4wordEi
	pop	hl
	pop	hl
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, __ZN12_GLOBAL__N_16streamE
	push	hl
	call	__ZN5rally6Stream4wordEi
	ld	sp, ix
	pop	ix
	jp	__ZN12_GLOBAL__N_15flushEv
	.local	.Lfunc_end55
.Lfunc_end55:
	.size	__ZN12_GLOBAL__N_113trafficMatrixEjiii, .Lfunc_end55-__ZN12_GLOBAL__N_113trafficMatrixEjiii
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_14textEiiPKcii,@function ; -- Begin function _ZN12_GLOBAL__N_14textEiiPKcii
__ZN12_GLOBAL__N_14textEiiPKcii:        ; @_ZN12_GLOBAL__N_14textEiiPKcii
	.local	.Lfunc_begin56
.Lfunc_begin56:
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	hl, (ix + 6)
	ld	(ix - 6), hl
	ld	hl, (ix + 9)
	ld	(ix - 9), hl
	ld	hl, (ix + 12)
	ld	(ix - 3), hl
	ld	hl, (ix + 15)
	ld	de, (ix + 18)
	ld	(ix - 12), de
	push	hl
	call	_vdp_set_text_colour
	pop	hl
	ld	hl, (ix - 12)
	push	hl
	call	_vdp_set_text_bg_colour
	pop	hl
	ld	hl, (ix - 9)
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
	jp	__ZN12_GLOBAL__N_14sendEPKhj
	.local	.Lfunc_end56
.Lfunc_end56:
	.size	__ZN12_GLOBAL__N_14textEiiPKcii, .Lfunc_end56-__ZN12_GLOBAL__N_14textEiiPKcii
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_16centreEiPKci,@function ; -- Begin function _ZN12_GLOBAL__N_16centreEiPKci
__ZN12_GLOBAL__N_16centreEiPKci:        ; @_ZN12_GLOBAL__N_16centreEiPKci
	.local	.Lfunc_begin57
.Lfunc_begin57:
; %bb.0:
	call	__frameset0
	ld	hl, (ix + 9)
	push	hl
	call	_strlen
	push	hl
	pop	de
	pop	hl
	ld	hl, 40
	or	a, a
	sbc	hl, de
	ld	bc, 2
	call	__idivs
	ld	de, 20
	push	de
	ld	de, (ix + 12)
	push	de
	ld	de, (ix + 9)
	push	de
	ld	de, (ix + 6)
	push	de
	push	hl
	call	__ZN12_GLOBAL__N_14textEiiPKcii
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end57
.Lfunc_end57:
	.size	__ZN12_GLOBAL__N_16centreEiPKci, .Lfunc_end57-__ZN12_GLOBAL__N_16centreEiPKci
                                        ; -- End function
	.type	__ZN12_GLOBAL__N_19clockTextEPcjm,@function ; -- Begin function _ZN12_GLOBAL__N_19clockTextEPcjm
__ZN12_GLOBAL__N_19clockTextEPcjm:      ; @_ZN12_GLOBAL__N_19clockTextEPcjm
	.local	.Lfunc_begin58
.Lfunc_begin58:
; %bb.0:
	ld	hl, -13
	call	__frameset
	ld	hl, (ix + 9)
	ld	bc, 100
	xor	a, a
	ld	e, (ix + 12)
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	(ix - 13), d
	ld	bc, 120
	call	__ldivu
	ld	(ix - 9), hl
	ld	(ix - 10), e                    ; 1-byte Folded Spill
	lea	hl, iy + 0
	ld	e, d
	ld	bc, 720000
	call	__ldivu
	ld	(ix - 3), hl
                                        ; kill: def $e killed $e def $ude
	ld	(ix - 6), de
	lea	hl, iy + 0
	ld	e, (ix - 13)                    ; 1-byte Folded Reload
	ld	bc, 12000
	call	__ldivu
	ld	bc, 60
	call	__lremu
	ld	(ix - 13), hl
	ld	iyl, e
	ld	hl, (ix - 9)
	ld	e, (ix - 10)                    ; 1-byte Folded Reload
	ld	bc, 100
	call	__lremu
                                        ; kill: def $e killed $e def $ude
	push	de
	push	hl
	push	iy
	ld	hl, (ix - 13)
	push	hl
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	ld	hl, _.str.45
	push	hl
	ld	hl, 20
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	_snprintf
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end58
.Lfunc_end58:
	.size	__ZN12_GLOBAL__N_19clockTextEPcjm, .Lfunc_end58-__ZN12_GLOBAL__N_19clockTextEPcjm
                                        ; -- End function
	.weak	__ZN5rally4game8HudImageC2Ev    ; -- Begin function _ZN5rally4game8HudImageC2Ev
	.type	__ZN5rally4game8HudImageC2Ev,@function
__ZN5rally4game8HudImageC2Ev:           ; @_ZN5rally4game8HudImageC2Ev
	.local	.Lfunc_begin59
.Lfunc_begin59:
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
	.local	.LBB59_1
.LBB59_1:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	z, .LBB59_3
; %bb.2:                                ;   in Loop: Header=BB59_1 Depth=1
	ld	iy, (ix + 6)
	add	iy, bc
	ld	(iy), 32
	ld	(iy + 120), 15
	inc	bc
	jr	.LBB59_1
	.local	.LBB59_3
.LBB59_3:
	pop	ix
	ret
	.local	.Lfunc_end59
.Lfunc_end59:
	.size	__ZN5rally4game8HudImageC2Ev, .Lfunc_end59-__ZN5rally4game8HudImageC2Ev
                                        ; -- End function
	.weak	__ZN5rally4game8HudImage3putEjjPKch ; -- Begin function _ZN5rally4game8HudImage3putEjjPKch
	.type	__ZN5rally4game8HudImage3putEjjPKch,@function
__ZN5rally4game8HudImage3putEjjPKch:    ; @_ZN5rally4game8HudImage3putEjjPKch
	.local	.Lfunc_begin60
.Lfunc_begin60:
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
	jr	nc, .LBB60_5
; %bb.1:
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	(ix - 3), hl
	ld	hl, (ix + 15)
	add	iy, bc
	push	hl
	pop	bc
	.local	.LBB60_2
.LBB60_2:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	ld	e, (hl)
	ld	a, e
	or	a, a
	jr	z, .LBB60_5
; %bb.3:                                ;   in Loop: Header=BB60_2 Depth=1
	ld	(ix - 9), bc
	ld	hl, (ix - 3)
	ld	bc, 40
	or	a, a
	sbc	hl, bc
	ld	bc, (ix - 9)
	jr	nc, .LBB60_5
; %bb.4:                                ;   in Loop: Header=BB60_2 Depth=1
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
	jr	.LBB60_2
	.local	.LBB60_5
.LBB60_5:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end60
.Lfunc_end60:
	.size	__ZN5rally4game8HudImage3putEjjPKch, .Lfunc_end60-__ZN5rally4game8HudImage3putEjjPKch
                                        ; -- End function
	.weak	__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE ; -- Begin function _ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE
	.type	__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE,@function
__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE: ; @_ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE
	.local	.Lfunc_begin61
.Lfunc_begin61:
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
	jr	nz, .LBB61_2
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
	.local	.LBB61_2
.LBB61_2:
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
	.local	.LBB61_3
.LBB61_3:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB61_5 Depth 2
                                        ;       Child Loop BB61_24 Depth 3
	lea	hl, iy + 0
	or	a, a
	sbc	hl, bc
	jp	z, .LBB61_35
; %bb.4:                                ;   in Loop: Header=BB61_3 Depth=1
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
	.local	.LBB61_5
.LBB61_5:                               ;   Parent Loop BB61_3 Depth=1
                                        ; =>  This Loop Header: Depth=2
                                        ;       Child Loop BB61_24 Depth 3
	lea	hl, iy + 0
	ld	de, 40
	or	a, a
	sbc	hl, de
	jp	nc, .LBB61_34
; %bb.6:                                ;   in Loop: Header=BB61_5 Depth=2
	ld	(ix - 12), iy
	ld	de, (ix - 24)
	add	iy, de
	lea	de, iy + 0
	ld	hl, (ix - 6)
	bit	0, (hl)
	jr	z, .LBB61_10
; %bb.7:                                ;   in Loop: Header=BB61_5 Depth=2
	ld	hl, (ix - 18)
	add	hl, de
	ld	iy, (ix + 15)
	add	iy, de
	ld	c, (iy)
	ld	a, (hl)
	cp	a, c
	jr	nz, .LBB61_10
; %bb.8:                                ;   in Loop: Header=BB61_5 Depth=2
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
	jr	nz, .LBB61_10
; %bb.9:                                ;   in Loop: Header=BB61_5 Depth=2
	ld	iy, (ix - 12)
	inc	iy
	jr	.LBB61_5
	.local	.LBB61_10
.LBB61_10:                              ;   in Loop: Header=BB61_5 Depth=2
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
	jp	nc, .LBB61_18
; %bb.11:                               ;   in Loop: Header=BB61_5 Depth=2
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
	jp	nc, .LBB61_18
; %bb.12:                               ;   in Loop: Header=BB61_5 Depth=2
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
	jp	nc, .LBB61_18
; %bb.13:                               ;   in Loop: Header=BB61_5 Depth=2
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
	jp	nc, .LBB61_19
; %bb.14:                               ;   in Loop: Header=BB61_5 Depth=2
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
	jr	nc, .LBB61_19
; %bb.15:                               ;   in Loop: Header=BB61_5 Depth=2
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
	jr	nc, .LBB61_20
; %bb.16:                               ;   in Loop: Header=BB61_5 Depth=2
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
	jr	nc, .LBB61_20
; %bb.17:                               ;   in Loop: Header=BB61_5 Depth=2
	ld	de, (ix - 28)
	add	iy, de
	inc	de
	ld	hl, (ix - 15)
	ld	(hl), de
	ld	a, (ix - 29)
	ld	(iy), a
	jr	.LBB61_21
	.local	.LBB61_18
.LBB61_18:                              ;   in Loop: Header=BB61_5 Depth=2
	ld	iy, (ix + 9)
	lea	hl, iy + 0
	ld	bc, 4099
	add	hl, bc
	ld	(hl), 1
	.local	.LBB61_19
.LBB61_19:                              ;   in Loop: Header=BB61_5 Depth=2
	lea	hl, iy + 0
	add	hl, bc
	ld	(hl), 1
	.local	.LBB61_20
.LBB61_20:                              ;   in Loop: Header=BB61_5 Depth=2
	lea	hl, iy + 0
	add	hl, bc
	ld	(hl), 1
	.local	.LBB61_21
.LBB61_21:                              ;   in Loop: Header=BB61_5 Depth=2
	ld	bc, (ix - 12)
	push	bc
	pop	hl
	ld	de, 40
	or	a, a
	sbc	hl, de
	push	bc
	pop	hl
	jr	nc, .LBB61_23
; %bb.22:                               ;   in Loop: Header=BB61_5 Depth=2
	ld	hl, 39
	.local	.LBB61_23
.LBB61_23:                              ;   in Loop: Header=BB61_5 Depth=2
	inc	hl
	ld	(ix - 28), hl
	.local	.LBB61_24
.LBB61_24:                              ;   Parent Loop BB61_3 Depth=1
                                        ;     Parent Loop BB61_5 Depth=2
                                        ; =>    This Inner Loop Header: Depth=3
	ld	(ix - 12), bc
	ld	hl, (ix - 15)
	ld	bc, (hl)
	push	bc
	pop	hl
	ld	de, 4096
	or	a, a
	sbc	hl, de
	jr	nc, .LBB61_26
; %bb.25:                               ;   in Loop: Header=BB61_24 Depth=3
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
	jr	.LBB61_27
	.local	.LBB61_26
.LBB61_26:                              ;   in Loop: Header=BB61_24 Depth=3
	ld	hl, (ix + 9)
	ld	de, 4099
	add	hl, de
	ld	(hl), 1
	ld	bc, (ix - 12)
	.local	.LBB61_27
.LBB61_27:                              ;   in Loop: Header=BB61_24 Depth=3
	inc	bc
	push	bc
	pop	hl
	ld	de, 40
	or	a, a
	sbc	hl, de
	jr	nc, .LBB61_32
; %bb.28:                               ;   in Loop: Header=BB61_24 Depth=3
	ld	iy, (ix - 3)
	ld	de, (ix - 12)
	add	iy, de
	ld	a, (iy + 121)
	ld	l, (ix - 25)
	cp	a, l
	jr	nz, .LBB61_33
; %bb.29:                               ;   in Loop: Header=BB61_24 Depth=3
	ld	hl, (ix - 6)
	bit	0, (hl)
	jr	z, .LBB61_24
; %bb.30:                               ;   in Loop: Header=BB61_24 Depth=3
	ld	hl, (ix - 9)
	add	hl, de
	ld	e, (iy + 1)
	push	hl
	pop	iy
	ld	a, (iy + 1)
	cp	a, e
	jr	nz, .LBB61_24
; %bb.31:                               ;   in Loop: Header=BB61_24 Depth=3
	ld	a, (iy + 121)
	ld	l, (ix - 25)
	cp	a, l
	push	bc
	pop	iy
	jp	z, .LBB61_5
	jp	.LBB61_24
	.local	.LBB61_32
.LBB61_32:                              ;   in Loop: Header=BB61_5 Depth=2
	ld	iy, (ix - 28)
	jp	.LBB61_5
	.local	.LBB61_33
.LBB61_33:                              ;   in Loop: Header=BB61_5 Depth=2
	push	bc
	pop	iy
	jp	.LBB61_5
	.local	.LBB61_34
.LBB61_34:                              ;   in Loop: Header=BB61_3 Depth=1
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
	jp	.LBB61_3
	.local	.LBB61_35
.LBB61_35:
	ld	de, (ix - 18)
	ld	hl, (ix + 15)
	ld	bc, 240
	ldir
	ld	hl, (ix - 6)
	ld	(hl), 1
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end61
.Lfunc_end61:
	.size	__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE, .Lfunc_end61-__ZN5rally4game3Hud4emitERNS_6StreamEjRKNS0_8HudImageE
                                        ; -- End function
	.weak	__ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE ; -- Begin function _ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE
	.type	__ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE,@function
__ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE: ; @_ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE
	.local	.Lfunc_begin62
.Lfunc_begin62:
; %bb.0:
	ld	hl, -4642
	call	__frameset
	ld	hl, (ix + 9)
	ld	bc, -2326
	lea	iy, ix + 0
	add	iy, bc
	lea	de, iy + 0
	push	ix
	ld	bc, -4633
	add	ix, bc
	ld	(ix + 0), de
	pop	ix
	push	de
	push	hl
	call	__ZNK5rally4game7Records6encodeEPh
	pop	hl
	pop	hl
	ld	hl, _.str.59
	push	hl
	ld	hl, (ix + 6)
	push	hl
	call	_fopen
	push	hl
	pop	bc
	pop	hl
	pop	hl
	push	bc
	pop	hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	z, .LBB62_11
; %bb.1:
	ld	hl, 1
	ld	de, 2320
	push	bc
	push	de
	push	hl
	ld	de, -4633
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	push	hl
	ld	de, -4636
	lea	hl, ix + 0
	add	hl, de
	ld	(hl), bc
	call	_fwrite
	ld	bc, -4633
	lea	iy, ix + 0
	add	iy, bc
	ld	(iy + 0), hl
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, -4636
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	push	hl
	call	_fclose
	push	hl
	pop	de
	pop	hl
	ld	bc, 2320
	ld	(ix - 3), de
	ld	de, -4633
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	or	a, a
	sbc	hl, bc
	ld	de, (ix - 3)
	jp	nz, .LBB62_11
; %bb.2:
	ex	de, hl
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jp	nz, .LBB62_11
; %bb.3:
	ld	de, -4630
	lea	iy, ix + 0
	add	iy, de
	lea	hl, iy + 0
	ld	(iy + 0), 0
	push	hl
	pop	iy
	inc	iy
	ld	bc, 2303
	lea	de, iy + 0
	push	hl
	pop	iy
	ldir
	ld	bc, -4633
	lea	hl, ix + 0
	add	hl, bc
	ld	(hl), iy
	push	iy
	ld	hl, (ix + 6)
	push	hl
	call	__ZN5rally4game11readRecordsEPKcRNS0_7RecordsE
	pop	hl
	pop	hl
	bit	0, a
	ld	a, 0
	jp	z, .LBB62_12
; %bb.4:
	ld	de, -4633
	lea	hl, ix + 0
	add	hl, de
	ld	iy, (hl)
	lea	hl, iy + 4
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	iy, (ix + 9)
	lea	hl, iy + 4
	ld	de, -4636
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	ld	bc, 288
	ld	d, b
	or	a, a
	sbc	hl, hl
	.local	.LBB62_5
.LBB62_5:                               ; =>This Inner Loop Header: Depth=1
	ld	(ix - 3), de
	ld	de, -4639
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), hl
	or	a, a
	sbc	hl, bc
	ld	de, (ix - 3)
	jp	z, .LBB62_10
; %bb.6:                                ;   in Loop: Header=BB62_5 Depth=1
	ld	bc, -4636
	lea	hl, ix + 0
	add	hl, bc
	ld	iy, (hl)
	ld	hl, (iy - 4)
	ld	a, d
	lea	de, iy + 0
	ld	bc, -4633
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	bc, (iy - 4)
	push	de
	pop	iy
	ld	d, a
	ld	e, (iy - 1)
	ld	(ix - 3), bc
	ld	bc, -4633
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	a, (iy - 1)
	ld	bc, (ix - 3)
	call	__lcmpu
	ld	bc, 288
	jp	nz, .LBB62_10
; %bb.7:                                ;   in Loop: Header=BB62_5 Depth=1
	ld	bc, -4636
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	ld	hl, (hl)
	ld	bc, -4633
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	ld	bc, (iy)
	ld	(ix - 3), de
	ld	de, -4642
	lea	iy, ix + 0
	add	iy, de
	ld	(iy + 0), bc
	push	ix
	ld	bc, -4636
	add	ix, bc
	ld	iy, (ix + 0)
	pop	ix
	ld	de, (ix - 3)
	ld	e, (iy + 3)
	ld	(ix - 3), de
	ld	de, -4642
	lea	iy, ix + 0
	add	iy, de
	ld	bc, (iy + 0)
	push	ix
	ld	de, -4633
	add	ix, de
	ld	iy, (ix + 0)
	pop	ix
	ld	a, (iy + 3)
	ld	de, (ix - 3)
	call	__lcmpu
	ld	a, d
	jr	z, .LBB62_9
; %bb.8:                                ;   in Loop: Header=BB62_5 Depth=1
	ld	a, 0
	.local	.LBB62_9
.LBB62_9:                               ;   in Loop: Header=BB62_5 Depth=1
	ld	bc, -4639
	lea	hl, ix + 0
	add	hl, bc
	ld	hl, (hl)
	inc	hl
	ld	bc, -4633
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	lea	iy, iy + 8
	push	ix
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	ld	bc, -4636
	lea	iy, ix + 0
	add	iy, bc
	ld	iy, (iy + 0)
	lea	iy, iy + 8
	push	ix
	add	ix, bc
	ld	(ix + 0), iy
	pop	ix
	bit	0, a
	ld	bc, 288
	jp	nz, .LBB62_5
	.local	.LBB62_10
.LBB62_10:
	ld	de, -4639
	lea	hl, ix + 0
	add	hl, de
	ld	hl, (hl)
	or	a, a
	sbc	hl, bc
	ccf
                                        ; kill: def $a killed $a
	sbc	a, a
	jr	.LBB62_12
	.local	.LBB62_11
.LBB62_11:
	xor	a, a
	.local	.LBB62_12
.LBB62_12:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end62
.Lfunc_end62:
	.size	__ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE, .Lfunc_end62-__ZN5rally4game12writeRecordsEPKcRKNS0_7RecordsE
                                        ; -- End function
	.weak	__ZNK5rally4game7Records6encodeEPh ; -- Begin function _ZNK5rally4game7Records6encodeEPh
	.type	__ZNK5rally4game7Records6encodeEPh,@function
__ZNK5rally4game7Records6encodeEPh:     ; @_ZNK5rally4game7Records6encodeEPh
	.local	.Lfunc_begin63
.Lfunc_begin63:
; %bb.0:
	ld	hl, -9
	call	__frameset
	ld	iy, (ix + 9)
	ld	hl, 4280897
	ld	de, 5852236
	ld.sis	bc, 12592
	ld	(iy), hl
	ld	(iy + 3), de
	ld	(iy + 6), c
	ld	(iy + 7), b
	or	a, a
	sbc	hl, hl
	push	hl
	ld	hl, 288
	push	hl
	pea	iy + 8
	call	__ZN5rally4game7Records5put32EPhm
	ld	bc, 0
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB63_1
.LBB63_1:                               ; =>This Inner Loop Header: Depth=1
	ld	de, 2304
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	z, .LBB63_3
; %bb.2:                                ;   in Loop: Header=BB63_1 Depth=1
	push	bc
	pop	de
	ld	hl, (ix + 9)
	add	hl, de
	ld	(ix - 3), hl
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	add	iy, de
	ld	(ix - 9), iy
	ld	hl, (iy)
	ld	e, (iy + 3)
	push	de
	push	hl
	ld	iy, (ix - 3)
	pea	iy + 16
	ld	(ix - 6), bc
	call	__ZN5rally4game7Records5put32EPhm
	pop	hl
	pop	hl
	pop	hl
	ld	iy, (ix - 9)
	ld	hl, (iy + 4)
	ld	e, (iy + 7)
	push	de
	push	hl
	ld	iy, (ix - 3)
	pea	iy + 20
	call	__ZN5rally4game7Records5put32EPhm
	ld	iy, (ix - 6)
	pop	hl
	pop	hl
	pop	hl
	ld	de, 8
	add	iy, de
	lea	bc, iy + 0
	jr	.LBB63_1
	.local	.LBB63_3
.LBB63_3:
	ld	hl, 2304
	push	hl
	ld	hl, (ix + 9)
	push	hl
	pop	iy
	pea	iy + 16
	call	__ZN5rally4game7Records4hashEPKhj
                                        ; kill: def $e killed $e def $ude
	pop	bc
	pop	bc
	push	de
	push	hl
	ld	iy, (ix + 9)
	pea	iy + 12
	call	__ZN5rally4game7Records5put32EPhm
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end63
.Lfunc_end63:
	.size	__ZNK5rally4game7Records6encodeEPh, .Lfunc_end63-__ZNK5rally4game7Records6encodeEPh
                                        ; -- End function
	.weak	__ZN5rally4game7Records5put32EPhm ; -- Begin function _ZN5rally4game7Records5put32EPhm
	.type	__ZN5rally4game7Records5put32EPhm,@function
__ZN5rally4game7Records5put32EPhm:      ; @_ZN5rally4game7Records5put32EPhm
	.local	.Lfunc_begin64
.Lfunc_begin64:
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	iy, (ix + 9)
	ld	a, (ix + 12)
	ld	bc, 0
	.local	.LBB64_1
.LBB64_1:                               ; =>This Inner Loop Header: Depth=1
	ld	de, 4
	push	bc
	pop	hl
	or	a, a
	sbc	hl, de
	jr	z, .LBB64_3
; %bb.2:                                ;   in Loop: Header=BB64_1 Depth=1
	ex	de, hl
	ld	e, iyl
	ex	de, hl
	ld	(ix - 3), iy
	ld	iy, (ix + 6)
	push	bc
	pop	de
	add	iy, de
	ld	(iy), l
	ld	bc, (ix - 3)
	ld	l, 8
	call	__lshru
	push	bc
	pop	iy
	inc	de
	push	de
	pop	bc
	jr	.LBB64_1
	.local	.LBB64_3
.LBB64_3:
	pop	hl
	pop	ix
	ret
	.local	.Lfunc_end64
.Lfunc_end64:
	.size	__ZN5rally4game7Records5put32EPhm, .Lfunc_end64-__ZN5rally4game7Records5put32EPhm
                                        ; -- End function
	.weak	__ZN5rally10DirectRoad7projectElll ; -- Begin function _ZN5rally10DirectRoad7projectElll
	.type	__ZN5rally10DirectRoad7projectElll,@function
__ZN5rally10DirectRoad7projectElll:     ; @_ZN5rally10DirectRoad7projectElll
	.local	.Lfunc_begin65
.Lfunc_begin65:
; %bb.0:
	ld	hl, -22
	call	__frameset
	ld	hl, (ix + 9)
	ld	bc, 100
	xor	a, a
	lea	de, ix - 16
	ld	(ix - 19), de
	ld	e, (ix + 12)
	call	__ldivs
	push	hl
	pop	iy
	ld	l, 8
	lea	bc, iy + 0
	ld	a, e
	call	__lshl
	ld	(ix - 22), bc
	ld	d, a
	lea	hl, iy + 0
	ld	bc, 100
	ld	iyl, b
	ld	a, iyl
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	call	__lsub
	push	hl
	pop	bc
	ld	a, e
	ld	l, 8
	call	__lshl
	push	bc
	pop	hl
	ld	e, a
	ld	bc, 100
	ld	a, iyl
	call	__ldivs
	ld	bc, (ix - 22)
	ld	a, d
	call	__ladd
	ld	(ix - 22), hl
	ld	hl, (ix + 6)
	push	hl
	pop	iy
	ld	bc, 2167
	add	iy, bc
	ld	bc, (ix - 22)
	ld	(iy), bc
	lea	iy, iy + 3
	ld	(iy), e
	ld	bc, 2171
	push	hl
	pop	iy
	add	iy, bc
	ld	bc, (ix + 21)
	ld	(iy), bc
	lea	iy, iy + 3
	ld	a, (ix + 24)
	ld	(iy), a
	ld	bc, (hl)
	push	bc
                                        ; kill: def $e killed $e def $ude
	push	de
	ld	hl, (ix - 22)
	push	hl
	ld	hl, (ix - 19)
	push	hl
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	de, 2175
	ld	iy, (ix + 6)
	lea	hl, iy + 0
	add	hl, de
	ex	de, hl
	ld	hl, (ix - 19)
	ld	bc, 16
	ldir
	ld	l, (ix + 24)
	push	hl
	ld	hl, (ix + 21)
	push	hl
	ld	l, (ix + 18)
	push	hl
	ld	hl, (ix + 15)
	push	hl
	ld	l, (ix + 12)
	push	hl
	ld	hl, (ix + 9)
	push	hl
	push	iy
	call	__ZN5rally4Road7projectElll
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end65
.Lfunc_end65:
	.size	__ZN5rally10DirectRoad7projectElll, .Lfunc_end65-__ZN5rally10DirectRoad7projectElll
                                        ; -- End function
	.weak	__ZN5rally14sceneryHeadingEll   ; -- Begin function _ZN5rally14sceneryHeadingEll
	.type	__ZN5rally14sceneryHeadingEll,@function
__ZN5rally14sceneryHeadingEll:          ; @_ZN5rally14sceneryHeadingEll
	.local	.Lfunc_begin66
.Lfunc_begin66:
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
	jp	z, .LBB66_13
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
	jr	nc, .LBB66_3
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
	jr	.LBB66_4
	.local	.LBB66_3
.LBB66_3:
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
	.local	.LBB66_4
.LBB66_4:
	ld	hl, (ix + 12)
	ld	e, iyl
	call	__lcmpzero
	ld	a, 1
	ld	d, 0
	ld	iyl, a
	jp	m, .LBB66_6
; %bb.5:
	ld	iyl, d
	.local	.LBB66_6
.LBB66_6:
	ld	hl, (ix + 6)
	ld	e, (ix + 9)
	call	__lcmpzero
	jp	m, .LBB66_8
; %bb.7:
	ld	a, d
	.local	.LBB66_8
.LBB66_8:
	ld	hl, 512
	or	a, a
	sbc	hl, bc
	push	hl
	pop	de
	bit	0, a
	jr	nz, .LBB66_10
; %bb.9:
	push	bc
	pop	de
	.local	.LBB66_10
.LBB66_10:
	ld	bc, 1023
	push	de
	pop	hl
	call	__ineg
	ld	a, iyl
	bit	0, a
	jr	nz, .LBB66_12
; %bb.11:
	ex	de, hl
	.local	.LBB66_12
.LBB66_12:
	call	__iand
	.local	.LBB66_13
.LBB66_13:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end66
.Lfunc_end66:
	.size	__ZN5rally14sceneryHeadingEll, .Lfunc_end66-__ZN5rally14sceneryHeadingEll
                                        ; -- End function
	.weak	__ZN5rally14SceneryHistory7prepareEi ; -- Begin function _ZN5rally14SceneryHistory7prepareEi
	.type	__ZN5rally14SceneryHistory7prepareEi,@function
__ZN5rally14SceneryHistory7prepareEi:   ; @_ZN5rally14SceneryHistory7prepareEi
	.local	.Lfunc_begin67
.Lfunc_begin67:
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
	jr	z, .LBB67_3
; %bb.1:
	ld	de, 768
	ld	hl, (ix - 12)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB67_3
; %bb.2:
	ld	de, 257
	ld	hl, (ix - 12)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	p, .LBB67_7
	.local	.LBB67_3
.LBB67_3:
	ld	iy, (ix + 6)
	or	a, a
	sbc	hl, hl
	ld	(iy), hl
	.local	.LBB67_4
.LBB67_4:
	ld	(iy + 3), hl
	ld	hl, 319
	.local	.LBB67_5
.LBB67_5:
	ld	(iy + 6), hl
	ld	(iy + 9), 1
	.local	.LBB67_6
.LBB67_6:
	lea	hl, iy + 0
	ld	sp, ix
	pop	ix
	ret
	.local	.LBB67_7
.LBB67_7:
	ld	hl, (ix - 15)
	add	hl, bc
	or	a, a
	sbc	hl, bc
	jr	nz, .LBB67_9
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
	jp	.LBB67_6
	.local	.LBB67_9
.LBB67_9:
	ld	iy, (ix + 6)
	ld	(iy), hl
	ld	de, 513
	ld	hl, (ix - 12)
	or	a, a
	sbc	hl, de
	jr	c, .LBB67_11
; %bb.10:
	ld	hl, 832
	ld	de, (ix - 12)
	or	a, a
	sbc	hl, de
	jp	.LBB67_4
	.local	.LBB67_11
.LBB67_11:
	ld	hl, 511
	ld	de, 0
	ld	(iy + 3), de
	ld	de, (ix - 12)
	or	a, a
	sbc	hl, de
	jp	.LBB67_5
	.local	.Lfunc_end67
.Lfunc_end67:
	.size	__ZN5rally14SceneryHistory7prepareEi, .Lfunc_end67-__ZN5rally14SceneryHistory7prepareEi
                                        ; -- End function
	.weak	__ZN5rally3r1816headingFromCrossEl ; -- Begin function _ZN5rally3r1816headingFromCrossEl
	.type	__ZN5rally3r1816headingFromCrossEl,@function
__ZN5rally3r1816headingFromCrossEl:     ; @_ZN5rally3r1816headingFromCrossEl
	.local	.Lfunc_begin68
.Lfunc_begin68:
; %bb.0:
	ld	hl, -9
	call	__frameset
	ld	hl, (ix + 6)
	ld	bc, 4096
	xor	a, a
	ld	e, (ix + 9)
	call	__lcmpzero
	ld	d, 1
	ld	iyl, a
	ld	l, d
	jp	m, .LBB68_2
; %bb.1:
	ex	de, hl
	ld	e, iyl
	ex	de, hl
	.local	.LBB68_2
.LBB68_2:
	ld	(ix - 3), l
	ld	hl, (ix + 6)
	ld	e, (ix + 9)
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB68_4
; %bb.3:
	ld	d, iyl
	.local	.LBB68_4
.LBB68_4:
	bit	0, d
	ld	bc, (ix + 6)
	jr	nz, .LBB68_6
; %bb.5:
	ld	bc, 4096
	.local	.LBB68_6
.LBB68_6:
	ld	hl, -4096
	ld	e, -1
	bit	0, d
	ld	d, (ix + 9)
	jr	nz, .LBB68_8
; %bb.7:
	ld	d, a
	.local	.LBB68_8
.LBB68_8:
	ld	a, d
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB68_10
; %bb.9:
	push	hl
	pop	bc
	.local	.LBB68_10
.LBB68_10:
	push	bc
	pop	hl
	call	__ineg
	push	hl
	pop	iy
	bit	0, (ix - 3)                     ; 1-byte Folded Reload
	jr	nz, .LBB68_12
; %bb.11:
	push	bc
	pop	iy
	.local	.LBB68_12
.LBB68_12:
	ld	de, 3585
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jr	nc, .LBB68_14
; %bb.13:
	ld	hl, 5
	ld	(ix - 6), hl
	ld	de, 31
	ld	c, l
	lea	hl, iy + 0
	call	__ishru
	jr	.LBB68_16
	.local	.LBB68_14
.LBB68_14:
	ld	de, 3969
	lea	hl, iy + 0
	or	a, a
	sbc	hl, de
	jp	nc, .LBB68_23
; %bb.15:
	ld	bc, -3584
	ld	hl, 3
	ld	(ix - 6), hl
	ld	de, 7
	lea	hl, iy + 0
	add	hl, bc
	ld	c, 3
	call	__ishru
	ld	bc, 112
	add	hl, bc
	.local	.LBB68_16
.LBB68_16:
	ld	(ix - 3), hl
	lea	hl, iy + 0
	push	de
	pop	bc
	call	__iand
	push	hl
	pop	de
	ld	c, 1
	ld	hl, (ix - 3)
	call	__ishl
	push	hl
	pop	bc
	ld	iy, __ZN5rally3r18L13HeadingAnglesE
	lea	hl, iy + 0
	add	hl, bc
	ld	bc, (hl)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, c
	push	hl
	pop	bc
	ld	(ix - 9), de
	ld	a, e
	or	a, a
	jp	z, .LBB68_18
; %bb.17:
	ld	hl, (ix - 3)
	inc	hl
	push	bc
	pop	de
	ld	c, 1
	call	__ishl
	push	hl
	pop	bc
	add	iy, bc
	ld	bc, (iy)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	ld	h, a
	ld	l, c
	or	a, a
	sbc	hl, de
	ld	bc, (ix - 9)
	call	__imulu
	ld	bc, (ix - 6)
                                        ; kill: def $c killed $c killed $ubc
	call	__ishrs
	add	hl, de
	push	hl
	pop	bc
	.local	.LBB68_18
.LBB68_18:
	ld	hl, (ix + 6)
	ld	e, (ix + 9)
	call	__lcmpzero
	jp	m, .LBB68_20
; %bb.19:
	ld	a, 0
	jr	.LBB68_21
	.local	.LBB68_20
.LBB68_20:
	ld	a, 1
	.local	.LBB68_21
.LBB68_21:
	push	bc
	pop	hl
	call	__ineg
	bit	0, a
	jp	nz, .LBB68_28
; %bb.22:
	push	bc
	pop	hl
	jp	.LBB68_28
	.local	.LBB68_23
.LBB68_23:
	ld	bc, -3808
	ld	hl, (ix + 6)
	ld	e, (ix + 9)
	call	__lcmpzero
	jp	m, .LBB68_25
; %bb.24:
	ld	a, 0
	jr	.LBB68_26
	.local	.LBB68_25
.LBB68_25:
	ld	a, 1
	.local	.LBB68_26
.LBB68_26:
	add	iy, bc
	ld	c, 1
	lea	hl, iy + 0
	call	__ishl
	push	hl
	pop	de
	ld	hl, __ZN5rally3r18L13HeadingAnglesE
	add	hl, de
	ld	de, (hl)
	ld	l, e
	ld	h, d
	call	__sneg
                                        ; kill: def $hl killed $hl def $uhl
	bit	0, a
	jr	nz, .LBB68_28
; %bb.27:
	ld	l, e
	ld	h, d
	.local	.LBB68_28
.LBB68_28:
                                        ; kill: def $hl killed $hl killed $uhl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end68
.Lfunc_end68:
	.size	__ZN5rally3r1816headingFromCrossEl, .Lfunc_end68-__ZN5rally3r1816headingFromCrossEl
                                        ; -- End function
	.weak	__ZN5rally3r1814viewingBearingEi ; -- Begin function _ZN5rally3r1814viewingBearingEi
	.type	__ZN5rally3r1814viewingBearingEi,@function
__ZN5rally3r1814viewingBearingEi:       ; @_ZN5rally3r1814viewingBearingEi
	.local	.Lfunc_begin69
.Lfunc_begin69:
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	bc, (ix + 6)
	ld	de, -160
	ld	hl, 160
	push	bc
	pop	iy
	add	iy, de
	or	a, a
	sbc	hl, bc
	push	hl
	pop	de
	push	bc
	pop	hl
	ld	bc, 160
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	m, .LBB69_2
; %bb.1:
	lea	de, iy + 0
	.local	.LBB69_2
.LBB69_2:
	ld	bc, 512
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	c, .LBB69_4
; %bb.3:
	ld	de, 512
	.local	.LBB69_4
.LBB69_4:
	ld	c, 1
	push	de
	pop	iy
	lea	hl, iy + 0
	call	__ishru
	ld	(ix - 3), hl
	call	__ishl
	push	hl
	pop	de
	ld	hl, __ZN5rally3r18L13BearingAnglesE
	add	hl, de
	ld	bc, (hl)
	ld	a, b
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	de
	ld	d, a
	ld	e, c
	lea	hl, iy + 0
	ld	bc, 1
	call	__iand
	bit	0, l
	jr	z, .LBB69_6
; %bb.5:
	ld	hl, (ix - 3)
	inc	hl
	ld	c, 1
	call	__ishl
	push	hl
	pop	bc
	ld	hl, __ZN5rally3r18L13BearingAnglesE
	add	hl, bc
	ld	iy, (hl)
	ld	a, iyh
	ld	l, a
	rlc	l
	sbc	hl, hl
	push	hl
	pop	bc
	ld	b, a
	ld	c, iyl
	ld	hl, 1
	or	a, a
	sbc	hl, de
	add	hl, bc
	ld	bc, 2
	call	__idivs
	add	hl, de
	ex	de, hl
	.local	.LBB69_6
.LBB69_6:
	push	de
	pop	hl
	call	__ineg
	push	hl
	pop	iy
	ld	hl, (ix + 6)
	ld	bc, 160
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	m, .LBB69_8
; %bb.7:
	push	de
	pop	iy
	.local	.LBB69_8
.LBB69_8:
	ex	de, hl
	ld	e, iyl
	ld	d, iyh
	ex	de, hl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end69
.Lfunc_end69:
	.size	__ZN5rally3r1814viewingBearingEi, .Lfunc_end69-__ZN5rally3r1814viewingBearingEi
                                        ; -- End function
	.weak	__ZN5rally3r1810playerPoseEiib  ; -- Begin function _ZN5rally3r1810playerPoseEiib
	.type	__ZN5rally3r1810playerPoseEiib,@function
__ZN5rally3r1810playerPoseEiib:         ; @_ZN5rally3r1810playerPoseEiib
	.local	.Lfunc_begin70
.Lfunc_begin70:
; %bb.0:
	ld	hl, -3
	call	__frameset
	ld	de, (ix + 9)
	bit	0, (ix + 15)
	jr	z, .LBB70_2
; %bb.1:
	ld	iy, (ix + 12)
	ld	c, 8
	ex	de, hl
	call	__ishl
	ld	(ix - 3), hl
	push	iy
	call	__ZN5rally3r1814viewingBearingEi
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
	ld	hl, (ix - 3)
	or	a, a
	sbc	hl, bc
	push	hl
	pop	de
	push	de
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	bc
	ld	(ix - 3), de
	ex	de, hl
	add	hl, bc
	call	__ixor
	ld	bc, 672
	add	hl, bc
	ld	bc, 1344
	jr	.LBB70_3
	.local	.LBB70_2
.LBB70_2:
	push	de
	pop	hl
	push	de
	pop	iy
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	bc
	ld	(ix - 3), de
	ex	de, hl
	add	hl, bc
	call	__ixor
	ld	c, 2
	call	__ishl
	ld	bc, 10
	add	hl, bc
	ld	bc, 21
	.local	.LBB70_3
.LBB70_3:
	call	__idivu
	push	hl
	pop	bc
	ld	iy, (ix + 6)
	ld	de, 4
	or	a, a
	sbc	hl, de
	jr	c, .LBB70_5
; %bb.4:
	ld	bc, 4
	.local	.LBB70_5
.LBB70_5:
	ld	a, c
	ld	(iy), a
	ld	bc, 1
	ld	hl, (ix - 3)
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	p, .LBB70_7
; %bb.6:
	ld	a, 0
	jr	.LBB70_8
	.local	.LBB70_7
.LBB70_7:
	ld	a, 1
	.local	.LBB70_8
.LBB70_8:
	ld	(iy + 1), a
	lea	hl, iy + 0
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end70
.Lfunc_end70:
	.size	__ZN5rally3r1810playerPoseEiib, .Lfunc_end70-__ZN5rally3r1810playerPoseEiib
                                        ; -- End function
	.weak	__ZN5rally4Road7projectElll     ; -- Begin function _ZN5rally4Road7projectElll
	.type	__ZN5rally4Road7projectElll,@function
__ZN5rally4Road7projectElll:            ; @_ZN5rally4Road7projectElll
	.local	.Lfunc_begin71
.Lfunc_begin71:
; %bb.0:
	ld	hl, -60
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	ld	d, 0
	bit	0, (iy + 3)
	jr	nz, .LBB71_2
; %bb.1:
	ld	bc, (iy)
	ld	(ix - 35), bc
	jr	.LBB71_5
	.local	.LBB71_2
.LBB71_2:
	ld	bc, 1600
	ld	a, d
	call	__ldivs
	push	hl
	pop	de
	ld	hl, (iy)
	push	de
	pop	bc
	push	de
	pop	iy
	ld	de, 360
	add	iy, de
	ld	(ix - 35), hl
	ld	de, __ZN5rallyL4FujiE
	or	a, a
	sbc	hl, de
	jr	z, .LBB71_4
; %bb.3:
	push	bc
	pop	iy
	.local	.LBB71_4
.LBB71_4:
	ld	c, 1
	lea	hl, iy + 0
	call	__ishl
	push	hl
	pop	de
	ld	hl, __ZN5rallyL11BandOffsetsE
	add	hl, de
	ld	hl, (hl)
	ld	de, 0
	ld	e, l
	ld	d, h
	ld	hl, __ZN5rallyL8BandEndsE
	add	hl, de
	ld	iy, (ix + 6)
	ld	(iy + 4), hl
	ld	d, 0
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
	.local	.LBB71_5
.LBB71_5:
	ld	bc, 100
	ld	a, d
	call	__ldivs
	push	hl
	pop	iy
	ld	l, 8
	lea	bc, iy + 0
	ld	a, e
	call	__lshl
	ld	(ix - 38), bc
	ld	(ix - 41), a                    ; 1-byte Folded Spill
	lea	hl, iy + 0
	ld	iy, 100
	lea	bc, iy + 0
	ld	a, d
	call	__lmulu
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix + 9)
	ld	e, (ix + 12)
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
	ld	a, d
	call	__ldivs
	ld	bc, (ix - 38)
	ld	a, (ix - 41)                    ; 1-byte Folded Reload
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	ld	bc, (ix - 35)
	push	bc
	ld	(ix - 50), de
	push	de
	ld	(ix - 47), hl
	push	hl
	pea	ix - 16
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	ld	iy, 1455
	ld	bc, 2043
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	.local	.LBB71_6
.LBB71_6:                               ; =>This Inner Loop Header: Depth=1
	push	bc
	pop	hl
	ld	de, -1939
	add	hl, de
	ld	(ix - 38), hl
	lea	hl, iy + 0
	ld	de, 1939
	or	a, a
	sbc	hl, de
	jp	z, .LBB71_12
; %bb.7:                                ;   in Loop: Header=BB71_6 Depth=1
	ld	(ix - 44), bc
	push	bc
	pop	hl
	ld	de, -2035
	add	hl, de
	ld	(ix - 35), hl
	lea	de, iy + 0
	ld	hl, (ix + 6)
	add	hl, de
	ld	(ix - 53), hl
	ld	(ix - 41), iy
	push	hl
	pop	iy
	ld	de, -900
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix - 47)
	ld	iy, (ix - 50)
	ld	a, iyl
	call	__ladd
                                        ; kill: def $e killed $e def $ude
	ld	iy, (ix + 6)
	ld	bc, (iy)
	push	bc
	push	de
	push	hl
	pea	ix - 32
	call	__ZN5rally11trackSampleElRKNS_8TrackDefE
	pop	hl
	pop	hl
	pop	hl
	pop	hl
	ld	bc, (ix - 32)
	ld	hl, (ix - 16)
	ld	e, (ix - 13)
	ld	a, (ix - 29)
	call	__lsub
	ld	(ix - 56), hl
	ld	iyl, e
	ld	hl, (ix - 28)
	ld	bc, (ix - 12)
	ld	e, (ix - 25)
	ld	a, (ix - 9)
	call	__lsub
	ld	(ix - 59), hl
	ld	(ix - 60), e                    ; 1-byte Folded Spill
	ld	hl, (ix - 4)
	ld	e, (ix - 1)
	ld	bc, (ix - 56)
	ld	a, iyl
	call	__lmulu
	push	hl
	pop	iy
	ld	d, e
	ld	hl, (ix - 8)
	ld	e, (ix - 5)
	ld	bc, (ix - 59)
	ld	a, (ix - 60)                    ; 1-byte Folded Reload
	call	__lmulu
	lea	bc, iy + 0
	ld	a, d
	call	__ladd
	ld	bc, 4096
	ld	d, c
	ld	a, d
	call	__ldivs
	ld	bc, (ix + 21)
	ld	a, (ix + 24)
	call	__lsub
	push	hl
	pop	bc
	ld	hl, (ix - 35)
	ld	iy, (ix - 35)
	add	iy, iy
	sbc	hl, hl
	push	hl
	pop	iy
	push	bc
	pop	hl
	ld	bc, (ix - 35)
	ld	a, iyl
	call	__lmulu
	ld	bc, 50
	ld	a, d
	call	__ldivs
	ld	bc, 40960
	call	__ladd
	ld	iy, (ix - 53)
	ld	(iy), hl
	ld	(iy + 3), e
	ld	iy, (ix + 6)
	ld	hl, (ix - 38)
	ld	bc, 116
	or	a, a
	sbc	hl, bc
	ld	hl, (ix - 41)
	ld	a, d
	jr	c, .LBB71_11
; %bb.8:                                ;   in Loop: Header=BB71_6 Depth=1
	ex	de, hl
	add	iy, de
	ld	de, -1416
	add	iy, de
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix + 15)
	ld	a, (ix + 18)
	call	__ladd
	ld	bc, 8000
	xor	a, a
	call	__lrems
	ld	bc, 4000
	call	__lcmps
	call	pe, __setflag
	ld	a, -1
	jp	m, .LBB71_10
; %bb.9:                                ;   in Loop: Header=BB71_6 Depth=1
	ld	a, 0
	.local	.LBB71_10
.LBB71_10:                              ;   in Loop: Header=BB71_6 Depth=1
	ld	iy, (ix + 6)
	ld	hl, (ix - 41)
	.local	.LBB71_11
.LBB71_11:                              ;   in Loop: Header=BB71_6 Depth=1
	ld	bc, (ix - 44)
	add	iy, bc
	and	a, 1
	ld	(iy), a
	ld	de, 4
	add	hl, de
	inc	bc
	push	hl
	pop	iy
	jp	.LBB71_6
	.local	.LBB71_12
.LBB71_12:
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end71
.Lfunc_end71:
	.size	__ZN5rally4Road7projectElll, .Lfunc_end71-__ZN5rally4Road7projectElll
                                        ; -- End function
	.weak	__ZNK5rally4Road7bandEndEi      ; -- Begin function _ZNK5rally4Road7bandEndEi
	.type	__ZNK5rally4Road7bandEndEi,@function
__ZNK5rally4Road7bandEndEi:             ; @_ZNK5rally4Road7bandEndEi
	.local	.Lfunc_begin72
.Lfunc_begin72:
; %bb.0:
	ld	hl, -48
	call	__frameset
	ld	iy, (ix + 6)
	ld	de, (ix + 9)
	bit	0, (iy + 3)
	jp	nz, .LBB72_12
; %bb.1:
	ld	bc, 1939
	ld	iy, (ix + 6)
	lea	hl, iy + 0
	add	hl, de
	add	hl, bc
	ld	(ix - 9), hl
	ld	c, 2
	ld	hl, (ix + 9)
	call	__ishl
	push	hl
	pop	de
	lea	hl, iy + 0
	add	hl, de
	ld	de, 1039
	add	hl, de
	ld	(ix - 15), hl
	ld	de, 224
	ld	hl, (ix + 9)
	or	a, a
	sbc	hl, de
	ld	hl, (ix + 9)
	call	pe, __setflag
	push	hl
	pop	de
	jp	p, .LBB72_3
; %bb.2:
	ld	de, 223
	.local	.LBB72_3
.LBB72_3:
	ld	(ix - 6), de
	call	__ishl
	push	hl
	pop	de
	ld	hl, (ix + 6)
	add	hl, de
	ld	de, 1043
	add	hl, de
	ld	(ix - 12), hl
	ld	hl, (ix + 9)
	.local	.LBB72_4
.LBB72_4:                               ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB72_7 Depth 2
	push	hl
	pop	bc
	ld	de, (ix - 6)
	or	a, a
	sbc	hl, de
	jp	z, .LBB72_19
; %bb.5:                                ;   in Loop: Header=BB72_4 Depth=1
	push	bc
	pop	de
	ld	hl, (ix + 6)
	add	hl, de
	ld	de, 1940
	add	hl, de
	ld	a, (hl)
	and	a, 1
	ld	d, a
	ld	hl, (ix - 9)
	ld	a, (hl)
	and	a, 1
	ld	e, a
	ld	a, d
	cp	a, e
	jp	nz, .LBB72_20
; %bb.6:                                ;   in Loop: Header=BB72_4 Depth=1
	push	bc
	pop	hl
	inc	hl
	ld	(ix - 24), hl
	push	bc
	pop	hl
	ld	de, 2
	add	hl, de
	ld	(ix - 3), hl
	ld	de, (ix + 9)
	or	a, a
	sbc	hl, de
	push	hl
	pop	de
	push	de
	pop	iy
	add	iy, iy
	ld	iy, (ix + 6)
	sbc	hl, hl
	ld	(ix - 21), hl
	ld	hl, (ix - 3)
	ld	(ix - 3), bc
	ld	c, 2
	call	__ishl
	push	hl
	pop	bc
	lea	hl, iy + 0
	add	hl, bc
	ld	bc, 1039
	add	hl, bc
	ld	(ix - 30), hl
	ld	(ix - 18), de
	push	de
	pop	bc
	ld	hl, (ix - 21)
	ld	a, l
	ld	l, 8
	call	__lshl
	ld	(ix - 33), bc
	push	bc
	pop	hl
	ld	(ix - 34), a                    ; 1-byte Folded Spill
	ld	e, a
	call	__lneg
	ld	(ix - 37), hl
	ld	(ix - 38), e                    ; 1-byte Folded Spill
	ld	hl, (ix - 12)
	ld	(ix - 21), hl
	or	a, a
	sbc	hl, hl
	push	hl
	pop	bc
	.local	.LBB72_7
.LBB72_7:                               ;   Parent Loop BB72_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ld	hl, (ix + 9)
	ld	(ix - 27), bc
	add	hl, bc
	push	hl
	pop	bc
	ld	hl, (ix - 3)
	or	a, a
	sbc	hl, bc
	call	pe, __setflag
	jp	m, .LBB72_11
; %bb.8:                                ;   in Loop: Header=BB72_7 Depth=2
	ld	(ix - 48), bc
	ld	hl, (ix - 18)
	push	hl
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	(ix - 41), hl
	ld	iy, (ix - 15)
	ld	hl, (iy)
	ld	(ix - 45), hl
	lea	iy, iy + 3
	ld	d, (iy)
	ld	iy, (ix - 21)
	ld	bc, (iy)
	ld	e, d
	ld	a, (iy + 3)
	call	__lsub
	ld	bc, (ix - 18)
	ld	iy, (ix - 41)
	ld	a, iyl
	call	__lmulu
	ld	(ix - 41), hl
	ld	(ix - 42), e                    ; 1-byte Folded Spill
	ld	iy, (ix - 30)
	ld	hl, (iy)
	lea	iy, iy + 3
	ld	e, (iy)
	ld	bc, (ix - 45)
	ld	a, d
	call	__lsub
	ld	(ix - 45), hl
	ld	bc, (ix - 27)
	inc	bc
	push	bc
	pop	hl
	push	bc
	pop	iy
	add	iy, iy
	sbc	hl, hl
	ld	(ix - 27), hl
	ld	hl, (ix - 45)
	ld	(ix - 45), bc
	ld	iy, (ix - 27)
	ld	a, iyl
	call	__lmulu
	ld	bc, (ix - 41)
	ld	a, (ix - 42)                    ; 1-byte Folded Reload
	call	__ladd
	push	hl
	pop	bc
	ld	a, e
	ld	hl, (ix - 33)
	ld	e, (ix - 34)                    ; 1-byte Folded Reload
	call	__lcmps
	call	pe, __setflag
	jp	m, .LBB72_10
; %bb.9:                                ;   in Loop: Header=BB72_7 Depth=2
	ld	iy, (ix - 21)
	lea	iy, iy + 4
	ld	(ix - 21), iy
	push	bc
	pop	hl
	ld	e, a
	ld	bc, (ix - 37)
	ld	a, (ix - 38)                    ; 1-byte Folded Reload
	call	__lcmps
	call	pe, __setflag
	ld	bc, (ix - 45)
	jp	p, .LBB72_7
	.local	.LBB72_10
.LBB72_10:                              ;   in Loop: Header=BB72_4 Depth=1
	ld	bc, (ix - 3)
	push	bc
	pop	hl
	ld	de, (ix - 48)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	ld	hl, (ix - 24)
	jp	m, .LBB72_4
	jr	.LBB72_20
	.local	.LBB72_11
.LBB72_11:                              ;   in Loop: Header=BB72_4 Depth=1
	ld	hl, (ix - 24)
	jp	.LBB72_4
	.local	.LBB72_12
.LBB72_12:
	ld	iy, (ix + 6)
	ld	iy, (iy + 4)
	.local	.LBB72_13
.LBB72_13:                              ; =>This Inner Loop Header: Depth=1
	ld	a, (iy)
	ld	bc, 0
	ld	c, a
	inc	iy
	push	bc
	pop	hl
	ld	de, (ix + 9)
	or	a, a
	sbc	hl, de
	call	pe, __setflag
	jp	m, .LBB72_13
; %bb.14:
	ld	(ix - 3), bc
	ld	de, 1939
	ld	hl, (ix + 9)
	push	hl
	pop	bc
	ld	iy, (ix + 6)
	lea	hl, iy + 0
	add	hl, bc
	add	hl, de
	ld	(ix - 6), hl
	ld	de, 0
	ld	e, a
	ld	bc, (ix + 9)
	.local	.LBB72_15
.LBB72_15:                              ; =>This Inner Loop Header: Depth=1
	push	de
	pop	hl
	or	a, a
	sbc	hl, bc
	jr	z, .LBB72_18
; %bb.16:                               ;   in Loop: Header=BB72_15 Depth=1
	lea	hl, iy + 0
	add	hl, bc
	inc	bc
	push	de
	pop	iy
	ld	de, 1940
	add	hl, de
	lea	de, iy + 0
	ld	a, (hl)
	and	a, 1
	ld	iyl, a
	ld	hl, (ix - 6)
	ld	a, (hl)
	and	a, 1
	ld	h, a
	ld	a, iyl
	ld	iy, (ix + 6)
	cp	a, h
	jr	z, .LBB72_15
; %bb.17:
	dec	bc
	jr	.LBB72_20
	.local	.LBB72_18
.LBB72_18:
	ld	bc, (ix - 3)
	jr	.LBB72_20
	.local	.LBB72_19
.LBB72_19:
	push	de
	pop	bc
	.local	.LBB72_20
.LBB72_20:
	push	bc
	pop	hl
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end72
.Lfunc_end72:
	.size	__ZNK5rally4Road7bandEndEi, .Lfunc_end72-__ZNK5rally4Road7bandEndEi
                                        ; -- End function
	.weak	__ZNK5rally4Road5stripERNS_6StreamEiiiii ; -- Begin function _ZNK5rally4Road5stripERNS_6StreamEiiiii
	.type	__ZNK5rally4Road5stripERNS_6StreamEiiiii,@function
__ZNK5rally4Road5stripERNS_6StreamEiiiii: ; @_ZNK5rally4Road5stripERNS_6StreamEiiiii
	.local	.Lfunc_begin73
.Lfunc_begin73:
; %bb.0:
	ld	hl, -12
	call	__frameset
	ld	iy, (ix + 6)
	ld	hl, (ix + 12)
	xor	a, a
	ld	de, 1039
	add	iy, de
	ld	(ix - 3), iy
	ld	c, 2
	call	__ishl
	push	hl
	pop	bc
	add	iy, bc
	ld	hl, (iy)
	ld	e, (iy + 3)
	ld	bc, 256
	call	__ldivs
	ld	(ix - 9), hl
	ld	hl, (ix + 15)
	ld	c, 2
	call	__ishl
	push	hl
	pop	de
	ld	iy, (ix - 3)
	add	iy, de
	ld	hl, (iy)
	ld	e, (iy + 3)
	ld	bc, 256
	call	__ldivs
	ld	(ix - 6), hl
	ld	iy, (ix + 12)
	ld	de, -96
	add	iy, de
	lea	hl, iy + 0
	ld	bc, (ix + 18)
	call	__imulu
	ld	de, 50
	push	de
	pop	bc
	call	__idivs
	ld	de, (ix - 9)
	add	hl, de
	ld	(ix - 3), hl
	lea	hl, iy + 0
	ld	bc, (ix + 21)
	call	__imulu
	ld	bc, 50
	call	__idivs
	add	hl, de
	ld	(ix - 9), hl
	ld	iy, (ix + 15)
	ld	de, -96
	add	iy, de
	lea	hl, iy + 0
	ld	bc, (ix + 18)
	call	__imulu
	ld	bc, 50
	call	__idivs
	ld	de, (ix - 6)
	add	hl, de
	ld	(ix - 12), hl
	lea	hl, iy + 0
	ld	bc, (ix + 21)
	call	__imulu
	ld	bc, 50
	call	__idivs
	add	hl, de
	ld	de, (ix + 24)
	push	de
	ld	de, (ix + 15)
	push	de
	push	hl
	ld	hl, (ix - 12)
	push	hl
	ld	hl, (ix + 12)
	push	hl
	ld	hl, (ix - 9)
	push	hl
	ld	hl, (ix - 3)
	push	hl
	ld	hl, (ix + 9)
	push	hl
	call	__ZN5rally6Stream4quadEiiiiiii
	ld	sp, ix
	pop	ix
	ret
	.local	.Lfunc_end73
.Lfunc_end73:
	.size	__ZNK5rally4Road5stripERNS_6StreamEiiiii, .Lfunc_end73-__ZNK5rally4Road5stripERNS_6StreamEiiiii
                                        ; -- End function
	.weak	__ZN5rally6Stream4quadEiiiiiii  ; -- Begin function _ZN5rally6Stream4quadEiiiiiii
	.type	__ZN5rally6Stream4quadEiiiiiii,@function
__ZN5rally6Stream4quadEiiiiiii:         ; @_ZN5rally6Stream4quadEiiiiiii
	.local	.Lfunc_begin74
.Lfunc_begin74:
; %bb.0:
	ld	hl, -21
	call	__frameset
	ld	de, (ix + 6)
	ld	(ix - 3), de
	ld	hl, (ix + 9)
	ld	(ix - 21), hl
	ld	hl, (ix + 12)
	ld	(ix - 18), hl
	ld	hl, (ix + 15)
	ld	(ix - 9), hl
	ld	hl, (ix + 18)
	ld	(ix - 15), hl
	ld	hl, (ix + 21)
	ld	(ix - 12), hl
	ld	hl, (ix + 24)
	ld	(ix - 6), hl
	ld	hl, (ix + 27)
	push	hl
	push	de
	call	__ZN5rally6Stream5colorEi
	pop	hl
	pop	hl
	ld	hl, (ix - 9)
	push	hl
	ld	hl, (ix - 21)
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
	ld	hl, (ix - 9)
	push	hl
	ld	hl, (ix - 18)
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
	ld	hl, (ix - 6)
	push	hl
	ld	hl, (ix - 15)
	push	hl
	ld	hl, 85
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
	ld	hl, 85
	ld	(ix + 9), hl
	ld	hl, (ix - 12)
	ld	(ix + 12), hl
	ld	hl, (ix - 6)
	ld	(ix + 15), hl
	ld	sp, ix
	pop	ix
	jp	__ZN5rally6Stream4plotEiii
	.local	.Lfunc_end74
.Lfunc_end74:
	.size	__ZN5rally6Stream4quadEiiiiiii, .Lfunc_end74-__ZN5rally6Stream4quadEiiiiiii
                                        ; -- End function
	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_14roadE
__ZN12_GLOBAL__N_14roadE:
	d24	__ZN5rallyL4FujiE
	db	0                               ; 0x0
	d24	__ZN5rallyL8BandEndsE
	.zero	516
	.zero	516
	.zero	900
	.zero	225
	d24	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	0                               ; 0x0
	d32	4096                            ; 0x1000
	d32	0                               ; 0x0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_16streamE
__ZN12_GLOBAL__N_16streamE:
	.skip	4100

	.local	__ZN12_GLOBAL__N_110billboardsE
__ZN12_GLOBAL__N_110billboardsE:
	.skip	27

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

	.section	.rodata,"a",@progbits
	.local	_.str
_.str:
	db	"oval", 0

	.local	__ZN5rallyL7TriOvalE
__ZN5rallyL7TriOvalE:
	d24	__ZN5rallyL13TriOvalPointsE
	d24	90                              ; 0x5a
	d32	5760                            ; 0x1680
	d24	_.str.13

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_18selectedE
__ZN12_GLOBAL__N_18selectedE:
	d24	__ZN5rallyL7TriOvalE

	.section	.rodata,"a",@progbits
	.local	_.str.3
_.str.3:
	db	"fuji", 0

	.local	__ZN5rallyL4FujiE
__ZN5rallyL4FujiE:
	d24	__ZN5rallyL10FujiPointsE
	d24	512                             ; 0x200
	d32	32768                           ; 0x8000
	d24	_.str.14

	.local	_.str.4
_.str.4:
	db	"mute", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_15mutedE
__ZN12_GLOBAL__N_15mutedE:
	.skip	1

	.section	.rodata,"a",@progbits
	.local	_.str.5
_.str.5:
	db	"steer1", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_112steeringStepE
__ZN12_GLOBAL__N_112steeringStepE:
	.skip	1

	.section	.rodata,"a",@progbits
	.local	_.str.6
_.str.6:
	db	"steer2", 0

	.local	_.str.7
_.str.7:
	db	"arcade", 0

	.section	.data,"aw",@progbits
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

	.section	.rodata,"a",@progbits
	.local	_.str.8
_.str.8:
	db	"circuit", 0

	.local	_.str.9
_.str.9:
	db	"demo", 0

	.local	_.str.11
_.str.11:
	db	"rally.sav", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_17recordsE
__ZN12_GLOBAL__N_17recordsE:
	.skip	2304

	.section	.rodata,"a",@progbits
	.local	_.str.12
_.str.12:
	db	"rally.bak", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_16engineE
__ZN12_GLOBAL__N_16engineE:
	.skip	4

	.local	__ZN12_GLOBAL__N_14quitE
__ZN12_GLOBAL__N_14quitE:
	.skip	1

	.local	__ZN12_GLOBAL__N_112previousKeysE
__ZN12_GLOBAL__N_112previousKeysE:
	.skip	16

	.local	__ZN12_GLOBAL__N_18heldKeysE
__ZN12_GLOBAL__N_18heldKeysE:
	.skip	16

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_110demoDriverE
__ZN12_GLOBAL__N_110demoDriverE:
	d24	224                             ; 0xe0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_17trafficE
__ZN12_GLOBAL__N_17trafficE:
	.skip	60

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_111raceTrafficE
__ZN12_GLOBAL__N_111raceTrafficE:
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

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_114sceneryHistoryE
__ZN12_GLOBAL__N_114sceneryHistoryE:
	.skip	11

	.local	__ZN12_GLOBAL__N_15sceneE
__ZN12_GLOBAL__N_15sceneE:
	.skip	158

	.local	__ZN12_GLOBAL__N_111savePendingE
__ZN12_GLOBAL__N_111savePendingE:
	.skip	1

	.section	.rodata,"a",@progbits
	.local	___const._Z8gameMainiPPc.fonts
___const._Z8gameMainiPPc.fonts:
	d24	63940                           ; 0xf9c4
	d24	63941                           ; 0xf9c5

	.local	__ZN5rallyL8BandEndsE
__ZN5rallyL8BandEndsE:
	db	"hikoy", 140, 165, 223, "hikoz", 143, 175, 223, "hiko{", 143, 164, 193, 223, "hikns", 127, 155, 206, 223, "hijlq", 127, 153, 176, 223, "hijlpz", 134, 172, 223, "hijlou", 132, 166, 194, 223, "hijlou", 134, 170, 207, 223, "hijlov", 137, 179, 223, "hijknt", 136, 152, 217, 223, "hijkns{", 147, 211, 223, "hijkmqy", 148, 169, 223, "hijlou~", 157, 183, 223, "hijlot}", 157, 181, 223, "hijlot}", 160, 190, 223, "hijlnr{", 148, 204, 223, "hijlmqw", 130, 176, 223, "hijkmos|", 136, 188, 223, "hijkmos{", 136, 201, 223, "hijkmot|", 138, 220, 223, "hijkmot|", 141, 223, "hijklorw", 130, 147, 223, "hijkmpu|", 146, 223, "hijkmpsx", 130, 156, 223, "hijklmpry", 132, 163, 223, "hijklnqsz", 134, 170, 223, "hijklnqs{", 136, 170, 202, 223, "hijklmoru~", 140, 177, 212, 223, "hijklmoru~", 140, 178, 223, "hijklnpsv", 127, 135, 152, 199, 223, "hijklnptw", 129, 137, 154, 204, 223, "hijklmnpsw}", 136, 158, 219, 223, "hijklmoquy", 132, 141, 166, 223, "hijklmnoqsw{", 135, 145, 175, 223, "ijklnpsw|", 136, 149, 188, 223, "ijklmnprtx}", 136, 154, 206, 223, "ijklmoqty", 127, 138, 161, 183, 223, "ijklmnoqru{", 129, 135, 152, 172, 198, 223, "ijklnprtw}", 132, 146, 183, 205, 223, "ijkmnpqsux~", 135, 146, 168, 201, 223, "ikmoqtx}", 131, 138, 145, 168, 223, "iklmoqruz", 130, 142, 148, 176, 223, "jkmnprsvy|", 133, 146, 153, 189, 223, "jlnpqsuwy~", 136, 152, 160, 207, 223, "jlmoqtvxz", 127, 137, 147, 160, 169, 223, "jlnoqruwz", 129, 135, 144, 169, 179, 223, "kmnprsvx{~", 132, 146, 157, 181, 193, 223, "hkmoqsuwy}", 129, 135, 146, 156, 198, 212, 223, "hkmoqtvxz", 127, 132, 138, 145, 161, 175, 223, "hkmoruwz}", 129, 133, 142, 148, 170, 184, 223, "hkmoqsvx{}", 131, 134, 146, 153, 182, 199, 223, "hkmoqsuwy}", 127, 134, 138, 152, 160, 200, 221, 223, "hlnprtvxz", 127, 130, 138, 142, 159, 168, 223, "hloruxz}", 129, 132, 141, 146, 169, 179, 223, "hlnpsvx{}", 131, 134, 146, 151, 181, 193, 223, "hlnqsvx}", 127, 134, 137, 152, 157, 198, 212, 223, "hloqtxz", 127, 129, 137, 140, 159, 165, 223, "hloruy{", 129, 132, 141, 144, 168, 175, 184, 223, "hloqsvy{}", 131, 134, 146, 150, 180, 189, 198, 223, "hmpsvx}", 127, 134, 137, 151, 155, 160, 197, 207, 218, 223, "hjmprtxz", 127, 129, 137, 140, 158, 163, 168, 223, "hiloruz", 128, 131, 141, 144, 162, 168, 173, 179, 223, "hilortvz|", 131, 134, 146, 149, 154, 180, 187, 194, 223, "hjmpswy}", 128, 134, 137, 151, 155, 159, 196, 204, 212, 221, 223, "hjmptxz", 127, 130, 137, 140, 158, 163, 168, 222, 223, "himpsvz", 129, 132, 141, 144, 158, 168, 173, 178, 223, "himorv{~", 131, 134, 146, 149, 154, 179, 185, 191, 198, 223, "hjmorux}", 128, 134, 137, 151, 155, 159, 196, 203, 211, 220, 223, "hjmorux{", 127, 131, 137, 140, 158, 162, 167, 222, 223, "hjmorvz", 129, 132, 141, 144, 167, 172, 177, 223, "hjmpsw{", 127, 131, 134, 146, 150, 179, 185, 191, 198, 223, "hjmprux}", 129, 134, 137, 151, 155, 160, 196, 203, 210, 218, 223, "hkmpqty", 127, 132, 137, 140, 158, 163, 168, 222, 223, "hlnqruz", 129, 133, 141, 145, 167, 173, 179, 223, "inqsv|", 131, 134, 146, 150, 180, 187, 194, 223, "inqsux}", 132, 135, 139, 151, 155, 160, 197, 205, 213, 222, 223, "imoqtvy", 127, 133, 138, 142, 158, 163, 168, 222, 223, "imorux{", 129, 133, 141, 145, 167, 173, 179, 223, "jnpsvx|", 132, 139, 146, 151, 180, 187, 194, 223, "jnprtwy}", 130, 135, 141, 152, 157, 197, 205, 214, 223, "mpqtxz", 127, 132, 138, 143, 159, 165, 222, 223, "mpruy{", 129, 133, 141, 146, 168, 174, 181, 223, "mprsvy{}", 131, 134, 146, 151, 180, 188, 196, 223, "mpsuwy}", 127, 134, 137, 152, 158, 197, 206, 216, 223, "mortvxz~", 128, 137, 141, 159, 166, 222, 223, "mpsuwz~", 129, 131, 141, 145, 168, 175, 185, 223, "mpsvx{}", 131, 134, 146, 151, 180, 189, 199, 223, "mpswx}", 127, 134, 137, 152, 157, 197, 207, 219, 223, "mpruxy", 127, 130, 137, 140, 159, 165, 223, "loruyz|", 129, 132, 141, 144, 152, 168, 175, 183, 223, "lortw{}", 131, 134, 145, 148, 151, 180, 188, 196, 223, "losvy}", 127, 134, 137, 151, 155, 159, 197, 206, 216, 223, "lortx{~", 128, 137, 140, 158, 162, 167, 222, 223, "kosuz", 128, 130, 135, 141, 144, 158, 167, 172, 177, 223, "kosvy|", 131, 133, 146, 149, 154, 179, 185, 191, 198, 223, "koruwy}", 129, 134, 136, 151, 155, 159, 196, 203, 210, 218, 223, "koruxz", 127, 132, 137, 140, 158, 162, 167, 222, 223, "korvz", 127, 130, 141, 144, 148, 167, 172, 177, 223, "kosw{}", 131, 134, 145, 148, 151, 179, 185, 191, 197, 223, "kosx}", 128, 134, 137, 151, 154, 157, 196, 203, 210, 218, 223, "lpty", 127, 130, 137, 140, 158, 162, 166, 222, 223, "lptw{", 129, 132, 141, 145, 167, 171, 176, 181, 223, "lptw|", 131, 134, 146, 150, 179, 184, 189, 194, 223, "lptx}", 133, 136, 151, 156, 170, 196, 202, 208, 215, 222, 223, "lpuy", 127, 134, 138, 141, 158, 163, 168, 221, 223, "mrvz", 129, 133, 141, 144, 163, 169, 175, 182, 223, "mquy|", 132, 139, 146, 149, 155, 180, 187, 194, 223, "mquy~", 134, 138, 151, 155, 159, 197, 205, 214, 223, "mpuy", 127, 137, 141, 158, 163, 168, 222, 223, "nrv{", 129, 134, 142, 147, 167, 172, 177, 223, "nrw|", 132, 143, 148, 154, 179, 185, 191, 198, 223, "nrx~", 135, 143, 152, 158, 196, 203, 211, 219, 223, "osy", 127, 138, 144, 159, 165, 222, 223, "osz", 129, 135, 142, 148, 168, 175, 184, 223, "pt{", 132, 146, 152, 180, 188, 197, 223, "pt{", 128, 135, 144, 153, 160, 197, 207, 218, 223, "qv}", 130, 138, 144, 159, 167, 223, "rw~", 132, 142, 148, 168, 177, 223, "rw~", 133, 146, 152, 181, 192, 223, "sx", 128, 136, 152, 159, 198, 211, 223, "tz", 130, 139, 159, 167, 223, "u{", 132, 143, 168, 177, 223, "v}", 134, 147, 159, 181, 192, 223, "w", 127, 137, 153, 164, 198, 211, 223, "x", 128, 140, 160, 172, 223, "y", 128, 139, 151, 170, 184, 223, "z", 128, 136, 149, 182, 198, 223, "|", 130, 138, 155, 199, 218, 223, "~", 134, 143, 162, 223, 127, 133, 144, 171, 196, 223, 129, 135, 148, 184, 208, 223, 131, 138, 154, 201, 223, 133, 140, 161, 183, 223, 136, 144, 171, 192, 223, 139, 148, 184, 206, 223, 142, 154, 173, 202, 223, 146, 161, 174, 223, 150, 170, 184, 223, 156, 182, 198, 223, 163, 200, 220, 223, 171, 223, 182, 223, 196, 223, 217, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, "~", 223, "j", 223, "i", 223, "h", 223, "h", 223, "h", 223, "h", 223, "hm", 223, "hj", 223, "hj", 223, "hi", 223, "hi", 223, "hi", 181, 223, "hil", 223, "hik", 223, "hik", 223, "hij", 223, "hijp", 223, "hik", 223, "hik", 223, "hik", 223, "hiko", 223, "hikm", 223, "hikm", 223, "hikm", 223, "hikm", 223, "hikm{", 223, "hikmq", 223, "hijln", 223, "hijlnt", 223, "hijlo", 223, "hijlou", 223, "hijlor", 223, "hijkmpu", 223, "hijkmpt", 223, "hijkmps", 223, "hijkmps", 223, "hijkmpt", 223, "hijklnru", 223, "hijklnrv", 223, "hijklnquy", 223, "hijkmptx", 179, 223, "hijkmosy", 143, 223, "hijklnqv{", 166, 223, "hijkmnqu|", 147, 223, "hijkmorw~", 154, 223, "hijklmorw", 127, 148, 223, "hijklnpsx", 127, 133, 177, 223, "hijklnpsx~", 133, 167, 223, "hijklmoqty", 128, 136, 173, 223, "hijklmoquz", 129, 139, 180, 223, "hijklnprv|", 132, 143, 193, 223, "ijklnpsw}", 134, 147, 159, 223, "ijklmnpsvz", 129, 138, 153, 165, 223, "ijklmoqty", 129, 140, 160, 172, 223, "ijklmnoqsu{", 131, 144, 170, 184, 223, "ijklnpsv|", 134, 149, 182, 198, 223, "ijklmnprux~", 137, 155, 200, 219, 223, "ijklmoqtx|", 129, 140, 162, 221, 223, "jklmoqrvz", 130, 144, 171, 193, 223, "jklnprsw|", 132, 148, 184, 207, 223, "jkmnpqsux}", 132, 139, 155, 201, 223, "jlmoqtwz", 127, 134, 141, 162, 223, "jlnoqruy}", 129, 134, 143, 171, 194, 223, "klnprsvy|", 132, 140, 148, 184, 207, 223, "kmnpqsuwy~", 134, 138, 153, 164, 202, 223, "kmoqtvxz", 127, 138, 143, 160, 172, 223, "kmoqruwz", 129, 135, 142, 147, 170, 184, 223, "ikmnprsvx{~", 132, 145, 151, 182, 198, 223, "ilnpqsuwy}", 128, 135, 145, 153, 160, 199, 218, 223, "hlnoqtvxz", 127, 131, 138, 145, 159, 166, 223, "hloqruxz}", 129, 132, 142, 148, 168, 177, 223, "hlnprsvx{}", 131, 134, 146, 153, 181, 191, 206, 223, "hlnpqsuwy}", 127, 134, 137, 152, 159, 198, 210, 223, "hmoqtvxz~", 128, 137, 141, 159, 167, 223, "hmoruwz~", 129, 132, 141, 145, 168, 177, 223, "hmoqsvx{}", 131, 134, 146, 151, 181, 192, 223, "hmpsuwy}", 127, 134, 137, 152, 157, 198, 211, 223, "hmoqtvxz", 127, 130, 137, 140, 159, 165, 223, "hjmpruwz}", 129, 132, 141, 144, 156, 168, 175, 183, 223, "hjmpsvx{}", 131, 134, 146, 149, 154, 180, 188, 197, 223, "hjnqswx}", 127, 134, 137, 151, 155, 159, 197, 207, 218, 223, "hjmprtxz~", 128, 137, 140, 158, 162, 167, 223, "hjmpruy{", 129, 131, 141, 144, 167, 172, 177, 223, "hjmqsv{}", 131, 134, 146, 150, 179, 185, 191, 198, 223, "hjmqswz}", 127, 134, 137, 151, 155, 160, 196, 203, 211, 219, 223, "hjmptx{", 127, 129, 137, 140, 158, 163, 168, 222, 223, "himpsvz", 129, 131, 141, 144, 150, 167, 172, 178, 223, "himptw{~", 131, 133, 145, 148, 151, 180, 187, 194, 223, "hjnqtwz}", 128, 134, 137, 151, 154, 158, 197, 205, 214, 223, "hjmptx{", 127, 131, 137, 140, 158, 162, 166, 222, 223, "hjmpsvz", 129, 132, 141, 144, 150, 167, 172, 177, 223, "inqtw{", 127, 131, 134, 145, 148, 151, 179, 184, 190, 196, 223, "inqtx}", 129, 134, 137, 151, 154, 158, 196, 202, 209, 216, 223, "imoquy", 127, 132, 137, 140, 158, 162, 166, 222, 223, "imorvz", 129, 133, 141, 144, 167, 172, 177, 223, "jnpsw|", 131, 134, 146, 150, 179, 184, 190, 196, 223, "jnqsvy}", 134, 137, 151, 155, 159, 196, 203, 210, 217, 223, "knprtx|", 128, 137, 141, 158, 163, 168, 222, 223, "npruz", 129, 134, 141, 145, 167, 172, 178, 223, "npsvy|", 132, 140, 146, 150, 179, 185, 191, 198, 223, "mprtwy}", 130, 135, 141, 152, 157, 196, 203, 211, 220, 223, "moqtwy", 127, 132, 138, 143, 159, 164, 172, 222, 223, "loruy{", 129, 133, 142, 147, 168, 174, 181, 223, "loqsvy{}", 131, 134, 146, 151, 180, 187, 195, 223, "knqsuwy}", 128, 134, 137, 152, 158, 197, 206, 215, 223, "knqtwy", 127, 130, 137, 141, 159, 166, 222, 223, "koruxz~", 129, 132, 141, 145, 168, 176, 210, 223, "kortvx{}", 131, 134, 146, 151, 180, 189, 199, 223, "kortwy}", 127, 134, 137, 152, 157, 197, 208, 220, 223, "loqtwy", 127, 130, 137, 140, 159, 165, 223, "lpruxz}", 129, 132, 141, 144, 168, 174, 181, 223, "lpsvy{}", 131, 134, 146, 150, 180, 188, 196, 223, "lortwy}", 127, 134, 137, 151, 155, 160, 197, 206, 216, 223, "lortxz", 127, 129, 137, 140, 158, 163, 168, 222, 223, "knruz~", 129, 132, 141, 144, 167, 172, 178, 223, "knrv{}", 131, 134, 146, 150, 180, 187, 194, 223, "knruwz}", 127, 134, 137, 151, 155, 159, 197, 205, 214, 223, "knqux{", 127, 130, 137, 140, 158, 163, 168, 222, 223, "kosvz", 129, 132, 141, 144, 155, 168, 173, 179, 223, "kosw{~", 131, 134, 146, 149, 154, 180, 186, 193, 223, "korw}", 128, 134, 137, 151, 155, 159, 197, 204, 212, 221, 223, "korwz", 127, 131, 137, 140, 158, 162, 167, 222, 223, "kosx{", 129, 132, 141, 144, 161, 168, 173, 178, 223, "kptx|", 131, 134, 146, 150, 179, 185, 191, 198, 223, "korv{~", 134, 137, 151, 155, 159, 196, 203, 210, 218, 223, "koruz", 127, 134, 138, 141, 158, 163, 168, 222, 223, "kosv{", 129, 133, 141, 145, 167, 172, 177, 223, "kosw|", 132, 139, 146, 150, 179, 185, 191, 198, 223, "jnsx~", 134, 138, 151, 155, 160, 196, 203, 211, 219, 223, "jnty", 128, 138, 143, 158, 163, 168, 222, 223, "jnsv{", 130, 141, 146, 168, 174, 180, 223, "jnrw|", 132, 146, 151, 180, 187, 194, 223, "jnrx~", 135, 152, 158, 197, 205, 214, 223, "imrx", 127, 138, 147, 159, 166, 222, 223, "insz", 130, 142, 149, 168, 175, 184, 223, "ins{", 130, 136, 147, 155, 180, 189, 198, 223, "int}", 135, 152, 160, 197, 207, 218, 223, "int}", 129, 139, 160, 169, 223, "imrw", 129, 136, 144, 169, 179, 223, "ilqw", 131, 136, 147, 158, 181, 193, 223, "ilqx", 133, 138, 153, 164, 198, 212, 223, "ilqx", 131, 138, 145, 160, 172, 223, "ilrz", 135, 142, 148, 170, 183, 223, "ilrz", 131, 146, 153, 182, 198, 223, "ils{", 130, 148, 155, 171, 200, 219, 223, "ils{", 130, 147, 160, 169, 223, "ils|", 132, 150, 169, 179, 223, "ilt~", 134, 154, 181, 192, 223, "ils}", 136, 159, 198, 212, 223, "ilqx", 131, 140, 167, 223, "ilpx", 132, 144, 176, 223, "ikox", 134, 148, 189, 223, "ikoy", 137, 154, 207, 223, "hjmq{", 140, 161, 182, 223, "ilp|", 144, 171, 191, 223, "ikow", 129, 150, 183, 204, 223, "ilq", 127, 151, 201, 223, "ilq", 128, 152, 176, 223, "ilpv", 132, 160, 188, 223, "iknt", 134, 163, 193, 223, "iknt", 137, 168, 208, 223, "ilpv", 141, 177, 223, "ilpw", 145, 186, 223, "iknsz", 150, 199, 223, "iknsz", 156, 217, 223, "ilpy", 150, 173, 223, "ilpv~", 173, 223, "ikns}", 174, 208, 223, "ikns", 127, 171, 209, 223, "ilpv", 129, 169, 223, "ilpv", 131, 169, 223, "ilpv", 133, 170, 223, "ilpv", 133, 162, 223, "ilpv", 128, 142, 191, 223, "ilpv~", 145, 197, 223, "ilpv", 127, 149, 208, 223, "jmqx", 129, 155, 223, "jmqx", 130, 162, 223, "jmqw", 130, 168, 198, 223, "jmqx", 131, 164, 191, 223, "ilpv", 128, 140, 203, 223, "ilpv", 128, 142, 204, 223, "ilpv", 127, 144, 207, 223, "ilpv", 127, 140, 157, 223, "ilpv", 128, 142, 160, 223, "imry", 132, 147, 167, 223, "imry", 133, 149, 175, 223, "imry", 134, 152, 187, 223, "hkot|", 138, 159, 205, 223, "hkou~", 142, 166, 223, "hkou~", 141, 174, 223, "hjou~", 139, 157, 189, 223, "hkou~", 140, 159, 206, 223, "hjov", 128, 143, 166, 223, "hjov", 127, 145, 175, 223, "hjov", 127, 140, 159, 190, 223, "hjou~", 139, 159, 206, 223, "hjns{", 134, 151, 174, 223, "hils|", 136, 153, 178, 223, "hils}", 137, 154, 188, 223, "hjnt", 127, 140, 160, 206, 223, "hjnu", 129, 143, 166, 223, "hikov", 131, 147, 175, 223, "hikow", 134, 152, 188, 223, "hikox", 136, 158, 206, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, "k", 223, "i", 223, "h", 223, "h", 223, "h", 223, "h", 223, "h", 223, "hj", 223, "hi", 223, "hi", 223, "hi", 223, "hi", 223, "hio", 223, "hik", 223, "hij", 223, "hij", 223, "hij", 223, "hijm", 223, "hijl", 223, "hijk", 223, "hijkx", 223, "hijkm", 223, "hijkl", 223, "hijkl", 138, 223, "hijklo", 223, "hijkm", 223, "hijklmt", 223, "hijkln", 223, "hijkln", 150, 223, "hijkmo", 223, "hijklmo", 181, 223, "hijklnp", 223, "hijklnp|", 223, "hijklmoq", 223, "hijklmoqx", 223, "hijklnpr", 129, 223, "hijklnps", 223, "hijkmnprt", 223, "hijkmoqtz", 223, "hijklnoqsu|", 223, "hijkmnpsv|", 223, "hijklnprtwz", 223, "hijklmoqtx|", 223, "hijlnoqruz", 137, 223, "hijlnprtw|", 144, 223, "hijklmoqsux}", 132, 223, "hijkmoqtwz", 127, 134, 223, "hijkmnpruy|", 129, 134, 189, 223, "hijkmnprtvy|", 132, 140, 223, "hijkmnpsuwy}", 132, 136, 171, 223, "ijklnoqtwy", 127, 134, 139, 163, 223, "iklnoqtvz", 129, 134, 142, 147, 200, 223, "iklnpsvy|", 132, 140, 147, 153, 212, 223, "ikmpqtwy}", 129, 135, 142, 152, 159, 223, "ikmoqtxz", 127, 132, 138, 143, 159, 167, 223, "iklnqrvz", 129, 133, 142, 147, 168, 177, 223, "ijlnqsw{~", 132, 137, 146, 152, 181, 191, 205, 223, "jlnqsux}", 129, 134, 138, 152, 159, 198, 211, 223, "jlmortvy", 127, 132, 138, 142, 159, 167, 223, "jlnpsux{", 129, 133, 141, 146, 168, 177, 223, "jknpsvx|", 131, 134, 146, 151, 180, 190, 201, 223, "jlnpruwy~", 134, 138, 152, 158, 198, 210, 223, "jloquxz", 127, 137, 141, 159, 165, 223, "jlorvz~", 130, 141, 145, 168, 175, 184, 223, "jlnpsw{}", 132, 145, 150, 180, 189, 198, 223, "jlnprtx}", 127, 135, 145, 152, 157, 197, 207, 218, 223, "jlmprtx~", 128, 138, 145, 159, 165, 223, "kmoruy}", 129, 132, 142, 148, 168, 175, 183, 223, "knqsvy|", 131, 134, 146, 153, 180, 188, 197, 223, "kmortwy~", 134, 137, 152, 159, 197, 206, 217, 223, "kmortxz", 127, 136, 139, 144, 159, 167, 223, "kmoruz", 129, 134, 141, 144, 168, 177, 223, "kmptvz}", 132, 142, 146, 150, 181, 192, 223, "kmpruwy}", 128, 135, 142, 151, 155, 160, 198, 211, 223, "kmoquxz", 127, 131, 138, 143, 158, 163, 168, 223, "kmprvz", 129, 132, 142, 147, 167, 173, 179, 223, "kmortw{~", 131, 134, 146, 152, 180, 187, 194, 223, "kmortx}", 128, 134, 137, 152, 158, 197, 205, 214, 223, "kmortwz", 127, 131, 138, 142, 159, 166, 222, 223, "kmoruy}", 129, 132, 141, 145, 168, 176, 223, "kmoqtvy}", 131, 134, 146, 151, 180, 189, 199, 223, "kmoruwy~", 134, 137, 151, 156, 187, 199, 210, 223, "kmoqtxz", 127, 137, 141, 159, 165, 223, "kmoruz", 128, 132, 141, 145, 168, 174, 181, 223, "kmoqsv{~", 132, 146, 151, 180, 188, 196, 223, "kmoqswz}", 128, 135, 144, 152, 157, 197, 206, 216, 223, "kmoqtx{", 127, 131, 138, 145, 159, 165, 222, 223, "kmoruz", 129, 132, 142, 148, 168, 175, 183, 223, "kmoqsv{", 127, 132, 136, 146, 152, 180, 188, 196, 223, "kmoqsvy}", 130, 134, 137, 152, 159, 197, 206, 216, 223, "kmoqtx|", 127, 132, 138, 141, 159, 167, 222, 223, "kmoruz", 129, 133, 141, 145, 168, 177, 223, "kmoqsv{", 128, 132, 137, 146, 150, 181, 191, 205, 223, "kmoqsvx}", 132, 135, 140, 152, 157, 198, 210, 223, "kmoqtx{", 127, 133, 138, 142, 159, 164, 172, 223, "kmoruz", 129, 133, 141, 145, 168, 174, 181, 223, "kmoqsv{~", 132, 140, 146, 151, 180, 187, 195, 223, "kmoqswz}", 129, 135, 141, 152, 157, 197, 206, 216, 223, "kmoqtx{", 127, 132, 138, 143, 159, 165, 222, 223, "kmoruz", 129, 133, 142, 147, 168, 175, 183, 223, "knpsv{~", 132, 137, 146, 152, 180, 188, 197, 223, "kmoqsvy}", 129, 134, 137, 152, 158, 197, 206, 216, 223, "kmoqtx{", 127, 132, 138, 142, 159, 166, 222, 223, "jloruz", 129, 133, 141, 145, 168, 176, 223, "jlnpsvz}", 131, 134, 146, 151, 180, 190, 201, 223, "kmprtwy}", 131, 135, 139, 152, 157, 197, 209, 222, 223, "kmoqtxz", 127, 133, 138, 142, 159, 165, 223, "jloruz", 129, 133, 141, 145, 168, 175, 183, 223, "jmpsv{~", 132, 138, 146, 151, 180, 188, 196, 223, "jmpsvy}", 128, 134, 138, 152, 157, 197, 206, 216, 223, "kmoqtx{", 127, 131, 138, 142, 159, 165, 222, 223, "knqsuz", 129, 132, 141, 146, 168, 175, 183, 223, "knpsvz}", 131, 134, 146, 151, 180, 188, 196, 223, "knqswy}", 129, 134, 137, 152, 158, 197, 206, 216, 223, "kmoqtxz", 127, 132, 138, 141, 159, 166, 222, 223, "kmoruz", 129, 133, 141, 145, 168, 175, 185, 223, "kmpsv{~", 132, 137, 146, 150, 180, 189, 198, 223, "kmpswz}", 129, 134, 138, 151, 156, 175, 197, 207, 218, 223, "jmprux{", 127, 131, 138, 142, 159, 164, 172, 223, "jmpruz", 129, 132, 141, 145, 168, 174, 181, 223, "jmortw{~", 131, 134, 146, 151, 180, 187, 195, 223, "jmosvy}", 129, 134, 137, 152, 157, 197, 205, 214, 223, "jmortx|", 127, 132, 138, 142, 159, 165, 222, 223, "jmoruz", 129, 133, 141, 145, 168, 175, 183, 223, "jmptvz}", 131, 134, 146, 150, 180, 188, 197, 223, "jmpswy}", 131, 135, 139, 152, 157, 197, 206, 217, 223, "jmprux{", 127, 133, 138, 142, 159, 165, 223, "jnqsvz", 129, 133, 141, 145, 168, 174, 181, 223, "jnqsw{~", 132, 138, 146, 150, 180, 187, 195, 223, "jnqsw}", 129, 135, 140, 152, 157, 197, 206, 216, 223, "korty", 127, 132, 138, 142, 159, 164, 172, 222, 223, "kosuz", 129, 132, 141, 146, 168, 174, 181, 223, "kosv|", 131, 134, 146, 151, 180, 187, 195, 223, "koswz~", 134, 137, 152, 158, 197, 206, 216, 223, "korux{", 128, 137, 141, 159, 166, 222, 223, "kosvz", 129, 135, 141, 145, 168, 175, 185, 223, "kosw{", 127, 132, 146, 151, 180, 189, 199, 223, "kotx}", 131, 136, 152, 157, 197, 207, 218, 223, "lpuy", 127, 133, 139, 159, 165, 223, "lqvz", 129, 133, 142, 148, 168, 175, 183, 223, "lqw|", 132, 139, 147, 153, 180, 188, 196, 223, "kotx}", 134, 138, 152, 159, 197, 206, 216, 223, "knsy", 127, 138, 143, 159, 167, 222, 223, "kou{", 129, 135, 142, 147, 168, 177, 223, "kou|", 132, 146, 152, 181, 192, 223, "kou{", 129, 135, 145, 152, 158, 198, 211, 223, "kpv|", 130, 138, 145, 159, 166, 223, "lpw~", 132, 142, 148, 168, 176, 223, "lqx", 127, 134, 146, 152, 180, 190, 201, 223, "lqy", 128, 136, 152, 159, 197, 209, 222, 223, "lrz", 129, 139, 159, 167, 223, "ms|", 132, 143, 168, 177, 223, "ms}", 134, 148, 181, 192, 223, "mt", 127, 137, 154, 187, 199, 212, 223, "mu", 129, 140, 161, 177, 223, "nv", 131, 143, 170, 186, 223, "nw", 132, 148, 183, 202, 223, "nw", 130, 152, 165, 200, 223, "oy", 135, 161, 178, 223, "oz", 136, 160, 174, 223, "p|", 139, 165, 184, 203, 223, "p}", 141, 168, 200, 223, "q", 127, 144, 173, 223, "q", 128, 147, 182, 223, "r", 131, 153, 195, 223, "s", 134, 159, 213, 223, "t", 137, 166, 223, "u", 140, 168, 221, 223, "v", 143, 162, 195, 223, "w", 146, 166, 209, 223, "x", 149, 169, 223, "y", 153, 177, 223, "{", 159, 189, 223, "}", 166, 206, 223, 127, 175, 223, "o", 131, 186, 223, "o", 133, 200, 223, "o", 130, 146, 222, 223, "o", 129, 144, 223, "m", 133, 150, 223, "m", 132, 152, 223, "l", 129, 157, 223, "l", 130, 164, 223, "l", 132, 174, 223, "k", 136, 187, 223, "k", 140, 205, 223, "k", 143, 223, "k", 147, 223, "k", 150, 223, "j|", 153, 223, "js", 157, 223, "js", 160, 223, "js", 164, 223, "jt", 172, 223, "jt", 181, 223, "ju", 191, 223, "ju", 206, 223, "jt", 223, "js", 211, 223, "jr", 182, 223, "jq", 176, 223, "jq", 131, 181, 223, "jp", 129, 210, 223, "jp", 131, 168, 223, "jp", 131, 168, 223, "jo", 131, 171, 223, "jo", 132, 177, 223, "jo", 134, 187, 223, "jo", 135, 200, 223, "imx", 147, 221, 223, "imx", 149, 223, "imw", 153, 223, "imv", 158, 223, "imu", 162, 223, "imu", 169, 223, "imt", 140, 190, 223, "imt", 137, 201, 223, "hkp~", 218, 223, "hjox", 148, 223, "hjox", 145, 223, "imt", 139, 223, "hjox", 147, 223, "hjox", 149, 223, "hjnv", 149, 223, "ilr~", 161, 223, "hjnv", 134, 174, 223, "hjnv", 134, 178, 223, "hjnv", 135, 187, 223, "hjnv", 135, 200, 223, "hjmt", 131, 215, 223, "hjmt", 131, 181, 223, "hjmt", 130, 161, 223, "hjmt", 130, 160, 223, "hjmt", 130, 162, 223, "hjmt", 130, 168, 223, "hjms", 128, 158, 222, 223, "hjms", 128, 158, 216, 223, "hjmr~", 157, 223, "hjmq|", 147, 209, 223, "hjmq{", 147, 205, 223, "hjmq{", 145, 207, 223, "hikns", 127, 157, 223, "hikns", 127, 153, 223, "hilpw", 137, 182, 223, "hikns", 128, 156, 218, 223, "hikns", 127, 159, 223, "hiknrz", 145, 190, 223, "hikns{", 147, 194, 223, "hijmqw", 137, 192, 223, "hijmqw", 135, 178, 223, "hijlpv", 128, 157, 223, "hikns{", 148, 212, 223, "hikns{", 143, 203, 223, "hiknsz", 134, 169, 223, "hikmqx", 131, 168, 223, "hikmqw", 129, 156, 210, 223, "hikmqw", 128, 143, 197, 223, "hikmqw", 129, 143, 204, 223, "hikmqw", 129, 143, 192, 223, "hikmpv", 127, 145, 196, 223, "hikmot|", 136, 153, 213, 223, "hijlnry", 132, 150, 180, 223, "hijlnpv", 128, 142, 166, 223, "hijlos{", 134, 149, 176, 223, "hijlnqw", 128, 143, 162, 192, 223, "hijlory", 131, 148, 168, 208, 223, "hijlory", 131, 146, 167, 223, "hijlory", 132, 148, 175, 223, "hijknqt}", 136, 153, 187, 223, "hijlosz", 132, 150, 181, 214, 223, "hijloru~", 141, 166, 223, "hijkmptx", 131, 146, 175, 223, "hijkmptw", 129, 145, 175, 209, 223, "hijlnqux", 130, 143, 161, 207, 223, "hijlnquy", 132, 146, 166, 223, "ijlnrv{", 135, 150, 175, 223, "ijlnqu{", 134, 151, 187, 223, "ijlnquz", 127, 141, 159, 205, 223, "ijlnpty", 128, 143, 165, 223, "ijkmosx~", 131, 148, 174, 223, "ijkmoqu|", 132, 152, 187, 223, "ijkmorv|", 133, 139, 159, 205, 223, "ikmorv{", 129, 139, 166, 223, "iklorv|", 131, 142, 150, 177, 223, "ikmpsw}", 133, 147, 157, 190, 223, "ikmpsx", 127, 136, 153, 163, 208, 223, "jlmpruz", 129, 139, 160, 171, 223, "jlnqsv{", 131, 143, 169, 181, 223, "jlnqtw}", 134, 148, 182, 197, 223, "jmorux~", 136, 154, 190, 206, 223, "ilnpty", 128, 140, 161, 178, 223, "jmoruz", 130, 143, 170, 186, 223, "jmoqtw|", 133, 148, 183, 202, 223, "jmoqtx}", 136, 154, 200, 223, "jmoquy", 127, 139, 161, 183, 223, "jmorvz", 129, 136, 145, 171, 192, 223, "jmpsw|", 132, 148, 183, 205, 223, "jmpsw}", 135, 153, 168, 202, 223, "jnqty", 127, 137, 143, 161, 177, 223, "jnru{", 129, 135, 143, 162, 176, 223, "jnrux}", 132, 146, 153, 183, 202, 223, "koswz", 127, 135, 145, 153, 161, 200, 222, 223, "kotx|", 130, 138, 145, 160, 169, 223, "kpuz", 130, 142, 148, 169, 180, 223, "kpv{", 128, 135, 146, 153, 181, 194, 223, "kpvy}", 132, 140, 152, 159, 198, 213, 223, "kpvy", 127, 134, 142, 159, 167, 223, "lqw{", 129, 133, 143, 169, 178, 223, "lry|", 132, 140, 149, 181, 192, 223, "lry~", 134, 138, 154, 184, 199, 213, 223, "lqw", 127, 137, 142, 161, 177, 223, "lpv", 127, 131, 142, 147, 170, 186, 223, "lov", 127, 132, 144, 149, 183, 202, 223, "lpw", 129, 135, 144, 152, 158, 200, 222, 223, "lpw", 129, 138, 144, 159, 166, 223, "lqx", 131, 142, 148, 168, 176, 223, "lqy", 133, 146, 152, 180, 190, 201, 223, "lqz", 133, 152, 159, 198, 210, 223, "lr{", 134, 149, 160, 168, 223, "ls|", 135, 150, 169, 178, 223, "ls~", 138, 154, 181, 192, 223, "mt", 127, 140, 158, 198, 211, 223, "mu", 129, 143, 165, 223, "mv", 131, 147, 174, 223, "mw", 134, 152, 187, 223, "nx", 137, 158, 205, 223, "ny", 140, 166, 223, "nz", 144, 175, 223, "ny", 128, 149, 188, 223, "o}", 155, 207, 223, "o|", 132, 162, 223, "oz", 131, 172, 223, "oz", 134, 184, 212, 223, "p|", 137, 202, 223, "q~", 140, 223, "q~", 144, 223, "q", 127, 149, 223, "r", 129, 155, 223, "r", 131, 162, 223, "r", 133, 172, 223, "s", 136, 185, 214, 223, "t", 139, 203, 223, "u", 142, 223, "v", 147, 223, "v", 151, 223, "w", 153, 223, "w", 142, 175, 223, "x", 144, 183, 223, "y", 146, 194, 223, "z", 148, 213, 223, "{", 151, 223, "}", 155, 223, "~", 159, 223, 127, 165, 223, 128, 172, 223, 130, 183, 223, 132, 196, 223, "z", 210, 223, "v", 135, 223, "o", 137, 223, "o", 140, 223, "o", 143, 223, "p", 147, 223, "o", 151, 223, "n", 156, 223, "n", 163, 223, "n", 171, 223, "n", 182, 223, "n", 195, 223, "m", 169, 223, "l", 175, 223, "l", 183, 223, "l", 187, 223, "l", 191, 223, "l", 197, 223, "k~", 215, 223, "k}", 223, "k|", 223, "jv", 155, 223, "jv", 159, 223, "jw", 164, 223, "jx", 171, 223, "ky", 179, 223, "k{", 191, 223, "kv", 153, 217, 223, "kv", 166, 223, "kw", 167, 223, "kw", 187, 223, "kw", 223, "kx", 223, "jr", 150, 223, "jr", 154, 223, "jp", 127, 165, 223, "jp", 129, 173, 223, "jo", 131, 158, 223, "jp", 133, 160, 208, 223, "jp", 136, 165, 215, 223, "jp", 137, 167, 221, 223, "jq", 141, 174, 223, "jq", 143, 183, 223, "jr", 148, 196, 223, "jq", 135, 165, 219, 223, "jq", 136, 171, 223, "jq", 136, 182, 223, "jpz", 144, 195, 223, "imw", 151, 214, 223, "imw", 152, 223, "imx", 156, 223, "imx", 160, 223, "imy", 167, 223, "imx", 173, 223, "imv", 133, 188, 223, "iny", 140, 198, 223, "imv", 135, 180, 223, "imw", 137, 184, 223, "imv", 138, 202, 223, "imt", 137, 223, "imt", 140, 193, 223, "ilr", 127, 149, 223, "ilr", 128, 153, 221, 223, "hjow", 152, 220, 223, "hjnv", 134, 164, 223, "hkq~", 171, 223, "hjmu", 136, 182, 223, "hjmu", 137, 196, 223, "hjmu", 139, 215, 223, "hjmu", 140, 223, "hilr}", 150, 223, "hilp{", 154, 223, "hilp{", 159, 223, "hjmr~", 168, 223, "hjmr", 128, 178, 223, "hjmr", 128, 190, 223, "hjnt", 132, 210, 223, "hikns", 130, 155, 223, "hikou", 135, 164, 223, "hikou", 135, 163, 223, "hikou", 135, 164, 223, "hiknt", 135, 169, 223, "hikmqx", 143, 182, 223, "hijlqx", 144, 193, 223, "hijmrz", 148, 211, 223, "hijmrz", 149, 223, "hijlot}", 156, 223, "hijlnt~", 159, 223, "hijknt", 127, 165, 223, "hijknry", 133, 177, 223, "hijkmpw", 132, 184, 223, "hijkmpx", 134, 197, 223, "hijkmqy", 137, 217, 223, "hijklorz", 139, 223, "hijklos|", 144, 223, "hijklns}", 145, 222, 223, "hijklmqt", 127, 149, 181, 223, "hijklmpu", 129, 152, 179, 223, "hijklmnrv", 131, 155, 183, 223, "hijklnqw", 134, 160, 193, 223, "hijkmnpv{", 137, 165, 209, 223, "hijkmory", 140, 173, 223, "hijklmoqw|", 144, 182, 223, "hijkmnpt|", 149, 195, 223, "hijkmnpqu}", 155, 214, 223, "hijklmoqt|", 130, 162, 223, "hijklnoqrv", 129, 162, 186, 223, "hijklnprsx", 132, 176, 205, 223, "hijkmoqsuz", 135, 183, 215, 223, "hijkmoqtv{", 138, 167, 223, "hiklnpruw|", 138, 147, 223, "hikmnprsvx~", 141, 150, 223, "hikmoqsuwy", 127, 143, 155, 223, "hijlnoqtwy", 128, 145, 161, 177, 223, "hijlnpruxz~", 133, 152, 171, 187, 223, "ijlnpsvy{}", 133, 154, 183, 201, 223, "hjlmoqtwy}", 127, 136, 160, 200, 222, 223, "hjlmoqtxz", 127, 130, 140, 168, 223, "hjkmoruz", 128, 131, 143, 177, 223, "iknpsw{~", 131, 134, 148, 191, 223, "ikmoqsvy}", 128, 134, 137, 154, 204, 223, "hjloqty", 127, 131, 137, 140, 161, 180, 223, "ikloruz", 129, 132, 141, 145, 171, 189, 223, "ikmpsv|", 131, 134, 146, 150, 183, 203, 223, "ikmprux}", 134, 137, 151, 156, 171, 201, 223, "ikmprux|", 128, 137, 141, 158, 163, 169, 223, "ikmoruz", 129, 135, 141, 145, 168, 174, 181, 223, "ikmortw|", 132, 144, 148, 153, 180, 187, 195, 223, "ikmosvy}", 132, 137, 152, 157, 197, 205, 214, 223, "ikmorty", 127, 133, 139, 159, 165, 222, 223, "ikmoruz", 129, 133, 142, 148, 168, 175, 183, 223, "iknptv{", 128, 132, 139, 147, 154, 180, 188, 196, 223, "ikmprvy}", 133, 137, 152, 159, 197, 206, 216, 223, "ikmoqux{", 127, 135, 139, 153, 161, 169, 222, 223, "ikmorvz", 129, 134, 142, 147, 168, 177, 223, "ikmpsw{", 127, 132, 141, 147, 152, 181, 192, 223, "ikmpsvz}", 130, 135, 142, 152, 158, 198, 211, 223, "ikmprty", 127, 132, 138, 143, 159, 166, 223, "ikmpsu{", 129, 133, 142, 147, 168, 176, 223, "ikmoruw|", 131, 134, 146, 152, 180, 189, 199, 223, "ikmoruwz", 127, 134, 138, 152, 159, 197, 208, 220, 223, "ikmorux{", 128, 137, 141, 159, 166, 223, "ikmoruz", 130, 141, 146, 168, 177, 223, "ikmpsw{", 127, 133, 146, 151, 180, 190, 201, 223, "ikmpsw|", 127, 135, 152, 157, 198, 210, 223, "ikmoquy", 127, 132, 139, 159, 165, 223, "ikmorvz", 129, 133, 142, 150, 168, 175, 184, 223, "ikmortw|", 131, 134, 147, 156, 180, 188, 197, 223, "ikmortx}", 133, 137, 153, 162, 197, 207, 218, 223, "ikmorty", 127, 135, 139, 148, 160, 170, 223, "ijloruz", 129, 134, 141, 146, 169, 180, 223, "ijlnpsv{", 132, 142, 147, 152, 181, 194, 223, "ijlnqtwz~", 134, 139, 152, 158, 199, 215, 223, "ikmoqux{", 128, 138, 144, 159, 165, 223, "ikmorvz", 130, 142, 148, 168, 175, 184, 223, "ikmortw{", 127, 133, 146, 152, 180, 189, 198, 223, "ikmortx}", 130, 136, 152, 159, 197, 207, 218, 223, "ikmoruy", 127, 132, 139, 159, 167, 223, "ikloruz", 129, 133, 142, 149, 168, 177, 223, "ikmpsv|", 131, 134, 147, 155, 181, 191, 205, 223, "ikmprux}", 134, 138, 153, 161, 198, 210, 223, "ikmoqux|", 128, 137, 141, 160, 169, 223, "ikmorvz", 129, 136, 142, 147, 169, 180, 223, "ikmnqsw|", 132, 146, 151, 181, 194, 223, "ikmortx}", 132, 137, 152, 158, 198, 213, 223, "ikmorty", 127, 133, 139, 159, 165, 223, "ikmoruz", 129, 133, 142, 149, 168, 175, 184, 223, "ikmpsv{", 129, 133, 147, 155, 180, 189, 198, 223, "ikmpruwz~", 134, 138, 152, 160, 197, 207, 218, 223, "ikmoqux{", 127, 137, 142, 160, 169, 223, "ikmorvz", 129, 135, 142, 147, 169, 180, 223, "ikmortw{", 127, 132, 144, 149, 181, 193, 223, "jlnqsux}", 130, 135, 144, 152, 158, 198, 213, 223, "jlnpsuy", 127, 132, 138, 144, 159, 166, 223, "jlnpsuy}", 129, 133, 142, 148, 168, 176, 223, "jlnpsvy|", 131, 134, 146, 152, 180, 189, 199, 223, "jlnpruwy~", 134, 138, 152, 159, 197, 208, 220, 223, "jloquxz", 127, 137, 141, 159, 167, 223, "kmorvz", 128, 133, 141, 146, 168, 177, 223, "kmpsw{~", 132, 146, 151, 181, 192, 223, "kmpsvy}", 128, 135, 146, 152, 158, 198, 211, 223, "jlnqty", 127, 131, 138, 145, 159, 165, 223, "jlnqsuz", 129, 132, 142, 148, 168, 175, 184, 223, "jlnqsv{", 129, 132, 137, 147, 154, 180, 188, 197, 223, "jmoswz~", 134, 137, 152, 159, 197, 207, 218, 223, "jmortx{", 127, 135, 138, 142, 159, 167, 223, "jmoruz", 129, 134, 141, 145, 169, 179, 223, "jnptw{", 127, 132, 141, 146, 151, 181, 192, 223, "jnprvy}", 130, 135, 142, 152, 157, 198, 211, 223, "jnprux|", 127, 132, 138, 143, 159, 165, 223, "jorvz", 129, 133, 142, 147, 168, 175, 183, 223, "joqsw|", 131, 134, 146, 152, 180, 188, 197, 223, "jortx}", 131, 135, 140, 152, 159, 197, 206, 216, 223, "jnqty", 127, 133, 138, 142, 159, 166, 222, 223, "jmruz", 129, 133, 141, 146, 168, 176, 223, "jnruw|", 132, 139, 146, 151, 180, 190, 201, 223, "jnswz", 127, 134, 138, 152, 158, 197, 209, 222, 223, "jntx{", 128, 138, 143, 159, 165, 223, "jnuz", 130, 141, 146, 168, 175, 184, 223, "jnux{", 127, 133, 146, 151, 180, 188, 197, 223, "jnvy}", 129, 136, 152, 158, 197, 207, 218, 223, "jmqx}", 128, 138, 147, 159, 166, 223, "jmqy|", 129, 133, 142, 150, 168, 176, 222, 223, "jmqz}", 131, 134, 147, 156, 180, 189, 199, 223, "jnr{~", 134, 138, 153, 162, 197, 208, 220, 223, "jnr|", 128, 137, 141, 160, 170, 223, "jns~", 130, 141, 145, 169, 180, 223, "jns", 127, 132, 141, 146, 151, 181, 194, 223, "kot", 129, 135, 142, 152, 157, 198, 213, 223, "kou", 130, 138, 144, 159, 165, 223, "kpv", 133, 142, 147, 168, 175, 184, 223, "kpw", 135, 146, 152, 180, 188, 197, 223, "kpx", 138, 152, 159, 197, 207, 218, 223, "kpx", 141, 159, 167, 223, "jns{", 146, 168, 177, 223, "jns|", 150, 180, 190, 201, 223, "kpv~", 157, 198, 210, 223, "kot", 128, 164, 223, "kpv", 130, 174, 223, "kpv", 132, 187, 223, "kpw", 135, 205, 223, "kpw", 134, 144, 223, "kpx", 133, 145, 223, "kqy", 134, 149, 223, "kqz", 134, 154, 223, "kr{", 134, 161, 186, 223, "ls}", 137, 171, 193, 223, "lt~", 139, 183, 206, 223, "lt", 128, 142, 196, 222, 223, "lt", 130, 144, 194, 223, "lt", 131, 147, 200, 223, "ls{", 136, 153, 212, 223, "ls{", 138, 158, 223, "lt|", 142, 166, 223, "mu~", 146, 175, 223, "mu", 127, 150, 188, 223, "mv", 129, 157, 206, 223, "mv", 130, 164, 223, "mv", 132, 174, 223, "mv", 135, 187, 223, "nx", 138, 205, 223, "ny", 141, 223, "o{", 145, 223, "o{", 150, 223, "o|", 156, 223, "o}", 164, 223, "p", 128, 174, 223, "p", 128, 186, 223, "q", 131, 205, 223, "q", 132, 200, 223, "r", 135, 187, 223, "r", 135, 171, 223, "s", 138, 177, 223, "t", 142, 184, 223, "t", 137, 181, 223, "t", 135, 177, 223, "u", 136, 178, 223, "v", 138, 182, 223, "w", 140, 191, 223, "x", 142, 203, 223, "y", 145, 223, "y", 148, 223, "z", 152, 223, "{", 157, 223, "}", 164, 223, "~", 171, 223, 129, 182, 223, 131, 196, 223, 135, 215, 223, 139, 223, 145, 223, 151, 223, 157, 223, 164, 223, 174, 223, "o", 179, 223, "n", 143, 222, 223, "l", 141, 223, "l", 140, 223, "l", 142, 223, "l", 147, 223, "k", 149, 223, "k", 150, 223, "k", 152, 223, "k", 157, 223, "j", 174, 223, "iy", 190, 223, "ir", 184, 223, "iq", 182, 223, "io", 198, 223, "io", 167, 223, "io", 174, 223, "io", 186, 223, "io", 164, 223, "in", 206, 223, "hkx", 181, 223, "hkt", 189, 223, "hks", 199, 223, "hjp", 171, 223, "hjp", 173, 223, "hjn~", 223, "hjn", 127, 223, "hilv", 171, 223, "hilt", 179, 223, "hilt", 191, 223, "hilq}", 211, 223, "hikp~", 219, 223, "hikp", 128, 223, "hijms", 130, 186, 223, "hijms", 132, 196, 223, "hijms", 134, 210, 223, "hijlpv", 137, 190, 223, "hijlpv", 139, 186, 223, "hijlpw", 142, 192, 223, "hijknv", 148, 202, 223, "hijknu", 149, 209, 223, "hijkmrz", 156, 223, "hijkmr{", 163, 223, "hijklot}", 170, 223, "hijklnt~", 181, 223, "hijklnt", 128, 196, 223, "hijklmpv", 130, 206, 223, "ijklnry", 133, 215, 223, "ijklmou", 134, 175, 223, "ijklmosz", 138, 183, 223, "ijklmosz", 141, 188, 223, "hijklmnpt|", 145, 197, 223, "hjklmnpt}", 150, 209, 223, "hjklmnoqv", 128, 156, 223, "hjklmoqv", 129, 164, 223, "hjklmnoprw", 131, 173, 223, "hklmnpsx", 134, 186, 223, "hiklmnopqtz", 137, 204, 223, "hiklmoqsv|", 140, 223, "hiklmnoprv|", 144, 223, "hilmnprsw~", 149, 223, "hilmnopqstx", 128, 155, 223, "hikmoqrtuy", 129, 162, 223, "hijmnopruw{", 132, 171, 223, "hijmnprsvw|", 134, 175, 206, 223, "hijnopqstwx}", 137, 180, 213, 223, "hijlnoqrtuxy", 127, 140, 186, 223, "hijkopqruvyz|", 130, 144, 195, 223, "hijkoprsvw{|", 132, 149, 208, 223, "hijkpqstwx}", 127, 135, 149, 164, 223, "hijlpqstuxy~", 128, 138, 146, 163, 223, "hijlpruvyz{", 128, 130, 135, 142, 149, 172, 206, 223, "hijlqrsvw{|", 131, 133, 147, 155, 185, 210, 223, "hijkmqstwx|}~", 134, 136, 152, 160, 202, 223, "hijkmrtuxy~", 127, 128, 137, 140, 160, 169, 223, "hijkmsuvyz{", 128, 129, 130, 132, 141, 144, 149, 169, 180, 223, "hijkmosvw{|", 130, 131, 132, 133, 145, 148, 151, 181, 193, 223, "hijkmptwx|}~", 134, 136, 141, 151, 154, 158, 198, 213, 223, "hijklnuxy~", 127, 128, 137, 139, 141, 158, 162, 166, 223, "ijklouyz{", 128, 129, 130, 132, 141, 143, 145, 167, 172, 177, 223, "ijklnqv{|", 131, 132, 133, 145, 147, 150, 179, 184, 189, 195, 223, "ijkmpw|}~", 133, 134, 135, 136, 139, 151, 154, 157, 196, 203, 210, 217, 223, "ijkmpx~", 127, 128, 137, 138, 139, 140, 158, 161, 164, 167, 222, 223, "ijklnrx{", 128, 129, 130, 132, 141, 143, 145, 167, 170, 174, 178, 223, "jkmnrx|", 131, 132, 133, 145, 147, 149, 151, 179, 183, 187, 191, 196, 223, "jkmoty}", 129, 134, 135, 136, 139, 151, 153, 155, 157, 196, 201, 206, 211, 216, 222, 223, "jkmouy", 127, 131, 137, 138, 139, 140, 158, 160, 163, 166, 221, 223, "jklov{", 129, 132, 141, 142, 144, 146, 167, 170, 173, 176, 179, 223, "kmp|", 131, 134, 145, 147, 149, 151, 179, 182, 185, 188, 191, 195, 223, "kmp}", 130, 134, 137, 151, 153, 155, 157, 195, 199, 203, 207, 211, 215, 219, 223, "kmp|", 127, 131, 137, 140, 158, 160, 162, 164, 166, 221, 223, "lou}", 129, 132, 141, 144, 147, 167, 170, 173, 176, 179, 223, "lo{", 131, 134, 145, 148, 151, 179, 182, 185, 188, 191, 194, 200, 223, "mrz", 127, 134, 137, 151, 154, 157, 195, 198, 201, 204, 207, 210, 214, 218, 222, 223, "mtz", 128, 137, 140, 158, 161, 164, 167, 221, 223, "ny~", 130, 141, 144, 147, 167, 170, 173, 176, 179, 223, "ow|", 132, 137, 145, 148, 151, 179, 182, 186, 190, 194, 223, "rx}", 132, 135, 139, 151, 154, 157, 196, 200, 204, 208, 213, 218, 223, "ry", 127, 132, 137, 140, 158, 161, 164, 167, 221, 223, "rx|", 129, 132, 141, 144, 152, 167, 170, 173, 176, 180, 223, "quz}", 131, 134, 145, 148, 151, 179, 183, 187, 191, 195, 223, "quy}", 130, 134, 137, 151, 154, 157, 196, 201, 206, 211, 216, 221, 223, "quy", 127, 132, 137, 140, 158, 162, 166, 221, 223, "quz", 129, 132, 141, 144, 167, 171, 175, 179, 223, "rv|", 131, 134, 146, 149, 154, 179, 184, 189, 194, 223, "qtx}", 133, 136, 151, 155, 159, 196, 201, 207, 213, 220, 223, "quy", 127, 134, 138, 141, 158, 162, 167, 221, 223, "puz", 129, 133, 141, 144, 159, 168, 173, 178, 223, "pv{", 127, 132, 138, 146, 149, 154, 179, 185, 191, 197, 223, "pwz}", 129, 134, 138, 151, 155, 159, 196, 203, 210, 218, 223, "px{", 127, 132, 138, 142, 158, 162, 167, 222, 223, "oy|", 129, 132, 141, 145, 167, 172, 177, 223, "oz}", 131, 134, 146, 151, 179, 184, 190, 196, 223, "o|", 127, 134, 137, 152, 157, 196, 203, 210, 218, 223, "p}", 128, 137, 140, 159, 165, 222, 223, "p", 127, 130, 141, 145, 168, 175, 183, 223, "p", 128, 132, 136, 146, 150, 180, 188, 196, 223, "q", 130, 134, 137, 151, 156, 172, 197, 206, 216, 223, "q", 132, 138, 141, 158, 163, 169, 222, 223, "q", 133, 141, 145, 168, 174, 181, 223, "q", 136, 146, 150, 180, 187, 195, 223, "r", 139, 151, 156, 173, 197, 205, 214, 223, "r", 142, 158, 163, 169, 222, 223, "r", 132, 155, 168, 174, 181, 223, "r", 130, 155, 180, 187, 195, 223, "s", 130, 161, 197, 205, 214, 223, "t", 131, 168, 222, 223, "u", 132, 178, 223, "u", 133, 191, 223, "v", 135, 210, 223, "w", 137, 223, "x", 139, 223, "z", 141, 223, "{", 144, 223, "|", 147, 223, "~", 152, 223, 127, 156, 223, 129, 163, 223, 131, 171, 223, 134, 182, 223, 137, 195, 223, 141, 214, 223, "z", 145, 223, "u", 148, 223, "t", 153, 223, "s", 159, 223, "r", 167, 223, "r", 177, 223, "r", 191, 223, "r", 210, 223, "r", 223, "s", 223, "q", 223, "p", 223, "p", 223, "p", 223, "o", 223, "n", 223, "n", 223, "n", 223, "n", 223, "n", 223, "m", 223, "m", 207, 223, "m", 160, 223, "m", 149, 223, "m", 143, 223, "l", 134, 223, "l", 135, 223, "l", 133, 223, "l", 131, 223, "l", 130, 223, "lz", 171, 223, "lz", 168, 223, "l{", 170, 223, "l{", 173, 223, "l{", 175, 223, "l{", 189, 223, "m~", 192, 223, "l}", 215, 223, "l~", 223, "l", 127, 198, 223, "l~", 198, 223, "l|", 223, "lw", 142, 223, "lv", 143, 223, "ks", 145, 223, "kt", 149, 223, "ku", 155, 223, "ku", 161, 223, "kv", 168, 223, "kv", 179, 223, "kv", 193, 223, "kw", 212, 223, "kx", 223, "kw", 223, "kw", 211, 223, "kw", 135, 223, "kv", 134, 223, "kv", 136, 223, "kv", 138, 223, "kv", 140, 223, "kv", 143, 223, "jq", 139, 223, "jq", 136, 163, 223, "jp", 133, 162, 223, "jp", 133, 170, 223, "jq", 136, 180, 223, "jq", 137, 192, 223, "jq", 138, 211, 223, "jq", 140, 223, "jq", 138, 223, "jq", 138, 223, "jq", 138, 223, "jq", 139, 223, "jq", 134, 218, 223, "jq", 131, 217, 223, "iny", 179, 223, "iny", 179, 223, "inz", 184, 223, "jp}", 199, 223, "jp~", 209, 223, "jp", 127, 213, 223, "imw", 142, 223, "imv", 141, 223, "jo}", 161, 223, "imv", 142, 223, "jnx", 148, 223, "joy", 151, 223, "imv", 142, 223, "imw", 145, 213, 223, "imw", 145, 209, 223, "ilr", 127, 171, 223, "imu", 143, 221, 223, "imt", 130, 180, 223, "imt", 130, 177, 223, "ims", 129, 173, 223, "imt", 131, 179, 223, "imt", 132, 184, 223, "imt", 134, 194, 223, "imt", 136, 207, 223, "imt", 139, 223, "ilq{", 145, 223, "ilqz", 149, 223, "ilr|", 154, 223, "ilr|", 160, 223, "ilr}", 167, 223, "ilr~", 177, 223, "hjnu", 130, 191, 223, "hjnu", 130, 209, 223, "hkpx", 135, 223, "hjmt", 132, 203, 223, "hjms}", 144, 223, "hjms|", 142, 223, "hjmt~", 146, 223, "hilq|", 147, 217, 223, "hilpy", 141, 178, 223, "hilpy", 136, 164, 223, "hikow", 132, 167, 223, "hikow", 133, 176, 223, "hijmqz", 137, 190, 223, "hjmr|", 140, 208, 223, "hjmr|", 143, 223, "hikot", 127, 148, 223, "hikou", 129, 152, 223, "hjlpv", 131, 158, 223, "hjlpv", 132, 165, 223, "ikmqw", 134, 175, 223, "ikns{", 140, 189, 223, "ikmry", 139, 206, 223, "ikmrz", 142, 223, "ikmr{", 146, 223, "iknt}", 151, 223, "iknt", 127, 158, 223, "iknry", 132, 166, 223, "iknqw", 131, 175, 223, "hjmpx", 134, 188, 223, "hjmpx", 135, 179, 223, "hknqz", 139, 192, 223, "hknr{", 141, 196, 223, "hknr{", 139, 156, 223, "hknrv", 128, 150, 177, 223, "hjmpu", 129, 151, 173, 223, "hjmpu", 131, 154, 178, 223, "hjmqv", 133, 157, 188, 223, "hjnrx", 136, 163, 206, 223, "hjmqv{", 140, 171, 223, "hjnrw|", 144, 181, 223, "ikosx}", 149, 194, 223, "ikotz", 127, 155, 212, 223, "ikpu{", 129, 162, 223, "ikpv|", 131, 172, 223, "ikpu|", 133, 185, 223, "ikpu{", 131, 138, 203, 223, "iknry", 129, 139, 189, 223, "iknsz", 131, 143, 201, 223, "hjms{", 134, 148, 220, 223, "hjmt|", 136, 154, 189, 223, "hjmu}", 134, 144, 161, 178, 223, "hknv~", 134, 145, 170, 186, 223, "iknw", 128, 137, 149, 183, 202, 223, "ikntx", 129, 138, 155, 200, 223, "ilpy", 131, 141, 162, 223, "ilpz", 133, 145, 171, 195, 223, "ilp|", 136, 149, 184, 208, 223, "ilos~", 139, 155, 201, 223, "ikmqy", 128, 142, 162, 223, "iknr", 130, 146, 172, 210, 223, "ikns", 132, 150, 184, 209, 223, "ikot", 135, 157, 202, 223, "ikou", 139, 164, 223, "ikot{", 143, 174, 223, "ikpv", 128, 148, 186, 223, "ikorx", 133, 153, 168, 206, 223, "ilqx", 132, 161, 177, 223, "ilrz", 135, 170, 186, 223, "ikns|", 139, 183, 201, 223, "ilot}", 141, 200, 222, 223, "ilnt|", 132, 150, 223, "ilou~", 135, 155, 223, "ilov", 127, 136, 156, 223, "ilow", 129, 138, 161, 223, "ilox", 131, 141, 168, 223, "ilpy", 129, 144, 177, 223, "ilp{", 136, 149, 190, 223, "ilq|", 132, 154, 208, 223, "ilq{", 129, 146, 163, 223, "ilps", 128, 136, 156, 175, 223, "ilos", 130, 137, 157, 185, 214, 223, "ilpt", 132, 140, 162, 203, 223, "ilpu", 134, 142, 168, 223, "ilpv", 137, 146, 177, 223, "ilqw", 139, 149, 189, 223, "ilqx", 142, 154, 185, 223, "ilqy", 143, 161, 177, 223, "ilpu{", 150, 171, 188, 223, "ilpu|", 151, 183, 202, 223, "ilpu~", 158, 200, 223, "ilpu", 128, 161, 223, "ilpv", 130, 160, 223, "ilqx", 132, 162, 223, "ilqx", 135, 170, 223, "ilqy", 138, 169, 223, "ilq{", 142, 159, 223, "ilpv~", 147, 164, 223, "ilqx", 128, 153, 169, 223, "ilqw", 129, 160, 174, 223, "imry", 131, 170, 186, 223, "imry", 134, 182, 201, 223, "imsz", 136, 199, 222, 223, "jnt{", 140, 223, "jnt|", 144, 222, 223, "jnu~", 148, 223, "jov", 127, 154, 223, "jov", 129, 162, 223, "jns|", 134, 171, 210, 223, "jnrz", 134, 184, 214, 223, "jns{", 137, 202, 223, "jmr{", 140, 212, 223, "jms}", 144, 216, 223, "jms~", 149, 223, "imt", 128, 155, 223, "imu", 130, 162, 223, "imu", 132, 171, 223, "imsy", 135, 179, 210, 223, "imsy", 138, 183, 216, 223, "imrz", 141, 189, 223, "imr{", 145, 198, 223, "jow~", 150, 209, 223, "jou", 127, 156, 223, "jou", 128, 164, 223, "jou", 130, 173, 223, "jou", 133, 186, 223, "jou", 136, 204, 223, "jov", 139, 223, "jov", 143, 223, "jow", 147, 223, "ilrz", 154, 223, "ilrz", 160, 182, 223, "ilr{", 159, 177, 223, "jnv", 127, 183, 207, 223, "imt", 127, 165, 202, 223, "imt", 129, 168, 223, "imt", 129, 156, 223, "imt", 130, 158, 223, "jnv", 134, 169, 223, "jnv", 134, 151, 223, "jox", 138, 157, 223, "jox", 139, 157, 220, 223, "jox", 140, 159, 223, "jox", 140, 165, 223, "ilq|", 149, 176, 223, "ilr~", 154, 189, 223, "ilr~", 156, 206, 223, "ims", 128, 162, 223, "imt", 130, 163, 223, "imt", 130, 162, 223, "imu", 132, 166, 223, "imv", 134, 173, 223, "imv", 135, 181, 223, "ims{", 146, 205, 223, "imrz", 143, 204, 223, "imr{", 146, 199, 223, "imr|", 149, 204, 223, "imr~", 154, 214, 223, "ims", 128, 161, 223, "ims", 129, 165, 223, "ilr", 131, 168, 223, "ilqy", 135, 176, 223, "ilr|", 139, 184, 223, "ilqx", 141, 187, 223, "ilqx", 145, 196, 223, "ilrz", 150, 208, 223, "ilrz", 156, 223, "ilr{", 163, 223, "ilr|", 172, 223, "ilpw", 129, 186, 223, "ilqy", 132, 204, 223, "hkov", 130, 172, 223, "ilpx", 133, 173, 223, "ilqy", 135, 175, 223, "ilqz", 138, 179, 223, "ilq{", 142, 186, 223, "ilr|", 146, 195, 223, "ilr~", 150, 205, 223, "ilqy", 131, 157, 223, "ilqx", 131, 164, 223, "ilpw", 132, 174, 223, "ilpx", 135, 187, 223, "jnu", 128, 141, 205, 223, "jnu~", 142, 223, "jnt}", 145, 223, "jns}", 150, 223, "kpx", 130, 156, 223, "kou", 129, 164, 223, "kot", 129, 173, 223, "kou", 132, 186, 223, "knt", 131, 147, 204, 223, "lqx", 139, 223, "lpw", 137, 154, 223, "lpw", 138, 156, 223, "lpx", 140, 159, 223, "lpy", 142, 166, 223, "mq{", 148, 176, 223, "mq{", 143, 187, 223, "lpx", 129, 162, 206, 223, "lq{", 133, 171, 223, "lqz", 133, 177, 223, "lr|", 136, 181, 223, "lr{", 137, 181, 223, "lry", 140, 186, 223, "ls{", 144, 195, 223, "lt}", 149, 208, 223, "lt|", 148, 168, 223, "kt|", 148, 168, 223, "ku}", 151, 176, 223, "ku}", 154, 187, 223, "ku~", 157, 205, 223, "ku}", 142, 191, 223, "ku}", 136, 182, 223, "ku~", 138, 194, 223, "kv", 128, 140, 189, 223, "js", 129, 142, 191, 223, "kx", 132, 147, 202, 223, "kw", 135, 151, 211, 223, "jq", 128, 140, 158, 223, "jq", 128, 142, 165, 223, "jq", 128, 145, 174, 223, "jq", 129, 150, 187, 223, "jq", 131, 156, 205, 223, "jq", 133, 164, 223, "jr", 135, 173, 223, "jr", 138, 186, 223, "jr", 140, 204, 223, "inz", 146, 223, "jq", 146, 223, "jr", 152, 223, "imx", 161, 223, "imw", 168, 223, "jny", 178, 223, "jo{", 192, 223, "jo{", 210, 223, "jny", 171, 223, "jo{", 178, 223, "jo{", 156, 223, "imy", 150, 223, "ilq~", 161, 223, "ilr", 128, 164, 223, "ilr", 129, 167, 223, "ilr", 131, 172, 223, "ims", 133, 180, 223, "imt", 135, 189, 223, "imt", 138, 203, 223, "imu", 141, 223, "imv", 145, 223, "imu", 149, 223, "ims|", 155, 223, "ims|", 161, 223, "ims|", 169, 223, "ilr}", 179, 223, "ilr~", 192, 223, "hjnu", 129, 212, 223, "hjnu", 130, 223, "ilr", 130, 223, "ikpx", 135, 223, "ilr|", 139, 223, "ilr|", 142, 223, "ilr|", 146, 223, "ilqz", 150, 223, "hjmt", 128, 157, 223, "hjmt", 128, 165, 223, "hjms~", 173, 223, "hjms", 127, 162, 193, 223, "hjms", 128, 152, 207, 223, "hjms", 128, 151, 223, "hjmr", 127, 149, 223, "ikov", 135, 163, 223, "hjmr~", 148, 223, "hjmqz", 143, 176, 223, "hjmqz", 146, 184, 223, "hjmqz", 144, 193, 223, "hjmr|", 150, 213, 223, "hjmr|", 149, 186, 223, "hjmr|", 151, 190, 223, "hjmr{", 147, 195, 223, "hjmqw", 133, 172, 223, "hjmqw", 132, 172, 223, "hjmqw", 133, 181, 223, "hjmqx", 136, 192, 223, "hjmqy", 138, 189, 223, "hjmrz", 140, 193, 223, "hjmr{", 142, 198, 223, "hjmr|", 142, 196, 223, "hjmrx", 129, 156, 223, "hjmqv", 129, 152, 193, 223, "hjmqv", 131, 155, 195, 223, "hjlpw", 133, 159, 203, 223, "hjmqx", 136, 165, 218, 223, "hjmqy", 140, 173, 223, "hjlpv}", 144, 182, 223, "hjmqw~", 149, 195, 223, "hjmqw", 127, 155, 213, 223, "hjmqw", 128, 161, 223, "hjlot~", 135, 172, 223, "hjlot|", 134, 182, 214, 223, "hjmqw", 131, 141, 203, 223, "hjmpu}", 139, 186, 223, "hjlpv~", 143, 198, 223, "iknrx", 129, 148, 216, 223, "iknry", 130, 154, 223, "iknry", 131, 155, 172, 223, "iknrz", 133, 158, 176, 223, "iknry", 132, 157, 185, 212, 223, "hjmqv", 127, 139, 168, 203, 223, "hjmpu~", 141, 173, 223, "hjlpu~", 138, 154, 192, 223, "iknrw", 129, 144, 165, 211, 223, "iknrx", 130, 142, 159, 214, 223, "iknrx", 130, 143, 165, 223, "iknry", 132, 147, 174, 223, "iknsz", 133, 150, 187, 223, "jmqv~", 140, 158, 205, 223, "jmpu}", 134, 151, 171, 223, "jmqv~", 134, 150, 175, 223, "jmqw", 128, 137, 154, 187, 223, "jmqw", 128, 138, 158, 205, 223, "knry", 131, 141, 166, 223, "knry", 132, 145, 175, 223, "kns{", 135, 149, 187, 223, "knrx", 128, 140, 156, 206, 223, "knrx", 129, 142, 162, 223, "jmpu}", 133, 147, 172, 212, 223, "jmqw", 128, 137, 153, 184, 209, 223, "jmqw", 128, 138, 157, 202, 223, "jmry", 131, 141, 165, 223, "jnsz", 133, 145, 174, 223, "jnsz", 133, 149, 187, 223, "jot|", 138, 155, 205, 223, "jou}", 134, 150, 165, 223, "jpv~", 134, 149, 172, 209, 223, "jpw", 128, 137, 153, 184, 209, 223, "jqx", 129, 138, 158, 202, 223, "jqy", 131, 141, 165, 223, "jrz", 133, 145, 174, 223, "jrz", 133, 149, 187, 223, "jqv~", 139, 155, 205, 223, "ilt}", 134, 150, 165, 223, "imv", 130, 146, 171, 195, 223, "imv", 129, 138, 155, 184, 207, 223, "imw", 130, 139, 158, 202, 223, "imy", 135, 146, 167, 223, "imz", 136, 147, 175, 223, "in{", 138, 150, 188, 223, "in}", 141, 156, 206, 223, "jo", 127, 145, 163, 223, "jo", 129, 149, 172, 212, 223, "jp", 131, 153, 185, 211, 223, "jp", 134, 160, 202, 223, "jp", 136, 149, 177, 223, "jp", 137, 149, 180, 223, "jpx", 143, 156, 193, 223, "jnt", 132, 154, 209, 223, "ils", 137, 162, 223, "jmt", 138, 165, 185, 223, "jmu", 140, 162, 186, 217, 223, "jnv", 135, 159, 202, 223, "jnw", 137, 167, 223, "imw", 136, 156, 186, 223, "imw", 134, 154, 191, 223, "iny", 138, 160, 209, 223, "inz", 140, 167, 223, "jo|", 145, 177, 223, "jo}", 145, 189, 223, "joy", 133, 171, 211, 223, "jov", 131, 156, 223, "jou", 133, 159, 223, "jou", 135, 162, 223, "jou", 138, 167, 223, "jnt", 141, 174, 223, "jnu", 145, 183, 223, "jnu", 142, 166, 215, 223, "imu", 129, 158, 215, 223, "imv", 131, 165, 223, "imv", 129, 175, 223, "imv", 128, 187, 223, "imt", 127, 205, 223, "imr|", 142, 223, "imr}", 140, 223, "imr~", 140, 223, "imr", 128, 143, 223, "jns", 130, 146, 223, "jot", 132, 149, 223, "jou", 134, 153, 223, "jou", 136, 159, 223, "jov", 139, 166, 223, "jow", 142, 176, 223, "ilry", 147, 189, 223, "ilrz", 151, 207, 223, "ilrz", 154, 209, 223, "imt}", 160, 206, 223, "imt~", 164, 213, 223, "imu", 128, 170, 223, "imv", 129, 178, 223, "imv", 131, 188, 223, "imt", 130, 163, 223, "imrz", 137, 223, "imq{", 141, 223, "imr|", 145, 223, "imr~", 150, 223, "imr", 127, 156, 223, "imr", 129, 163, 223, "ilr", 131, 173, 223, "ilr", 129, 154, 187, 223, "ilr{", 139, 204, 223, "ilry", 141, 223, "ilry", 145, 223, "ilry", 149, 223, "ilry", 155, 223, "ilrz", 161, 223, "ilr|", 171, 223, "ilpy", 133, 186, 223, "ilq|", 149, 206, 223, "ilqz", 132, 223, "ilqz", 133, 223, "ilqz", 135, 223, "ilq{", 137, 223, "ilq{", 140, 217, 223, "ilr}", 145, 223, "ilq|", 149, 223, "ilqy", 135, 157, 223, "ilqx", 133, 163, 223, "ilqx", 134, 173, 223, "ilpx", 136, 185, 223, "hkow", 138, 203, 223, "hjmrz", 142, 223, "ilq{", 146, 223, "ilq{", 151, 223, "hjmr}", 157, 223, "hjms", 127, 165, 223, "hjmr}", 138, 176, 223, "hjmr|", 137, 188, 223, "hjnt", 130, 145, 207, 223, "hjnt", 128, 143, 223, "hjnt", 127, 145, 223, "hjns|", 148, 223, "hjmqy", 141, 161, 223, "hjmqz", 143, 167, 223, "hilqz", 140, 174, 223, "hikot~", 152, 188, 223, "hjmr{", 141, 192, 223, "hikns}", 145, 196, 223, "hiknt", 127, 150, 208, 223, "hiknt}", 139, 180, 223, "hjmry", 137, 171, 223, "hjmqx", 135, 165, 223, "hjlpw", 130, 148, 191, 223, "hjlpx", 131, 152, 202, 223, "hjlpx", 130, 156, 219, 223, "hjlpx", 131, 163, 223, "hikns|", 136, 173, 223, "hikns}", 137, 174, 210, 223, "hikns~", 140, 178, 216, 223, "hikmqx", 131, 146, 189, 223, "hikmqw", 131, 147, 192, 223, "hikns{", 136, 153, 205, 223, "hiknsz", 137, 158, 222, 223, "hiknry", 140, 165, 223, "hiknry", 138, 157, 183, 223, "hijlot}", 149, 188, 223, "ijlosz", 134, 157, 206, 223, "iknry", 132, 163, 223, "iknry", 133, 172, 223, "iknqv", 127, 140, 186, 223, "ikmqv", 128, 141, 189, 223, "ikmqv", 128, 143, 191, 223, "hjlosx", 131, 147, 200, 223, "hjlosx", 130, 150, 208, 223, "hjlnrw", 129, 143, 163, 223, "hjlnrw", 127, 142, 166, 223, "hjlot{", 134, 150, 176, 223, "hjlnrw}", 137, 154, 189, 223, "hjlnrx", 127, 140, 159, 206, 223, "hilosy", 129, 143, 166, 223, "hilosz", 131, 147, 176, 223, "hilorx~", 134, 152, 188, 223, "hilnqu~", 136, 158, 206, 223, "hikmpt|", 131, 141, 166, 223, "hiknrw", 129, 144, 175, 223, "hijnqty", 132, 148, 188, 223, "hijnqty", 131, 140, 155, 206, 223, "hijlosw~", 140, 162, 223, "hijlosv|", 136, 146, 171, 193, 223, "hijlptw}", 137, 149, 184, 206, 223, "hijlptx", 127, 140, 155, 201, 223, "hijlquy", 129, 143, 162, 223, "hijkmrw{", 131, 147, 171, 194, 223, "hikmrw|", 133, 152, 184, 207, 223, "hijkmsx~", 136, 158, 202, 223, "hijlntz", 128, 140, 165, 223, "hijlnu{", 130, 144, 175, 223, "hijlnuy", 127, 133, 148, 188, 223, "hijlnsx", 127, 135, 154, 206, 223, "hijlmow{", 130, 139, 162, 210, 223, "hijlnqz", 131, 143, 171, 192, 223, "hijkmnq{", 133, 147, 159, 184, 206, 223, "hijlnq|", 129, 137, 153, 164, 202, 223, "hijlnps~", 132, 140, 160, 172, 223, "hijkmor|", 130, 143, 170, 183, 223, "hijkmps", 128, 134, 148, 182, 198, 223, "hijkmpsz", 135, 154, 199, 218, 223, "hijlnqu", 132, 139, 161, 179, 223, "hijlnqsv", 134, 143, 170, 187, 223, "hijlnqsw", 136, 147, 159, 183, 203, 223, "hijlnqsx", 138, 153, 164, 201, 223, "hijlmoruy", 137, 160, 172, 223, "hijlnpsvz", 136, 169, 182, 223, "hijlnptw|", 142, 182, 198, 223, "hjlnqtx~", 147, 199, 218, 223, "hijlnpruy", 127, 142, 194, 223, "hikmorvz", 129, 137, 181, 223, "hikmoqtx|", 132, 154, 219, 223, "hikmpruy}", 135, 156, 223, "hikmoquy", 127, 137, 143, 176, 223, "iklnqsv{", 129, 135, 143, 162, 211, 223, "ikmortw|", 132, 146, 153, 197, 223, "ikmortx~", 135, 145, 154, 164, 218, 223, "ikmorty", 128, 138, 145, 160, 170, 223, "ikmoruz", 130, 142, 148, 169, 180, 223, "ikmorv|", 133, 146, 153, 181, 194, 223, "hjlnqtw{", 127, 135, 152, 160, 199, 215, 223, "hjloruy", 127, 139, 159, 168, 223, "ikmorvz", 129, 136, 144, 169, 179, 223, "iknpsw|", 132, 147, 159, 181, 192, 223, "ikmpsx}", 132, 137, 153, 165, 198, 212, 223, "ikmpruy", 127, 134, 139, 160, 172, 223, "ilorvz", 129, 134, 142, 149, 170, 184, 223, "ikmpsw|", 132, 140, 147, 155, 182, 198, 223, "ikmpsx~", 134, 138, 153, 161, 199, 218, 223, "ikmpty", 127, 138, 143, 160, 169, 223, "ikmpsvz", 129, 137, 142, 147, 169, 180, 223, "iknqtw|", 132, 146, 152, 181, 194, 223, "jmptx~", 135, 152, 158, 198, 213, 223, "jloruy", 127, 138, 147, 159, 166, 223, "jlosvz", 129, 137, 143, 163, 171, 180, 223, "jlorw|", 132, 147, 155, 180, 190, 201, 223, "jlorvz~", 135, 152, 160, 198, 210, 223, "jlorvz", 127, 135, 141, 160, 169, 223, "kmpsw{", 129, 134, 142, 149, 169, 180, 223, "kmqtx|", 132, 142, 149, 181, 194, 223, "kmqtx~", 134, 139, 153, 161, 199, 215, 223, "kmquz", 128, 138, 144, 160, 169, 223, "losv{", 130, 142, 148, 169, 180, 223, "lnrw}", 132, 146, 152, 181, 193, 223, "lotx~", 135, 152, 159, 198, 213, 223, "loty", 128, 138, 148, 160, 168, 223, "mpuz", 130, 142, 150, 168, 177, 223, "mpu|", 133, 147, 156, 181, 192, 223, "mqw}", 136, 153, 162, 198, 211, 223, "nqv{", 128, 139, 160, 170, 223, "nrw}", 130, 143, 169, 180, 223, "osy", 127, 132, 148, 181, 194, 223, "osy", 127, 135, 153, 168, 199, 215, 223, "otz", 129, 138, 146, 161, 177, 223, "pu|", 132, 142, 149, 170, 186, 223, "qv}", 134, 147, 155, 183, 201, 223, "qw", 127, 137, 152, 160, 200, 223, "ry", 129, 140, 160, 169, 223, "ry", 127, 137, 147, 169, 180, 223, "s{", 134, 148, 181, 193, 223, "t}", 137, 154, 198, 213, 223, "u~", 132, 142, 162, 207, 223, "v", 128, 134, 145, 171, 191, 223, "w", 129, 135, 149, 183, 204, 223, "x", 131, 137, 155, 201, 223, "y", 132, 139, 162, 223, "{", 135, 143, 171, 196, 223, "|", 137, 147, 158, 185, 210, 223, "~", 140, 153, 164, 202, 223, 128, 143, 160, 172, 223, 130, 147, 170, 184, 223, 133, 152, 182, 198, 223, 135, 158, 199, 218, 223, 139, 165, 223, 143, 175, 223, 148, 188, 223, 154, 206, 223, 161, 185, 223, 171, 194, 223, 183, 206, 223, 201, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223, 223

	.local	__ZN5rallyL13TriOvalPointsE
__ZN5rallyL13TriOvalPointsE:
	dw	0                               ; 0x0
	dw	0                               ; 0x0
	dw	4096                            ; 0x1000
	dw	0                               ; 0x0
	dw	64                              ; 0x40
	dw	65535                           ; 0xffff
	dw	4094                            ; 0xffe
	dw	65411                           ; 0xff83
	dw	128                             ; 0x80
	dw	65532                           ; 0xfffc
	dw	4088                            ; 0xff8
	dw	65281                           ; 0xff01
	dw	192                             ; 0xc0
	dw	65527                           ; 0xfff7
	dw	4078                            ; 0xfee
	dw	65154                           ; 0xfe82
	dw	255                             ; 0xff
	dw	65520                           ; 0xfff0
	dw	4066                            ; 0xfe2
	dw	65042                           ; 0xfe12
	dw	319                             ; 0x13f
	dw	65512                           ; 0xffe8
	dw	4054                            ; 0xfd6
	dw	64948                           ; 0xfdb4
	dw	382                             ; 0x17e
	dw	65502                           ; 0xffde
	dw	4042                            ; 0xfca
	dw	64874                           ; 0xfd6a
	dw	445                             ; 0x1bd
	dw	65491                           ; 0xffd3
	dw	4033                            ; 0xfc1
	dw	64819                           ; 0xfd33
	dw	508                             ; 0x1fc
	dw	65480                           ; 0xffc8
	dw	4024                            ; 0xfb8
	dw	64771                           ; 0xfd03
	dw	571                             ; 0x23b
	dw	65467                           ; 0xffbb
	dw	4005                            ; 0xfa5
	dw	64679                           ; 0xfca7
	dw	633                             ; 0x279
	dw	65453                           ; 0xffad
	dw	3980                            ; 0xf8c
	dw	64567                           ; 0xfc37
	dw	695                             ; 0x2b7
	dw	65437                           ; 0xff9d
	dw	3944                            ; 0xf68
	dw	64429                           ; 0xfbad
	dw	756                             ; 0x2f4
	dw	65418                           ; 0xff8a
	dw	3893                            ; 0xf35
	dw	64261                           ; 0xfb05
	dw	817                             ; 0x331
	dw	65397                           ; 0xff75
	dw	3819                            ; 0xeeb
	dw	64056                           ; 0xfa38
	dw	876                             ; 0x36c
	dw	65371                           ; 0xff5b
	dw	3713                            ; 0xe81
	dw	63806                           ; 0xf93e
	dw	932                             ; 0x3a4
	dw	65342                           ; 0xff3e
	dw	3558                            ; 0xde6
	dw	63506                           ; 0xf812
	dw	986                             ; 0x3da
	dw	65308                           ; 0xff1c
	dw	3332                            ; 0xd04
	dw	63154                           ; 0xf6b2
	dw	1036                            ; 0x40c
	dw	65268                           ; 0xfef4
	dw	3011                            ; 0xbc3
	dw	62759                           ; 0xf527
	dw	1080                            ; 0x438
	dw	65221                           ; 0xfec5
	dw	2576                            ; 0xa10
	dw	62351                           ; 0xf38f
	dw	1116                            ; 0x45c
	dw	65168                           ; 0xfe90
	dw	2036                            ; 0x7f4
	dw	61982                           ; 0xf21e
	dw	1143                            ; 0x477
	dw	65110                           ; 0xfe56
	dw	1437                            ; 0x59d
	dw	61700                           ; 0xf104
	dw	1161                            ; 0x489
	dw	65049                           ; 0xfe19
	dw	848                             ; 0x350
	dw	61529                           ; 0xf059
	dw	1170                            ; 0x492
	dw	64986                           ; 0xfdda
	dw	319                             ; 0x13f
	dw	61452                           ; 0xf00c
	dw	1171                            ; 0x493
	dw	64922                           ; 0xfd9a
	dw	65401                           ; 0xff79
	dw	61442                           ; 0xf002
	dw	1165                            ; 0x48d
	dw	64858                           ; 0xfd5a
	dw	64902                           ; 0xfd86
	dw	61489                           ; 0xf031
	dw	1151                            ; 0x47f
	dw	64796                           ; 0xfd1c
	dw	64323                           ; 0xfb43
	dw	61624                           ; 0xf0b8
	dw	1127                            ; 0x467
	dw	64736                           ; 0xfce0
	dw	63699                           ; 0xf8d3
	dw	61875                           ; 0xf1b3
	dw	1094                            ; 0x446
	dw	64682                           ; 0xfcaa
	dw	63095                           ; 0xf677
	dw	62247                           ; 0xf327
	dw	1051                            ; 0x41b
	dw	64634                           ; 0xfc7a
	dw	62576                           ; 0xf470
	dw	62705                           ; 0xf4f1
	dw	1002                            ; 0x3ea
	dw	64593                           ; 0xfc51
	dw	62182                           ; 0xf2e6
	dw	63185                           ; 0xf6d1
	dw	947                             ; 0x3b3
	dw	64560                           ; 0xfc30
	dw	61905                           ; 0xf1d1
	dw	63640                           ; 0xf898
	dw	889                             ; 0x379
	dw	64534                           ; 0xfc16
	dw	61722                           ; 0xf11a
	dw	64043                           ; 0xfa2b
	dw	828                             ; 0x33c
	dw	64513                           ; 0xfc01
	dw	61604                           ; 0xf0a4
	dw	64390                           ; 0xfb86
	dw	766                             ; 0x2fe
	dw	64498                           ; 0xfbf2
	dw	61529                           ; 0xf059
	dw	64685                           ; 0xfcad
	dw	703                             ; 0x2bf
	dw	64487                           ; 0xfbe7
	dw	61484                           ; 0xf02c
	dw	64936                           ; 0xfda8
	dw	640                             ; 0x280
	dw	64479                           ; 0xfbdf
	dw	61458                           ; 0xf012
	dw	65150                           ; 0xfe7e
	dw	576                             ; 0x240
	dw	64474                           ; 0xfbda
	dw	61445                           ; 0xf005
	dw	65336                           ; 0xff38
	dw	512                             ; 0x200
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	65498                           ; 0xffda
	dw	448                             ; 0x1c0
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	384                             ; 0x180
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	320                             ; 0x140
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	256                             ; 0x100
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	192                             ; 0xc0
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	128                             ; 0x80
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	64                              ; 0x40
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	0                               ; 0x0
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	65472                           ; 0xffc0
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	65408                           ; 0xff80
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	65344                           ; 0xff40
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	65280                           ; 0xff00
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	65216                           ; 0xfec0
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	65152                           ; 0xfe80
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	65088                           ; 0xfe40
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	0                               ; 0x0
	dw	65024                           ; 0xfe00
	dw	64473                           ; 0xfbd9
	dw	61440                           ; 0xf000
	dw	38                              ; 0x26
	dw	64960                           ; 0xfdc0
	dw	64474                           ; 0xfbda
	dw	61445                           ; 0xf005
	dw	200                             ; 0xc8
	dw	64896                           ; 0xfd80
	dw	64479                           ; 0xfbdf
	dw	61458                           ; 0xf012
	dw	386                             ; 0x182
	dw	64833                           ; 0xfd41
	dw	64487                           ; 0xfbe7
	dw	61484                           ; 0xf02c
	dw	600                             ; 0x258
	dw	64770                           ; 0xfd02
	dw	64498                           ; 0xfbf2
	dw	61529                           ; 0xf059
	dw	851                             ; 0x353
	dw	64708                           ; 0xfcc4
	dw	64513                           ; 0xfc01
	dw	61604                           ; 0xf0a4
	dw	1146                            ; 0x47a
	dw	64647                           ; 0xfc87
	dw	64534                           ; 0xfc16
	dw	61722                           ; 0xf11a
	dw	1493                            ; 0x5d5
	dw	64589                           ; 0xfc4d
	dw	64560                           ; 0xfc30
	dw	61905                           ; 0xf1d1
	dw	1896                            ; 0x768
	dw	64534                           ; 0xfc16
	dw	64593                           ; 0xfc51
	dw	62182                           ; 0xf2e6
	dw	2351                            ; 0x92f
	dw	64485                           ; 0xfbe5
	dw	64634                           ; 0xfc7a
	dw	62576                           ; 0xf470
	dw	2831                            ; 0xb0f
	dw	64442                           ; 0xfbba
	dw	64682                           ; 0xfcaa
	dw	63095                           ; 0xf677
	dw	3289                            ; 0xcd9
	dw	64409                           ; 0xfb99
	dw	64736                           ; 0xfce0
	dw	63699                           ; 0xf8d3
	dw	3661                            ; 0xe4d
	dw	64385                           ; 0xfb81
	dw	64796                           ; 0xfd1c
	dw	64323                           ; 0xfb43
	dw	3912                            ; 0xf48
	dw	64371                           ; 0xfb73
	dw	64858                           ; 0xfd5a
	dw	64902                           ; 0xfd86
	dw	4047                            ; 0xfcf
	dw	64365                           ; 0xfb6d
	dw	64922                           ; 0xfd9a
	dw	65401                           ; 0xff79
	dw	4094                            ; 0xffe
	dw	64366                           ; 0xfb6e
	dw	64986                           ; 0xfdda
	dw	319                             ; 0x13f
	dw	4084                            ; 0xff4
	dw	64375                           ; 0xfb77
	dw	65049                           ; 0xfe19
	dw	848                             ; 0x350
	dw	4007                            ; 0xfa7
	dw	64393                           ; 0xfb89
	dw	65110                           ; 0xfe56
	dw	1437                            ; 0x59d
	dw	3836                            ; 0xefc
	dw	64420                           ; 0xfba4
	dw	65168                           ; 0xfe90
	dw	2036                            ; 0x7f4
	dw	3554                            ; 0xde2
	dw	64456                           ; 0xfbc8
	dw	65221                           ; 0xfec5
	dw	2576                            ; 0xa10
	dw	3185                            ; 0xc71
	dw	64500                           ; 0xfbf4
	dw	65268                           ; 0xfef4
	dw	3011                            ; 0xbc3
	dw	2777                            ; 0xad9
	dw	64550                           ; 0xfc26
	dw	65308                           ; 0xff1c
	dw	3332                            ; 0xd04
	dw	2382                            ; 0x94e
	dw	64604                           ; 0xfc5c
	dw	65342                           ; 0xff3e
	dw	3558                            ; 0xde6
	dw	2030                            ; 0x7ee
	dw	64660                           ; 0xfc94
	dw	65371                           ; 0xff5b
	dw	3713                            ; 0xe81
	dw	1730                            ; 0x6c2
	dw	64719                           ; 0xfccf
	dw	65397                           ; 0xff75
	dw	3819                            ; 0xeeb
	dw	1480                            ; 0x5c8
	dw	64780                           ; 0xfd0c
	dw	65418                           ; 0xff8a
	dw	3893                            ; 0xf35
	dw	1275                            ; 0x4fb
	dw	64841                           ; 0xfd49
	dw	65437                           ; 0xff9d
	dw	3944                            ; 0xf68
	dw	1107                            ; 0x453
	dw	64903                           ; 0xfd87
	dw	65453                           ; 0xffad
	dw	3980                            ; 0xf8c
	dw	969                             ; 0x3c9
	dw	64965                           ; 0xfdc5
	dw	65467                           ; 0xffbb
	dw	4005                            ; 0xfa5
	dw	857                             ; 0x359
	dw	65028                           ; 0xfe04
	dw	65480                           ; 0xffc8
	dw	4024                            ; 0xfb8
	dw	765                             ; 0x2fd
	dw	65091                           ; 0xfe43
	dw	65491                           ; 0xffd3
	dw	4033                            ; 0xfc1
	dw	717                             ; 0x2cd
	dw	65154                           ; 0xfe82
	dw	65502                           ; 0xffde
	dw	4042                            ; 0xfca
	dw	662                             ; 0x296
	dw	65217                           ; 0xfec1
	dw	65512                           ; 0xffe8
	dw	4054                            ; 0xfd6
	dw	588                             ; 0x24c
	dw	65281                           ; 0xff01
	dw	65520                           ; 0xfff0
	dw	4066                            ; 0xfe2
	dw	494                             ; 0x1ee
	dw	65344                           ; 0xff40
	dw	65527                           ; 0xfff7
	dw	4078                            ; 0xfee
	dw	382                             ; 0x17e
	dw	65408                           ; 0xff80
	dw	65532                           ; 0xfffc
	dw	4088                            ; 0xff8
	dw	255                             ; 0xff
	dw	65472                           ; 0xffc0
	dw	65535                           ; 0xffff
	dw	4094                            ; 0xffe
	dw	125                             ; 0x7d

	.local	_.str.13
_.str.13:
	db	"Tri-oval", 0

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

	.local	_.str.14
_.str.14:
	db	"Fuji reference", 0

	.local	_.str.15
_.str.15:
	db	"rb", 0

	.local	_.str.16
_.str.16:
	db	"ARALLY01", 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_19carUploadE
__ZN12_GLOBAL__N_19carUploadE:
	.skip	7854

	.section	.rodata,"a",@progbits
	.local	___const._ZN12_GLOBAL__N_18loadCarsEv.mirrorCommands
___const._ZN12_GLOBAL__N_18loadCarsEv.mirrorCommands:
	db	23, 0, 248, 1, 0, 1, 0, 23, 0, 160, 240, 249, " ", 0, 23, 0, 160, 240, 249, " ", 11, 192, 255, 255, 0, 0, "e", 0, 0, 0, 1, 0, 0, 0

	.local	__ZN5rallyL9CarPixelsE
__ZN5rallyL9CarPixelsE:
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 207, 207, 194, 194, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 239, 239, 194, 194, 248, 248, 248, 248, 194, 194, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 194, 194, 248, 248, 248, 248, 248, 248, 194, 194, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 234, 234, 234, 234, 0, 194, 194, 192, 248, 248, 248, 248, 248, 248, 192, 194, 194, 0, 234, 234, 234, 234, 192, 192, 192, 192, 192, 234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 234, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 194, 194, 192, 248, 208, 208, 208, 208, 248, 192, 194, 194, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 234, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 0, 192, 192, 192, 192, 199, 199, 199, 199, 199, 194, 194, 194, 192, 213, 213, 213, 213, 213, 213, 192, 194, 194, 194, 199, 199, 199, 199, 199, 192, 192, 192, 192, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 192, 192, 192, 192, 192, 192, 199, 199, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 199, 199, 192, 192, 192, 192, 192, 192, 192, 192, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 192, 192, 192, 192, 192, 192, 199, 199, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 199, 199, 192, 192, 192, 192, 192, 192, 192, 192, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 199, 199, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 199, 199, 192, 192, 192, 192, 192, 192, 192, 192, 234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 195, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 195, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 234, 234, 194, 194, 194, 194, 234, 234, 194, 194, 194, 195, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 234, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 234, 234, 194, 194, 194, 194, 234, 234, 194, 194, 194, 195, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 194, 194, 194, 194, 194, 195, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 194, 194, 194, 194, 194, 195, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 194, 194, 194, 194, 194, 213, 213, 213, 213, 194, 194, 194, 194, 194, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 213, 213, 213, 213
	.zero	670
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 239, 194, 194, 207, 207, 194, 194, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 239, 194, 194, 194, 207, 248, 248, 248, 248, 248, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 248, 248, 248, 248, 248, 194, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 0, 234, 234, 0, 0, 194, 194, 194, 194, 248, 248, 248, 248, 248, 248, 248, 194, 234, 234, 234, 234, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 234, 234, 234, 0, 0, 194, 194, 192, 192, 248, 208, 208, 208, 208, 208, 192, 194, 194, 194, 199, 199, 199, 199, 192, 192, 192, 192, 0, 0, 0, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 195, 192, 192, 195, 199, 199, 199, 199, 199, 194, 194, 194, 192, 192, 213, 213, 213, 213, 213, 213, 192, 194, 194, 199, 199, 199, 199, 194, 192, 192, 239, 239, 239, 239, 239, 239, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 195, 192, 192, 195, 199, 199, 199, 199, 199, 194, 194, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 195, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 195, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 195, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 195, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 195, 192, 192, 192, 192, 192, 192, 192, 199, 194, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 199, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 195, 192, 192, 192, 192, 192, 192, 192, 199, 199, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 199, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 199, 199, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 234, 234, 194, 194, 194, 194, 234, 234, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 234, 234, 194, 213, 213, 213, 234, 234, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 194, 194, 194, 194, 194, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 194, 194, 194, 194, 194, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 194, 194, 194, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 213, 213, 213, 213
	.zero	667
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 192, 192, 192, 192, 192, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 194, 194, 207, 207, 194, 194, 194, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 194, 194, 194, 207, 207, 207, 194, 194, 248, 248, 248, 248, 239, 239, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 207, 207, 248, 248, 248, 248, 248, 248, 234, 234, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 239, 0, 0, 0, 194, 194, 194, 194, 194, 194, 194, 248, 248, 248, 248, 248, 248, 194, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 234, 192, 192, 192, 192, 192, 192, 234, 234, 0, 0, 0, 194, 194, 194, 192, 192, 192, 248, 208, 208, 208, 208, 208, 194, 194, 199, 199, 199, 199, 199, 192, 192, 0, 0, 0, 0, 0, 239, 239, 239, 239, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 234, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 194, 194, 194, 194, 192, 192, 248, 213, 213, 213, 213, 213, 213, 194, 194, 199, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 192, 192, 192, 192, 192, 195, 195, 199, 199, 199, 199, 199, 194, 194, 194, 192, 192, 192, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 195, 195, 199, 199, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 195, 195, 195, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 0, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 195, 195, 195, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 195, 195, 195, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 199, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 195, 195, 194, 194, 192, 192, 192, 192, 194, 194, 194, 194, 213, 213, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 199, 199, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 195, 195, 192, 192, 192, 192, 192, 192, 194, 194, 194, 194, 213, 213, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 195, 192, 192, 192, 192, 192, 192, 199, 194, 194, 194, 213, 213, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 213, 213, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 234, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 234, 234, 194, 194, 194, 194, 234, 234, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 234, 234, 213, 213, 213, 213, 194, 194, 194, 194, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 195, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 194, 194, 194, 194, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 194, 194, 194, 194, 0, 0, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 213, 213, 213, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192
	.zero	615
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 192, 192, 192, 192, 192, 192, 192, 192, 239, 239, 239, 194, 194, 194, 207, 207, 207, 194, 194, 194, 194, 239, 248, 248, 248, 248, 248, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 192, 192, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 194, 194, 194, 194, 207, 207, 207, 194, 194, 194, 248, 248, 248, 248, 248, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 192, 192, 192, 192, 192, 192, 192, 192, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 207, 194, 248, 248, 248, 248, 248, 208, 208, 192, 194, 199, 199, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 234, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 194, 194, 194, 194, 194, 194, 192, 192, 192, 248, 248, 208, 208, 208, 208, 208, 213, 199, 199, 199, 199, 192, 0, 0, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 192, 192, 192, 192, 192, 192, 192, 234, 234, 0, 0, 194, 194, 194, 194, 194, 192, 192, 192, 192, 213, 213, 213, 213, 213, 213, 213, 194, 194, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 192, 192, 192, 192, 192, 192, 0, 0, 0, 199, 199, 199, 194, 194, 194, 194, 192, 192, 192, 213, 213, 213, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 239, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 192, 192, 192, 192, 192, 192, 0, 195, 199, 195, 195, 199, 199, 194, 194, 194, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 0, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 195, 195, 195, 195, 195, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 0, 195, 195, 195, 195, 195, 195, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 213, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 0, 0, 192, 192, 195, 195, 195, 195, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 213, 199, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 195, 195, 195, 195, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 213, 213, 199, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 195, 195, 195, 192, 192, 192, 192, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 213, 213, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 195, 195, 192, 192, 192, 192, 192, 194, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 213, 213, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 234, 234, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 194, 194, 194, 194, 194, 194, 234, 234, 194, 194, 194, 194, 234, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 194, 194, 194, 194, 194, 194, 234, 234, 213, 213, 213, 213, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 195, 194, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 194, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 194, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192
	.zero	552
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 239, 239, 239, 194, 194, 207, 207, 207, 194, 194, 194, 194, 239, 239, 239, 0, 248, 248, 248, 248, 248, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 239, 239, 194, 194, 194, 194, 194, 207, 207, 207, 194, 194, 194, 194, 194, 248, 248, 248, 248, 248, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 195, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 192, 192, 192, 192, 192, 192, 192, 192, 192, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 207, 207, 194, 194, 194, 248, 248, 248, 248, 208, 208, 199, 199, 199, 199, 0, 0, 0, 0, 0, 0, 0, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 195, 195, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 248, 248, 208, 208, 208, 213, 213, 213, 199, 199, 199, 0, 0, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 234, 192, 192, 192, 192, 192, 192, 192, 234, 0, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 248, 213, 213, 213, 213, 213, 213, 213, 194, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 195, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 234, 192, 192, 192, 192, 192, 192, 234, 0, 0, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 213, 213, 213, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 192, 192, 192, 0, 0, 195, 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 234, 234, 192, 192, 192, 192, 192, 192, 0, 0, 195, 199, 199, 199, 199, 195, 194, 194, 194, 194, 194, 192, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 192, 192, 192, 192, 192, 192, 0, 0, 195, 199, 199, 199, 199, 195, 195, 195, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 213, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 195, 195, 195, 199, 199, 195, 195, 195, 195, 239, 239, 239, 239, 239, 239, 239, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 213, 213, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 195, 195, 195, 195, 199, 195, 195, 195, 195, 195, 239, 239, 194, 194, 194, 194, 194, 194, 213, 194, 194, 194, 194, 194, 194, 194, 213, 213, 199, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 195, 195, 192, 192, 192, 195, 195, 195, 195, 195, 194, 194, 194, 194, 194, 194, 194, 213, 213, 194, 194, 194, 194, 194, 194, 194, 213, 213, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 0, 0, 0, 0, 0, 0, 0, 195, 192, 192, 192, 192, 192, 195, 195, 195, 195, 192, 192, 192, 194, 194, 194, 194, 213, 213, 194, 194, 194, 194, 194, 194, 194, 213, 213, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 195, 195, 192, 192, 192, 194, 194, 194, 194, 213, 213, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 194, 194, 194, 213, 213, 194, 194, 194, 194, 194, 194, 194, 234, 234, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 194, 194, 194, 194, 194, 194, 194, 234, 194, 194, 194, 194, 234, 234, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 234, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 194, 194, 194, 194, 194, 194, 194, 234, 234, 213, 213, 213, 194, 194, 194, 194, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 194, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 213, 194, 194, 194, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 194, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 213, 194, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 234, 234, 192, 192, 192, 192, 192, 192, 192, 192, 192, 194, 194, 194, 194, 194, 194, 194, 213, 213, 213, 213, 213, 213, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 194, 194, 194, 194, 0, 0, 213, 213, 213, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 192, 192, 192, 192, 192
	.zero	548

	.weak	__ZZN5rally9carColourEhjE7colours
__ZZN5rally9carColourEhjE7colours:
	db	224, 240, 244, 199, 219, 207
	db	196, 196, 200, 195, 235, 255
	db	202, 207, 223, 242, 246, 240
	db	232, 252, 253, 195, 215, 255
	db	230, 246, 251, 207, 223, 196
	db	198, 199, 203, 244, 249, 252

	.local	__ZN5rallyL13SceneryPixelsE
__ZN5rallyL13SceneryPixelsE:
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD@", 0, "DDDDD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDDDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDD@", 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDDDDDD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDD", 0, 0, 0, 0, 0, 0, 4, "DDDDD4CDDDDDDDD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDD0", 0, "DDDDCDDDDC3C4DDDDDD4D", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "DDDDDDDC3DDDDDDDDDD33C333DDDC3D@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDD@", 0, 0, 0, 0, "DDDDDD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "34DDDD334DDDDDDDDDC33DD334DD34DC", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDD@", 0, 0, 0, "DDDDDDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "33333DDDDDDDDDD3334DDDD3333DD30", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDC4DDDDDDDDDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDDDDDDDD333DDDDD3DDDDC30", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDD34DDDDDDDDDDDD0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDDDDDDDDC33DDDDDD33DDC330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDCDDDDCDDDDDDDDDDDD33", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDD4DDDDD33DDDDDDDC3333330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDC4DDDDDDDDDDDDDDC330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "4DDDDDDDD33DDDC333DDDDC4DD3333333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DD4DDD34DDDC3DDDDDDDDC30", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDD", 0, 0, 0, 0, 0, 4, "DDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "33DDDDDC3333333333DDDC333DD333330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDD3DDC34DDDDC34DDDDD333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDDD", 0, 0, 0, 4, "DDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "333333033333333333333333333333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDC3333DDDDDDDC3333333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDDD", 0, 0, "DDDDDD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "333330", 0, 0, 3, "3333", 0, 0, "3333330", 0, "333330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDC33DD3DDDDDDDDDC30", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDDDDD", 0, 4, "DDDDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "3333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "33330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "DDDDDDDDC4DDDDDDDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDD4D4DDDDDDDD0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "33", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "4DDDDDDD33DDDDDDDDDC0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDDC4DDDDD333CDDDDDDC3", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "33DDDDC3334DDDDDDDD33", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDDD33DDDC334C4DDDDD33", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDD", 0, "DDDD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "333333333433DDDDDC330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDDDDDC34DD333DC34DDD333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDDDD", 0, 0, 0, 0, 0, 4, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "3333333333333333333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDCDDDDDD33334D3333333330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDD@", 4, "DDDD", 0, 0, 0, 0, "DDDDDDDDDDDDD@", 0, 0, 0, 4, "DDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "3333", 0, 0, 3, "33333333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDD4DDDDDD333333", 0, 3, "333333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, "DDDDDDDDDDDD", 0, 4, "DDDDDDDDDDDDDC", 0, 0, 0, "DDDDD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDDCDDDDDD33", 0, 0, 0, 0, 0, 0, 0, "3330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDDDDDDD", 4, "DDDDDDDDDD4DD30", 0, 4, "DDDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDD3DDDDDD3", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DDDDDDDDDDDDDDCDDDDDDDDDC3DC30", 0, 4, "DDDDDD0", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "4DDCDDDDC34DDDDC3", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "4DDDDDDDDDDDDDC4DDDDDDDD33C330", 0, 3, "DDDDDC3", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "3DDD3DDC333DDDC33", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "3DDDDDDDDDDDDC334DDDD3333333", 0, 0, "C4DDDD33", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "334DD33333333333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "34DDDDDDD4DD3333DDC33333330", 4, "DC34DD333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "333333333", 0, 3, "333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "DDDDDDC3D33034DDD3333330", 4, "DDD3333330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "3333333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "34DDD334333", 0, 0, "DDDDC3", 0, 0, 0, 0, 0, "DDDDC33333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "33330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "3333DC33", 0, 0, 4, "DDDDD", 0, 0, 0, 0, 0, 0, "DDDDDC333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "4DDD33", 0, 0, 0, 4, "DDDDD0", 0, 0, 0, 0, 0, "4DDDDDD30", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "3DDC33", 0, 0, 0, 3, "DDDDC3", 0, 0, 0, 0, 0, 3, "4CDDDC30", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "333330", 0, 0, 0, 3, "4DDD33", 0, 0, 0, 0, 0, 0, 3, "33DC33", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "3333", 0, 0, 0, 0, 3, "3DDC33", 0, 0, 0, 0, 0, 0, 0, 0, "33330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "33", 0, 0, 0, 0, 0, 0, "333330", 0, 0, 0, 0, 0, 0, 0, 0, 3, "333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "3333", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "330", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, "33", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, "D@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, "TDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UUDDD@", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UUTDDDD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, "UTDDDDDE", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UUDDDDDDDP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "UTDDDDDDDE", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "uUDDDDTDDDDP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "UUDDDDuDDDDE", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "uUTDDDGwDDDDDP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "uUTDDDGwtDDEUE", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wUUDDDDwwtDDEUUP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "uUUDDDDwwwtDDUUU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wUUTDETGwwwwUDUUUP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwUUTDUUGwwwwuUEUUU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwuUUDUUWwwwwwwUUUUUP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwUUUEUUwwwwwwwuUUUUU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "wwwuUUTUUWwwwwwwwwUUUUUP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "wwwwuUUUUUWwwwwwwwwuUUUUUP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "wwwwwUUUUUUwwwwwwwwwwUUUUUUP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "wwwwwuUUUUUWwwwwwwwwwwuUUUUUUP", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwwwwUUUUWwwwwwwwwwwwwwwuUUUUU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwwwwwUUUwwwwwwwwwwwwwwwwwwwUUUU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "wwwwwwuUwwwwwwwwwwwwwwwwwwwwwwwUUU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwwwwwWwwwwwwwwwwwwwwwwwwwwwwwwwwuU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwx", 136, 135, "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww", 136, "wwp", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, "www", 136, 136, 136, 135, "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww", 136, 136, 136, "wwp", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 0, 0, 8, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 0, 0, 8, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwwx", 136, 136, 136, 136, 136, 136, 136, "wwwwwwwwwwwwwwwwwwwx", 136, 135, "www", 136, 136, 136, 136, 136, 136, 136, 135, "wwp", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 128, 0, 0, 8, 136, 128, 0, 8, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 0, 0, 8, 136, 0, 0, 8, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 0, 0, 136, 136, 0, 0, 0, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 128, 0, 0, 8, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "wwwwww", 136, 136, 136, 136, 136, 136, 136, 136, 135, "wwx", 136, 136, "wwwwwwwwwwwwx", 136, 136, 136, 135, "w", 136, 136, 136, 136, 136, 136, 136, 136, 136, "wwwp", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 8, 136, 136, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 128, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 8, 136, 136, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 128, 0, 8, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 128, 8, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 0, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 8, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 8, 136, 135, "wwwwww", 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 135, "w", 136, 136, 136, 136, "wwwwwwwwwww", 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, "wwwp", 0, 0, 0, 8, 128, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 136, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 128, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 128, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 8, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 128, 0, 0, 136, 136, 136, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 8, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 136, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 8, 136, 136, 128, 0, 0, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, "wwx", 136, 136, 136, 136, 136, 138, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, "wwwww", 136, 136, 136, 136, 138, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 135, "ww", 0, 8, 136, 136, 128, 0, 8, 136, 128, 0, 0, 136, 136, 138, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 8, 136, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 136, 136, 128, 0, 136, 136, 128, 0, 0, 0, 136, 136, 136, 136, 136, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 136, 136, 0, 0, 136, 136, 136, 0, 0, 0, 0, 136, 136, 136, 136, 138, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 8, 136, 136, 128, 0, 0, 0, 0, 0, 0, 8, 136, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 8, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 138, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 8, 136, 136, 136, 136, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 128, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 136, 138, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 0, 8, 136, 136, 136, 0, 0, 136, 136, 136, 136, 136, 136, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 136, 136, 128, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, "wwwx", 136, 136, 136, 138, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 135, "wx", 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 168, 138, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 8, 136, 138, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 8, 136, 136, 136, 136, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 0, 0, 0, 136, 138, 170, 136, 136, 136, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 136, 136, 136, 136, 138, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 8, 136, 136, 136, 136, 138, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 136, 136, 128, 8, 136, 138, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 8, 136, 136, 136, 136, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 136, 136, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 136, 136, 136, 136, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 0, 0, 0, 136, 136, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 0, 8, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 0, 8, 136, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 8, 136, 136, 136, 138, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 138, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 136, 136, 136, 136, 136, 170, 170, 170, 170, 168, 170, 170, 168, 136, 136, 136, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 136, 136, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 136, 136, 136, 136, 138, 170, 170, 170, 168, 136, 136, 138, 170, 170, 136, 138, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 8, 136, 136, 136, 136, 138, 170, 170, 170, 136, 136, 138, 170, 136, 136, 138, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 136, 136, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 136, 136, 170, 170, 136, 136, 136, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 136, 136, 136, 136, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 0, 136, 136, 136, 136, 136, 136, 170, 170, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 128, 8, 136, 136, 136, 136, 136, 138, 170, 168, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 0, 0, 136, 138, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 168, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 168, 136, 136, 138, 170, 170, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 168, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 168, 136, 138, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 168, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 136, 138, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 168, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 138, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 138, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 138, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 138, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 168, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 168, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 168, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 138, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 138, 170, 170, 168, 136, 136, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 138, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 138, 170, 168, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 138, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 170, 168, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 170, 170, 168, 136, 170, 170, 168, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 170, 170, 136, 136, 170, 170, 170, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 138, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 168, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 138, 136, 136, 138, 170, 170, 170, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 136, 170, 170, 170, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 138, 170, 170, 168, 136, 136, 170, 168, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 138, 168, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 170, 170, 170, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 168, 136, 138, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170, 170

	.local	__ZN5rallyL14SceneryPaletteE
__ZN5rallyL14SceneryPaletteE:
	db	244, 245, 249, 250, 255, 234, 229, 228, 212, 196, 197, 217, 252, 213, 216, 218

	.local	___const._ZN12_GLOBAL__N_18loadFontEv.consolidate
___const._ZN12_GLOBAL__N_18loadFontEv.consolidate:
	db	23, 0, 160, 197, 249, 14

	.local	__ZN5rally4gameL10FontPixelsE
__ZN5rally4gameL10FontPixelsE:
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 16, 16, 16, 16, 0, 16, 0, "((", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "dh", 8, 16, " ,L", 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 16, " ", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 16, "|", 16, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "|", 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 24, 0, 4, 8, 8, 16, "  @", 0, "8DLTdD8", 0, 16, "0", 16, 16, 16, 16, "8", 0, "8D", 4, 8, 16, " |", 0, "x", 4, 4, "8", 4, 4, "x", 0, 8, 24, "(H|", 8, 8, 0, "|@@x", 4, 4, "x", 0, "8@@xDD8", 0, "|", 4, 8, 8, 16, 16, 16, 0, "8DD8DD8", 0, "8DD<", 4, 4, "8", 0, 0, 16, 16, 0, 16, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 16, " @ ", 16, 8, 0, 0, "|", 0, "|", 0, 0, 0, 0, " ", 16, 8, 4, 8, 16, " ", 0, "8D", 4, 8, 16, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, "8DD|DDD", 0, "xDDxDDx", 0, "<@@@@@<", 0, "xDDDDDx", 0, "|@@x@@|", 0, "|@@x@@@", 0, "<@@", 92, "DD<", 0, "DDD|DDD", 0, "|", 16, 16, 16, 16, 16, "|", 0, 28, 8, 8, 8, "HH0", 0, "DHP`PHD", 0, "@@@@@@|", 0, "DlTTDDD", 0, "DddTLLD", 0, "8DDDDD8", 0, "xDDx@@@", 0, "8DDDTH4", 0, "xDDxPHD", 0, "<@@8", 4, 4, "x", 0, "|", 16, 16, 16, 16, 16, 16, 0, "DDDDDD8", 0, "DDDDD(", 16, 0, "DDDTTlD", 0, "DD(", 16, "(DD", 0, "DD(", 16, 16, 16, 16, 0, "|", 4, 8, 16, " @|", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "8DD|DDD", 0, "xDDxDDx", 0, "<@@@@@<", 0, "xDDDDDx", 0, "|@@x@@|", 0, "|@@x@@@", 0, "<@@", 92, "DD<", 0, "DDD|DDD", 0, "|", 16, 16, 16, 16, 16, "|", 0, 28, 8, 8, 8, "HH0", 0, "DHP`PHD", 0, "@@@@@@|", 0, "DlTTDDD", 0, "DddTLLD", 0, "8DDDDD8", 0, "xDDx@@@", 0, "8DDDTH4", 0, "xDDxPHD", 0, "<@@8", 4, 4, "x", 0, "|", 16, 16, 16, 16, 16, 16, 0, "DDDDDD8", 0, "DDDDD(", 16, 0, "DDDTTlD", 0, "DD(", 16, "(DD", 0, "DD(", 16, 16, 16, 16, 0, "|", 4, 8, 16, " @|"
	.zero	1065

	.local	__ZN5rally4gameL11SignArtworkE
__ZN5rally4gameL11SignArtworkE:
	db	0                               ; 0x0
	db	255                             ; 0xff
	db	208                             ; 0xd0
	db	252                             ; 0xfc
	db	219                             ; 0xdb
	db	253                             ; 0xfd
	db	234                             ; 0xea
	.zero	9
	db	17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, "#3", 34, "#323322", 34, "22", 34, "2#3", 34, "33", 34, "#3", 34, "33", 34, "#32", 17, 17, "2", 34, "22", 34, 34, 34, "2", 34, "3", 34, "22", 34, "22", 34, "22", 34, "22", 34, "22", 34, "22", 34, 34, 17, 17, "2", 34, "22", 34, 34, 34, "2", 34, "3", 34, "22", 34, "22", 34, "22", 34, "22", 34, "22", 34, "22", 34, 34, 17, 17, "332232", 34, "2", 34, "2222", 34, "23322", 34, "22", 34, "233", 34, "#3", 34, 17, 17, "2", 34, "22", 34, "2", 34, "2", 34, "2#22", 34, "22", 34, "22", 34, "22", 34, "222", 34, 34, 34, "2", 17, 17, "2", 34, "22", 34, "2", 34, "2", 34, "2#2##", 34, "2", 34, "22", 34, "22", 34, "22#", 34, 34, 34, "2", 17, 17, "2", 34, "2#323322", 34, "2", 34, "2", 34, "2", 34, "233", 34, "#3", 34, "2", 34, "233", 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "$DB", 34, 34, 34, 34, 34, 34, 34, 34, 34, "U", 34, 34, 34, 34, 34, "U", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "$DB", 34, 34, 34, 34, 34, 34, 34, 34, 34, "U", 34, 34, 34, 34, 34, "U", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "$DDDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, "U", 34, 34, 34, "U", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "$DDDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, "U", 34, 34, 34, "U", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "$DDDDDB", 34, 34, 34, 34, 34, 34, 34, "UUUUUUU", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "$DDDDDB", 34, 34, 34, 34, 34, 34, 34, "UUUUUUU", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "$DB$DB$DB", 34, 34, 34, 34, 34, "UU", 34, "UUU", 34, "UU", 34, 34, 34, 34, 17, 17, 34, 34, 34, "$DB$DB$DB", 34, 34, 34, 34, 34, "UU", 34, "UUU", 34, "UU", 34, 34, 34, 34, 17, 17, 34, 34, 34, "$DDDDDDDB", 34, 34, 34, 34, "UUUUUUUUUUU", 34, 34, 34, 17, 17, 34, 34, 34, "$DDDDDDDB", 34, 34, 34, 34, "UUUUUUUUUUU", 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "$B", 34, "$B", 34, 34, 34, 34, 34, 34, "U", 34, "UUUUUUU", 34, "U", 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "$B", 34, "$B", 34, 34, 34, 34, 34, 34, "U", 34, "UUUUUUU", 34, "U", 34, 34, 34, 17, 17, 34, 34, 34, 34, "$B$DB$B", 34, 34, 34, 34, 34, "U", 34, "U", 34, 34, 34, 34, 34, "U", 34, "U", 34, 34, 34, 17, 17, 34, 34, 34, 34, "$B$DB$B", 34, 34, 34, 34, 34, "U", 34, "U", 34, 34, 34, 34, 34, "U", 34, "U", 34, 34, 34, 17, 17, 34, 34, 34, "$B$B", 34, "$B$B", 34, 34, 34, 34, 34, 34, 34, "UU", 34, "UU", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "$B$B", 34, "$B$B", 34, 34, 34, 34, 34, 34, 34, "UU", 34, "UU", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "ff", 0, 0, 0, 0, 0
	db	0                               ; 0x0
	db	255                             ; 0xff
	db	192                             ; 0xc0
	db	253                             ; 0xfd
	db	252                             ; 0xfc
	db	234                             ; 0xea
	.zero	10
	db	17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "33", 34, "3323323322", 34, "233", 34, "33233", 34, 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, "22", 34, 34, "2", 34, 34, "2", 34, 34, "3", 34, "22", 34, "22", 34, 34, "2", 34, "2", 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, "22", 34, 34, "2", 34, 34, "2", 34, 34, "3", 34, "22", 34, "22", 34, 34, "2", 34, "2", 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, "233", 34, "33", 34, "33", 34, "2222", 34, "233", 34, "33", 34, 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, "22", 34, 34, "2", 34, 34, "2", 34, 34, "2#22", 34, "22", 34, 34, "22", 34, 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, "22", 34, 34, "2", 34, 34, "2", 34, 34, "2#22", 34, "22", 34, 34, "2#", 34, 34, 34, 34, 17, 17, 34, 34, 34, "33", 34, "3322", 34, 34, "3322", 34, "233", 34, "3322", 34, "2", 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "DD", 17, 20, "DD", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "DD", 17, 20, "DD", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "DD", 17, 20, "DD", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "$DD", 17, 17, 17, 17, 17, 17, "D", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "$DD", 17, 17, 17, 17, 17, 17, "D", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "DDDDD", 17, 17, 17, 17, 17, 17, 17, 17, 17, 20, "DDDD", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "DDDDD", 17, 17, 17, 17, 17, 17, 17, 17, 17, 20, "DDDD", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "DDDDD", 17, 17, 17, 17, 17, 17, 17, 17, 17, 20, "DDDD", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 17, 17, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 17, 17, 34, 34, 34, "DDDDD", 17, 17, 17, 17, 17, 17, 17, 17, 17, 20, "DDDD", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "DDDDD", 17, 17, 17, 17, 17, 17, 17, 17, 17, 20, "DDDD", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "DDDDD", 17, 17, 17, 17, 17, 17, 17, 17, 17, 20, "DDDD", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "$DD", 17, 17, 17, 17, 17, 17, "D", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "$DD", 17, 17, 17, 17, 17, 17, "D", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "DD", 17, 20, "DD", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "DD", 17, 20, "DD", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "DD", 17, 20, "DD", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0
	db	0                               ; 0x0
	db	255                             ; 0xff
	db	192                             ; 0xc0
	db	243                             ; 0xf3
	db	209                             ; 0xd1
	db	234                             ; 0xea
	.zero	10
	db	17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!!", 18, 19, "3#4B", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!#", 19, "2", 19, "C2#333", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "#33!3333C", 34, "#", 19, "4#3C3B", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "1C3##B13#C2#$B", 34, "B", 34, 34, "DDD", 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 19, "43323$B", 34, 34, 34, "$DDBDB", 34, "A34D", 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDDDDA", 19, "3", 20, "C4", 34, "334D", 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "DB$DA", 17, "3", 20, "C334C4BCDDD", 34, 34, 34, 17, 17, 34, 34, "$DDA", 17, "BCD$3C333C4D3C4BCDDD", 34, 34, 34, 17, 17, 34, 34, 34, "C333", 20, "CDD3C4D3C4D3C4B", 19, "34B", 34, 34, 34, 17, 17, 34, 34, 34, "$3DC4CDD3C4D3C4D4C4B34DD", 34, 34, 34, 17, 17, 34, 34, 34, "$3DC4CDD3C4A4C", 17, 19, "4C4B3DDD!2", 34, 17, 17, 34, 34, 34, "$3DC4CDD3C", 17, 19, "4C33DC4D3DDD", 19, "3", 34, 17, 17, 34, 34, 34, "$3DC4CDD3C33DC4DDC1", 17, "334D$4", 34, 17, 17, 34, "!B$3", 17, "3DCDD3C43DC4DDC3333DD", 34, "B", 34, 17, 17, 34, "#2$334DC4D4C4C4C4D", 34, "DDDDDDA", 20, 34, 34, 17, 17, "#33D3DDD#334CDDDDDB", 34, "$D", 17, "D", 19, "334B", 34, 17, 17, 34, "#", 34, "$3DDD$33DDDDDDDD", 34, "!33D3334B", 34, 17, 17, 34, "!B$3DD", 34, 34, "DDDDA", 17, 19, 20, "C4B#33C4DC4B", 34, 17, 17, 34, "B", 34, "$3DB", 34, "DA", 17, "31C333C4B#4DC4DDDB", 34, 17, 17, 34, "D", 34, "$3A4", 34, "CC333C4D3C4B#1", 17, "C3", 19, "1DB", 34, 17, 17, 34, "D", 34, "$3C4BCC4D3C4D3C4B#33D333DB", 34, 17, 17, 34, "CB$3C4BCC4DCC4D3C4B#4DDDD3D", 34, 34, 17, 17, 34, "C4$3C4BCC4D", 19, "C4A3C4B#4DDDD3D", 34, 34, 17, 17, 34, "C1D3C4BCC1", 19, "4C334C4DC4AA", 17, "33D", 34, 34, 17, 17, 34, "C3", 20, "3C4BCC33DC4DDC1", 19, "333C33DD", 34, 34, 17, 17, 34, "C313C4BCC334C4DDC33334DDDDD", 34, 34, 17, 17, 34, "C333C4DCC4C4C4DD$DDDDDDDDDB", 34, 34, 17, 17, 34, "C433D333C4D3DDD", 34, "$DDDDDB", 34, 34, 34, 34, 34, 34, 17, 17, 34, "C4C3DC3DDDDDDDD", 34, 34, 34, 34, 34, 34, "!33332", 34, 34, 17, 17, 34, "C4D3D$DDBDD$", 34, 34, 34, 34, "!333333DDB", 34, 34, 34, 17, 17, 34, "CDBCD$DD", 34, 34, 34, 34, 34, "!333334DDB", 34, 34, 34, 34, 34, 34, 17, 17, 34, "$DBDD", 34, 34, 34, "!333334DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, "DB$D", 34, "#334DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "$", 34, 34, "$B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!3334B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "#333DD", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "$", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0
	db	0, 255, 208, 223, 224, 234, 229, 250
	.zero	8
	db	17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "#3", 34, "#32#3", 34, "2", 34, "2", 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "2", 34, "22", 34, 34, "2", 34, "23", 34, "2", 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "2", 34, "22", 34, 34, "2", 34, "23", 34, "2", 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "3322322", 34, "2222", 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "2", 34, "22", 34, "22", 34, "22#2", 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "2", 34, "22", 34, "22", 34, "22#2", 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "2", 34, "2#32#3", 34, "2", 34, "2", 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDD", 17, "TDDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDD", 17, 20, "DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDD", 17, 20, "DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDD", 17, 20, "DDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDD", 17, "dDDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DDD", 17, "dDDB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DA", 21, "aA", 17, "DB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "DQ", 17, "EA", 17, "DB", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "D", 17, 17, 20, 17, 17, 20, "B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "A", 17, 17, "D", 20, "A", 20, "B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "A", 17, 17, "D", 20, "A", 17, "B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "A", 17, 20, 17, 17, 17, 17, "B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "a", 20, 20, 17, 17, 20, 17, "B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, "T", 20, 17, 17, "Dqb", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "qDF", 17, "dDaR", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "qE", 21, "DA", 20, "ab", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, "Q", 23, "a", 22, 17, 17, "B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "Q", 17, 20, 17, 20, 17, 17, "R", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "A", 17, 20, 17, 20, 17, 17, "B", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, "e", 22, 20, 17, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, "FDGq", 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "a", 17, "DDDG", 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "#3#", 34, "##", 34, "##33#32", 34, "32#", 34, "#", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "2#", 34, "##", 34, "2#", 34, 34, "#", 34, "##", 34, "##", 34, "#", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "2#", 34, "###", 34, "#", 34, 34, "#", 34, "##", 34, "#", 34, "22", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "2#", 34, "##2", 34, "#32#32#", 34, "#", 34, "#", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "#", 34, "2#", 34, "###", 34, "#", 34, 34, "#", 34, "##", 34, "#", 34, "22", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "#", 34, "2#", 34, "##", 34, "2#", 34, 34, "#", 34, "##", 34, "##", 34, "#", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "3", 34, 34, "32#", 34, "##33#32", 34, "32#", 34, "#", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0
	db	0, 255, 192, 194, 210, 214, 213, 193, 198, 239, 234, 212, 215, 208, 235, 197
	db	17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 34, 34, 34, 34, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, "#334E2!&", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, "#32", 34, "#$UB", 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!#33", 34, 18, 34, "$EU2", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, "333", 34, "!", 34, "tTUU!", 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "!#333", 34, "!", 34, "$DEE", 130, 18, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 18, "3334", 34, "a", 146, 34, "DT4D", 162, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 19, "333", 34, 18, 34, 34, 17, "*", 17, "#3!", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, "!#333", 34, 34, 34, 34, 34, "!", 17, 18, "#2b", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, "!3332", 18, 34, 34, 34, 34, 162, 34, 17, 162, "2", 18, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 18, "333", 34, 34, 34, 34, 34, 34, 34, 34, 34, 26, "4", 18, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 18, "334", 34, 34, 34, 34, 34, 34, "!", 34, 34, 17, "3!", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 19, "3#2", 34, 34, 18, 34, 34, 18, "!", 34, 17, 17, "S!", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "+#2", 17, 34, "*!", 18, 34, 34, 17, "!!!", 18, "3q", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, "#:!#!!", 18, 34, 34, 17, "!!", 17, 18, "3", 193, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, "#6", 18, 18, "5", 34, 34, 34, 34, 34, 17, 17, 17, "#3A", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, "#2", 17, 17, 34, 34, 34, 34, 34, 34, "!", 17, 18, "331", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, "#2", 26, 17, 17, "!", 18, 34, 34, 34, 18, 18, "#33!", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 19, "2", 17, 18, 17, 17, 17, 17, "a", 17, 18, "'333!R", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 18, "3", 34, 34, "!", 17, "!", 17, 34, 17, 18, "3333", 34, "2", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 18, "32", 17, 17, 17, "!", 17, 17, "a", 18, "3333", 18, "2", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "-!33", 34, 22, 34, 26, 17, "!", 17, 34, 34, "#32", 18, "r", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, "!#3r", 34, "!", 34, 25, 26, 18, "!", 17, 18, "31#b", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "+", 178, 20, "2!", 17, 17, 18, 34, 34, "!", 17, 17, 17, "s)#", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 18, "!", 17, 17, 17, 17, 18, 34, 17, 17, "a", 17, "2", 18, "#", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 22, 17, 34, 18, "!", 34, 17, 18, "!", 34, "2", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 17, 34, "b", 34, 17, 18, 18, "!", 17, 34, 18, 34, "2", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, "!", 18, "#3", 34, 34, 34, 17, "!!", 34, 34, "2", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, "*", 18, "!'", 34, 34, 34, 34, 34, 34, "f", 34, 34, "'", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 225, 34, 34, 34, 34, 34, 34, 162, 34, 34, "#", 242, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "*", 170, 34, "&", 170, 162, 34, 34, 34, "#", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "%", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 204, 204, 194, 194, 34, 194, 204, 204, 194, 204, 204, 194, 194, 34, 194, 204, 204, 34, 204, 204, 194, 204, 204, 34, 34, 34, 34, 17, 17, 34, 34, 34, 194, 34, 34, 194, 34, 194, 34, 194, 34, 194, 34, 34, 204, 34, 194, 194, 34, 194, 194, 34, 34, 194, 34, 194, 34, 34, 34, 17, 17, 34, 34, 34, 194, 34, 34, ",,", 34, 34, 194, 34, 194, 34, 34, 204, 34, 194, 194, 34, 194, 194, 34, 34, 194, 34, 194, 34, 34, 34, 17, 17, 34, 34, 34, 204, 204, 34, 34, 194, 34, 34, 194, 34, 204, 204, 34, 194, 194, 194, 194, 34, 194, 204, 204, 34, 204, 204, 34, 34, 34, 34, 17, 17, 34, 34, 34, 194, 34, 34, ",,", 34, 34, 194, 34, 194, 34, 34, 194, ",", 194, 194, 34, 194, 194, 34, 34, 194, 194, 34, 34, 34, 34, 17, 17, 34, 34, 34, 194, 34, 34, 194, 34, 194, 34, 194, 34, 194, 34, 34, 194, ",", 194, 194, 34, 194, 194, 34, 34, 194, ",", 34, 34, 34, 34, 17, 17, 34, 34, 34, 204, 204, 194, 194, 34, 194, 34, 194, 34, 204, 204, 194, 194, 34, 194, 204, 204, 34, 204, 204, 194, 194, 34, 194, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 170, 0, 0, 0, 0, 0
	db	0                               ; 0x0
	db	255                             ; 0xff
	db	224                             ; 0xe0
	db	229                             ; 0xe5
	db	250                             ; 0xfa
	db	234                             ; 0xea
	.zero	10
	db	17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 19, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 20, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "#", 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "1B", 17, 18, 20, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 18, 17, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "Q", 17, 19, "%!", 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 34, "!", 17, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "%", 17, 17, 17, 34, 17, 17, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 17, 17, 34, "!", 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "1", 17, 17, 18, "Q!", 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 18, 17, 17, 17, "!", 17, "2", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 20, 17, 34, 17, 17, 17, "!", 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 18, 17, "!", 17, 17, 17, "#", 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 18, 17, "!", 17, 17, 17, 34, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, "2#!", 17, 17, 18, 34, "A", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 34, 34, "!", 17, "R", 34, 34, "1", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, "2!", 34, 34, 34, 17, "21", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "#", 17, "2", 17, 18, "#", 18, 17, 18, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "$", 17, "A", 17, 18, 17, 21, "A", 17, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "$", 17, 17, 17, 34, 17, 17, "!", 17, 17, 20, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 17, "$", 17, 17, "!", 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 20, "!", 17, 17, "!", 17, 17, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 17, 18, "!", 19, 17, "%", 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 17, 18, 18, 34, "!", 34, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "$", 17, 17, "R", 34, 34, 34, 34, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, "E", 34, 34, 34, 34, 34, "#A", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 34, "!", 17, 18, "!", 17, 34, 18, 34, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, 18, 34, 34, 18, 34, 18, 17, 34, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, 18, 34, 34, 18, 34, 18, 17, 34, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 18, 18, 17, 18, 18, 34, 18, 18, 18, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, 18, 34, 18, 18, 34, 18, 18, "!", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, 18, 34, 18, 18, 34, 18, 18, "!", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, "!", 17, 18, "!", 17, 34, 18, 34, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "UU", 0, 0, 0, 0, 0
	db	0                               ; 0x0
	db	255                             ; 0xff
	db	193                             ; 0xc1
	db	223                             ; 0xdf
	db	234                             ; 0xea
	.zero	11
	db	17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "!", 17, 18, "!", 17, 17, 34, 17, 17, "!", 34, "!", 34, 17, 18, "!", 17, 18, "!", 17, 18, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "!", 34, "!", 34, "!", 34, "!", 34, 34, "!", 34, "!!", 34, "!!", 34, "!!", 34, "!", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "!", 34, "!", 34, "!", 34, "!", 34, 34, "!", 34, "!!", 34, "!!", 34, "!!", 34, "!", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "!", 17, 18, 34, "!", 34, "!", 34, 34, "!", 17, 17, "!", 17, 17, "!", 17, 18, "!", 34, "!", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "!!", 34, 34, "!", 34, "!", 34, 34, "!", 34, "!!", 34, "!!!", 34, "!", 34, "!", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "!", 34, 18, 34, "!", 34, "!", 34, 34, "!", 34, "!!", 34, "!!", 34, 18, "!", 34, "!", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, "!", 34, "!!", 17, 17, 34, 17, 17, "!", 34, "!!", 34, "!!", 34, "!!", 17, 18, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, "!", 17, 17, "!", 34, "!!", 17, 18, "!", 34, "!!", 34, "!!", 17, 17, "!", 17, 18, 34, 17, 17, "!", 17, 17, 34, 34, 17, 17, 34, 34, "!", 34, "!", 34, "!!", 34, "!!", 18, "!!", 18, "!", 34, "!", 34, "!", 34, "!!", 34, 34, "!", 34, 34, 34, 34, 17, 17, 34, 34, "!", 34, "!", 34, "!!", 34, "!!", 18, "!!", 18, "!", 34, "!", 34, "!", 34, "!!", 34, 34, "!", 34, 34, 34, 34, 17, 17, 34, 34, "!", 34, "!", 34, "!!", 17, 18, "!!!!!!", 34, "!", 34, "!", 34, "!!!", 17, "!", 17, 18, 34, 34, 17, 17, 34, 34, "!", 34, "!", 34, "!!!", 34, "!", 34, 17, "!", 34, 17, 34, "!", 34, "!", 34, "!!", 34, "!!", 34, 34, 34, 34, 17, 17, 34, 34, "!", 34, "!", 34, "!!", 34, 18, "!", 34, 17, "!", 34, 17, 34, "!", 34, "!", 34, "!!", 34, "!!", 34, 34, 34, 34, 17, 17, 34, 34, "!", 34, 34, 17, 18, "!", 34, "!!", 34, "!!", 34, "!!", 17, 17, "!", 17, 18, 34, 17, 17, "!", 17, 17, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "#32332#3", 34, "33", 34, "#322", 34, "233233", 34, 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, 34, 34, "2", 34, "2", 34, "22", 34, "22", 34, 34, "2", 34, "2", 34, "2", 34, "2", 34, "2", 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, 34, 34, "2", 34, "2", 34, "22", 34, "22", 34, 34, "2", 34, "2", 34, "2", 34, "2", 34, "2", 34, 34, 34, 17, 17, 34, 34, 34, "#3", 34, 34, "2", 34, "33233", 34, "#3", 34, "332", 34, "2", 34, "33", 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "2", 34, "2", 34, "2", 34, "222", 34, 34, 34, "22", 34, "2", 34, "2", 34, "2", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "2", 34, "2", 34, "2", 34, "22#", 34, 34, 34, "22", 34, "2", 34, "2", 34, "2", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "33", 34, 34, "2", 34, "2", 34, "22", 34, "233", 34, "2", 34, "23322", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "#323322", 34, "23323322", 34, "23322", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, 34, "2", 34, 34, "3", 34, "2", 34, "2", 34, 34, "2", 34, "3", 34, "22", 34, 34, "2", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "2", 34, 34, "2", 34, 34, "3", 34, "2", 34, "2", 34, 34, "2", 34, "3", 34, "22", 34, 34, "2", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "#3", 34, "33", 34, "222", 34, "2", 34, 34, "2", 34, "22233", 34, "2", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "22", 34, 34, "2#2", 34, "2", 34, 34, "2", 34, "2#22", 34, 34, "2", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, "22", 34, 34, "2#2", 34, "2", 34, 34, "2", 34, "2#22", 34, 34, "2", 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, "33", 34, "3322", 34, "2", 34, "2", 34, "3322", 34, "2332332", 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0
	db	0                               ; 0x0
	db	255                             ; 0xff
	db	196                             ; 0xc4
	db	223                             ; 0xdf
	db	234                             ; 0xea
	.zero	11
	db	17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "2", 34, "2332#3", 34, "2", 34, "2", 34, "2", 34, "#32", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "2", 34, "2", 34, "2", 34, "2", 34, "23", 34, "2", 34, "2", 34, "2", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "##", 34, 34, "2", 34, "2", 34, "23", 34, "2#", 34, 34, "2", 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, "2", 34, 34, "2", 34, "332222", 34, 34, 34, "#3", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "##", 34, 34, "2", 34, "2", 34, "22#2", 34, 34, 34, 34, 34, "2", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "2", 34, "2", 34, "2", 34, "2", 34, "22#2", 34, 34, 34, 34, 34, "2", 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, "2", 34, "23322", 34, "22", 34, "2", 34, 34, 34, "33", 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, "!", 17, 34, "!", 17, 18, "!", 17, 34, 18, 34, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, 18, 34, 34, 18, 34, 18, 17, 34, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, 18, 34, 34, 18, 34, 18, 17, 34, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 18, 18, 17, 18, 18, 34, 18, 18, 18, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, 18, 34, 18, 18, 34, 18, 18, "!", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, 18, 34, 18, 18, 34, 18, 18, "!", 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 18, 34, 18, "!", 17, 18, "!", 17, 34, 18, 34, 18, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 17, 17, 34, 17, 17, 34, "!", 17, 34, 34, 17, 18, 17, 17, 18, "!", 17, 18, 17, 17, 18, "!", 17, 18, 34, 34, 34, 17, 17, 34, 34, 34, 18, 34, 18, 18, 34, 18, 18, 34, 18, 34, "!", 34, 18, 34, 34, 18, 34, 34, 34, 18, 34, 18, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 18, 34, 18, 18, 34, 18, 18, 34, 18, 34, "!", 34, 18, 34, 34, 18, 34, 34, 34, 18, 34, 18, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 17, 17, 34, 17, 17, 34, 18, 34, 18, 34, "!", 34, 17, 17, 34, 18, 34, 34, 34, 18, 34, "!", 17, 34, 34, 34, 34, 17, 17, 34, 34, 34, 18, 34, 34, 18, 18, 34, 18, 34, 18, 18, "!", 34, 18, 34, 34, 18, 34, 34, 34, 18, 34, 34, 34, 18, 34, 34, 34, 17, 17, 34, 34, 34, 18, 34, 34, 18, "!", 34, 18, 34, 18, 18, "!", 34, 18, 34, 34, 18, 34, 34, 34, 18, 34, 34, 34, 18, 34, 34, 34, 17, 17, 34, 34, 34, 18, 34, 34, 18, 34, 18, "!", 17, 34, "!", 18, 34, 17, 17, 18, "!", 17, 18, 34, 18, 34, 17, 17, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "DD", 0, 0, 0, 0, 0

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_15crashE
__ZN12_GLOBAL__N_15crashE:
	.skip	4

	.local	__ZN12_GLOBAL__N_115attractProgressE
__ZN12_GLOBAL__N_115attractProgressE:
	.skip	4

	.section	.rodata,"a",@progbits
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

	.section	.data,"aw",@progbits
	.local	__ZN12_GLOBAL__N_113shownRevisionE
__ZN12_GLOBAL__N_113shownRevisionE:
	dw	65535                           ; 0xffff

	.section	.bss,"aw",@nobits
	.local	__ZN12_GLOBAL__N_110panelCacheE
__ZN12_GLOBAL__N_110panelCacheE:
	.skip	320

	.local	__ZN12_GLOBAL__N_110inputArmedE
__ZN12_GLOBAL__N_110inputArmedE:
	.skip	1

	.section	.rodata,"a",@progbits
	.local	__ZN5rally4gameL9FujiRulesE
__ZN5rally4gameL9FujiRulesE:
	dw	90                              ; 0x5a
	dw	60                              ; 0x3c
	dw	85                              ; 0x55
	dw	75                              ; 0x4b
	db	2                               ; 0x2

	.local	__ZN5rally4gameL9OvalRulesE
__ZN5rally4gameL9OvalRulesE:
	dw	20                              ; 0x14
	dw	11                              ; 0xb
	dw	20                              ; 0x14
	dw	16                              ; 0x10
	db	6                               ; 0x6

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

	.local	___const._ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm.lanes
___const._ZN5rally4game5Crash4tickERNS_6MotionERKNS0_11RaceTrafficEm.lanes:
	d24	0                               ; 0x0
	d24	16777180                        ; 0xffffdc
	d24	36                              ; 0x24
	d24	16777151                        ; 0xffffbf
	d24	65                              ; 0x41

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

	.local	_.str.20
_.str.20:
	db	"%d/%s/%d/%u/%d", 0

	.local	_.str.21
_.str.21:
	db	"FUJI", 0

	.local	_.str.22
_.str.22:
	db	"OVAL", 0

	.local	_.str.23
_.str.23:
	db	"AGON RALLY", 0

	.local	_.str.24
_.str.24:
	db	"QUALIFY. RACE. BEAT THE CLOCK.", 0

	.local	_.str.25
_.str.25:
	db	"PRESS ANY KEY TO RACE", 0

	.local	_.str.26
_.str.26:
	db	"CHOOSE YOUR RACE", 0

	.local	_.str.27
_.str.27:
	db	"<  FUJI SPEEDWAY  >", 0

	.local	_.str.28
_.str.28:
	db	"<    TRI-OVAL    >", 0

	.local	_.str.29
_.str.29:
	db	"CIRCUIT RACE  -  UP/DOWN", 0

	.local	_.str.30
_.str.30:
	db	"ARCADE TRAFFIC  -  UP/DOWN", 0

	.local	_.str.31
_.str.31:
	db	"SPACE / ENTER TO START", 0

	.local	_.str.32
_.str.32:
	db	"PREPARE TO QUALIFY", 0

	.local	_.str.33
_.str.33:
	db	"PREPARE TO RACE", 0

	.local	_.str.34
_.str.34:
	db	"%u", 0

	.local	_.str.35
_.str.35:
	db	"UP: GAS   DOWN: BRAKE   L/R: STEER", 0

	.local	_.str.36
_.str.36:
	db	"QUALIFIED!", 0

	.local	_.str.37
_.str.37:
	db	"GRID POSITION %d OF 7", 0

	.local	_.str.38
_.str.38:
	db	"GET READY FOR THE RACE", 0

	.local	_.str.39
_.str.39:
	db	"GOAL!", 0

	.local	_.str.40
_.str.40:
	db	"TIME UP", 0

	.local	_.str.41
_.str.41:
	db	"DID NOT QUALIFY", 0

	.local	_.str.42
_.str.42:
	db	"BEST LAP %s", 0

	.local	_.str.43
_.str.43:
	db	"SPACE / ENTER: TRY AGAIN", 0

	.local	_.str.44
_.str.44:
	db	"ESC: TITLE", 0

	.local	_.str.45
_.str.45:
	db	"%01lu'%02lu", 34, "%02lu", 0

	.local	_.str.46
_.str.46:
	db	"TOP %07lu", 0

	.local	_.str.47
_.str.47:
	db	"TIME %03lu", 0

	.local	_.str.48
_.str.48:
	db	"LAP %s", 0

	.local	_.str.49
_.str.49:
	db	"SCORE %07lu", 0

	.local	_.str.50
_.str.50:
	db	"SPEED %03ld", 0

	.local	_.str.51
_.str.51:
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
	.local	_.str.52
_.str.52:
	db	"ARROWS DRIVE   -= GRIP   M MUTE", 0

	.local	_.str.53
_.str.53:
	db	"QUALIFYING LAP", 0

	.local	_.str.54
_.str.54:
	db	"%s  LAP %u/%u", 0

	.local	_.str.55
_.str.55:
	db	"RACE", 0

	.local	_.str.56
_.str.56:
	db	"ARCADE", 0

	.local	_.str.57
_.str.57:
	db	"TIME EXTENDED!", 0

	.local	_.str.58
_.str.58:
	db	"rally.new", 0

	.local	_.str.59
_.str.59:
	db	"wb", 0

	.local	___const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute
___const._ZN5rally4game6Engine4stopIPFvPKhjEEEvT_.mute:
	db	23, 0, 133, 0, 2, 0

	.local	___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.setup
___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.setup:
	db	23, 0, 133, 0, 8, 23, 0, 133, 0, 10, 23, 0, 133, 0, 4, 3

	.local	___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.volume
___const._ZN5rally4game6Engine5startIPFvPKhjEEEvT_.volume:
	db	23, 0, 133, 0, 2, "("

	.local	__ZN5rallyL11BandOffsetsE
__ZN5rallyL11BandOffsetsE:
	dw	0                               ; 0x0
	dw	8                               ; 0x8
	dw	16                              ; 0x10
	dw	25                              ; 0x19
	dw	34                              ; 0x22
	dw	43                              ; 0x2b
	dw	52                              ; 0x34
	dw	62                              ; 0x3e
	dw	72                              ; 0x48
	dw	81                              ; 0x51
	dw	91                              ; 0x5b
	dw	101                             ; 0x65
	dw	111                             ; 0x6f
	dw	121                             ; 0x79
	dw	131                             ; 0x83
	dw	141                             ; 0x8d
	dw	151                             ; 0x97
	dw	161                             ; 0xa1
	dw	172                             ; 0xac
	dw	183                             ; 0xb7
	dw	194                             ; 0xc2
	dw	204                             ; 0xcc
	dw	215                             ; 0xd7
	dw	225                             ; 0xe1
	dw	236                             ; 0xec
	dw	248                             ; 0xf8
	dw	260                             ; 0x104
	dw	273                             ; 0x111
	dw	287                             ; 0x11f
	dw	300                             ; 0x12c
	dw	314                             ; 0x13a
	dw	328                             ; 0x148
	dw	343                             ; 0x157
	dw	357                             ; 0x165
	dw	373                             ; 0x175
	dw	386                             ; 0x182
	dw	401                             ; 0x191
	dw	415                             ; 0x19f
	dw	432                             ; 0x1b0
	dw	447                             ; 0x1bf
	dw	463                             ; 0x1cf
	dw	476                             ; 0x1dc
	dw	490                             ; 0x1ea
	dw	505                             ; 0x1f9
	dw	520                             ; 0x208
	dw	535                             ; 0x217
	dw	550                             ; 0x226
	dw	566                             ; 0x236
	dw	583                             ; 0x247
	dw	599                             ; 0x257
	dw	615                             ; 0x267
	dw	632                             ; 0x278
	dw	650                             ; 0x28a
	dw	666                             ; 0x29a
	dw	681                             ; 0x2a9
	dw	697                             ; 0x2b9
	dw	713                             ; 0x2c9
	dw	727                             ; 0x2d7
	dw	742                             ; 0x2e6
	dw	759                             ; 0x2f7
	dw	776                             ; 0x308
	dw	792                             ; 0x318
	dw	808                             ; 0x328
	dw	826                             ; 0x33a
	dw	845                             ; 0x34d
	dw	861                             ; 0x35d
	dw	877                             ; 0x36d
	dw	895                             ; 0x37f
	dw	914                             ; 0x392
	dw	931                             ; 0x3a3
	dw	946                             ; 0x3b2
	dw	963                             ; 0x3c3
	dw	982                             ; 0x3d6
	dw	998                             ; 0x3e6
	dw	1013                            ; 0x3f5
	dw	1027                            ; 0x403
	dw	1045                            ; 0x415
	dw	1061                            ; 0x425
	dw	1076                            ; 0x434
	dw	1091                            ; 0x443
	dw	1108                            ; 0x454
	dw	1122                            ; 0x462
	dw	1136                            ; 0x470
	dw	1152                            ; 0x480
	dw	1168                            ; 0x490
	dw	1183                            ; 0x49f
	dw	1198                            ; 0x4ae
	dw	1213                            ; 0x4bd
	dw	1228                            ; 0x4cc
	dw	1241                            ; 0x4d9
	dw	1257                            ; 0x4e9
	dw	1273                            ; 0x4f9
	dw	1289                            ; 0x509
	dw	1304                            ; 0x518
	dw	1319                            ; 0x527
	dw	1335                            ; 0x537
	dw	1353                            ; 0x549
	dw	1368                            ; 0x558
	dw	1382                            ; 0x566
	dw	1398                            ; 0x576
	dw	1414                            ; 0x586
	dw	1427                            ; 0x593
	dw	1441                            ; 0x5a1
	dw	1455                            ; 0x5af
	dw	1471                            ; 0x5bf
	dw	1484                            ; 0x5cc
	dw	1497                            ; 0x5d9
	dw	1511                            ; 0x5e7
	dw	1525                            ; 0x5f5
	dw	1537                            ; 0x601
	dw	1549                            ; 0x60d
	dw	1562                            ; 0x61a
	dw	1575                            ; 0x627
	dw	1585                            ; 0x631
	dw	1596                            ; 0x63c
	dw	1606                            ; 0x646
	dw	1618                            ; 0x652
	dw	1627                            ; 0x65b
	dw	1636                            ; 0x664
	dw	1645                            ; 0x66d
	dw	1654                            ; 0x676
	dw	1661                            ; 0x67d
	dw	1668                            ; 0x684
	dw	1676                            ; 0x68c
	dw	1684                            ; 0x694
	dw	1690                            ; 0x69a
	dw	1697                            ; 0x6a1
	dw	1704                            ; 0x6a8
	dw	1711                            ; 0x6af
	dw	1716                            ; 0x6b4
	dw	1722                            ; 0x6ba
	dw	1728                            ; 0x6c0
	dw	1733                            ; 0x6c5
	dw	1738                            ; 0x6ca
	dw	1743                            ; 0x6cf
	dw	1748                            ; 0x6d4
	dw	1753                            ; 0x6d9
	dw	1757                            ; 0x6dd
	dw	1761                            ; 0x6e1
	dw	1765                            ; 0x6e5
	dw	1769                            ; 0x6e9
	dw	1771                            ; 0x6eb
	dw	1773                            ; 0x6ed
	dw	1775                            ; 0x6ef
	dw	1777                            ; 0x6f1
	dw	1778                            ; 0x6f2
	dw	1779                            ; 0x6f3
	dw	1780                            ; 0x6f4
	dw	1781                            ; 0x6f5
	dw	1782                            ; 0x6f6
	dw	1783                            ; 0x6f7
	dw	1784                            ; 0x6f8
	dw	1785                            ; 0x6f9
	dw	1786                            ; 0x6fa
	dw	1787                            ; 0x6fb
	dw	1789                            ; 0x6fd
	dw	1791                            ; 0x6ff
	dw	1793                            ; 0x701
	dw	1795                            ; 0x703
	dw	1797                            ; 0x705
	dw	1799                            ; 0x707
	dw	1801                            ; 0x709
	dw	1804                            ; 0x70c
	dw	1807                            ; 0x70f
	dw	1810                            ; 0x712
	dw	1813                            ; 0x715
	dw	1816                            ; 0x718
	dw	1820                            ; 0x71c
	dw	1824                            ; 0x720
	dw	1828                            ; 0x724
	dw	1832                            ; 0x728
	dw	1836                            ; 0x72c
	dw	1841                            ; 0x731
	dw	1845                            ; 0x735
	dw	1849                            ; 0x739
	dw	1853                            ; 0x73d
	dw	1858                            ; 0x742
	dw	1863                            ; 0x747
	dw	1868                            ; 0x74c
	dw	1873                            ; 0x751
	dw	1878                            ; 0x756
	dw	1884                            ; 0x75c
	dw	1890                            ; 0x762
	dw	1896                            ; 0x768
	dw	1903                            ; 0x76f
	dw	1909                            ; 0x775
	dw	1916                            ; 0x77c
	dw	1923                            ; 0x783
	dw	1931                            ; 0x78b
	dw	1939                            ; 0x793
	dw	1947                            ; 0x79b
	dw	1955                            ; 0x7a3
	dw	1963                            ; 0x7ab
	dw	1972                            ; 0x7b4
	dw	1981                            ; 0x7bd
	dw	1991                            ; 0x7c7
	dw	2001                            ; 0x7d1
	dw	2011                            ; 0x7db
	dw	2022                            ; 0x7e6
	dw	2033                            ; 0x7f1
	dw	2044                            ; 0x7fc
	dw	2056                            ; 0x808
	dw	2069                            ; 0x815
	dw	2082                            ; 0x822
	dw	2096                            ; 0x830
	dw	2110                            ; 0x83e
	dw	2124                            ; 0x84c
	dw	2137                            ; 0x859
	dw	2152                            ; 0x868
	dw	2166                            ; 0x876
	dw	2182                            ; 0x886
	dw	2196                            ; 0x894
	dw	2212                            ; 0x8a4
	dw	2227                            ; 0x8b3
	dw	2241                            ; 0x8c1
	dw	2255                            ; 0x8cf
	dw	2270                            ; 0x8de
	dw	2283                            ; 0x8eb
	dw	2298                            ; 0x8fa
	dw	2313                            ; 0x909
	dw	2329                            ; 0x919
	dw	2343                            ; 0x927
	dw	2358                            ; 0x936
	dw	2375                            ; 0x947
	dw	2393                            ; 0x959
	dw	2409                            ; 0x969
	dw	2425                            ; 0x979
	dw	2443                            ; 0x98b
	dw	2461                            ; 0x99d
	dw	2476                            ; 0x9ac
	dw	2491                            ; 0x9bb
	dw	2507                            ; 0x9cb
	dw	2523                            ; 0x9db
	dw	2538                            ; 0x9ea
	dw	2556                            ; 0x9fc
	dw	2574                            ; 0xa0e
	dw	2592                            ; 0xa20
	dw	2608                            ; 0xa30
	dw	2624                            ; 0xa40
	dw	2641                            ; 0xa51
	dw	2660                            ; 0xa64
	dw	2676                            ; 0xa74
	dw	2692                            ; 0xa84
	dw	2709                            ; 0xa95
	dw	2727                            ; 0xaa7
	dw	2743                            ; 0xab7
	dw	2759                            ; 0xac7
	dw	2776                            ; 0xad8
	dw	2793                            ; 0xae9
	dw	2808                            ; 0xaf8
	dw	2822                            ; 0xb06
	dw	2837                            ; 0xb15
	dw	2854                            ; 0xb26
	dw	2869                            ; 0xb35
	dw	2882                            ; 0xb42
	dw	2897                            ; 0xb51
	dw	2914                            ; 0xb62
	dw	2929                            ; 0xb71
	dw	2943                            ; 0xb7f
	dw	2959                            ; 0xb8f
	dw	2976                            ; 0xba0
	dw	2990                            ; 0xbae
	dw	3005                            ; 0xbbd
	dw	3021                            ; 0xbcd
	dw	3037                            ; 0xbdd
	dw	3050                            ; 0xbea
	dw	3065                            ; 0xbf9
	dw	3080                            ; 0xc08
	dw	3097                            ; 0xc19
	dw	3112                            ; 0xc28
	dw	3126                            ; 0xc36
	dw	3140                            ; 0xc44
	dw	3157                            ; 0xc55
	dw	3172                            ; 0xc64
	dw	3186                            ; 0xc72
	dw	3201                            ; 0xc81
	dw	3217                            ; 0xc91
	dw	3231                            ; 0xc9f
	dw	3245                            ; 0xcad
	dw	3259                            ; 0xcbb
	dw	3275                            ; 0xccb
	dw	3289                            ; 0xcd9
	dw	3302                            ; 0xce6
	dw	3316                            ; 0xcf4
	dw	3331                            ; 0xd03
	dw	3343                            ; 0xd0f
	dw	3355                            ; 0xd1b
	dw	3367                            ; 0xd27
	dw	3379                            ; 0xd33
	dw	3390                            ; 0xd3e
	dw	3401                            ; 0xd49
	dw	3413                            ; 0xd55
	dw	3424                            ; 0xd60
	dw	3433                            ; 0xd69
	dw	3443                            ; 0xd73
	dw	3454                            ; 0xd7e
	dw	3465                            ; 0xd89
	dw	3475                            ; 0xd93
	dw	3485                            ; 0xd9d
	dw	3495                            ; 0xda7
	dw	3506                            ; 0xdb2
	dw	3515                            ; 0xdbb
	dw	3524                            ; 0xdc4
	dw	3533                            ; 0xdcd
	dw	3542                            ; 0xdd6
	dw	3550                            ; 0xdde
	dw	3558                            ; 0xde6
	dw	3566                            ; 0xdee
	dw	3574                            ; 0xdf6
	dw	3583                            ; 0xdff
	dw	3591                            ; 0xe07
	dw	3600                            ; 0xe10
	dw	3607                            ; 0xe17
	dw	3614                            ; 0xe1e
	dw	3622                            ; 0xe26
	dw	3630                            ; 0xe2e
	dw	3638                            ; 0xe36
	dw	3645                            ; 0xe3d
	dw	3652                            ; 0xe44
	dw	3660                            ; 0xe4c
	dw	3668                            ; 0xe54
	dw	3675                            ; 0xe5b
	dw	3682                            ; 0xe62
	dw	3690                            ; 0xe6a
	dw	3698                            ; 0xe72
	dw	3705                            ; 0xe79
	dw	3712                            ; 0xe80
	dw	3719                            ; 0xe87
	dw	3726                            ; 0xe8e
	dw	3734                            ; 0xe96
	dw	3742                            ; 0xe9e
	dw	3750                            ; 0xea6
	dw	3757                            ; 0xead
	dw	3764                            ; 0xeb4
	dw	3772                            ; 0xebc
	dw	3780                            ; 0xec4
	dw	3788                            ; 0xecc
	dw	3796                            ; 0xed4
	dw	3804                            ; 0xedc
	dw	3812                            ; 0xee4
	dw	3820                            ; 0xeec
	dw	3828                            ; 0xef4
	dw	3836                            ; 0xefc
	dw	3844                            ; 0xf04
	dw	3853                            ; 0xf0d
	dw	3861                            ; 0xf15
	dw	3869                            ; 0xf1d
	dw	3878                            ; 0xf26
	dw	3887                            ; 0xf2f
	dw	3895                            ; 0xf37
	dw	3903                            ; 0xf3f
	dw	3912                            ; 0xf48
	dw	3921                            ; 0xf51
	dw	3930                            ; 0xf5a
	dw	3939                            ; 0xf63
	dw	3948                            ; 0xf6c
	dw	3957                            ; 0xf75
	dw	3965                            ; 0xf7d
	dw	3974                            ; 0xf86
	dw	3983                            ; 0xf8f
	dw	3992                            ; 0xf98
	dw	3993                            ; 0xf99
	dw	3994                            ; 0xf9a
	dw	3995                            ; 0xf9b
	dw	3996                            ; 0xf9c
	dw	3997                            ; 0xf9d
	dw	3998                            ; 0xf9e
	dw	3999                            ; 0xf9f
	dw	4000                            ; 0xfa0
	dw	4001                            ; 0xfa1
	dw	4002                            ; 0xfa2
	dw	4003                            ; 0xfa3
	dw	4004                            ; 0xfa4
	dw	4005                            ; 0xfa5
	dw	4006                            ; 0xfa6
	dw	4007                            ; 0xfa7
	dw	4008                            ; 0xfa8
	dw	4009                            ; 0xfa9
	dw	4010                            ; 0xfaa
	dw	4011                            ; 0xfab
	dw	4012                            ; 0xfac
	dw	4013                            ; 0xfad
	dw	4014                            ; 0xfae
	dw	4015                            ; 0xfaf
	dw	4016                            ; 0xfb0
	dw	4017                            ; 0xfb1
	dw	4018                            ; 0xfb2
	dw	4019                            ; 0xfb3
	dw	4020                            ; 0xfb4
	dw	4021                            ; 0xfb5
	dw	4022                            ; 0xfb6
	dw	4023                            ; 0xfb7
	dw	4024                            ; 0xfb8
	dw	4025                            ; 0xfb9
	dw	4026                            ; 0xfba
	dw	4027                            ; 0xfbb
	dw	4028                            ; 0xfbc
	dw	4029                            ; 0xfbd
	dw	4030                            ; 0xfbe
	dw	4031                            ; 0xfbf
	dw	4032                            ; 0xfc0
	dw	4033                            ; 0xfc1
	dw	4034                            ; 0xfc2
	dw	4035                            ; 0xfc3
	dw	4036                            ; 0xfc4
	dw	4037                            ; 0xfc5
	dw	4038                            ; 0xfc6
	dw	4039                            ; 0xfc7
	dw	4040                            ; 0xfc8
	dw	4041                            ; 0xfc9
	dw	4042                            ; 0xfca
	dw	4043                            ; 0xfcb
	dw	4044                            ; 0xfcc
	dw	4045                            ; 0xfcd
	dw	4046                            ; 0xfce
	dw	4047                            ; 0xfcf
	dw	4048                            ; 0xfd0
	dw	4049                            ; 0xfd1
	dw	4050                            ; 0xfd2
	dw	4051                            ; 0xfd3
	dw	4052                            ; 0xfd4
	dw	4053                            ; 0xfd5
	dw	4054                            ; 0xfd6
	dw	4055                            ; 0xfd7
	dw	4056                            ; 0xfd8
	dw	4057                            ; 0xfd9
	dw	4058                            ; 0xfda
	dw	4059                            ; 0xfdb
	dw	4060                            ; 0xfdc
	dw	4061                            ; 0xfdd
	dw	4062                            ; 0xfde
	dw	4063                            ; 0xfdf
	dw	4064                            ; 0xfe0
	dw	4065                            ; 0xfe1
	dw	4066                            ; 0xfe2
	dw	4067                            ; 0xfe3
	dw	4068                            ; 0xfe4
	dw	4069                            ; 0xfe5
	dw	4070                            ; 0xfe6
	dw	4071                            ; 0xfe7
	dw	4072                            ; 0xfe8
	dw	4073                            ; 0xfe9
	dw	4074                            ; 0xfea
	dw	4075                            ; 0xfeb
	dw	4076                            ; 0xfec
	dw	4077                            ; 0xfed
	dw	4078                            ; 0xfee
	dw	4079                            ; 0xfef
	dw	4080                            ; 0xff0
	dw	4081                            ; 0xff1
	dw	4082                            ; 0xff2
	dw	4083                            ; 0xff3
	dw	4084                            ; 0xff4
	dw	4085                            ; 0xff5
	dw	4086                            ; 0xff6
	dw	4087                            ; 0xff7
	dw	4088                            ; 0xff8
	dw	4089                            ; 0xff9
	dw	4090                            ; 0xffa
	dw	4091                            ; 0xffb
	dw	4092                            ; 0xffc
	dw	4093                            ; 0xffd
	dw	4094                            ; 0xffe
	dw	4095                            ; 0xfff
	dw	4096                            ; 0x1000
	dw	4097                            ; 0x1001
	dw	4098                            ; 0x1002
	dw	4099                            ; 0x1003
	dw	4100                            ; 0x1004
	dw	4101                            ; 0x1005
	dw	4102                            ; 0x1006
	dw	4103                            ; 0x1007
	dw	4104                            ; 0x1008
	dw	4105                            ; 0x1009
	dw	4106                            ; 0x100a
	dw	4107                            ; 0x100b
	dw	4108                            ; 0x100c
	dw	4109                            ; 0x100d
	dw	4110                            ; 0x100e
	dw	4111                            ; 0x100f
	dw	4112                            ; 0x1010
	dw	4113                            ; 0x1011
	dw	4114                            ; 0x1012
	dw	4115                            ; 0x1013
	dw	4116                            ; 0x1014
	dw	4117                            ; 0x1015
	dw	4118                            ; 0x1016
	dw	4119                            ; 0x1017
	dw	4120                            ; 0x1018
	dw	4121                            ; 0x1019
	dw	4122                            ; 0x101a
	dw	4123                            ; 0x101b
	dw	4124                            ; 0x101c
	dw	4125                            ; 0x101d
	dw	4126                            ; 0x101e
	dw	4127                            ; 0x101f
	dw	4128                            ; 0x1020
	dw	4129                            ; 0x1021
	dw	4130                            ; 0x1022
	dw	4131                            ; 0x1023
	dw	4132                            ; 0x1024
	dw	4133                            ; 0x1025
	dw	4134                            ; 0x1026
	dw	4135                            ; 0x1027
	dw	4136                            ; 0x1028
	dw	4137                            ; 0x1029
	dw	4138                            ; 0x102a
	dw	4139                            ; 0x102b
	dw	4140                            ; 0x102c
	dw	4141                            ; 0x102d
	dw	4142                            ; 0x102e
	dw	4143                            ; 0x102f
	dw	4144                            ; 0x1030
	dw	4145                            ; 0x1031
	dw	4146                            ; 0x1032
	dw	4147                            ; 0x1033
	dw	4148                            ; 0x1034
	dw	4149                            ; 0x1035
	dw	4150                            ; 0x1036
	dw	4151                            ; 0x1037
	dw	4152                            ; 0x1038
	dw	4153                            ; 0x1039
	dw	4154                            ; 0x103a
	dw	4155                            ; 0x103b
	dw	4156                            ; 0x103c
	dw	4157                            ; 0x103d
	dw	4158                            ; 0x103e
	dw	4159                            ; 0x103f
	dw	4160                            ; 0x1040
	dw	4161                            ; 0x1041
	dw	4162                            ; 0x1042
	dw	4163                            ; 0x1043
	dw	4164                            ; 0x1044
	dw	4165                            ; 0x1045
	dw	4166                            ; 0x1046
	dw	4167                            ; 0x1047
	dw	4168                            ; 0x1048
	dw	4169                            ; 0x1049
	dw	4170                            ; 0x104a
	dw	4171                            ; 0x104b
	dw	4172                            ; 0x104c
	dw	4173                            ; 0x104d
	dw	4174                            ; 0x104e
	dw	4175                            ; 0x104f
	dw	4176                            ; 0x1050
	dw	4177                            ; 0x1051
	dw	4178                            ; 0x1052
	dw	4179                            ; 0x1053
	dw	4180                            ; 0x1054
	dw	4181                            ; 0x1055
	dw	4182                            ; 0x1056
	dw	4183                            ; 0x1057
	dw	4184                            ; 0x1058
	dw	4185                            ; 0x1059
	dw	4186                            ; 0x105a
	dw	4187                            ; 0x105b
	dw	4188                            ; 0x105c
	dw	4189                            ; 0x105d
	dw	4190                            ; 0x105e
	dw	4191                            ; 0x105f
	dw	4192                            ; 0x1060
	dw	4193                            ; 0x1061
	dw	4194                            ; 0x1062
	dw	4195                            ; 0x1063
	dw	4196                            ; 0x1064
	dw	4197                            ; 0x1065
	dw	4198                            ; 0x1066
	dw	4199                            ; 0x1067
	dw	4200                            ; 0x1068
	dw	4201                            ; 0x1069
	dw	4202                            ; 0x106a
	dw	4203                            ; 0x106b
	dw	4204                            ; 0x106c
	dw	4205                            ; 0x106d
	dw	4206                            ; 0x106e
	dw	4207                            ; 0x106f
	dw	4208                            ; 0x1070
	dw	4209                            ; 0x1071
	dw	4210                            ; 0x1072
	dw	4211                            ; 0x1073
	dw	4212                            ; 0x1074
	dw	4213                            ; 0x1075
	dw	4214                            ; 0x1076
	dw	4215                            ; 0x1077
	dw	4216                            ; 0x1078
	dw	4217                            ; 0x1079
	dw	4218                            ; 0x107a
	dw	4219                            ; 0x107b
	dw	4220                            ; 0x107c
	dw	4221                            ; 0x107d
	dw	4222                            ; 0x107e
	dw	4223                            ; 0x107f
	dw	4224                            ; 0x1080
	dw	4225                            ; 0x1081
	dw	4226                            ; 0x1082
	dw	4227                            ; 0x1083
	dw	4228                            ; 0x1084
	dw	4229                            ; 0x1085
	dw	4230                            ; 0x1086
	dw	4231                            ; 0x1087
	dw	4232                            ; 0x1088
	dw	4233                            ; 0x1089
	dw	4234                            ; 0x108a
	dw	4235                            ; 0x108b
	dw	4236                            ; 0x108c
	dw	4237                            ; 0x108d
	dw	4238                            ; 0x108e
	dw	4239                            ; 0x108f
	dw	4240                            ; 0x1090
	dw	4241                            ; 0x1091
	dw	4242                            ; 0x1092
	dw	4243                            ; 0x1093
	dw	4244                            ; 0x1094
	dw	4245                            ; 0x1095
	dw	4246                            ; 0x1096
	dw	4247                            ; 0x1097
	dw	4248                            ; 0x1098
	dw	4249                            ; 0x1099
	dw	4250                            ; 0x109a
	dw	4251                            ; 0x109b
	dw	4252                            ; 0x109c
	dw	4253                            ; 0x109d
	dw	4254                            ; 0x109e
	dw	4256                            ; 0x10a0
	dw	4258                            ; 0x10a2
	dw	4260                            ; 0x10a4
	dw	4262                            ; 0x10a6
	dw	4264                            ; 0x10a8
	dw	4266                            ; 0x10aa
	dw	4268                            ; 0x10ac
	dw	4271                            ; 0x10af
	dw	4274                            ; 0x10b2
	dw	4277                            ; 0x10b5
	dw	4280                            ; 0x10b8
	dw	4283                            ; 0x10bb
	dw	4287                            ; 0x10bf
	dw	4291                            ; 0x10c3
	dw	4295                            ; 0x10c7
	dw	4299                            ; 0x10cb
	dw	4303                            ; 0x10cf
	dw	4308                            ; 0x10d4
	dw	4313                            ; 0x10d9
	dw	4318                            ; 0x10de
	dw	4324                            ; 0x10e4
	dw	4330                            ; 0x10ea
	dw	4336                            ; 0x10f0
	dw	4343                            ; 0x10f7
	dw	4350                            ; 0x10fe
	dw	4356                            ; 0x1104
	dw	4364                            ; 0x110c
	dw	4371                            ; 0x1113
	dw	4379                            ; 0x111b
	dw	4386                            ; 0x1122
	dw	4395                            ; 0x112b
	dw	4403                            ; 0x1133
	dw	4412                            ; 0x113c
	dw	4421                            ; 0x1145
	dw	4431                            ; 0x114f
	dw	4441                            ; 0x1159
	dw	4450                            ; 0x1162
	dw	4460                            ; 0x116c
	dw	4470                            ; 0x1176
	dw	4482                            ; 0x1182
	dw	4493                            ; 0x118d
	dw	4505                            ; 0x1199
	dw	4517                            ; 0x11a5
	dw	4529                            ; 0x11b1
	dw	4541                            ; 0x11bd
	dw	4555                            ; 0x11cb
	dw	4568                            ; 0x11d8
	dw	4583                            ; 0x11e7
	dw	4598                            ; 0x11f6
	dw	4614                            ; 0x1206
	dw	4629                            ; 0x1215
	dw	4644                            ; 0x1224
	dw	4659                            ; 0x1233
	dw	4674                            ; 0x1242
	dw	4689                            ; 0x1251
	dw	4704                            ; 0x1260
	dw	4721                            ; 0x1271
	dw	4737                            ; 0x1281
	dw	4752                            ; 0x1290
	dw	4767                            ; 0x129f
	dw	4783                            ; 0x12af
	dw	4799                            ; 0x12bf
	dw	4812                            ; 0x12cc
	dw	4826                            ; 0x12da
	dw	4841                            ; 0x12e9
	dw	4858                            ; 0x12fa
	dw	4872                            ; 0x1308
	dw	4887                            ; 0x1317
	dw	4902                            ; 0x1326
	dw	4918                            ; 0x1336
	dw	4932                            ; 0x1344
	dw	4945                            ; 0x1351
	dw	4959                            ; 0x135f
	dw	4976                            ; 0x1370
	dw	4991                            ; 0x137f
	dw	5005                            ; 0x138d
	dw	5021                            ; 0x139d
	dw	5037                            ; 0x13ad
	dw	5052                            ; 0x13bc
	dw	5066                            ; 0x13ca
	dw	5082                            ; 0x13da
	dw	5098                            ; 0x13ea
	dw	5111                            ; 0x13f7
	dw	5125                            ; 0x1405
	dw	5140                            ; 0x1414
	dw	5157                            ; 0x1425
	dw	5172                            ; 0x1434
	dw	5186                            ; 0x1442
	dw	5202                            ; 0x1452
	dw	5219                            ; 0x1463
	dw	5234                            ; 0x1472
	dw	5247                            ; 0x147f
	dw	5263                            ; 0x148f
	dw	5279                            ; 0x149f
	dw	5294                            ; 0x14ae
	dw	5308                            ; 0x14bc
	dw	5324                            ; 0x14cc
	dw	5341                            ; 0x14dd
	dw	5356                            ; 0x14ec
	dw	5370                            ; 0x14fa
	dw	5385                            ; 0x1509
	dw	5402                            ; 0x151a
	dw	5417                            ; 0x1529
	dw	5430                            ; 0x1536
	dw	5446                            ; 0x1546
	dw	5463                            ; 0x1557
	dw	5477                            ; 0x1565
	dw	5491                            ; 0x1573
	dw	5506                            ; 0x1582
	dw	5522                            ; 0x1592
	dw	5537                            ; 0x15a1
	dw	5551                            ; 0x15af
	dw	5566                            ; 0x15be
	dw	5582                            ; 0x15ce
	dw	5597                            ; 0x15dd
	dw	5611                            ; 0x15eb
	dw	5626                            ; 0x15fa
	dw	5643                            ; 0x160b
	dw	5658                            ; 0x161a
	dw	5672                            ; 0x1628
	dw	5688                            ; 0x1638
	dw	5704                            ; 0x1648
	dw	5719                            ; 0x1657
	dw	5733                            ; 0x1665
	dw	5748                            ; 0x1674
	dw	5764                            ; 0x1684
	dw	5778                            ; 0x1692
	dw	5792                            ; 0x16a0
	dw	5807                            ; 0x16af
	dw	5822                            ; 0x16be
	dw	5836                            ; 0x16cc
	dw	5849                            ; 0x16d9
	dw	5862                            ; 0x16e6
	dw	5876                            ; 0x16f4
	dw	5889                            ; 0x1701
	dw	5902                            ; 0x170e
	dw	5915                            ; 0x171b
	dw	5928                            ; 0x1728
	dw	5938                            ; 0x1732
	dw	5950                            ; 0x173e
	dw	5962                            ; 0x174a
	dw	5975                            ; 0x1757
	dw	5986                            ; 0x1762
	dw	5997                            ; 0x176d
	dw	6007                            ; 0x1777
	dw	6019                            ; 0x1783
	dw	6029                            ; 0x178d
	dw	6039                            ; 0x1797
	dw	6050                            ; 0x17a2
	dw	6061                            ; 0x17ad
	dw	6069                            ; 0x17b5
	dw	6077                            ; 0x17bd
	dw	6085                            ; 0x17c5
	dw	6094                            ; 0x17ce
	dw	6101                            ; 0x17d5
	dw	6108                            ; 0x17dc
	dw	6115                            ; 0x17e3
	dw	6122                            ; 0x17ea
	dw	6128                            ; 0x17f0
	dw	6134                            ; 0x17f6
	dw	6141                            ; 0x17fd
	dw	6147                            ; 0x1803
	dw	6152                            ; 0x1808
	dw	6157                            ; 0x180d
	dw	6162                            ; 0x1812
	dw	6167                            ; 0x1817
	dw	6171                            ; 0x181b
	dw	6176                            ; 0x1820
	dw	6181                            ; 0x1825
	dw	6186                            ; 0x182a
	dw	6190                            ; 0x182e
	dw	6194                            ; 0x1832
	dw	6198                            ; 0x1836
	dw	6202                            ; 0x183a
	dw	6205                            ; 0x183d
	dw	6209                            ; 0x1841
	dw	6213                            ; 0x1845
	dw	6218                            ; 0x184a
	dw	6222                            ; 0x184e
	dw	6226                            ; 0x1852
	dw	6230                            ; 0x1856
	dw	6234                            ; 0x185a
	dw	6238                            ; 0x185e
	dw	6242                            ; 0x1862
	dw	6246                            ; 0x1866
	dw	6250                            ; 0x186a
	dw	6253                            ; 0x186d
	dw	6256                            ; 0x1870
	dw	6259                            ; 0x1873
	dw	6263                            ; 0x1877
	dw	6267                            ; 0x187b
	dw	6271                            ; 0x187f
	dw	6275                            ; 0x1883
	dw	6279                            ; 0x1887
	dw	6283                            ; 0x188b
	dw	6287                            ; 0x188f
	dw	6291                            ; 0x1893
	dw	6294                            ; 0x1896
	dw	6298                            ; 0x189a
	dw	6302                            ; 0x189e
	dw	6306                            ; 0x18a2
	dw	6311                            ; 0x18a7
	dw	6316                            ; 0x18ac
	dw	6321                            ; 0x18b1
	dw	6326                            ; 0x18b6
	dw	6331                            ; 0x18bb
	dw	6336                            ; 0x18c0
	dw	6341                            ; 0x18c5
	dw	6346                            ; 0x18ca
	dw	6352                            ; 0x18d0
	dw	6357                            ; 0x18d5
	dw	6362                            ; 0x18da
	dw	6367                            ; 0x18df
	dw	6372                            ; 0x18e4
	dw	6377                            ; 0x18e9
	dw	6383                            ; 0x18ef
	dw	6389                            ; 0x18f5
	dw	6395                            ; 0x18fb
	dw	6401                            ; 0x1901
	dw	6407                            ; 0x1907
	dw	6412                            ; 0x190c
	dw	6418                            ; 0x1912
	dw	6424                            ; 0x1918
	dw	6430                            ; 0x191e
	dw	6436                            ; 0x1924
	dw	6443                            ; 0x192b
	dw	6450                            ; 0x1932
	dw	6457                            ; 0x1939
	dw	6464                            ; 0x1940
	dw	6471                            ; 0x1947
	dw	6478                            ; 0x194e
	dw	6485                            ; 0x1955
	dw	6492                            ; 0x195c
	dw	6499                            ; 0x1963
	dw	6506                            ; 0x196a
	dw	6514                            ; 0x1972
	dw	6522                            ; 0x197a
	dw	6529                            ; 0x1981
	dw	6537                            ; 0x1989
	dw	6545                            ; 0x1991
	dw	6553                            ; 0x1999
	dw	6561                            ; 0x19a1
	dw	6569                            ; 0x19a9
	dw	6577                            ; 0x19b1
	dw	6586                            ; 0x19ba
	dw	6594                            ; 0x19c2
	dw	6603                            ; 0x19cb
	dw	6612                            ; 0x19d4
	dw	6621                            ; 0x19dd
	dw	6630                            ; 0x19e6
	dw	6639                            ; 0x19ef
	dw	6648                            ; 0x19f8
	dw	6657                            ; 0x1a01
	dw	6666                            ; 0x1a0a
	dw	6675                            ; 0x1a13
	dw	6685                            ; 0x1a1d
	dw	6695                            ; 0x1a27
	dw	6705                            ; 0x1a31
	dw	6715                            ; 0x1a3b
	dw	6725                            ; 0x1a45
	dw	6736                            ; 0x1a50
	dw	6747                            ; 0x1a5b
	dw	6758                            ; 0x1a66
	dw	6769                            ; 0x1a71
	dw	6781                            ; 0x1a7d
	dw	6793                            ; 0x1a89
	dw	6804                            ; 0x1a94
	dw	6815                            ; 0x1a9f
	dw	6827                            ; 0x1aab
	dw	6839                            ; 0x1ab7
	dw	6850                            ; 0x1ac2
	dw	6862                            ; 0x1ace
	dw	6875                            ; 0x1adb
	dw	6888                            ; 0x1ae8
	dw	6900                            ; 0x1af4
	dw	6911                            ; 0x1aff
	dw	6922                            ; 0x1b0a
	dw	6934                            ; 0x1b16
	dw	6945                            ; 0x1b21
	dw	6957                            ; 0x1b2d
	dw	6969                            ; 0x1b39
	dw	6982                            ; 0x1b46
	dw	6993                            ; 0x1b51
	dw	7005                            ; 0x1b5d
	dw	7017                            ; 0x1b69
	dw	7029                            ; 0x1b75
	dw	7041                            ; 0x1b81
	dw	7053                            ; 0x1b8d
	dw	7065                            ; 0x1b99
	dw	7077                            ; 0x1ba5
	dw	7088                            ; 0x1bb0
	dw	7099                            ; 0x1bbb
	dw	7111                            ; 0x1bc7
	dw	7122                            ; 0x1bd2
	dw	7133                            ; 0x1bdd
	dw	7145                            ; 0x1be9
	dw	7156                            ; 0x1bf4
	dw	7167                            ; 0x1bff
	dw	7178                            ; 0x1c0a
	dw	7189                            ; 0x1c15
	dw	7201                            ; 0x1c21
	dw	7214                            ; 0x1c2e
	dw	7225                            ; 0x1c39
	dw	7235                            ; 0x1c43
	dw	7246                            ; 0x1c4e
	dw	7258                            ; 0x1c5a
	dw	7268                            ; 0x1c64
	dw	7278                            ; 0x1c6e
	dw	7288                            ; 0x1c78
	dw	7299                            ; 0x1c83
	dw	7308                            ; 0x1c8c
	dw	7318                            ; 0x1c96
	dw	7328                            ; 0x1ca0
	dw	7339                            ; 0x1cab
	dw	7348                            ; 0x1cb4
	dw	7357                            ; 0x1cbd
	dw	7367                            ; 0x1cc7
	dw	7376                            ; 0x1cd0
	dw	7384                            ; 0x1cd8
	dw	7392                            ; 0x1ce0
	dw	7400                            ; 0x1ce8
	dw	7408                            ; 0x1cf0
	dw	7414                            ; 0x1cf6
	dw	7420                            ; 0x1cfc
	dw	7426                            ; 0x1d02
	dw	7432                            ; 0x1d08
	dw	7437                            ; 0x1d0d
	dw	7442                            ; 0x1d12
	dw	7448                            ; 0x1d18
	dw	7453                            ; 0x1d1d
	dw	7458                            ; 0x1d22
	dw	7463                            ; 0x1d27
	dw	7469                            ; 0x1d2d
	dw	7474                            ; 0x1d32
	dw	7478                            ; 0x1d36
	dw	7482                            ; 0x1d3a
	dw	7486                            ; 0x1d3e
	dw	7490                            ; 0x1d42
	dw	7494                            ; 0x1d46
	dw	7498                            ; 0x1d4a
	dw	7503                            ; 0x1d4f
	dw	7507                            ; 0x1d53
	dw	7510                            ; 0x1d56
	dw	7513                            ; 0x1d59
	dw	7516                            ; 0x1d5c
	dw	7519                            ; 0x1d5f
	dw	7523                            ; 0x1d63
	dw	7527                            ; 0x1d67
	dw	7531                            ; 0x1d6b
	dw	7535                            ; 0x1d6f
	dw	7538                            ; 0x1d72
	dw	7541                            ; 0x1d75
	dw	7544                            ; 0x1d78
	dw	7547                            ; 0x1d7b
	dw	7550                            ; 0x1d7e
	dw	7553                            ; 0x1d81
	dw	7556                            ; 0x1d84
	dw	7559                            ; 0x1d87
	dw	7562                            ; 0x1d8a
	dw	7565                            ; 0x1d8d
	dw	7568                            ; 0x1d90
	dw	7571                            ; 0x1d93
	dw	7574                            ; 0x1d96
	dw	7577                            ; 0x1d99
	dw	7580                            ; 0x1d9c
	dw	7583                            ; 0x1d9f
	dw	7586                            ; 0x1da2
	dw	7589                            ; 0x1da5
	dw	7592                            ; 0x1da8
	dw	7595                            ; 0x1dab
	dw	7598                            ; 0x1dae
	dw	7601                            ; 0x1db1
	dw	7604                            ; 0x1db4
	dw	7607                            ; 0x1db7
	dw	7610                            ; 0x1dba
	dw	7614                            ; 0x1dbe
	dw	7617                            ; 0x1dc1
	dw	7620                            ; 0x1dc4
	dw	7624                            ; 0x1dc8
	dw	7628                            ; 0x1dcc
	dw	7632                            ; 0x1dd0
	dw	7636                            ; 0x1dd4
	dw	7640                            ; 0x1dd8
	dw	7644                            ; 0x1ddc
	dw	7649                            ; 0x1de1
	dw	7653                            ; 0x1de5
	dw	7657                            ; 0x1de9
	dw	7661                            ; 0x1ded
	dw	7664                            ; 0x1df0
	dw	7667                            ; 0x1df3
	dw	7671                            ; 0x1df7
	dw	7675                            ; 0x1dfb
	dw	7680                            ; 0x1e00
	dw	7685                            ; 0x1e05
	dw	7690                            ; 0x1e0a
	dw	7696                            ; 0x1e10
	dw	7702                            ; 0x1e16
	dw	7708                            ; 0x1e1c
	dw	7713                            ; 0x1e21
	dw	7718                            ; 0x1e26
	dw	7723                            ; 0x1e2b
	dw	7729                            ; 0x1e31
	dw	7734                            ; 0x1e36
	dw	7739                            ; 0x1e3b
	dw	7745                            ; 0x1e41
	dw	7751                            ; 0x1e47
	dw	7756                            ; 0x1e4c
	dw	7761                            ; 0x1e51
	dw	7766                            ; 0x1e56
	dw	7771                            ; 0x1e5b
	dw	7776                            ; 0x1e60
	dw	7782                            ; 0x1e66
	dw	7788                            ; 0x1e6c
	dw	7794                            ; 0x1e72
	dw	7800                            ; 0x1e78
	dw	7806                            ; 0x1e7e
	dw	7811                            ; 0x1e83
	dw	7817                            ; 0x1e89
	dw	7823                            ; 0x1e8f
	dw	7830                            ; 0x1e96
	dw	7837                            ; 0x1e9d
	dw	7844                            ; 0x1ea4
	dw	7850                            ; 0x1eaa
	dw	7857                            ; 0x1eb1
	dw	7864                            ; 0x1eb8
	dw	7871                            ; 0x1ebf
	dw	7877                            ; 0x1ec5
	dw	7884                            ; 0x1ecc
	dw	7891                            ; 0x1ed3
	dw	7898                            ; 0x1eda
	dw	7905                            ; 0x1ee1
	dw	7912                            ; 0x1ee8
	dw	7919                            ; 0x1eef
	dw	7926                            ; 0x1ef6
	dw	7934                            ; 0x1efe
	dw	7942                            ; 0x1f06
	dw	7950                            ; 0x1f0e
	dw	7958                            ; 0x1f16
	dw	7966                            ; 0x1f1e
	dw	7975                            ; 0x1f27
	dw	7984                            ; 0x1f30
	dw	7993                            ; 0x1f39
	dw	8001                            ; 0x1f41
	dw	8010                            ; 0x1f4a
	dw	8019                            ; 0x1f53
	dw	8028                            ; 0x1f5c
	dw	8038                            ; 0x1f66
	dw	8048                            ; 0x1f70
	dw	8058                            ; 0x1f7a
	dw	8068                            ; 0x1f84
	dw	8078                            ; 0x1f8e
	dw	8088                            ; 0x1f98
	dw	8099                            ; 0x1fa3
	dw	8111                            ; 0x1faf
	dw	8123                            ; 0x1fbb
	dw	8136                            ; 0x1fc8
	dw	8148                            ; 0x1fd4
	dw	8161                            ; 0x1fe1
	dw	8172                            ; 0x1fec
	dw	8185                            ; 0x1ff9
	dw	8197                            ; 0x2005
	dw	8210                            ; 0x2012
	dw	8223                            ; 0x201f
	dw	8237                            ; 0x202d
	dw	8251                            ; 0x203b
	dw	8265                            ; 0x2049
	dw	8278                            ; 0x2056
	dw	8291                            ; 0x2063
	dw	8305                            ; 0x2071
	dw	8319                            ; 0x207f
	dw	8334                            ; 0x208e
	dw	8350                            ; 0x209e
	dw	8365                            ; 0x20ad
	dw	8381                            ; 0x20bd
	dw	8395                            ; 0x20cb
	dw	8408                            ; 0x20d8
	dw	8421                            ; 0x20e5
	dw	8436                            ; 0x20f4
	dw	8450                            ; 0x2102
	dw	8464                            ; 0x2110
	dw	8478                            ; 0x211e
	dw	8493                            ; 0x212d
	dw	8508                            ; 0x213c
	dw	8523                            ; 0x214b
	dw	8539                            ; 0x215b
	dw	8555                            ; 0x216b
	dw	8569                            ; 0x2179
	dw	8584                            ; 0x2188
	dw	8600                            ; 0x2198
	dw	8616                            ; 0x21a8
	dw	8632                            ; 0x21b8
	dw	8646                            ; 0x21c6
	dw	8661                            ; 0x21d5
	dw	8677                            ; 0x21e5
	dw	8691                            ; 0x21f3
	dw	8705                            ; 0x2201
	dw	8721                            ; 0x2211
	dw	8738                            ; 0x2222
	dw	8752                            ; 0x2230
	dw	8765                            ; 0x223d
	dw	8780                            ; 0x224c
	dw	8794                            ; 0x225a
	dw	8807                            ; 0x2267
	dw	8822                            ; 0x2276
	dw	8838                            ; 0x2286
	dw	8854                            ; 0x2296
	dw	8868                            ; 0x22a4
	dw	8882                            ; 0x22b2
	dw	8897                            ; 0x22c1
	dw	8913                            ; 0x22d1
	dw	8927                            ; 0x22df
	dw	8941                            ; 0x22ed
	dw	8957                            ; 0x22fd
	dw	8973                            ; 0x230d
	dw	8986                            ; 0x231a
	dw	9000                            ; 0x2328
	dw	9015                            ; 0x2337
	dw	9030                            ; 0x2346
	dw	9044                            ; 0x2354
	dw	9058                            ; 0x2362
	dw	9072                            ; 0x2370
	dw	9087                            ; 0x237f
	dw	9100                            ; 0x238c
	dw	9115                            ; 0x239b
	dw	9130                            ; 0x23aa
	dw	9147                            ; 0x23bb
	dw	9161                            ; 0x23c9
	dw	9175                            ; 0x23d7
	dw	9190                            ; 0x23e6
	dw	9206                            ; 0x23f6
	dw	9220                            ; 0x2404
	dw	9235                            ; 0x2413
	dw	9251                            ; 0x2423
	dw	9268                            ; 0x2434
	dw	9281                            ; 0x2441
	dw	9294                            ; 0x244e
	dw	9307                            ; 0x245b
	dw	9322                            ; 0x246a
	dw	9335                            ; 0x2477
	dw	9350                            ; 0x2486
	dw	9366                            ; 0x2496
	dw	9381                            ; 0x24a5
	dw	9395                            ; 0x24b3
	dw	9408                            ; 0x24c0
	dw	9422                            ; 0x24ce
	dw	9437                            ; 0x24dd
	dw	9451                            ; 0x24eb
	dw	9464                            ; 0x24f8
	dw	9478                            ; 0x2506
	dw	9493                            ; 0x2515
	dw	9506                            ; 0x2522
	dw	9518                            ; 0x252e
	dw	9532                            ; 0x253c
	dw	9546                            ; 0x254a
	dw	9557                            ; 0x2555
	dw	9568                            ; 0x2560
	dw	9581                            ; 0x256d
	dw	9594                            ; 0x257a
	dw	9605                            ; 0x2585
	dw	9618                            ; 0x2592
	dw	9631                            ; 0x259f
	dw	9644                            ; 0x25ac
	dw	9654                            ; 0x25b6
	dw	9664                            ; 0x25c0
	dw	9675                            ; 0x25cb
	dw	9686                            ; 0x25d6
	dw	9695                            ; 0x25df
	dw	9705                            ; 0x25e9
	dw	9715                            ; 0x25f3
	dw	9725                            ; 0x25fd
	dw	9732                            ; 0x2604
	dw	9740                            ; 0x260c
	dw	9749                            ; 0x2615
	dw	9757                            ; 0x261d
	dw	9763                            ; 0x2623
	dw	9769                            ; 0x2629
	dw	9775                            ; 0x262f
	dw	9781                            ; 0x2635
	dw	9787                            ; 0x263b
	dw	9793                            ; 0x2641
	dw	9799                            ; 0x2647
	dw	9805                            ; 0x264d
	dw	9812                            ; 0x2654
	dw	9819                            ; 0x265b
	dw	9826                            ; 0x2662
	dw	9833                            ; 0x2669
	dw	9839                            ; 0x266f
	dw	9845                            ; 0x2675
	dw	9852                            ; 0x267c
	dw	9858                            ; 0x2682
	dw	9864                            ; 0x2688
	dw	9870                            ; 0x268e
	dw	9876                            ; 0x2694
	dw	9882                            ; 0x269a
	dw	9887                            ; 0x269f
	dw	9892                            ; 0x26a4
	dw	9897                            ; 0x26a9
	dw	9902                            ; 0x26ae
	dw	9906                            ; 0x26b2
	dw	9910                            ; 0x26b6
	dw	9914                            ; 0x26ba
	dw	9918                            ; 0x26be
	dw	9922                            ; 0x26c2
	dw	9926                            ; 0x26c6
	dw	9930                            ; 0x26ca
	dw	9934                            ; 0x26ce
	dw	9938                            ; 0x26d2
	dw	9942                            ; 0x26d6
	dw	9946                            ; 0x26da
	dw	9950                            ; 0x26de
	dw	9954                            ; 0x26e2
	dw	9958                            ; 0x26e6
	dw	9962                            ; 0x26ea
	dw	9966                            ; 0x26ee
	dw	9970                            ; 0x26f2
	dw	9974                            ; 0x26f6
	dw	9978                            ; 0x26fa
	dw	9981                            ; 0x26fd
	dw	9984                            ; 0x2700
	dw	9987                            ; 0x2703
	dw	9990                            ; 0x2706
	dw	9993                            ; 0x2709
	dw	9996                            ; 0x270c
	dw	9999                            ; 0x270f
	dw	10002                           ; 0x2712
	dw	10005                           ; 0x2715
	dw	10007                           ; 0x2717
	dw	10009                           ; 0x2719
	dw	10011                           ; 0x271b
	dw	10013                           ; 0x271d
	dw	10015                           ; 0x271f
	dw	10017                           ; 0x2721
	dw	10020                           ; 0x2724
	dw	10024                           ; 0x2728
	dw	10027                           ; 0x272b
	dw	10030                           ; 0x272e
	dw	10033                           ; 0x2731
	dw	10036                           ; 0x2734
	dw	10039                           ; 0x2737
	dw	10042                           ; 0x273a
	dw	10045                           ; 0x273d
	dw	10048                           ; 0x2740
	dw	10051                           ; 0x2743
	dw	10055                           ; 0x2747
	dw	10059                           ; 0x274b
	dw	10063                           ; 0x274f
	dw	10067                           ; 0x2753
	dw	10071                           ; 0x2757
	dw	10075                           ; 0x275b
	dw	10079                           ; 0x275f
	dw	10083                           ; 0x2763
	dw	10087                           ; 0x2767
	dw	10092                           ; 0x276c
	dw	10097                           ; 0x2771
	dw	10102                           ; 0x2776
	dw	10107                           ; 0x277b
	dw	10112                           ; 0x2780
	dw	10117                           ; 0x2785
	dw	10122                           ; 0x278a
	dw	10128                           ; 0x2790
	dw	10134                           ; 0x2796
	dw	10140                           ; 0x279c
	dw	10147                           ; 0x27a3
	dw	10154                           ; 0x27aa
	dw	10160                           ; 0x27b0
	dw	10168                           ; 0x27b8
	dw	10176                           ; 0x27c0
	dw	10184                           ; 0x27c8
	dw	10193                           ; 0x27d1
	dw	10202                           ; 0x27da
	dw	10211                           ; 0x27e3
	dw	10220                           ; 0x27ec
	dw	10229                           ; 0x27f5
	dw	10238                           ; 0x27fe
	dw	10247                           ; 0x2807
	dw	10257                           ; 0x2811
	dw	10267                           ; 0x281b
	dw	10277                           ; 0x2825
	dw	10288                           ; 0x2830
	dw	10298                           ; 0x283a
	dw	10308                           ; 0x2844
	dw	10319                           ; 0x284f
	dw	10330                           ; 0x285a
	dw	10343                           ; 0x2867
	dw	10355                           ; 0x2873
	dw	10367                           ; 0x287f
	dw	10378                           ; 0x288a
	dw	10391                           ; 0x2897
	dw	10402                           ; 0x28a2
	dw	10416                           ; 0x28b0
	dw	10428                           ; 0x28bc
	dw	10441                           ; 0x28c9
	dw	10453                           ; 0x28d5
	dw	10467                           ; 0x28e3
	dw	10480                           ; 0x28f0
	dw	10494                           ; 0x28fe
	dw	10509                           ; 0x290d
	dw	10525                           ; 0x291d
	dw	10541                           ; 0x292d
	dw	10558                           ; 0x293e
	dw	10574                           ; 0x294e
	dw	10590                           ; 0x295e
	dw	10607                           ; 0x296f
	dw	10626                           ; 0x2982
	dw	10644                           ; 0x2994
	dw	10663                           ; 0x29a7
	dw	10681                           ; 0x29b9
	dw	10702                           ; 0x29ce
	dw	10723                           ; 0x29e3
	dw	10744                           ; 0x29f8
	dw	10763                           ; 0x2a0b
	dw	10783                           ; 0x2a1f
	dw	10803                           ; 0x2a33
	dw	10825                           ; 0x2a49
	dw	10844                           ; 0x2a5c
	dw	10864                           ; 0x2a70
	dw	10884                           ; 0x2a84
	dw	10907                           ; 0x2a9b
	dw	10925                           ; 0x2aad
	dw	10943                           ; 0x2abf
	dw	10960                           ; 0x2ad0
	dw	10979                           ; 0x2ae3
	dw	10994                           ; 0x2af2
	dw	11009                           ; 0x2b01
	dw	11025                           ; 0x2b11
	dw	11044                           ; 0x2b24
	dw	11056                           ; 0x2b30
	dw	11069                           ; 0x2b3d
	dw	11083                           ; 0x2b4b
	dw	11099                           ; 0x2b5b
	dw	11111                           ; 0x2b67
	dw	11125                           ; 0x2b75
	dw	11140                           ; 0x2b84
	dw	11157                           ; 0x2b95
	dw	11169                           ; 0x2ba1
	dw	11181                           ; 0x2bad
	dw	11194                           ; 0x2bba
	dw	11209                           ; 0x2bc9
	dw	11221                           ; 0x2bd5
	dw	11233                           ; 0x2be1
	dw	11247                           ; 0x2bef
	dw	11262                           ; 0x2bfe
	dw	11274                           ; 0x2c0a
	dw	11285                           ; 0x2c15
	dw	11297                           ; 0x2c21
	dw	11309                           ; 0x2c2d
	dw	11318                           ; 0x2c36
	dw	11327                           ; 0x2c3f
	dw	11337                           ; 0x2c49
	dw	11348                           ; 0x2c54
	dw	11357                           ; 0x2c5d
	dw	11365                           ; 0x2c65
	dw	11373                           ; 0x2c6d
	dw	11382                           ; 0x2c76
	dw	11389                           ; 0x2c7d
	dw	11396                           ; 0x2c84
	dw	11403                           ; 0x2c8b
	dw	11410                           ; 0x2c92
	dw	11415                           ; 0x2c97
	dw	11419                           ; 0x2c9b
	dw	11423                           ; 0x2c9f
	dw	11427                           ; 0x2ca3
	dw	11430                           ; 0x2ca6
	dw	11433                           ; 0x2ca9
	dw	11436                           ; 0x2cac
	dw	11439                           ; 0x2caf
	dw	11442                           ; 0x2cb2
	dw	11445                           ; 0x2cb5
	dw	11448                           ; 0x2cb8
	dw	11451                           ; 0x2cbb
	dw	11454                           ; 0x2cbe
	dw	11457                           ; 0x2cc1
	dw	11460                           ; 0x2cc4
	dw	11463                           ; 0x2cc7
	dw	11466                           ; 0x2cca
	dw	11469                           ; 0x2ccd
	dw	11472                           ; 0x2cd0
	dw	11475                           ; 0x2cd3
	dw	11478                           ; 0x2cd6
	dw	11481                           ; 0x2cd9
	dw	11484                           ; 0x2cdc
	dw	11487                           ; 0x2cdf
	dw	11489                           ; 0x2ce1
	dw	11491                           ; 0x2ce3
	dw	11493                           ; 0x2ce5
	dw	11495                           ; 0x2ce7
	dw	11497                           ; 0x2ce9
	dw	11499                           ; 0x2ceb
	dw	11501                           ; 0x2ced
	dw	11503                           ; 0x2cef
	dw	11505                           ; 0x2cf1
	dw	11507                           ; 0x2cf3
	dw	11509                           ; 0x2cf5
	dw	11511                           ; 0x2cf7
	dw	11513                           ; 0x2cf9
	dw	11516                           ; 0x2cfc
	dw	11519                           ; 0x2cff
	dw	11522                           ; 0x2d02
	dw	11525                           ; 0x2d05
	dw	11528                           ; 0x2d08
	dw	11531                           ; 0x2d0b
	dw	11534                           ; 0x2d0e
	dw	11537                           ; 0x2d11
	dw	11540                           ; 0x2d14
	dw	11544                           ; 0x2d18
	dw	11548                           ; 0x2d1c
	dw	11552                           ; 0x2d20
	dw	11556                           ; 0x2d24
	dw	11560                           ; 0x2d28
	dw	11564                           ; 0x2d2c
	dw	11568                           ; 0x2d30
	dw	11572                           ; 0x2d34
	dw	11575                           ; 0x2d37
	dw	11579                           ; 0x2d3b
	dw	11583                           ; 0x2d3f
	dw	11586                           ; 0x2d42
	dw	11590                           ; 0x2d46
	dw	11594                           ; 0x2d4a
	dw	11598                           ; 0x2d4e
	dw	11602                           ; 0x2d52
	dw	11606                           ; 0x2d56
	dw	11610                           ; 0x2d5a
	dw	11614                           ; 0x2d5e
	dw	11618                           ; 0x2d62
	dw	11622                           ; 0x2d66
	dw	11626                           ; 0x2d6a
	dw	11629                           ; 0x2d6d
	dw	11632                           ; 0x2d70
	dw	11636                           ; 0x2d74
	dw	11640                           ; 0x2d78
	dw	11644                           ; 0x2d7c
	dw	11648                           ; 0x2d80
	dw	11652                           ; 0x2d84
	dw	11656                           ; 0x2d88
	dw	11660                           ; 0x2d8c
	dw	11664                           ; 0x2d90
	dw	11669                           ; 0x2d95
	dw	11674                           ; 0x2d9a
	dw	11679                           ; 0x2d9f
	dw	11684                           ; 0x2da4
	dw	11689                           ; 0x2da9
	dw	11694                           ; 0x2dae
	dw	11698                           ; 0x2db2
	dw	11702                           ; 0x2db6
	dw	11706                           ; 0x2dba
	dw	11710                           ; 0x2dbe
	dw	11714                           ; 0x2dc2
	dw	11719                           ; 0x2dc7
	dw	11724                           ; 0x2dcc
	dw	11729                           ; 0x2dd1
	dw	11734                           ; 0x2dd6
	dw	11739                           ; 0x2ddb
	dw	11744                           ; 0x2de0
	dw	11749                           ; 0x2de5
	dw	11754                           ; 0x2dea
	dw	11759                           ; 0x2def
	dw	11764                           ; 0x2df4
	dw	11769                           ; 0x2df9
	dw	11774                           ; 0x2dfe
	dw	11779                           ; 0x2e03
	dw	11784                           ; 0x2e08
	dw	11789                           ; 0x2e0d
	dw	11795                           ; 0x2e13
	dw	11801                           ; 0x2e19
	dw	11807                           ; 0x2e1f
	dw	11813                           ; 0x2e25
	dw	11819                           ; 0x2e2b
	dw	11825                           ; 0x2e31
	dw	11831                           ; 0x2e37
	dw	11837                           ; 0x2e3d
	dw	11843                           ; 0x2e43
	dw	11849                           ; 0x2e49
	dw	11855                           ; 0x2e4f
	dw	11860                           ; 0x2e54
	dw	11866                           ; 0x2e5a
	dw	11872                           ; 0x2e60
	dw	11878                           ; 0x2e66
	dw	11884                           ; 0x2e6c
	dw	11890                           ; 0x2e72
	dw	11896                           ; 0x2e78
	dw	11903                           ; 0x2e7f
	dw	11910                           ; 0x2e86
	dw	11916                           ; 0x2e8c
	dw	11923                           ; 0x2e93
	dw	11930                           ; 0x2e9a
	dw	11937                           ; 0x2ea1
	dw	11944                           ; 0x2ea8
	dw	11952                           ; 0x2eb0
	dw	11960                           ; 0x2eb8
	dw	11968                           ; 0x2ec0
	dw	11976                           ; 0x2ec8
	dw	11984                           ; 0x2ed0
	dw	11993                           ; 0x2ed9
	dw	12001                           ; 0x2ee1
	dw	12008                           ; 0x2ee8
	dw	12016                           ; 0x2ef0
	dw	12024                           ; 0x2ef8
	dw	12032                           ; 0x2f00
	dw	12040                           ; 0x2f08
	dw	12048                           ; 0x2f10
	dw	12056                           ; 0x2f18
	dw	12064                           ; 0x2f20
	dw	12071                           ; 0x2f27
	dw	12078                           ; 0x2f2e
	dw	12085                           ; 0x2f35
	dw	12092                           ; 0x2f3c
	dw	12100                           ; 0x2f44
	dw	12108                           ; 0x2f4c
	dw	12116                           ; 0x2f54
	dw	12124                           ; 0x2f5c
	dw	12132                           ; 0x2f64
	dw	12140                           ; 0x2f6c
	dw	12148                           ; 0x2f74
	dw	12157                           ; 0x2f7d
	dw	12166                           ; 0x2f86
	dw	12175                           ; 0x2f8f
	dw	12184                           ; 0x2f98
	dw	12193                           ; 0x2fa1
	dw	12202                           ; 0x2faa
	dw	12211                           ; 0x2fb3
	dw	12220                           ; 0x2fbc
	dw	12229                           ; 0x2fc5
	dw	12237                           ; 0x2fcd
	dw	12245                           ; 0x2fd5
	dw	12253                           ; 0x2fdd
	dw	12262                           ; 0x2fe6
	dw	12271                           ; 0x2fef
	dw	12280                           ; 0x2ff8
	dw	12289                           ; 0x3001
	dw	12298                           ; 0x300a
	dw	12308                           ; 0x3014
	dw	12318                           ; 0x301e
	dw	12328                           ; 0x3028
	dw	12338                           ; 0x3032
	dw	12346                           ; 0x303a
	dw	12355                           ; 0x3043
	dw	12364                           ; 0x304c
	dw	12373                           ; 0x3055
	dw	12382                           ; 0x305e
	dw	12391                           ; 0x3067
	dw	12400                           ; 0x3070
	dw	12408                           ; 0x3078
	dw	12415                           ; 0x307f
	dw	12423                           ; 0x3087
	dw	12431                           ; 0x308f
	dw	12441                           ; 0x3099
	dw	12449                           ; 0x30a1
	dw	12457                           ; 0x30a9
	dw	12466                           ; 0x30b2
	dw	12475                           ; 0x30bb
	dw	12483                           ; 0x30c3
	dw	12491                           ; 0x30cb
	dw	12499                           ; 0x30d3
	dw	12507                           ; 0x30db
	dw	12515                           ; 0x30e3
	dw	12523                           ; 0x30eb
	dw	12531                           ; 0x30f3
	dw	12539                           ; 0x30fb
	dw	12547                           ; 0x3103
	dw	12556                           ; 0x310c
	dw	12566                           ; 0x3116
	dw	12575                           ; 0x311f
	dw	12583                           ; 0x3127
	dw	12591                           ; 0x312f
	dw	12599                           ; 0x3137
	dw	12607                           ; 0x313f
	dw	12615                           ; 0x3147
	dw	12624                           ; 0x3150
	dw	12633                           ; 0x3159
	dw	12641                           ; 0x3161
	dw	12648                           ; 0x3168
	dw	12655                           ; 0x316f
	dw	12662                           ; 0x3176
	dw	12669                           ; 0x317d
	dw	12676                           ; 0x3184
	dw	12683                           ; 0x318b
	dw	12691                           ; 0x3193
	dw	12699                           ; 0x319b
	dw	12707                           ; 0x31a3
	dw	12715                           ; 0x31ab
	dw	12723                           ; 0x31b3
	dw	12731                           ; 0x31bb
	dw	12737                           ; 0x31c1
	dw	12744                           ; 0x31c8
	dw	12750                           ; 0x31ce
	dw	12756                           ; 0x31d4
	dw	12762                           ; 0x31da
	dw	12770                           ; 0x31e2
	dw	12778                           ; 0x31ea
	dw	12785                           ; 0x31f1
	dw	12792                           ; 0x31f8
	dw	12799                           ; 0x31ff
	dw	12805                           ; 0x3205
	dw	12811                           ; 0x320b
	dw	12817                           ; 0x3211
	dw	12823                           ; 0x3217
	dw	12831                           ; 0x321f
	dw	12839                           ; 0x3227
	dw	12846                           ; 0x322e
	dw	12853                           ; 0x3235
	dw	12860                           ; 0x323c
	dw	12866                           ; 0x3242
	dw	12872                           ; 0x3248
	dw	12878                           ; 0x324e
	dw	12884                           ; 0x3254
	dw	12890                           ; 0x325a
	dw	12895                           ; 0x325f
	dw	12900                           ; 0x3264
	dw	12905                           ; 0x3269
	dw	12911                           ; 0x326f
	dw	12918                           ; 0x3276
	dw	12925                           ; 0x327d
	dw	12932                           ; 0x3284
	dw	12939                           ; 0x328b
	dw	12945                           ; 0x3291
	dw	12951                           ; 0x3297
	dw	12957                           ; 0x329d
	dw	12963                           ; 0x32a3
	dw	12969                           ; 0x32a9
	dw	12975                           ; 0x32af
	dw	12982                           ; 0x32b6
	dw	12988                           ; 0x32bc
	dw	12994                           ; 0x32c2
	dw	13001                           ; 0x32c9
	dw	13008                           ; 0x32d0
	dw	13015                           ; 0x32d7
	dw	13021                           ; 0x32dd
	dw	13027                           ; 0x32e3
	dw	13033                           ; 0x32e9
	dw	13039                           ; 0x32ef
	dw	13045                           ; 0x32f5
	dw	13051                           ; 0x32fb
	dw	13058                           ; 0x3302
	dw	13065                           ; 0x3309
	dw	13072                           ; 0x3310
	dw	13079                           ; 0x3317
	dw	13086                           ; 0x331e
	dw	13092                           ; 0x3324
	dw	13098                           ; 0x332a
	dw	13104                           ; 0x3330
	dw	13111                           ; 0x3337
	dw	13118                           ; 0x333e
	dw	13125                           ; 0x3345
	dw	13132                           ; 0x334c
	dw	13139                           ; 0x3353
	dw	13145                           ; 0x3359
	dw	13151                           ; 0x335f
	dw	13157                           ; 0x3365
	dw	13164                           ; 0x336c
	dw	13171                           ; 0x3373
	dw	13178                           ; 0x337a
	dw	13185                           ; 0x3381
	dw	13192                           ; 0x3388
	dw	13199                           ; 0x338f
	dw	13206                           ; 0x3396
	dw	13213                           ; 0x339d
	dw	13220                           ; 0x33a4
	dw	13227                           ; 0x33ab
	dw	13234                           ; 0x33b2
	dw	13241                           ; 0x33b9
	dw	13248                           ; 0x33c0
	dw	13255                           ; 0x33c7
	dw	13261                           ; 0x33cd
	dw	13267                           ; 0x33d3
	dw	13273                           ; 0x33d9
	dw	13279                           ; 0x33df
	dw	13285                           ; 0x33e5
	dw	13291                           ; 0x33eb
	dw	13297                           ; 0x33f1
	dw	13304                           ; 0x33f8
	dw	13309                           ; 0x33fd
	dw	13315                           ; 0x3403
	dw	13321                           ; 0x3409
	dw	13327                           ; 0x340f
	dw	13333                           ; 0x3415
	dw	13339                           ; 0x341b
	dw	13345                           ; 0x3421
	dw	13352                           ; 0x3428
	dw	13358                           ; 0x342e
	dw	13364                           ; 0x3434
	dw	13370                           ; 0x343a
	dw	13376                           ; 0x3440
	dw	13382                           ; 0x3446
	dw	13388                           ; 0x344c
	dw	13394                           ; 0x3452
	dw	13400                           ; 0x3458
	dw	13406                           ; 0x345e
	dw	13412                           ; 0x3464
	dw	13418                           ; 0x346a
	dw	13424                           ; 0x3470
	dw	13430                           ; 0x3476
	dw	13436                           ; 0x347c
	dw	13442                           ; 0x3482
	dw	13448                           ; 0x3488
	dw	13454                           ; 0x348e
	dw	13460                           ; 0x3494
	dw	13466                           ; 0x349a
	dw	13472                           ; 0x34a0
	dw	13478                           ; 0x34a6
	dw	13484                           ; 0x34ac
	dw	13490                           ; 0x34b2
	dw	13496                           ; 0x34b8
	dw	13501                           ; 0x34bd
	dw	13506                           ; 0x34c2
	dw	13511                           ; 0x34c7
	dw	13516                           ; 0x34cc
	dw	13521                           ; 0x34d1
	dw	13525                           ; 0x34d5
	dw	13529                           ; 0x34d9
	dw	13534                           ; 0x34de
	dw	13539                           ; 0x34e3
	dw	13544                           ; 0x34e8
	dw	13549                           ; 0x34ed
	dw	13554                           ; 0x34f2
	dw	13559                           ; 0x34f7
	dw	13564                           ; 0x34fc
	dw	13569                           ; 0x3501
	dw	13574                           ; 0x3506
	dw	13580                           ; 0x350c
	dw	13586                           ; 0x3512
	dw	13592                           ; 0x3518
	dw	13598                           ; 0x351e
	dw	13604                           ; 0x3524
	dw	13610                           ; 0x352a
	dw	13616                           ; 0x3530
	dw	13621                           ; 0x3535
	dw	13626                           ; 0x353a
	dw	13631                           ; 0x353f
	dw	13637                           ; 0x3545
	dw	13643                           ; 0x354b
	dw	13649                           ; 0x3551
	dw	13655                           ; 0x3557
	dw	13661                           ; 0x355d
	dw	13668                           ; 0x3564
	dw	13674                           ; 0x356a
	dw	13679                           ; 0x356f
	dw	13685                           ; 0x3575
	dw	13691                           ; 0x357b
	dw	13697                           ; 0x3581
	dw	13703                           ; 0x3587
	dw	13709                           ; 0x358d
	dw	13716                           ; 0x3594
	dw	13723                           ; 0x359b
	dw	13730                           ; 0x35a2
	dw	13738                           ; 0x35aa
	dw	13746                           ; 0x35b2
	dw	13753                           ; 0x35b9
	dw	13760                           ; 0x35c0
	dw	13767                           ; 0x35c7
	dw	13774                           ; 0x35ce
	dw	13782                           ; 0x35d6
	dw	13790                           ; 0x35de
	dw	13798                           ; 0x35e6
	dw	13806                           ; 0x35ee
	dw	13814                           ; 0x35f6
	dw	13822                           ; 0x35fe
	dw	13830                           ; 0x3606
	dw	13838                           ; 0x360e
	dw	13846                           ; 0x3616
	dw	13854                           ; 0x361e
	dw	13862                           ; 0x3626
	dw	13870                           ; 0x362e
	dw	13878                           ; 0x3636
	dw	13886                           ; 0x363e
	dw	13894                           ; 0x3646
	dw	13902                           ; 0x364e
	dw	13911                           ; 0x3657
	dw	13920                           ; 0x3660
	dw	13929                           ; 0x3669
	dw	13938                           ; 0x3672
	dw	13946                           ; 0x367a
	dw	13955                           ; 0x3683
	dw	13964                           ; 0x368c
	dw	13973                           ; 0x3695
	dw	13981                           ; 0x369d
	dw	13990                           ; 0x36a6
	dw	14000                           ; 0x36b0
	dw	14009                           ; 0x36b9
	dw	14018                           ; 0x36c2
	dw	14027                           ; 0x36cb
	dw	14036                           ; 0x36d4
	dw	14044                           ; 0x36dc
	dw	14053                           ; 0x36e5
	dw	14062                           ; 0x36ee
	dw	14072                           ; 0x36f8
	dw	14082                           ; 0x3702
	dw	14091                           ; 0x370b
	dw	14101                           ; 0x3715
	dw	14111                           ; 0x371f
	dw	14121                           ; 0x3729
	dw	14130                           ; 0x3732
	dw	14139                           ; 0x373b
	dw	14148                           ; 0x3744
	dw	14157                           ; 0x374d
	dw	14166                           ; 0x3756
	dw	14175                           ; 0x375f
	dw	14184                           ; 0x3768
	dw	14193                           ; 0x3771
	dw	14201                           ; 0x3779
	dw	14209                           ; 0x3781
	dw	14217                           ; 0x3789
	dw	14226                           ; 0x3792
	dw	14234                           ; 0x379a
	dw	14244                           ; 0x37a4
	dw	14254                           ; 0x37ae
	dw	14263                           ; 0x37b7
	dw	14271                           ; 0x37bf
	dw	14279                           ; 0x37c7
	dw	14287                           ; 0x37cf
	dw	14295                           ; 0x37d7
	dw	14303                           ; 0x37df
	dw	14312                           ; 0x37e8
	dw	14321                           ; 0x37f1
	dw	14329                           ; 0x37f9
	dw	14336                           ; 0x3800
	dw	14343                           ; 0x3807
	dw	14350                           ; 0x380e
	dw	14358                           ; 0x3816
	dw	14366                           ; 0x381e
	dw	14374                           ; 0x3826
	dw	14383                           ; 0x382f
	dw	14391                           ; 0x3837
	dw	14398                           ; 0x383e
	dw	14405                           ; 0x3845
	dw	14412                           ; 0x384c
	dw	14419                           ; 0x3853
	dw	14425                           ; 0x3859
	dw	14432                           ; 0x3860
	dw	14439                           ; 0x3867
	dw	14445                           ; 0x386d
	dw	14451                           ; 0x3873
	dw	14457                           ; 0x3879
	dw	14464                           ; 0x3880
	dw	14471                           ; 0x3887
	dw	14477                           ; 0x388d
	dw	14484                           ; 0x3894
	dw	14492                           ; 0x389c
	dw	14499                           ; 0x38a3
	dw	14505                           ; 0x38a9
	dw	14512                           ; 0x38b0
	dw	14519                           ; 0x38b7
	dw	14526                           ; 0x38be
	dw	14532                           ; 0x38c4
	dw	14538                           ; 0x38ca
	dw	14544                           ; 0x38d0
	dw	14551                           ; 0x38d7
	dw	14557                           ; 0x38dd
	dw	14563                           ; 0x38e3
	dw	14569                           ; 0x38e9
	dw	14575                           ; 0x38ef
	dw	14581                           ; 0x38f5
	dw	14587                           ; 0x38fb
	dw	14594                           ; 0x3902
	dw	14601                           ; 0x3909
	dw	14607                           ; 0x390f
	dw	14613                           ; 0x3915
	dw	14619                           ; 0x391b
	dw	14625                           ; 0x3921
	dw	14631                           ; 0x3927
	dw	14637                           ; 0x392d
	dw	14643                           ; 0x3933
	dw	14649                           ; 0x3939
	dw	14655                           ; 0x393f
	dw	14661                           ; 0x3945
	dw	14667                           ; 0x394b
	dw	14673                           ; 0x3951
	dw	14679                           ; 0x3957
	dw	14685                           ; 0x395d
	dw	14692                           ; 0x3964
	dw	14699                           ; 0x396b
	dw	14706                           ; 0x3972
	dw	14713                           ; 0x3979
	dw	14720                           ; 0x3980
	dw	14726                           ; 0x3986
	dw	14732                           ; 0x398c
	dw	14738                           ; 0x3992
	dw	14744                           ; 0x3998
	dw	14750                           ; 0x399e
	dw	14756                           ; 0x39a4
	dw	14762                           ; 0x39aa
	dw	14768                           ; 0x39b0
	dw	14774                           ; 0x39b6
	dw	14780                           ; 0x39bc
	dw	14786                           ; 0x39c2
	dw	14793                           ; 0x39c9
	dw	14800                           ; 0x39d0
	dw	14806                           ; 0x39d6
	dw	14812                           ; 0x39dc
	dw	14818                           ; 0x39e2
	dw	14824                           ; 0x39e8
	dw	14830                           ; 0x39ee
	dw	14836                           ; 0x39f4
	dw	14843                           ; 0x39fb
	dw	14850                           ; 0x3a02
	dw	14856                           ; 0x3a08
	dw	14862                           ; 0x3a0e
	dw	14868                           ; 0x3a14
	dw	14874                           ; 0x3a1a
	dw	14881                           ; 0x3a21
	dw	14887                           ; 0x3a27
	dw	14893                           ; 0x3a2d
	dw	14900                           ; 0x3a34
	dw	14907                           ; 0x3a3b
	dw	14914                           ; 0x3a42
	dw	14921                           ; 0x3a49
	dw	14928                           ; 0x3a50
	dw	14935                           ; 0x3a57
	dw	14941                           ; 0x3a5d
	dw	14947                           ; 0x3a63
	dw	14954                           ; 0x3a6a
	dw	14961                           ; 0x3a71
	dw	14969                           ; 0x3a79
	dw	14977                           ; 0x3a81
	dw	14985                           ; 0x3a89
	dw	14992                           ; 0x3a90
	dw	14999                           ; 0x3a97
	dw	15006                           ; 0x3a9e
	dw	15014                           ; 0x3aa6
	dw	15022                           ; 0x3aae
	dw	15030                           ; 0x3ab6
	dw	15039                           ; 0x3abf
	dw	15047                           ; 0x3ac7
	dw	15056                           ; 0x3ad0
	dw	15065                           ; 0x3ad9
	dw	15074                           ; 0x3ae2
	dw	15082                           ; 0x3aea
	dw	15090                           ; 0x3af2
	dw	15099                           ; 0x3afb
	dw	15108                           ; 0x3b04
	dw	15117                           ; 0x3b0d
	dw	15125                           ; 0x3b15
	dw	15134                           ; 0x3b1e
	dw	15144                           ; 0x3b28
	dw	15154                           ; 0x3b32
	dw	15164                           ; 0x3b3c
	dw	15174                           ; 0x3b46
	dw	15184                           ; 0x3b50
	dw	15194                           ; 0x3b5a
	dw	15203                           ; 0x3b63
	dw	15213                           ; 0x3b6d
	dw	15223                           ; 0x3b77
	dw	15233                           ; 0x3b81
	dw	15241                           ; 0x3b89
	dw	15249                           ; 0x3b91
	dw	15258                           ; 0x3b9a
	dw	15267                           ; 0x3ba3
	dw	15276                           ; 0x3bac
	dw	15286                           ; 0x3bb6
	dw	15296                           ; 0x3bc0
	dw	15306                           ; 0x3bca
	dw	15316                           ; 0x3bd4
	dw	15326                           ; 0x3bde
	dw	15337                           ; 0x3be9
	dw	15348                           ; 0x3bf4
	dw	15358                           ; 0x3bfe
	dw	15368                           ; 0x3c08
	dw	15379                           ; 0x3c13
	dw	15390                           ; 0x3c1e
	dw	15401                           ; 0x3c29
	dw	15411                           ; 0x3c33
	dw	15422                           ; 0x3c3e
	dw	15434                           ; 0x3c4a
	dw	15445                           ; 0x3c55
	dw	15458                           ; 0x3c62
	dw	15471                           ; 0x3c6f
	dw	15483                           ; 0x3c7b
	dw	15494                           ; 0x3c86
	dw	15507                           ; 0x3c93
	dw	15519                           ; 0x3c9f
	dw	15531                           ; 0x3cab
	dw	15542                           ; 0x3cb6
	dw	15553                           ; 0x3cc1
	dw	15565                           ; 0x3ccd
	dw	15577                           ; 0x3cd9
	dw	15590                           ; 0x3ce6
	dw	15602                           ; 0x3cf2
	dw	15616                           ; 0x3d00
	dw	15629                           ; 0x3d0d
	dw	15642                           ; 0x3d1a
	dw	15655                           ; 0x3d27
	dw	15668                           ; 0x3d34
	dw	15681                           ; 0x3d41
	dw	15693                           ; 0x3d4d
	dw	15706                           ; 0x3d5a
	dw	15720                           ; 0x3d68
	dw	15733                           ; 0x3d75
	dw	15746                           ; 0x3d82
	dw	15759                           ; 0x3d8f
	dw	15772                           ; 0x3d9c
	dw	15784                           ; 0x3da8
	dw	15797                           ; 0x3db5
	dw	15809                           ; 0x3dc1
	dw	15822                           ; 0x3dce
	dw	15834                           ; 0x3dda
	dw	15847                           ; 0x3de7
	dw	15861                           ; 0x3df5
	dw	15874                           ; 0x3e02
	dw	15888                           ; 0x3e10
	dw	15901                           ; 0x3e1d
	dw	15914                           ; 0x3e2a
	dw	15927                           ; 0x3e37
	dw	15942                           ; 0x3e46
	dw	15954                           ; 0x3e52
	dw	15967                           ; 0x3e5f
	dw	15980                           ; 0x3e6c
	dw	15994                           ; 0x3e7a
	dw	16007                           ; 0x3e87
	dw	16020                           ; 0x3e94
	dw	16034                           ; 0x3ea2
	dw	16048                           ; 0x3eb0
	dw	16060                           ; 0x3ebc
	dw	16074                           ; 0x3eca
	dw	16087                           ; 0x3ed7
	dw	16099                           ; 0x3ee3
	dw	16111                           ; 0x3eef
	dw	16124                           ; 0x3efc
	dw	16137                           ; 0x3f09
	dw	16150                           ; 0x3f16
	dw	16162                           ; 0x3f22
	dw	16175                           ; 0x3f2f
	dw	16187                           ; 0x3f3b
	dw	16200                           ; 0x3f48
	dw	16211                           ; 0x3f53
	dw	16222                           ; 0x3f5e
	dw	16233                           ; 0x3f69
	dw	16244                           ; 0x3f74
	dw	16254                           ; 0x3f7e
	dw	16264                           ; 0x3f88
	dw	16274                           ; 0x3f92
	dw	16284                           ; 0x3f9c
	dw	16293                           ; 0x3fa5
	dw	16302                           ; 0x3fae
	dw	16311                           ; 0x3fb7
	dw	16321                           ; 0x3fc1
	dw	16330                           ; 0x3fca
	dw	16339                           ; 0x3fd3
	dw	16348                           ; 0x3fdc
	dw	16356                           ; 0x3fe4
	dw	16363                           ; 0x3feb
	dw	16371                           ; 0x3ff3
	dw	16378                           ; 0x3ffa
	dw	16385                           ; 0x4001
	dw	16392                           ; 0x4008
	dw	16399                           ; 0x400f
	dw	16406                           ; 0x4016
	dw	16412                           ; 0x401c
	dw	16417                           ; 0x4021
	dw	16423                           ; 0x4027
	dw	16430                           ; 0x402e
	dw	16436                           ; 0x4034
	dw	16441                           ; 0x4039
	dw	16446                           ; 0x403e
	dw	16451                           ; 0x4043
	dw	16456                           ; 0x4048
	dw	16459                           ; 0x404b
	dw	16462                           ; 0x404e
	dw	16465                           ; 0x4051
	dw	16468                           ; 0x4054
	dw	16471                           ; 0x4057
	dw	16474                           ; 0x405a
	dw	16477                           ; 0x405d
	dw	16479                           ; 0x405f
	dw	16480                           ; 0x4060
	dw	16481                           ; 0x4061
	dw	16482                           ; 0x4062
	dw	16483                           ; 0x4063
	dw	16484                           ; 0x4064
	dw	16485                           ; 0x4065
	dw	16486                           ; 0x4066
	dw	16487                           ; 0x4067
	dw	16488                           ; 0x4068
	dw	16489                           ; 0x4069
	dw	16490                           ; 0x406a
	dw	16491                           ; 0x406b
	dw	16492                           ; 0x406c
	dw	16493                           ; 0x406d
	dw	16494                           ; 0x406e
	dw	16495                           ; 0x406f
	dw	16496                           ; 0x4070
	dw	16497                           ; 0x4071
	dw	16498                           ; 0x4072
	dw	16499                           ; 0x4073
	dw	16500                           ; 0x4074
	dw	16501                           ; 0x4075
	dw	16502                           ; 0x4076
	dw	16503                           ; 0x4077
	dw	16504                           ; 0x4078
	dw	16505                           ; 0x4079
	dw	16506                           ; 0x407a
	dw	16507                           ; 0x407b
	dw	16508                           ; 0x407c
	dw	16509                           ; 0x407d
	dw	16510                           ; 0x407e
	dw	16511                           ; 0x407f
	dw	16512                           ; 0x4080
	dw	16513                           ; 0x4081
	dw	16514                           ; 0x4082
	dw	16515                           ; 0x4083
	dw	16516                           ; 0x4084
	dw	16517                           ; 0x4085
	dw	16518                           ; 0x4086
	dw	16519                           ; 0x4087
	dw	16520                           ; 0x4088
	dw	16521                           ; 0x4089
	dw	16522                           ; 0x408a
	dw	16523                           ; 0x408b
	dw	16524                           ; 0x408c
	dw	16525                           ; 0x408d
	dw	16526                           ; 0x408e
	dw	16527                           ; 0x408f
	dw	16528                           ; 0x4090
	dw	16529                           ; 0x4091
	dw	16530                           ; 0x4092
	dw	16531                           ; 0x4093
	dw	16532                           ; 0x4094
	dw	16533                           ; 0x4095
	dw	16534                           ; 0x4096
	dw	16535                           ; 0x4097
	dw	16536                           ; 0x4098
	dw	16537                           ; 0x4099
	dw	16538                           ; 0x409a
	dw	16539                           ; 0x409b
	dw	16540                           ; 0x409c
	dw	16541                           ; 0x409d
	dw	16542                           ; 0x409e
	dw	16543                           ; 0x409f
	dw	16544                           ; 0x40a0
	dw	16545                           ; 0x40a1
	dw	16546                           ; 0x40a2
	dw	16547                           ; 0x40a3
	dw	16548                           ; 0x40a4
	dw	16549                           ; 0x40a5
	dw	16550                           ; 0x40a6
	dw	16551                           ; 0x40a7
	dw	16552                           ; 0x40a8
	dw	16553                           ; 0x40a9
	dw	16554                           ; 0x40aa
	dw	16555                           ; 0x40ab
	dw	16556                           ; 0x40ac
	dw	16557                           ; 0x40ad
	dw	16558                           ; 0x40ae
	dw	16559                           ; 0x40af
	dw	16560                           ; 0x40b0
	dw	16561                           ; 0x40b1
	dw	16562                           ; 0x40b2
	dw	16563                           ; 0x40b3
	dw	16564                           ; 0x40b4
	dw	16565                           ; 0x40b5
	dw	16566                           ; 0x40b6
	dw	16567                           ; 0x40b7
	dw	16568                           ; 0x40b8
	dw	16569                           ; 0x40b9
	dw	16570                           ; 0x40ba
	dw	16571                           ; 0x40bb
	dw	16572                           ; 0x40bc
	dw	16573                           ; 0x40bd
	dw	16574                           ; 0x40be
	dw	16575                           ; 0x40bf
	dw	16576                           ; 0x40c0
	dw	16577                           ; 0x40c1
	dw	16578                           ; 0x40c2
	dw	16579                           ; 0x40c3
	dw	16580                           ; 0x40c4
	dw	16581                           ; 0x40c5
	dw	16582                           ; 0x40c6
	dw	16583                           ; 0x40c7
	dw	16584                           ; 0x40c8
	dw	16585                           ; 0x40c9
	dw	16586                           ; 0x40ca
	dw	16587                           ; 0x40cb
	dw	16588                           ; 0x40cc
	dw	16589                           ; 0x40cd
	dw	16590                           ; 0x40ce
	dw	16591                           ; 0x40cf
	dw	16592                           ; 0x40d0
	dw	16593                           ; 0x40d1
	dw	16594                           ; 0x40d2
	dw	16595                           ; 0x40d3
	dw	16596                           ; 0x40d4
	dw	16597                           ; 0x40d5
	dw	16598                           ; 0x40d6
	dw	16599                           ; 0x40d7
	dw	16600                           ; 0x40d8
	dw	16601                           ; 0x40d9
	dw	16602                           ; 0x40da
	dw	16603                           ; 0x40db
	dw	16604                           ; 0x40dc
	dw	16605                           ; 0x40dd
	dw	16606                           ; 0x40de
	dw	16607                           ; 0x40df
	dw	16608                           ; 0x40e0
	dw	16609                           ; 0x40e1
	dw	16610                           ; 0x40e2
	dw	16611                           ; 0x40e3
	dw	16612                           ; 0x40e4
	dw	16613                           ; 0x40e5
	dw	16614                           ; 0x40e6
	dw	16615                           ; 0x40e7
	dw	16616                           ; 0x40e8
	dw	16617                           ; 0x40e9
	dw	16618                           ; 0x40ea
	dw	16619                           ; 0x40eb
	dw	16620                           ; 0x40ec
	dw	16621                           ; 0x40ed
	dw	16622                           ; 0x40ee
	dw	16623                           ; 0x40ef
	dw	16624                           ; 0x40f0
	dw	16625                           ; 0x40f1
	dw	16626                           ; 0x40f2
	dw	16627                           ; 0x40f3
	dw	16628                           ; 0x40f4
	dw	16629                           ; 0x40f5
	dw	16630                           ; 0x40f6
	dw	16631                           ; 0x40f7
	dw	16632                           ; 0x40f8
	dw	16633                           ; 0x40f9
	dw	16634                           ; 0x40fa
	dw	16635                           ; 0x40fb
	dw	16636                           ; 0x40fc
	dw	16637                           ; 0x40fd
	dw	16638                           ; 0x40fe
	dw	16639                           ; 0x40ff
	dw	16640                           ; 0x4100
	dw	16641                           ; 0x4101
	dw	16642                           ; 0x4102
	dw	16643                           ; 0x4103
	dw	16644                           ; 0x4104
	dw	16645                           ; 0x4105
	dw	16646                           ; 0x4106
	dw	16647                           ; 0x4107
	dw	16648                           ; 0x4108
	dw	16649                           ; 0x4109
	dw	16650                           ; 0x410a
	dw	16651                           ; 0x410b
	dw	16652                           ; 0x410c
	dw	16653                           ; 0x410d
	dw	16654                           ; 0x410e
	dw	16655                           ; 0x410f
	dw	16656                           ; 0x4110
	dw	16657                           ; 0x4111
	dw	16658                           ; 0x4112
	dw	16659                           ; 0x4113
	dw	16660                           ; 0x4114
	dw	16661                           ; 0x4115
	dw	16662                           ; 0x4116
	dw	16663                           ; 0x4117
	dw	16664                           ; 0x4118
	dw	16665                           ; 0x4119
	dw	16666                           ; 0x411a
	dw	16667                           ; 0x411b
	dw	16668                           ; 0x411c
	dw	16669                           ; 0x411d
	dw	16670                           ; 0x411e
	dw	16671                           ; 0x411f
	dw	16672                           ; 0x4120
	dw	16673                           ; 0x4121
	dw	16674                           ; 0x4122
	dw	16675                           ; 0x4123
	dw	16676                           ; 0x4124
	dw	16677                           ; 0x4125
	dw	16678                           ; 0x4126
	dw	16679                           ; 0x4127
	dw	16680                           ; 0x4128
	dw	16681                           ; 0x4129
	dw	16682                           ; 0x412a
	dw	16683                           ; 0x412b
	dw	16684                           ; 0x412c
	dw	16685                           ; 0x412d
	dw	16686                           ; 0x412e
	dw	16687                           ; 0x412f
	dw	16688                           ; 0x4130
	dw	16689                           ; 0x4131
	dw	16690                           ; 0x4132
	dw	16691                           ; 0x4133
	dw	16692                           ; 0x4134
	dw	16693                           ; 0x4135
	dw	16694                           ; 0x4136
	dw	16695                           ; 0x4137
	dw	16696                           ; 0x4138
	dw	16697                           ; 0x4139
	dw	16698                           ; 0x413a
	dw	16699                           ; 0x413b
	dw	16700                           ; 0x413c
	dw	16701                           ; 0x413d
	dw	16702                           ; 0x413e
	dw	16703                           ; 0x413f
	dw	16704                           ; 0x4140
	dw	16705                           ; 0x4141
	dw	16706                           ; 0x4142
	dw	16707                           ; 0x4143
	dw	16708                           ; 0x4144
	dw	16709                           ; 0x4145
	dw	16710                           ; 0x4146
	dw	16711                           ; 0x4147
	dw	16712                           ; 0x4148
	dw	16713                           ; 0x4149
	dw	16714                           ; 0x414a
	dw	16715                           ; 0x414b
	dw	16716                           ; 0x414c
	dw	16717                           ; 0x414d
	dw	16718                           ; 0x414e
	dw	16719                           ; 0x414f
	dw	16720                           ; 0x4150
	dw	16721                           ; 0x4151
	dw	16722                           ; 0x4152
	dw	16723                           ; 0x4153
	dw	16724                           ; 0x4154
	dw	16725                           ; 0x4155
	dw	16726                           ; 0x4156
	dw	16727                           ; 0x4157
	dw	16728                           ; 0x4158
	dw	16729                           ; 0x4159
	dw	16730                           ; 0x415a
	dw	16731                           ; 0x415b
	dw	16732                           ; 0x415c
	dw	16733                           ; 0x415d
	dw	16734                           ; 0x415e
	dw	16735                           ; 0x415f
	dw	16736                           ; 0x4160
	dw	16737                           ; 0x4161
	dw	16738                           ; 0x4162
	dw	16739                           ; 0x4163
	dw	16740                           ; 0x4164
	dw	16741                           ; 0x4165
	dw	16742                           ; 0x4166
	dw	16743                           ; 0x4167
	dw	16744                           ; 0x4168
	dw	16745                           ; 0x4169
	dw	16746                           ; 0x416a
	dw	16747                           ; 0x416b
	dw	16748                           ; 0x416c
	dw	16749                           ; 0x416d
	dw	16750                           ; 0x416e
	dw	16751                           ; 0x416f
	dw	16752                           ; 0x4170
	dw	16753                           ; 0x4171
	dw	16754                           ; 0x4172
	dw	16755                           ; 0x4173
	dw	16756                           ; 0x4174
	dw	16757                           ; 0x4175
	dw	16758                           ; 0x4176
	dw	16759                           ; 0x4177
	dw	16760                           ; 0x4178
	dw	16761                           ; 0x4179
	dw	16762                           ; 0x417a
	dw	16763                           ; 0x417b
	dw	16764                           ; 0x417c
	dw	16765                           ; 0x417d
	dw	16766                           ; 0x417e
	dw	16767                           ; 0x417f
	dw	16768                           ; 0x4180
	dw	16769                           ; 0x4181
	dw	16770                           ; 0x4182
	dw	16771                           ; 0x4183
	dw	16772                           ; 0x4184
	dw	16773                           ; 0x4185
	dw	16774                           ; 0x4186
	dw	16775                           ; 0x4187
	dw	16776                           ; 0x4188
	dw	16777                           ; 0x4189
	dw	16778                           ; 0x418a
	dw	16779                           ; 0x418b
	dw	16780                           ; 0x418c
	dw	16781                           ; 0x418d
	dw	16782                           ; 0x418e
	dw	16783                           ; 0x418f
	dw	16784                           ; 0x4190
	dw	16785                           ; 0x4191
	dw	16786                           ; 0x4192
	dw	16787                           ; 0x4193
	dw	16788                           ; 0x4194
	dw	16789                           ; 0x4195
	dw	16790                           ; 0x4196
	dw	16791                           ; 0x4197
	dw	16792                           ; 0x4198
	dw	16793                           ; 0x4199
	dw	16794                           ; 0x419a
	dw	16795                           ; 0x419b
	dw	16796                           ; 0x419c
	dw	16797                           ; 0x419d
	dw	16798                           ; 0x419e
	dw	16799                           ; 0x419f
	dw	16800                           ; 0x41a0
	dw	16801                           ; 0x41a1
	dw	16802                           ; 0x41a2

	.local	__ZN5rallyL11HeadingAtanE
__ZN5rallyL11HeadingAtanE:
	db	0, 1, 1, 2, 3, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 15, 15, 16, 16, 17, 18, 18, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 27, 27, 28, 28, 29, 30, 30, 31, 31, " !!", 34, 34, "#$$%&&''())**+,,--../001123344556778899::;<<==>>??@AABBCCDDEEFFGGHHIJJKKLLMMNNOOPPQQRRSSTTTUUVVWWXXYYZZ[[[", 92, 92, "]]^^__```aabbcccddeefffgghhhiijjjkklllmmnnnoopppqqqrrssstttuuvvvwwwxxxyyyzzz{{{|||}}}~~~", 127, 127, 127, 128, 128

	.local	__ZN5rally3r18L13HeadingAnglesE
__ZN5rally3r18L13HeadingAnglesE:
	dw	0                               ; 0x0
	dw	81                              ; 0x51
	dw	163                             ; 0xa3
	dw	244                             ; 0xf4
	dw	326                             ; 0x146
	dw	408                             ; 0x198
	dw	489                             ; 0x1e9
	dw	571                             ; 0x23b
	dw	652                             ; 0x28c
	dw	734                             ; 0x2de
	dw	816                             ; 0x330
	dw	897                             ; 0x381
	dw	979                             ; 0x3d3
	dw	1061                            ; 0x425
	dw	1143                            ; 0x477
	dw	1225                            ; 0x4c9
	dw	1307                            ; 0x51b
	dw	1389                            ; 0x56d
	dw	1472                            ; 0x5c0
	dw	1554                            ; 0x612
	dw	1636                            ; 0x664
	dw	1719                            ; 0x6b7
	dw	1802                            ; 0x70a
	dw	1884                            ; 0x75c
	dw	1967                            ; 0x7af
	dw	2050                            ; 0x802
	dw	2134                            ; 0x856
	dw	2217                            ; 0x8a9
	dw	2300                            ; 0x8fc
	dw	2384                            ; 0x950
	dw	2468                            ; 0x9a4
	dw	2551                            ; 0x9f7
	dw	2636                            ; 0xa4c
	dw	2720                            ; 0xaa0
	dw	2804                            ; 0xaf4
	dw	2889                            ; 0xb49
	dw	2974                            ; 0xb9e
	dw	3059                            ; 0xbf3
	dw	3144                            ; 0xc48
	dw	3229                            ; 0xc9d
	dw	3315                            ; 0xcf3
	dw	3401                            ; 0xd49
	dw	3487                            ; 0xd9f
	dw	3573                            ; 0xdf5
	dw	3660                            ; 0xe4c
	dw	3747                            ; 0xea3
	dw	3834                            ; 0xefa
	dw	3922                            ; 0xf52
	dw	4009                            ; 0xfa9
	dw	4097                            ; 0x1001
	dw	4186                            ; 0x105a
	dw	4275                            ; 0x10b3
	dw	4364                            ; 0x110c
	dw	4453                            ; 0x1165
	dw	4543                            ; 0x11bf
	dw	4633                            ; 0x1219
	dw	4723                            ; 0x1273
	dw	4814                            ; 0x12ce
	dw	4905                            ; 0x1329
	dw	4997                            ; 0x1385
	dw	5089                            ; 0x13e1
	dw	5181                            ; 0x143d
	dw	5274                            ; 0x149a
	dw	5367                            ; 0x14f7
	dw	5461                            ; 0x1555
	dw	5556                            ; 0x15b4
	dw	5651                            ; 0x1613
	dw	5746                            ; 0x1672
	dw	5842                            ; 0x16d2
	dw	5938                            ; 0x1732
	dw	6035                            ; 0x1793
	dw	6133                            ; 0x17f5
	dw	6231                            ; 0x1857
	dw	6330                            ; 0x18ba
	dw	6430                            ; 0x191e
	dw	6530                            ; 0x1982
	dw	6631                            ; 0x19e7
	dw	6732                            ; 0x1a4c
	dw	6835                            ; 0x1ab3
	dw	6938                            ; 0x1b1a
	dw	7042                            ; 0x1b82
	dw	7147                            ; 0x1beb
	dw	7252                            ; 0x1c54
	dw	7359                            ; 0x1cbf
	dw	7466                            ; 0x1d2a
	dw	7575                            ; 0x1d97
	dw	7684                            ; 0x1e04
	dw	7795                            ; 0x1e73
	dw	7907                            ; 0x1ee3
	dw	8019                            ; 0x1f53
	dw	8133                            ; 0x1fc5
	dw	8249                            ; 0x2039
	dw	8365                            ; 0x20ad
	dw	8483                            ; 0x2123
	dw	8602                            ; 0x219a
	dw	8723                            ; 0x2213
	dw	8846                            ; 0x228e
	dw	8970                            ; 0x230a
	dw	9095                            ; 0x2387
	dw	9223                            ; 0x2407
	dw	9353                            ; 0x2489
	dw	9484                            ; 0x250c
	dw	9618                            ; 0x2592
	dw	9754                            ; 0x261a
	dw	9892                            ; 0x26a4
	dw	10034                           ; 0x2732
	dw	10177                           ; 0x27c1
	dw	10324                           ; 0x2854
	dw	10475                           ; 0x28eb
	dw	10628                           ; 0x2984
	dw	10785                           ; 0x2a21
	dw	10947                           ; 0x2ac3
	dw	11113                           ; 0x2b69
	dw	11155                           ; 0x2b93
	dw	11198                           ; 0x2bbe
	dw	11241                           ; 0x2be9
	dw	11284                           ; 0x2c14
	dw	11327                           ; 0x2c3f
	dw	11371                           ; 0x2c6b
	dw	11415                           ; 0x2c97
	dw	11460                           ; 0x2cc4
	dw	11505                           ; 0x2cf1
	dw	11550                           ; 0x2d1e
	dw	11596                           ; 0x2d4c
	dw	11642                           ; 0x2d7a
	dw	11689                           ; 0x2da9
	dw	11736                           ; 0x2dd8
	dw	11784                           ; 0x2e08
	dw	11831                           ; 0x2e37
	dw	11880                           ; 0x2e68
	dw	11929                           ; 0x2e99
	dw	11978                           ; 0x2eca
	dw	12028                           ; 0x2efc
	dw	12079                           ; 0x2f2f
	dw	12130                           ; 0x2f62
	dw	12181                           ; 0x2f95
	dw	12234                           ; 0x2fca
	dw	12287                           ; 0x2fff
	dw	12340                           ; 0x3034
	dw	12394                           ; 0x306a
	dw	12449                           ; 0x30a1
	dw	12505                           ; 0x30d9
	dw	12561                           ; 0x3111
	dw	12619                           ; 0x314b
	dw	12677                           ; 0x3185
	dw	12736                           ; 0x31c0
	dw	12796                           ; 0x31fc
	dw	12857                           ; 0x3239
	dw	12919                           ; 0x3277
	dw	12982                           ; 0x32b6
	dw	13046                           ; 0x32f6
	dw	13111                           ; 0x3337
	dw	13178                           ; 0x337a
	dw	13246                           ; 0x33be
	dw	13315                           ; 0x3403
	dw	13386                           ; 0x344a
	dw	13459                           ; 0x3493
	dw	13534                           ; 0x34de
	dw	13610                           ; 0x352a
	dw	13689                           ; 0x3579
	dw	13770                           ; 0x35ca
	dw	13780                           ; 0x35d4
	dw	13790                           ; 0x35de
	dw	13801                           ; 0x35e9
	dw	13811                           ; 0x35f3
	dw	13821                           ; 0x35fd
	dw	13832                           ; 0x3608
	dw	13842                           ; 0x3612
	dw	13853                           ; 0x361d
	dw	13864                           ; 0x3628
	dw	13874                           ; 0x3632
	dw	13885                           ; 0x363d
	dw	13896                           ; 0x3648
	dw	13907                           ; 0x3653
	dw	13917                           ; 0x365d
	dw	13928                           ; 0x3668
	dw	13939                           ; 0x3673
	dw	13950                           ; 0x367e
	dw	13961                           ; 0x3689
	dw	13972                           ; 0x3694
	dw	13983                           ; 0x369f
	dw	13995                           ; 0x36ab
	dw	14006                           ; 0x36b6
	dw	14017                           ; 0x36c1
	dw	14029                           ; 0x36cd
	dw	14040                           ; 0x36d8
	dw	14051                           ; 0x36e3
	dw	14063                           ; 0x36ef
	dw	14074                           ; 0x36fa
	dw	14086                           ; 0x3706
	dw	14098                           ; 0x3712
	dw	14110                           ; 0x371e
	dw	14121                           ; 0x3729
	dw	14133                           ; 0x3735
	dw	14145                           ; 0x3741
	dw	14157                           ; 0x374d
	dw	14169                           ; 0x3759
	dw	14181                           ; 0x3765
	dw	14193                           ; 0x3771
	dw	14206                           ; 0x377e
	dw	14218                           ; 0x378a
	dw	14230                           ; 0x3796
	dw	14243                           ; 0x37a3
	dw	14255                           ; 0x37af
	dw	14268                           ; 0x37bc
	dw	14281                           ; 0x37c9
	dw	14293                           ; 0x37d5
	dw	14306                           ; 0x37e2
	dw	14319                           ; 0x37ef
	dw	14332                           ; 0x37fc
	dw	14345                           ; 0x3809
	dw	14358                           ; 0x3816
	dw	14372                           ; 0x3824
	dw	14385                           ; 0x3831
	dw	14398                           ; 0x383e
	dw	14412                           ; 0x384c
	dw	14425                           ; 0x3859
	dw	14439                           ; 0x3867
	dw	14453                           ; 0x3875
	dw	14467                           ; 0x3883
	dw	14481                           ; 0x3891
	dw	14495                           ; 0x389f
	dw	14509                           ; 0x38ad
	dw	14523                           ; 0x38bb
	dw	14538                           ; 0x38ca
	dw	14552                           ; 0x38d8
	dw	14567                           ; 0x38e7
	dw	14582                           ; 0x38f6
	dw	14597                           ; 0x3905
	dw	14612                           ; 0x3914
	dw	14627                           ; 0x3923
	dw	14642                           ; 0x3932
	dw	14657                           ; 0x3941
	dw	14673                           ; 0x3951
	dw	14688                           ; 0x3960
	dw	14704                           ; 0x3970
	dw	14720                           ; 0x3980
	dw	14736                           ; 0x3990
	dw	14753                           ; 0x39a1
	dw	14769                           ; 0x39b1
	dw	14786                           ; 0x39c2
	dw	14802                           ; 0x39d2
	dw	14819                           ; 0x39e3
	dw	14836                           ; 0x39f4
	dw	14854                           ; 0x3a06
	dw	14871                           ; 0x3a17
	dw	14889                           ; 0x3a29
	dw	14907                           ; 0x3a3b
	dw	14925                           ; 0x3a4d
	dw	14944                           ; 0x3a60
	dw	14962                           ; 0x3a72
	dw	14981                           ; 0x3a85
	dw	15000                           ; 0x3a98
	dw	15019                           ; 0x3aab
	dw	15039                           ; 0x3abf
	dw	15059                           ; 0x3ad3
	dw	15079                           ; 0x3ae7
	dw	15100                           ; 0x3afc
	dw	15121                           ; 0x3b11
	dw	15142                           ; 0x3b26
	dw	15164                           ; 0x3b3c
	dw	15186                           ; 0x3b52
	dw	15208                           ; 0x3b68
	dw	15231                           ; 0x3b7f
	dw	15254                           ; 0x3b96
	dw	15278                           ; 0x3bae
	dw	15302                           ; 0x3bc6
	dw	15327                           ; 0x3bdf
	dw	15353                           ; 0x3bf9
	dw	15379                           ; 0x3c13
	dw	15406                           ; 0x3c2e
	dw	15433                           ; 0x3c49
	dw	15462                           ; 0x3c66
	dw	15491                           ; 0x3c83
	dw	15521                           ; 0x3ca1
	dw	15553                           ; 0x3cc1
	dw	15585                           ; 0x3ce1
	dw	15619                           ; 0x3d03
	dw	15655                           ; 0x3d27
	dw	15692                           ; 0x3d4c
	dw	15732                           ; 0x3d74
	dw	15774                           ; 0x3d9e
	dw	15819                           ; 0x3dcb
	dw	15869                           ; 0x3dfd
	dw	15923                           ; 0x3e33
	dw	15985                           ; 0x3e71
	dw	16058                           ; 0x3eba
	dw	16154                           ; 0x3f1a
	dw	16384                           ; 0x4000

	.local	__ZN5rally3r18L13BearingAnglesE
__ZN5rally3r18L13BearingAnglesE:
	dw	0                               ; 0x0
	dw	130                             ; 0x82
	dw	261                             ; 0x105
	dw	391                             ; 0x187
	dw	521                             ; 0x209
	dw	651                             ; 0x28b
	dw	781                             ; 0x30d
	dw	910                             ; 0x38e
	dw	1040                            ; 0x410
	dw	1169                            ; 0x491
	dw	1297                            ; 0x511
	dw	1425                            ; 0x591
	dw	1553                            ; 0x611
	dw	1680                            ; 0x690
	dw	1807                            ; 0x70f
	dw	1933                            ; 0x78d
	dw	2059                            ; 0x80b
	dw	2184                            ; 0x888
	dw	2308                            ; 0x904
	dw	2432                            ; 0x980
	dw	2555                            ; 0x9fb
	dw	2678                            ; 0xa76
	dw	2799                            ; 0xaef
	dw	2920                            ; 0xb68
	dw	3040                            ; 0xbe0
	dw	3159                            ; 0xc57
	dw	3278                            ; 0xcce
	dw	3395                            ; 0xd43
	dw	3512                            ; 0xdb8
	dw	3627                            ; 0xe2b
	dw	3742                            ; 0xe9e
	dw	3856                            ; 0xf10
	dw	3969                            ; 0xf81
	dw	4081                            ; 0xff1
	dw	4192                            ; 0x1060
	dw	4302                            ; 0x10ce
	dw	4411                            ; 0x113b
	dw	4518                            ; 0x11a6
	dw	4625                            ; 0x1211
	dw	4731                            ; 0x127b
	dw	4836                            ; 0x12e4
	dw	4940                            ; 0x134c
	dw	5043                            ; 0x13b3
	dw	5144                            ; 0x1418
	dw	5245                            ; 0x147d
	dw	5344                            ; 0x14e0
	dw	5443                            ; 0x1543
	dw	5540                            ; 0x15a4
	dw	5637                            ; 0x1605
	dw	5732                            ; 0x1664
	dw	5826                            ; 0x16c2
	dw	5920                            ; 0x1720
	dw	6012                            ; 0x177c
	dw	6103                            ; 0x17d7
	dw	6193                            ; 0x1831
	dw	6282                            ; 0x188a
	dw	6370                            ; 0x18e2
	dw	6457                            ; 0x1939
	dw	6543                            ; 0x198f
	dw	6628                            ; 0x19e4
	dw	6712                            ; 0x1a38
	dw	6795                            ; 0x1a8b
	dw	6877                            ; 0x1add
	dw	6958                            ; 0x1b2e
	dw	7038                            ; 0x1b7e
	dw	7117                            ; 0x1bcd
	dw	7195                            ; 0x1c1b
	dw	7272                            ; 0x1c68
	dw	7348                            ; 0x1cb4
	dw	7423                            ; 0x1cff
	dw	7498                            ; 0x1d4a
	dw	7571                            ; 0x1d93
	dw	7644                            ; 0x1ddc
	dw	7715                            ; 0x1e23
	dw	7786                            ; 0x1e6a
	dw	7856                            ; 0x1eb0
	dw	7925                            ; 0x1ef5
	dw	7993                            ; 0x1f39
	dw	8060                            ; 0x1f7c
	dw	8126                            ; 0x1fbe
	dw	8192                            ; 0x2000
	dw	8257                            ; 0x2041
	dw	8321                            ; 0x2081
	dw	8384                            ; 0x20c0
	dw	8446                            ; 0x20fe
	dw	8508                            ; 0x213c
	dw	8569                            ; 0x2179
	dw	8629                            ; 0x21b5
	dw	8688                            ; 0x21f0
	dw	8747                            ; 0x222b
	dw	8805                            ; 0x2265
	dw	8862                            ; 0x229e
	dw	8919                            ; 0x22d7
	dw	8974                            ; 0x230e
	dw	9029                            ; 0x2345
	dw	9084                            ; 0x237c
	dw	9138                            ; 0x23b2
	dw	9191                            ; 0x23e7
	dw	9243                            ; 0x241b
	dw	9295                            ; 0x244f
	dw	9346                            ; 0x2482
	dw	9397                            ; 0x24b5
	dw	9447                            ; 0x24e7
	dw	9496                            ; 0x2518
	dw	9545                            ; 0x2549
	dw	9593                            ; 0x2579
	dw	9641                            ; 0x25a9
	dw	9688                            ; 0x25d8
	dw	9734                            ; 0x2606
	dw	9780                            ; 0x2634
	dw	9825                            ; 0x2661
	dw	9870                            ; 0x268e
	dw	9915                            ; 0x26bb
	dw	9958                            ; 0x26e6
	dw	10002                           ; 0x2712
	dw	10044                           ; 0x273c
	dw	10087                           ; 0x2767
	dw	10128                           ; 0x2790
	dw	10170                           ; 0x27ba
	dw	10211                           ; 0x27e3
	dw	10251                           ; 0x280b
	dw	10291                           ; 0x2833
	dw	10330                           ; 0x285a
	dw	10369                           ; 0x2881
	dw	10408                           ; 0x28a8
	dw	10446                           ; 0x28ce
	dw	10484                           ; 0x28f4
	dw	10521                           ; 0x2919
	dw	10558                           ; 0x293e
	dw	10594                           ; 0x2962
	dw	10630                           ; 0x2986
	dw	10666                           ; 0x29aa
	dw	10701                           ; 0x29cd
	dw	10736                           ; 0x29f0
	dw	10770                           ; 0x2a12
	dw	10804                           ; 0x2a34
	dw	10838                           ; 0x2a56
	dw	10871                           ; 0x2a77
	dw	10904                           ; 0x2a98
	dw	10937                           ; 0x2ab9
	dw	10969                           ; 0x2ad9
	dw	11001                           ; 0x2af9
	dw	11033                           ; 0x2b19
	dw	11064                           ; 0x2b38
	dw	11095                           ; 0x2b57
	dw	11125                           ; 0x2b75
	dw	11156                           ; 0x2b94
	dw	11186                           ; 0x2bb2
	dw	11215                           ; 0x2bcf
	dw	11245                           ; 0x2bed
	dw	11274                           ; 0x2c0a
	dw	11302                           ; 0x2c26
	dw	11331                           ; 0x2c43
	dw	11359                           ; 0x2c5f
	dw	11387                           ; 0x2c7b
	dw	11414                           ; 0x2c96
	dw	11442                           ; 0x2cb2
	dw	11469                           ; 0x2ccd
	dw	11495                           ; 0x2ce7
	dw	11522                           ; 0x2d02
	dw	11548                           ; 0x2d1c
	dw	11574                           ; 0x2d36
	dw	11600                           ; 0x2d50
	dw	11625                           ; 0x2d69
	dw	11650                           ; 0x2d82
	dw	11675                           ; 0x2d9b
	dw	11700                           ; 0x2db4
	dw	11724                           ; 0x2dcc
	dw	11749                           ; 0x2de5
	dw	11773                           ; 0x2dfd
	dw	11796                           ; 0x2e14
	dw	11820                           ; 0x2e2c
	dw	11843                           ; 0x2e43
	dw	11866                           ; 0x2e5a
	dw	11889                           ; 0x2e71
	dw	11912                           ; 0x2e88
	dw	11934                           ; 0x2e9e
	dw	11956                           ; 0x2eb4
	dw	11978                           ; 0x2eca
	dw	12000                           ; 0x2ee0
	dw	12022                           ; 0x2ef6
	dw	12043                           ; 0x2f0b
	dw	12064                           ; 0x2f20
	dw	12085                           ; 0x2f35
	dw	12106                           ; 0x2f4a
	dw	12127                           ; 0x2f5f
	dw	12147                           ; 0x2f73
	dw	12168                           ; 0x2f88
	dw	12188                           ; 0x2f9c
	dw	12208                           ; 0x2fb0
	dw	12227                           ; 0x2fc3
	dw	12247                           ; 0x2fd7
	dw	12266                           ; 0x2fea
	dw	12285                           ; 0x2ffd
	dw	12304                           ; 0x3010
	dw	12323                           ; 0x3023
	dw	12342                           ; 0x3036
	dw	12361                           ; 0x3049
	dw	12379                           ; 0x305b
	dw	12397                           ; 0x306d
	dw	12415                           ; 0x307f
	dw	12433                           ; 0x3091
	dw	12451                           ; 0x30a3
	dw	12468                           ; 0x30b4
	dw	12486                           ; 0x30c6
	dw	12503                           ; 0x30d7
	dw	12520                           ; 0x30e8
	dw	12537                           ; 0x30f9
	dw	12554                           ; 0x310a
	dw	12571                           ; 0x311b
	dw	12588                           ; 0x312c
	dw	12604                           ; 0x313c
	dw	12620                           ; 0x314c
	dw	12637                           ; 0x315d
	dw	12653                           ; 0x316d
	dw	12668                           ; 0x317c
	dw	12684                           ; 0x318c
	dw	12700                           ; 0x319c
	dw	12715                           ; 0x31ab
	dw	12731                           ; 0x31bb
	dw	12746                           ; 0x31ca
	dw	12761                           ; 0x31d9
	dw	12776                           ; 0x31e8
	dw	12791                           ; 0x31f7
	dw	12806                           ; 0x3206
	dw	12821                           ; 0x3215
	dw	12835                           ; 0x3223
	dw	12850                           ; 0x3232
	dw	12864                           ; 0x3240
	dw	12878                           ; 0x324e
	dw	12893                           ; 0x325d
	dw	12907                           ; 0x326b
	dw	12920                           ; 0x3278
	dw	12934                           ; 0x3286
	dw	12948                           ; 0x3294
	dw	12962                           ; 0x32a2
	dw	12975                           ; 0x32af
	dw	12988                           ; 0x32bc
	dw	13002                           ; 0x32ca
	dw	13015                           ; 0x32d7
	dw	13028                           ; 0x32e4
	dw	13041                           ; 0x32f1
	dw	13054                           ; 0x32fe
	dw	13067                           ; 0x330b
	dw	13079                           ; 0x3317
	dw	13092                           ; 0x3324
	dw	13105                           ; 0x3331
	dw	13117                           ; 0x333d
	dw	13129                           ; 0x3349
	dw	13142                           ; 0x3356
	dw	13154                           ; 0x3362
	dw	13166                           ; 0x336e
	dw	13178                           ; 0x337a
	dw	13190                           ; 0x3386
	dw	13201                           ; 0x3391
	dw	13213                           ; 0x339d
	dw	13225                           ; 0x33a9

	.local	_str
_str:
	db	"Usage: rally [oval|fuji] [circuit|arcade] [steer1|steer2] [mute]", 0

	.local	_switch.table._ZN12_GLOBAL__N_112phaseChangedEv
_switch.table._ZN12_GLOBAL__N_112phaseChangedEv:
	db	1, 9, 9, 9, 9, 9, 7, 8, 9

	.ident	"clang version 15.0.7 (https://github.com/AgonPlatform/agon-llvm-project.git c76386c0083e6a6236ff774275227e2389f85538)"
	.extern	__lcmpzero
	.extern	_sys_vars
	.extern	__sxor
	.extern	__idivs
	.extern	__idivu
	.extern	_vdp_set_logical_coordinates
	.extern	__sremu
	.extern	__ineg
	.extern	_fwrite
	.extern	_vdp_set_pixel_coordinates
	.extern	__imulu
	.extern	__lxor
	.extern	_vdp_getKeyMap
	.extern	__frameset0
	.extern	__ldivs
	.extern	__ldivu
	.extern	__lor
	.extern	__inot
	.extern	_vdp_adv_write_block_data
	.extern	__sshl
	.extern	_snprintf
	.extern	__sshru
	.extern	__setflag
	.extern	_strlen
	.extern	_vdp_draw_bitmap
	.extern	__iand
	.extern	_vdp_adv_bitmap_from_buffer
	.extern	_vdp_cursor_enable
	.extern	__lmulu
	.extern	_vdp_adv_clear_buffer
	.extern	_remove
	.extern	_puts
	.extern	_vdp_mode
	.extern	__lshl
	.extern	__irems
	.extern	__iremu
	.extern	_memcmp
	.extern	__Unwind_SjLj_Register
	.extern	_vdp_cursor_tab
	.extern	__sneg
	.extern	__ixor
	.extern	_fread
	.extern	_vdp_set_text_bg_colour
	.extern	__lrems
	.extern	__lremu
	.extern	__indcallhl
	.extern	__lsub
	.extern	_strcmp
	.extern	_vdp_adv_use_affine_matrix
	.extern	__ishrs
	.extern	__ishru
	.extern	__sdivs
	.extern	__sdivu
	.extern	_strcpy
	.extern	__lcmps
	.extern	__lcmpu
	.extern	__lneg
	.extern	_fclose
	.extern	_vdp_scroll_screen_extent
	.extern	__sand
	.extern	__ishl
	.extern	__ladd
	.extern	_mos_puts
	.extern	__smulu
	.extern	__lshrs
	.extern	__lshru
	.extern	__frameset
	.extern	_fopen
	.extern	_fgetc
	.extern	_vdp_select_bitmap
	.extern	_vdp_swap
	.extern	__Unwind_SjLj_Unregister
	.extern	__land
	.extern	__bshl
	.extern	_vdp_set_text_colour
	.extern	_mos_ren
	.extern	_vdp_reset_sprites
