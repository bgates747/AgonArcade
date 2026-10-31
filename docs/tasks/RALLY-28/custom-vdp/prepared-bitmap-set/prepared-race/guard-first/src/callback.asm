; Fixture-only VDPL v1 mailbox. MOS supplies payload in DEU.
; Preserve all registers; ordinary keyboard packets pass through unchanged.
.assume adl=1
.section .text
.global _fs_callback
.extern _fs_reply, _fs_ready
_fs_callback:
    push af
    push bc
    push de
    push hl
    push ix
    push iy
    push de
    pop ix
    ld a,(ix+0)
    cp 'V'
    jr nz,fs_done
    ld a,(ix+1)
    cp 'D'
    jr nz,fs_done
    ld a,(ix+2)
    cp 'P'
    jr nz,fs_done
    ld a,(ix+3)
    cp 'L'
    jr nz,fs_done
    push ix
    pop hl
    ld de,_fs_reply
    ld bc,10
    ldir
    xor a
    ld (ix+0),a
    ld (ix+1),a
    ld (ix+2),a
    ld (ix+3),a
    ld a,1
    ld (_fs_ready),a
fs_done:
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    ret
