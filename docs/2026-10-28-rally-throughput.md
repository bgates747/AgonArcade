# 2026-10-28 — Rally native throughput investigation

Author requests follow-up on the built-in affine path after clarifying the
scaling approaches. INC-001-02-AFF01 records isolation of matrix setup, format,
alpha, clipping, dispatch and transformed drawing; no general inefficiency claim
is justified by the current A/B alone. Current artwork loads full-size once;
resizing occurs inside VDP with no scaled-bitmap uploads during the hot loop.
Author accepts that arrangement. Future cached-size proposals are separate.
Documentation only; no new build/run or publication.

Matched motion comparison completed after Author reports other jobs done:
jobs absent/host49°C, then session03runs both orders unchanged. Affine baseline
28.4585→additive35.3519nominal MOS FPS (+24.2226%); PRT+24.2621%;6.8519nominal
ms/frame saved. Four900-frame/3600-tick/2913reply runs pass independent scene/player,
full final-state, timer/input/backend/clean-exit checks. Their actual312300-byte
timed UART streams are identical,347bytes/frame, including all motion packets.
Independent raw audit agrees. Max56°C/boost restored1/all emulators stopped.
Earlier incomplete startup pair and95°C prelaunch abort preserved/excluded;
older42.4%gain belongs to constant-gap workload. Human visual/exit acceptance
recorded; hardware/publication/new optimization remain open. [Results](tasks/RALLY-28/custom-vdp/incremental/sprites/motion-comparison/RESULTS.md).

Author accepts moving sampler visuals/clean MOS return, then requests the same
deterministic pattern against the affine baseline before proceeding. Matched
unpaced900-frame fixtures reuse exact motion table/driver/artwork/runtime and
347UARTbytes/frame; both orders staged. First affine run passes27.68nominal MOS
FPS; its sampler partner stalls during startup, preserved after guarded abort.
Fresh identical02profiles staged, but next session thermally aborts at95°C before
launch. Other CPU-heavy agon-6502 target experiments remain untouched. Boost1
restored/no owned emulators. Await Author host coordination; no matched-pattern
gain yet, no code publication/hardware/next optimization. [Scope/receipts](tasks/RALLY-28/custom-vdp/incremental/sprites/motion-comparison/README.md).

Author review found traffic kept player pace, concealing changing car sizes,
and exit did not visibly return to MOS. A separate900-frame scripted-motion
review exercises six cars over62scales each, approaching/passing in three lanes.
The review driver restores single-buffered mode8/full text viewport/cursor;
the final silent run emits DONE then the MOS prompt. All2913reply, final
scripted position/lane/player, timer and backend checks pass. First startup
failure and intermediate narrow-window run preserved; final inputs are fresh
and stopped for Author launch. Benchmark bytes/results unchanged. Both SDL
driversdummy; boost restored1/all emulators stopped. New work uncommitted.
[Review instructions](tasks/RALLY-28/custom-vdp/incremental/sprites/review/README.md).

INC-001-02 completed after the Author's all-dirt commit/push checkpoint
**32a7cb4**. Restricted integer additive sampling replaces actor affine scaling;
road/player/physics and the timed UART tape remain unchanged. Two reversed-order
900-frame pairs give **26.98→38.42 nominal MOS FPS (+42.40%)**, saving
**11.04 nominal ms/frame**; independent PRT gain is42.42%. All four runs pass
3600ticks/2913retained replies, independent state/input/timer/backend checks;
all final captures are byte-identical. Separate admitted128-frame actor probes
show preparation plus drawing reduced60.67% in raw emulated CCOUNT, including
sampling moved into preparation. Uncalibrated counters are not physical cycles.
The initial late-load candidate and larger diagnostic modules failed memory
admission; equal early LOAD solves headline admission. Four preclip timings are
excluded after stale sign pixels exposed an inactive canvas viewport; corrected
PLOT4 activation is covered by host regression checks. Exact inputs and rejected
attempts are preserved. Both SDL driversdummy, boost restored1, all emulators
stopped. New work is uncommitted; Author motion review and byte-identical hardware
testing remain open. [Results](tasks/RALLY-28/custom-vdp/incremental/sprites/RESULTS.md)
and [review launch](tasks/RALLY-28/custom-vdp/incremental/sprites/HUMAN-REVIEW.md).

INC-001-01 completed after all-dirt/scope checkpoint **b0bf5e7** was pushed. The
new [incremental plan](tasks/RALLY-28/custom-vdp/incremental/PLAN.md) prioritizes
redundant clears, specialized sprite sampling, wider span fills, caches/static
drawing, synchronization and composition. First modification only: retain sky
and bottom clears, omit the opaque road area;38,400clear writes saved,+12wire
bytes/frame. Four reversed-order900-frame/3600-tick Oryx Flexe runs pass2913reply
records each, independent final state, input hashes, PRT restoration, backend and
exit checks. All shutdown captures are pixel-identical. Pooled nominal MOS
25.9615→26.3286FPS(+1.41%),PRT25.0850→25.4489(+1.45%),0.537nominal MOSms/frame
saved; pairwise gains0.15%/2.69% are small/variable, not a stable gain guarantee.
Both SDLdriversdummy;boost1→0→1,max60°C,all emulators stopped. INC-001-01 removed
from unfinished root TODO with this disposition; later implementation/hardware
not released. New code/evidence uncommitted for review. [Results](tasks/RALLY-28/custom-vdp/incremental/RESULTS.md).

The Author releases a fresh baseline and an isolated native road renderer experiment toward60Hz. Existing renderer evidence and the new work contract will be committed/pushed before implementation. No prior visual/hardware gate is accepted by this checkpoint. Scope: [RALLY-28 HZ60-001](tasks/RALLY-28/custom-vdp/throughput/PLAN.md).

Initial read-only checks find Oryx reachable with the canonical SSH identity, the preserved native review runtime present, no emulator running, and CPU boost enabled (`1`). Existing thermal safeguards require boost disabled for unattended runs; no power setting has been changed and no emulator has been launched. Continue independent source/host work; actual timing remains conditional on the guard.

Two parallel read-only audits identified the frozen ABI's limitations (no native timer service and only single-buffer monochrome frame access) and a supported alternative: write an application-owned RGBA2222 buffer through existing buffer leases, then draw it through the stock bitmap command. The finite900-frame flat-background Fuji fixture remains the comparison workload; full playable-game performance is not implied. The new contract separately identifies unpaced and diagnostic cases and preserves historic benchmark bytes.

The full pre-execution checkpoint was committed/pushed as `39a546a`; clean tree verified before implementation. Parallel implementation delivered a span raster/bitmap helper and separate raw-CCOUNT diagnostics; an independent read-only review found no blocking correctness issue. The helper retains frozen generated simulation, float endpoints, road bands and actor/player/HUD/finish code. Ordinary and ASan/UBSan modes each pass 900 frames / 3,600 ticks, exact independent final arrays and 900 stock-quad road images, plus 490 edge cases, 598 section cases, six invalid cases and 126 failure/lifetime cases. Candidate module SHA d178334e4d4beb8a3df326e70ffabae87ff16d0a193b972be15ac3078d1ca4bb, text 30,928 / data 1,004 bytes; peak four balanced leases. Persistent image costs 38,400 bytes. Road list averages 45.4 resident bytes/frame versus 1,799.29; outbound UART remains 248 bytes/frame. These counts do not establish a speedup.

Two phase probes each build for 128 frames / 512 ticks with 130 foreground marks and 39,430 retained bytes. Ordinary/sanitized host replay matches uninstrumented state/drawing; 24 protocol negative groups and nine decoder cases pass. Raw CCOUNT is uncalibrated/interrupt-inclusive; drawing brackets include dispatch/marker/flush overhead. Three separate completion-fenced unpaced controls/candidate add an ordered checked root-generation reply after controller swap and before the foreground mark. They add 17 outbound bytes and a reply/frame and do not timestamp physical scanout. Existing paced and unfenced bytes remain distinct.

Eleven profiles are now staged/stopped and all runtime/input hashes checked on Oryx. The original campaign guard rejected boost 1 before any run output changed; no emulator launch or power setting change occurred. Deployment also detected a differing old remote native-demo/build.py and preserved it. New tools now use their own tape helpers and hash-pinned runner/verifier snapshots; runtime import checks on Oryx pass. Portable inputs/modules/unchanged firmware are packaged with per-member hashes. Read custom-vdp/throughput/RESULTS.md under RALLY-28. Tasks01/04/05delivered; fresh baseline, phase execution, A/B, runtime stack/headroom and motion/hardware gates remain open. All61frozen controls, prior archive and production game SHA7f1620ed…unchanged. New implementation/results stay uncommitted pending review/publication instruction; next dependent action needs the existing host thermal condition resolved.


The Author approved a temporary boost disable for the prepared tests, with restoration afterward. All three supervised sessions returned boost from1to0to1, stopped owned emulators first, used both SDLdummy drivers and stayed at or below63°C on one host boot. The initial original-control unpaced run stalled in startup artwork upload before any native LOAD or physics/render; exact failed prefix preserved. Identical bytes passed in a fresh profile. No emulator fix is claimed.

The RGBA span candidate qualified, then a bounded Native-format extension used an existing stock fast copy path. Exact source/host proof establishes the same opaque pixel bytes in mode136/VGA64/-H/-V; only bitmap setup format changes1→3, with module/script/physics/pixels unchanged. No additional firmware/SDK or public service is needed. The proof does not generalize to different sync, palettes, transparency or affine drawing.

Fifteen successful900-frame/3600-tick runs plus two128-frame diagnostics now pass. Reversed-order completion-fenced pooling gives quad15.33,RGBA20.52,Native25.91nominal MOS FPS; Native gains69.05%over the previous best, but still misses60Hz. PRT14.81/19.82/25.04is reported separately. Suppressed checked READ16 after controller swap fences frame timestamps; transport cost included,physical scanout unobserved. Phase control/quad identifies road and actor drawing as the largest measured non-swap costs; counters are abstract Flexe instruction progress,not physicalESP32cycles. New candidate remaining phase shares have not been measured.

A quiet stopped Native-format fenced-unpaced human profile is ready on Oryx, audio disabled and startup flashing text blanked. Read [review instructions](tasks/RALLY-28/custom-vdp/throughput/HUMAN-REVIEW.md) and [results](tasks/RALLY-28/custom-vdp/throughput/RESULTS.md). All61controls/prior archive/production binary and runtime/SDK pins remain unchanged. New implementation/results remain uncommitted; motion review and later identical-byte hardware are the next gates. No physical card, flash or peer-source change occurred. Earlier entries describe the pre-approval blocked state and are preserved as chronology.


WOLF-REF-001 completed on Author request: silent headless Oryx Flexe reference using the deployed105122-byte Wolf3D application and matching existing custom VDP. Two30-second host-clock windows each return870completed render frames:1740/60.014s=28.993FPS,reported29.0. The application retains nominal30Hz simulation/submission cap; no unpaced maximum claim. Original E1L1 spawn restored only in isolated state copy; normal medium AI/256x160view/weapon/HUD active during continuousRightturning. Entire capture1876consecutiveW3DR completions=1876render requests=1876C3commands,no fizzle/backend errors;120headings,unchanged position. Wolf dirty source/generated/deployed inputs untouched; same pinned Flexe/MOS runtime as Rally. Both SDLdummy,boost1→0→1,max60C,processstopped. Evidence under RALLY-28/research/wolf3d-framerate/RESULTS.md and JSON. Host seconds differ from Rally nominalMOS/PRT clocks; no cross-clock percentage. No source/firmware optimization,hardware or commit/push. Completed ID removed from authoritativeTODO; later unpaced/crowded-scene investigations are unpromoted.


WOLF-REF-002 completed: Author selected E1L1cells(34,33)/(34,36) and requested360°rotation at each. One exact360°clockwise turn each,all120headings,120frame intervals:no translation/fizzle. Center4.137017s/29.0064FPS,south4.136100s/29.0128FPS,both reported29.0underunchanged30Hzcap. Hosttimestamped existingUARTtrace;timed/rawP/R/D/C events match,all measuredcompletionspresented. Mean submission→delivered-callback21.6/23.0msincludestransport/queues/readout,notisolatedVDPCPU. Normalguardcombat remains;health100→94both. Existingapp/assets/firmware/runtime/shim samebetweenpositions,onlyisolatedstatecoordinatesdiffer. Firstsouthstartupstalledbeforegame,exact1422695Bprefixofsuccessfulcenter;preservedtimeout/cleanstop/boostrestore. Freshidenticalretry passes. Sourceandpriorevidenceunchanged,allheadless/silent,boostrestored1,allownedprofilesstopped/backenderrorszero. Read RALLY-28/research/wolf3d-framerate/positions/RESULTS.md/JSON. Nooptimization/hardware/commit/push. CompletedIDremovedfromTODO.
