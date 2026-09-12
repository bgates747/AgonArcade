# Headless timing

64 fixed poses per run, six opponents, two runs per track/variant. Batch time includes the final drain. Clock: 120 raw ticks/second.

| Track / renderer | FPS equivalent | ms/frame | 60 Hz budget | Over budget | Road bytes/frame | Sections/frame |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| oval / full | 7.71 | 129.69 | 7.78× | 113.02 ms | 2281.12 | 19.00 |
| oval / sections | 22.59 | 44.27 | 2.66× | 27.60 ms | 513.98 | 19.36 |
| fuji / full | 8.16 | 122.53 | 7.35× | 105.86 ms | 1762.64 | 14.56 |
| fuji / sections | 23.63 | 42.32 | 2.54× | 25.65 ms | 403.05 | 14.92 |

| Track / renderer | Fixture setup ms | Geometry ms | Command construction ms | Submission ms | Completion wait ms |
| --- | ---: | ---: | ---: | ---: | ---: |
| oval / full | 0.00 | 46.35 | 34.64 | 32.03 | 16.67 |
| oval / sections | 0.26 | 2.08 | 4.17 | 20.57 | 17.19 |
| fuji / full | 0.26 | 47.27 | 28.65 | 29.43 | 16.93 |
| fuji / sections | 0.65 | 1.82 | 3.52 | 18.36 | 17.97 |

The fixture excludes elapsed-time gameplay physics. Its `physics` column measures deterministic fixture setup. Submission includes scenery, road, traffic, HUD and swap calls, including any UART/VDP backpressure. Traffic centre projections occur there in the candidate. Completion wait is the stock post-swap poll; it is not an isolated measure of VDP raster time.

The unchanged scheduler permits a submission every four raw ticks (30 Hz maximum before workload delays). Two-tick clock resolution makes individual stages coarse. Stage sums omit scheduling gaps, final draining and untimed instrumentation overhead; complete batch time is authoritative.
