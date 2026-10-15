# RALLY-28 — Faster Rally rendering: shared research and two implementations

Research cheaper arithmetic, geometry and drawing for both Rally implementations. Apply the research first to the standard-VDP game, where pseudo3D computation runs on eZ80; then to the custom-VDP game using Golem/VDPlets. RALLY-28 owns the entire effort: shared findings, separate application work and independent acceptance evidence for both versions. The Author requests one task with separate code areas and the standard version first. Author's2026-10-14 “go” released the first hot-loop research item: completed review below. No candidate implementation, benchmark, emulator run or publication release is inferred.

## First research result —2026-10-14

[MATH-001-01 hot-loop review](RALLY-28/research/HOT-LOOP-REVIEW.md) and [machine-readable evidence](RALLY-28/research/AUDIT.json) are ready. Unchanged standard/native eZ80 source inspections reproduce the preserved objects byte for byte;226 existing inputs/artifacts stay unchanged. ABI confirms16-bit short,24-bit int/pointers and32-bit long. Dense standard projection executes847 software-wide multiplies/frame, including242 for discarded ahead tangents; strip layers repeat endpoint divisions and edge arithmetic. Prioritize removing work and proving ranges before narrowing types. No speedup or CPU headroom measured. Native responsibility/source/eZ80-code map is recorded separately; no new Xtensa qualification. Next research item: MATH-001-02 bounds/rounding, before an isolated STD experiment proposal. Existing native human startup defect remains open.

## Work areas and priority

| Area under RALLY-28 | Location | Responsibility/priority |
| --- | --- | --- |
| Shared research | `docs/tasks/RALLY-28/research/` | Hot-loop/math/library audit, algorithms, reusable references and comparison methodology |
| Standard VDP/eZ80 | `docs/tasks/RALLY-28/standard-vdp/` | All pseudo3D computations on eZ80; first implementation priority |
| Custom VDP/Golem/VDPlets | `docs/tasks/RALLY-28/custom-vdp/` | Residual eZ80 versus Xtensa/native renderer work; second implementation priority |

Keep version-specific code, build outputs, fixtures and results in their respective areas; place only genuinely shared material in research. Machine-local builds/traces belong in each area's ignored `.work/`. Preserve the production trees and prior task fixtures as controls. All work remains registered through the single RALLY-28 entry in root TODO; these areas are not independent numbered tasks.

Supply enough shared research to start the standard version without waiting for all custom-runtime investigation. FS-001-07 is a separate custom-version visual defect and does not block standard research/application planning. Techniques can transfer between areas; benchmark/acceptance evidence stays specific to the version tested. Original MATH, FAST, STD and NATIVE subtask identifiers are retained.

## Immediate subtask — recover the existing lookup engine

Author amendment, 2026-10-14: assess the preserved lookup engine before polishing the live standard projection. Write this subtask, commit/push all current dirt in logical groups, then execute the assessment. Existing MATH/FAST/STD/NATIVE identifiers remain fixed; the new identifier avoids renumbering them.

- **LOOKUP-001-01** [ ] — Trace the preserved R16/R18/R22 lookup lineage and R27 replacement, pin actual source/table/generator/build identities, and separate lookup mathematics from the buffered VDP matrix emitter. Compare current live projection, lookup projection and current native helper by recurring operations, memory/assets, rounding/coverage and processor ownership. Inspect emitted eZ80 arithmetic and existing performance records without treating unlike fixtures as a controlled comparison. Where useful, perform bounded host feasibility checks of lookup centres/bands with direct final-vertex emission compatible with standard VDP; keep all code/build/evidence in the RALLY-28 areas and production controls untouched. Deliver a reuse recommendation and concrete smallest standard-version derivative proposal before further live-engine micro-optimization. No adoption, replacement of the full game, new emulator/hardware run or resumption of paused RALLY-20 is implied by this assessment.

This lookup assessment takes priority over MATH-001-02 and AUD-01/AUD-02 implementation selection. It can reuse the completed arithmetic audit. Record evidence under `RALLY-28/research/`, with any isolated standard-only feasibility code under `RALLY-28/standard-vdp/`. Author's all-dirt checkpoint instruction explicitly authorizes publication of the existing unfinished native fixture and research state; it does not mark FS-001-07 visually accepted.

## Starting evidence

The current native helper already uses track/stripe lookup tables and adaptive vertical bands. `renderer-helper/render_core.inc` still evaluates band centres, computes binary32 section vertices, emits several material layers and sends ordinary drawing-command lists back through VDP command processing. Opponent/car transforms add other work. These observations identify possible costs, not measured bottlenecks.

Matched flat-background unpaced fixture: Console823.45FPS versus Flexe29.02FPS with byte-identical inputs. The fuller native fixture subsequently measured28.51Flexe FPS with panorama/HUD/audio, but lacks matching hardware qualification and its Author graphical launch stalled during startup (FS-001-07). These workloads/results are not interchangeable. Preserve R27-05 and all existing native fixture inputs/evidence unchanged; build future experiments separately.

## Subtask — review the current game hot loop and arithmetic widths

Author amendment,2026-10-14: explicitly review the current hot loop for unnecessary32-bit arithmetic on eZ80. Prefer suitable16-bit or native24-bit integer/fixed-point operations; explore reduced rendering accuracy when it buys meaningful speed. Where integer methods are unsuitable, evaluate the hand-written binary16 routines in the Author-referenced `agon-maths` partial Berkeley SoftFloat port, including an AgonDev assembler/C/C++ integration path. This releases the review/design task, not implementation or new benchmark runs.

- **MATH-001-01** [x] — Completed2026-10-14: [review](RALLY-28/research/HOT-LOOP-REVIEW.md), [receipt/reproduction](RALLY-28/research/README.md). Traced maintained standard hot loop first, then custom full-scene fixture; inspected unchanged-source eZ80 assembly/optimized IR against preserved objects. Inventoried player/control/rules, sampling, geometry, indexing, formatting, packets, clocks and waits, with processor/frequency/helper evidence and unknown cycle costs. Static deductions are distinguished from runtime measurements. Native Xtensa responsibility is mapped from current source; no new target module was compiled/qualified.
- **MATH-001-02** [ ] — For each candidate derive signed/unsigned value and intermediate bounds, then compare16-bit,24-bit,32-bit and fixed-point representations. Include constants, mixed-width expressions, multiply/divide intermediates, shifts, address/index arithmetic and conversions. A final value fitting16or24bits is not sufficient proof that all preceding arithmetic fits. Examine camera-relative/local-coordinate and split quotient/remainder formulations that avoid unnecessarily wide products. Preserve wrap, negative-coordinate rounding and existing checked-error semantics where required.
- **MATH-001-03** [ ] — Propose explicitly approximate rendering variants: fewer fractional bits, coarser tables/interpolation, reciprocal approximations, incremental curves and reduced geometry/stripe precision. Measure error where it affects visible motion: horizon, shared edges, curve/bin/lap seams, stripe cadence, car/sign alignment and background continuity. Author is willing to trade rendering accuracy for speed; exact pixel equality is not the universal acceptance condition. Keep a preserved exact control, disclose artifacts and use Author visual review rather than prolonged approximately99% parity polishing. Keep authoritative world/collision/game-rule changes separate from presentation approximations.
- **MATH-001-04** [ ] — Locate and audit `agon-maths` and its partial hand-coded Berkeley SoftFloat half-precision implementation. Record repository/revision/license/provenance, available operations/conversions, rounding and exceptional-value behavior, missing pieces, calling conventions and existing verification/performance evidence. The supplied location/name is a reference to investigate, not an already-consumed library pin; it was not found at `/Agon/mystuff/agon-maths` in the initial check.
- **MATH-001-05** [ ] — Design the smallest AgonDev-compatible port/wrapper for the needed half operations. Translate ez80asm syntax/directives/symbols to the AgonDev assembly toolchain; document ADL mode, register preservation, stack/argument/return layout,16-bit payload representation, relocations and C/C++ declarations. Use the same toolchain as the game. Do not assume a compiler half type or binary16 storage produces binary16 arithmetic; inspect code and make conversions explicit. No library/source edits outside Rally's ownership fence without their owner's agreed scope.
- **MATH-001-06** [ ] — Compare narrower integer/fixed-point and software-half proposals by total work, including conversions, wrapper calls, memory access and full-loop effects. Test representative ranges, cancellation/accumulation, overflow/underflow and visible jitter; consider local/scaled coordinates where half cannot retain required world-space range/precision. Software16-bit float is an alternative to measure, not an assumed speedup over32-bit integer or float. Report speed/precision/memory tradeoffs and nominate bounded experiments for Author release.

Audit eZ80 and Xtensa separately: a narrower representation that helps eZ80 can be neutral or slower on the32-bit VDP processor. Review compiler ABI widths and instruction selection rather than assuming ordinary C `int` is16bits or that the shortest storage type emits the cheapest arithmetic. Current32-bit Golem route/contact semantics and previously proven wide intermediates remain controls, not automatically replaceable with narrower values.

This review precedes selection of the geometry/filler experiments below and shares measurement requirements with RALLY-25 TRF-001-55/56. It treats the maintained standard full game's complete eZ80 hot loop as the first target, and the custom architecture's residual eZ80/Xtensa work as the second. Do not confuse either with deprecated renderer experiments.

## Candidate approaches

| Candidate | Possible saving | Main question/risk |
| --- | --- | --- |
| Narrower integer/fixed-point and incremental band geometry | Fewer repeated floating-point vertex operations | Which current rounding and shared-edge rules must remain exact? |
| Software binary16 via AgonDev assembly wrappers | Smaller arithmetic/storage may help some operations | Partial library coverage, conversion overhead, precision/range and actual eZ80 cycle cost |
| More precomputed/cached centres or endpoints | Shift work from frames to tables/cache updates | Memory footprint, cache churn, seams and interpolation error |
| Fewer road primitives/material passes | Less command processing and overdraw | Kerbs/stripes/finish and curve appearance; may change pixels |
| Native clipped horizontal spans | Avoid building/parsing much of the polygon command stream | Mode136 framebuffer/controller support, drawing owner and completion interface are unverified |
| Prebuilt road rows or bitmap warping | Reuse pixel patterns instead of reconstructing them | Whether stock bitmap operations actually avoid work on Agon; no per-scanline hardware-scroll assumption |

Do not assume multiplication is expensive merely because it was on an old6502: Xtensa arithmetic, memory traffic, graphics primitives and command dispatch must be measured on our actual path. A faster curve formula alone might leave the expensive raster work unchanged. Conversely, fewer large polygons might beat many thin spans; benchmark actual total cost.

## Research and experiment sequence

- **FAST-001-01** [ ] — Inventory current geometry/commands/drawing/presentation costs and reusable instrumentation. Reuse RALLY-25 headroom/phase work rather than create a conflicting measurement project. Separate eZ80 CPU/submission/reply waits from VDP physics, geometry, dispatch, rasterization and swap/completion. Identify which intervals remain unavailable and request specific peer-owned hooks through agent mail.
- **FAST-001-02** [ ] — Read supplied POLE26.S, AtariAge discussion and Lou Gorenfeld article; extract concrete algorithms and their assumptions. Distinguish actual2600 source, an author's demonstration and conjecture about arcade hardware. Map each idea to our existing lookup/band/helper design; report what we already do and genuinely new alternatives.
- **FAST-001-03** [ ] — Design a geometry-only candidate preserving the existing camera/track/game semantics. Consider fixed-point vertices, shared-edge reuse, finite differences, cached lookup endpoints and bounded approximations. Record operation counts, table/private memory and overflow/rounding risks; do not silently change steering perspective or collision coordinates.
- **FAST-001-04** [ ] — Classify drawing/dispatch candidates by platform: stock-compatible command/primitive/overdraw improvements versus custom native spans/row access. Document interface, format, synchronization and completion requirements; the standard/custom application sections below own subsequent implementation. Treat unavailable capabilities as requests, not implemented APIs.
- **FAST-001-05** [ ] — Propose the smallest informative A/B tranche from measured costs. Freeze deterministic poses/state, scene coverage, timer boundaries, count/completion checks, exact candidate/firmware hashes and required visual review. Record both isolated-stage and full-scene totals and enough memory/quality evidence to assess a tradeoff.
- **FAST-001-06** [x] — Disposed by internal work-area split, not executed: implementation/benchmark responsibility moves to STD-001-03–06 and NATIVE-001-03–06 below, all under RALLY-28. Shared methodology remains here; no candidate build/run is claimed.
- **FAST-001-07** [ ] — Present shared research and prioritized experiment recommendations for Author review, feeding the standard area first. Actual measured acceptance/integration records belong to each version's area. Preserve current rendering as control/rollback. Existing approximately99% visual agreement is sufficient to advance to human review; no exhaustive pixel pursuit or new blanket tolerance is implied.

## Reading notes — Lou Gorenfeld,2026-10-14

The following summarizes the author's techniques, not an independent verification of every historical hardware claim. [Source: Lou's Pseudo3D Page](https://www.extentofthejam.com/pseudo/).

- Precompute screen-row depth, width and scale for a flat road.
- Curvature can use a slope accumulator followed by a centre-position accumulator; segment boundaries change the slope increment.
- Stripe phase can use fixed-point bits; sorted sprites can share the road's depth/scale lookup.
- Projected segments need a starting-slope correction as the camera crosses a boundary, avoiding discontinuities.
- Road shape can be drawn using spans or selected bitmap rows; polygon geometry does not require a general polygon drawing API.
- Hardware-specific row scrolling, sprite scaling and fast fills explain why the same mathematics has different costs on different machines.

## Custom-version implications — analysis, not measured gains

The simple three-accumulator perspective approximation is not the first experiment I would choose: our existing depth/stripe tables already avoid reconstructing that perspective every frame, and changing to approximate depth can change the apparent spacing of markings. Existing sprite placement already exploits inverse depth. The primary question is what expensive work remains after these lookups.

**First geometry candidate: specialize the existing section builder.** In `render_core.inc::section`, four corners are generated by a general bilinear expression with loop coordinates restricted to0or1. Algebraically the top corners are the top centre plus row width times the material boundary; the bottom corners are the bottom centre plus their row width times that boundary. Explicit corner generation may eliminate generic transforms, repeated conversions and computations of terms that become zero. Inspect actual generated Xtensa code first: the compiler may already remove some operations. Test shared-edge behavior and the effects of changing floating-point evaluation order; exact and approximate/fixed-point alternatives should have distinct evidence and visible artifacts disclosed. This is a local, reviewable change without adopting a new track model.

**First drawing candidate: keep the same geometry, change how it is filled.** Compare native clipped material spans or specialized trapezoid filling against the current layered polygons. Count covered pixels, redundant coverage, material changes, command bytes and dispatches. Cache/precompute row widths/material boundaries only if it saves more than memory reads/copies cost. The current helper generates ordinary VDU command buffers; it does not yet provide direct mode136 span drawing. SDK framebuffer capability presence alone does not prove compatible mode/format/double-buffer access. Establish that interface separately with its owner.

**Keep geometry and filling as separate experiment axes.** Exact geometry with a different filler reveals drawing/dispatch savings. Alternative geometry with the existing filler reveals preparation savings. Only combine winning changes afterward, so the evidence identifies the cause. A table-driven, stylistically different road can remain a later labelled candidate if local optimizations are insufficient; it must not silently redefine Fuji, sprite alignment, scenery heading or collision space.

**Review cases:** include beginning/end of curves, opposing turns, track-wrap and table-bin seams, stripe transitions, nearest/farthest bands, negative/off-screen edges, signs/traffic/player overlap and both retained pages. Keep our accepted centreline camera and player-lateral behavior; the tutorial's perspective steering is a different design. Hills, branching roads and a new road texture system are deferred unless needed to evaluate an explicitly selected candidate.

Within the custom task, proposed ordering remains phase measurements, specialized existing geometry, then a drawing/dispatch A/B selected by those measurements. Standard-version arithmetic/projection review is now the first application priority. Direct spans are a credible option, not yet a demonstrated speedup. Fixing the current startup/visual-review defect is separate from these rendering experiments.

## Application A — standard VDP/eZ80, first priority

Apply the shared findings to the maintained standard-VDP game. All pseudo3D computation remains on eZ80 and the resulting product must work with standard firmware without Golem/VDPlets or a custom renderer service. Implementation code/evidence lives under `RALLY-28/standard-vdp/`.

### Standard-version control and boundaries

Use `rally-game/` and its maintained direct-eZ80 roadway implementation as the application authority; preserve the accepted R27 product and existing R27-05 full-scene fixture unchanged as controls. Historical R16/R18/R20/R22 results inform research but do not replace current-game qualification or resume paused RALLY-20. No custom-native timing result qualifies this version.

Optimize actual eZ80 work, including geometry, car/sign placement, track/scenery sampling, loop/controller work and command generation where measurements justify it. Retain traffic, scrolling panorama, HUD/title, sound and normal game behavior. Rendering accuracy may be traded for speed in disclosed experimental candidates; authoritative physics/contact/rule changes require their own decision and checks.

### Standard-version subtasks

- **STD-001-01** [ ] — Freeze source/build/stock-firmware identities and the complete deterministic workload. Map existing R27-05 instrumentation and measurements, recording its simplified centerline player versus normal gameplay. Define comparable unpaced CPU/geometry/submission/wait and frame/completion boundaries. A diagnostic custom-firmware measurement aid, if separately selected, must be labelled and cannot replace stock-firmware compatibility/performance qualification.
- **STD-001-02** [ ] — Apply RALLY-28 MATH-001 findings to the current eZ80 hot loop first. Inspect generated code, library helpers, promotions/constants and operation frequency; nominate16/24-bit integer/fixed-point substitutions with intermediate bounds. Identify expensive calculations avoided entirely by tables/reuse and whether algebraic simplification beats changing representation. Record expected fidelity changes explicitly.
- **STD-001-03** [ ] — After the selected tranche is released, implement one bounded integer/fixed-point or geometry/command improvement in an isolated derivative. Preserve the exact control and original fixture; do not mix unrelated changes or reintroduce old renderer experiments. Record source/binary identities and intended/error-tolerant numerical behavior.
- **STD-001-04** [ ] — If integer methods are unsuitable or uncompetitive, separately prototype the needed `agon-maths` binary16 routines with AgonDev-compatible assembly/C/C++ wrappers. Reuse RALLY-28 library/ABI findings, account for conversions/call overhead and verify actually emitted arithmetic. Keep the standard VDP product independent of custom firmware and unsupported compiler half-type assumptions.
- **STD-001-05** [ ] — Validate each candidate against independent game/numerical references and full-scene deterministic coverage, then measure isolated costs and whole-frame throughput/memory. Include curves/seams/negative coordinates/overlap and normal player/control cases beyond the simplified fixture. Preserve per-run self-created data. Distinguish CPU headroom from transport/VBlank waits and approximation quality from gameplay equivalence.
- **STD-001-06** [ ] — Compare emulator and hardware using byte-identical candidate application/assets and matching standard firmware. Automated runs force BOTH SDL video/audio dummy; Author launches any visible/audible review or manual hardware test. Retain exact control/candidate/environment identities. Do not infer hardware performance from Flexe or compare different workloads as the same benchmark.
- **STD-001-07** [ ] — Present measured speed/quality/memory options for Author visual selection and explicit integration/publication direction. Feed reusable algorithm, range/ABI and measurement findings back to shared research and the custom-version area; native adoption is independently qualified, never implied by a standard-version win.

### Standard-version deliverable

A reviewable standard-VDP candidate with honest stage/full-scene measurements, numerical/visual tradeoffs and stock compatibility evidence. Shared library work remains owner-coordinated. No existing product, old fixture or published evidence is overwritten, and no commit/push is authorized by the planning split.

## Application B — custom VDP/Golem/VDPlets, second priority

Apply relevant shared/standard findings to the custom version. Independently distinguish eZ80 foreground costs from Xtensa simulation/rendering and graphics processing; a standard-version speedup is not native evidence. Implementation code/evidence lives under `RALLY-28/custom-vdp/`. No new compiler/SDK/runtime work is released by this structure.

### Custom-version control and boundaries

Use RALLY-25's actual native helper/composed source and full-scene fixture as the relevant integration line. Preserve the accepted flat fixture, matched Console8/Flexe evidence and full-scene results unchanged. FS-001-07's failed human graphical startup remains a defect to resolve before normal native visual acceptance; headless success is not human acceptance. Standard-version research can proceed without waiting for this custom defect.

The eZ80 and Xtensa have different arithmetic costs and responsibilities. Reuse an algorithm or proof where valid, but do not automatically transplant16/24-bit eZ80 types, assembly or software-half operations into a32-bit Xtensa/Golem path. Existing generated numeric/lifetime contracts remain controls until a separately agreed change.

### Custom-version subtasks

- **NATIVE-001-01** [ ] — Pin the actual custom source/module/helper/firmware/runtime and matching full-scene workload. Resolve or explicitly account for startup/visual-review reliability separately from measured hot-loop costs. Coordinate with RALLY-25 TRF-001-55/56 to split residual eZ80 CPU, transport/waits, native physics/contact, geometry, command dispatch/rasterization and completion.
- **NATIVE-001-02** [ ] — Select relevant shared/standard-version findings using native measurements: specialize generic section-corner calculations, cache endpoints/scale/material state, reduce primitives or redundant fills, and investigate alternative raster paths. Determine what the compiler already optimizes. Keep geometry changes and filling changes as separate experiment axes.
- **NATIVE-001-03** [ ] — After a bounded tranche release, implement an isolated helper/source geometry candidate against the preserved control. Preserve or disclose changes to shared edges, rounding, stripe/curve shape and visual alignment; retain physics/contact/rule behavior unless separately changed. Golem owns compiler/generated bindings/SDK; Rally owns application/helper logic.
- **NATIVE-001-04** [ ] — Investigate/prototype a separately released drawing/dispatch candidate only if measurements justify it: reduced command layers, specialized trapezoids, native clipped spans or cached row copies. Establish actual mode136 format, graphics access, buffering, synchronization and completed-frame contract with the runtime owner before relying on a service. No assumed existing framebuffer API compatibility.
- **NATIVE-001-05** [ ] — Qualify independent world/geometry/output state, finite-call/lifecycle/generation checks, full-scene order, resource/stack costs and visual tradeoffs. Measure pure stage and whole-frame gains separately; record diagnostic overhead and unpaced versus real-time scheduler behavior. Do not transfer a measured standard-version speedup as native evidence.
- **NATIVE-001-06** [ ] — Run released emulator/hardware comparisons using exact same native candidate application/module/assets/firmware bytes. Automated sessions are strictly windowless and silent. Preserve self-created outputs and identities; Author launches visible/audible reviews and physical runs. Existing hardware23.45FPS applies to the older flat workload, not automatically to a fuller optimized game.
- **NATIVE-001-07** [ ] — Present independent native speed/quality/memory and human review evidence for Author integration/publication decisions. Update shared findings with results, preserve rollback controls and state any remaining compiler/runtime work or cadence limits.

### Custom-version deliverable

A separately accepted custom-version candidate and evidence demonstrating where its improvement comes from. Reduced rendering precision is an allowed exploration direction; normal gameplay/camera/physics changes and autonomous scheduling remain separately identified. Existing Golem packages/contracts and the paused RALLY-20 effort are not silently rewritten or resumed.

## References and constraints

- [AtariAge road-algorithm discussion](https://forums.atariage.com/topic/148179-pole-position-like-road-algorithmes/), especially Kurt Woloch's lookup/accumulation experiment and discussion of road graphics tables.
- [Lou's Pseudo3D Page](https://www.extentofthejam.com/pseudo/) — read2026-10-14; summary and engine-specific interpretation above.
- Supplied `POLE26.S`: `/Agon/mystuff/agent-state/codex/attachments/2a66caec-bc28-4036-8d7a-252a126ab63d/POLE26.S`;6502/TIA/RIOT source for the2600 version, provenance unverified.
- Current `RALLY-25/renderer-helper/render_core.inc`, [full-scene native results](RALLY-25/full-scene/README.md), [matched platform comparison](RALLY-25/native-demo/IDENTICAL-COMPARISON.md), and historical R16/R18 lookup experiments (references only).

Root TODO.md is the authoritative register. This exploration does not claim a fix for FS-001-07, qualify120Hz physics/30Hz rendering or authorize a new scheduler. The custom defect does not become a dependency of standard-version optimization. Preserve player/opponent/game rules and accepted camera behavior while testing rendering. Reduced rendering precision and stylistic/geometric alternatives are explicitly welcomed for exploration; label them and obtain Author visual/implementation decisions before adoption. Authoritative game rules and collision semantics remain separate.
