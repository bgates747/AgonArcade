# Partial four-case comparison: control completed, cached startup stalled

The only completed control reports **60.00 nominal MOS FPS** (900 frames /
1,800 MOS units / nominal120 units per second =15.000 seconds). Its independent
nominal PRT stopwatch reports **35.09 FPS** (25,647 ticks / nominal1,000 Hz =
25.647 seconds). These clocks disagree by1.7098×; this is not a verified60FPS
physical or wall-clock rendering result. Every one of900 frame intervals is
exactly2 MOS units; PRT intervals vary24–41 ticks. Preserve both clocks without
calibration, correction, cherry-picking or historical-kernel pooling.

| Order / case | Outcome | Frames completed | Nominal MOS FPS | Nominal PRT FPS |
| --- | --- | --- | --- | --- |
|1 control1|PASS|900|60.00|35.09|
|2 cached1|Startup UART-progress guard|No timed run|—|—|
|3 cached2|UNRUN|—|—|—|
|4 control2|UNRUN|—|—|—|

There is no completed cached race, directional pair, within-role replication,
pooled comparison or HUD-cache gain measurement. REPORT.json retains the frozen
reporter's first output unchanged; its functional/clock gates establish recorded
intervals and accounting, not agreement between clocks or physical calibration.

## Completed control

All2,024 native requests/replies, exact independent final state/player/counters,
3,600 logical physics steps, two warm renders and900 completed render/swap fences
pass. Outgoing722,201 bytes exactly match the expected complete stream:426,498
prefix +291,568 timed +4,135 cleanup. Named setup401,782 bytes is included in
prefix. Stop/unload/timer restoration, normal exit to MOS and backend error gates
pass. Host Popen-through-stopped time35.536 seconds includes setup/teardown and
is not the timed race interval. INFO17 remaining task-stack watermark2260→1956B
is an observation, not eZ80 headroom. The observer finalized on shutdown with
zero samples because the process ended before the50-second trigger.

After release, the actual full auditor ran on a private copy of the control;
full-audit.json and verified.json reproduce byte-for-byte. No original witness
or frozen audit was edited. Final MOS PPM is retained; no moving race image or
Author visual acceptance is claimed.

## Cached startup failure and useful observer evidence

The original60-host-second unchanged UART guard stops the cached case before
Init/warm/race; its67.493-second process exits0 after host teardown but has no
result/state/timing/transcript or guest cleanup proof. Backend accounts241,988
outbound/342 inbound bytes, returned equals delivered, one exact LOAD reply
handle1, no Init or later native requests, no backend reported fault.

Complete original149,554-byte assets start at35,331; artwork starts184,885 and
contains57,103 of58,780 bytes, leaving1,677 absent. Parsing actual command
boundaries while skipping opaque declared payloads finds the trace ends in
buffer63800 command0:2048-byte declared payload,420 payload bytes captured,
1,628 absent. The command begins at absolute241,560 (art56,675);428 bytes
including its8-byte header are captured. Absolute setup offsets differ by4B
from the successful reference's preliminary poll traffic; they are derived
from exact assets/partial artwork, not assumed reference offsets. This is
host-enqueued traffic, not firmware-consumption evidence or a root cause.

The pinned observer reader accepts a complete timely three-sample window at
57.035927,57.285981,57.535980 host seconds. Each available sender snapshot says
returned_cts/false, completed_sends241988, pausedfalse. Publication, batches,
eZ80 cycles and VDP cycles/frames advance across samples. Final reason is
stasis_window_observed. These are direct snapshots; they establish neither
firmware PC/FIFO/IRQ state nor why CTS returns false. The record supplies a real
stalled-window witness, unlike earlier short successful startup/smoke runs.
No extension, retry, repair or additional process followed.

## Host context, limits and custody

Golem185 explicitly accepts current kernel7.1.5-76070105-generic and
boot9ba12fbc-c204-4332-9ff9-8bda03dfe2b2 for all four existing cases as a separate
postmaintenance cohort. CONTEXT185.md/CONTEXT-ADDENDUM.md in
execution-postkernel-20261101 preserve this exception, leaving71062298 unchanged.
All320 closure/88profile pins and absent outputs passed fresh admission. A single
bounded read-only CPU delta observed0.619 total cores of desktop activity across
24 online CPUs; no scientific/build job or emulator was present. This is a
boundary sample, not a promise of contention-free execution. Recorded boundary
kernel/boot/governor/affinity remain common. No host service/affinity/governor
was changed, and this agent ran no concurrent build.

FIFO request45f1f343e088 /checkout74 used fresh idle proof and original live
assertion before each of two processes. Both SDL drivers dummy/JIT, original
60s UART/95°C/287+10+3 guards and first-failure-stop were retained. Session
104.295 host seconds, maximum72°C. Initial boost1 temporarily became0 and was
restored1. All37 retrieved raw/result/metadata files hash-match Oryx, all320
closure/88profile pins remain exact. Fresh whole-host empty proof precedes
explicit release17:57:09EST; next_request:null. Golem received immediate chat
availability before offline analysis. No Oryx process/queue is held.

Original17-file deferral47b21acb and source71062298 freeze remain exact. New work
is uncommitted. This tranche is disposed as partial; no retry/extra process,
HUD adoption, hardware, human-review or publication release follows. Return the
new sender witness and clock discrepancy to Golem for bounded owner follow-up.
