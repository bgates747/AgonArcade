.assume adl=1
.section .text
.global _frame_callback
.extern _completion_ready,_completion_count,_completion_sysvars
.extern _completion_mos,_completion_prt,_ticks
_frame_callback:
    push af
    push bc
    push de
    push hl
    push ix
    push iy
    push de
    pop ix
    ld a,(ix+2)
    or a
    jr nz,callback_done
    ld hl,(_completion_sysvars)
    ld de,_completion_mos
    ld bc,4
    ldir
    ld hl,(_ticks)
    ld (_completion_prt),hl
    ld hl,_completion_count
    inc (hl)
    ld a,1
    ld (_completion_ready),a
callback_done:
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    ret
