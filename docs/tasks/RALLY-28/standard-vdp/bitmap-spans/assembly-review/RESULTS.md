# SPAN-001-04/05 — Single-write buffer and emitted-assembly review

The demo now submits its complete737byte command in one MOS write, with only bitmap/centre fields changed in the embedded payload. Its64pixel results are identical to the previous35pixel demo. Compiler-emitted assembly confirms the packaging change and exposes avoidable stripe arithmetic in the sample and persistent large-stack addressing in the actual game. No additional optimization or throughput campaign has been performed; a fresh stopped Oryx profile is ready for Author review.

## Delivered packaging change

`SPAN-001-03/src/generated.hpp` contains one **writable initialized737byte `RoadCommand` array**: constant11byte parameter-update header,720byte payload, constant6byte CALL. Initial payload includes bitmap IDs, centre160and fixed per-row matrix IDs. The drawing loop patches only bitmap ID and centre fields; it does not rebuild the header/CALL or rewrite matrix IDs. Each view calls the sender once for this array. The separate grass clear, GP fence, labels and pixel verification remain separate writes and are not part of this one road submission.

The array is in writable `.data` at **0x457b2** in the linked sample. Independent extraction of the object's data and the final binary matches all737initial bytes; constructor/destructor tables are empty. Runtime's saved `command.bin` also matches the independently expected final view, including unchanged envelope/matrix IDs. Six views report six road writes. Generated assembly has one737byte send call in the road-update path; SDK `mos_puts` loads the address/count and executes one MOS RST18. No claim of an atomic UART transaction: interrupts and CTS waits still apply, and synchronous MOS transmission can still block.

| Ordinary sample drawing function | Before, checkpoint50acc3c | After |
|---|---:|---:|
| Static instructions in whole `draw` function |99|72|
| Local frame requested by `__frameset` |44bytes|23bytes|
| Road-envelope sender calls/view |3|1|
| Road bytes/view |737|737|
| Per-row parameter stores |6bytes|4bytes|

These are static/code-path observations, not measured cycles or speedup. The whole binary is23266bytes versus22473previously: initialized storage replaces the uninitialized parameter plane, and new output/counter diagnostics add code. The drawing function's72instructions are a static listing count; its loop repeats120times. [Exact compiler excerpts](EXCERPTS.md) include before/after drawing and stripe functions.

## Headless verification and review

Final exact binary SHA256: `40a992b93bc6c164877859ed3beab6b90d559a486a098f8a96d47399485b2e75`.

`SPAN-001-03/evidence/rally28-span03-single-write-test01/` records six completed views/64passing centre/edge/background readbacks, byte-for-byte identical to test04's64pixel records. The saved737byte command matches the host reference; runtime/input identities stayed unchanged. Both SDL drivers were forced dummy and CPU boost remained disabled. Owned emulator stopped; no other session was stopped. Approximately13seconds includes deliberate viewing pauses and is **not** an FPS result. No raw UART capture or full-frame equivalence claim is made.

Fresh stopped review on Oryx:

```bash
cd ~/Agon/mystuff/AgonArcade/.emulator/rally28-span03-single-write-review
./fab-agon-emulator
```

Same six views and controls: SPACE cycles, Q/Escape exits after the initial cycle. Audio is always dummy. Review remains a human gate. Old review/test profiles and evidence are preserved. No physical deployment, Flexe/firmware/SDK change, game replacement or commit/push.

## Compiler capability and trustworthy artifacts

The installed compiler is Agon LLVM15.0.7, upstream revisionc76386c0083e6a6236ff774275227e2389f85538. The audit obtains each actual C++ compile command from `make -n -B obj/main.o V=` and substitutes output/mode only. It retains `-Oz`, target/ABI settings, normal eZ80 GAS printer switches, includes and defines. The actual game is the ordinary standard build with no fixture defines. No actual game linking/rebuild/run occurs; inspection objects go to this audit's ignored workspace.

1. **`-S -fverbose-asm` works.** It provides function/block labels, loop nesting and folded spill/reload comments. It does not provide a C++ comment beside every instruction or carry arbitrary source comments through compilation. Use the function names/source files and LLVM IR to connect the listing to the source.
2. **`-gline-tables-only` was accepted but did not provide usable source mapping.** Generated listings contain zero`.loc`directives and inspection objects have no`.debug_*`sections. The debug-flag game's text differs:34458bytes versus34444ordinary. Ordinary emitted assembly/object is authoritative; debug attempts are retained as capability evidence, not used to explain the shipped hot loop. Sample debug text happens to match ordinary text, which does not establish general safety of adding the flag.
3. **Ordinary inspection text matches existing objects.** Both the sample and unchanged game reproduce their current object's`.text`exactly.98protected product/production files remain unchanged, including the game binary. Compiler, library, makefile, commands and source hashes are recorded in [AUDIT.json](evidence/AUDIT.json).
4. Full listings/optimized IR are in `evidence/{sample,sample-before,game}.{s,ll}`; `*-lines.s` are the unsuccessful source-line-table experiments. They are compiler output, not disassembly. A linked sample map/data extraction was used only to verify final initialization/placement. The previous product-wide [hot-loop review](../../../research/HOT-LOOP-REVIEW.md) and its range/consumer findings remain applicable.

## Sample hot path findings and ranked next candidates

1. **Precompute stripe depth/remainder by row.** Each view calls `painted(y,phase)`120times. Rows104–115return early; the other108calls execute a24bit divide (`__idivu`),32bit addition (`__ladd`),32bit remainder (`__lremu`) and32bit comparison (`__lcmpu`). Width/scale matrices are already precomputed, but stripe depth is still recalculated. For marked rows, depth is at most40000; valid phase0–7999gives a sum at most47999. Better still, a row table of `depth %8000` reduces the changing sum to0–15998and removes both recurring divide and remainder. Select the half-period by comparisons/subtraction. Prove exact equivalence across all8000phases and108marked rows before adopting; do not specialize only to the two demonstration phases. This is the strongest small next CPU experiment in this sample.
2. **Simplify parameter addressing after the arithmetic change.** The compiler already folds the bitmap high byte to a constant and hoists centre-byte values out of the loop. It still maintains a row counter and a six-byte offset, spills both around the out-of-line stripe call, reconstructs the base address each row, and reloads centre bytes from the frame. A walking record pointer/precomputed row phase could reduce this. Review new assembly after removing the expensive helper calls rather than assuming a hand-written packing loop or assembly routine is necessary.
3. **Avoid transmitting static fields.** Matrix IDs remain fixed in the initialized array but still consume240payload bytes each update. A resident sequence with row matrix IDs hardcoded would allow a four-byte record(bitmap ID+centre),480payload bytes and497header/payload/CALL bytes, subject to its independently measured VDP interpretation costs. This changes the parameter protocol; it was intentionally not mixed into the authorized same737byte packaging change. Bitmap high bytes/constant centres offer further optional compression, but should not silently specialize away curved-road support.
4. **Measure the completed bitmap road pipeline before selecting the larger direction.** Current evidence proves the mechanism and same picture samples, not a net gain over buffered polygons. The future bounded comparison must include real upload/CTS, resident command interpretation, transform drawing and completion, with setup/labels/readbacks/viewing pauses excluded. No additional benchmark is authorized by this return.

## Actual standard-game hot loop findings

The reviewed game is preserved RALLY-27/direct `rally-game/src/main.cpp`, not the isolated newer lookup candidates and not this static bitmap proof. This provenance matters: fixes to the preserved game should become isolated candidates and be carried across compatible consumers, not silently replace the accepted binary.

| Finding | Evidence and implication |
|---|---|
| Startup-only scratch storage persists in the hot-loop frame | `gameMain` starts with `ld hl,-4264; call __frameset`. Optimized IR contains a `rally::Stream` alloca from inlined `loadCars()`: a4096byte buffer plus size/overflow fields used to construct an11byte recolour command (`main.cpp:479`). That large frame remains during gameplay. The loop around game.s:1500 repeatedly forms addresses roughly4KiB belowIX using extra register loads/adds and push/pop sequences rather than short indexed accesses. Splitting/no-inlining setup or using appropriately sized command storage is a concrete non-numerical candidate; actual savings need a separate compile/measurement. The newer fixture driver does not necessarily have this frame. |
| Dense road still recomputes full track samples | `trackSample` has four32bit multiply sites and computes x,y,tx,ty; standard row projection repeatedly calls it. Prior audit's847wide multiplies/frame, including242for unused tangent results, remains supported. Carry recovered shared lookup/sampling savings into all compatible positioning consumers before polishing this abandoned dense calculation in isolation. |
| Adaptive band fitting repeatedly rescans centres | `Road::bandEnd` has nested candidate/row loops and two wide-multiply sites per tested interior row. Bitmap scanlines avoid polygon band fitting for road drawing; do not preserve that fitting work unnecessarily during eventual integration. World/scene consumers still need a shared coherent centre model. |
| Polygon strips repeatedly calculate the same endpoints | `Road::strip` contains two32bit `/256`helpers and four24bit multiply/divide pairs per strip. The shared candidates already hoist endpoints/use edge tables; preserve those wins when changing emission. Signed division truncation is not interchangeable with arithmetic right shift for negative centres without correction. |
| Scene/traffic/sign positioning has remaining wide arithmetic and repeated sampling | Compiler listings and the previous audit show full samples for camera/traffic headings and recalculated static sign layout. Apply shared tangent-only sampling, depth/edge tables and station caches consistently. The existing shared candidates address several of these; do not report them as new unimplemented work everywhere. |
| HUD/panel caching saves output but leaves formatting work | `clockText` emits one32bit multiply, three unsigned-wide divide and two wide-remainder sites; `drawHud` formats fields before comparing cached output. Panel builds its string signature before its cache decision. Numeric input/field dirty checks could suppress unchanged computation. Keep page-specific output invalidation correct; event changes still require rendering. |
| Physics remains a separate optimization/qualification problem | `Motion::tick` has six wide-multiply/five signed-wide-divide sites plus sampler calls; `lateralStep` has four/five. Attract steering also samples repeatedly. These are static sites with conditional/looped execution, not ticks-per-second. Preserve actual physics timestep/state semantics, independently benchmark any numerical candidate, then choose pacing with real transport costs. |
| Submission is synchronous | The sender reaches MOS RST18; grouping bytes removes call/setup overhead but does not eliminate byte transfer or CTS blocking. No current sample proves nonblocking physics during that transfer. Do not confuse this packaging change with the later gameplay scheduler. |

Suggested order after this review: row-phase table for the sample, then the finite road-only completed-pipeline comparison; separately promote the startup-frame issue and field-level HUD caching into the existing reuse audit for actual-game application. Choose and release one small step with the Author. No extra implementation, benchmark campaign or precision tradeoff is silently accepted.
