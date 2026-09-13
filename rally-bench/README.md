# Rally bench experiment

Isolated BENCH-001 derivative of rally-production, reusing its accepted artwork,
road geometry and manual physics. The production directory remains unchanged.

Build: `make -C rally-bench` from the repository root, with agondev-config on PATH.
Run from a directory containing rally.bin and the selected oval.road/fuji.road:

```
LOAD rally.bin
RUN . oval race telemetry engine grip200
```

Existing options: oval/fuji, demo/race, autosteer, perspective. New bench options:
telemetry enables the optional resident EMOS gateway; engine enables the sine
sound; mute disables it (default); grip200 starts at the Author-requested 200%
grip, still adjustable with -=. Left/right and up/down retain normal steering
and throttle/brake; Escape quits. Telemetry requires the explicitly selected
EMOS BENCH-001 composition and the matching P4 telemetry endpoint. It is never
sent to the onboard VDP. Without telemetry the game runs on ordinary MOS.

The external driver must use race without autosteer. The app publishes copied
state and geometry; it does not accept direct state changes. Engine pitch is
80–680 Hz over speed 0–300, in four-Hz steps, at channel volume 40/127. Channel
0 is enabled/reset when audio starts and silenced on ordinary exit. This is a
speed tone, without RPM/gearing. Early/error exits before audio starts are silent.

Telemetry and host tools are owned by agon-extender/scripts/rally_drive.py and
its BENCH-001 contract; EMOS implementation is owned by agon-emos. Neither
hardware validation nor a production release is implied by successful host or
emulator tests. Human emulator review and commit approval remain outstanding.

The current experiment publishes snapshot v2 (140 bytes), requiring matching
EMOS v0.1.16 bench-telemetry and Extender console r17 or their explicitly
compatible successors. It reports all six opponents, including those outside
the drawn range. Traffic overlaps are measured every physics tick using the
documented conservative footprint; no collision response is added to gameplay.
This is telemetry-driven passing, not camera vision.

The Extender host's `scripts/rally_trial.py` wraps each driving test with a
fresh manual race at 200% grip, then holds Escape and confirms telemetry stops.
It respects physical keyboard takeover. `scripts/rally_drive.py` plans passing
lanes/speeds with a maximum of 300 and records raw snapshots, requested controls,
passes and contacts. Historical instrumented rates are not production FPS.

The Author requested no change to the speed tone after hearing it. Future
attention cues use an emulator startup beep. Opponent-to-opponent avoidance by
offline Python-generated move tables belongs to deferred RALLY-21; the current
traffic remains unchanged for this experiment.

Steering comparison: `steer1`, `steer2` or historical `steer3` selects the number
of angle ticks applied once per rendered frame while a direction key is held.
The new candidate defaults to two. This changes response rate, preserving the
+/-21 range and the five artwork views/reflections. Snapshot byte78 reports the
actual step; the host controller uses it, including odd/even reachable angles
with step2. This is independent of operating-system keyboard repeat.
The Author requested one first, then two, on hardware. Passing on either side
outranks centre-line preference; the host returns to centre when safe progress
is otherwise equal. Firmware transport and accepted production files are unchanged.
