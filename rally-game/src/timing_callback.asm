; Fixture-only R27T v1 mailbox. MOS supplies payload in DEU.
; Preserve all registers; ordinary keyboard packets pass through unchanged.
.assume adl=1
.section .text
.global _r27_callback
.extern _r27_reply, _r27_ready
_r27_callback:
    push af
    push bc
    push de
    push hl
    push ix
    push iy
    push de
    pop ix
    ld a,(ix+0)
    cp 'R'
    jr nz,r27_done
    ld a,(ix+1)
    cp '2'
    jr nz,r27_done
    ld a,(ix+2)
    cp '7'
    jr nz,r27_done
    ld a,(ix+3)
    cp 'T'
    jr nz,r27_done
    push ix
    pop hl
    ld de,_r27_reply
    ld bc,10
    ldir
    xor a
    ld (ix+0),a
    ld (ix+1),a
    ld (ix+2),a
    ld (ix+3),a
    ld a,1
    ld (_r27_ready),a
r27_done:
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    ret
