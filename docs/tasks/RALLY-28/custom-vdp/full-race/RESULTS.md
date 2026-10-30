# Full-race renderer comparison

Every renderer runs the same race presentation: scrolling panorama, approaching/receding traffic, road/signs/player/finish, HUD/footer and engine commands. These fresh results judge complete-race workload performance; historical flat-background gains remain separate.

| Variant | Forward MOS FPS | Reverse MOS FPS | Pooled MOS FPS | Pooled PRT FPS | MOS vs baseline |
| --- | ---: | ---: | ---: | ---: | ---: |
| baseline | 14.44 | 14.46 | 14.45 | 13.96 | +0.00% |
| float-tri-layered | 14.37 | 14.59 | 14.48 | 13.99 | +0.20% |
| integer-tri-layered | 14.37 | 14.71 | 14.54 | 14.05 | +0.63% |
| float-quad-layered | 15.82 | 15.67 | 15.75 | 15.21 | +8.97% |
| integer-quad-layered | 15.42 | 15.33 | 15.37 | 14.85 | +6.39% |
| float-tri-strips | 10.63 | 10.63 | 10.63 | 10.27 | -26.44% |
| integer-tri-strips | 10.50 | 10.02 | 10.26 | 9.91 | -29.02% |
| float-quad-strips | 11.66 | 11.44 | 11.55 | 11.15 | -20.09% |
| integer-quad-strips | 11.88 | 11.34 | 11.60 | 11.21 | -19.70% |
| integer-quad-segments | 9.39 | 9.35 | 9.37 | 9.05 | -35.15% |
| float-quad-segments | 13.24 | 12.57 | 12.90 | 12.46 | -10.75% |
| span-rgba | 20.76 | 21.23 | 21.00 | 20.29 | +45.30% |
| span-native | 26.20 | 24.62 | 25.39 | 24.53 | +75.69% |
| split-clear | 26.24 | 25.92 | 26.08 | 25.20 | +80.49% |
| additive | 32.32 | 30.22 | 31.23 | 30.18 | +116.14% |
| word-fill | 33.25 | 30.59 | 31.87 | 30.80 | +120.54% |
| static | 32.24 | 32.35 | 32.30 | 31.19 | +123.50% |

Pool only executable-identical replicas. The range is observed run variation, not a confidence interval.

| Engine | Runs | Pooled MOS FPS | Pooled PRT FPS | MOS FPS range | Range |
| --- | ---: | ---: | ---: | ---: | ---: |
| baseline | 2 | 14.45 | 13.96 | 14.44–14.46 | 0.11% |
| native_spans | 4 | 25.73 | 24.86 | 24.62–26.24 | 6.56% |
| additive_sampler | 4 | 31.76 | 30.68 | 30.22–32.35 | 7.07% |

1. Executable-identical repeats span up to 7.07% in nominal MOS FPS. Wider fill differs +0.35% from the four accepted byte-fill runs; that small difference is assessed against this repeat spread. Keep the accepted additive sampler with byte fills.

2. Split-clear has exactly the span-native executable inputs; corrected static has exactly the additive inputs. Their differences are replica variation, not separate optimization gains. Panorama retention and changed-cell HUD caching are common to every case. The earlier flat-sky gain does not transfer.

3. COMPARISON-SELECTION.json preserves two logical 17-case orders, with each row pointing to its original campaign/case. It retains 17 forward and 12 reverse successes from racefullsession02, then five remaining reverse cases under racefinishsession01. An external CPU-boost change interrupted the original session after its 29 valid runs; the interrupted case is excluded. No successful original receipt or raw stream was copied into a synthetic campaign. The selector pins source receipts, and the independent raw audit qualifies the selected intervals.

4. Every selected run completes 900 measured renders/3,600 native physics ticks after two unmeasured warm renders. All 34 pass exact final state, 5,624 retained native replies, completion/post-swap checks, timer restoration, stop/unload, zero backend errors and clean MOS return. RESULTS.json preserves all 34 named runs and their actual source references. Completed 272-frame crash/blink/recovery coverage and fenced scene captures are excluded from timing.

5. The deterministic driving policy disables damage while checking contacts and exercises panorama repair, dynamic HUD/footer, traffic scaling and finish markings. This fixture is not interactive full-game/state-machine or autonomous physics-scheduler qualification.

6. Runs use silent headless Oryx Flexe with the same pinned firmware/runtime, boost 0 during selected intervals and the original 95°C guard. MOS/PRT remain separate nominal emulator clocks. Host activity and observed variation limit inference; there is no physical frame-rate, monitor scanout or isolated physics-headroom claim.

7. The earlier partial raceab02 campaign is excluded. Bounded startup transport retries preserve their original streams and qualification evidence. Guest/native/backend/state or in-window failures are not eligible silent retries. DIAGNOSTIC-ATTEMPTS.md and ATTEMPTS registries retain original outcomes; the final guest loads before mode136 and uses the corrected road/actor viewports.

New fixture and evidence remain uncommitted for Author visual review and explicit publication approval.
