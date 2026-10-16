# Olimex suite return — all ten cases pass

The physical Olimex completed all ten cases, including all four128frame drawing runs that stalled under Flexe. Every frozen input matches the deployment, every case reports successful cleanup, and all420actual-physics state fields match the independent reference. This bitmap implementation is substantially slower than on-demand buffered polygons on the real VDP. No game/backend adoption or integrated physics cadence follows automatically.

The Author returned the mainboard SD to Oryx. Collection was read-only from UUID746D-53DB into [evidence/hardware01](evidence/hardware01/). [Return manifest](evidence/hardware01/RETURN-MANIFEST.json) pins all96returned files, sizes and source timestamps. All43deployed files and root startup SHA91428508…remain unchanged. The [flash receipt](MAINBOARD-FLASH.json) identifies the previously installed exact diagnostic image36edc736… . No new device invocation, reset, flash, SD write or emulator launch occurred during collection.

## Completed road work and local VDP timing

| Candidate | Frames | Active frame throughput, nominal PRT FPS | VDP complete mean ms | VDP complete p95 ms | Full diagnostic-window FPS |
| --- | ---: | ---: | ---: | ---: | ---: |
| On-demand buffered polygons | 128 | **9.761** | **70.883** | 104.897 | 7.588 |
| Redundant all-row polygon control | 128 | 8.455 | 67.525 | 102.307 | 6.776 |
| Bitmap, original phase arithmetic | 128 | 2.613 | 336.823 | 337.210 | 2.428 |
| Bitmap, phase lookup | 128 | **2.614** | **340.984** | 341.479 | 2.429 |

Active throughput divides128frames by the summed per-frame PRT geometry, packing, synchronous submission and completion-wait intervals. These are sequential one-frame-outstanding workload intervals, not a claim of an autonomous uninterrupted game loop. It excludes stopped-record readout. Full diagnostic-window rates use the entire PRT capture, including that readout: sparse polygons16.868seconds; lookup bitmaps52.707seconds. The ordinary marker/fence instrumentation inside each frame remains included; there is no subtraction of empty controls or overlapping processor intervals.

On-demand polygons complete the active frame workload about**3.73times**as fast as lookup bitmaps. The local VDP elapsed interval is about4.81times shorter. VDP intervals include resident command interpretation, copies, transforms/drawing, queue/worker scheduling and final completion; they are not exclusive raster CPU or scanout time. The common/sparse polygon controls emit the same polygon commands but have different CPU pacing/worker phase; their VDP means must not be interpreted as a proved rendering penalty caused by sparse geometry.

| Per-frame nominal PRT ms | Geometry | Packing | Submission | Completion wait |
| --- | ---: | ---: | ---: | ---: |
| On-demand polygons | 5.594 | 17.023 | 8.391 | 71.445 |
| Lookup bitmaps | 25.336 | 3.023 | 9.406 | 344.758 |

The phase table substantially helps CPU packing but does not overcome this VDP cost. Original/lookup bitmap active throughput is effectively the same in this single comparison; the small VDP-clock difference is not evidence that the arithmetic itself makes VDP rendering faster. The empty32frame control completes, with local VDP mean13.757ms; it remains an observed control rather than a constant overhead to subtract.

## Actual physics and CPU capacity

Actual numerical physics completes8,192ticks/four scenarios in24,460nominal PRT milliseconds, **334.91ticks/s**. All420state fields verify independently, with no duplicate/missing state keys, vector_restored=1and lifecycle restored=1. MOS2940units at nominal120Hz gives24.500seconds,334.37ticks/s. These clocks agree within0.164%; no external host-wall calibration was collected on the physical board. The numerical timestep remains the old workload's timestep; no new120Hz pacing is selected.

| CPU-only candidate | Frames | Nominal PRT ms/frame | Earlier Fab host-wall ms/frame |
| --- | ---: | ---: | ---: |
| On-demand polygons | 1024 | 22.851 | 22.830 |
| Redundant all-row polygon control | 1024 | 42.052 | 41.994 |
| Bitmap arithmetic | 1024 | 32.795 | 32.753 |
| Bitmap lookup | 1024 | 28.476 | 28.437 |

Hardware PRT CPU measurements are within0.14%of the preserved Fab host-wall CPU cases; physics capacity is likewise within0.15%of the latest335.41tick/s isolated emulator result. This supports the Author's observation that the eZ80 core is a useful approximation here. It does not qualify the Fab native host VDP as representative of the real ESP32: its earlier31.98/27.74road FPS controls used a different native renderer/stock-completion configuration and512frames.

Prior full128frame Flexe diagnostic comparisons did not finish, so there is no qualified sustained Flexe-versus-hardware FPS ratio. Earlier short16pose Flexe VDP intervals covered an opening section, whereas these128poses span Fuji/offsets. Do not compare those means as if the workload coverage were equal. Physical completion rules out a universal deterministic deadlock of these fixture bytes; it does not by itself identify the emulator transfer fault.

## Verification and scope

[analyze_hardware.py](analyze_hardware.py), run with repository `.venv/bin/python`, reproduces [HARDWARE-RESULTS.json](HARDWARE-RESULTS.json) without network or hardware operations. It verifies returned-file hashes against the card snapshot, all deployed/input identities, full frame indices/counts, configuration identities, cleanup/failure fields, VDP submit+drain=complete for every diagnostic record, expected record-query byte accounting and independent physics state. Nine road/CPU cases contain4,640total frame records. Root startup and all frozen package files are preserved; card results remain in place.

PRT1000Hz and MOS120Hz scales remain nominal. Raw counters, per-frame distributions, byte totals and phase CSVs are retained. These are road-only cases plus a separately isolated numerical physics workload. They do not include a simultaneous real-time player/physics/render scheduler, traffic/scenery/HUD/audio, full-game FPS or human motion acceptance. The Pi result-gated live coordinator is still unqualified; the Author used the explicit MOS suite. New results/docs remain uncommitted for review.
