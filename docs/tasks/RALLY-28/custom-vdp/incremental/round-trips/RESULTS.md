# Full-race serial round-trip result

Fewer serial waits improved completed race throughput from **33.09 to 36.57 nominal MOS FPS (+10.53%)**. Both logical orders improve. All native errors, full publication validation and the final post-swap fence remain. The independent raw audit confirms exact world state and identical non-diagnostic frame commands. These are emulator results; physical hardware performance is untested.

| Case | Frames pooled | MOS seconds | MOS FPS | Separate PRT seconds | PRT FPS |
| --- | ---: | ---: | ---: | ---: | ---: |
| diagnostic | 1800 | 54.4000 | 33.0882 | 56.3250 | 31.9574 |
| compact | 1800 | 49.2167 | 36.5730 | 50.9250 | 35.3461 |

PRT throughput improves10.60% independently. Pooling sums completed frames and elapsed units within each clock; clocks are never combined or rescaled. Main runs are900frames/3600ticks each, plus two separate60frame startup/functional smokes excluded from the throughput comparison.

| Order | Diagnostic MOS FPS | Compact MOS FPS | Gain |
| --- | ---: | ---: | ---: |
| rlyrtab01 | 33.1492 | 36.6102 | 10.44% |
| rlyrtba01 | 33.0275 | 36.5359 | 10.62% |

## What changed

1. Both arms use identical native module479fe1ac... and guest685f4b4c.... Only the16-byte config flag changes executable behavior; expected.json describes it. The native module checks full32-bit publication/session/request/world/generation, readiness, status and release results before RUN reports success. The diagnostic arm additionally reads four intermediate words. The compact arm omits those queries during timed frames only. Warm pages and optional effect coverage retain diagnostics.
2. The RUN error callback and timeout, final stock swap plus checked generation reply,203 final-state reads, PRT restoration, Stop/UNLOAD and clean MOS exit remain. A successful RUN validates command/pixel preparation; it is not raster completion. FRAME-COMPLETION-FENCE.md in full-race preserves the stronger final swap proof.
3. Native module size34836bytes, text32264/data1004. This is420package bytes more than the original additive module; both measured arms include that cost. Target stack declarations report352bytes for entry and672bytes for the renderer preparation, not an exhaustive summed stack bound. INFO17 goes2260→1956 in every full run; it measures command-task stack watermark, not free heap.
4. Geometry, sampler, original artwork, panorama/HUD/footer/engine work, motion, native physics, pacing and firmware/SDK/runtime are unchanged. This remains the finite four-physics-steps/render fixture; it does not establish autonomous120Hz physics. AFF03 is not part of this experiment. No generation or bitmap-cache change is hidden in the result.

## Actual wire and wait cost

Counts below cover one900-frame timed race. Outgoing boundaries are after initial INFO17 submission through the final outgoing swap-fence query. Incoming boundaries are after that INFO17 response through the final swap-fence response. All full multiplexed incoming bytes are counted, including ordinary MOS packets.

| Quantity | Diagnostic | Compact | Reduction |
| --- | ---: | ---: | ---: |
| Complete outgoing bytes | 352768 | 291568 | 61200 (17.35%) |
| All multiplexed return bytes | 214876 | 171676 | 43200 (20.10%) |
| Native reply bytes, including packet headers | 64800 | 21600 | 43200 (66.67%) |
| Timed native replies/waits | 5400 | 1800 | 3600 (six→two/frame) |
| Mean aggregate reply wait, nominal PRT ms | 13413 | 11878 | 1535 (11.44%) |

The measured savings are exactly68outgoing and48incoming native bytes per frame. The remaining native replies are one RUN status and one final checked swap fence per frame. Query tokens differ as expected; removing only the four diagnostics and normalizing the token fields leaves the entire timed outgoing stream byte-identical across all four runs. Two same-case repeats have identical actual timed bytes before normalization.

## Qualification and remaining gate

1. Ordinary and ASan/UBSan actual-C replays each pass900frames/3600ticks plus two warm renders against the unmodified accepted module and independent world model. All command buffers and road/actor pixel workspaces match. All27 corruption/acquire/release/failure tests reject; maximum four balanced leases and intact canaries.
2. Independent raw audit passes all four full runs and both smokes. Full runs retain5624diagnostic or2024compact total native replies, including setup/final/teardown. Every request/reply token, status and final fence matches the reconstructed schedule. Final406bytes agree with the independent model and203raw reads. UART delivery equals capture, backend errors are zero, timers restore, UNLOAD0 and the MOS prompt follow cleanup. No startup failure or retry occurred in this campaign.
3. The exclusive central lease covered all six sequential runs. Session execution175.19host seconds; original boost1 restored1, all owned processes stopped, fresh process/maps inspection empty, lease explicitly released. Original95°C guard retained; actual sampled maximum61°C. The preliminary release mail said58°C from console output; this complete guard log supersedes that preliminary peak. No peer process was touched.
4. Fresh candidate review profile is stopped; see HUMAN-REVIEW.md. Human moving review and publication remain pending. No hardware operation, runtime/firmware replacement, commit or push occurred. Keep prior accepted renderer and all historical archives preserved until disposition.

Raw evidence, exact inputs, diffs, SOURCE/target pins, guard/release receipts and RAW-AUDIT.json accompany this report. Source-package inherited build files are provenance only; target/rally-render.vdpl is the authoritative new module.
