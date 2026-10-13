# RALLY-24 local implementation results — 2026-10-12

## Executive summary

**The local tranche passes: the complete native road/car command generator fits
one VDPlet, and both candidates match the current-game host reference across
5,840 deterministic poses each.** Candidate B replaces the buffered road matrix
arithmetic as requested. It needs 7,016 bytes of executable memory, 556 bytes of
private data and an 8,392-byte package, all within the current runtime limits.
No runtime changes or module swapping are needed for this implementation.

The proposed recurring scene channel is confirmed at **147 bytes/frame** by
serialization/stream checks. For these deterministic inputs, current scene
commands have medians of 558 bytes for Fuji and 710 for oval: reductions of
**73.66% and 79.30%**, respectively. These are command-byte comparisons, not
measured wire throughput, CPU savings or FPS. Scenery, HUD, audio, viewport
setup and swap remain additional traffic.

**Next: physical runtime qualification, then deterministic visual comparison.**
Nothing has been flashed, deployed or run in an emulator. Actual native
execution, framebuffer equality and performance remain unproven. In particular,
classic-ESP32 DSP rounding and the existing negative float-to-word conversion
need physical qualification before calling candidate B pixel-equivalent.

## 1. Work completed

1. Froze the Author-approved local scope in LOCAL-CONTRACT.md after separately
   preserving and pushing Choplifter and the Rally research/roadmap.
2. Implemented task-local canonical asset export, 32-byte arguments, 112-byte
   world state, three bounded output buffers and ready-clearing/conditional
   execution wrappers. The channel sends world positions and essential state;
   no road spans or projected car coordinates cross this proposed interface.
3. Implemented native lookup/band selection and player/opponent projection,
   scale, view/reflection and ordering. Existing signs, finish stripe, crash
   drawing and invulnerability blink move with the visual dependency chain.
   Physics, road/kerb/grass tests, traffic simulation and collisions remain
   outside the module. Production game code remains unchanged.
4. Implemented both A (buffered section control) and B (native road endpoints).
   Both retain ordinary VDP rasterization and bitmap affine rendering.
5. Compared complete generated streams against the current-game host oracle,
   exercised failure gates and sanitizers, compiled native packages and used
   the unchanged SDK image loader for admission/relocation checks.
6. Preserved reproducible tooling, result summaries and artifact hashes. No
   RALLY-25/26 work or playable-game integration was started.

## 2. Comparison results

| Test | A: compatibility control | B: native road arithmetic |
|---|---:|---:|
| Fuji poses with exact host command equality |4,608 /4,608|4,608 /4,608|
| Oval poses with exact host command equality |1,232 /1,232|1,232 /1,232|
| Malformed input / lifecycle / service-failure cases |35 passed|35 passed|
| Maximum simultaneous leases observed |3|3|
| Text allocation |6,780 B|7,016 B|
| Private data allocation |516 B|556 B|
| Package |8,092 B|8,392 B|
| Undefined native symbols |0|0|
| SDK admission / relocation |pass,36 relocations|pass,38 relocations|
| Compiler entry stack frame |336 B|352 B|
| Source-call-graph module stack estimate |464 B|480 B|

Limits are 8,192 B text, 4,096 B private data and 16,384 B package. The stack
estimate includes nested module emitter calls, but excludes runtime callbacks,
command-task stack, interrupts and register-window overhead. It is not a
physical watermark or a guarantee that the runtime task stack is sufficient.
The package builder's 512-byte declaration is not enforcement.

Both variants also pass the full host comparison and negative cases with
AddressSanitizer and UndefinedBehaviorSanitizer. Output-capacity canaries cover
truncated and sufficient buffers. Wrapper tests cover invalid runtime handles,
duplicate successful sequences and failures while writing each of the three
outputs. All suppress stale/partial command execution. Generated-list decoders
stop at the return terminator despite poisoned trailing bytes.

The pose set uses fixed seed240012, every track interval's beginning/end and
adjacent station values, four stripe boundary phases, lap wrap and500 random
poses per track. It cycles steering, panel/perspective/traffic flags,0..6 cars,
near/far clipping boundaries, signed lane limits, crash counters and blink.
It is not an exhaustive enumeration of every possible world state or a live
physics replay. Root SOURCES.json pins reference code; tests fail if it changes.

Host comparison/negative-test execution took0.770 seconds unsanitized and1.267
seconds sanitized on this aarch64 host in the recorded run. Those durations
include oracle subprocess generation/comparison, exclude compilation and are
reproduction estimates only, not target rendering performance.

## 3. Resources and traffic

| Scene channel for sampled inputs | Fuji | Oval |
|---|---:|---:|
| Current host command median |558 B|710 B|
| Proposed state + four CALLs |147 B|147 B|
| Median reduction |73.66%|79.30%|
| Largest B road output observed |3,762 B|3,411 B|
| Largest actor output observed |350 B|350 B|
| Largest player output observed |141 B|141 B|

The current-channel counts come from candidate A's matching ordinary host
streams with the three native-output terminators removed. They include the
finish/sign/current crash dependencies. They exclude common surrounding frame
commands, uploads, binding and diagnostics. Scene selection is a correctness
stress set, not a weighted sample of typical play.

Keep the conservative20KiB/2KiB/256B output allocations for now; observed maxima
do not prove worst-case bounds. Assets stay in separately leased resident
buffers, not module private data. The persistent asset/output estimate and
contiguous allocation/consolidation concerns in REVIEW.md still apply.

## 4. Findings and corrections during implementation

1. Inactive cars must contribute zero distance to the original exchange sort,
   even though they draw nothing. Giving them another distance changes the
   order of equal-distance active cars because that sort is unstable. The
   initial parity run caught this; the native code now preserves it.
2. Lookup interval selection needs all14 fractional bits. Reconstructing it
   from Q12 loses two bits at interval boundaries; the module preserves Q14
   separately and uses Q12 only for polynomial evaluation.
3. GCC lowers aggregate initialization/copy to memset/memcpy even with
   `-fno-builtin`. Two small module-local hidden byte routines satisfy those
   calls; the SDK and import contract are unchanged. No external libc or
   allocation dependency remains.
4. An initial compiler entry frame was640B. Moving bounded car/order scratch to
   private module data reduced the final entry to352B. That is valid only for
   the existing synchronous, non-reentrant entry contract.
5. Frozen current routes bound heading to±1920 and lateral Q8 to±14260, from
   routes_data.hpp and routes-proof.json. These now explicitly constrain ABI1;
   player lateral remains±38400. Future route changes require reviewed limits.
6. BIND validates distinct buffer ranges, exact asset identity/checksum and
   directory offset/width/count/range arithmetic. It retains no acquired
   pointers. After binding, the owner must keep resources/configuration
   immutable until rebinding; checksum validation is deliberately not repeated
   per frame. This is a trusted application contract, not a security sandbox.

## 5. Remaining gates and next tranche

1. Obtain the VDPlet runtime owner's physical LOAD/RUN/UNLOAD and buffer-service
   qualification, or explicitly schedule that prerequisite. Current SDK docs
   still label physical qualification pending. Local image admission does not
   execute native instructions.
2. Establish bench ownership, current firmware identities and recoverable
   startup/input before any physical work. No installation authority is inferred
   from this local tranche.
3. Run finite diagnostic jobs and record real stack watermark, buffer allocation
   headroom, cleanup and rebind behaviour. Prove queued Canvas work cannot
   outlive resources being reused or unloaded.
4. Compare B's actual endpoints and complete frozen colour frames against A and
   the current renderer on the same runtime-enabled firmware. Resolve DSP
   accumulation and signed conversion behaviour without relaxing parity or
   silently changing upstream. Host B uses generic binary32 multiplication;
   that does not establish the physical DSP implementation's exact result.
5. Only then integrate an optional experimental Rally path and execute the
   paired performance matrix in MEASUREMENTS.md. Human visual acceptance follows;
   submission rate is not displayed FPS. Keep current production available.

Sources/tools are in experiment/README.md. Machine-readable summaries are
LOCAL-HOST-RESULTS.json, LOCAL-SANITIZER-RESULTS.json, LOCAL-NATIVE-RESULTS.json
and LOCAL-PROVENANCE.json. Generated packages, raw build logs and disassembly
remain under ignored experiment/.work/ and can be regenerated with `make all`.
