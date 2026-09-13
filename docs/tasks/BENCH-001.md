# BENCH-001 — Rally telemetry and engine sound

Status: Active component work, authorized 2026-09-13.

The Author selected unattended resident telemetry, host-controlled Rally driving
and a speed-linked sine engine tone. The final physical driving run provides
the wake-up cue; all earlier checks are silent/headless. This supersedes old
planning-only restrictions for this bounded experiment, not unrelated work.

Create rally-bench as an isolated derivative of rally-production, reusing its
accepted headers. Add optional EMOS telemetry and sine engine sound. Preserve
manual steering/grip physics. Publish coherent game state and road look-ahead
for an external host keyboard driver; never substitute the game demo driver.
The accepted rally-production source/binary and wider RALLY-20 queue stay intact.

The cross-component execution checklist and provisional wire contract belong
to agon-extender/docs/tasks/BENCH-001.md and BENCH-001/TELEMETRY.md. This file
owns local implementation scope; it does not duplicate that execution register.
Use identified draft builds and preserved rollback. Necessary scoped deployment
uses the Author's standing firmware/SD/reset authorization; no commit or push is
requested. Preserve current branches and unrelated/concurrent work. Applicable
emulator human validation and commit approval remain separate from machine tests.

The Author subsequently requested faster driving with traffic avoidance. The
Extender-owned v2 contract expands copied snapshots to 140 bytes and defines
physics-tick overlap observations without gameplay collision response. Preserve
production physics and engine tone. Fresh game startup and held-Escape exit
bound each physical run; future attention cues use an emulator beep.
