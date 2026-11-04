# RALLY-28 — Direct-row road rendering experiment

Selected by the Author on2026-11-04: try direct hidden-page road rendering
before any async-UART experiment. If the improvement is marked, evaluate
async transmission afterward, then independent physics and rendering loops
that run as fast as practical without blocking each other. Those later
experiments are priorities, not part of this renderer comparison.

The Author subsequently requires this task to be written first, all existing
dirt committed/pushed in logical groups, then execution. Preserve every frozen
baseline/source/result/profile; create the experiment in this dedicated silo.
Root TODO owns the status of these immutable subtask identifiers.

## Problem and candidate

The accepted native renderer generates a320×120opaque AABBGGRR road bitmap in
VDP buffer50700, then emits an ordinary bitmap plot to copy it to the drawing
page. The Author objects to that recurring half-frame plot cost. Replace only
the road output target with the current VDPlet scoped colour-row service:
BEGIN once, resolve each row independently, fill the same clipped spans with
the same geometry/colours, preserve physical VGA sync bits, END before normal
actor/HUD/Canvas operations, and present only on success.

The new service is optional ABI1.6/capability256. It requires a separately
pinned compatible runtime/SDK composition and actual double-buffered SBGR2222
storage. No new generic service is proposed. Runtime/SDK contracts and generic
firmware belong to mailbox vdplet, chat VDPlet2026-11-04
(`01a1a540-82f4-7970-a1e4-fefc8b8ff9fb`); Rally owns integration and comparison.
Do not prompt the retired Golem runtime chat or edit another project's source.

## Scope and controls

Retain the full900-frame/3,600logical-step deterministic race, two warm frames,
scripted traffic, geometry/edge stepping, actor sampler, player, scrolling and
repairing sky, HUD/footer, audio changes, native state/publication checks,
request matching, post-swap fence, timeouts, finite cleanup and guest-created
telemetry. Keep UART synchronous and the existing coupled fixture scheduler.
Keep all presentation tasks: no road-only or static-fixture substitute for the
final comparison. Do not combine physics, approximation, cache or HUD changes.

The physical reference is Console8 return01:24.68MOS/24.73PRTFPS,900frames,
final state/all2,024replies/cleanup pass, mean40.44ms/frame. Original inputs,
firmware8da2ebfd… and native479fe1ac… stay unchanged. The supplied firmware
file is identified; the fixture did not read back installed firmware or MOS.
Human visual acceptance for this exact returned run remains unreported.

A fair candidate comparison must separate a runtime/compiler migration from
the output-target change. Pin the owner's recommended immutable rows closure,
compiler/library/maps and options. Prepare bitmap control and direct-row
candidate with the same selected policy/runtime and document any required
shared startup changes. Retain the old qualified native as the historical
anchor; do not silently rebrand new binaries as the old control. Check executable
contiguity and actual allocation, rather than assuming a higher text allowance
means mode136will fit. Do not weaken resource guards to force a run.

## Work items

- **ROW-001-01** [ ] — Freeze baseline/source inventory and consult VDPlet for
  the immutable row-enabled runtime/SDK, current qualified composition and
  exact compiler/capacity/startup requirements. Resolve the matching control
  before selecting target profiles. Record source ownership and differences.
- **ROW-001-02** [ ] — Prepare isolated bitmap/direct-row native variants.
  Reuse actual road geometry/span boundaries; remove the road bitmap plot
  from the row variant. Prove per-row address/layout, colour mapping, clipped
  bounds, sync preservation, balanced normal/error cleanup and no escaped
  pointers. Record whether old scratch storage is retained for first-pass
  matching or removed; never keep an unnecessary timed road copy.
- **ROW-001-03** [ ] — Verify actual modified C against the bitmap reference
  for representative/full deterministic scenes, both drawing pages, borders
  and failure paths. Keep ordinary functional state/lease checks. Build with
  pinned SDK/compiler; inspect size, stack/codegen and contiguous-memory fit.
  Use the single shared Pi build reservation for serial compile/link and
  ordinary bounded checks under the current canonical scheduling policy.
- **ROW-001-04** [ ] — Prepare fresh silent stopped emulator profiles and
  exact expected telemetry/wire changes. Establish new raw-capture expectations
  rather than normalize a differing stream into the old722,201-byte freeze.
  Bound the first cohort to bitmap60then rows60smokes, followed on success by
  bitmap900/rows900/rows900/bitmap900. First unexpected failure stops; no
  automatic retry or extra process. Freeze actual profiles/runtime and guards
  before normal Oryx FIFO checkout and assert before every process.
- **ROW-001-05** [ ] — Execute the bounded Oryx Flexe comparison with both SDL
  drivers dummy, normal thermal/power-restoration/cleanup guards and no other
  owned compile running during timing. Retrieve/hash, prove owned teardown,
  release and immediately notify the next owner before extended analysis.
  No physical firmware flash, human GUI launch or automatic card overwrite.
- **ROW-001-06** [ ] — Report complete rendered FPS first, separate MOS/PRT
  rates and disagreements, matched pair variation, exact state/reply/wire
  checks, memory/stack observations, visual differences and limitations.
  Compare same-runtime bitmap versus rows and label any historical baseline
  difference separately. Native-return and callback waits are not pure raster
  timing; retain the actual presentation fence in both arms.
- **ROW-001-07** [ ] — If the candidate is functional and promising, prepare
  a new stopped human review/hardware package with its required firmware and
  clear instructions for the Author. Preserve old profiles/card results and
  root autoexec.txt. Author visual confirmation and a later physical matched
  run decide adoption; emulator speed is not hardware truth. Stop with a
  concrete result and next recommendation before async/scheduler work.

## Execution boundaries

Current canonical Pi policy2026-11-04 makes finite serial compile/link jobs
self-service through the shared build reservation and token; no per-build
manager approval. This supersedes the older Nov3local scheduling summary for
builds. Substantial non-build Pi execution needs its separate admission and
Author authorization; do not disguise an emulator/soak as a build check.
Use Oryx's normal shared FIFO for the finite silent target cohort. Human review,
physical custody/flash and publication/default adoption remain separate.

Commit/push release applies to accumulated dirt and this preimplementation
contract. New experiment results are recorded honestly for review; it does
not approve a default runtime change or unobserved visual/hardware success.

References: [physical baseline](../hardware-review-20261104/return01/RESULTS.md),
[UART/VDPlet review](../../../../2026-11-04-rally-uart-vdplet-devlog.md),
[current row API](/Agon/mystuff/agon-vdplet/docs/API-reference.md),
[Pi scheduling](/Agon/mystuff/agon-dev-env/cross-agent/pi5-workloads/README.md).
