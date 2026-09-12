# RALLY-17 results

Normal 18.432 MHz eZ80 execution; unchanged UART FIFO and baud timing.
The sink discards bytes only at the VDP receive boundary and keeps CTS ready.
Each cycle includes fixed-pose setup, one physics update, traffic update, complete scene command generation, transmission and fixture bookkeeping. These are **cycles per second, not displayed FPS**.

Primary measurements use the stock emulator debugger cycle counter between existing batch boundary instructions. The 64-cycle batch ends after UART TEMT. No per-frame pacing or completion waits. Breakpoint pause time is excluded from cycle counts; debugger-run MOS wall ticks are not used.

| Renderer | Track | ms/cycle (two sink runs) | Cycles/s | 60 Hz budget used |
|---|---|---:|---:|---:|
| full | oval | 119.01, 119.32 | 8.39 | 7.15× |
| full | fuji | 105.02, 105.07 | 9.52 | 6.30× |
| pavement | oval | 70.55, 70.56 | 14.17 | 4.23× |
| pavement | fuji | 66.41, 66.40 | 15.06 | 3.98× |
| sections | oval | 32.08, 32.11 | 31.16 | 1.93× |
| sections | fuji | 27.92, 27.95 | 35.80 | 1.68× |

All three runs per renderer/track (one passthrough, two sink) matched transmitted byte count and FNV-1a64 hash, road bytes, cars and post-physics pose hash. Every final stock poll completed. All runs were headless, with no unlimited CPU flag. Mainline fingerprints passed before and after. Linux scratch builds passed the existing sanitizer tests and applicable renderer tests. Proxy unit checks cover CTS, exact accounting and delivery restoration; the canonical launcher rejected a missing module without fallback.

Unpaused wall-clock runs are retained in ../results; their variance motivated instruction-cycle measurement. CPU cycles still include MOS interrupt service and UART transmission waits. This establishes CPU-plus-wire cost with an uncongested receiver, not pure arithmetic cost, physical-hardware FPS or VDP rendering performance. Passthrough results retain host VDP behavior/backpressure and are primarily an equal-output control.

No game or upstream emulator changes were made. All implementation, profiles and evidence are inside this task bucket. Nothing has been committed.
