# G057-RLY-INV-001 [x] — Existing gates inventory,2026-11-02

Golem283 requests existing-evidence status only. No new implementation, test,
review prompt, emulator, Oryx contact, reservation or publication is selected.
This inventory does not revise any frozen report, fixture or acceptance receipt.

## Human moving review

1. **Earlier visual acceptance exists.** HZ60-001's Native renderer received
   the Author's “visual correctness passes” statement, recorded in
   `custom-vdp/throughput/RESULTS.md`, final Author review update. The corrected
   complete-race comparison also has explicit **RACE-001-07 visual acceptance**:
   `custom-vdp/full-race/HUMAN-ACCEPTANCE.json` records “it looks good.” for
   `rally28-hz60-racereview01-static`. The corresponding dated log is
   `docs/2026-10-29-rally-full-race.md`; committed receipt/evidence are in
   `059f1f7c18684f961ecfdf71c62eaefbb0f0ef4c`. That receipt contains no retrieved
   human timing and does not itself grant commit/push permission.
2. **GOLEM057's later compact review is still open.** The specific original
   selected synchronization change is INC-001-05/G057-RLY-001. Its exact
   `incremental/round-trips/RETURN.md`, `HUMAN-REVIEW.md`, dated
   `docs/2026-10-30-rally-round-trips.md` and root TODO retain the moving review
   gate for `rally28-hz60-rlyrtreview01-compact`. No later existing acceptance
   disposition found closes that review. Earlier RACE/HZ60 acceptance is not
   silently transferred to the compact module/transport policy.
3. **HUD/current maintained cohort has no moving acceptance.** HUD-001-04
   remains open. Historical `incremental/hud-format/HUMAN-REVIEW.md` describes
   a stopped review profile and explicitly withholds launch clearance; its
   first-failure wording is historical, not current live readiness. Golem224's
   `startup-recovery/maintained-runtime/DISPOSITION224.md` accepts exactly one
   silent maintained086 functional900-frame qualification and explicitly
   excludes human/default/publication acceptance. MOS prompt captures and raw
   state/wire parity do not close a moving review. No new review is requested
   or scheduled here. Any eventual review needs a separate fresh stopped
   profile/custodian checkout, with the Author launching it.

## Publication and checkpoint history

4. **Historical checkpoint publication is already complete.** The original
   compact source/module/results/return are committed in
   `78ef50d565e7001dbde21bded80b7597b56fd187` (“Preserve compact Rally transport
   and qualification evidence”). `docs/2026-10-31-rally-phase-cost.md`,
   “Checkpoint completed and pushed,” records the Author-authorized push of
   that commit alongside0e81d9c/3621591/2ac6a32 to origin/main. Therefore the
   original round-trip return's “uncommitted” wording describes its return
   boundary, not the present checkpoint state. The earlier complete-race
   receipt059f1f7 is also an ancestor of the pushed current checkpoint.
5. **HUD source was also explicitly checkpoint-published.**
   `191a1e8d4fe08ceecd58a5b3241f7d781f5b6fd3` contains shared HUD cache code,
   host checks and failed-startup evidence. The subsequent recovery contract
   is `dec22d0794779ebfb1a0f825583c885415b812e9`;39df4bc preserves phase/assembly
   findings. `docs/2026-10-31-rally-startup-recovery.md`, “Checkpoint pushed,”
   records their authorized push. Current local HEAD and local origin/main
   tracking ref both resolve to dec22d0. No fresh remote Git query is made.
6. **Post-checkpoint publication/default approval is not complete.** The
   November1 startup/observer/smoke/partial-ABBA/maintained086 harnesses, receipts
   and accepted results remain working-tree changes/untracked files. Golem224
   explicitly selects no publication/default/hardware action. Neither the
   later SDK publication3ca63f6/clean-token contract b10eedb nor functional
   acceptance grants consumer publication or product adoption. No commit/push
   is performed by this inventory. The actual open gate is disposition of
   this later work and visual/default adoption, not a second publication of
   the already pushed original compact/HUD checkpoint.

## Required generic VDPlet hook

7. **None identified for the accepted existing Rally contract.** Existing
   buffered execution, native error/status/publication checks, state-buffer
   access, leases and final stock swap/checked generation fence support the
   accepted complete fixture, including normal timer/Stop/UNLOAD/MOS cleanup.
   The exact proof is maintained-runtime/RESULTS.md + DISPOSITION224.md:
   all2024 native replies, independent state and strict722201-byte full wire
   stream passed. No unfulfilled generic API extension is required to close
   this bounded functional qualification. Its firmware remains8da2; it is not
   a claim of migration/qualification against the newly published SDK image.

The proposed phase-cost timing work is separate research:
`research/phase-cost/TIMING-CONTRACT.md` explicitly says no new SDK clock/log/
drain service is inherently required; private module markers and existing
stock drain/fences were proposed. It is not a missing accepted hook or a
release to implement it. Backend owning-CTS operands and host-aligned clock
calibration were likewise unselected diagnostic proposals, not generic VDPlet
contract dependencies.

## Limits retained

The latest single maintained086 run records60.00 nominal MOS FPS and36.154742
nominal PRT FPS; neither is calibrated wall/physical FPS. MOS/PRT service and
presentation coalescing remain as recorded in source-followup194. The old200f
startup failure has a real three-sample CTS-false witness but no established
receiver/FIFO/IRQ/PC cause or repair. One later supported-runtime success is
not a cause, a paired HUD gain, autonomous120Hz scheduling, visual acceptance
or physical qualification. The two old ABBA successors remain unrun. No extra
work or root acknowledgment is required by this report.
