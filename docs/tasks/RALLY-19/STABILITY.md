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
