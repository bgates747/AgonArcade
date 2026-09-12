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
