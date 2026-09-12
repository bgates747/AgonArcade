# Rally on the Intel Mac — 2026-09-11

1. Read migration handoff and canonical Mac workflow. Starting checkout was
   clean at `a981184`. No gameplay, tuning or generated asset changes.
2. Created root `.venv` with Python 3.13.2. Installed Pillow 12.3.0 and the
   existing Mac `agon-utils` checkout editable; import, hello check and
   `pip check` pass. This checkout reports agonutils 1.0, so it is not claimed
   identical to the Linux 1.1.0 asset-generation environment. Existing Blender
   4.1.1 is accessible through `~/.local/bin/blender`; no model regeneration.
3. No Intel agondev release was available in the inspected stable/nightly
   assets. Began an isolated source build under
   `~/Agon/mystuff/toolchains/agondev-intel`, then stopped it after the user
   offered the existing Linux compiler. Its incomplete source/build files are
   preserved, but it is not installed on PATH or qualified as a toolchain.
4. Added `rally/tools/build_linux.py`: transfers a source snapshot to a unique
   temporary build directory on the pinned SSH alias `agon-linux`, compiles,
   runs sanitizer checks, and retrieves a SHA256-verified binary. The existing
   Linux game checkout is untouched. Build evidence is retained remotely and
   in ignored `rally/bin/linux-build.txt`. `make -C rally` uses this route when
   `agondev-config` is absent; `make -C rally remote` selects it explicitly.
5. Native Linux build and Linux/Mac ASan/UBSan host checks pass. Candidate is
   99,312 bytes, SHA256
   `2f683dc2ff412b7aadc828fd6778e70f6ba765f0b5810213de5f46fcadbeed84`.
6. Profile preparation now accepts `--runtime` and defaults on macOS to the
   installed official `~/Agon/fab-agon-emulator` (1.2.4). Canonical setup pins
   MOS 3.0.2 and creates the real profile launcher. Verified the binary-only
   mapping and CRLF autoexec: keyboard selection, `cd /rally`, `load rally.bin`,
   `run`. Launched the generated profile-local wrapper using Cocoa, leaving the
   graphical instance open for human review. Log: `rally/.emulator/review.log`.
7. Human Mac gameplay validation and explicit commit approval remain pending.
   No physical SD deployment or performance acceptance is claimed. All changes
   remain uncommitted; root TODO.md retains the existing gameplay priorities.
8. A separate headless Mac run through the same canonical wrapper captured
   Rally's road, panorama, traffic, player and PRESS ANY KEY TO RACE prompt.
   Capture evidence is in ignored `rally/.emulator/capture/frame-600.png`.
   The capture process reported the known shutdown mutex exception after its
   requested SDL quit. The first graphical instance also subsequently exited
   with that exception; its close trigger was not observed. Reopened the
   graphical review instance. No shutdown fix or performance claim is implied.
9. RALLY-10 iteration 1 authorized: user confirmed 120 raw clock ticks/second
   and requested incremental performance work with emulator review alerts.
   Added opt-in stock post-swap alternating GP fence, terminal five-second
   reply timeout, consistent counter reads and bounded in-memory timing records.
   Existing motion coefficients and steering cadence remain unchanged.
10. Native build (103,841 bytes) and both host sanitizer suites pass, including
    new stale-token/timeout/wrap checks. Four serial 20-second Mac samples in
    forward and reverse A/B order yielded baseline counts 69/111 and fenced
    counts 101/100; all 201 fenced submissions received replies, no timeouts.
    Initial apparent gain did not survive reversal. Projection dominates the
    steadier samples; hardware cost and performance remain unqualified. Raw
    evidence and limitations: `docs/research/rally-timing-2026-09-11/README.md`.
11. Separate native captures show fenced rendering on both tracks and
    tri-oval demo takeover/manual HUD/MOS exit. Arrow events were injected, but
    the selected stills do not independently establish steering response.
    Host steering checks pass; human controls/feel review remains necessary.
    Capture quit reproduces the known Mac shutdown exception. Refreshed and
    launched the graphical profile with `run . oval fence` for user review.
    No hardware deployment or commit; RALLY-10 stays open for the next decision.
12. User established task organization: root TODO.md is a simple linked
    checklist; detailed documents use task-ID filenames under docs/tasks, with
    task-owned scripts/results in matching subdirectories. RALLY-14 records
    deeper emulator/VDP instrumentation and MOS timing callbacks. Handoff files
    remain unchanged. User authorized RALLY-10 controlled comparisons, requiring
    headless performance tests and graphical launch only for review notification.
13. RALLY-10 iteration 2 adds fixed 64-pose workloads, scenery/traffic/reflection
    switches, a reduced-instrumentation comparison, and separate geometry/band
    timing. Two warm-up frames initialize both buffers; normal physics and
    steering remain unchanged. Native binary is 106,761 bytes. Mac/Linux
    sanitizer checks pass, including fixture equality and road-stream parity.
14. Twelve serial headless samples plus a focused four-run reflection repeat
    agree on pose hash/road payload and record 896 successful measured frame
    acknowledgments, no timeouts. Band generation/stream construction is the
    largest measured Mac stage; with geometry it is about 74% of batch time.
    Traffic has a smaller submission cost; no large consistent scenery or
    reflection gain is established. Detailed timing overhead was not resolved
    above variation. Results: docs/tasks/RALLY-10/results/2026-09-11-controlled/.
15. Separate headless captures verify full/omitted-scene variants, reflection,
    normal demo takeover, +9 steering after Right input and MOS exit. The full
    and reflected selected stills differ only in the player region. Requested
    capture quits expose existing shutdown instability; one SIGSEGV variant is
    recorded without claiming its cause. No hardware test, optimization or
    commit. Graphical normal-demo profile prepared for user review notification.
16. User authorized replacing runtime band search with precomputed boundaries,
    then requested freezing the contract and prior changes first. The frozen
    contract is `docs/tasks/RALLY-10/band-boundaries-contract.md`. A verified
    59-file archive, including the prior binary, HEAD identity, hashes and
    worktree/index patches, is retained under
    `.research-cache/checkpoints/rally-before-band-table-20260911-222616/`.
17. RALLY-10 iteration 3 adds optional `fixedbands`: 2,408 precomputed boundary
    lists covering 16-world-unit sections on both tracks, preserving projection,
    materials and strip emission. Tables use 22,725 bytes. A single universal
    table required 65 geometric bands; the command buffer could be enlarged,
    but the shorter-section choice reduces unnecessary command volume.
18. Mac/Linux ASan/UBSan checks pass, including 334,053 independent sampled
    views with maximum 0.449707-pixel centreline error and all 202 material
    patterns per table. Maximum stream is 3,945/4,096 bytes, 32 bands. Header
    regeneration is exact. Native binary: 129,831 bytes; SHA-256
    `5a6749f16ff6e7de9a17932771c8cf7454bdebf3c8bd117c5d3afb1c4477f684`.
19. Headless ABBA on each track gives 512 acknowledged measured frames with no
    timeouts. Mean batch cost falls 26.8% on the oval and 25.0% on Fuji; the band
    stage falls 55–61%. Road bytes increase 52.1% and 28.0%, respectively.
    Evidence and limitations: `docs/tasks/RALLY-10/results/2026-09-11-bands/`.
    Actual VDP operation timing and physical-hardware performance remain open.
20. Separate headless native captures show continuous edges on both tracks,
    candidate demo takeover, +12 steering after Right, and Escape to MOS. The
    known native mutex exception recurs on requested emulator quit after saved
    captures. The candidate is ready for graphical human review with
    `run . oval fixedbands fence`; the default runtime remains greedy. No
    commit or hardware deployment. User requested buffered VDP commands for
    reducing UART traffic as the next discussion, after this review iteration.
21. Prepared the canonical default profile with `run . oval fence fixedbands`
    in autoexec and launched its graphical wrapper for review (PID 77106).
    Cocoa video driver and live process verified; log is
    `rally/.emulator/review-bands.log`. All preceding automated runs were headless.
22. User requested an even 120 road rows while discussing bitmap striping.
    RoadTop changes from 103 to 104; bottom remains 223 and horizon remains 96.
    Regenerated section band tables (21,619 bytes) and extended scenery to
    1024×104, verifying all original 103 rows are pixel-identical. Updated
    projection-edge expectation and current documentation. Linux build and
    sanitizer tests pass, including unchanged 0.449707-pixel sampled band error
    and 3,945-byte worst-case capacity. Binary is 129,237 bytes, SHA-256
    `d08300dc7c0b4ab9b55dbbafc7cf3ba02c1f6e9cb42b8b828385751e1e6aa920`.
    Build evidence: `agon-linux:/home/smith/Agon/mystuff/rally-mac-build.tF9d3j`.
    Earlier performance comparisons remain evidence for the 121-row build;
    this adjustment does not implement bitmap striping or buffered-command reuse.
    Headless native captures at `rally/.emulator/captures/controlled-osiu_762/`
    show the adjusted road/scenery join and Escape to MOS; requested emulator
    quit still produces the known mutex exception after capture. Prepared the
    fixed-band autoexec and launched the graphical review wrapper, with output
    at `rally/.emulator/review-120-rows.log`.
23. User authorized a temporary experiment retaining pavement, vehicles and
    background but removing kerbs and road lines, with all experiment code in
    a task bucket. Added `docs/tasks/RALLY-10/pavement/` with a derived renderer,
    focused tests and a runner that injects it into an isolated source copy.
    Mainline source and binary hashes are verified unchanged. Both baseline
    and candidate build on Linux and pass sanitizer checks; candidate stream
    samples have at most 651 bytes/23 bands and are independent of stripe phase.
24. Eight headless ABBA runs on identical poses yield 512 acknowledged frames,
    no timeouts: full-markings 7.81/8.74 FPS equivalent versus no-markings
    14.01/13.64 on oval/Fuji. Candidate frame times are 71.35/73.31 ms, or
    4.28/4.40 times the 60 Hz budget. Physics is excluded. Existing projection,
    including paint classification, is retained to isolate emission/segmentation.
    Evidence: `docs/tasks/RALLY-10/pavement/results/README.md`.
25. Headless native captures retain pavement, cars and scenery without road
    markings, and exercise steering and Escape to MOS. Requested emulator quits
    fail after capture with the prior SIGABRT/mutex or SIGSEGV shutdown patterns;
    causes are not resolved here. Candidate binary SHA-256:
    `fb27f734e737b017578213451b19fb905d9649a6c6b1687eeede0dcb2aad4102`.
    Human review uses a separate task-owned profile; no mainline promotion,
    hardware deployment or commit.
