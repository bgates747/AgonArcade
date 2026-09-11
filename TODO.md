# AgonArcade TODO

3. [ ] RALLY-04: Validate the current 96,344-byte narrow-shoulder build on physical
   hardware. Deployed to AGON /mystuff/arcade/rally/rally.bin; autoexec.txt
   preserved. Prior build had lag/strobing; remediation retest result pending.

8. [ ] RALLY-09: Review kerb/grass contact slowdown and inset shoulder lines.
   Car-width contact, milder kerb drag, restored grass drag and HUD surface labels
   pass host checks; hardware validation remains pending.

7. [ ] RALLY-08: Procedural flat-shaded infinity panorama, heading-driven
   scrolling, wider kerbs and white/yellow shoulder lines; emulator review.

9. [ ] RALLY-10: Investigate hardware/emulator frame pacing regression. Research
   complete: see docs/research/rally-frame-pacing.md. Attempt 1 replaces broad
   shoulder overdraw with narrow strips; hardware performance retest pending.
   Shipping must use stock VDP; custom completion callbacks are diagnostic only.

10. [ ] RALLY-11: Implement stock viewport scrolling for retained scenery.
    Frozen contract: docs/contracts/rally-scenery-scroll.md. Separate per-buffer
    offsets, exposed-edge repaint and wrap/fallback tests; hardware benefit unmeasured.

2. [ ] STUNT-01: Next project direction — Stunt Car Racer-inspired game using
   a custom Pingo VDP with true 3D, flat-shaded triangles. Start by qualifying
   the existing renderer/examples and a minimal elevated track with one ramp.
   Keep separate from Rally; notes in [the project brief](docs/plans/stunt-racer.md).

ARCADE-01 approval and validation are recorded in
[the development log](defender/docs/2026-09-11.md).

RALLY-02 research evidence is recorded in [the research log](docs/2026-09-11-research.md).

RALLY-01 emulator and physical-hardware acceptance are recorded in
[the Rally development log](docs/2026-09-11-rally.md). The user authorized a
local milestone commit; remote publication is deferred.
