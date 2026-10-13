# RALLY-25 — Native traffic simulation and collision events

## Executive summary

After RALLY-24 proves road/car visual offload, evaluate moving traffic position updates and collision detection into bounded VDPlet jobs. This is a later feasibility stage, not a requirement to change first-pass physics. Planning recorded 2026-10-12; execution awaits Author review.

## Proposed work

- [ ] TRF-001 — Use RALLY-24 measurements to determine whether traffic simulation has meaningful remaining CPU cost. Preserve deterministic routes, circuit/triggered traffic modes and opponent separation guarantees.
- [ ] TRF-002 — Define world-state ownership, fixed physics tick, catch-up limits and synchronization with eZ80 player motion. Rendering rate must not determine simulation results. Choose whether traffic simulation alone or collision detection alone should move first based on evidence.
- [ ] COL-001 — Audit the existing custom keyboard-packet callback mechanism and VDPlet service table. Native modules presently have no raw serial/callback service; identify whether a resident event buffer plus existing firmware dispatch suffices or propose a separately owned runtime service. Do not promise callbacks before that audit.
- [ ] COL-002 — Specify collision event code, object identity/generation, sequence, physics tick and run/session identity. Define duplicates, overflow, lost/stale notifications, reset and queue recovery; do not confuse callback packets with real keyboard input.
- [ ] COL-003 — Define exactly which processor detects contact and which applies crash state, penalties and recovery. Prevent double reporting or eZ80/VDP disagreement. Specify deterministic collision tests independently of projected screen rectangles.
- [ ] VAL-001 — Plan comparison against unchanged eZ80 simulation: deterministic replay, near misses, lap wrap, spawn/despawn, catch-up and repeated contact. Measure event latency, wire bytes and both processors' work separately.
- [ ] REV-001 — Present ABI, ownership and benefit assessment for review before code, runtime changes or hardware tests. Retain eZ80 implementation as oracle/rollback.

## Boundaries

RALLY-24 keeps traffic simulation and collisions on eZ80. This task does not revive driving practice or Golem. Module-generated events would notify eZ80 to branch into gameplay handling; asynchronous arrival alone is not an agreed physics clock. Any reusable runtime API belongs in agon-vdplet with its own review. No development, build, deployment or commit is authorized by this roadmap.
