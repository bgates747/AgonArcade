# R19-11 stability evidence

Status: in progress. The root TODO remains the sole acceptance register.
R19-10's qualified source and performance evidence remain unchanged.

The stability diagnostic derives from the qualified frontend and uses its
accepted simulation with deterministic held-key inputs and four physics ticks
per rendered frame. This is a test-only clock/input layer, not a replacement
game input implementation. Actual SDL keyboard handling is covered separately
by the R19-09 native frontend cases and lifecycle/exit checks. Each track must
run for at least ten minutes; short observer qualification runs do not count.

An external Linux interposer observes the return of stock
`VDUStreamProcessor::bufferCall(2000, AdvancedOffset)`. It reads admitted state,
status and matrix values using stock exported read-only accessors on the VDP
thread, after the finite resident call has returned. It neither supplies answers
nor changes buffers. This observation establishes resident-job return, not
raster completion. Native swap evidence remains separately defined in
PERFORMANCE.md. All observer runs use dummy SDL video/audio and are untimed
diagnostics; their duration is used only to establish the soak requirement.

The observer reuses the qualified heap_caps_malloc/free tracker. Its live-byte
counts include allocations made through that native API, including PSRAM
allocator containers and shared objects. They exclude host allocations that
bypass it and must not be described as physical hardware heap measurements.
Reads of owned matrix metadata additionally check finite values and allocation
stability. Warmup/cache growth must be separated from steady-state growth.

Before accepting the observer, compare its raw state/status against independent
guest GP byte readback on the same short run. Record exact native function ABI,
source/library/runtime hashes and source copies. Retain any failed qualification
and use fresh evidence/profile names for retries. Full-scene malformed inputs,
sequence wrap, reset/reload/cleanup, sanitizer checks and final independent
requirements review remain necessary after the long replays.

## First qualified replay and loader checkpoint

The observer's LP64 ABI uses AdvancedOffset{uint32_t,size_t} (16 bytes, second
field at offset8), the native one-byte MatrixSize bitfields and the exported
readBufferBytes/getMatrixSize/getMatrixFromBuffer functions. Observations run
on the VDP thread after bufferCall2000 returns; no cross-thread buffer-map read
is made. Every compiler-owned ID plus the original player mirror is considered,
and the raw33-float road trace is checked separately. Readback validation uses
the existing guest GP nibble-copy path, not the observer's native accessors.

`golem-stability/observer-oval` and `observer-fuji` each passed128 frames, exact
host payload comparison and independent final92-byte guest readback. These
short runs qualified the observation mechanism but did not meet soak duration.
`soak-oval` then passed18064 frames/72256 guest ticks (602.133 seconds): every
80-byte admitted state matched the ASan/UBSan host replay, all106 matrices were
finite and all3698 tracked live allocations/720553 bytes stayed constant.
Fuji's short run lazily added one16-byte matrix-metadata node; steady-state
growth must be evaluated after that first branch is exercised.

The replay uses four physics ticks/frame and a1200-frame repeat schedule:
64 original frozen stress poses, demo assistance, held-key takeover, both held
turns, throttle/brake, grip adjustments and autosteer transitions. The accepted
input/physics body is extracted literally (only its Escape break becomes a
test-function return). Host/eZ80 comparison is per-frame raw state, not merely a
final hash. The frozen scene bytecode, simulation and artwork remain unchanged.

Loader review found that the previous loader accepted any nonempty bootstrap.
The candidate now generates size/FNV-1a signatures from actual compiler output,
validates bootstrap and cleanup before installation, and checks the staged
bootstrap again before executing it. Cleanup is fully read/checked into a
bounded6144-byte local array before any cleanup commands are sent; failed cleanup
remains retryable. FNV-1a detects damaged/mismatched local derivatives and is not
an authentication scheme. Recurring prepare/submit methods are unchanged.

`golem-loader/empty-fixture-fix` passes738 ASan/UBSan cases across both actual
track assets: missing/truncated/corrupted/oversized files, every read/seek/close
fault boundary, repeated-load ownership and cleanup retries. Its predecessor
`initial` caught a test-fixture bug (fwrite received a null vector data pointer
for a zero-length file); the test now skips that zero-length write. The initial
replay host build also mistakenly called Traffic.reset instead of init; its
compiler failure is retained under `initial-build-failure`.

The checked frontend build is `.work/frontend/checked-assets`; binary SHA256
f39646ce4f38258cf31529c7d504a8c29b24ac9c6284cb83a9b17a4fe210caed.
Both bootstrap/cleanup/road files are byte-identical to R19-09/R19-10.
This checkpoint does **not** qualify the new loader's native failure cleanup,
full lifecycle or new startup cost. The original frontend also returns from an
initialization error before releasing uploaded art; that path needs remediation
and native evidence before R19-11 can close.

Reproduction from the repository root uses `.venv/bin/python` explicitly:
`build_frontend.py checked-assets`, then
`build_stability.py checked-assets --frontend checked-assets`,
`probe_stability.py NAME --build checked-assets --track oval|fuji`, and
`probe_loader.py NAME --build checked-assets`, with these script paths prefixed
by `docs/tasks/RALLY-19/`. Use fresh names and put agondev/release/bin on PATH
for builds. All probes create canonical local profiles and launch dummy SDL.

## Requested clean stopping point

Both long replays and full-oval lifecycle passed. See DEBRIEF-2026-09-12.md
for exact results, loader fixes, the native two-vblank path and pending work.
The Author requested stopping for discussion. R19-11 and R19-12 remain open.

## Stack-fix candidate regression

After the Author resumed hardware diagnosis, the stock processLoop stack failure
led to selective compiler call inlining. These bootstraps differ from the earlier
replays; their old soak/performance results are not final-candidate acceptance.
See HARDWARE-DEBUG.md for the physical evidence and current firmware/card state.

The `hardware-inline` research frontend reproduces the production candidate's
two scene assets exactly. The explicit `--inline-qualified` builder option checks
the full66-pose proof, evidence/source identities and regenerated integrity
header, while retaining exact cleanup/road data and original simulation/transport.
Without that option the old strict bridge rejects the changed bootstraps.
Damaged bootstrap and stale-header negative checks also reject temporary copies.

Reproduction uses fresh names and the existing build environment:
`build_frontend.py hardware-inline`, followed by `build_stability.py`,
`build_lifecycle.py` or `build_render_work.py` with
`hardware-inline --frontend hardware-inline --inline-qualified`.
Prefix scripts with `docs/tasks/RALLY-19/` and invoke `.venv/bin/python`.
These are diagnostic builds; the card retains its separate production binary.

`probe_loader.py hardware-inline --build hardware-inline` passes834 sanitized
fault cases; the larger bootstrap sizes add read-boundary cases to the old738.
`probe_lifecycle.py hardware-inline-fuji --build hardware-inline --track fuji`
passes210 events/27 admitted states, sequence wrap and rejection/history checks,
three teardown/reload cycles, all853 owned IDs and the foreign canary check.
Equivalent cleanup phases remain255 allocations/560158 bytes, reload phases
3779/868319, and final teardown26/174986. These are native tracked allocations.
The updated oval lifecycle, long replays and final timing/controls still require
their own execution and audit. Physical stock compatibility remains unaccepted.

The matching oval lifecycle subsequently passed all210 events/27 admissions
and three cleanup/reload cycles, including all836 owned IDs and the foreign
canary. Reload phases remained3706 allocations/745461 bytes; cleanup phases
were255/560158 and final teardown26/174986, identical across repeated cycles.
Evidence: `evidence/golem-lifecycle/hardware-inline-oval/results.json`.
Both-track native missing/corrupt bootstrap/cleanup tests were then started;
their individual result files determine completion, not this progress note.

All eight native startup-failure cases subsequently passed: missing/corrupted
`.vdp` and `.clr` on each track returned the expected error31 and left no queried
scene/art/bootstrap buffer readable. Results are under `evidence/golem-failure/`
with prefix `hardware-inline-<track>-<case>`. The first final-asset long replay,
`hardware-inline-soak-oval`, was then started for18064 frames; completion and
steady-state memory still require its final report and the both-track auditor.

The corrected oval long replay passed18064 frames/72256 ticks (602.133 guest
seconds). Every admitted80-byte state matched the sanitized host replay and the
independent final92-byte guest readback matched. All106 matrices stayed finite;
all3698 tracked live allocations/745263 bytes stayed constant throughout.
Evidence: `evidence/golem-stability/hardware-inline-soak-oval/results.json`.
The matching Fuji run was then started; the final both-track audit remains open.

Fuji also passed18064 frames/72256 ticks. The independent both-track audit
`evidence/golem-stability/hardware-inline-audit/qualification.json` recomputes
all state/status/readback checks and steady memory from the raw captures.
Both runs exceeded600 wall seconds as well as602.133 guest seconds. Fuji's only
growth was one16-byte metadata allocation at frame8; the remaining18055 frames
stayed at112 matrices,3772 allocations/868137 bytes. Both runs cleaned down to
26 allocations/174986 bytes. Coverage includes59 natural lap crossings, all
surfaces, both steering/lateral limits, speed0..300, grip25..200 and4659 poses
with nearby visible vehicle depths. Actual keyboard inputs and final timing
remain separate checks; these replays do not establish physical performance.


All12 final frontend control runs subsequently passed and were independently
qualified in `evidence/golem-frontend/hardware-inline-qualification.json`.
There are638 exact host state records, unchanged input/physics/HUD source,
held steering limits of-21/+21, grip25/200, proper takeover and armed Escape,
zero invalid states,97 state/submit bytes per frame and cleanup/MOS exit.
Bootstrap-only startup is570 ticks/4.75s oval and1156 ticks/9.633s Fuji; these
values exclude art upload and are not whole-application startup times.
The Author also confirmed slow continued rendering after a board reset on restored
official VDP2.16.0. That physical startup correction is accepted separately from
native stability and the still-unacceptable physical speed. H2/H3 evidence and
limits are in HARDWARE-DEBUG.md. Final-asset timing and overall R19-11 review remain.
