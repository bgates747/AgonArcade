# Exact Rally affine workload

`workload.py` interprets the preserved full-race baseline's `artwork.vdu`, then
executes its actual generated `native.c` and unchanged renderer helper in a
private host library. It replays the same two unmeasured warm renders, 3,600
native physics calls and 900 measured renders as the accepted full-race fixture.
The 24-byte-per-frame `motion.bin` positions are independently regenerated and
checked before replay. Each native tick is checked against the independent
world/contact model; the complete final root and five mutable arrays match the
frozen full-race reference exactly. The old source, artwork and fixture files
remain unchanged.

`WORKLOAD.json` pins all source/installation inputs, the recovered artwork and
`OBSERVED-DRAWS.jsonl`. Each trace row is one actual emitted bitmap draw,
including its bitmap ID, source dimensions, affine selector, Q8 forward matrix,
placement and active inclusive clipping rectangle. The matrix layout is
`[xx, xy, tx, yx, yy, ty]`, each coefficient divided by 256. Selector 65535 means
ordinary bitmap plotting with affine disabled; its trace matrix is identity for
convenience and does not imply a matrix command was sent.

| Measured workload | Draws | Bitmaps observed | Q8 scales | Reflected draws |
|---|---:|---:|---:|---:|
| Traffic | 4,158 | all 30 | 62 values, 14–246 | 1,656 |
| Signs | 709 | all 8 | 52 values, 32–136 | 0 |
| Player | 900 | player view 0 | fixed 256 | 0 |

The trace contains 5,767 measured draws plus eight draws from the two warm
renders. It retains their original order rather than treating the 2,737 unique
measured combinations as equally frequent. Counts are calls emitted by the
baseline, including partly clipped calls, not the number of opaque pixels drawn.

The 43 original bitmaps are raw one-byte RGBA2222 images under `assets/`:
five 102×77 player views, thirty 102×77 traffic views and eight 64×64 signs.
Their 307,658 pixels comprise 205,100 fully transparent and 102,558 fully opaque
pixels. The original artwork has no alpha-1 or alpha-2 pixels. Tests of those
intermediate alpha values therefore require separate synthetic coverage.
No original scaled artwork files were created or loaded.

`target_cases` provides a finite convenient subset: observed far/middle/near
traffic and sign cases, the ordinary fixed player, and explicitly marked
synthetic full-size, reflection and clipping cases. The largest observed sign
case is partially clipped at the left edge; this is part of its real placement,
not a representative fully visible sign. The forced player mirror is synthetic
because the deterministic replay never selects it. Its reflection is the actual
`x' = -x + 101` matrix, with the renderer's one-pixel placement adjustment to
preserve its ground anchor. Synthetic cases carry no observed frame number.

This host execution recovers commands and verifies inputs. Its duration is not
a benchmark of the host scaler, emulated VDP or physical ESP32. The companion
affine harness owns those separate measurements. Existing accepted full-race
renderers, firmware, qualified fixtures and benchmark results are preserved.

Recreate and verify the extraction on the Pi5 from the repository root:

```sh
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/workload.py
```

The tool refuses to overwrite differing completed artifacts. No emulator or
network operation is involved.
