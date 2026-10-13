# RALLY-26 — Resident crash effects and VDPlet state machine

## Executive summary

Explore keeping explosion assets, animation state and drawing on VDP, with multiple stored VDPlet packages selected for racing and special effects. Current runtime has one active module, so module switching is explicit load/unload work, not concurrent execution. Planning recorded 2026-10-12; implementation awaits Author review and RALLY-24 evidence.

## Proposed work

- [ ] MOD-001 — Inventory regular-racing and effect code/data sizes against package, executable-memory, data/BSS and stack limits. Prefer shared racing/effect code where it fits; allow multiple packages rather than force everything into one module.
- [ ] MOD-002 — Define persistent versioned state in separate VDP buffers, entry IDs and lifecycle transitions: racing, crash start, effect progression, recovery, cancellation, unload/exit. Module globals and acquired pointers do not survive module replacement as a valid sharing mechanism.
- [ ] MOD-003 — Measure package load/relocation/init and unload costs separately from steady-state calls. Compare once-per-state-transition swaps against recurring per-frame swaps; record executable heap fragmentation and repeated-load behaviour. Stored-in-buffer does not mean zero-cost activation.
- [ ] FX-001 — Plan bounded native animation steps using explicit elapsed physics time or another agreed clock. Entries must return; no endless animation loop and no unproven autonomous scheduler. eZ80 may invoke/timestamp progress without computing explosion geometry.
- [ ] FX-002 — Preserve drawing of road, traffic, scenery and HUD during the explosion. Specify either a module retaining regular rendering or an ordered multi-module schedule, with double-buffer ownership and command buffers valid across swaps.
- [ ] FX-003 — Keep original assets/palette and define start, completion, cancellation and recovery events. Collision handling remains eZ80-owned unless RALLY-25 is separately accepted. Effects can start from an eZ80 collision event without requiring native collision detection first.
- [ ] VAL-001 — Plan visual equivalence, both page histories, interrupted effects, successive crashes, allocation/load failure, exit and reset tests. Report load spikes, frame tails, recurring bytes and memory, not just average native call time.
- [ ] REV-001 — Present the state machine, resource budget and bounded implementation proposal for review. Any missing reusable services are proposed to agon-vdplet separately.

## Boundaries

No direct colour-framebuffer service is assumed: current services expose PALETTE2 only, so colour effects initially use generated ordinary VDU commands as in RALLY-24. No broad renderer rewrite, firmware changes or hardware work is authorized by this planning record. Keep current Rally and experiment rollback intact.
