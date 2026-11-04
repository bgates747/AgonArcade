# RALLY-28 — Native state audit findings

Research completed 2026-11-04 under NAT-001-01–06 after checkpoint commits
`c10eca3` (direct-row work) and `a77a42b` (audit contract) were pushed. No game,
module, compiler, SDK, firmware or fixture was modified; no build or emulator
was run. The new audit files are left uncommitted for review.

**The native integration retains an unnecessarily fragmented, byte-serialized
shared-state representation. Replace that representation with native-owned C
structures, small native tables and scoped access to external assets.** This
is supported by source and memory-layout evidence. Its share of frame time is
not measured yet; it is not a demonstrated explanation of the entire slowdown.

The arithmetic is already compiled Xtensa code. The current application does
not run the earlier interpreted Golem physics program. What survives is its
shared-state convention, scalar-by-scalar access strategy, interpreted invocation
wrappers and regenerated output command lists. They are separate replacement
opportunities; removing only the wrappers leaves the main access problem.

## Evidence and current execution path

Audited primary input: direct-rows/source/rows, the exact candidate that produced
39.16 nominal PRT FPS against the same-runtime bitmap control's 36.28 FPS.
Those emulator clocks remain uncalibrated. No new FPS measurement is claimed
in this source audit. The earlier physical C8 result is a different cohort.

[SOURCE-PINS.json](SOURCE-PINS.json) identifies 45 inspected inputs, including
actual a50 firmware source rather than the live owner's newest runtime.
[STATIC-INVENTORY.json](STATIC-INVENTORY.json) contains decoded installation
records, state metadata and manually derived successful-path count formulas.
[inspect_source.py](inspect_source.py) repeats the finite decoding/hash work;
it cannot execute buffered programs or native code and does not compile.

1. Four guest `fs::tick()` operations each send a six-byte CALL to buffer13.
   That buffer contains exactly 43 interpreted bytes: clear completion.ready,
   set root.requested_entry=3, and execute a silent native RUN. There is no
   route/collision arithmetic in that wrapper. Its handle is patched at startup.
2. Each RUN enters native `vdplet_entry`, borrows two-byte arguments containing
   root ID1, releases them, then borrows the 310-byte root. It checks 88 constant
   header/descriptor bytes, all seven array shapes and global value bounds.
3. Tick3 performs native route/player/opponent/contact work. Each individual
   table or opponent array read/store makes its own acquire/release pair.
   The root is already borrowed; root scalar reads do not reacquire it.
4. Before rendering, the guest overwrites all six positions and laterals with
   the deterministic visual traffic script. Render15 is a direct requested RUN,
   not the resident wrapper. The same prefix runs again, then the renderer
   takes three whole-array snapshots into a native 108-byte structure.
5. The renderer writes the road directly to hidden rows. It samples actors into
   preinstalled bitmap backing buffers and generates three ordinary VDU command
   lists. After RUN returns, the guest CALLs those lists for footer/finish line,
   actors and player; it draws HUD/sky/audio via ordinary guest commands and
   swaps. A following requested read supplies the ordered post-swap fence.

Sources: [guest packets](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/guest/include/native.hpp:32),
[frame loop and drawing](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/guest/src/main.cpp:73),
[native entry](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/checked.c:54),
[installation decoding](STATIC-INVENTORY.json),
[actual stock CALL interpreter](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdu_buffered.h:327).

## NAT-F01 — The dual-backend state model survived native-only compilation

**Source fact; high priority.** The root metadata still declares
`r25-g0-root-v1-dual-backend` and `application_shared`. The native metadata has
`buffered_entries: []`, `buffered_owned: []` and `buffered_dispatch: 0`: it does
not install the former interpreted arithmetic backend. The native header itself
says that module state stays in VDP buffers. Root-v1's 112-byte header includes
four unused role descriptors and generic conformance/status metadata; all
198 remaining bytes are named globals, including arithmetic scratch and unused
primitive test globals. Removing unused dispatch cases in ROW-001 did not
remove that representation or those root validation duties.

Historical evidence: RALLY-25/generated-state deliberately qualified the same
retained root/array images with two compiler backends. Its adapter validates
both wrapper sets and shared initial bytes. RALLY-24 Candidate A retained
resident matrix arithmetic; required Candidate B removed that road arithmetic.
The older section protocol still exists in rally-production for the standard
VDP branch and contains matrix/transform commands, but the selected native
fixture does not invoke its section draw routine. File presence alone is not
an active dependency or permission to delete the standard game's source.

**Replacement:** native-owned World/Route/Player/Opponent structures. Keep
computation temporaries local rather than publishing each intermediate to a
shared PSRAM byte image. Retain only meaningful state and compact external
inputs/events. Put legacy state export in a diagnostic adapter, separate from
ownership of the live state. Retire the generated root-v1 contract for the new
native variant rather than contorting it to require that format forever.

Sources: [interface](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/interface.json),
[backend metadata](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/backends.json),
[generated qualification](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-25/generated-state/README.md),
[dual-backend adapter](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-25/generated-state/adapter.py:93),
[native road decision](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-24/REVIEW.md:9),
[historical section commands](/Agon/mystuff/AgonArcade/rally-production/include/section_protocol.hpp:50).

## NAT-F02 — Scalar array operations repeatedly enter the checked service

**Source fact and successful-path derivation; high priority.** A single normal
active opponent reads active, clears contact, reads/writes progress, reads/writes
position, writes lateral, then rereads position and lateral for contact tests.
A collision adds one more contact store. The six-element arrays are only
12–24 bytes each, but the native code borrows slices of 2 or 4 bytes separately.

Each acquisition resolves a global buffer-map entry, verifies single-block
storage, copies shared ownership, checks argument alias protection and bounds,
scans four lease slots for conflicts/capacity, assigns a generation token and
returns a view. Release scans the slots and drops ownership. This is native
C++ service work, not the buffered-command arithmetic interpreter. It is still
needlessly repeated for this application.

Successful Tick acquire/release **pairs** are:

`24 + 7*N + C + 2*B + I`

Here N is active opponents (0..6), C is actual contact-true opponents (0..N),
B is a route-record transition (0/1), and I is sine interpolation (0/1).
The 24 includes nine prefix acquisitions, twelve base opponent-loop accesses
and three unconditional route/sine accesses. With all six slots active that
is **66–75 pairs per Tick**, or **264–300 for four Ticks**. Render contributes
`30 + 2*S` pairs, where S is the number of sampled actors (0..8), giving a
conservative whole-frame envelope **294–346 acquire/release pairs**. This is
source-derived, not a captured dynamic trace or a duration. There are also
88 constant-byte comparisons per prefix, repeated five times per frame.

For successful lifecycle calls, InitRace has nine prefix +30 initial array
stores +one asset +12 preflight +one completion =53 pairs. StopRace has nine
prefix +one completion =10 pairs. Neither performs the opponent render snapshot.
Failure branches short-circuit these counts; generated error paths release the
root, helper paths unwind their views and runtime return supplies final cleanup.
This audit did not execute fault paths; ROW-001's existing host/target evidence
remains the functional qualification.

**Replacement:** run native numerical functions directly over native state.
For a small compatibility experiment, acquire each whole external array once,
copy/decode it to aligned local/private structures, release it, process all six
slots, then export once per array. That is a transitional adapter only: the
final design should keep authoritative state in module data and stop importing
and exporting every simulated step. Never replace each scalar acquisition with
a memcpy of the entire world on every scalar access.

Sources: [scalar route/sine reads](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/checked.c:151),
[opponent loop](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/checked.c:399),
[contact store](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/checked.c:675),
[actual service](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdplet_runtime.h:78).

## NAT-F03 — Native persistent state is already available, in internal RAM

**Runtime source fact; high priority.** The module has private data already:
`static RallyRenderContextV1 renderer` retains 464 bytes across RUNs. The actual
loader allocates writable data/rodata/BSS once, initializes it on LOAD, leaves
it live between calls and frees it on UNLOAD. The a50 allocator requests
`MALLOC_CAP_INTERNAL | MALLOC_CAP_8BIT` for this storage. Ordinary BufferStream
backing uses a PSRAM-preferred allocator. Moving small state into module data
can therefore eliminate both repeated service calls and external-RAM traffic.
The actual timing benefit remains a hypothesis until measured.

Raw legacy storage is small: root310 + mutable opponent arrays96 + routes48 +
sine514 = **968 bytes**. Current module data/rodata totals1004 of its declared
4096 bytes. Even adding all 968 bytes gives1972 before changed alignment,
metadata or code-generated constants. This is a feasibility estimate, not a
new build/allocation qualification. The large149,518-byte geometry asset and
52,238-byte actor scratch set are different resources and do not belong in
this small internal state budget.

**Replacement:** aligned native structures, e.g. six 16-byte Opponent records
(progress, station, lateral, active/contact) and typed route/player state.
The exact old mutable array payload is already96 bytes; no size inflation is
inherent in this AoS layout. Copy immutable route/sine tables into module data
at bind or include exact const tables if the new build's measured budget allows.
Use one authoritative copy. Reset/session/Stop/Fini semantics must be explicit.
Module globals and pointers to their own stable subobjects can persist until
unload. This requires no new generic heap or persistent-borrow API.

Sources: [existing private context](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/checked.c:22),
[data allocation and call lifecycle](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdplet_runtime.h:62),
[loader storage](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdplet_image.h:132),
[PSRAM buffer backing](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/buffer_stream.h:55),
[allocation selection](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/types.h:47),
[measured module sizes](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/build-r02/rows/rally-render.json).

## NAT-F04 — Pointer lifetime constraints permit useful long scopes

**Runtime contract and source fact.** Four ordinary borrowed views can coexist.
Argument access is read-only/protected, but the guest can use a compact packet
of up to32 bytes. Borrowed data pointers expire on release/return. The runtime
closes all leases at return; absence of a module unload does not extend them.
Native-owned structures are not borrowed views and survive normally.

The renderer already demonstrates a better pattern: it holds the large asset
once per render and derives ten table pointers in entry-local Assets. Keep
those pointers for the whole rendering computation. A four-slot limit need
not fragment a small World into seven buffers: one World buffer could be one
borrow, or native-owned state could need none. Keep external asset/source/
destination views only for the scope that uses them; finish queued bitmap work
before overwriting/removing its backing pixels. Keep framebuffer rows scoped
and resolve rows separately; the row API does not promise contiguous storage.

Do not cast the old root image to an aligned native struct: several32-bit fields
(e.g. playerStation at198) are unaligned, and the old wire format has explicit
little-endian widths. Decode at the boundary into aligned native fields and
serialize diagnostic outputs there. Assert sizes/offsets of genuine shared
formats. Use restrict only after real non-aliasing is established; avoid volatile
for ordinary owned state and avoid strict-aliasing type-punning. None of this
requires changing numerical precision or dropping required failure checks.

Sources: [runtime cleanup](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdplet_runtime.h:331),
[renderer's good asset scope](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/helper/rally_render.c:155),
[row scopes](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/helper/road_rows.inc),
[root field metadata](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/interface.json).

## NAT-F05 — Invocation wrappers and five-way entry validation can disappear

**Source/decoded packet facts; high priority after the state rewrite.** The four
Tick CALLs save UART bytes (4×6 instead of4×17 silent RUN bytes) but interpret
4×43 resident bytes. Each stock CALL creates a PSRAM-preferred MultiBufferStream
wrapper/control object on the normal external CALL path. Separately, five RUNs
repeat generic entry work, root checks and shape checks. No runtime rule requires
five RUNs or interpreted SETs for requested entry/completion readiness.

**Replacement:** one native frame/update entry receiving compact input and a
step count, calling `world_tick()` four times directly, then rendering. Validate
packet/session once. Do not implement the step loop as four recursive native
RUNs or four buffered CALLs. Move redundant requested-entry metadata and ready
updates into the native protocol; retain an observable outer RUN result and
final presentation fence so a pre-entry failure cannot publish stale output.
A silent direct RUN is already supported. The command decoder/runtime loader
is still needed to enter the module; the abandoned game-language interpreter
need not sit between game operations.

Four logical steps per render are a comparison control only. This consolidation
must not establish a production cadence tied to rendering. Future independent
physics/render scheduling and async UART remain separate, as the Author ordered.

Sources: [Tick CALL](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/guest/include/native.hpp:54),
[decoded wrappers](STATIC-INVENTORY.json),
[CALL stream allocation](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdu_buffered.h:358),
[RUN service/lifecycle](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdplet_runtime.h:331).

## NAT-F06 — Regenerated drawing buffers remain a second interpreter layer

**Source fact; medium priority, record separately from physics.** Buffers50301,
50302 and50303 reserve20,480/2,048/256 bytes. The helper serializes ordinary
VDU operations into them, appends a six-byte buffered jump-to-end, releases them,
and the guest CALLs all three. Direct rows removed the road bitmap plot, but the
road list still contains footer/finish-line primitives. Actors are sampled into
bitmap buffers; their generated commands select/plot those already scaled
images. Player bitmap plotting follows. The source still defines a matrix()
constructor, but its presence is not proof of per-frame interpreted matrix
arithmetic: active actor output uses the sampler and existing transform IDs.

The current helper preflights all12 output/scratch resources every render,
then acquires the outputs again, and acquires each visible actor source/dest.
That includes the unused38,400-byte road bitmap in the direct-row arm. The
12-way alias check compares all prior ranges (66 pairs) plus other live objects.
Startup/bind repeats these checks too. An immutable, owned layout can reduce
repeated work, but moving checks to bind needs a real resource-identity policy,
not the assumption that a buffer ID can never be replaced.

**Replacement:** remove these command-list buffers from the future native path.
For stock primitives the existing native `vdu_submit` can consume an entry-local
span without buffered CALLs or a MultiBufferStream allocation. It still validates
and **interprets ordinary drawing commands**; it is not a native typed blitter.
The actual a50 firmware supports profile5 and VDU capability4; the present module
requests273 without that bit. A new module would declare277 and remove buffered
terminators/unsupported resource opcodes, with exact viewport and queue-lifetime
checks. This can reduce staging but must not be sold as eliminating interpretation.

A fully native typed sprite/rectangle compositor over scoped rows is a separate
option if stock drawing parsing/sampling/copies prove expensive. It must preserve
transparency, clipping, painter order and VGA sync, and avoid mixing Canvas with
an open row lease. A raw Canvas pointer or arbitrary firmware symbols are not
provided by the current ABI; such a generic extension belongs to VDPlet if
needed. Current profiles and all historical experiments stay intact.

Sources: [helper preflight](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/helper/rally_render.c:82),
[output generation](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/helper/rally_render.c:166),
[serializer](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/helper/render_core.inc:19),
[actor sample access](/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/direct-rows/source/rows/helper/sprite_io.inc),
[VDU submission guard](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdplet_runtime.h:161),
[actual span interpreter](/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video/vdplet_runtime.h:555).

## NAT-F07 — External dependencies and data authority must be explicit

**Source fact; required for a fair rewrite.** Native state cannot simply ignore
what the guest currently writes/reads. `scriptedTraffic()` overwrites48 bytes of
positions/laterals per frame after the four Ticks, specifically to exercise
relative scaling. The renderer consumes those values. Progress and contact
arrays still evolve during physics. The guest has independent route/rules/HUD
state, and reads406 bytes of legacy root/arrays at the end, outside timing.
Init reads, publication, warm renders, coverage, Stop and clean exit use the
old metadata too. There is no steady complete world readback per frame.

For the first native-owned-state candidate, import the same scripted telemetry
as explicit render overrides at the same boundary and apply its effects to the
same subsequent simulation inputs. Do not accidentally preserve overrides only
for rendering if the old position state also feeds the next Tick. Export the
old state at explicit checkpoints/end for the independent oracle; reproduce
intermediate scratch only for compatibility checks, not as live PSRAM state.
Record intentional wire-format/count changes instead of normalizing captures.
Do not use this rewrite to silently disable contacts, simplify traffic, remove
sky/HUD/audio, accelerate world time or change rounding/overflow behavior.

## Buffer disposition inventory

| Current resource | Purpose and current form | Native redesign disposition |
| --- | --- | --- |
|1,310B|Root-v1 metadata, live globals, temporary/test globals|Replace live state with aligned module structures; diagnostic export only|
|2–6,96B total|Five six-slot mutable arrays|Six typed native Opponent records; compact external telemetry only|
|7/8,48+514B|Route and sine tables|Exact native const/private tables; initialize/bind once|
|9,2B|Root-ID argument block|Replace with compact versioned native request; runtime argument buffer remains transport|
|10–26,17×43B|Native invocation wrappers, only13 hot|Retire; direct RUN and native function calls; remove unused wrapper installation|
|50300,149,518B|Large geometry lookup asset, ordinary data|Keep one scoped asset borrow/render; cache validated offsets/identity, not expired pointers|
|50301–50303,22,784B capacity|Regenerated stock drawing command lists|Remove staged-list execution; native composition or bounded stock submission|
|50304,48B|Completion/publication data|Retain small explicit external status/events only as needed; do not poll internal scratch|
|50305|Native package upload staging|Loading transport; not interpreted game code, reusable/free only per actual load ownership|
|50700,38,400B|Old road bitmap, still allocated/preflighted in rows arm|Remove from new native-only allocation plan, preserve matched old control|
|50710–50717,52,238B|Actor sample bitmaps used by queued stock plots|Retain scoped data for first state experiment; optimize compositor separately|
|64000…/64120…|Original actor artwork, bitmap objects|Keep stable external assets or explicitly rework native compositor|
|Fonts,sky,mirror,audio resources|Ordinary presentation assets/stock operations|Data/primitive interfaces, not Golem physics programs; profile separately|
|Framebuffer rows|Actual drawing surface under BEGIN/ROW/END|Keep finite direct scope; never retain after END/mode/swap|

## Proposed implementation order, for later release

- **NAT-NEXT-01** [ ] — Replace the generated state/physics core with owned native
  structures, exact small tables and local arithmetic temporaries. Keep current
  four-step cadence, road geometry/sampler and full presentation for comparison.
  Use minimal compatibility adapters at the existing input/export boundaries;
  no scalar acquire/release calls inside numerical loops. Instrument phase/call
  counts in a separate diagnostic build. This is the first recommended tranche.
- **NAT-NEXT-02** [ ] — Consolidate repeated Tick entry into native direct function
  calls within a coarse update/render request; delete interpreted Tick wrappers
  and obsolete root metadata handshakes. Preserve four actual logical steps,
  publication, callback identity and completion/presentation fences.
- **NAT-NEXT-03** [ ] — Remove the three generated drawing-buffer staging paths;
  compare existing native VDU span submission versus a typed native compositor
  only where measured costs justify it. Eliminate unused road scratch/preflight
  and avoid rerunning immutable-resource checks without an ownership reason.
- **NAT-NEXT-04** [ ] — Audit the replacement across route, physics, contact,
  actors, sky and HUD: no piecemeal retention of the old access pattern. Then
  revisit async transport and independent real-time physics/render scheduling
  under separately reviewed scope. No new120Hz promise from this fixture.

These are proposed future items, not implementation authorization. This selected
research task is complete. The prepared bitmap/rows hardware comparison remains
available and untouched; no card/firmware or machine custody action was taken.

## Measurement contract for the replacement

Compare the exact direct-row full-race control with one integration change at a
time, same actual runtime/compiler policy/geometry/assets/traffic and completion
boundary. First preserve the900/3600/two-warm workload. Build and target execution
need their normal later task/finite scheduling scopes. Include an uninstrumented
pair to measure overhead introduced by profiling; accumulate native timing in
memory and export outside the race rather than adding per-element callbacks.

Report **completed full-frame FPS first**, with MOS/PRT/host/physical boundaries
and clock disagreements explicit, plus UART bytes and phase totals/counts:
entry/runtime admission; module validation/import/export; route/contact/traffic
physics; road setup/fill; sprite sampling; stock composition; swap/fence. Existing
reply waits cannot separate those. Current a50 has no calibrated native timing
callback in its audited host table; choose an appropriate supported clock or
separately agree an owner hook instead of inventing an ABI or trusting a raw
counter without its frequency/context/wrap definition. Pure computation checks
must be complemented by full wire/render work and eventual hardware timing.

Qualify exact numerical/state outputs at useful per-step/checkpoint boundaries,
both pages, collision-true/false/inactive cases, scripted override import,
Init/Reset/Stop/unload/reload, allocation/lease/failure paths, stale-status gating,
complete drawing and clean MOS exit. Golden old scratch/header exports can be
created at observation points without forcing the new live design to store every
intermediate in the old location. If internal failure ordering changes, document
that explicitly; retain externally required errors and never publish ready on
failure. The Author's own moving visual review remains the final visual gate.
