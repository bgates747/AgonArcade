# 2026-10-29 — Wider native road fills

The Author authorizes committing/pushing all current work, then testing aligned
32-bit road-span stores against the accepted additive sampler control. Scope is
[INC-001-03](tasks/RALLY-28/custom-vdp/incremental/wide-fill/README.md); no projected
speedup is treated as measured. New implementation begins after the checkpoint.

Accepted INC-001-02, RV01/RV02 and CMP01–03 are removed from unfinished TODO:
the sampler and clean MOS return passed Author visual review; matched moving
traffic gives28.46→35.35nominal MOS FPS (+24.22%), PRT+24.26%,6.85nominal ms/frame
saved. All four actual timed UART streams and complete final worlds match.
[Evidence](tasks/RALLY-28/custom-vdp/incremental/sprites/motion-comparison/RESULTS.md).
Earlier constant-gap42.4%gain and actor-counter studies remain separate. Their
publication is expressly authorized now; no hardware acceptance is inferred.
AFF01 remains pending research and no scaled pixels are uploaded in the hot loop.

Checkpoint `84fa64d` was committed/pushed and the tree was clean before the new
experiment. INC-001-03 is now complete and removed from unfinished TODO; its
immutable completed subtasks remain in the scope document. Genuine aligned
word stores preserve exact host pixels/commands/world and full target fixtures.
Fresh byte→word /word→byte comparisons pass900frames/3600ticks/2913retained
replies each, with identical347byte frame UART. Pooled nominal MOS throughput
is36.999→36.327FPS(-1.82%), PRT-1.85%; pairs disagree(-6.11/+2.79%). This does not
establish a benefit. Keep the accepted byte-fill/additive renderer.

The separate no-physics/no-drawing80window fill replay shows52.65% fewer raw
emulated counter units. It overlapped otherCPUjobs;92–94°C session temperatures
remain below the original95°C guard. Earlier full-frame sessionmax55°C. Both
sessions silent/headless, boostrestored1, ownedemulatorsstopped. The experiment
and all raw inputs/returns are preserved in
[wide-fill/RESULTS.md](tasks/RALLY-28/custom-vdp/incremental/wide-fill/RESULTS.md).
New work remains uncommitted for Author review. Candidate is not adopted;
hardware, new visual acceptance, AFF01 and INC-001-04–06 are not released.

The Author agrees to retain the previous system: accepted additive actor sampler
with byte road fills. Wider fills remain a preserved experiment. This acceptance
does not authorize publishing new dirt or executing the next optimization.
