# RALLY-18 measured results

Checkpoint: **182a1d0**. Current code is isolated under RALLY-18; the subsequent review checkpoint is recorded in ../FREEZE.md.

Normal 18.432 MHz eZ80 and unchanged UART timing. Computation/wire figures use stock-debugger instruction-cycle deltas; completed rendering uses an unpaused batch plus a final stock VDP completion poll. Two runs per case, in alternating comparison order.

| Track | Variant | Computation ms / FPS equivalent | With commands + UART ms / FPS equivalent | Completed stock-VDP ms / FPS |
|---|---|---:|---:|---:|
| oval | live | 19.33 / 51.73 | 31.43 / 31.81 | 34.51 / 28.98 |
| oval | lookup | 14.93 / 67.00 | 27.01 / 37.03 | 33.98 / 29.43 |
| oval | lookup + perspective | 15.36 / 65.10 | 27.45 / 36.43 | 34.24 / 29.20 |
| fuji | live | 17.43 / 57.38 | 27.68 / 36.13 | 36.59 / 27.33 |
| fuji | lookup | 14.01 / 71.37 | 24.26 / 41.21 | 35.03 / 28.55 |
| fuji | lookup + perspective | 14.45 / 69.22 | 24.69 / 40.50 | 34.51 / 28.98 |

The candidate computation path fits the 16.67 ms / 60 FPS budget. The complete command/transmission workload still exceeds it. Native VDP completion is separately affected by the stock two-vblank swap behavior and host scheduling; do not interpret it as physical-hardware timing.

| Track | Lookup computation saving | Lookup wire-workload saving | Perspective cost (compute / wire) | Wire workload budget / excess |
|---|---:|---:|---:|---:|
| oval | 22.8% | 14.1% | 0.44 / 0.44 ms | 1.62× / +10.34 ms |
| fuji | 19.6% | 12.3% | 0.44 / 0.42 ms | 1.46× / +7.60 ms |

The following budget table uses exactly 1000/60 ms. Negative excess means time remains. Percentage savings compare each mode with its matching live centreline control; display differences are observations of this native run, not isolated CPU savings.

| Track | Variant | Mode | Time saved vs live | Budget multiple | Excess ms | Two-run range ms |
|---|---|---|---:|---:|---:|---:|
| oval | live | compute | 0.0% | 1.16× | +2.67 | 19.33..19.33 |
| oval | live | wire | 0.0% | 1.89× | +14.77 | 31.40..31.46 |
| oval | live | display | 0.0% | 2.07× | +17.84 | 33.85..35.16 |
| oval | lookup | compute | 22.8% | 0.90× | -1.74 | 14.93..14.93 |
| oval | lookup | wire | 14.1% | 1.62× | +10.34 | 27.00..27.01 |
| oval | lookup | display | 1.5% | 2.04× | +17.32 | 33.59..34.38 |
| oval | lookup + perspective | compute | 20.5% | 0.92× | -1.30 | 15.36..15.36 |
| oval | lookup + perspective | wire | 12.7% | 1.65× | +10.78 | 27.44..27.45 |
| oval | lookup + perspective | display | 0.8% | 2.05× | +17.58 | 33.59..34.90 |
| fuji | live | compute | 0.0% | 1.05× | +0.76 | 17.43..17.43 |
| fuji | live | wire | 0.0% | 1.66× | +11.01 | 27.68..27.68 |
| fuji | live | display | 0.0% | 2.20× | +19.92 | 33.59..39.58 |
| fuji | lookup | compute | 19.6% | 0.84× | -2.65 | 14.01..14.01 |
| fuji | lookup | wire | 12.3% | 1.46× | +7.60 | 24.25..24.28 |
| fuji | lookup | display | 4.3% | 2.10× | +18.36 | 33.33..36.72 |
| fuji | lookup + perspective | compute | 17.1% | 0.87× | -2.22 | 14.45..14.45 |
| fuji | lookup + perspective | wire | 10.8% | 1.48× | +8.02 | 24.68..24.69 |
| fuji | lookup + perspective | display | 5.7% | 2.07× | +17.84 | 33.85..35.16 |

| Track | Variant | Total / road bytes per frame | Total / road bytes/s at wire throughput | Total / road KiB/s at 60 FPS | Average sections |
|---|---|---:|---:|---:|---:|
| oval | live | 889.66 / 514.38 | 28304 / 16365 | 52.13 / 30.14 | 19.38 |
| oval | lookup | 889.66 / 514.38 | 32940 / 19045 | 52.13 / 30.14 | 19.38 |
| oval | lookup + perspective | 889.66 / 514.38 | 32412 / 18740 | 52.13 / 30.14 | 19.38 |
| fuji | live | 770.91 / 402.27 | 27853 / 14534 | 45.17 / 23.57 | 14.89 |
| fuji | lookup | 770.91 / 402.27 | 31772 / 16579 | 45.17 / 23.57 | 14.89 |
| fuji | lookup + perspective | 770.91 / 402.27 | 31225 / 16294 | 45.17 / 23.57 | 14.89 |

Precomputation leaves the initial 25-byte resident-section protocol intact. Vehicle-angle correction changes command values/mirror use, not the protocol. Its measured UART delta is zero bytes/frame on both tracks (64-frame totals remain 56,938 oval and 49,338 Fuji). All compute cases recorded zero UART bytes. All cases completed their final poll; repeated identical cases matched byte count/hash and pose metadata.

Early completed-render cases in the primary manifest ran while exhaustive geometry validation and host indexing were active, with substantial load/variance. They are retained but are superseded here by the explicit display-only rerun after numerical validation finished. All original data remains linked below; no CPU-cycle cases were replaced.

Primary evidence: [bench-ui1ehkre/manifest.json](bench-ui1ehkre/manifest.json). Display rerun: [bench-lttycqb0/manifest.json](bench-lttycqb0/manifest.json).

See [road qualification](../road-results/README.md) for exhaustive geometry/loader/sanitizer coverage, [vehicle notes](../vehicle-notes.md) for placement/orientation checks, and [native visual results](../visual-results/README.md) for images, guest-state agreement and scripted input evidence. Human visual acceptance and hardware qualification remain separate.
