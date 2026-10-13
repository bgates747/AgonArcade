# RALLY-24 local implementation contract — 2026-10-12

## Executive summary

Author approved the proposed local tranche and requested all outstanding dirt be committed and pushed first. Implement a task-local native road/car generator targeting candidate B, with A as a diagnostic control. No firmware flashing, deployment, emulator/profile changes or gameplay runs. Preserve current playable sources and the VDPlet SDK/runtime. Stop at a verified local result or a documented numerical/resource blocker requiring design review.

## Ordered work and evidence

1. Freeze this contract before source development. Root TODO RALLY-24 remains the sole active task register.
2. Add explicit serializers, resident assets, a current-game C++ reference oracle and finite native module(s) in `experiment/`. Generate all outputs in ignored `experiment/.work/`.
3. Validate one section first, then road, cars, existing signs/finish/crash dependencies. Match current arithmetic, ordering and stream semantics; do not relax pixel expectations.
4. Test serialization, input bounds, output capacity, lifecycle/lease cleanup and readiness guards with a local mock host. Use sanitizers where supported. Host checks are not runtime/hardware qualification.
5. Compile with the pinned classic Xtensa SDK; inspect imports, text/data/package and stack. Stop for review if the current single-module envelope fails; preserve the failing measurements and propose bounded splitting rather than increasing runtime limits.
6. Report local parity/limits and outstanding physical questions. No speedup claims from host timings. Hardware installation and human review need the next explicit instruction.

## Completion tracking

Execution evidence and completed steps belong in LOCAL-RESULTS.md. Existing research files remain historical proposals where marked; this contract records the current approval boundary. No work in RALLY-25 or RALLY-26 is activated.
