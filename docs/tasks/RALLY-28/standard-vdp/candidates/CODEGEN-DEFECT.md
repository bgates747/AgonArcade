# Instrumented panorama conditional call — 2026-10-15

The host/target byte check rejected the shared v4 fixture. Its eZ80 compiler emits a panorama call unconditionally after overwriting the flags used to decide whether that call is needed. A small isolated helper avoids this code sequence. The dense control remains byte-identical; no compiler, SDK or preserved game source was edited.

The shared v4 CPU runs send2,793extra bytes and399extra calls: one seven-byte panorama bitmap draw for every repaint. The recovered live prefix differs first at frame-zero byte39, with an unwanted bitmap atx1024 immediately after the valid draw atx0. This is a fixture correctness failure, not an accepted approximate rendering choice or an explanation for the separate UART stalls.

Generated v4 code for `if (1024-offset<=scene.skyRight) vdp_draw_bitmap(1024-offset,0)` contains:

```asm
ld hl,(scene+9)       ; skyRight
or a,a
sbc hl,de            ; signed comparison against1024-offset
call pe,__setflag    ; signed-overflow correction
or a,a               ; destroys comparison flags and clears carry
sbc hl,hl            ; constructs y=0 and leaves sign clear
push hl
push de
call p,_vdp_draw_bitmap ; always taken after the zero construction
```

The isolated generated product now calls `panoramaDraw(x)`, a non-inlined one-argument helper that setsy0 in its own unconditional call. v5 emits comparison/overflow correction, `push de`, then `call p,panoramaDraw`, preserving comparison flags. The complete whole-scene host stream is unchanged. Its first900-frame target summary reports exactly1,229,909application bytes/106,784calls again; all five final boost-off CPU cases now independently verify exact expected byte counts and final fixture state.

[Compiler/diagnostic receipt](evidence/CODEGEN-DEFECT.json), losslessly saved [v4 disassembly](evidence/main-v4.dis.gz) and [corrected v5 disassembly](evidence/main-v5.dis.gz) preserve the evidence. `generated-v4` retains the rejected source; `generated`/`BUILD-V5.json`/`binaries-v5` identify the correction. Shared v4 cases have explicit REJECTED receipts; dense v4 is separately verified.

This observation is local to the consumed AgonDev output. No owner notification or compiler repair has been performed. Further compiler work is outside this fixture tranche.
