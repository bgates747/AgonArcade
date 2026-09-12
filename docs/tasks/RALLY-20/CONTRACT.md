# RALLY-20 frozen planning contract

2026-09-12. Author review pending. Execution register: root `TODO.md`, R20-00
through R20-08. This document freezes the work order and evidence gates, not an
unresearched wire protocol. Later protocol choices must be documented before
implementation and may not silently change this task's acceptance criteria.

## Mission and current permission

Optimize the hardware-accepted pre-Golem Rally while building an unattended
development loop: change Agon SD files through Extender, launch bounded game
experiments, retrieve trustworthy measurements and restore a playable product.
Minimize requests to the Author for SD-card movement, resets, wiring or probes.

The Author permits later Extender and onboard VDP firmware changes, application
test hooks and cross-project development managed by this agent. This turn is
**planning only**. Do not build, test, flash, change the physical SD or start
implementation before review. Documentation and its freeze commit are in scope.
At the end of planning, launch one clearly labelled emulator notification and
pause. All subsequent emulator testing is headless. Later GUI summons are for
unavoidable human physical intervention, not routine progress announcements.

No delegation. Do not push, merge unrelated work, or commit emulator changes
without the applicable explicit approval. Commit each completed execution item
with evidence, keeping component implementations and integration evidence in
their respective repositories. Record exact participating commits. Preserve
dirty work instead of including it accidentally in a milestone commit.

A needed EMOS change is a design decision to expose at the transport gate:
the Author explicitly named P4 and onboard VDP flashing, not an arbitrary MOS
replacement. Prefer the existing supported interface or a RAM application. If
a new EMOS image is indispensable, establish its authorization and recovery
route before deploying it; do not substitute direct UART/interrupt patching.

## Accepted baseline and preservation

The conceptual source baseline is Rally commit
`949f6186853ab99f257906e95786593a7a2e098f`, with the later production stripping
recorded by RALLY-19's `build_pre_golem_production.py`. Neither current root
`make -C rally` nor the Golem candidate can be assumed to reproduce this binary.

| Artifact | Bytes | SHA256 |
| --- | ---: | --- |
| rally.bin, stripped production | 131731 | e14e5c0f155a4f035e925b1da5971e8f7202fe47c7147e24a5726ef937d4fe5f |
| oval.road | 20584 | a433e692f75e086bc0b20f80442cb55f5dda2b445a291fd3537bf951e02cf625 |
| fuji.road | 116800 | 72f835b888a79f3130e2d8c73c9ab8a80e3dcdc04991ea223038e43ce0d4269e |

Reproduction and deployment evidence are under
`docs/tasks/RALLY-19/evidence/hardware-production/pre-golem-oval/`; generated
builds are under `docs/tasks/RALLY-19/.work/production/pre-golem-oval/`.
The source builder, deployment helper and evidence were untracked at planning
time; preserve and publish their nonprivate provenance in R20-01. Do not stage
the root `.work/` wholesale: it contains physical flash backups.

Physical application path is `/mystuff/arcade/rally/rally.bin`. Current startup
selects `SET KEYBOARD 1`, enables `EMOS KEYINPUT extender`, loads that file and
uses `run . oval demo`. Preserve the surrounding autoexec comments and CRLF
bytes; current autoexec SHA256 is
`c051ef1f18ce2941ba4e583a12f8d70adb9ffeac5ac13c55027db071a059d9e7`.
The Extender is the only usable keyboard path because the mainboard keyboard
circuit is damaged. A routine debug step must not disable it.

Official onboard VDP 2.16.0 was verified against all three release segments
before the accepted run. App-segment SHA256:
`b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f`.
Official images and the original full flash backup are in root
`.work/stock-vdp-2.16.0/`. The current physical MOS is EMOS. Extender's last
local bench notes name P4 r11 and EMOS v0.1.13; those identities require a fresh
check before experimentation. This planning pass did not contact the boards.

The accepted renderer computes lookup/projection spans on eZ80 and uses simple
resident VDP drawing commands. It retains mode 136, 320x240 double buffering,
the retained panorama, all road markings, player and six traffic liveries.
Latest production tuning is grip 60%, top speed 300, world-speed multiplier 2
and steering 3 ticks per rendered iteration. Preserve the actual accepted
headers, not earlier transcript values such as top speed 224. Perspective is
off by default. Demo steers and slows for corners; any key enters racing.
No diagnostic fences, trace files, logging or performance collection ship in
the production derivative.

The clock is nominally 120 Hz and current pacing advances deadlines by four
ticks. That is a requested 30 Hz cadence, **not proof of sustained 30 fps**.
The Author's latest observations are: kerb strobing suggests possible uneven
frames in curves; demo deceleration could explain it; manual input remains
responsive; heavy traffic has little apparent effect. These are valuable
qualitative observations, not a measured curve or traffic bottleneck.

## Work order and decision gates

### R20-01 — Establish reproducible product and bench identities

Preserve the above executable/data/startup and collect their existing evidence.
Reproduce the stripped build before moving it into a maintained product path;
record toolchain, source, headers and output hashes. Any source relocation must
be a separate reviewable change with a demonstrated behavior match.

Read component AGENTS/OWNERSHIP, `HARDWARE.local.md`, bench constraints and version
policy. Record clean source identities and existing dirty files separately.
Create isolated implementation branches/worktrees where needed; no edits to
upstream MOS/VDP references or unrelated QUAL-003 work. Obtain fresh live
capability/identity observations only once implementation is released.

Record actual PC–Pi–P4, Ethernet, UART1 and onboard USB serial topology, current
input routing and available reset mechanisms. Keep private addresses, SSH
identities and board IDs in ignored local manifests. Preserve the known-good
product and firmware in independent recovery locations before changing either.

### R20-02 — Freeze and prove the smallest viable control/transfer design

Intended ownership path:

```
Developer host -> P4 control/data service -> EMOS-owned Extender transport
               -> eZ80 foreground bench service -> MOS/FatFS -> Agon SD
```

Results and acknowledgements return through the same owned service. The P4
does not acquire the Agon's SD bus. Its separate microSD slot is unrelated.
There must never be two writers mounting the same filesystem.

Inventory existing APIs before adding firmware. The current P4 network service
exposes video and optional timing diagnostics; inspection found no Agon SD file
upload endpoint. UART1 is already owned by EMOS while the Extender keyboard is
selected. Public UART calls or replacement IRQ handlers are not a valid way to
steal it. Existing QTG/8C timing replies have source/mode restrictions and are
not an established general-purpose bulk channel in Legacy mode.

The gate delivers a documented prototype route, byte/queue/RAM budgets,
foreground polling/dispatch contract, keyboard coexistence and recovery story.
Prefer a small RAM bench application plus minimal owned EMOS interface if
necessary; the 128 KiB EMOS image has little spare space. Confirm actual fit
and ABI rather than assuming a large filesystem server belongs in ROM.

Do not claim the initial bench application is already on the Agon SD. Establish
a concrete bootstrap: existing installed transfer capability, safe console
loader, or a one-time installation if other supported paths fail. A keyboard
command can launch a present file; it cannot make a nonexistent loader exist.
Freeze this decision and any required firmware authorization before proceeding.

The protocol must identify sessions, requests and transfers; bound payloads,
paths, queues and timeouts; verify length and checksum; support offset/chunk
retry, duplicate/lost acknowledgements and status queries. Preserve keyboard
priority and release semantics under bulk traffic. File I/O happens in a
foreground MOS context, never in an interrupt or keyboard callback. Bulk bytes
must not masquerade as keystrokes. Avoid dependency on the deferred browser UI.

### R20-03 — Qualify transfer, activation and recovery

Implement staged writes, readback verification and explicit activation. Keep a
known-good runnable fallback. Close files and stop the prior job before changing
its files. A successful acknowledgement means the documented durability level,
not merely that bytes reached a UART buffer. FAT rename is not a promise of
power-failure atomicity: define a recoverable journal/selection scheme and its
failure windows. Treat startup changes as backed-up, verified transactions.

Test truncation, corrupted chunks, retry, stale sessions, lost ACKs, full disk,
write/sync errors and interrupted activation without destroying the only good
copy. Use raw-image emulator filesystem tests where appropriate: Extender
REMED-003 records failures specific to the directory-backed FAT adapter.
Headless success does not establish physical SD durability.

Normal tests terminate cooperatively and return to a responsive service. Freeze
separate recovery procedures for app hang, VDP hang, P4 reset and transport
loss. P4 USB serial opening may reset P4 and remove the keyboard temporarily;
onboard VDP reset is not a whole-Agon reset. Do not allow flash/reset loops.

The old Pi/reset breadboard circuit is documented as electrically unresolved.
Do not toggle it or assume automatic hard reset exists. Qualify a real reset
path before deliberately testing unrecoverable hangs. If no supported remote
recovery works, exhaust the software routes, then request one bundled physical
intervention with an emulator summons. A board hang must remain an explicit
limitation until that path is proven.

### R20-04 — Demonstrate the unattended development cycle

Host orchestration builds a uniquely identified candidate, transfers and checks
it, launches a bounded run, retrieves structured results, classifies failure
and restores the chosen runnable product. Support cancellation, stale-run
rejection and restart after interrupted host execution. No overlapping flash,
serial capture or SD owner. Keep live-monitoring ports out of reset-prone opens.

Acceptance: ten consecutive complete cycles with at least two distinct test
builds and deliberate recoverable failures, with no human SD movement or reset.
Record recovery time, all host/firmware identities and any untested hard-hang
case. Do not advertise fully unattended hard-hang recovery based on cooperative
tests. Commissioning physical actions are counted separately, not hidden.

### R20-05 — Establish the physical performance baseline

First answer the Author's curve observation with a controlled matrix:

| Variable | Matched cases |
| --- | --- |
| Road shape | Straight, shallow curve, tight curve; both tracks |
| Vehicle speed | Identical held speed and stripe-phase progression within each comparison |
| Traffic | None, representative traffic, heavy visible overlap; identical poses across variants |
| Driver | Deterministic constant-speed fixture; ordinary slowing demo reported separately |
| Pacing | Existing paced product versus isolated unpaced diagnostic renderer |

Do not infer FPS from kerb aliasing. Measure submission, completion and pacing
separately: simulation/geometry CPU, packet construction, UART blocking/bytes,
VDP queue/draw work, buffer-swap completion and frame intervals. Give each
counter an exact definition and frame sequence. Callback receipt/root-call
return are not automatically scanout timestamps. Clocks from different chips
must be correlated explicitly, not subtracted as though synchronized.

Use bounded in-memory counters/traces and read them after each run. Prefer the
stock ESP32 library timing primitives, e.g. `esp_timer_get_time`, with explicit
resolution and wrap/clock behavior. No hot-loop serial printing. Compare
instrumentation absent, counters enabled and detailed tracing to quantify
observer cost. Diagnostic custom VDP is allowed; shipping requires stock VDP.

Reuse the existing QUAL-003/INTEG-012 work selectively: its first physical
mainboard sprite test reached FR_TIMEOUT after 114 successful intervals. That
failure has no established cause; even its detail-off path retained hooks and
fences. It is not a zero-overhead baseline or proof of a Rally bottleneck.

Record medians, p95/p99, interval distributions, missed requested deadlines,
UART totals and instrumentation overhead. Use a monotonic local timeline and
warmed matched runs. Start with at least three ABBA pairs of 64-pose batches
per track plus 60-second paced runs, lengthening only if uncertainty requires
it. Host native results stay separately labelled. Normal eZ80 clock is the
baseline; unlimited emulator CPU is a diagnostic variant only.

### R20-06 — Optimize the measured limiting work

Rank candidates using R20-05. Initial hypotheses include lookup/division and
packet construction on eZ80, unnecessary span/clip/overdraw work, affine car
draw cost, and scenery repair. Traffic and curvature are hypotheses, not
preassigned bottlenecks. The accepted baseline's SDK viewport calls reportedly
reverse pixel-mode Y endpoints; evaluate that as a separate correctness and
performance candidate, never silently fold it into the baseline.

Use small changes and matched A/B comparisons. Simple preloaded drawing batches
may reduce UART traffic; they do not make the same raster primitive inherently
faster. Do not repeat full-scene interpreted Golem arithmetic as this task's
main renderer. Keep alternate experiments reversible and out of production
until qualified. First batch is bounded to three evidence-selected candidates,
followed by a written retain/reject/next decision; no unbounded silent search.

The review target is at least 10% lower median physical unpaced render interval
with p95 no worse than 5% over baseline on both tracks, plus no regression in
paced deadline misses or input responsiveness. This is a proposed optimization
target, not a historical measurement or a promise of 60 fps. Report a measured
ceiling or failed target honestly; do not mark optimization complete merely
because the tooling is complete. Freeze any revised target explicitly with its
reason before qualifying against it.

Do not buy a faster result by deleting cars, road bands, markings or scenery,
reducing resolution, slowing the car, weakening grip or changing steering feel.
Steering currently advances per rendered iteration: simply raising a render
cap changes the game. A pacing/physics change needs an explicit design with
equivalent physical-time controls and review, not a hidden performance tweak.

### R20-07 — Qualify retained changes and clean production

Adapt R19's 66-pose visual fixtures and material/car masks to this exact
pre-Golem baseline; validate the comparator before using it. Include both
tracks, seams, signs of curvature, road edges, retained-page history, traffic
overlap, all five views/reflections and demo/manual transitions. Keep every
visible material/object and baseline geometry within one pixel; explain any
raster tolerance rather than relaxing it after a failure. Test control timing,
kerb/grass behavior, stop/start, exit and resource lifecycle.

Run the meaningful host checks and headless regressions for the actual source
being changed, then repeat matched physical A/B measurements. Require at least
ten minutes per track without crash, resource growth or corrupted input. Record
what a counter actually proves; human approval of an earlier Linux/Mac build
does not validate a new build or final hardware appearance.

Remove instrumentation from the production build rather than hiding enabled
hooks behind an unused menu flag. Restore and verify official onboard VDP and
an ordinary working Extender keyboard configuration. The game must not require
custom VDP callbacks, fences, logs or performance collection. Preserve the
separate development/recovery workflow without running it inside production.

### R20-08 — Deliver reproducibly and stop cleanly

Publish local durable source/build/run manifests, fixture definitions, raw
results, analysis, known limitations and rollback instructions. Integrate the
accepted renderer into a clearly documented maintained source path; do not
leave future agents thinking root `make` builds an unrelated candidate.
Record all component commits and uncommitted/private artifacts that must be
preserved. No remote publication without authorization.

Leave the card set to oval demo with press-any-key-to-race and Extender keyboard
enabled, with verified product/assets/startup hashes. Report baseline versus
candidate performance and actual human interventions. Final gameplay/appearance
acceptance remains human validation, and emulator-related commit approval must
be explicit. No routine GUI completion summons beyond the planning exception;
use one later only when the Author must physically intervene.

## Evidence and reference map

- RALLY-19: DELIVERY, BUILDING, HARDWARE-DEBUG, DEBRIEF-2026-09-12 and the
  pre-golem-oval production evidence. Native success and slow physical Golem
  rendering are separate facts; observed stack-depth failure was corrected.
- `agon-extender/OWNERSHIP.md`, `agon-emos/OWNERSHIP.md`, component AGENTS,
  `agon-extender/docs/qualification/bench-constraints.md`, ignored
  `HARDWARE.local.md`, and `docs/versions/README.md` govern component work.
- EMOS `src/uart.c`, `src/emos_console.c`, INTEG-012; Extender
  `vdp/video/extender/network/wired_network_service.cpp`, QUAL-003 contract and
  latest physical failure evidence describe current capabilities and limits.
- Official local `agon-docs/docs/mos/API.md` and `Star-Commands.md` specify MOS
  filesystem and console APIs; MOS v3.0.2 and VDP v2.16.0 references are pinned.
- [ESP Timer, ESP-IDF 4.4.7](https://docs.espressif.com/projects/esp-idf/en/v4.4.7/esp32/api-reference/system/esp_timer.html)
  documents the stock timer primitive; use the actual firmware SDK's matching
  API and measure overhead, rather than importing ESP32-P4 assumptions to ESP32.

At planning freeze: Rally HEAD 5b6e3c3, Golem 3ac500c, Extender 05d9921, EMOS
e48d431, agon-dev-env ea122d8. These are recorded observations, not a command
to reset any tree. Rally's prior production deployment documents/helpers and
Extender's QUAL-003 results are dirty; preserve them. No firmware, card, source,
build or physical run was changed to prepare this plan.
