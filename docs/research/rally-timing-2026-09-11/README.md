# RALLY-10 iteration 1: stock poll fence and Mac timing

The user confirmed Rally's clock is 120 ticks/second and authorized iterative
performance work with graphical emulator reviews. The existing one-physics-step
per raw tick and three steering units per rendered update remain unchanged.
The stock fence is opt-in (`run . fence`); normal launch remains the baseline.

## Implementation and qualifications

1. `PollFence` sends `23,0,0x80,token` after the existing swap, alternating
   0x5A/0xA5 with only one request outstanding. Its initial token differs from
   the current GP mailbox. MOS 3.0.2 stores the reply at sysvar offset 0x37;
   no keyboard vector or custom firmware is used. After a five-second reply
   timeout the experiment stops and does not reuse the undrained token.
   The timeout cannot interrupt a blocked `mos_puts` call.
2. The native clock reader requires two matching volatile 32-bit reads to
   reject a counter rollover between eZ80 component loads. Deadline/elapsed
   arithmetic uses unsigned 32-bit subtraction. No `/100` motion coefficients
   were rescaled. Physics catch-up remains unbounded for this iteration.
3. Timed runs fence startup uploads and exclude that wait from the sample.
   A 20-second guest-clock sample records at most 1,024 rows in memory, then
   writes its CSV after returning to mode 0. The baseline drains its final
   commands before writing; that drain is separate from the sample duration.
4. Recorded intervals, control/physics, road projection, drawing submission,
   and fence waits are raw ticks. Submission includes CPU preparation of
   scenery/traffic/HUD commands plus UART/backpressure; it is not isolated
   VDP raster time. The counter changes in twos, so resolution is about 16.7 ms.
   Road bytes exclude other commands. Omitted samples are explicitly counted.
5. Host tests cover stale mailbox values, hundreds of alternating replies,
   delayed responses, missing responses, terminal timeout and 32-bit wrap.
   Mac and Linux ASan/UBSan suites and the native Linux build pass. Candidate
   is 103,841 bytes, built from the Mac source via the isolated Linux helper.

## Source basis

Official Fab 1.2.4, MOS 3.0.2, stock platform VDP. The Mac runtime uses:

1. `vdp-console8` revision `7bcf28e0a2376e32328a6a5554d0df852b75c80e`,
   `video/vdu_sys.h` (`sendGeneralPoll`, swap dispatch), `video/agon_screen.h`
   (`switchBuffer`). Processing is serial: swap completes before the poll.
2. `userspace-vdp-gl` revision `2c12e77a0d00f8989c884525479ee6d37340751a`,
   `src/canvas.cpp` (`Canvas::swapBuffers`) and `src/displaycontroller.cpp`.
   The native emulator executes primitives immediately in `addPrimitive`;
   `primitivesExecutionWait` waits for its VBlank signal. This differs from
   hardware primitive queuing. A GP reply does not count a unique SDL display
   or establish physical monitor presentation.
3. Official MOS v3.0.2 `src/vdp_protocol.asm`, `vdp_protocol_GP`, copies packet
   data into `_gp`; `src/mos_api.inc` defines sysvar offset 0x37.

The experiment qualifies working token exchange after stock swaps on this
emulator. Source ordering supports the completion interpretation; hardware
ordering, latency and performance still require direct qualification.

## Measurements

Four serial headless native Mac runs used the full-scene tri-oval demo from
its normal starting state. No input injection, capture interposer or per-frame
logging ran during these timing samples. Runs 1–2 used baseline/fence order;
runs 3–4 reversed it. This shared Intel Mac had variable background load.
Different frame intervals also change demo steering/control cadence, so the
resulting trajectories and workloads are not frame-identical replays.

| Run | Mode | Submitted | Per-frame replies | Guest ticks | Mean interval | Maximum interval |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| [1](01-free.csv) | Baseline | 69 | — | 2424 | 35.03 | 82 |
| [2](02-fence.csv) | Fence | 101 | 101 | 2400 | 23.70 | 68 |
| [3](03-fence.csv) | Fence | 100 | 100 | 2412 | 24.10 | 70 |
| [4](04-free.csv) | Baseline | 111 | — | 2404 | 21.64 | 36 |

All runs reported zero timeouts and zero omitted samples. Mean intervals
exclude the first zero interval. The fenced runs acknowledged all 201 submitted
frames; the baseline intentionally does not request per-frame replies.
The initial apparent throughput gain did not survive the reversed comparison.
**No consistent speed or latency improvement is established.**

Mean stage ticks for the steadier reverse-order pair:

| Stage | Fence (run 3) | Baseline (run 4) |
| --- | ---: | ---: |
| Control/physics | 4.66 | 4.94 |
| Road projection | 14.66 | 14.32 |
| Drawing submission | 2.78 | 2.38 |
| Post-swap wait | 2.02 | 0.00 |

Road projection dominates these Mac samples (about 119–122 ms per submitted
frame at 120 ticks/second). That measures the emulated eZ80 path under this host's
scheduling, not hardware CPU duration. The reply wait is usually two ticks,
occasionally four. Baseline end-drain was two ticks in both runs; that alone
does not rule out transient queuing earlier in the run.

## Review and continuation

The graphical review candidate uses `run . oval fence`. No pacing fix is
accepted yet and no physical card has been written. Changes remain uncommitted
until human validation and explicit commit approval.

Separate native captures (excluded from timings) show the fenced tri-oval and
Fuji scenes, plus any-key takeover, manual HUD and Escape return to MOS on the
tri-oval. They do not establish constant-rate presentation or human control feel.
Both capture processes reproduced the known Mac mutex exception on requested
shutdown; this is recorded separately from in-game fence behavior.

The next decision under root TODO's RALLY-10 is whether to subdivide the road
projection work and compare its cost with earlier milestones, then investigate
repeated track interpolation or other CPU costs. Scenery/traffic/mirror A/B
cases and hardware testing remain relevant; the present measurements do not
justify committing to an asynchronous scheduler or blaming VDP transforms alone.
