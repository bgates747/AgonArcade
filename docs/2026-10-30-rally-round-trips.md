# Rally: publication checks with fewer serial waits

Golem released the existing synchronization experiment under the Author's
standing delegation. Preparation preserves the actual race workload and puts
the same checked native module and guest binary in both arms; a config flag
removes four intermediate reads only during timed candidate frames. The final
swap fence and RUN error handling remain. Fresh complete-race results are33.09→36.57 nominal MOS FPS (+10.53%); PRT31.96→35.35 separately. Both orders improve; moving review/publication remain pending.

Owner task INC-001-05, central assignment G057-RLY-001. Scope and source live
under tasks/RALLY-28/custom-vdp/incremental/round-trips/. Acceptance/readiness
mail is durably recorded there. Golem confirms keeping the qualified old
firmware/runtime rather than changing that variable during this comparison.

Both ordinary and ASan/UBSan900frame/3600tick replays match the original complete
world, road/actor/player commands and pixel workspaces. All27 publication/lease
failure cases reject; maximum four leases, balanced cleanup and intact canaries.
Native text32264/data1004bytes, module34836bytes. Shared guest binary685f4b4c...
and module479fe1ac... differ only in config policy across the two arms.

Two60frame smoke profiles and four900frame profiles were staged on Oryx without
launch. Exclusive requestc6863feb4355 was granted and explicitly released after all runs. Historical44.96host
seconds per full fixture refined the slot estimate to6–10minutes, including
retrieval/teardown. Expected saving68outgoing/48incoming bytes per timed frame
remains a prediction until raw UART confirms it. FPS must be reported first
once measured; nominal MOS/PRT clocks remain separate from physical performance.

Preparation-only corrections: host exports originally shadowed the checked
source filename and a ctypes mutation needed immutable bytes; fixed before
qualification. The first staging campaign name contained a prohibited hyphen;
no profile or emulator was started by that refused attempt. Original source,
fixtures, archives and failures/results are preserved; no commit/push or
hardware operation was requested.

Final evidence: round-trips/RESULTS.md and RAW-AUDIT.json. All four full runs and
both smokes pass every raw request/reply, full independent final state, unchanged
nonquery frame commands, exact input/runtime pins, PRT restoration, UNLOAD and
clean MOS exit. Same-case actual timed streams repeat exactly. Outgoing352768→
291568bytes per900frames; all multiplexed returns214876→171676bytes, exactly
68outgoing/48incoming saved per frame. Native waits6→2; mean nominal PRT reply
wait13413→11878ms per run. No simulator/world/render workload change.

Session175.19host seconds, originalboost1restored1, original95°C limit retained,
full sampled maximum61°C. Preliminary console-derived58°C in the release mail
is superseded by the full guard receipt. Fresh process/maps inspection empty;
leasef67ac234... released and Golem notified. Fresh stopped compact review profile
requires a separate live central Author lease; no visible/audible run performed.
INC-001-05 remains in rootTODO for moving review and explicit publication.
