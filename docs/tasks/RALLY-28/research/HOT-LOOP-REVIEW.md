# RALLY-28 — current hot-loop review

The standard game's road preparation contains substantial software 32-bit arithmetic, including work whose results are discarded. The best first experiment is to remove unused track interpolation and repeated endpoint/edge calculations while preserving the picture. Wider range proofs and approximate rendering can follow. This review identifies executable code and operation frequencies; it does **not** measure CPU cycles, establish a speedup or qualify the 120 Hz physics budget.

Author released this first research item with “go” on 2026-10-14. MATH-001-01 is complete. No game implementation, emulator session, firmware change, deployment, commit or push occurred. The standard version remains first; the native version's failed human startup review remains separate.

## Evidence and reproduction

[AUDIT.json](AUDIT.json) records source/build/toolchain hashes, commands, per-function assembly transfer sites, optimized LLVM integer operations, ABI probes and preservation checks. [audit_hot_loop.py](audit_hot_loop.py) compiles unchanged source to this directory's ignored `.work/`; it neither links nor launches a program. Run from the repository root:

```bash
.venv/bin/python docs/tasks/RALLY-28/research/audit_hot_loop.py
```

The native inspection additionally requires the preserved full-scene `.work/build` source, bindings and object. It deliberately does not regenerate that fixture. The script fails if the standard manifest no longer matches, an inspection object's text differs, or a protected input changes. The receipt captures the present dirty checkout rather than pretending Git HEAD alone identifies it.

| Control | Verified identity/result |
| --- | --- |
| Ordinary standard product | `rally-game/bin/rally.bin`, 164,315 bytes |
| Standard binary SHA256 | `7f1620ed8139ee779e7d50e333ef572aeaf612a154e41ec574e63a57da760293` |
| Standard compilation | Manifest flags empty; all recorded input hashes verified; isolated `main.o` byte-identical to preserved ordinary object |
| Native eZ80 compilation | Existing full-scene generated `src/main.cpp`, existing bindings; isolated `main.o` byte-identical to preserved fixture object |
| Compiler | AgonDev Clang 15.0.7, Agon LLVM `c76386c0083e6a6236ff774275227e2389f85538`, `-Oz`, ADL eZ80 target, C++17; exact commands/hashes in receipt |
| Preservation | 226 existing standard/native source, artifact and evidence files hash-identical before/after inspection |

Static helper-site counts describe the emitted functions, including conditional and initialization paths. They are **not** executed-call counts. Per-frame counts below are separate deductions from the actual source loops and their emitted code. Branch-dependent costs, UART waits and elapsed cycle counts remain unknown.

Primary standard source: [frame/input/tick/presentation](../../../../rally-game/src/main.cpp), [direct-road integration](../../../../rally-game/include/direct_road.hpp), [track sampling/player/road geometry](../../../../rally-production/include/road.hpp), [scene placement](../../../../rally-game/include/game_scene.hpp), [signs](../../../../rally-game/include/signs.hpp), [traffic/routes](../../../../rally-game/include/race_traffic.hpp), [attract controller](../../../../rally-production/include/demo.hpp) and [rules](../../../../rally-game/include/rules.hpp).

## Language and arithmetic widths

The standard application is C++, primarily one translation unit plus header implementations. Its ordinary link uses `main.o`; the application gateway, callback and PRT assembly objects are excluded by the empty feature flags even though old objects remain on disk. AgonDev/MOS/runtime routines beneath the application include assembly. The existing native fixture adds callback/PRT assembly and uses Golem-generated C plus the C renderer helper on the VDP.

| Type or expression | Actual eZ80 compilation |
| --- | --- |
| `short`, `int16_t` | 16 bits |
| `int`, `unsigned`, `int24_t`, pointers, `size_t` | 24 bits |
| `long`, `int32_t`, `uint32_t` | 32 bits |
| `float`, `double` | 32 bits of storage each |
| Probe returning `a*b` from two `uint16_t` parameters | Operands promoted to `int`; LLVM `mul i24`, assembly `__imulu` |
| Probe multiplying two `int32_t` parameters | LLVM `mul i32`, assembly `__lmulu` |

The probe demonstrates promotion, not safe multiplication over the full unsigned-16 domain: some products exceed signed 24-bit range. Smaller storage alone does not guarantee 16-bit arithmetic. Explicit `int32_t` operands/casts and `L` constants keep many game expressions at 32 bits; changing only a destination type is insufficient.

Both inspected eZ80 translation units contain zero LLVM floating arithmetic/conversion operations. Projection is already integer/fixed-point. Binary16 is therefore an alternative algorithm/library experiment, not a simple replacement for an existing eZ80 float hot loop. The native C section builder does use binary32, on Xtensa; its cost must be assessed independently.

The linked 24-bit multiply routine uses six `MLT` instructions; the 32-bit multiply uses ten and more register/stack handling. General unsigned division cores iterate 24 and 32 times respectively, with signed wrappers. These are structural reasons to reduce work/width, not calibrated cycle costs. The audit assembles the installed helper sources and checks their text against `libagon.a`; multiply/division cores also match the bytes in the preserved standard binary. It does not assume the separately named `_fast` routines are the ones linked.

## Actual standard frame path

`rally-game/src/main.cpp:548` reads the MOS clock until the frame deadline, then reads keys, handles input, runs the attract controller if active and processes **elapsed MOS ticks**. It does not always execute four physics ticks per frame. It updates the engine, prepares the scene/signs, draws scenery/road/finish/traffic/player, updates panel/HUD/footer and submits swap.

The standard pacer sets the next deadline to `now+4` (nominal 30 submissions/s at 120 MOS units/s); frames can take longer. Steering/grip input remains per rendered frame under the existing contract. Physics runs once per elapsed raw MOS tick, with different attract, manual-driving, recovery and inactive-phase paths. A faster renderer must not silently change these control semantics.

Startup depth-table divisions, asset uploads, track initialization and result-screen score-file I/O are separate from recurring racing work. `Road::fixedBands` remains false in the maintained game. Its compiled table branch and the historical lookup/section renderers are not the active standard road path. `Traffic::tick` is also historical here: maintained opponents use `RaceTraffic`.

## Operation and frequency inventory

All entries in this table run on eZ80 in the standard game. `B` is the actual number of road bands; `V` is visible traffic, at most six. Costs shown are emitted helper evidence, not milliseconds.

| Work / source | Frequency in current standard game | Width and emitted-cost evidence |
| --- | --- | --- |
| `DirectRoad::project` wrapper (`direct_road.hpp:11`) | Once/frame | Full-fraction position conversion and camera sample repeated by base projection; wrapper has two signed-wide divide sites and one wide multiply site |
| `trackSample` (`road.hpp:30`) | 121 ahead samples inside road projection, plus its camera; additional scene/physics/attract calls below | Out-of-line function always computes **x,y,tx,ty**: four `__lmulu`, five `__lshrs`, two `__lshl`, four `__ladd` sites; 24-bit index remainder only when wrapping |
| `Road::project` row work (`road.hpp:142`) | Exactly 121 rows, 104 through 224 inclusive, every frame | Each row has four sampler wide multiplies plus three direct wide multiplies, two direct `__ldivs`; stripe `__lrems` executes on 109 rows, 116 through 224 |
| Dense road-row total | Every frame, excluding setup, bands, cars and physics | **847 software 32-bit multiplies, 242 signed 32-bit divides, 109 signed 32-bit remainders**; additionally shifts, loads, additions and function overhead |
| `Road::bandEnd` (`road.hpp:152`) | Once/band; nested row rescans depend on curvature/material | Two `__lmulu` per tested intermediate row, wide subtraction/addition/comparison. Growing a successful same-material band of `L` rows tests `L*(L-1)/2` rows, plus any failed extension. Actual frame count/cycles not collected |
| `Road::strip` / stream (`road.hpp:182`, `direct_road.hpp:28`) | Four or five strips/band | Per strip: two signed-wide centre divisions by 256; four 24-bit multiplies and four signed-24 divides for edges. Thus 8–10 wide divides and 16–20 native-width multiply/divide pairs per band |
| Road command construction/submission | Four/five 27-byte quads/band plus two 15-byte background/bottom rectangles | `108B` to `135B` bytes plus 30, for `fillSky=false`. Stream byte/word/index work is mostly 24/16/8-bit; `mos_puts` may wait for CTS. VDP owns rasterization |
| Scene camera/scenery (`game_scene.hpp:14`) | Full-fraction sample + scenery heading once/frame; separate integer-world camera sample once/frame | The full-fraction sample duplicates wrapper/base samples. `sceneryHeading` selects one wide ratio/divide; both branch sites exist. The integer-world camera deliberately rounds differently |
| Traffic placement (`game_scene.hpp:21`) | Six distance calculations, 15 sort comparisons/frame; sampling/transforms for `V` cars | Wide station remainders, division by 100, inverse-depth calculation, tangent sample/cross and yaw lookup; row 103 can invoke fallback full projection in `centerAt`. Some visible-range arithmetic is compiler-narrowed to 16 bits |
| Signs (`signs.hpp:8`) | One nearest-index calculation + four candidate stations/frame; at most two drawn | Three wide-multiply and three signed-wide-divide static sites, two wide-remainder sites (looped); compiler already narrows visible sign depth/scale math to 16 bits. Static track layout is recalculated every frame |
| Finish line (`main.cpp:424`) | Distance check/frame; up to 24 rectangles near finish | Wide ahead remainder/depth conversion, then mainly 24-bit row/edge arithmetic and command bytes; not 24 rectangles on every frame |
| Actual player `Motion::tick` (`road.hpp:100`) | Once/elapsed tick in normal attract or non-recovering driving; aim is 120/s | Two full track samples plus cross/centripetal/integration. Own function has six wide-multiply, five signed-wide-divide and two signed-wide-remainder sites, in addition to sampler/lateralStep calls |
| `Motion::lateralStep` (`road.hpp:74`) | Once/actual Motion tick | Steering/speed/grip/acceleration Q8 expressions; four wide-multiply/five signed-wide-divide static sites. Branches select surface limits; not all sites execute each tick |
| `DemoDriver::frame` (`demo.hpp:6`) | Once/render in ordinary attract; absent from R27 timing fixture | 20 full samples (two initial + nine look-ahead pairs), ten curvature crosses, variable speed search. Eleven wide-multiply/nine wide-divide static sites include loops; they are not the dynamic totals |
| `RaceTraffic` / `RouteCursor` (`race_traffic.hpp`) | One shared pace update/tick in attract/race, up to six slot updates | Shared sine interpolation already avoids six separate sine evaluations. Route motion uses wide multiply/divide and bounded 16-bit heading/countdown; slot station advance already uses conditional wrap. Contact/rank/pass checks are phase-dependent |
| Rules/contact/recovery (`rules.hpp`, `main.cpp:329`) | Rules once/elapsed tick; contact/pass/rank primarily racing | 32-bit clocks/progress/score and comparisons; active driving distance score includes one unsigned-wide division, with remainder reconstructed from that quotient. Finish/grid operations are conditional events |
| HUD/panel (`main.cpp:233`) | HUD/frame; panel signature/frame while visible | `clockText`: one wide multiply, three unsigned-wide divides and two unsigned-wide remainders before `snprintf`. HUD text-output cache does not avoid formatting; panel constructs a formatted signature before comparing it |
| Engine and input (`engine.hpp`, `controls.hpp`) | Input/frame, engine update/frame | Frequency computation becomes small integer work and unchanged frequency suppresses output. No eZ80 floating audio synthesis. Keymap polling/packet service is separate from physics arithmetic |
| Clock, deadline, send, swap | Clock repeatedly; sends variable; swap/frame | 32-bit wrap-aware clock arithmetic is intentional. Deadline polling is pacing wait; sender blocking is transport wait. Neither is useful arithmetic headroom |

The two divisions in a full-fraction position conversion are quotient `/100` and scaled remainder `/100`; the compiler shares the original quotient and reconstructs `%100` rather than issuing another standalone remainder helper. Similarly, rules `/1600` and `%1600` share their quotient. Count what was emitted rather than counting operators in source.

## Prioritized findings

| Finding | First candidate and reason | Exactness / next evidence |
| --- | --- | --- |
| **AUD-01 — unused/repeated sampling** | Separate position-only and tangent-only sampling. Ahead road rows use x/y yet compute both tangents. Removing those two interpolations would eliminate **242 wide multiplies/frame** plus associated shifts/additions/stores. Reuse the three identical full-fraction camera samples/conversions | Can preserve integer results exactly. Retain the separately rounded traffic-yaw camera. Check actual compiler output after a separately released isolated change |
| **AUD-02 — repeated strip arithmetic** | Convert selected band endpoints to pixel centres once and reuse the previous endpoint; table/reuse the five edge magnitudes 106,90,86,84,2 by screen row | Can preserve current signed truncation and picture. Current layers repeat centre divisions 8–10 times/band. Five signed-16 edge tables for rows104–224 would occupy 1,210 bytes; memory/loads versus arithmetic must be measured |
| **AUD-03 — band search work** | Count actual greedy row tests/bands, then compare incremental/cheaper validation or separately generated conservative band endpoints | Potentially larger saving than changing types, but dynamic cost is unknown. A new approximation/table must disclose changes to one-pixel fit/material boundaries; old table branch is a reference, not a qualified replacement |
| **AUD-04 — bounded wrap and static scenery** | Replace proven normalized-station modulo with conditional wrap; precompute sign stations. `Traffic::ahead` alone repeats runtime wide modulo for six traffic distances, four sign distances and one finish check/frame | Exact only under stated bounds. Motion's normalized station/phase advance also looks amenable to one conditional subtraction. Do not generalize this to signed unwrapped progress, recovery or lifetime counters |
| **AUD-05 — controller/player work** | Reuse adjacent look-ahead samples in ordinary attract and use tangent-only samples for bend/physics. Derive player intermediate bounds before choosing 24-bit/local Q formats | 20 attract sample calls cover only ten distinct stations. Normal attract/controller work is missing from the simplified timing fixture. Keep physics/rules semantics separate from allowed rendering approximation |
| **AUD-06 — formatting and shared caches** | Cache field values before HUD formatting; replace panel string signature with directly comparable state if measurements justify it | Pixel emission is already cached per retained page. Formatting is not. Preserve both pages' redraw behavior; formatting speed is unmeasured |

I would start a bounded implementation with AUD-01, then AUD-02. This isolates readily removable work without first redesigning track geometry, changing physics or introducing a half-float library. AUD-03 needs actual test-count evidence to decide its place relative to the exact candidates. Lower-precision projection/curvature remains an explicitly welcome later experiment if these savings are insufficient.

## Initial range cautions for the next research item

These observations guide MATH-001-02; they are not a completed overflow proof or permission to narrow all fields.

- **RANGE-01 — storage versus products:** Fuji station 0..3,276,799 fits unsigned/signed 24-bit; phase0..7999 and speed0..300 fit16. Player lateral reaches±38,400, exceeding signed16. Score up to9,999,999 fits unsigned24 but exceeds signed24. Clock/cumulative/world/generation semantics require separate lifetime analysis.
- **RANGE-02 — interpolation:** Across the actual Fuji/oval tables, adjacent x/y differences have magnitude at most64. Multiplication by a Q14 fraction up to16,383 gives at most1,048,512, fitting signed24. Tangent differences reach1,215 in Fuji: that same product can reach19,905,345, exceeding signed24. Coordinate and tangent interpolation cannot be narrowed under the same argument.
- **RANGE-03 — cross products:** Tangents reach±4096. Even one product4096*4096 is16,777,216, beyond signed24. A small final bend/yaw value does not make its preceding products safe. Candidate approaches include local/scaled coordinates, split products or disclosed lower precision; retaining wide intermediates is also valid.
- **RANGE-04 — signs:** Fuji has68 signs and oval12. `position*total` or `index*lap` can be hundreds of millions even though the final station fits24. Precomputation removes the arithmetic rather than truncating these products.
- **RANGE-05 — rounding:** Signed C division truncates toward zero; emitted arithmetic shifts of negative interpolants round differently. Replacing `/256` or `/4096` with a shift needs an exact bias/sign formulation or a disclosed rendering change. The current native helper also uses different endpoint rounding from this standard renderer; it is not an exact replacement by name alone.

## Custom full-scene responsibility map

The actual existing eZ80 native fixture was inspected separately, using its own preserved object and generated source. Its loop executes exactly four fixture ticks per frame and is unpaced. This is a workload schedule, not an autonomous 120 Hz physics/30 Hz rendering scheduler.

| Processor / work | Actual frequency and evidence |
| --- | --- |
| eZ80 `full_scene::Player::tick` | Four/frame; a simple route-speed/centerline advance and `rules.tick(0)`, not manual `Motion::tick` physics. Emitted player function has two signed-wide remainders and one wide multiply site. Do not call its existing PRT result interactive player headroom |
| eZ80 snapshot/transport | Four snapshots and buffered tick commands/frame. Snapshot sends two 32-bit fields plus paired phase/steering; RUN/reply/completion checks are protocol work. Timer accumulation and clocks retain wide arithmetic |
| eZ80 scenery | One `trackSample`/heading/history preparation/frame; still computes unneeded x/y for background heading. This is a valid shared sampling candidate |
| eZ80 HUD/panel/audio | Reused standard functions once/frame; shared formatting/cache findings apply. Native frame also issues three output-buffer calls and swap |
| Xtensa `Tick120` | Four/frame; shared route/sine update, six active-slot station/lateral/contact updates. Golem's 32-bit checked arithmetic is on a32-bit processor, not eZ80 software-long arithmetic |
| Xtensa renderer helper | One render/frame; road centres/bands use coefficient/stripe/band tables, unlike current dense standard projection. `section` uses binary32 corner expressions; traffic/sign/player/finish commands are generated here |
| VDP command/raster/swap service | Processes helper output and eZ80 presentation commands; costs/completed-display boundary require separate native instrumentation |

Source authorities: [native driver](../../RALLY-25/full-scene/main_tail.cpp), [fixture player](../../RALLY-25/full-scene/player.hpp), [transport](../../RALLY-25/full-scene/native.hpp), [Golem physics](../../RALLY-25/full-scene/full-scene.golem) and [C renderer core](../../RALLY-25/renderer-helper/render_core.inc). This review does not disassemble or independently qualify a new Xtensa module/compiler. Source-level candidate overlap includes sampling, sign tables, wrap simplification, HUD caching and command reuse. The standard 121-row sampler and greedy scan costs do **not** transfer to native table geometry. Binary16/16-bit storage changes do not automatically help Xtensa.

## Timing interpretation and next scope

The ordinary AgonDev `vdp_swap()` implementation sends the three-byte swap command through `mos_puts`; it is not an explicit CPU-side “wait for VBlank” call or a completed-frame acknowledgement. Standard deadline polling supplies an application pacing wait. Receiver-side swap timing and backpressure can also affect wall time. Separate computation, UART/CTS blocking, VDP processing and completion before claiming CPU headroom.

R27-05 provides reusable PRT stages and diagnostic VDP markers/completed counts. Its “Geometry” stage covers scene/sign preparation, **but band search, strip vertices and road command construction occur later in “Submission”**. Its full hot-loop total also includes transport waits. The fixture replaces normal attract/player handling with centerline pace advancement, so it cannot quantify the actual player physics reviewed here. Existing12.19–12.40FPS diagnostic interpreter results are not a stock-hardware CPU profile.

The existing native fixture has separate player/scenery/HUD estimates and send/reply intervals, but those are nominal emulator timer intervals and include its diagnostic controls. They do not qualify physical CPU headroom or isolate native draw/completion. No new timing run was performed for this review.

Next shared research item is **MATH-001-02**: prove relevant intermediate ranges and rounding, and describe the smallest standard-version experiment from AUD-01/AUD-02. The binary16 library audit remains MATH-001-04; no missing library location blocks these integer candidates. Implementation and comparable timing/Author visual review remain the STD application tasks. All emulator authority remains strictly windowless **and silent**; the Author launches visible/audible review.
