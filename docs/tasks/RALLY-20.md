# RALLY-20 — Autonomous hardware development and Rally optimization

Status: planning frozen for Author review; implementation is not authorized to
begin until that review. Created 2026-09-12.

The Author accepts the stripped pre-Golem build as a viable hardware product.
This task develops that renderer, together with the Extender-assisted bench
workflow needed to optimize it without repeated human intervention.

Read [CONTRACT.md](RALLY-20/CONTRACT.md) for scope, baseline, architecture,
experiments, acceptance and recovery boundaries. The root [TODO](../../TODO.md)
is the sole execution checklist. Historical task evidence remains in place;
consolidation is not a claim that every previous review has passed.

The Author explicitly requested an emulator summons when this planning phase
is ready. That notification is an exception to headless testing, and does not
authorize starting implementation, running a benchmark or changing hardware.

## Forwarded work

| Previous task | Disposition in RALLY-20 |
| --- | --- |
| RALLY-18 | The 949f618-derived production binary now has qualitative oval hardware acceptance. Preserve its precise derivative; mainline integration, quantitative qualification and Fuji review remain. R20-01, 05, 07, 08. |
| RALLY-17 | Reuse separation of simulation/geometry, packet construction and UART costs. Old measurements are host evidence, not a physical baseline. R20-05. |
| RALLY-16 | Reuse normal-clock unpaced fixtures. The particular native swap implementation does not establish a universal 30 Hz hardware ceiling. R20-05. |
| RALLY-15 | Preserve the simple resident section draw expansion already in the accepted lineage; further changes need measured benefit. R20-06. |
| RALLY-10 | Performance investigation becomes this task's hardware measurement and optimization work. R20-05 through 07. |
| RALLY-14 | Reuse diagnostic counter/callback research only where needed, with measured overhead and no production dependency. R20-05. |
| RALLY-04 | Latest oval build is qualitatively accepted, superseding the old binary selection. Both-track regression and final new-build hardware qualification remain. R20-07, 08. |
| RALLY-09 | Preserve current shoulder, tyre/hub and kerb/grass/grip behavior; exercise boundaries during regressions. Broad acceptance does not settle every edge case. R20-07. |
| RALLY-08 | Preserve accepted scenery and road-edge artwork, including flat sky. No new dithering experiment. R20-07. |
| RALLY-11 | Retained scenery is part of the baseline. Preserve page association, wrap behavior and foreground repair; its hardware benefit is not quantified. R20-05 through 07. |
| RALLY-19 | Closed research, not a product acceleration. Carry diagnostic lessons, fixtures and provenance; do not resume full-scene Golem arithmetic. R20-01, 05, 07. |

The original task files remain historical references. STUNT-01 and unrelated
Defender/Aginvadors work stay separate. Autosteer feel, banking, new art, new
tracks, collisions/explosions and higher resolutions are not performance fixes.

## Cross-project ownership

RALLY-20 owns the ordered integration plan, run evidence and acceptance. It does
not replace component ownership or sweep unrelated component TODOs into scope.

| Owner | Work within this task |
| --- | --- |
| AgonArcade | Accepted game lineage, foreground bench application, production/test separation, replay fixtures, orchestration and aggregate evidence. |
| agon-extender | P4 firmware, transport contract, input coexistence, bounded remote control/data service and system qualification. |
| agon-emos | Any necessary eZ80-side Extender dispatcher/service/API changes; UART1 and console routing ownership. |
| mos-agondev | Existing build/ABI/link guards, if an EMOS change proves necessary; no application implementation here. |
| Owned VDP diagnostic checkout | Temporary counters/timing hooks based on official 2.16.0, with exact restoration artifacts. Upstream checkouts remain read-only. |
| agon-dev-env | Canonical setup/bench guidance and durable coordination references; do not modify shared launch policy to hide a local problem. |
| Golem | Donor of completed research only; no new compiler goal. |

Useful Extender donors are QUAL-003/INTEG-012 (timing and reply ownership),
INTEG-009 (working keyboard), and REMED-003 (directory-backed emulator FAT
limitations). REMOTE-001's deferred browser UI and PORT-007's P4-local SD work
are not prerequisites. Component task IDs and public interfaces will be recorded
before component implementation; avoid duplicate independent progress checklists.
