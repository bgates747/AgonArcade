; Same AgonDev C ABI / RST18 block writer as its mos_puts.src, separate
; symbol so diagnostic wrapping never bypasses real MOS/UART/CTS handling.
.assume adl=1
.section .text
.global _uart_write
_uart_write:
    push ix
    ld ix,0
    add ix,sp
    ld hl,(ix+6)
    ld bc,(ix+9)
    ld a,(ix+12)
    rst.lil 0x18
    pop ix
    ret
