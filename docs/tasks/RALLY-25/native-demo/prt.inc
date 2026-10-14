; Adapted from the Author's timer_prt_stopwatch.inc (Agon matrix example).
; Own idle PRT1 only; leave a running timer untouched. 72*256 =18432 clocks/IRQ.
; At nominal18.432MHz this is1ms; emulator PRT follows eZ80 instruction clocks.
; Save/restore MOS vector via its public API instead of rewriting the table.
prt_init:
    in0 a,(083h)
    ld (prt_old_ctl),a
    and 1
    ret nz
    in0 a,(092h)
    ld (prt_old_iss),a
    and 0f3h
    out0 (092h),a
    ld hl,prt_irq
    ld e,00ch
    push ix
    push iy
    MOSCALL mos_setintvector
    pop iy
    pop ix
    ld (prt_old_vector),hl
    ld hl,0
    ld (prt_counter),hl
    ld hl,72
    out0 (084h),l
    out0 (085h),h
    ld a,00eh
    out0 (083h),a
    ld a,1
    ld (prt_owned),a
    ld (prt_touched),a
    ld a,05fh
    out0 (083h),a
    ret
prt_stop:
    ld a,(prt_owned)
    or a
    ret z
    xor a
    out0 (083h),a
    ld a,(prt_old_iss)
    out0 (092h),a
    ld hl,(prt_old_vector)
    ld e,00ch
    push ix
    push iy
    MOSCALL mos_setintvector
    pop iy
    pop ix
    ld de,prt_irq
    or a
    sbc hl,de
    ld a,0
    jr nz,prt_vector_checked
    inc a
prt_vector_checked:
    ld (prt_restore_ok),a
    ld a,(prt_old_ctl)
    and 07eh
    out0 (083h),a
    xor a
    ld (prt_owned),a
    ret
prt_irq:
    push af
    push hl
    in0 a,(083h)
    ld hl,(prt_counter)
    inc hl
    ld (prt_counter),hl
    pop hl
    pop af
    ei
    reti.l
prt_owned: db 0
prt_old_ctl: db 0
prt_old_iss: db 0
prt_old_vector: dl 0
prt_counter: dl 0

; Saved after teardown: magic, schema, reserved, reload, divider, nominalHz,
; whether an idle PRT was borrowed, and whether its old vector was restored.
prt_metadata: db "R25T",1,0
    dw 72,256
    db 0,040h,019h,1 ;18432000 as little-endian u32
prt_touched: db 0
prt_restore_ok: db 0
prt_metadata_end:
