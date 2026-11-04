# RALLY-28 — Native state and interpreted-command audit

Selected by the Author on 2026-11-04. Write this task first, commit and push
all accumulated dirt in logical groups, then perform and record the research.
This tranche audits source and existing evidence; it does not implement the
redesign, build, run an emulator, deploy firmware or change a frozen fixture.

## Objective and direction

Identify and remove from the future native design all remnants of the earlier
attempt to execute Rally logic using the interpreted VDP buffered-command API.
The intended replacement is efficient native C data structures and direct
pointer access, with useful pointers held for as much work as their actual
lifetime permits. Investigate call consolidation, array layout, prevalidated
bulk access, native-owned state, scratch ownership and any other concrete
source-level means of reducing access costs. Do not preserve an inefficient
representation merely because the Golem-generated interface uses it.

Establish which current operations actually interpret buffered commands and
which merely use the buffered API's allocations as data storage. A buffered
RUN wrapper, a buffer containing native code, a data buffer and a framebuffer
lease are distinct. Trace the actual current call chain and historical origin;
do not equate all buffer usage with interpretation or claim a speedup without
measurement. The Author's suspicion is a research lead, not a proven cause.

The selected direct-row candidate is the main subject. Preserve its exact
bitmap control, old qualified module, full-race inputs and results. The older
standard-VDP interpreter experiments are historical references, not candidates
for restoration. General findings may apply to both RALLY-28 code silos.

## Work items

- **NAT-001-01** [ ] — Pin the selected guest/native/helper/runtime/SDK sources,
  read VDPlet's Rally/Wolf comparison and locate earlier interpreted-command
  artifacts. Trace guest packets through buffered wrappers, native dispatch,
  state access, drawing and completion. Record which bytes are interpreted,
  what is native and what storage is shared. Use precise source references.
- **NAT-001-02** [ ] — Inventory active buffers, state layouts, handles, ownership,
  validation and lease lifetimes. Trace every root/array/scalar acquisition,
  release, copy and repeated shape check in Tick/Init/Render/Stop. Separate
  static site counts from exact path counts and unmeasured timing. Include
  eZ80 reads/writes and presentation dependencies on the exposed state.
- **NAT-001-03** [ ] — Audit native helper access, actor/sky/HUD/drawing command
  construction and interpreted wrappers for avoidable indirection, staging,
  serialization and repeated work. Classify each retained buffered operation:
  required transport/stock primitive, replaceable game logic, data allocation,
  native-code loading or diagnostic-only. Identify common fixes across paths.
- **NAT-001-04** [ ] — Compare concrete native-C replacement designs: one checked
  borrow per useful scope, packed/typed state with immutable tables, consolidated
  calls and persistent native-owned state if supported. Establish pointer,
  allocation, alias/alignment, mode/unload/failure and four-lease constraints
  from actual runtime source. Record missing contracts instead of inventing
  pointer persistence or weakening validation. No peer edits or new ABI work.
- **NAT-001-05** [ ] — Record prioritized findings, evidence, proposed replacement,
  dependencies and a staged measurement plan. Preserve exact simulation and
  complete-race rendering when comparing integration changes; report FPS plus
  phase costs and wire bytes. Distinguish experiments requiring later release.
- **NAT-001-06** [ ] — Reconcile the task/root TODO and report the research result,
  concrete next implementation tranche and remaining questions to the Author.
  Stop after research; hardware/visual, async UART and independent scheduling
  keep their own pending scopes and are not started by this audit.

## Deliverables and checks

Write FINDINGS.md with an actionable inventory and replacement plan, plus a
source hash manifest for the audited inputs. Use immutable finding identifiers
and exact source paths/lines. Mark evidence strength explicitly: source fact,
static/dynamic count, historical evidence, hypothesis, or timing measurement.
Read-only source inspection and small bounded analysis scripts are sufficient;
no compiler, benchmark, emulator, Oryx/Pi queue reservation or physical action
is selected. Do not make a historical source inspection into a broad busy scan.
New research results remain uncommitted for review after the initial checkpoint.

References: [direct-row result](../direct-rows/RESULTS.md),
[shared costs](../direct-rows/SHARED-COST-NOTES.md),
[VDPlet comparison](/Agon/mystuff/agon-vdplet/docs/tasks/VDPL-024/RALLY-WOLF.md),
[original renderer/state work](../../../RALLY-25.md).
