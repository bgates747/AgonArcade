# RALLY-28 — Native-owned state implementation and comparison

Author release 2026-11-04: goal task; write the task, commit and push all dirt,
then implement. Silent leased Oryx correctness/preliminary timing is authorized.
Prepare the same complete deterministic fixture for the Author's later Console8
comparison. Do not deploy/flash hardware or launch a GUI/sound session.

## Objective and controls

Replace the generated shared-buffer state/physics access pattern with aligned,
native-owned C structures, exact small tables and ordinary direct function/array
access. Keep useful native pointers through their actual valid lifetimes. Large
external assets remain scoped borrows; no expired pointer is cached. Preserve
the direct-row road geometry/sampler, complete race presentation, deterministic
traffic overrides, physics arithmetic, contact checks, final state, callbacks,
completion/swap fences and clean MOS exit. Async UART and production independent
physics/render scheduling remain later work.

Use ROW-001's exact direct-row module/guest/runtime as the preserved baseline.
First isolate native state behind compatible diagnostic input/export boundaries
so the same guest/wire/state oracle can compare it. Then test a coarse native
four-step call, removing the hot interpreted Tick wrapper. Keep the four logical
steps per rendered frame as a comparison workload; this does not adopt a real-time
cadence. Legacy root/array images are compatibility exports, not the authoritative
live state. Retain a narrowly labeled adapter where the current fixture depends
on it; record every surviving interpreter/storage layer honestly. Native drawing
list/compositor replacement remains NAT-NEXT-03, outside this state tranche.

## Work items

- **NAT-002-01** [ ] — Freeze exact direct-row baseline, source/SDK/compiler/
  firmware/guest/asset inputs and define native structure ownership, input
  overrides, diagnostic serialization and lifecycle/error contracts. Commit/push
  all current research dirt and this task before implementation.
- **NAT-002-02** [ ] — Implement a separate native-owned state core: typed scalar
  fields/opponent records, exact route/sine tables, local computational access,
  no scalar acquire/release in physics. Read external input only at its existing
  boundary; serialize legacy diagnostic state separately. Implement initialization,
  Stop/unload/reload/session checks and explicit error cleanup.
- **NAT-002-03** [ ] — Prepare a separate coarse four-step entry/guest removing
  the hot interpreted Tick CALL while preserving four step semantics, generations,
  requested render result and final swap fence. Keep the same native state core
  in compatible and coarse variants so call consolidation is distinguishable.
- **NAT-002-04** [ ] — Qualify actual modified C against preserved generated C:
  full3600-step/900-frame/two-warm state and command outputs, independent world,
  direct road pixels/both pages/sync, scripted overrides and lifecycle/failure
  cases. Record actual service counts. Build with frozen corrected SDK/policy,
  unchanged size/stack guards and inspect generated code/resources. Use the
  current shared Pi build FIFO for serial builds and bounded ordinary checks.
- **NAT-002-05** [ ] — Freeze fresh silent Oryx profiles and exact wire/reply
  expectations before reservation. Finite first cohort: baseline60/state60/
  coarse60 smokes, then baseline900/state900/coarse900/coarse900/state900/
  baseline900 on success. First unexpected failure stops, no automatic retry.
  Use normal FIFO/idle/checkout/assert, both SDL dummy, original thermal/UART/
  cleanup/boost-restoration guards. A repair needs a new explicit receipt and
  finite cohort, preserving the failed evidence; no guard relaxation.
- **NAT-002-06** [ ] — Retrieve/hash, prove owned teardown and release/notify
  next before analysis. Report completed FPS first, separate raw clock estimates,
  both orders/variation, exact state/output/wire checks and measured service
  counts. Do not extrapolate the emulator gain to hardware or label reply waits
  pure raster time. Preserve all prior results and identify remaining overhead.
- **NAT-002-07** [ ] — Prepare a self-contained matched baseline/candidate C8
  fixture pair with required vdp_rally.bin, identical workloads and run/result
  instructions. No card overwrite, autoexec edit or flash in this task. Return
  concrete results and hardware kit; Author supplies moving visual/hardware
  truth. Mark goal complete only after this selected implementation/comparison/
  handoff is actually ready, or honestly retain unfinished work.

## Release and evidence boundaries

Checkpoint publication covers all existing dirt and this preimplementation task.
New implementation/results remain reviewable and uncommitted afterward unless
subsequently released. No peer source edits, generic runtime/ABI migration,
resource-limit increase, default adoption or unrelated numerical approximation.
The current a50/7e7d/plain086 composition is shared by all arms. No new VDPlet
build is needed for native-owned persistent data; route any real dependency to
mailbox vdplet through the established durable mail plus immediate steering.

References: [audit](../native-state-audit/FINDINGS.md),
[direct-row baseline](../direct-rows/RESULTS.md),
[Pi scheduling](/Agon/mystuff/agon-dev-env/cross-agent/pi5-workloads/README.md),
[Oryx scheduling](/Agon/mystuff/agon-dev-env/cross-agent/vdplet-rollout/README.md).
