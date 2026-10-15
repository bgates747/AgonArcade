# Standard full-scene wire census and buffered alternatives

2026-10-15, WIRE-001-01. The900-frame Fuji control emits **1,673,633 recurring application bytes**, averaging **1,859.59bytes/frame** (range1,521–2,339). The road accounts for73.69%; traffic/signs17.66%. These are executable serializer counts, not estimates from screenshots. The [verification receipt](evidence/verification.json) and [frame CSV](evidence/wire/frames.csv) preserve the totals. Normal and ASan/UBSan host executions produce identical complete command streams, including setup; the target CPU sink independently matches the recurring total and final station/phase. It does not capture every target byte or draw a picture.

| Component |900-frame bytes | Mean/frame | Share |
| --- | ---: | ---: | ---: |
| Road/grass/bottom erase |1,233,333 |1,370.37 |73.69% |
| Six opponents, signs, matrices/clipping |295,614 |328.46 |17.66% |
| Panorama/scroll/clipping |58,974 |65.53 |3.52% |
| Repainted static footer |34,200 |38.00 |2.04% |
| Frame viewport changes |27,000 |30.00 |1.61% |
| Player |20,700 |23.00 |1.24% |
| Swap |2,700 |3.00 |0.16% |
| HUD |722 |0.80 |0.04% |
| Title panel |222 |0.25 |0.01% |
| Changed engine pitch |168 |0.19 |0.01% |

The control has10,093 bands,44,679 quads,5,400 opponent draws,711 sign draws,397 scroll frames and399 repaints. Existing HUD/panel retention and changed-only audio work: do not discard them when replacing geometry. It has no per-frame completion request. No finish line is visible in these900 frames; the emitter is included and source-audited, but its24-rectangle visible path needs a separate candidate case. Gameplay phases/crash visuals are likewise outside this wire control; actual-player capacity uses its separate workloads.

Setup emits124,461bytes for cars/colour expansion, panorama, signs, matrices, fonts and engine setup. Mode/keyboard/MOS boot handshakes are outside that figure. This is138.29bytes/frame amortized over900 frames, or a nominal1.08seconds of serial wire time; upload/parser/raster work adds cost. Recurring setup is not folded into the steady-frame number.

## Complete traffic models

Stock API encoding used here: buffer CALL6bytes; contiguous multi-byte SET patch11-byte header plus payload (six-byte buffer prefix, operation byte,16-bit offset,16-bit count). Resident buffer-to-buffer copies are ordinary byte copies. They save upstream bytes but consume VDP interpreter work and resident RAM. No proposal below moves projection, width, physics or other complex arithmetic onto the buffered API.

| Candidate | Existing recurring cost | Proposed upstream cost | Interpretation/status |
| --- | --- | --- | --- |
| Road band, four layers |108B |11B patch +36B final coordinates +6B CALL =53B | Retained model; copy16 x words and two y words into resident plot templates; fixed colours in unpainted variant |
| Road band, five layers |135B |11+44+6=61B | Retained model;20 x words/two y words, fixed painted colours |
| Whole road control, same bands/rectangles |1,370.37B/frame |662.65B/frame | **51.64% modeled saving**, including every patch/CALL and unchanged30B grass/bottom rectangles. Does not assume a CALL alone sends the frame |
| Opponent matrix+bitmap+draw |44B/object |11B patch +11B parameters +6B CALL =28B | Retained model: xx/translation/y-scale16-bit, x/y16-bit, bitmap8-bit. Fixed slot template; packed plane copied into command fields. Six cars save96B/frame; no transform math in VDP |
| Sign with two viewport changes |74B/object |28B object +2*6B resident viewport calls =40B | Same object reuse; no special incompatible renderer. Clip identities remain phase-specific |
| Direct bitmap-only sequence |17B |11+4B coordinates+6=21B | Direct emission is smaller. Do not apply a patch+CALL mechanically everywhere |
| Player including mirror/reset |23B |22B with five packed parameters, or19B with a per-pose template and x patch | Small saving; lower priority than road, preserve fixed ground anchors and reflections |
| Fixed viewport and activating MOVE |15B |6B CALL |9B saved per static viewport. Dynamic panorama clip rectangles need parameters and separate costing |
| Static footer plus bottom erase |38+15=53B/frame |Initialize/cache each page, then no recurring erase/redraw while unchanged | Retained family-wide candidate; remove erasing and resending together, invalidate both page histories on phase/mode changes |
| HUD/panel/audio |Already changed-only byte emission |Keep current retention; avoid unchanged formatting too | Main opportunity is CPU work, not blanket replacement with templates |

Road templates need roughly0.6–0.75KiB per four/five-layer variant if each x/y word is copied with its own15-byte resident copy instruction, plus the existing108/135-byte drawing sequence and compact parameter planes. Two variants with two frame-owned44-byte planes are roughly1.5KiB before IDs/dispatcher bookkeeping. Budget the actual emitted package before acceptance; the larger resident command stream may be slower for VDP to interpret even while sending fewer bytes. At minimum, each buffer upload adds8B plus its body, with6B clear per buffer where used. Amortize those setup bytes over measured frames and include owner/memory occupancy. Sign/car template copies have the same interpreter-versus-wire tradeoff.

A plain stock completion tail adds **7 upstream bytes/frame** after drawing/swap; the requested keyboard reply is **6 downstream bytes/frame**. If a master frame-buffer CALL is added, count another6 upstream bytes unless already counted above. Real keyboard/clock/protocol traffic is additional; downstream traffic has its own direction and service cost. The old control sends a3-byte swap and supplies no explicit completion measurement. The earlier qualified notification probe used single-buffer mode8; double-buffer completion/presentation ordering still requires testing before game integration.

## CPU, blocking transfer and ownership

The target CPU sink measures unchanged dense road/scene preparation separately from command construction, greedy band fitting, final vertices, HUD formatting and SDK serialization. Its sink functions are in a separate translation unit with no LTO, so the caller must construct bytes exactly as for an opaque MOS call. It includes counter-call overhead, ordinary MOS/PRT interrupts and setup/reset differences are disclosed in RESULTS. The sink consumes bytes without transmitting them; it cannot measure CTS blocking or VDP service.

At the documented nominal1,152,000baud/8N1, the recurring mean alone takes **16.14ms/frame on the wire**, excluding software overhead and backpressure. At30FPS that is55.8kB/s,48.4% of the ideal115,200B/s payload rate. Treat this as a bandwidth floor, not measured blocked CPU time or saturation. MOS `serial_PUTCH` waits for CTS and transmitter holding-register availability; `mos_puts` uses the synchronous RST18 block writer. These waits stop foreground physics in the current design. Count/model evidence does not establish their duration; **actual UART/CTS intervals and completed pipeline timing remain PACE-001-02**, together with candidate comparison. CPU and serial/VDP intervals can overlap; do not simply add them as independent frame times.

Only publish a new immutable snapshot/parameter plane after the prior frame's completion releases it. Preserve eZ80 world state separately, retain drawing order, and keep CPU geometry/command generation bounded or resumable between physics deadlines. Page-specific sky/HUD/panel/footer histories track the page actually drawn. A resident template shared by opponents and signs must not be repatched while an older execution still uses it; prove command-copy/queue lifetime or allocate separate frame/slot storage. Completion callback work remains a small publication, not an ISR renderer.

## Sources and next choice

Source-backed protocols: local official [Buffered Commands API](/Agon/agon-docs/docs/vdp/Buffered-Commands-API.md), AgonDev `src/lib/libvdp` serializers recorded in build.json, [MOS serial implementation](/Agon/agon-mos/src/serial.asm), and [VDP UART configuration](/Agon/mystuff/agon-vdp/video/agon.h). No firmware or SDK change was made.

Nominate shared lookup/sparse projection with an explicitly coarser variant, then a simple road-buffer prototype. Compare both CPU and complete emitted traffic against this dense control: the recovered conservative direct lookup increased road traffic32.88%, whereas its table/cache eliminates much repeated computation. Retain faster approximate candidates for Author motion review. Neither this byte model nor the CPU sink proves a game FPS gain or selects a real-time physics cadence.
