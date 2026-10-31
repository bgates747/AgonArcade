# HUD cache implemented; benchmark stopped in original artwork setup

**No new completed-frame FPS is available.** The first, unchanged control stalled
before race initialization; the cached guest and five remaining tests never ran.
The last qualified compact reference remains **36.1930 FPS,900frames/24.8667
nominal MOS seconds**, with separate PRT **34.9610 FPS,900/25.743 seconds**.
Those are historical references, not results from this attempt. The cache's
performance and target visual correctness are still unqualified.

## Implementation and offline checks

The shared game/fixture presentation caches formatted field strings before
rebuilding unchanged text. It preserves original formats, values, per-page HUD
cell/color retention, footer drawing, native module, firmware, assets, physics
and completion checks. The standard game and separate candidate build; empty
CRT/release checks pass. Ordinary, sanitized and development actual-function
tests each pass12,932 byte/cell comparisons. Race formatting falls7,200→2,645
calls (63.26% fewer); this is a work count, not a frame-rate gain.

[CODE-REVIEW.md](CODE-REVIEW.md) records keys, invalidation, edge coverage and
machine-code sizes. Original guest`685f4b4c…`, candidate`c6d75022…`, native
image`479fe1ac…`, firmware`8da2ebfd…`. Only guest/metadata differ within each
test pair. All84readiness files and103old control/archive inputs remain exact.
The live game presentation edit is explicitly released and recorded separately.

## One failed control, five unrun cases

FIFO request`5c6fe3061222` checked out generation49 after fresh whole-host idle
inspection. The existing guard executed only `hudsmoke01/control` and stopped
when both UART capture lengths stayed unchanged for60host seconds. Session
duration was67.897host seconds, max63°C with the original95°C guard intact.
Both SDL drivers were dummy; actual initial boost1 was restored to1. These host
observations do not establish a guest timing rate or the precise duration/cause
of firmware silence.

The independent [failed-startup audit](FAILED-STARTUP-AUDIT.json) establishes:

1. The guest is the original accepted control binary. One exact native LOAD
   reply succeeds (token1,kind2,handle1). No Init, warm-render, timing-start or
   main-frame request occurs. Native backend error counters are zero.
2. The outgoing trace contains224,661host-enqueued bytes and all149,554bytes of
   the original assets stream. Artwork starts at absolute184,889 and contains
   an exact39,772/58,780-byte prefix;19,008artwork bytes are absent.
3. A structured parse skips five complete7854-byte original-player payloads,
   their bitmap registrations and the first256-byte recolor map. The captured
   prefix ends9/11bytes through buffered command72 at artwork offset39,763,
   destination64008/source64003/map63960. Its final two map-ID bytes (`d8f9`)
   are missing from the host-enqueued stream. This is a command-argument prefix,
   not the earlier prepared-image experiment's partial2048-byte pixel payload.
4. Host enqueue/accounting does not prove how much firmware consumed. The exact
   cause and expected quiet interval remain unqualified; this capture does not
   prove a common cause with another project or earlier upload stalls.
5. There is no guest result/state/timer file, verified cleanup or MOS return.
   Normal frontend exit0 and clean host teardown do not turn this into a guest
   success. No game FPS can be computed from backend scanout counters.
6. `hudsmoke01/cached`, both `hudab01` cases and both `hudba01` cases are **UNRUN**.
   No retry, input repair, limit relaxation or hidden replacement took place.

Raw files are under `evidence/hudsmoke01/control/`. The originally frozen
full-success `audit.py` remains unchanged and is not applicable to this failed
cohort. `failed_startup_audit.py` verifies the failure separately.

## Release and remaining work

Raw data was retrieved, fresh whole-host inspection was empty and the checkout
was explicitly released **before analysis**. [RELEASE.json](RELEASE.json) points
to the next reservation; [HANDOFF.json](HANDOFF.json) records an immediate prompt
to that verified-idle existing chat, starting it without an active-turn queue.
The API still lacks an explicit active-turn steering option; no queued route
was used. Oryx is no longer held by Rally.

HUD-001-01/02 implementation/offline verification are complete.03's target
comparison and04's target/human visual gate remain open. Resolve or narrowly
diagnose the original-art startup transport problem before another matched
performance tranche; preserve this witness. No further run or source repair is
part of the exhausted first-failure-stop tranche. A separate bounded follow-up
must retain identical startup treatment in both arms and stay outside their
timed race window.

The separate cached review profile remains stopped and **not cleared for human
review yet**, since the candidate has not passed a target smoke. All code,
findings, earlier research and failure evidence remain uncommitted. No cache
adoption, human/hardware approval, firmware/SDK change or publication is claimed.

Offline verification from the project root:

```sh
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/failed_startup_audit.py
git diff --check
```
