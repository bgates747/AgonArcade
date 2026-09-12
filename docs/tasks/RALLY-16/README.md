# Unpaced rendering with normal eZ80 throttling

Execution scope: [RALLY-16](../RALLY-16.md), based on committed checkpoint
`4ca24dc`. Mainline and earlier experiments remain unchanged.

The batch hot loop has no deadline, clock read, explicit sleep, per-frame
completion poll, stage logging or elapsed-time physics. Each iteration selects
one of the same 64 deterministic camera/traffic poses, renders the complete
scene and swaps buffers. Device/UART backpressure and the VDP's own swap
behavior remain. The emulator uses its normal 18.432 MHz CPU throttle; no
unlimited flag or CPU clock override is supplied.

There are three builds: the mainline full road with precomputed bands,
pavement-only, and the RALLY-15 resident-section renderer. Artwork, six traffic
cars, player view, scenery and fixture HUD remain. The benchmark does not
sample keyboard input or run gameplay physics. This is a rendering-throughput
experiment, not an interactive game or a new physics timebase.

## Measurement

Uploads and two warm-up frames complete before measurement. Three clock reads
surround the whole batch: start, submission end and final completion. A single
post-batch stock poll drains the queued work. Completed-batch FPS includes this
drain; separately reported submission throughput is not presented as finished
frames. There are no clock reads or completion polls inside `renderPose()` or
the measured frame loop. Counters/hash accumulation verify the workload.

Run full/pavement/sections/sections/pavement/full for each track, headlessly and
serially. Check 64 submitted frames, 384 traffic draws, matching historical
pose hash/road bytes, successful final acknowledgement and the live process's
absence of unlimited CPU flags. Framebuffer/display presentation rate and
actual VDP raster cost are not isolated by these batch timings.

## Files and reproduction

`batch.cpp.inc` owns the new batch loop. `experiment.py` constructs an isolated
`main.cpp` from the committed game's existing startup/draw helpers and that
loop. Source substitution checks reject pacing/timing calls in the hot path.
Copies of the unchanged pavement/section headers and focused tests live here;
the section headers retain their original generator provenance in RALLY-15.
Builds, native executables and profiles are ignored under `.work/` and
`.emulator/`. Original game files and its binary are fingerprinted throughout.

From the repository root:

```sh
.venv/bin/python docs/tasks/RALLY-16/experiment.py build
.venv/bin/python docs/tasks/RALLY-16/experiment.py bench
.venv/bin/python docs/tasks/RALLY-16/summarize.py
```

Linux builds use fresh scratch directories through the existing build helper,
without modifying the cleaned Linux project checkout. Existing sanitizer tests
run for every variant, with the matching focused pavement/section test added.
Raw reports, binary/firmware/process identities and build logs are retained in
`results/`. Historical report dependencies are used only to verify matching
poses and command counts, not to supply new timing numbers.
