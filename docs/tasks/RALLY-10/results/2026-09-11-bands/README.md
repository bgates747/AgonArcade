# RALLY-10 precomputed band results

The candidate reduces measured band-construction cost on both tracks, with
about 25% less time for the complete controlled fixture. This trades 22,725 bytes
of tables and increased road-command volume for less eZ80 computation.

| Track | Greedy band stage | Table band stage | Mean 64-frame batch, greedy → table | Road bytes, greedy → table |
| --- | ---: | ---: | ---: | ---: |
| Tri-oval | 80.21 ms/frame | 36.46 ms/frame | 1,366 → 1,000 ticks (26.8% less) | 98,931 → 150,501 (+52.1%) |
| Fuji | 72.01 ms/frame | 28.39 ms/frame | 1,210 → 907 ticks (25.0% less) | 90,777 → 116,157 (+28.0%) |

## Measurement

1. Each track runs greedy/table/table/greedy using the same binary, full scene,
   fixed 64-pose fixture and post-swap stock poll. Two warm-up frames precede
   measurement. All 512 measured submissions received acknowledgments, with no
   timeouts or omitted records. Pose hashes match within each track; command
   bytes repeat exactly within each track/mode.
2. `bands` measures eZ80 selection/search, edge calculations and RAM stream
   construction. It does not measure VDP raster time. `geometry` still projects
   every row; the candidate also selects its precomputed list in this stage.
   Full-batch figures include the final drain and do not imply physical-display
   FPS. There is no elapsed-time physics in this fixture.
3. All eight runs used SDL dummy video/audio, software rendering and the
   canonical profile wrapper. Capture instrumentation was absent. The
   [manifest](manifest.json) records runtime/source hashes and host load;
   [per-run table](table.md) and adjacent CSVs retain the raw results.
4. The shared Mac's one-minute load varied from roughly 10 to 21. The final
   oval baseline is slower across several stages. Both table runs still beat
   both greedy runs on each track. The stage reduction is clear in these
   samples; the precise percentage should not be treated as a hardware promise.
5. More VDP commands are a real cost of these conservative boundaries.
   Physical hardware has not qualified the net result. A universal table with
   an enlarged command buffer was not timed; the current 4 KiB allocation is
   a software choice, not a hardware limit.

## Implementation and validation

The [frozen contract](../../band-boundaries-contract.md) and
[task document](../../../RALLY-10.md#precomputed-band-experiment) record the
checkpoint, scope, table construction and sampling details. The candidate keeps
the original projection and strip emitter, using a table for each 16-world-unit
track section and preserving material transitions and shared band endpoints.
The greedy implementation remains the default; `fixedbands` explicitly selects
the candidate.

Mac and Linux ASan/UBSan tests pass. Independent validation covered 334,053 views
with at most 0.449707 pixels of centreline error. Every table was checked against
all 202 distinct material patterns: maximum 32 emitted bands and 3,945 bytes,
within the existing 4,096-byte stream. The geometric coverage is sampled.
Regeneration reproduces the header byte-for-byte.

The binary is 129,831 bytes (23,070 bytes larger than the checkpoint), SHA-256
`5a6749f16ff6e7de9a17932771c8cf7454bdebf3c8bd117c5d3afb1c4477f684`.
Linux build evidence is retained at
`agon-linux:/home/smith/Agon/mystuff/rally-mac-build.I7gyHd`.

## Native visual review

Separate headless captures compare stationary views at oval position 4,000 and
Fuji position 4,800: [oval greedy](visuals/oval-greedy.png),
[oval table](visuals/oval-fixed.png), [Fuji greedy](visuals/fuji-greedy.png),
[Fuji table](visuals/fuji-fixed.png). Inspected road edges and markings remain
continuous. The 640×480 captures differ in 812 pixels on the oval and 184 on
Fuji, within the road region; they are not byte-identical raster outputs.
Still comparisons do not establish smoothness at every table boundary.

A separate moving candidate run captures [demo driving](visuals/demo.png),
[manual takeover with +12 steering after Right input](visuals/manual.png),
and [return to MOS after Escape](visuals/mos-exit.png). These captures are
functional evidence only and are excluded from the timings.

All five capture processes saved their expected four frames, then encountered
the already-known native Mac mutex exception on the harness's requested quit
(SIGABRT). In-game Escape reached MOS before that separate emulator shutdown.
Human driving/appearance review and physical-hardware performance remain pending.

## Reproduction

From the repository root:

```sh
make -C rally test
make -C rally
.venv/bin/python docs/tasks/RALLY-10/compare_bands.py
.venv/bin/python docs/tasks/RALLY-10/capture_bands.py
```

Timing and capture tools use separate headless profiles. Only after inspecting
those results, prepare and launch the human review profile:

```sh
.venv/bin/python rally/tools/prepare_emulator.py --fixed-bands --fence
./rally/run.sh
```
