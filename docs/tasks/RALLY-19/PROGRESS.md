# RALLY-19 execution evidence

## R19-00 — Contract frozen, 2026-09-12

Read canonical instructions, the delivered Linux handoff and feasibility notes,
Golem handoff/compiler/lifecycle/loop/design references, and inspected both Git
states. Original AgonArcade has only user-supplied untracked handoff.md; original
Golem has untracked deploy.py/deploy.toml. Preserved both. Verified the incremental
Git bundle and imported 949f618 into sibling AgonArcade-rally19 on rally19-golem.
Overlaid only the delivered pending documents into that checkpoint. No gameplay,
compiler, emulator-runtime or asset implementation changed and no tests/builds
were started. Root TODO records the full plan and initial completed freeze.

The Author's latest explicit instruction supplies unattended goal authorization,
headless-only operation and local commit authorization for every completed box.
This supersedes older discussion-only and GUI-validation/alert requirements for
this goal. Performance thresholds in the contract are explicitly chosen execution
criteria; they are not mislabeled as previously measured or Author-supplied facts.

## R19-01 — Foundations reproduced, 2026-09-12

All delivered SHA256SUMS pass. The local foundation.py reconstructs the final
review source from committed task code, checks it against the archived source,
then rebuilds it to the exact accepted 142,960-byte binary hash. Road, pacing,
fixed-band and production 2x manual-handling tests pass under host sanitizers.
Golem foundation commit 3a9920e0fc6aff70c15fddfc617fb76dac0e4186 preserves its
existing semantics with regression checks; hello and loop compile. Both new
worktrees have their own CPython 3.14.6 venvs. Runtime, input/data, compiler and
binary identities are in evidence/foundation.json; build log is adjacent.
A canonical stock profile was prepared at .emulator/foundation; no graphical
launch and no upstream/original-worktree edits. Native visual/runtime oracle
qualification follows in R19-02; compiler arithmetic probes follow in R19-04.

## R19-02 — Oracle frozen and qualified, 2026-09-12

Captured 66 static native cases on the stock Linux runtime at normal CPU speed;
all host/guest scene records match exactly. Preserved the original 48 inputs and
added 18 Fuji bend approaches after discovering the uniform poses missed its
hairpin. Frozen per-material/vehicle support and regional metric before any
candidate renderer. Synthetic tolerances and missing-object/occlusion negatives
pass; every native visible car/marking erasure fails, even with an unchanged
claimed mask. Linux SDL hook smoke and 37 malformed fixture tests pass.

Exact accepted-binary 64-pose warmed baseline batches give 14.9368 ms oval and
14.0051 ms Fuji instruction-based compute-span means; normal-clock submission
batch means are 32.8125–33.0729 ms. Full procedural command accounting is 888.875
bytes/frame oval, 768.563 Fuji including 17 diagnostic HUD bytes; native road
counts corroborate the host accounting. These are initial batch baselines, not
final per-frame distributions or scene-only CPU savings. ORACLE.md explains all
scope, identities, reproduction commands, retained failures and timing/mask
limitations; evidence/visual-freeze.json hashes the frozen metric and masks.
No game/compiler implementation or upstream state changed. All native tests
were headless, with no alert. R19-03 now defines the reusable Golem/scene ABI.

Evidence packaging follow-up: preserve raw MOS CSV CRLF via task-local Git
attributes instead of rewriting hash-identified data. Explicitly include raw
capture/debugger logs otherwise hidden by the repository-wide *.log ignore.

## R19-03 — Hosted compiler and scene ABI designed, 2026-09-12

Golem design commit 696d83084e23e92638129e544b498bdcec819acf specifies an opt-in
typed hosted extension of the existing compiler, finite program/call/repeat
rules, stock lowering, symbolic relocation/ID ownership, numeric guards and
resource/alias budgets. Its intended parser acceptance/rejection corpus is
specified, not yet implemented; ordinary compiler sanitizer regressions pass.

ABI.md and scene_protocol.hpp fix 80 payload bytes / 97 update+call bytes, with
raw world state, independent phase, six unsorted cars, HUD values and sequence.
Existing swap adds three scene bytes; HUD remains separately counted. Host codec
tests pass under ASan/UBSan, including all truncated lengths, invalid fields,
signed boundaries, non-mutating failure and modulo-65535 sequence wrap.
Evidence/abi-design.json records source hashes, command and Golem commit.

Pinned stock source requires same-format command41 conversion, checked positive
bias for negative integer output, and exclusion of conditional-word 0xFFFF's
missing-value sentinel. The design explicitly accounts for these, matrix inverse
caches and finite recovery from incomplete raw commands. Native arithmetic,
admission and performance are still pending; no claim of a running VDP renderer.

## R19-04 — First native arithmetic checkpoint, still unchecked, 2026-09-12

Golem commit e6197940d952989963c096099e9badbe30deaa51 extends its C++ compiler
with typed hosted declarations, real stock arithmetic lowering, finite calls/
repeats and checked signed-store/PLOT. Existing regressions, new byte goldens,
26 negative cases and the frozen hosted design accept/reject corpus pass with
sanitizers. Source formatting and conservative alias/range checks were followed
by reproduction of exactly the same native program bytes, recorded in
evidence/golem-arithmetic/checkpoint.json.

The passing isolated-build headless native run executes five varied input sets:
product, product-plus-input, reciprocal via diagonal affine inversion, division,
screen-Y rotation, signed floors including -32768/32767, and computed PLOT.
Its eight-trip loop wraps 65534 to 6 without corrupting adjacent 12345. Raw
results are copied back through stock GP-token echoes; this is diagnostic byte
readback, not a rendering-completion callback. Captured pixels are exactly the
five expected white points. No eZ80 implementation of the tested arithmetic.

The 1321-byte Golem bootstrap owns 35 IDs and reports 810 resident payload bytes,
excluding matrix metadata and allocator overhead. Kernel timing/peak memory are
not measured yet. Retained first run shows a wrong Cartesian-Y rotation reference;
the correction follows pinned stock source. Retained second attempt shows the
agondev forced-mkdir rebuild failure; per-run build directories avoid it without
upstream edits. Both failures and the passing evidence remain inspectable.

R19-04 remains open for native bad-depth admission, zero/one/120-trip loop cases,
broader index/type/lifetime checks and numerical cost measurements. R19-05 still
owns production state admission, dynamic indexing/assets and full lifecycle.
Neither the complete Golem interface nor the Rally renderer is claimed done.
All emulator work was headless; no alerts, pushes or SD changes.

## R19-04 — Reusable native arithmetic qualified, 2026-09-12

Golem commit 181c906270aa858e2381a4dde68495a50bc98127 completes the arithmetic
milestone. The reusable compiler/native kernels now prove matrix product/add/
subtract/scalar multiply, diagonal affine reciprocal/division, rotation,
nonzero matrix-cell replacement/extraction, signed conversion and computed PLOT.
Five differing inputs include 7*9, 84/7, negative products and signed-word limits.
Zero/negative/oversized denominators are rejected before inversion; valid input
is admitted. Native repeat counts 0/1/8/120 and neighboring-field preservation
pass. Host golden/negative/sanitizer regressions remain passing.

Complete-intrinsics visual and capture-free cost runs both pass. Final readback
remains correct after 40,960 finite calls. The final program is 2461 bootstrap
bytes, 66 IDs and 1477 declared payload bytes, excluding metadata/peak allocator
memory. Full arithmetic takes 30 ticks/4096 calls in both final repeats, about
61.0 us/call including UART submission and the final GP parser echo. Observed
clock granularity is two ticks, so small differences from empty jobs cannot be
used as pure VDP timing. No rendering-completion or ESP32 performance claim.

Evidence/golem-arithmetic/qualification.json maps the milestone requirements to
source identities, raw byte results, pixels, host tests and cost reports. The
runtime guard covers this arithmetic kernel's denominator; full frame-state
admission, dynamic asset/table indexing, metadata/memory balance and reset/reload
are still R19-05/11. All tests were headless; original worktrees and SD untouched.

## R19-05 — Resident lookup/lifecycle checkpoint, still unchecked, 2026-09-12

Golem implementation 8e089e3 and documentation correction
64e354697caf955a853397b745ef8b737b78ab68 add source-relative Asset/Table imports,
exact-size/range/ID validation, guarded resident record selection and explicit
owned cleanup. The existing C++ compiler patches a private copy instruction's
source ID after checking the index; it never executes data assets as commands.
Host ordinary/hosted/import sanitizer and frozen design checks pass.

The headless stock `probe_lookup.py initial` run passes 72 selections, nine
mode-reset/bootstrap reloads and all-256-byte diagnostic readbacks, and three
owned cleanup cycles. Four resident pairs produce 63/80/-24/62 through VDP matrix
arithmetic. Indices 4/65534/65535 leave prior record/product intact and status 0.
All owned buffers become unreadable after cleanup; unrelated canary 55555 survives
reload and cleanup. Native program SHA256
bae8c52ecc9bee1b4a5fbfc32de4d9267e7bdd00793e47a9ec6d8cb1c232c91e:
739 bootstrap bytes, 481 payload bytes, 17 IDs, 102 cleanup bytes.

Two tagged GP nibbles make arbitrary byte readback independent of expected
answers, including 0xFF. This diagnostic still proves parser/buffer progress,
not raster completion. A missing-copy tag is qualified against every tested
owned first byte before clear. Neither those observations nor the static ledger
measure allocator/metadata balance. Complete signed Rally admission, malformed/
incomplete transport, sequence policy and live resource evidence remain open;
R19-05's checkbox is deliberately unchanged. All testing uses normal CPU and
canonical headless wrappers. No original/upstream changes, alerts, pushes or SD.

## R19-05 — Resident admission/lifecycle qualified, 2026-09-12

Golem af8d91ee65416cde80ab8afb28d8adb7f310c007 completes this milestone. The
C++ compiler adds sticky signed/full-width guards and complete typed record copy,
aggregate resource limits and bounded syntax parsing. Both tracks pass 210 native
admission/fault-injection cases. Dynamic record selection crosses an ID-byte carry,
large-asset readback and >64 KiB multiblock bootstrap work, nine reloads/three
owned cleanups preserve foreign resources, and 36,864 additional calls have stable
tracked live allocations. Headless Escape reaches the guest after finite jobs.
Host sanitizer/regression tests pass; final compiler reproduces qualified native
arithmetic, lookup and admission bytes exactly. RESIDENT.md and
`evidence/golem-resident-qualification.json` map every criterion to raw evidence.

The expanded header-cut test retained a real parser diagnostic failure: stock
bufferAdjust can incur successive 200 ms waits, so a 500 ms idle before GP was
insufficient for an incomplete header. Final recovery tests pass with 2000 ms
for header/trigger cuts and 500 ms for payload cuts. No ordinary frame receives
that delay. Initial unused-constant and CRLF-sampler failures remain recorded.

Allocation samples cover stock heap_caps_malloc/actual frees, not hardware RAM
or all host allocations. The large fixture keeps 239 live allocations / 222600
bytes steady over each batch, and 32 / 83832 after every cleanup; the initial
232-byte warmed-container increase is stable. GP remains a parser/echo milestone.
The finite renderer proof doubles admitted position; complete roads/cars and all
frozen full-scene timing/visual/ten-minute criteria remain R19-06 onward. All work
was headless in isolated worktrees; no alerts, upstream edits, pushes or SD changes.

## R19-06 — Real-lookup prerequisites checkpoint, still unchecked, 2026-09-12

Golem 67eac1920e8469ac0b462aa21c62f462e8341498 adds typed second-level element
selection within a resident record buffer, exact bounded byte-offset arithmetic,
unsigned widening and an unbiased unsigned floor conversion. Native testing
passes eight cases crossing a byte-offset carry, preserving data on bad indices,
widening65535 and keeping correct interval floors near6400 and Fuji's last valid
position3276799. Host sanitizer/golden/negative tests pass. Final compiler output
matches the qualified element probe and reproduces the previous arithmetic and
full admission streams exactly. An initial erased-copy-template failure is
retained with the corrected readbacks under evidence/golem-elements.

SECTION.md records the real coefficient layout/bounds, precise integer oracle,
accepted material widths and integration constraints. The next work must select
real interval/lookahead coefficients, derive phase/section boundaries and draw
all section materials. The helper fixture does not satisfy R19-06 and its box
remains unchecked. All emulator tests were headless and normal-clock. No changes
to original worktrees, upstream firmware, SD or remote publication.

## R19-08 — Complete numeric vehicle projection checkpoint, still open

Golem c1bdb577084d498d2714ca4b0ba062a28dfa74ff qualifies checked fixed-type
narrowing and optional shared word-conversion temporaries. Clipping/reciprocal
passes1110 native depth inputs. Isolated versus shared conversions pass330 full
readbacks across signed/unsigned values, nested calls and repeats. Host sanitizer/
golden/negative tests pass, with exact source identities retained in evidence.

The admitted full-road program now computes player and all six opponent distance,
ordering, clipped depth, position, scale, yaw/view and reflection entirely on VDP.
All156 native numeric fixtures pass exact comparison with the accepted reference
(69 oval,87 Fuji). The original80-byte raw state is unchanged. Static tangent
records upload once; no host-projected values enter frames. CARS.md documents
the new generator, storage and284-byte diagnostic format.

The initial player-centre declaration was too broad for its destination and was
corrected to the exact containing sum. The unshared Fuji kernel exceeded the
frozen1024-buffer cap; its failure is preserved. Opt-in sharing brings ownership
to848/867 IDs, payload69140/190294 and bootstrap81338/202758 bytes. No ceiling was
raised. See evidence/golem-vehicle-projection/qualification.json and the clipping/
shared-scratch qualification reports. This is numeric and resource evidence,
not full-scene performance or whole-VDP heap measurement.

R19-08 remains unchecked: typed bitmap drawing, original artwork/liveries and
native per-car images/material/occlusion qualification are next. All emulator
work was headless; no GUI alert, original/upstream edit, push or deployment.

## R19-08 — Complete native vehicle renderer qualified

Golem completion documentation commit c66d0f88490127753519f70ec4d6a66a16b3acfc
(compiler implementation7065d0f) precedes this milestone. CARS.md documents the
resident car renderer, original-art bootstrap, typed affine draws and independent
native image/geometry harness. qualify_vehicles.py passes112 image pairs: all66
frozen poses, four depth/tie cases and42 steering cases. All player/opponent pixels
match exactly across every view/reflection and original livery. Fresh native
oracle foregrounds are checked against the original frozen captures. The156
numeric fixtures,24 primitive bitmap images and full host sanitizer/golden/
negative suite pass too. PNG and packed source data exactly match accepted art.

An initial shoulder comparison failed because the scene CSV was given rounded
centres instead of the expected Q8 centres. A separate VDP trace corrects that
diagnostic with unchanged rendered pixels; failures and exact-image regression
are retained. No metric was relaxed. Final road material agreement is at least
98.095%, original Q8 diagnostics are exact, and each vehicle's exact agreement100%.

The traced admitted renderer owns894/913 IDs, with71722/192876 resident payload
and84564/205984 bootstrap bytes. Raw state/update/call/swap remains100 UART bytes.
These are static payload/protocol ledgers, not full-scene timing or live heap
measurements. Original worktrees remain unchanged, including their pre-existing
untracked handoff/deploy files. No alert, GUI emulator, push or SD deployment.

R19-09 scenery/frontend is next; SCENERY.md records source-based preparation and
the important fractional-tangent/signed-floor pitfall. Performance, long stability,
independent review and final delivery remain R19-10 through R19-12. The overall
goal is still active.

## R19-09 — Signed-floor prerequisite checkpoint, still open

Golem f856fa2d0e0465d0586b16f7086a3377b046772f qualifies MatFloor without
the small-fraction loss of the signed16 bias conversion. All236 native complete
records and the full host boundary/sanitizer/golden/negative suite pass. Native
evidence includes1/16384 fractions, negative subnormals, signed zero, byte carries
and source preservation. No scenery kernel or frontend integration is claimed.

SCENERY.md now records accepted bearing/history/scroll behavior and a second
precision trap: Fuji delta*fraction can reach19902915, outside exact binary32
integers. It proposes an exact quotient/remainder decomposition before floor,
and records conservative major-tangent lower bounds2441/2501. The next work is
to qualify that interpolation and the bounded corrected atan ratio on VDP, then
implement retained-page scenery and the accepted interactive frontend. R19-09
and all subsequent boxes remain unchecked; no GUI, push or deployment.

## R19-09 — Complete scenery and Golem frontend qualified

Golem completion documentation commit cd6d1eda81b077bf358d834e8f5a16fb83413d27
precedes this milestone; compiler implementation remains a997437. Full-scene
scenery/road/car programs and the Golem-default frontend are now integrated.
The host sends80 raw state bytes,11 update bytes and6 call bytes, followed by
the unchanged HUD and one3-byte swap. Bearing, retained-page state, scroll strips,
road coordinates and vehicle projection/order stay on the stock VDP.

`qualify_scenery.py` recomputes186 native image pairs:66 frozen scenes and120
actual two-page history sequences. Every vehicle pixel is exact; background
radius-one agreement is100%; all road regions pass, with shoulder minimum98.095%.
Original scene bridges, geometry, original art, runtime identities and exact
frontend/bootstrap identity are verified. Native history has444 records; the
host history proof covers4,194,304 combinations. No tolerance was relaxed.

`qualify_frontend.py` passes12 both-track native input/exit cases and638 sanitized
host raw-state records. Held steering/grip limits, reversal, throttle, demo
takeover, Escape arming, optional autosteer and the explicit oracle option pass.
Accepted input/physics/HUD source blocks are unchanged. The initial guard mistook
the fixed-bands default for an unsupported option; its rejected source and error
screen remain under golem-frontend. It was corrected without changing120 road rows.

Resource totals are836/853 IDs and78565/199711 resident payload bytes, with
90816/212200 bootstrap bytes. External artwork and cached inverses are excluded
from those static totals. Startup counters cover bootstrap loading only; normal
cleanup evidence is not a live heap/fault-recovery proof. PERFORMANCE.md records
the upcoming measurement separation and a read-only native swap-observer lead.

R19-09 is checked and committed immediately. R19-10 performance, R19-11 long
stability/review and R19-12 delivery remain open. All emulators were headless and
have exited. No GUI alert, push, SD deployment or original/upstream edits occurred.
