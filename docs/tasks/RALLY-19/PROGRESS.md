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
