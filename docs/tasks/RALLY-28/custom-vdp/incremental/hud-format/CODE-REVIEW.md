# HUD format cache implementation checks

The shared presentation now caches unchanged formatted strings. Actual old/new
functions emit identical HUD/footer bytes and retain identical text/color cells
on both pages. On the deterministic900-frame race model, formatting calls fall
from7,200 to2,645 (**63.26% fewer**). This is a work-count result, not an FPS gain;
completed-frame timing awaits the reserved Oryx comparison.

1. `rally-game/include/hud_format.hpp` holds bounded48-byte HUD fields and a
   40-byte footer, matching the old temporary buffer sizes. A valid bit handles
   initial zero keys. Constant initialization avoids unsupported CRT constructor
   execution; both the standard game and private fixture have empty startup/
   finalizer tables.
2. Keys describe the complete formatted content: record score, rounded remaining
   seconds, lap ticks, score, signed speed and rank. Footer packs the two u8 lap
   fields plus the Circuit/Arcade label bit without overlap. Phase/record/track/
   grip changes still choose values through the original logic. Equal keys
   therefore mean equal strings; no screen-page state is cached here.
3. Existing `Hud::emit`, per-page invalidation, cell colors and all drawing stay
   unchanged. Footer strings are cached but drawn every frame after the native
   road output's clear. Development-only diagnostics still format each frame.
   The old `clockText` arithmetic/format remains unchanged, including width and
   overflow semantics.
4. Ordinary, address/undefined-sanitized and development host builds each pass
   12,932 comparisons of the actual extracted functions. These cover repeated
   fields, all phases/policies, both tracks, record replacement, grip/steering
   keys, rank/lap changes, invalidation, edge values and the original900-frame
   motion/rank workload. Standard race formatting counts are7,200→2,645;
   development counts8,100→3,545. LeakSanitizer alone is disabled under ptrace.
5. The actual AgonDev standard game builds and passes release-instrumentation/
   empty-CRT checks. The first invocation omitted the toolchain's required PATH;
   its log is preserved separately. The corrected invocation uses the installed
   toolchain PATH and succeeds; no code fix was required for that shell failure.
6. Private guest binary changes from`685f4b4c…` to`c6d75022…`. Native image
   `479fe1ac…`, firmware`8da2ebfd…`, artwork, motion, generated state and all
   completion/error handling are identical. Each fixture pair differs only in
   guest binary and metadata.103old control/archive inputs remain exact; the
   live game's presentation edit is explicitly released and recorded separately.
7. Generated eZ80 text grows31,941→32,476bytes (+535); BSS133,496→133,859bytes
   (+363). Data875 and rodata7,492 stay constant. `drawHud` stack frame shrinks
   336→291bytes; scratch string temporaries are smaller. These are compile-time
   sizes, not target stack-watermark or speed measurements. BSS ends437,327,
   below the existing0xa0000guard. The native image is not rebuilt.

The six-run schedule and84-file readiness freeze were completed before joining
the shared FIFO. First failure stops; no retry is implicit. A fresh stopped
review profile is staged separately. New code/evidence remain uncommitted and
need the Author's moving visual/publication decision after benchmark return.
