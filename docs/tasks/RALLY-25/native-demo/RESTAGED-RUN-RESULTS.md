# Latest human Flexe run — correct state, lower logged frame rate

The new RALLY-25 native review run completes900frames/3600physics ticks and all2,913saved reply checks. Its logged MOS rate is **14.37FPS**, compared with the earlier human29.30FPS, using the same immutable game/runtime/firmware/data. The cause of the lower rate is not established. This is nominal emulator timing; no independent host-wall duration was captured for this manual run.

Read-only collection from Oryx's rally25-native-review01preserves logs and backend artifacts under [evidence/review-restaged01](evidence/review-restaged01/). [Machine-readable result](RESTAGED-RUN-RESULTS.json) and the retained verifier output give:

1. MOS:7,518units at nominal120Hz,62.650seconds,14.3655FPS.
2. PRT:64,825nominal millisecond IRQ ticks,64.825seconds,13.8835nominal FPS. The emulator's instruction-derived PRT scale is not independent physical/host-wall calibration.
3. Every native reply record and all six final published buffers match the previous independently qualified human run exactly; reply SHA4ae79d93… . The five mutable arrays also directly match SOURCE-RESULTS.json's independent world model. Final world tick3600, render request900, generation4501.
4. Stack minimum free2260before/after; StopRace/UNLOADboth0. Borrowed PRT previous vector restored. No failure.logand no failed/unhandled/unregistered/unmapped backend flags; backend engineJIT.
5. All16current profile pins and four copied guest-log hashes verify. Immutable inputs match the accepted old profile; only the new wrapper has silence/boost-off guards. Most frame intervals are8or10MOS units rather than four; full histogram retained.

Current Oryx boost reads1(enabled) at collection. This is not an in-run monitor record and cannot establish its state over the run or explain the slowdown. The profile's startup guard requires0, but no continuous boost/load/temperature/wall trace was collected during Author execution. No power setting was changed and no further emulator was launched. Future automated emulator testing retains the explicit boost-off and both-dummy-driver requirements.

Author clarification: boost **was disabled during the measured run**, and was reenabled afterward. The post-run1observation is consistent with that history; it must not be presented as a cause of the recorded slowdown. The human review launcher's silent boost guard was subsequently removed at Author request; automated checks retain a descriptive boost-off refusal before log mutation. LAUNCHER-FIX.json records that later wrapper-only change, preserving the earlier run's input receipt.

This fixture remains a scripted native rendering/simulation demo, not a playable full game or independent physics scheduler. Rates include checks, transport/drawing and swap submission; no isolated VDP phase measurement follows. Logs/profile were left unchanged by collection; local verification writes only the copied evidence. New results remain uncommitted for Author review.
