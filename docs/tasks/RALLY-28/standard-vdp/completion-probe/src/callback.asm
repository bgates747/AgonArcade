; Stock MOS 3.0.2 keyboard callback. DEU points to four packet bytes.
; Capture packets without modifying them. No MOS/VDU/file calls in the ISR.
.assume adl=1
.section .text
.global _probe_callback
.extern _probe_events, _probe_count, _probe_overflow, _probe_marker, _probe_hits
.extern _probe_sysvars
_probe_callback:
    push af
    push bc
    push de
    push hl
    push ix
    push iy
    push de
    pop ix
    ld a,(ix+2)
    ld hl,_probe_marker
    cp (hl)
    jr nz,probe_capture
    ld hl,_probe_hits
    inc (hl)
probe_capture:
    ld a,(_probe_count)
    cp 255
    jr nz,probe_room
    ld a,1
    ld (_probe_overflow),a
    jr probe_done
probe_room:
    ld hl,0
    ld l,a
    add hl,hl
    push hl
    pop de
    add hl,hl
    add hl,hl
    add hl,de
    ld de,_probe_events
    add hl,de
    ex de,hl
    push ix
    pop hl
    ld bc,4
    ldir
    ld hl,(_probe_sysvars)
    ld bc,4
    ldir
    ld hl,(_probe_sysvars)
    ld bc,0x37
    add hl,bc
    ld a,(hl)
    ld (de),a
    inc de
    ld hl,(_probe_sysvars)
    ld bc,4
    add hl,bc
    ld a,(hl)
    ld (de),a
    ld hl,_probe_count
    inc (hl)
probe_done:
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    ret
