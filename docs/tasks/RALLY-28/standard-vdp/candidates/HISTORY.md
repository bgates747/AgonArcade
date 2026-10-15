# Historical candidate status notes

These interrupted-run notes are superseded by RESULTS.md. They preserve investigation history, not current instructions.

# Standard candidate tranche — results and interruption, 2026-10-15

**Shared lookup/sparse projection reduces the measured CPU-only work substantially, and buffered drawing reduces wire traffic. A matched completed-frame FPS comparison is still blocked by intermittent transfer stalls and renewed loss of Oryx connectivity.** No physics cadence or game integration is selected. New work remains uncommitted for review.

**Author paused all work on2026-10-15 for a possible Oryx thermal shutdown.** The08supervisor was interrupted and zero remaining Rally emulator processes verified. Preserve current profiles/results; no further testing or implementation until explicit resume. [Pause checkpoint](evidence/PAUSE.json).

Prior measurement/audit dirt was committed/pushed as `119edcd`; the released candidate contract as `c811998`. STD-002-01/02 implementation and host proof are delivered. STD-002-03/04 have partial target evidence; final comparisons, independent physics-service qualification and fresh human review profiles remain open.

## CPU and wire results

All five v3 CPU-only target applications complete 900 full-scene frames, independently verified against their host byte counts and final position/phase. Every candidate has an identical actual-physics object. The following are **nominal PRT intervals**, not hardware milliseconds or completed-frame FPS:

| Variant | Mean scene preparation | Mean construction | Entire 900-frame loop / frame | Application B/frame | Road B/frame |
| --- | ---: | ---: | ---: | ---: | ---: |
| Dense control |57.17ms |89.27ms |150.75ms |1859.59 |1370.37 |
| Shared fine/direct |12.25ms |22.22ms |38.79ms |2310.13 |1820.91 |
| Shared fine/buffered |12.24ms |15.54ms |32.12ms |1366.57 |877.34 |
| Coarse/direct |11.98ms |19.06ms |35.36ms |1742.56 |1253.34 |
| Coarse/buffered |11.97ms |14.49ms |30.79ms |1094.31 |605.08 |

Fine/buffered is about **4.69 times faster in this CPU-only diagnostic** than dense; coarse/buffered about 4.90 times. These are ratios of nominal emulator counter samples, with no real transmission in that mode. They must not be presented as game FPS or as qualified physical processor headroom. Fine/buffered reduces recurring total application traffic **26.5%**, coarse/buffered **41.2%**, versus dense. The fine/direct path actually increases traffic; its arithmetic gain does not erase that cost. [Five verified CPU receipts](evidence/V3-QUALIFICATION.json).

Counts include road patch/CALL and all existing scene commands. Real completion adds seven upstream bytes/frame and six downstream packet bytes. All variants preserve 397 panorama scrolls/399 repaints and existing changed-only HUD/panel/audio behavior. Setup is separate: the fine buffered run sends 125,910 setup bytes. Template bodies total 1,379 bytes plus 70 clear/upload header bytes, excluding allocator overhead. Candidate executables are approximately 193–207kB; coefficients require 116,800 bytes for Fuji.

## Complete real-transfer evidence

Two fine/buffered versions have independently verified 900-frame runs. Each has exact host/target setup and frame UART bytes, 900 distinct post-fence key-zero completion packets, unchanged delivered return packets, correct final position1202800/phase1600, restored PRT/vector/callback, unchanged inputs and zero backend protocol errors. These are successful individual runs, not evidence of transport reliability.

| Version / runtime | Raw MOS units | Raw PRT ticks | Nominal MOS seconds / FPS | Nominal PRT seconds | Host total including setup/save |
| --- | ---: | ---: | ---: | ---: | ---: |
| v1 fine/buffered, baseline adapter/JIT |5638 |58708 |46.983 /19.156 |58.708 |72.890s |
| v3 fine/buffered, accepted EOF adapter/interpreter |4656 |71797 |38.800 /23.196 |71.797 |85.851s |

**Neither row supplies an independently measured rendering-window wall FPS.** MOS units use nominal120/s and PRT nominal1000/s; the clocks disagree materially, especially under the interpreter. Host total includes substantial setup and output work and is not the rendering window. Do not infer a speedup by comparing these different versions/engines, or compare their nominal FPS to hardware/native results.

The v3 run includes endpoint hoisting, bounded64-byte MOS writes and between-chunk physics-service hooks (inactive in mode1). Its [verified receipt](evidence/lookup-buffer/live-v3-interp/verified.json) and [full-scene capture](evidence/lookup-buffer/live-v3-interp/runtime/final.png) are preserved. Automated inspection is not Author motion acceptance.

## Host proof, reuse and visual choices

Normal and ASan/UBSan checks pass 9,632 poses/two tracks, 10,677 object cases and all1,037 depth values. An independent bytecode interpreter reproduces the exact direct PLOT stream for the same fine/coarse geometry. All ten ordinary/sanitized whole-scene serializers agree, including setup. Endpoint hoists preserve earlier bytes exactly. Independent actual-physics checks pass3,780 field comparisons across36partial-prefix cases. [Range and consumer coverage](RANGES-AND-COVERAGE.md), [geometry proof](evidence/host-checks.json), [physics proof](evidence/shadow-host.json).

Road, opponents, signs, player, finish and panorama share appropriate projection/depth/edge/tangent/sign invariants. Fine rounds centres consistently to nearest pixel; old objects truncated, so some can move one pixel. Coarse removes optional curve boundaries while preserving material transitions and aligns objects with the resulting polygonal centre. Sampled centre differences reach28pixels; this remains an eligible appearance/speed choice for the Author. No accuracy-only rejection is applied. Finish and crash/recovery receive source/host coverage but are not visible in this900-frame presentation replay. Other audited work families remain explicitly pending.

## Failures and runtime choices

The original dense live run timed out after600host seconds. Its retrieved raw stream matches the expected321,153-byte frame prefix through187completion requests, then ends inside a PLOT submission. Zero backend errors and a clean frontend shutdown do not turn it into a pass. The stall is in the real submission path; its root cause is unproven.

All five v3 JIT live runs fail: four lack full guest results; fine/buffered reports334/900frames and a callback timeout. Bounded64-byte application writes therefore do **not** constitute a proven fix. The accepted Flexe EOF adapter correction alone also fails with the same dense application/firmware. A separate JIT physics-service attempt fails without a guest summary. Exact summaries, identities and failed traces are retained; no failed run contributes an FPS result.

Baseline adapter is `200f28cb…`; copied accepted EOF correction `108ec5b0…` comes from Flexe publication `bbd0343`, with unchanged frontend `7e78e991…`. The accepted fix concerns I2S EOF delivery. Owner sources separately document a possible ESP-IDF UART recovery ordering failure, but this experiment does **not** establish that as its cause. No private firmware fix, RX-forcing workaround, SDK or owner-source edit was adopted. Official stock VDP2.16.0 `b807beef…` and MOS3.0.2 `d5642432…` remain unchanged.

## Wall-clock campaign and recovered interruption

v4 adds guest-created `started.txt`/`ended.txt` file witnesses outside the PRT measurement, observed by host monotonic time at50ms polling. This provides an independent approximate loop window, including small witness/entry/teardown overhead, without relying on either disagreeing guest clock. The intended protocol/workload was unchanged, but resumed independent checks subsequently rejected shared v4 output for an extra panorama draw; see the correction below. Its reproducibility cleanup sources coefficients from tracked evidence, generates its own host prefix, and fixes `--targets-only`; resulting binaries remain byte-identical. [Historical v4 build receipt](evidence/BUILD-V4.json); current corrected build is [v5](evidence/BUILD-V5.json).

All final05 profiles use the same accepted adapter/interpreter, stock firmware,900-frame workload and witness instrumentation. Before the second connection loss, fine/buffered, coarse/buffered and dense again stalled; no final window/FPS exists. The fine/buffered owned frontend was explicitly stopped after sustained UART inactivity; the other two runners stopped their frontends after no command progress. The batch reached fine/direct, then Oryx disappeared from mDNS/SSH. [Partial campaign stdout](evidence/WALL-BATCH-PARTIAL.txt). Final05 raw artifacts have not yet been retrieved. Do not claim the active remote batch/frontend has stopped: its last state cannot be verified while the host is unreachable. Each run has a420-second timeout and an additional owned-profile UART-inactivity watchdog.

The earlier outage recovered after an Oryx reboot (uptime independently checked); no cause for either connectivity interruption is established. No fresh human motion-review profiles are ready. Existing consumed profiles are not fresh review instructions. The separate actual-physics mode2 is implemented and host-reference checked, but has no passing target qualification and supplies no120Hz headroom claim.

## Author restored Oryx; continuation and current blocker

After the Author reported Oryx back, SSH/uptime confirmed a new boot. No owned Rally supervisor or emulator remained. All four05profiles were retrieved, including the reboot-interrupted fine/direct case. A resumed06campaign collected five CPU cases, then was deliberately interrupted when its shared candidates failed byte verification. The owned frontend shut down cleanly. The interrupted06live return could not be retrieved before the next connectivity loss.

The shared v4 applications issued399extra panorama calls/2,793bytes. Inspection proves their generated conditional call overwrites its comparison flags while constructingy0. Those shared v4 cases are **rejected for comparison**. The corrected v5 uses a one-argument helper; generated code preserves flags, current host models retain the exact original scene stream, and the first v5 target summary restores the expected byte/call counts. [Source/codegen diagnosis and correction](CODEGEN-DEFECT.md). This is distinct from the unresolved transport stalls; no compiler/SDK/product source changed.

The **unchanged dense v4 control** passes independent state/count/identity checks,900frames, PRT/callback restoration and backend errors0. Its separate host file-witness window is135.593840s versus135.650nominal PRT seconds (0.042% difference), with no measured suspension. [Verified control](evidence/dense/cpu-v4-interp/verified.json). The corrected fine/buffered07target summary reports28.891180host seconds/28,904PRT ticks/900frames/exact expected1,229,909application bytes. That suggests the same approximately4.69x CPU-only saving, but its raw guest return has **not** been retrieved/independently verified. Do not promote it to a qualified comparison or completed-frame FPS.

The v5 campaign then starts coarse/bufferedCPU07, and SSH loses contact with Oryx again. [Partial07stdout](evidence/QUALIFIED07-PARTIAL.txt) is preserved. No live07or mode2qualification is established. Current remote campaign/process state is unverified; the runner has360-second per-run timeouts and60-second upstream inactivity checks. Runner now records boot identity and suspension separately, guards all create-new outputs and watches actual UART progress rather than debug footer text. All previous launched06processes were stopped before07began. Fresh human review profiles are still unavailable. Cause of the recurring host access loss is unproven; inspect boot/suspend history when access returns and consider a temporary task-local sleep inhibitor.

## Resume within the existing release

1. Restore canonical Oryx access; inspect/stop/retrieve owned07work and the interrupted06live case before new launches. Check host boot/suspend history; discard timing windows spanning suspension, reboot or interrupted observation. Use a temporary sleep inhibitor while testing if idle suspension is involved; do not change persistent host power settings.
2. Continue with corrected v5 shared applications and the byte-identical, verified dense control. Reject shared v4; preserve it as compiler/fixture failure evidence. Finish missing matched CPU/window checks and one bounded interpreter physics-service diagnostic, preserving transport failures without indefinite retries or private firmware workarounds.
3. Resolve transfer/clock blockers with the relevant owner before claiming reliable completed FPS or choosing physics pacing. Actual physics service must include transmission and retained debt; nominal MOS rate alone is insufficient.
4. Prepare fresh stopped fine/coarse review profiles with exact qualified identities and explicit limits. Author motion review remains the visual gate; product/scheduler integration and publication are later decisions.

Every automatic run forced **both SDL dummy drivers**, used its generated profile-local launcher and produced no window or speaker sound. No physical card/flash, native/Golem/compiler/SDK/product edit was made. Protected product SHA remains `7f1620ed8139ee779e7d50e333ef572aeaf612a154e41ec574e63a57da760293`. [Manifest](evidence/MANIFEST.json) inventories exact current source and artifacts; raw traces are losslessly gzip-packed with original hashes in [PACKED-TRACES.json](evidence/PACKED-TRACES.json).
