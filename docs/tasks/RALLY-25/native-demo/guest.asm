; RALLY-25 native demo: MOS transport/dispatch only; physics and renderer run in Golem/Xtensa.
; script.bin is loaded after boot. It contains ordinary VDU bytes and expectations.
; 0=end; 1=u16 bytes,raw VDU; 2=transaction metadata(10),raw VDU.
; 3=u16 VSync count; 4=u16 handle patch offset,u16 bytes,raw VDU.
; Metadata: token:u16,kind:u8,flags:u8,value:u16,handle-patch:u16,bytes:u16.
; flags: 1=capture nonzero handle, 2=accept arbitrary value; otherwise exact value.
    .assume adl=1
    .org 0x040000
    jp start
    .align 64
    db "MOS",0,1
    include ".work/mos_api.inc"

start:
    push af
    push bc
    push de
    push hl
    push ix
    push iy
    ld (saved_sp),sp             ; ADL24 OK: saved stack address.
    MOSCALL mos_sysvars
    push ix
    pop iy
    ; A failed rerun must not leave old success logs looking current.
    ld hl,result_name
    push iy
    MOSCALL mos_del
    pop iy
    ld hl,tick_name
    push iy
    MOSCALL mos_del
    pop iy
    ld hl,clock_name
    push iy
    MOSCALL mos_del
    pop iy
    ld hl,prt_name
    push iy
    MOSCALL mos_del
    pop iy
    ld hl,failure_name
    push iy
    MOSCALL mos_del
    pop iy
    ld hl,script_name
    ld de,0x050000
    ld bc,0x030000
    push iy
    MOSCALL mos_load
    pop iy
    or a
    jp nz,failed
    call prt_init
    ld hl,packet_callback
    ld c,0
    push iy
    MOSCALL mos_setkbvector
    pop iy
    ld a,1
    ld (installed),a
    ld hl,observations
    ld (cursor),hl               ; ADL24 OK: transcript address.
    ld ix,0x050000

next_record:
    ld a,(ix+0)
    inc ix
    or a
    jp z,complete
    cp 9
    jp z,repeat_begin
    cp 10
    jp z,repeat_end
    cp 12
    jp z,wait_prt
    cp 11
    jp z,pace_frame
    cp 5
    jp z,mark_time
    cp 6
    jp z,external_record
    cp 1
    jp z,raw_record
    cp 3
    jp z,wait_frames
    cp 4
    jp z,patched_record
    cp 2
    jp nz,failed
    ld a,(ix+0)
    ld (expected_token),a
    ld a,(ix+1)
    ld (expected_token+1),a
    ld a,(ix+2)
    ld (expected_kind),a
    ld a,(ix+3)
    ld (reply_flags),a
    ld a,(ix+4)
    ld (expected_value),a
    ld a,(ix+5)
    ld (expected_value+1),a
    ld de,0
    ld e,(ix+6)
    ld d,(ix+7)
    lea ix,ix+8
    call tape_word
    push ix
    pop hl
    ; FFFF means no dynamic handle patch; other offsets are packet-relative.
    ld a,d
    and e
    cp 255
    jr z,packet_ready
    push hl
    add hl,de
    ld a,(module_handle)
    ld (hl),a
    inc hl
    ld a,(module_handle+1)
    ld (hl),a
    pop hl
packet_ready:
    push hl
    add hl,bc
    push hl
    pop ix
    pop hl
    xor a
    ld (reply_ready),a
    call send
    ld a,(iy+sysvar_time)
    ld d,a
wait_reply:
    ld a,(reply_ready)
    or a
    jr nz,got_reply
    ld a,(iy+sysvar_time)
    sub d
    cp 250
    jr c,wait_reply
    jp failed
got_reply:
    di
    ld hl,mailbox
    ld de,snapshot
    ld bc,10
    ldir
    xor a
    ld (reply_ready),a
    ei
    ld a,(snapshot+4)
    cp 1
    jp nz,failed
    ld a,(expected_kind)
    ld hl,snapshot+5
    cp (hl)
    jp nz,failed
    ld a,(expected_token)
    inc hl
    cp (hl)
    jp nz,failed
    ld a,(expected_token+1)
    inc hl
    cp (hl)
    jp nz,failed
    ld a,(reply_flags)
    bit 0,a
    jr z,check_value
    ld a,(snapshot+8)
    ld (module_handle),a
    ld b,a
    ld a,(snapshot+9)
    ld (module_handle+1),a
    or b
    jp z,failed
    jr append_reply
check_value:
    bit 3,a
    jr z,check_request
    ld hl,(frame_number)
    add hl,hl
    add hl,hl
    jr dynamic_expected
check_request:
    bit 4,a
    jr z,check_generation
    ld hl,(frame_number)
    jr dynamic_expected
check_generation:
    bit 5,a
    jr z,constant_expected
    ld hl,(frame_number)
    push hl
    pop bc
    add hl,hl
    add hl,hl
    add hl,bc
    inc hl
    jr dynamic_expected
constant_expected:
    bit 1,a
    jr nz,append_reply
    ld a,(expected_value)
    ld hl,snapshot+8
    cp (hl)
    jp nz,failed
    ld a,(expected_value+1)
    inc hl
    cp (hl)
    jp nz,failed
    jr append_reply
dynamic_expected:
    ld a,(snapshot+8)
    cp l
    jp nz,failed
    ld a,(snapshot+9)
    cp h
    jp nz,failed
append_reply:
    ld hl,(transactions)
    inc hl
    ld (transactions),hl
    ld a,(reply_flags)
    bit 2,a
    jp nz,next_record
    ld hl,snapshot
    ld de,(cursor)              ; ADL24 OK: transcript address.
    ld bc,10
    ldir
    ld (cursor),de              ; ADL24 OK: transcript address.
    jp next_record

; 9=u16 repeat count, 10=end repeat. No nested loops are emitted.
repeat_begin:
    call tape_word
    ld (repeat_count),bc
    ld (repeat_start),ix
    ld hl,1
    ld (frame_number),hl
    ld a,b
    or c
    jp z,failed
    ld hl,(iy+sysvar_time)
    ld (frame_deadline),hl
    xor a
    ld (frame_fraction),a
    jp next_record
repeat_end:
    ld hl,(frame_number)
    inc hl
    ld (frame_number),hl
    ld bc,(repeat_count)
    dec bc
    ld (repeat_count),bc
    ld a,b
    or c
    jp z,next_record
    ld ix,(repeat_start)
    jp next_record
 ; 11=absolute30-Hz deadline: four MOS units per60-Hz-mode frame.
; MOS adds2units per VBlank: nominal120units/s. Foreground fixture only.
pace_frame:
    ld hl,(frame_deadline)
    ld bc,4
    add hl,bc
    ld (frame_deadline),hl
    ex de,hl
pace_wait:
    ld hl,(iy+sysvar_time) ;single ADL load, keep IRQ delivery enabled
    or a
    sbc hl,de
    bit 7,h
    jr nz,pace_wait
    jp next_record

; 12=u16 nominal PRT ticks to wait (qualification only; no VDP activity).
wait_prt:
    call tape_word
    ld a,(prt_owned)
    or a
    jp z,failed
    ld hl,(prt_counter) ;single ADL load: IRQ cannot split this instruction
    add hl,bc
    ex de,hl
    ld bc,60000
wait_prt_next:
    ld hl,(prt_counter) ;single ADL load: IRQ cannot split this instruction
    or a
    sbc hl,de
    jp p,next_record
    dec bc
    ld a,b
    or c
    jr nz,wait_prt_next
    jp next_record

; 5 stores one atomic 24-bit MOS VBlank-derived sample; builder bounds storage.

mark_time:
    ld hl,(tick_cursor)
    di
    ld a,(iy+sysvar_time)
    ld (hl),a
    inc hl
    ld a,(iy+sysvar_time+1)
    ld (hl),a
    inc hl
    ld a,(iy+sysvar_time+2)
    ld (hl),a
    ei
    inc hl
    ld (tick_cursor),hl
    ld de,(prt_cursor)
    ld hl,(prt_counter) ;single ADL load: IRQ cannot split this instruction
    push ix
    push de
    pop ix
    ld (ix+0),hl
    pop ix
    inc de
    inc de
    inc de
    ld (prt_cursor),de
    jp next_record

; 6 = u24 size, NUL filename. Load an untimed startup stream in upper RAM.
external_record:
    ld bc,(ix+0)
    ld (external_size),bc
    lea ix,ix+3
    push ix
    pop hl
external_name:
    ld a,(ix+0)
    inc ix
    or a
    jr nz,external_name
    push ix
    push iy
    ld de,0x080000
    ld bc,0x040000
    MOSCALL mos_load
    pop iy
    pop ix
    or a
    jp nz,failed
    ld hl,0x080000
    ld (external_cursor),hl
external_send:
    ld hl,(external_size)
    ld de,0x008000
    or a
    sbc hl,de
    jr nc,external_full
    ld de,(external_size)
    ld hl,0
external_full:
    ld (external_size),hl
    push de
    pop bc
    ld hl,(external_cursor)
    add hl,de
    ld (external_cursor),hl
    or a
    sbc hl,de
    call send
    ld hl,(external_size)
    ld de,0
    or a
    sbc hl,de
    jr nz,external_send
    jp next_record

raw_record:
    call tape_word
    push ix
    pop hl
    push hl
    add hl,bc
    push hl
    pop ix
    pop hl
    call send
    jp next_record

patched_record:
    call tape_word
    push bc
    call tape_word
    pop de
    push ix
    pop hl
    push hl
    add hl,de
    ld a,(module_handle)
    ld (hl),a
    inc hl
    ld a,(module_handle+1)
    ld (hl),a
    pop hl
    push hl
    add hl,bc
    push hl
    pop ix
    pop hl
    call send
    jp next_record

wait_frames:
    call tape_word
    ld a,b
    or c
    jp z,next_record
    ld a,(iy+sysvar_time)
    ld d,a
wait_next_frame:
    ld a,(iy+sysvar_time)
    cp d
    jr z,wait_next_frame
    ld d,a
    dec bc
    ld a,b
    or c
    jr nz,wait_next_frame
    jp next_record

tape_word:
    ld bc,0
    ld c,(ix+0)
    ld b,(ix+1)
    inc ix
    inc ix
    ret
send:
    push ix
    push iy
    xor a
    rst.lil 18h
    pop iy
    pop ix
    ret

; The callback only copies the small payload. MOS receives DE=payload address.
; The first four bytes become a null key-up record before MOS handles the key.
packet_callback:
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
    jr nz,callback_done
    ld a,(ix+1)
    cp 'D'
    jr nz,callback_done
    ld a,(ix+2)
    cp 'P'
    jr nz,callback_done
    ld a,(ix+3)
    cp 'L'
    jr nz,callback_done
    push ix
    pop hl
    ld de,mailbox
    ld bc,10
    ldir
    xor a
    ld (ix+0),a
    ld (ix+1),a
    ld (ix+2),a
    ld (ix+3),a
    inc a
    ld (reply_ready),a
callback_done:
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    ret

complete:
    ld hl,saving
    ld bc,saving_end-saving
    call send
    call remove_callback
    call prt_stop
    ld hl,clock_name
    ld de,prt_metadata
    ld bc,prt_metadata_end-prt_metadata
    push iy
    MOSCALL mos_save
    pop iy
    or a
    jp nz,failed
    ld hl,(prt_cursor)
    ld de,prt_samples
    or a
    sbc hl,de
    push hl
    pop bc
    ld hl,prt_name
    push iy
    MOSCALL mos_save
    pop iy
    or a
    jp nz,failed
    ld hl,(tick_cursor)
    ld de,ticks
    or a
    sbc hl,de
    push hl
    pop bc
    ld hl,tick_name
    push iy
    MOSCALL mos_save
    pop iy
    or a
    jp nz,failed
    ld hl,(cursor)              ; ADL24 OK: transcript address.
    ld de,observations
    or a
    sbc hl,de
    push hl
    pop bc
    ld hl,result_name
    push iy
    MOSCALL mos_save
    pop iy
    or a
    jp nz,failed
    ld hl,success
    ld bc,success_end-success
    call send
    ld hl,0
    jr finish
failed:
    call remove_callback
    call prt_stop
    ; Save a compact stage/mailbox diagnostic before any potentially blocked VDU.
    ld hl,failure_name
    ld de,transactions
    ld bc,failure_state_end-transactions
    push iy
    MOSCALL mos_save
    pop iy
    ld hl,failure
    ld bc,failure_end-failure
    call send
    ld hl,1
finish:
    ld (exit_code),hl           ; ADL24 OK: return code.
    ld sp,(saved_sp)            ; ADL24 OK: restore stack on nested failure.
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    pop af
    ld hl,(exit_code)           ; ADL24 OK: return code.
    ret
remove_callback:
    ld a,(installed)
    or a
    ret z
    xor a
    ld (installed),a
    ld hl,0
    ld c,0
    push iy
    MOSCALL mos_setkbvector
    pop iy
    ret

saving: db 13,10,"RALLY-25 saving results...",13,10
saving_end:
script_name: asciz "script.bin"
result_name: asciz "replies.log"
failure_name: asciz "failure.log"
success:
    db 28,0,29,39,28,31,0,0
    db "RALLY-25 DONE: logs saved.",13,10
success_end:
failure:
    db 13,10,"VDPLET proof failed. Keep this run for the agent.",13,10
failure_end:
installed: db 0
reply_ready: db 0
transactions: dl 0
reply_flags: db 0
expected_kind: db 0
expected_token: dw 0
expected_value: dw 0
module_handle: dw 0
mailbox: blkb 10,0
snapshot: blkb 10,0
failure_state_end:
saved_sp: dl 0
cursor: dl 0
exit_code: dl 0
external_size: dl 0
external_cursor: dl 0
    include "prt.inc"
clock_name: asciz "clock.log"
prt_name: asciz "prt.log"
prt_cursor: dl prt_samples
tick_name: asciz "ticks.log"
tick_cursor: dl ticks
frame_number: dl 0
repeat_start: dl 0
repeat_count: dl 0
frame_deadline: dl 0
frame_fraction: db 0
prt_samples: blkb 3000,0
ticks: blkb 3000,0
observations: blkb 50000,0
; Builder verifies image ends before 050000.
