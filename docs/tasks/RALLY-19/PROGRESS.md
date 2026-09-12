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
