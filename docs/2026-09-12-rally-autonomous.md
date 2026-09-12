# 2026-09-12 — Pre-Golem product and autonomous bench planning

The Author reports the stripped pre-Golem Rally now deployed on the Agon is a
viable product. The accepted binary is identified in the RALLY-20 contract;
this is qualitative oval gameplay acceptance, not a frame-rate measurement.

The Author requests a new goal to optimize that version and enable modification
of Agon SD contents through Extender, minimizing physical involvement. Later
P4/onboard VDP flashing and diagnostic hooks are authorized. Work this turn is
limited to planning, followed by an emulator notification and a review pause.

The follow-up observation is deliberately preserved without resolving it by
guesswork: kerb strobing appears less regular in curves, but demo deceleration
may explain it; controls remain responsive, and heavy traffic has little
apparent effect. R20-05 compares curvature at constant speed with traffic varied
independently. Neither consistent hardware 30 fps nor a curve bottleneck is
established.

RALLY-20 consolidates useful open Rally performance/qualification items without
marking their outstanding reviews as passed. See its task mapping and contract;
the root TODO owns execution. RALLY-19 remains closed research, with native
success and impractically slow physical full-scene Golem rendering both recorded.

Planning inspected project documentation, source contracts and Git state only.
No physical connection, firmware operation, SD edit, build or game test was
performed. Existing uncommitted deployment and QUAL-003 work is preserved.
The plan-review emulator is notification-only, not candidate validation.

The Author subsequently proposed delaying traffic visibility until its highest
drawn row lies within the road-span refresh region, to avoid clobbering retained
background. Added to R20-06 as a measured candidate, with transformed footprint,
curve coverage, alternating-buffer history and appearance-transition checks.
The Author explicitly says not to proceed with the goal; no implementation or
experiment accompanies this documentation amendment.

The Author then made mainboard SD read/write capability the first prerequisite
before all other development. Created Extender PORT-017 on its existing main
branch and placed it first in the local TODO, ahead of graphics work. Its local
task includes Radiotux findings, actor ownership, protocol-first design and
physical integrity/keyboard/recovery gates. Existing wiring is confirmed by
the Author; bulk service software is not yet qualified. Rally consumes that
task's evidence, and no returning Extender agent needs this checkout to proceed.
Golem development is explicitly excluded. The implementation pause remains.
