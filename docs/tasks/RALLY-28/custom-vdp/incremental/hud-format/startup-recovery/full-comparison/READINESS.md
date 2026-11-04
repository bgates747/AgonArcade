# Four stopped900-frame ABBA profiles — technical preparation only

No new emulator or performance result. Golem136 requests preparation only and
Golem137 corrects its earlier independent smoke-audit invocation chronology;
the actual corrected audit reproduces both accepted smoke results. No smoke
rerun occurred or is needed. `ROOT-AUDIT-CORRECTION.md` preserves that correction.

Oryx profile directory prefix:
`/home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-hud900abba01-`

| Order | Suffix | Role | Completed frames / physics / warm renders |
| --- | --- | --- | --- |
|1|`control1`|Control685f4b4c|900 /3600 /2|
|2|`cached1`|Cachedc6d75022|900 /3600 /2|
|3|`cached2`|Cachedc6d75022|900 /3600 /2|
|4|`control2`|Control685f4b4c|900 /3600 /2|

Exactly FOUR prospective processes, not four pairs. Each is fresh/stopped with
its own history/output. Both roles retain common7e7d/200f/8da2/MOS/ELF/native479/
art/scene/input/motion/warm/framecount/physics/pacing/power/observer. Only the
declared HUD guest/expected metadata and necessary paths differ. Both SDL dummy/
JIT and enabled fixed observer/reader12817411. No source or guest rebuild.

## Reference and wire predictions

Actual checked-C ordinary and ASan/UBSan references agree for3600 independent
ticks,900 regenerated motion rows and complete final root/arrays, with balanced
leases/canaries. Generation4503/request902/world3600/player1179600/phase400.
Existing unchanged actual HUD function byte/page checks retain their scope.
The entire2024-request/reply schedule matches a qualified saved900-frame control.

| Wire phase per case | Bytes | Accounting |
| --- | --- | --- |
|Named installed setup streams|401,782|Included in prefix, not added twice|
|Complete untimed prefix|426,498|After boot/setup/warm through initial INFO17|
|Timed900-frame stream|291,568|Expected delta0 across all four cases|
|Untimed suffix|4,135|Final readback/stop/unload/MOS completion|
|Complete outgoing reference|722,201|Prefix+timed+suffix|

All three complete command-stream sections are frozen and checked. The setup
prefix also matches both actual new-runtime smoke captures byte-for-byte. Named
setup streams include34,850module/1,080common/91,866native/149,554assets/58,780
artwork/65,652presentation bytes, each once before timing. Original eZ80 guest
file sizes40,789control/41,324cached and other SD-file sizes are separate from
UART traffic. Host trace is sender enqueue, not a consumption clock.

Primary guest interval starts after installation/two warm frames/INFO17 and ends
after frame900's post-swap generation fence. All input/physics/presentation/wire/
native/swap work is included, original setup and final cleanup excluded. No
foreground pacing; required completion/swap semantics identical. Four logical
physics steps per frame do not establish autonomous120Hz or player headroom.

## Reporting, gates and quiet host

`report.py` reports per-case900 completed frames, actual elapsed MOS units,
nominal units/120seconds and FPS first. PRT elapsed ticks/nominal1000Hz stopwatch
remain separate. Host monotonic process seconds include setup/teardown and are
not aligned race time. Both directional pairs and within-role variation accompany
pooled1800frames/combined seconds per role. A concrete device-free arithmetic
check distinguishes this from averaging FPS. Partial cohorts retain failed/unrun
labels and make no balanced-gain claim. No old-host data is pooled.

Each stopped process passes full raw/state/player/clocks/command streams/native
acknowledgments/observer-finalization/MOS/backend gate before any successor. All
deterministic native values match the first control; permitted runtime INFO
watermarks remain explicit observations, not stack bounds. Final MOS PPMs are
retained without race-pixel or Author visual claims. First unexpected failure
stops all later cases, no retry/replacement/fifth process or extra campaign.

Original60s UART/95°C guards,287s work+10s normal quit+3s forced wait <=300s per
process, initial boost restoration and owned teardown remain. Reader0 means
finalized schema only; missing/late/null/resumed windows remain explicit and
do not extend guards. Observer configuration stays50s/100ms/0,250,500/630s/
5lines/4attempts in all profiles. Anticipated occupancy3–5minutes is an estimate,
not a limit change. Keep6502 priority and normal FIFO; no reservation during prep.

Before execution inspect read-only `conditions.py` preflight for known competing
heavy work and fresh whole-host emulator occupancy. Defer before starting if
the host is knowingly busy, rather than altering services/affinity/governors or
polling until a convenient score. Boundary conditions record load/boost/boot/
CPU configuration/top20 processes (lifetime-average `%CPU`, not instantaneous
contention); existing supervisor samples thermal/load during the cohort. The
preparation sample is not admission for a later run. This agent runs no concurrent
builds. Preserve unexpected contention/interruption and report its limits.

## Prepared commands — not executed

Only after separate technical selection and fresh shared FIFO/idle/checkout:

```bash
cd /home/smith/Agon/mystuff/AgonArcade
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/startup-recovery/full-comparison/conditions.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/startup-recovery/full-comparison/runner.py --lease CHECKED_OUT_RALLY_LEASE
```

The runner uses the real canonical profile wrapper and live ownership assertion
before EACH process. Retrieve/hash all artifacts/condition/observer/result/state/
clock/reply/PPM/session receipts, stop owned children, take fresh whole-host idle,
release and immediately notify the next existing chat before lengthy analysis.
Then repeat raw audits against fresh capture copies using the explicit CLI
`audit.py COPY_OF_CASE` and run `report.py` on the retrieved cohort. Preserve its
first report; no silent replacements. No GUI/hardware/default/publication follows;
the Author moving visual gate remains open. Return new work uncommitted.
