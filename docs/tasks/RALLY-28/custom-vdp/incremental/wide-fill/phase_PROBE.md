# Isolated road-fill probe

The standalone probe compares byte and aligned word fills on actual clipped road
span calls without changing the accepted game fixture. Host qualification and
target code inspection pass. The separately guarded silent Oryx run is complete:
all80 windows pass with52.65% fewer raw emulated counter units. It ran on a warm,
contended host; this is provisional counter evidence, separate from the
whole-frame comparison. See [results and limits](RESULTS.md).

1. `phase_probe.py build phase-probe02` produced
   `.work/phase-probe02/fixture/`, with exact input hashes in
   `.work/phase-probe02/phase_BUILD.json`. The existing accepted moving-review
   `probe.bin` and `motion.bin` are copied byte for byte. The motion file is
   retained because the accepted driver loads it at startup, even though this
   tape sends no motion opcode. No driver, firmware or SDK change is required.
2. The input contains11,788 actual calls captured from the accepted control's
   selected frames1,60,120,180,240,300,450,600,750 and900. The host replay's
   `span-inputs.json` records provenance and per-frame hashes. Records preserve
   order, clipped endpoints, row offset, colour and empty calls. The separate
   first grass-row `memset` is outside this captured family.
3. Each sequence runs at four pixel-base shifts0–3 and in both byte/wide orders:
   80 paired sample windows. Each timed window repeats its exact sequence eight
   times with road stride320. Input descriptors also contain full-scratch CRC32
   values calculated independently by Python. Each scratch buffer has38,432
   bytes, with38,400 pixels at offset8 plus the selected shift and guards around
   the pixel extent.
4. The byte function preserves the frozen `r28_span_fill` body and the native
   module's exact byte-loop `memset`, with the pinned SDK's `-Os -fno-builtin`
   flags. The candidate includes the actual `wide_fill.inc`. The sole diagnostic
   function change is matching `noinline` on both tested fills. A shared replay
   function calls either through the same indirect dispatch. The candidate's
   alignment check uses the actual leased destination pointer.
5. Each interval contains span decoding, the replay loop, indirect fill dispatch
   and the fill itself. Buffer leases, input checks, reset to0xA5, full byte
   comparison, guard checks and CRC32 are outside the interval. An otherwise
   empty indirect fill is timed and reported separately without subtraction.
   Per-core raw CCOUNT deltas must be positive and below2^31; the module checks
   core identity before and after each paired measurement. Interrupt and cache
   effects are not excluded. These are uncalibrated raw emulated counter values,
   not physical cycles or milliseconds.
6. The probe uses the four existing buffer leases simultaneously: input, byte
   scratch, wide scratch and output. Every lease is released in reverse order on
   success and failure. A latched error stops later sample execution. The
   4,512-byte output has an explicit count/core/input-CRC header and80 records
   with counts, bytes, order, shift, raw intervals, CRCs, mismatches and guard
   failures. Runtime admission and error replies are checked by the tape.
7. The target module is2,808 bytes, with1,916 bytes of resident text and16 bytes
   of resident data. GCC's reported entry frame is288 bytes; the deepest static
   module call path adds replay48, byte-fill32 and byte-memset32, totaling400
   bytes within its declared512-byte allowance, before runtime callback frames.
   The inspection file shows only `s8i` in byte `memset`; the candidate has byte
   prefix/tail stores and an aligned `s32i.n` body, with no helper call. The
   common replay contains `callx8`.
8. Ordinary and ASan/UBSan host models pass all80 windows, expected CRCs, whole
   scratch equality, guards,324 balanced granted/released leases and rejection
   of an81st sample. Host fake counters test the wire format only. The first
   build, `.work/phase-probe01`, preserves a LeakSanitizer rejection caused by
   the ptraced sandbox. The qualified second build disables LeakSanitizer;
   AddressSanitizer and UndefinedBehaviorSanitizer remain enabled.
9. The fixture has80 sample windows, zero physics ticks,23,400 retained reply
   bytes, and82 MOS/PRT marks. It performs LOAD, INFO17 before/after, per-window
   success and committed-count checks, complete log retrieval, UNLOAD, buffer
   deletion and text-mode cleanup. The generic runner's `observed_fps` field
   measures sample-window throughput and has no gameplay meaning. Only the
   separate whole-frame fixture supports a game-frame comparison.

After staging/running with the pinned silent runner and boost/thermal supervisor,
verify a returned guest directory with:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/wide-fill/phase_probe.py verify /absolute/path/to/profile/sdcard/rally25
```

`phase_verified.json` reports raw intervals and reductions, exact byte/guard/CRC
checks and timer restoration. Emulator execution, target results and any
diagnostic admission failure must be preserved separately from host evidence.
