; PRT1 approach from pingoasm's agon/timer.inc (nurples donor), with MOS vector
; install/restore rather than patching vector RAM. No calibration guess between
; hosts: nominal Agon 18.432MHz /16 /1152 => 1ms, quantized downward <1ms.
; Callback adapted from ../review/callback.asm. Genuine packets untouched.
; C ABI: ADL24, HL return, AF/BC/DE/HL caller-saved; preserve IX/IY.
.assume adl = 1
.text
.global _timing_claim, _timing_release, _timing_start, _timing_stop
.global _timing_ticks, _timing_irq
.extern _ticks, _elapsed
_timing_claim:
    in0 a,(0x83)
    and 0x41
    ld hl,0
    ret nz
    in0 a,(0x92)
    ld (saved_iss),a
    and 0xf3
    out0 (0x92),a
    inc hl
    ret
_timing_release:
    ld a,(saved_iss)
    out0 (0x92),a
    ret
_timing_start:
    di
    xor a
    out0 (0x83),a
    in0 a,(0x83)
    ld hl,0
    ld (_ticks),hl
    ld a,0x80
    out0 (0x84),a
    ld a,4
    out0 (0x85),a
    ld a,0x57
    out0 (0x83),a
    ei
    ret
_timing_stop:
    di
    call stop_inner
    ei
    ret
stop_inner:
    ; Sample pending IRQ before disabling (also correct for Fab's writable
    ; emulation of read-only bit7). Boundary race is a few CPU cycles, <1 tick.
    in0 a,(0x83)
    push af
    xor a
    out0 (0x83),a
    pop af
    ld hl,(_ticks)
    bit 7,a
    jr z,stopped
    inc hl
stopped:
    ld (_ticks),hl
    ld (_elapsed),hl
    ret
_timing_ticks:
    ld hl,(_ticks)
    ret
_timing_irq:
    push af
    push hl
    in0 a,(0x83)
    bit 7,a
    jr z,irq_done
    ld hl,(_ticks)
    inc hl
    ld (_ticks),hl
irq_done:
    pop hl
    pop af
    ei
    reti.l

.data
saved_iss: .db 0
