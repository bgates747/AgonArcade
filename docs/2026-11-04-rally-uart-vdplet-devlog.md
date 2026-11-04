# Rally development log — UART overlap and current VDPlet services

2026-11-04, America/New_York. The Author requested this review while running
the new Console8 fixture. This is local source/evidence review and notes for
discussion, without builds, emulator runs, machine reservations, firmware
changes or messages assigning work to another owner. The hardware fixture and
its frozen source/runtime remain unchanged.

## Findings that affect our next decisions

1. **Interrupt-driven UART transmission is a credible way to reclaim eZ80
   computation during output.** Eirene's smaller sender has physical Console8
   evidence retaining about 86% of its no-traffic foreground calculation rate
   while transmitting flat out, at essentially stock bulk throughput. This
   fits our requirement to keep physics moving while rendering proceeds.
2. **Rally must explicitly adopt it.** Ordinary RST18/`mos_puts` remains
   synchronous. Our current `fs::send` calls `mos_puts`, and numerous helpers
   pass short stack arrays. Replacing its body with a borrowed async call would
   introduce invalid source lifetimes and would not make a useful integration.
3. **VDPlet now supports direct writes to hidden colour-framebuffer rows.**
   Our road already generates a 320×120 image in VDP memory, then plots it as
   a bitmap. A native row backend could generate those same spans directly
   into the drawing page, removing the intermediate road bitmap and its plot.
   This is a separate renderer experiment; no Rally speedup is measured yet.
4. **Asynchronous eZ80 output does not make native VDP calls asynchronous.**
   VDPlets still run synchronously in the VDP command task and must return.
   CPU transmission, remote execution, raster completion and presentation have
   different completion conditions. Preserve one bounded render in flight and
   render the latest state when ready, without catch-up renders.
5. **We have two relevant startup lessons.** Eirene's default IRQ-table
   initialization defect has a physically checked correction. VDPlet clients
   must also receive/validate a mode reply before starting subsequent runtime
   traffic. These need exact source/API review during any future port; neither
   is permission to change the current test or replay old failed profiles.

## UART: what changed and what the measurements mean

The current practical candidate is the Eirene RC2 single-buffer sender, derived
from Tom Morton's small implementation. The older agon-mos implementation has
session discovery, three descriptors and optional copied RST18 output; those
contracts must not be mixed with RC2. The old isolated
`agon-emos-uart0` UTX-001 ZDS size failure is historical, not the latest Eirene
integration result.

The matched Console8 TR-001 comparison used stock Bistromathics 2.16.0 and
three repeats per workload. A work step is the same checked xorshift
calculation in every arm; this measures available foreground calculation,
rather than exclusive CPU utilization.

| Measurement | Official stock MOS 3.0.2 | RC1 | Smaller sender, later RC2 implementation |
| --- | ---: | ---: | ---: |
| Bulk payload with calculation, decimal kB/s | 106.251 | 106.142 | 106.246 |
| Paced useful calculation, steps/s | 7,082.51 | 11,618.26 | 11,658.97 |
| Paced calculation gain versus stock | baseline | 64.04% | 64.62% |
| Bulk useful calculation, steps/s | 0 | 11,583.36 | 11,646.71 |
| Bulk calculation retained versus no traffic | 0% | 85.52% | 85.99% |

Stock's zero bulk work means its foreground sender blocks the fixture; it does
not mean the CPU cannot service interrupts or has no physically idle cycles.
Paced payload was about 44.1 kB/s. Each trial transferred 8,192 payload bytes
inside 8,448 wire bytes. The new sender preserves essentially the wire rate
while allowing calculation to overlap it. Short sequential trials on one
board do not establish indefinite rates or a Rally frame-rate gain.

The smaller sender is 286 instruction bytes plus 9 bytes of state, versus
RC1's 476/11. An optional fixed C callback gate costs 29 application bytes.
RC2 removes broad context/foreign-owner checks and makes those conditions
caller obligations. Ordinary startup/output remain synchronous unless the
application explicitly opts in.

Sources: [TR-001 physical comparison](/Agon/mystuff/eirene-mos/docs/tasks/TR-001/hardware-results.md),
[earlier five-way PERF2 comparison](/Agon/mystuff/eirene-mos/docs/tasks/TM-001/hardware-perf2-r01.md),
[caller contract](/Agon/mystuff/eirene-mos/docs/uart0-async.md),
[sender assembly](/Agon/mystuff/eirene-mos/src/uart0_async.asm).

### API and ownership we would actually implement

| Event/call | Meaning for Rally |
| --- | --- |
| RST.LIL08h, A=42h | Submit one borrowed immutable source; HL=source, BC=positive 24-bit length, DE=callback or zero |
| Return 0 / 1 / 2 | Accepted / BUSY / INVALID; rejected work remains caller-owned |
| Source-release callback | Last source byte entered UART hardware; source can be reused, but wire/VDP work may remain |
| RST.LIL08h, A=43h | Nonblocking finish; success requires local transmitter empty and restores the stock UART handler |
| Ordered remote reply/drawing fence | Separate evidence that the VDP reached the required execution/completion point |

There is one outstanding borrowed buffer, with no built-in queue or implicit
app-exit cleanup. Call in foreground ADL1/MBASE0, interrupts enabled, with sole
UART0 ownership and normal setup. Finish before ordinary output, printing,
conflicting MOS/SD operations or returning. BUSY is not admission and a timeout
does not release an accepted source.

The callback runs with interrupts disabled on the interrupt stack. It may post
a flag/counter and return; no MOS calls, output, allocation, waiting, EI or
nested submission. Arm the flag before submission because completion can
precede the next foreground instruction. Raw MOS preserves AF/BC/DE/HL; use
the supplied fixed-target gate for C code that may touch IX/IY/alternate banks.
Keep source and callback code resident until released. Receive processing,
including ordinary MOS VDP/key handling, continues through the combined path.

The sender refills at most one 16-byte FIFO per service, using OTIRX and a CTS
check per block. CTS-change handling resumes blocked output. This is neither
DMA nor an arbitrary unguarded full-transfer burst. It reduces foreground
waiting and service cost; it does not raise the physical baud rate.

### Integration and startup status

Published RC2 source/tag is `825eaf77176247f5b5ba2f940ae73fcace34e7e5`;
its 100,950-byte image SHA256 is
`a47130d78b70fa1e0e54aa61e4340831036d766a0c59e2738935bd9d04b94a3a`.
It is a prerelease, not an upstream/stable MOS allocation. Its branded image
was originally related to the qualified trim by unchanged sender objects;
the later IRQ campaign also actually tested original RC2.

The inherited startup called default-vector initialization before clearing
the BSS containing that table. Three handlers installed later masked the
defect in UART0-focused testing; 45 defaults were erased. IRQ-001 moved the
call after BSS clearing. Actual Console8 cold/warm tests reproduced the
original and checked all 48 corrected slots, 96 vector install/restore pairs,
two UART regressions and nine PERF2 trials. Corrected image CRC32 is
`DBE3E21E`; the sender is unchanged and bulk useful calculation remains 85.987%
of calibration. Current Eirene checkout HEAD observed during this review is
`1e5f3bc3955508d6a902ddad7ea33d25d908c0f2`. Do not select the older RC2 tag
merely because it is a published download and overlook this correction.

Extender's Eirene-based EMOS integration is further along than historical
UTX-001. Its corrected installed source is
`16ec1f78c7ead1f38378c5ee9bee4633bcb62c1d`, full-ROM SHA256
`f62eed7f6bab8c164dcfe5e700132d289d52352f19d955acccbe1cff81b5e893`.
Two physical Olimex Legacy/native-VDP functional invocations each compare all
8,192 receiver bytes, and the original C example passes. This preserves the
RC2 API while restricting submission to the mainboard route and refusing
route mutation until explicit finish. UART1/P4 async operation, matched PERF2
performance and the full paired acceptance suite remain separate.

Sources: [RC2 publication](/Agon/mystuff/eirene-mos/docs/tasks/RC-002/publication.md),
[IRQ physical before/after](/Agon/mystuff/eirene-mos/docs/tasks/IRQ-001/hardware-results.md),
[EMOS source port](/Agon/mystuff/agon-extender/docs/tasks/EMOS-001/R01-SOURCE-PORT.md),
[EMOS physical reuse results](/Agon/mystuff/agon-extender/docs/tasks/EMOS-001/TEST-REUSE-RESULTS-R01.md).
These identify evidence, not what is currently flashed on the Author's C8.

## VDPlet: capabilities relevant to Rally

Reviewed the new owner's handoff, current API/header, usage guide, capacity
guide, task register and supporting results. Maintained checkout HEAD observed
is `10947e04db4635daf6c9497cf826e7105ed8f817`; working-tree evidence has its
own scope. Rally's old firmware `8da2ebfd…`, native module `479fe1ac…` and SDK
export stay frozen. New services require a separately selected composition,
source pin, build and qualification rather than assuming they exist in C8's
included `vdp_rally.bin`.

| Facility | What exists now | Rally implication |
| --- | --- | --- |
| Scoped colour drawing rows | Optional ABI1.6, capability256, 84-byte table; `--borrow-rows` with pixels/pixels-lean | Generate opaque road spans directly into hidden physical drawing rows |
| Generic copied pixels | ABI1.3 surface discovery and RGB222/INDEX8 rectangles across supported native formats | Useful control/fallback, but still validates/copies an already generated image |
| Native VDU fonts | INFO24 profile6; published fixed-width font/glyph/select/restore support | Could move HUD emission/formatting into native work later without inventing a new font hook |
| Native ordinary buffers | INFO24 profile7; published bounded WRITE/CREATE/CLEAR/CONSOLIDATE | Module can manage assigned scratch buffers; not arbitrary buffer-program execution |
| Bounded readback | Optional operation6, INFO26, 1–8 bytes per reply | Cheaper telemetry/final dumps; separate callback format and actual firmware availability |
| Bitmap/affine use | Existing profile4 native VDU support | Still available; new row service does not establish affine is slow or replace pending cache experiments |
| Audio | Several optional PCM/queue compositions with different lifetimes/gates | Richer future engine audio, but unrelated listening failures/publication gates must not be hidden |

ABI minors0–6 preserve exact older prefix/table views. Check structure size,
capabilities and callbacks, not a firmware filename or equality against one
mask. There remains only one active native module; calls are synchronous and
finite. No generic native filesystem/raw serial/background callback service
or periodic independent VDPlet physics task has appeared.

### Direct rows: promising, but obey the actual pixel layout

BEGIN pauses/drains Canvas without a vblank and admits an in-bounds rectangle
on actual double-buffered SBGR2222 storage. ROW returns each row separately;
rows can occupy different pools, so deriving the next row from a stride is
invalid. END resumes Canvas; normal RUN cleanup closes outstanding access.
Pointers cannot survive END, return, a page swap or mode change.

Pixels use `data[(x_bias+x)^2]`, with `color_mask=0x3f` and
`preserve_mask=0xc0`. Preserve VGA sync bits in each destination byte. Our
existing road image uses opaque **AABBGGRR** bytes (`0xc8`, `0xd5`, etc.);
copying those raw bytes into physical rows would overwrite sync bits. Apply
the documented representation rather than treating the two formats as equal.
Do not use an ordinary constant-byte memset across physical pixels unless
the relevant preserved bits/layout are established.

VDU submission, copied pixel writes and native line batches refuse while a
row lease is open. Finish direct road stores before actor/HUD Canvas work.
The first experiment should retain geometry, edge stepping, scene, actor
sampling, HUD, sky and presentation; change only the road's output target.
Our current intermediate road is 38,400 bytes, so this removes one image's
generation target/plot path, not all frame cost. Per-row service and protected
store cost could offset savings; measure complete rendered FPS.

Generic row qualification covers 5,437,440 decoded pixels/25 groups across
both engines, plus a separate ARM mechanism cohort. Real FSIM/MOS consumer
checks exist. Those establish functionality in those scopes, not a physical
Rally gain. The actual frame-cost comparison and human/physical gates retain
their owners' stated limits.

### Fences, fixes and memory boundaries

1. An ordinary host-issued `VDU 23,0,0xCA` drains drawing with no new-vblank
   wait; it returns no packet and is not admitted by native `vdu_submit`.
   An ordered following query/reply is needed for host-observed completion.
   Native return generally means drawing submission, not completed rasterization.
   C3 presentation has its own VSYNC behavior. Preserve the current completion
   boundary when comparing candidates.
2. Before runtime traffic after a mode change, receive/validate its MOS mode
   reply. The new owner documents clear-mode-flag, complete mode command,
   bounded wait and actual geometry/mode validation. Our fixture installs its
   callback and LOADs before `vdp_mode(136)`; audit its pinned AgDev helper and
   callback handling before adapting the newer startup guidance. This is an
   ordering question, not proof that our old failures had that cause. Check
   actual Eirene flag/API equivalents; do not guess syscall compatibility.
3. VDPL-018 privately incorporates the UART owner's ESP32 receive-lock-order
   fix, with finite engine qualification and a separate Wolf row-enabled
   composition. It addresses a fullflag/masked-receive race. It is separate
   from eZ80 async TX and does not establish that Rally's historical CTS
   stalls are fixed. The older firmware is not silently repaired by using a
   different MOS.
4. VDPL-020 privately corrects narrow buffered conditions that retained FF
   upper bytes. It is tested, but human/publication/default adoption remain
   open. Do not make stock-compatible Rally buffers depend on that private
   correction without an explicit choice.
5. Maintained native module builds now default to the classic ESP32 PSRAM
   workaround for compile/link/matching libraries. That policy is now
   published (`9738926`), superseding its earlier uncommitted-policy status.
   Frozen consumers are unchanged. Rebuild size/maps/library hashes matter:
   our accepted module had only 504 bytes of its selected text budget left.
6. Larger optional admission ceilings reach 64 KiB text/16 KiB data/128 KiB
   package, but contiguous internal executable memory and display allocations
   decide actual fit. Tested double-buffered capacity can refuse about32KiB
   code while a smaller mixed module fits. These are not a promise that a
   larger Rally image fits. VDP task stack minimum is not eZ80 headroom.
7. VDPL-023 display allocation hardening is still at reproduced original-source
   faults and a proposed correction boundary. No allocator fix is qualified.
   Keep this distinct from the older optional failed-mode-release behavior.

Primary references: [handoff](/Agon/mystuff/agon-vdplet/docs/HANDOFF.md),
[API](/Agon/mystuff/agon-vdplet/docs/API-reference.md),
[native header](/Agon/mystuff/agon-vdplet/include/vdplet.h),
[mode fence](/Agon/mystuff/agon-vdplet/docs/mode-transition-fence.md),
[capacity](/Agon/mystuff/agon-vdplet/docs/capacity.md),
[compiler publication](/Agon/mystuff/agon-vdplet/docs/devlog/2026-11-03-module-compiler-policy.md),
[current task register](/Agon/mystuff/agon-vdplet/TODO.md).

## What these changes could do for each Rally version

1. **Standard VDP/eZ80 geometry:** prepare a complete stable command chunk,
   submit it asynchronously and compute the next physics step or next packet
   while it drains. At least two application-owned packet areas let us prepare
   one while the other is borrowed, despite RC2 permitting only one outstanding
   transfer. Neither building nor simulation may overwrite the accepted area.
   Keep resident command programs in the binary/VDP buffers and update only
   parameters where practical. This improves overlap without pretending wire
   transfer or remote draw cost disappeared.
2. **Custom VDP/native renderer:** async TX can free eZ80 time for rules/input/
   player physics during submission/backpressure and during remote work. Our
   opponents/native tick calls are still serialized VDP work. Direct rows
   separately target VDP frame cost. Do not run extra VDP physics or enqueue
   catch-up renders just because the eZ80 can produce commands faster.
3. **Both:** keep fixed simulation pacing a measured candidate choice, with
   bounded work and preserved real-time durations. A 120 Hz goal is still
   aspirational until the actual physics-plus-transport path demonstrates it.
   Poll input and service physics during permitted foreground waits; the
   interrupt callback merely publishes completion state. Render available
   current state, allow display skips, and avoid an accumulating render queue.

The current compact fixture sends 291,568 timed outbound bytes in 900frames:
323.96 bytes/frame. For scale, those bytes alone require about2.81ms/frame
at the ideal1.152Mbaud8N1 ceiling, or roughly3ms at the cited short benchmark's
achieved wire rate. At60FPS that is about19.44k outgoing bytes/s. These are
arithmetic wire-budget estimates, not Rally measurements; they omit replies,
CTS stalls, per-call costs and all VDP execution/presentation. Async therefore
has a stronger obvious CPU opportunity in a busier standard-VDP stream, while
native frame cost may dominate this compact candidate. Read the new hardware
`stages.csv` before ranking either as the actual bottleneck.

## Suggested discussion and experiment order

1. Retrieve and qualify the Author's current C8 run first. Lead with rendered
   FPS, MOS/PRT disagreement if any, visual report, whole-run success and phase
   totals. Record actual installed MOS/VDP evidence separately from supplied
   files. Our last emulator run was nominal60.00MOS versus36.15PRTFPS with
   uncalibrated clocks; it is not a hardware60FPS result.
2. Choose an isolated Eirene async transport candidate. Reuse the supplied
   C bridge/gate and exact corrected-image contract. Preserve the old app
   baseline and frame/state work. Aggregate stack-built fragments into stable
   packets; retain one pending render and distinguish source release, local
   drain, remote draw fence and presentation. No automatic RST18 conversion.
3. Measure equivalent sync/async workloads: isolated physics capacity and
   physics during output, full completed-frame FPS, outgoing/reply bytes,
   render completion, missed simulation deadlines and clean MOS return.
   Use sufficiently long physical windows/PRT and frame counts; do not transfer
   the xorshift86% result into a claimed Rally physics rate or FPS gain.
4. Independently trial direct-row road output against the same full-race
   control, retaining every actor/sky/HUD/audio task. Change only that backend
   and its required runtime composition. Compare completed FPS and total
   preparation/drawing cost, not just native span generation. Consider direct
   actor composition or native HUD only if measured remaining costs justify it.
5. Keep the prepared-size bitmap experiment and built-in affine investigation
   available. New rows/async features do not negate either; do not combine
   all changes into one result with no attributable baseline.

These are recommendations for review, not new implementation/run assignments.
No peer request, code change, new image, emulator run, Oryx contact or card
write occurred for this research. VDPlet 2026-11-04 is the runtime/SDK contact;
the retired Golem runtime chat remains untouched. Local source hashes read for
this review are recorded beside this log in the evidence manifest.

## Subsequent Author hardware return — 2026-11-04

The C8 card returned with this candidate under `/test/arcade/rally-28`.
All supplied input hashes and20retrieved-file hashes match. The unchanged
independent state/reply verifier passes900frames/3,600steps/2,024replies and
cleanup. [Physical results](tasks/RALLY-28/custom-vdp/hardware-review-20261104/return01/RESULTS.md):
**24.68MOS FPS / 24.73PRT FPS**, with clock durations agreeing within0.194%.
Mean40.44ms/frame includes2.97ms of synchronous sending and27.92ms of reply
waiting. The waiting bucket is not pure VDP time; it includes execution and
swap/presentation ordering. It is nevertheless much larger than measured
foreground send time, so async transmission alone is not evidence of reaching
60FPS here. Independent physics scheduling remains untested; the coupled
fixture advances98.91logicalsteps/s. Direct-row output and better wait-phase
attribution are worthwhile discussion topics alongside async CPU overlap.
No new candidate or test is selected by retrieving this baseline.
