# Physical VDP reset investigation — 2026-09-12


Current status (2026-09-12, after official-firmware reset test): **R19-11-H2 is
qualified for the observed startup correction.** The Author confirmed continued,
slow rendering after using the board reset button on restored official VDP2.16.0.
No cold power-cycle test was performed. The production card remains oval/demo,
without game logging or fencing; EMOS keyboard input remains commented out.
Passive serial capture is closed. The sections below preserve earlier phases;
references there to installed diagnostic firmware or pending card tests are
historical. The final section owns the current state. Hardware speed remains
unacceptable; no performance acceptance follows from this startup correction.

The Author resumed the goal and explicitly authorized ESP32 USB serial capture
and diagnostic VDP changes/flashing to trace the production Rally startup reset.
The Agon is powered, autoexec runs oval/demo, and EMOS extender keyboard is
disabled. EMOS + official VDP boots and runs another demanding game without
Rally; the identical Rally production binary works in the stock native emulator.
The failure also occurred with custom VDP + standard MOS on another Agon.

This is an amendment to the earlier no-hardware/no-GUI contract: physical
VDP diagnostics and application deployment are authorized. Testing emulators
remain headless; launch a dedicated graphical review emulator only after the
cause is located and evidence supports a working game. Do not modify MOS,
Extender/P4 firmware, upstream reference sources, or unrelated applications.
The root TODO's R19-11-H1 through H3 are the sole new execution checklist.
Commit each completed milestone under the existing Author authorization;
retain emulator changes pending human review where that gate applies.

Start with passive 115200-baud ESP32 UART0 output during a full Agon restart.
Use a diagnostic build copied from official VDP v2.16.0 if stock output lacks
crash detail. Preserve source diffs, dependencies, ELF/map, flash hashes,
serial logs and decoded backtraces. Observe startup milestones, heap/stack
state and buffered-call nesting only as evidence demands. Logging is temporary
VDP instrumentation; do not add production game fencing or performance logs.
Do not assume the native emulator models ESP32 RAM, stack, timing, interrupts
or the physical drawing queue. Prefer fixing emitted programs/loader to making
the product depend on changed firmware. Restore the official release and
repeat the corrected production launch before claiming stock compatibility.

Deployed production binary is 95822 bytes, SHA256
2d6b0d385f1b271c77cebb37e6a253ac55b11bf11d8df91a0b2720ed1829bbee;
command `run . oval demo`. Existing deployment hashes are in
`evidence/hardware-production/oval-demo/deployment.json`.
Official VDP artifacts and full preflash backup are in repository-root
`.work/stock-vdp-2.16.0/`; all three official segments independently verified.
The active official version is 2.16.0, source tag c7ac293d2aa81ddfa693390549bcd909069c8fc3.
The failing ESP32 is locally connected; resolve its stable serial path again
before flashing. Do not use the remote Extender P4 bench for this task.

## H1 — physical fault located

Stock serial capture reports `Stack canary watchpoint triggered (processLoop)`
on Core 0, followed by reboot. The corrupted backtrace is not usable for an
exact source-line attribution. Evidence: `evidence/hardware-production/serial-stock/passive.bin`.

A separately built official-2.16.0 diagnostic changes only the processLoop stack
from 4096 to 16384 bytes and adds UART0 call-depth/high-water logging. It reports
eight nested processAllAvailable calls along:
submit2000 -> commitState2002 -> renderProof2004 -> road_fullRoad2400 ->
road_drawNextBand2701 -> road_projectRow2406 -> LoadElement guard316 ->
patched-copy315. Each additional observed interpreter level costs384 bytes.
The first completed frame leaves11956 of16384 stack bytes:4428 consumed,
including diagnostic overhead, above stock4096. At least three frame returns
were observed. This is not yet a full gameplay or stock-firmware acceptance.
The native host's stack did not expose the ESP32's small task-stack constraint.

H2 will reduce emitted call nesting while preserving stock VDP semantics and
production game inputs. Larger firmware stack is a diagnostic control only.

## H2 candidate — ready for physical deployment, not yet accepted

The diagnostic original game returned720 frames over its600-second capture
without another reported reset. Do not interpret this as a performance pass.
The current physical VDP remains the temporary16KB-stack diagnostic.
The original16KB diagnostic ELF/bin/map were reproduced byte-identically and
preserved in `.work/vdp-diagnostic-artifacts/stack16384/` beneath this task;
a stock4096-stack diagnostic is prepared separately in sibling `stack4096/`.
Neither is product firmware. Repository-root `.work/stock-vdp-2.16.0/` retains
the official firmware for restoration.

Golem now supports an opt-in top-level `InlineCalls(namedProgram,...)` directive.
It expands compiler-recorded unconditional call sites after original DAG/type
validation. It never scans payload bytes for opcode patterns. Typed arithmetic,
mutable command templates, storage IDs, conditional calls, finite repeat back
edges and external program entrypoints remain intact. Expanded programs and
aggregate storage still face original resource caps. This reduces nesting but
is not a universal static proof of firmware stack safety.

The scenery generator selects the frame/road/vehicle wrappers to inline.
`build_stack_candidate.py inline-b` built a production candidate using the
byte-identical original production main.cpp; only the compiler-produced scene
assets and their loader integrity constants change. It remains unfenced and
contains no gameplay measurement or serial logging.
The candidate is `.work/production/inline-b/` beneath this task.

All14 host sanitizer/golden/negative targets pass, including an explicit-source
expansion equivalence test, nested/repeated sites, preserved conditionals/loops,
cleanup identity and bounded rejection cases. Eight oval plus eight Fuji native
scene comparisons pass. The exact visual-tested assets equal the candidate
assets byte-for-byte. A separate headless production run shows the demo prompt,
Space takeover, steering and injected Escape; no post-Escape screen was captured.
Evidence index: `evidence/hardware-production/inline-candidate/validation.json`.

The physical SD is not mounted. The Author has been asked to stop/power down
and mount it for candidate deployment. H2 remains open until a corrected physical
run succeeds on the original4096-byte stack and then official release firmware.
Deploy rally.bin + oval.vdp + oval.clr together; the embedded integrity signatures
must match the new scene files. Preserve the active demo/oval autoexec and its
commented EMOS keyboard command. Do not reuse deploy_production.py blindly: its
saved-script assumptions predate the boot-script isolation changes.
A graphical `hardware-stack-review` profile is being prepared for the Author;
it is a candidate review, not physical-stock validation. Compiler/game changes
remain uncommitted pending that physical test/review. H2/H3 remain unchecked.

## Corrected card deployment and stock-stack diagnostic prepared

The Author mounted the SD and confirmed the original game visibly produced
frames with the16KB diagnostic, but at a very low frame rate. Logging emitted
startup/depth maxima, first3 returns and one line per120 subsequent returns;
serial volume is therefore unlikely to explain most of the slowdown. No physical
performance acceptance is made. The renderer's real ESP32 cost remains unresolved.

`deploy_production.py inline-b-card --build inline-b` validated the original
production code/header identity, deployed the matched95,822-byte executable plus
115,526-byte oval bootstrap and5,016-byte cleanup, preserved autoexec byte-for-byte,
synced and safely unmounted `/dev/sdb1`. Deployment hashes and exact saved launch
script are in `evidence/hardware-production/inline-b-card/`. The script has14 real
CR/LF line endings, no literal escape sequences, commented EMOS KEYINPUT extender,
and active `run . oval demo`. The deployer now accepts the stack-fix manifest and
preserves the Author's autoexec instead of normalising or rewriting it.

The4096-byte-stack diagnostic image SHA256
6bc9fab882a7b33bbb3bb79f94627f26069209740a4b7b37a2ee911a9adc8dbe
was flashed at0x10000 and its write-time hash verified. Boot output confirms
`R19 DIAGNOSTIC stock2.16.0 stack4096`. UART0 capture was armed at19:42:57UTC.
As of19:52UTC no Golem buffer execution had arrived; the card still enumerated
in the PC reader. The Author was asked to return it and restart. Hardware success
must not be inferred from this boot marker. The passive capture helper records
raw bytes plus host arrival metadata and has an explicit stop-file mechanism.

## Full frozen scene regression completed

All66 frozen poses (24 oval,42 Fuji including added tight bends) pass on the
inline-b assets. `qualify_inline_candidate.py` recomputes per-region pixel and
road-boundary metrics, exact player/scenery/car records, source/asset hashes,
clean guest exit and the original frozen-image bridge. Its report is
`evidence/hardware-production/inline-candidate/frozen-qualification.json`.
This is full frozen scene coverage, not a substitute for physical stack testing.

The first4096-stack capture ended normally after600seconds with only the VDP
boot marker. A fresh longer passive capture, `stack4096-candidate-wait`, was
armed at19:53UTC. It likewise initially recorded only the4096-stack banner.
The SD still enumerated in the PC reader at that check. The next hardware action
remains the Author returning the prepared card and restarting the Agon.

## Continued regression while awaiting the physical restart

The graphical review emulator was closed by20:03UTC; no review approval is
inferred from that. The serial capture still contained only the4096-stack boot
banner. The deployed card and installed diagnostic firmware were left unchanged.

A fresh research frontend, `.work/frontend/hardware-inline`, reproduces both
deployed-candidate bootstraps exactly. `frontend_bridge.py` retains strict asset
identity by default; the new explicit `--inline-qualified` option accepts only
the two bootstrap hashes in the complete66-pose qualification. It rechecks every
listed evidence hash and visual-run source hash, all frozen case names, and the
generated integrity header. Cleanup/road data, simulation/art/projection headers
and recurring state preparation/submission remain identical. This bridge does
not assert physical stack safety or transfer old timing/stability results to new
assets. Its report is `evidence/hardware-production/inline-candidate/frontend-bridge.json`.

Fresh stability, lifecycle and real-UART timing diagnostics were built beneath
their task `.work` directories with name `hardware-inline`; these are separate
from the unfenced production binary on the SD. The updated bootstrap sizes cause
the existing sanitized loader fault suite to exercise834 cases, all passing
(`evidence/golem-loader/hardware-inline/results.json`). Headless Fuji lifecycle
testing was then started; completion evidence must be checked separately.

The Fuji lifecycle completed successfully at20:08UTC:210 events,27 admitted
states, exact96-byte readbacks, unchanged geometry/history on rejected input,
sequence wrap, finite coordinates, and three cleanup/reload cycles. All853
compiler-owned IDs were removed each time; the foreign canary survived.
Equivalent cleanup/reload phases had identical tracked allocation counts and
bytes; final game teardown returned to26 allocations/174986 bytes.
Evidence: `evidence/golem-lifecycle/hardware-inline-fuji/results.json`.
The physical capture still had only its boot banner. H2/H3 remain unchecked;
compiler, candidate and diagnostic-tool edits remain uncommitted pending review.

The fresh `build_production.py hardware-inline --frontend hardware-inline
--inline-qualified` path independently regenerates the production frontend from
the new research build, rather than copying the old emergency production tree.
The executable, source, every header, Makefile and both track assets are all
byte-identical to the `inline-b` card candidate. This closes the stale-build
possibility for the candidate awaiting physical testing; it makes no new hardware
performance claim. Evidence: `inline-candidate/production-rebuild.json` beneath
`evidence/hardware-production`. BUILDING.md locates the actual Golem/compiler
sources, generated kernels, build chain and diagnostic/production distinction.

The original600-second16KB-stack capture contains1127 bytes in
`stack-diagnostic/serial-completed.bin`. At the captured115200-baud8N1 settings,
that is1127*10/115200=0.09783 seconds of serial wire time. Bulk debug UART traffic
therefore cannot explain most of the visibly slow run. This calculation does
not measure formatting, per-call depth bookkeeping or any underlying renderer
cost; official-firmware testing still separates those factors. The720 reported
root-call returns remain diagnostic observations, not a qualified physical FPS.

## Corrected game runs on the4096-stack diagnostic; official VDP restored

The Author returned the card and restarted the Agon. The corrected production
reached logged root-return120 without a panic. Its maximum observed nesting is
six, with the deepest new chain2000/2002/3008/3000/505/504 (scHeading/scInterpolate
and generated scalar helpers). Minimum reported stack headroom is164 bytes,
including instrumentation: sufficient for this observed run, but a small margin.
Between logged calls3 and120, host UART arrival timestamps give1.1856 root-call
returns/second. These are sparse diagnostic observations, not direct scanout
measurements. The slowdown persists with the corrected scene assets.
Raw bytes, arrival metadata, identities and limitations are in
`evidence/hardware-production/stack4096-candidate-wait/diagnostic-summary.json`.
That capture was stopped deliberately and its serial handle closed before flashing.

Official release VDP2.16.0 was then restored at0x10000. All three release
segments (bootloader0x1000, partitions0x8000, application0x10000) independently
passed esptool flash verification. MOS and the card were unchanged. Evidence:
`evidence/hardware-production/official-inline-restore/`. The current installed
firmware is the official release, **not either diagnostic image**.
A new passive capture `official-inline-live` is armed; the Author was asked to
restart the whole Agon and confirm visible continued operation. Merely flashing
the ESP32 does not restart the eZ80 application or reinstall resident buffers.
H2 remains open until that official-release physical check succeeds.


## H2 complete — Author confirms corrected startup on official VDP

The Author's exact response was: "yes it is running, slowly. i did not power
completely down, just used the reset button, which should reset vdp and mos,
same as cycling power should". Record this as a board reset, without inferring
that it proves cold power-cycle equivalence. It does establish visible continued
operation after the specific reset on independently verified official VDP2.16.0.
No game or firmware change was made after that confirmation.

The stock passive capture was deliberately stopped at20:46:49UTC; its handle
closed normally. Its194 raw bytes contain two normal SDK watchdog-removal boot
warnings and no captured panic/backtrace or R19 diagnostic marker. Serial silence
alone is not proof of rendering; the Author supplies the visible-run evidence.
Capture hashes, exact acceptance scope, production/firmware hashes and reset
method are in `evidence/hardware-production/official-inline-restore/acceptance.json`.

Golem correction commit: `f9e7d8d0d0d105c26cc2ee8c2f30a2267a905895`.
Rally retains the deployed95,822-byte production executable SHA256
`64c8b0734bcd253112d162173fc38f343eafbc96894dc1d09b4793766ed59129`,
matching oval.vdp/oval.clr, and `run . oval demo`. The fresh production build
reproduces the card files exactly. All66 frozen poses pass on these scene assets.
The compiler's14 ASan/UBSan suites remain matched to its current source hashes.

H2 is checked and checkpointed under the standing frozen-goal commit instruction.
The game still renders slowly without diagnostic firmware: the current lowering
has not delivered a practical hardware acceleration. Its diagnostic164-byte
minimum stack margin is also small and does not establish every-path safety.
Final native regression/timing documentation and R19-12 delivery remain separate.
No remote push, new flash, deployment or GUI launch accompanied this checkpoint.
