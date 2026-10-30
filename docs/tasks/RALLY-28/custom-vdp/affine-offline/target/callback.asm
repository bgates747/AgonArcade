; Pinned MOS3.0.2 four-byte keyboard callback, no MOS/VDU/file calls in IRQ.
.assume adl=1
.section .text
.global _affine_callback
.extern _affine_hits, _affine_packets
_affine_callback:
    push af
    push hl
    push ix
    push de
    pop ix
    ld hl,(_affine_packets)
    inc hl
    ld (_affine_packets),hl
    ld a,(ix+2)
    or a
    jr nz,affine_callback_done
    ld hl,_affine_hits
    inc (hl)
affine_callback_done:
    pop ix
    pop hl
    pop af
    ret
