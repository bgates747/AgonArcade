# RALLY-24 headless Flexe results — 2026-10-13

## Executive summary

**The native modules execute and save usable logs, but candidate B is not yet
pixel-equivalent to the current renderer.** All six scene fixtures and the
coordinate probe completed on Oryx in both JIT and interpreter engines after
startup-upload retries. A matches the final reference scene exactly on both
tracks. B differs by **442 pixels on Fuji and 63 on oval**, identically in both
engines. These are scene pixels below the top24 status rows, not tolerated or
silently accepted differences.

B shows promising emulator headroom: its unpaced diagnostic batches complete
at roughly **44–47 frames per nominal MOS second**, versus **23–30** for replay.
**These are not hardware FPS or full-game FPS.** Replay omits eZ80 projection,
and emulated scheduling changes the figures. Real hardware timing is the next
measurement; no physical deployment or flashing occurred.

[Hardware fixtures and instructions](README.md) are ready. Each fixture saves
`replies.log` and `ticks.log` in its own directory; a failure saves `failure.log`.
The extra matrix probe will distinguish actual ESP32 conversion behavior from
an emulator peculiarity. Keep B experimental until that comparison is reviewed.

## 1. Comparable diagnostic timings

All numbers below are **nominal emulator time**, not elapsed host time. Native
CCOUNT is divided by240 MHz; MOS ticks by120 Hz. Mode136, 32 deterministic
poses/fixture, first four omitted from percentiles; batch rate includes all32.
Start-to-swap includes native/replay work and drawing/swap waiting. End occurs
when the ordinary synchronous VDP swap returns. Replay generation is unmeasured,
not zero-cost. All rows use the same pinned runtime firmware and assets.

| Track | Engine | Path | Native generation median ms | Start-to-swap median ms | Start-to-swap p95 ms | Diagnostic batch frames / nominal s |
|---|---|---|---:|---:|---:|---:|
| fuji | jit | REPLAY | — | 33.215 | 50.447 | 27.83 |
| fuji | jit | A | 0.100 | 32.144 | 49.125 | 33.10 |
| fuji | jit | B | 0.244 | 32.313 | 32.625 | 43.64 |
| oval | jit | REPLAY | — | 49.731 | 50.313 | 24.94 |
| oval | jit | A | 0.115 | 48.849 | 49.522 | 27.43 |
| oval | jit | B | 0.308 | 32.228 | 32.789 | 43.64 |
| fuji | interp | REPLAY | — | 33.499 | 50.268 | 29.54 |
| fuji | interp | A | 0.102 | 32.217 | 33.428 | 30.00 |
| fuji | interp | B | 0.246 | 23.648 | 32.709 | 46.83 |
| oval | interp | REPLAY | — | 49.836 | 50.238 | 23.13 |
| oval | interp | A | 0.116 | 32.147 | 49.389 | 27.83 |
| oval | interp | B | 0.299 | 32.339 | 32.673 | 43.64 |

1. A is the compatibility control: native visual projection, retained buffered
   matrix arithmetic. B replaces that arithmetic with native endpoints.
2. Scene clear, viewport, car/sign bitmaps, draw order and swap are included.
   Physics, input, scrolling scenery, HUD/audio and eZ80 projection are excluded.
   These rates must not be presented as integrated Rally performance.
3. The regular scene update remains147 bytes. This fixture adds page clear,
   viewport activation, swap and diagnostic calls; its native cases send187
   bytes/frame. The one-time guard installation increased by3 bytes/wrapper;
   recurring guarded CALLs did not change.
4. No per-frame replies, disk writes or debug prints are injected. End markers
   and command hashing add overhead; hashes run after the CCOUNT endpoint but
   are included in the batch clock. Final INFO acknowledgement adds an ordered
   completion boundary. MOS timing remains quantized, nominally8.33 ms/tick.
5. A median/p95 is not a missed-display-frame measurement. The JSON retains
   counts above33.333 nominal ms as budget comparisons, not measured optical
   misses. No camera, monitor or physical scanout was measured.
6. Host runtimes for successful isolated cases were about10–15 seconds including
   boot, startup transfer, execution and log retrieval. The14 successful runs
   total roughly three minutes. Retries/timeouts are separate, listed below.

Full samples, eZ80 submission ticks, byte counts and stack watermarks are in
[RESULTS.json](RESULTS.json). Both engines produce identical final scene pixels
within each path, even when their timing differs.

## 2. Correctness findings

1. **Actual native generation verified:** eight native scene runs (two tracks ×
   two variants × two engines) check768 generated command-buffer hashes against
   the independent host oracle. All match. The actual compiled Xtensa executes;
   the host does not substitute a numerical kernel.
2. **A pixel parity:** zero differing pixels against replay in the final captured
   scene on each track/engine. This checks two final poses, not every displayed
   pose. The broader host suite still passes5,840 states per variant plus35
   negative cases each.
3. **B parity exception:** the byte-exact B oracle uses signed truncation and
   generic float ordering, which is not sufficient to reproduce this firmware's
   matrix path. The follow-up probe reads460 actual matrix-generated X words:
   53 differ from the signed native reference. In44 cases a negative coordinate
   becomes-1; nine positive coordinates differ by one. Both engines return the
   same460 values. Raw comparisons are in [MATRIX.json](MATRIX.json).
4. The pinned VDP's `video/types.h::convertFloatToValue` converts fixed16 output
   directly from float to `uint16_t`; out-of-range negative C++ conversion is not
   a portable specification. Its DSP multiply uses `madd.s`, whereas B uses
   explicitly separated binary32 operations. These are source-grounded suspects,
   not a claim that physical silicon reproduces the emulator's nine rounding
   differences. The hardware probe is needed before changing B to mimic them.
5. **Guard defect fixed in the Rally wrapper:** `bufferConditional` initializes
   its int32 source to-1, then `readBufferBytes` copies only one byte into it.
   A literal operand1 is therefore unequal to ready1. Initial native runs
   generated correct buffers but drew a blank screen. Buffer-to-buffer equality
   against the immutable ABI version byte gives both sides the same high-byte
   representation and preserves the ready0 failure gate. No shared VDP code was
   modified. The host dispatch test now models the real representation.
6. The automatic qualifier now rejects blank/near-empty road captures. Initial
   black-screen timings are invalid drawing benchmarks and are excluded here.

## 3. Runner and resource corrections

1. MOS RST18 consumed only the low16 bits of a109,586-byte startup length. The
   transport trace stopped at44,050 bytes. The runner now splits startup output
   into32 KiB chunks. Fuji's209,200-byte startup and both track-data uploads are
   checked end-to-end by successful BIND/checksum validation.
2. The first diagnostic wrapper accidentally exported its internal helper,
   introducing a PLT relocation rejected by the unchanged loader. Making that
   helper static fixes admission. The builder now runs the real SDK loader over
   both packages before staging.
3. Separating diagnostic completion/hash work from dispatch keeps estimated
   module-only call chains at496 bytes for A and512 for B, within the declared
   limit. This excludes runtime callbacks/interrupt/window spill overhead.
   Diagnostic text/data: A7316/532 bytes; B7556/572 bytes. The command-task
   minimum free stack after runs was1700 bytes for A,2260 for B,2084 for replay.
   Those are emulator observations, not physical stack qualification.
4. The ordinary uninstrumented A/B package hashes are unchanged from the local
   tranche after adding an internal-visibility macro for the diagnostic wrapper.
   Production game sources and the shared SDK/runtime/emulator were not changed.
5. Old guest logs are deleted at fixture startup. A failed rerun cannot leave
   stale success logs looking current. Measurements stay in RAM until the batch
   completes; each fixture's expected manifest names the precise binary/tape.

## 4. Emulator startup stalls — unresolved

There were three observed upload stalls across the work: an earlier oval/B
interpreter run stopped after roughly184 seconds by the host, a final Fuji/B JIT
run reached its180-second deadline, and a final oval/B interpreter run reached
90 seconds. Each stopped in artwork startup before any `R24S` frame state or
native module load. Each subsequently completed on an unchanged retry.

They are **not passes**, and retry success is not a fix. Two final failed
receipts/traces remain under `.work/final-startup-stall` and
`.work/final-oval-startup-stall`; the earlier failure remains in Oryx's
`.work/pre-final-evidence/oval-b-interp` and profile history. The final fourteen
successful receipts match the currently packaged fixture manifests. No shared
Flexe changes were made to conceal or work around this issue. Escalate the
startup transport traces separately if it recurs; hardware runs will also help
separate fixture/VDP behavior from emulator transport scheduling.

## 5. Next decision and preserved evidence

1. Run the same six scene fixtures on the Agon with the matching VDPlet firmware,
   then the matrix probe. Return their fixture-local logs and firmware/clock
   identity. [README.md](README.md) gives exact commands and decoder usage.
2. Compare actual matrix coordinates first. Decide whether B must reproduce
   legacy endpoint conversion exactly or whether a documented visual correction
   is acceptable. No implicit tolerance or promotion has been made.
3. Review physical timings before adding the integrated eZ80 computation and
   full-game frame-cadence benchmark. The present replay provides a controlled
   draw/submission baseline, not that missing computation measurement.
4. All emulator processes are stopped. Production Rally and physical hardware
   remain unchanged. Changes are deliberately uncommitted pending the required
   human emulator validation and explicit commit approval.

[PROVENANCE.json](PROVENANCE.json) pins firmware, MOS, frontend, adapter, source,
module and evidence hashes. Full raw traces, replies, tick logs, VGA PPMs and
receipts are retained locally in `.work/evidence/` and in the isolated Oryx
project. `.work/rally24-hardware.zip` contains the SD fixture directories,
decoder, instructions, firmware image and SHA256 manifest; it performs no flash
or deployment. `.work/oryx-evidence.tar.gz` preserves the raw successful evidence.
