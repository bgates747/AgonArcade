# RALLY-14 — Measure individual drawing operations

## Objective

Support [RALLY-10](RALLY-10.md) by instrumenting an isolated diagnostic emulator
and/or its native VDP. Measure individual Rally drawing operations and rank the
largest time consumers. Root [TODO.md](../../TODO.md) owns status. Implementation
has not started; use this task when the coarse stock measurements cannot
separate execution costs or provide sufficient timer resolution.

## Approach

1. Inspect the documented Pingo-to-MOS callback donor and current native module
   ABI. Adapt tagged timing/completion records for Rally's 2D operations. The
   existing P3DR callback reports a 3D target bitmap ready; enabling it alone
   does not measure Rally or acknowledge its screen presentation.
2. Build a diagnostic runtime/module in an owned isolated directory. Preserve
   upstream checkouts and the normal stock review runtime. Qualify its timer's
   units, resolution and monotonic behavior; correlate host/VDP and MOS clocks
   explicitly rather than subtracting unrelated timestamps.
3. Instrument road primitives, panorama draws and viewport scrolling, ordinary
   and transformed/mirrored car bitmaps, and swaps. Record operation identifiers,
   counts, dimensions, durations and frame/sequence tokens. Separate CPU
   preparation, UART/queue delay, VDP execution and presentation where observable.
4. Deliver tagged diagnostic records through the MOS callback/mailbox mechanism.
   Keep interrupt work bounded, preserve registers and keyboard behavior, reject
   stale/malformed records and detect overflow. Drain pending events before
   disabling the callback or returning to MOS; never leave a callback targeting
   released application memory. Do not perform file/VDU work in the callback.
5. Use controlled RALLY-10 workloads. Compare instrumentation on/off, bound
   storage, dump after the run, and quantify instrumentation overhead. Report
   per-operation counts, totals and distributions; distinguish emulator results
   from hardware estimates or measurements.

## Acceptance and review

A reproducible report ranks the measured drawing costs and explains unmeasured
costs, clock boundaries and overhead. Lifecycle, timeout/overflow and keyboard
checks pass. Rendering matches the stock reference for the tested scenes.
Launch the isolated diagnostic review emulator for human validation. Leave
runtime/module/launcher changes uncommitted until explicit commit approval.

Shipping Rally must remain stock VDP; these callbacks and runtime modifications
are diagnostic only. No production physics, steering or asynchronous scheduler
redesign belongs in this task.

## Supporting files

Place task-specific scripts, instrumentation patches and selected results in
`docs/tasks/RALLY-14/` as they are created; keep generated binaries/profiles in
ignored runtime directories. Read the
[Pingo donor section](../research/rally-frame-pacing.md#pingo-donor-verified-completion-versus-presentation)
and canonical `agon-dev-env/codex/bespoke-vdp-emulator.md` before implementation.
