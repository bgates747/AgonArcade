# RALLY-24 — native execution and portable timing fixtures

Contract frozen before implementation, 2026-10-12. The Author authorizes
headless Fab/Flexe runs on Oryx, followed by their own physical Agon runs.
No physical deployment, flashing, reset, graphical emulator or alert in this
tranche. Emulator changes remain uncommitted pending human validation and
explicit commit approval.

## Measurements and limits

Use the actual compiled A/B Xtensa modules and runtime-enabled ESP32 firmware.
Keep production game and shared emulator/runtime sources unchanged. Add a
task-local diagnostic module wrapper, not an interpreted substitute.

Fixtures use mode 136, identical deterministic world states and resident Rally
artwork on both tracks. Compare native generated command hashes with the
independent current-game oracle. Compare final displayed pixels with a replay
of that oracle's commands on the same firmware. Include the retained matrix
control A and native-endpoint candidate B.

Buffer native CCOUNT timestamps and eZ80 MOS ticks in RAM; save logs beside
each fixture after its measured batch. Include status, sequence, command
hashes and byte counts. No per-frame serial debug or SD writes. Native cycle
counts cover generation; a following timestamp after the ordinary synchronous
VDP buffer swap measures command/drawing/swap completion, not optical scanout.
MOS ticks measure aggregate submission and completion with their actual coarse
resolution. Report emulator cycle/time separately from host elapsed time.

The replay control measures sending/rendering identical precomputed commands;
it does **not** measure eZ80 projection cost or full-game FPS. Do not infer those
from this fixture. Hardware results and playable-game integration remain later
gates. Diagnostic overhead, finite sample size and emulator non-cycle-exact
execution must accompany all performance tables. Correctness failures take
priority over optimisation.

## Checklist

- [x] F01 — Implement bounded fixture runner, diagnostic wrapper, build and log decoder.
- [x] F02 — Build fixtures, verify local expected commands, limits and log parsing.
- [x] F03 — Stage isolated project profiles on Oryx with pinned runtime identities.
- [x] F04 — Run native fixtures headlessly in JIT and interpreter; investigate failures.
- [x] F05 — Record comparisons, limitations and hardware run/retrieval instructions.

Each fixture directory contains its executable, tape, expected manifest and
run instructions. Hardware execution uses relative filenames and writes its
own results there. Completed logs are copied aside before reruns; failed runs
produce a failure record. No results are written to production directories.

## Completion record — 2026-10-13

The checked items mean implementation, execution and reporting are complete;
**B pixel parity is not accepted**. See [results](flexe/RESULTS.md).
The14 final receipts pass native execution/log checks after startup retries;
A matches captured pixels, while B retains the documented endpoint differences.
A source-backed matrix-coordinate probe was added within this tranche after
those differences appeared. It is included for the Author's hardware comparison.
No physical device was accessed. No game integration or publication occurred.
