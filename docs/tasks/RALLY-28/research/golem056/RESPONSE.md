# Rally return: GOLEM-056 C/C++ VDPlet consultation

Rally can use the existing buffer and native-VDU services to reduce foreground
round trips and to plot a pre-generated collection of bitmap sizes. Neither
requires a Golem language feature or a new permanent bitmap service. The main
potential service gap is scoped colour backbuffer access for eliminating the
road's intermediate image. The existing generic-pixel candidate should be
reviewed first rather than duplicated. No implementation or new test is started.

## 1. Session, pins and current work

Identity `rally`, AgonArcade thread `01a1346d-a74a-7211-b5b7-de3bcb8a28e5`.
Published checkpoint `fa7932d`; AFF02 full-race cache results and AFF03 proposed
multi-size preparation remain uncommitted. AFF02 awaits Author moving review;
AFF03 is documentation only. This consultation does not replace either scope.

Reviewed agon-vdplet `2541f10a1f8b06688bcecbc6d22eeae607da2b63`, its public ABI,
API reference, supported functions, runtime and generic colour-pixel contract.
Rally's measured fixtures still use frozen firmware
`8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473`,
their prior runtime/SDK and buffer-only modules (capability1). No newer firmware,
SDK or service table has been silently adopted. Native C source `94d92d10...`
is retained across the measured actor variants; full source identities are in
`docs/tasks/RALLY-28/custom-vdp/affine-race/BUILD.json` and RAW-AUDIT.json.

Evidence: eight selected 900-frame/3,600-tick Oryx Flexe runs, reverse-order
comparison, full real panorama/HUD/footer/audio work, exact final state and
352,768 identical timed outgoing bytes per run. Pooled nominal MOS FPS:
rebuild26.18, cached affine29.86, last-image bitmap cache29.74, accepted additive
sampler33.44. PRT FPS respectively25.30/28.86/28.74/32.31; these are separate
emulator clocks, not physical scanout or hardware FPS. Results live under
`/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/affine-race/`.

## 2. RLY056-001 — Reduce per-frame round trips and submit locally

**Improvement/evidence:** the current measured guest performs six native
transactions/replies per rendered frame: RUN, four publication/state reads and
a post-swap generation read. This is an actual wire census, not six necessary
gameplay exchanges. Reducing serial waits is promising; no FPS gain is measured.

**Existing route:** buffers1 plus VDU4 (module mask5), with profile4/INFO24 for
installed bitmaps and viewports, can keep projection and ordinary drawing local.
Rally owns a finite entry which validates and publishes its complete output
before returning success; keep its RUN error response and the final graphics/
swap fence while consolidating redundant intermediate reads. Preserve a rich
diagnostic control. Native submission return must not become a render-complete
claim. New VDU submission also preflights prepared matrices, unlike our old
buffered execution route; respect forward/inverse and queued-asset lifetimes.

**Hook/ownership:** no new service is requested for the first experiment. Rally
owns INC-001-05 and would adapt its module/driver; Golem/VDPlet owns clarification
of coverage and completion contracts. Do not dispatch a duplicate protocol
task or introduce a background module, scheduler, raw UART callback or arbitrary
buffer execution through `vdu_submit`. Inspect existing fences first.

**Validation/cost:** compare fresh full-race FPS with identical scene/world and
complete error/fence checks; count actual bytes, replies and waits. Firmware
growth can be zero if existing services suffice; module/wire changes need
measurement. Recommendation: next independent application-side candidate.

## 3. RLY056-002 — Prepare multiple bitmap sizes before racing

**Improvement/evidence:** AFF02 retains only the last image per actor. Its
3,000 hits are61.64% of draws but16.82% of natural transformed pixel area; all
263 large draws miss. This does not test the Author's proposed prepared set.
AFF03 will explore size/view/reflection counts, dense nearby sizes, screen-space
and motion error versus RAM, and setup generation before race timing. The
Author selects acceptable stepping. No gain is assumed from isolated draw costs.

**Existing route:** host creates/registers images during setup; a module can
bake pixels through scoped buffers or the host can issue stock transforms.
Keep original artwork loading once, not pre-scaled file uploads. Buffers1 and
profile4 VDU4 suffice for later ordinary plots. Source/objects survive the draw
fence. A fully prepared case performs no timed image generation/allocation;
any near-cache/far-additive hybrid is a separate case with explicit fallback.

**Hook/ownership:** no native bitmap-creation, transform-generation or loader
extension is requested. Offline selection, cache recipes, lookup/anchors and
startup population belong to Rally AFF03, not Golem or permanent firmware.
Budget pixel bytes, object/index overhead, DRAM/PSRAM, temporary generation and
largest blocks alongside existing scene/module resources. Recommendation:
already covered by Rally's proposed AFF03; await Author release/dispatch.

**Validation/cost:** fresh complete-race FPS against additive; report setup
seconds, peak/retained RAM, coverage and unexpected generation counts separately.
Cover the full supported range rather than fitting only one deterministic run.
Expected firmware increment zero; additional bitmap RAM and setup time unknown.

## 4. RLY056-003 — Review colour surface access before adding hooks

**Improvement:** current native road generation writes a320x120 retained image
(38,400 pixel bytes) and then plots it. Removing the intermediate image/copy is
an unmeasured candidate under INC-001-06; it is not the old triangle-road problem.

**Existing route:** ABI1.3's generic `surface_info/pixels_write` candidate already
describes physical rectangles, stride, palette mapping and the hidden drawing
surface of double-buffered controllers. Review mode136 compatibility and its
owner's promotion gate first. Buffers+pixels is mask17 if that optional service
is installed; selecting it must not imply audio/PCM is required. The current
`vdplet_media_host` convenience accessor expects both PIXELS and PCM, so any
future pixels-only build should have an independently capability-checked
accessor rather than force unused PCM dependencies.

**Actual remaining hook, only if justified:** `pixels_write` still copies caller
pixels. To rasterize directly with no intermediate road image, a generic scoped
colour drawing-surface transaction is needed; current PALETTE2-only frame rows
do not suffice. Proposed shape: checked physical rectangle, returned token/
format/dimensions/row extent and sanctioned native-layout access; a row accessor
within that transaction; explicit end plus automatic close on return/failure.
Drain prior drawing before exposing rows, pin the current hidden page for the
transaction, prohibit conflicting swaps and preserve surrounding/sync bits.
Reject unsupported surface/bounds/context/BUSY before writes. No pointer outlives
the lease, no heap bitmap is registered from borrowed module memory, and normal
completion/presentation fences remain explicit. The layout must not assume a
linear RGB row: the direct64 path uses x^2 lane ordering and sync bits.

**Ownership/validation:** Golem/agon-vdplet owns a minimal generic service or
extension of VDPL-005; Rally owns raster code and mode136 consumer tests. Other
consumers may share the contract. Compare existing bitmap versus candidate
rectangle writes before requesting writable-row work; measure whole-race FPS,
both pages, clipping/palette, cleanup, resource leases and actual permanent
firmware/DRAM increments. Gains and footprint are unknown. Recommendation:
coordinate with existing VDPL-005, later than application-only experiments.

## 5. RLY056-004 — Memory discovery is present; document it

The pinned runtime implements INFO18/19 (free PSRAM low/high) and20/21 (largest
PSRAM block low/high) in `src/vdplet_runtime.h`, alongside13/14 and15/16 for
internal byte-accessible memory. These solve a concrete AFF03 measurement need;
no new memory service is requested. The API reference INFO table omits18–23.
Please add the implemented field definitions, including22 audio-task stack and
23 task count, with applicability/build limits as appropriate. INFO17 is the
command-task stack watermark, not bitmap heap capacity. Owner: agon-vdplet docs.
Recommendation: useful small documentation correction during central review;
zero runtime/RAM/wire protocol change. Qualify query values only on a later
released target run, not from this consultation's source inspection.

## 6. RLY056-005 — No additional line/audio feature needed now

Line batches are not a replacement for the accepted filled-road span renderer.
Stock profile5 controls suffice for Rally's existing engine sound; the full race
records only24 frequency changes in900frames. There is no demonstrated need for
copied PCM, scheduled queues or a module background callback for this tranche.
Keep the reported Flexe/Fab audio differences with the emulator owner; no audio
test, workaround or firmware adoption follows from this return.

## 7. Dispatch recommendation

Prioritize RLY056-001 application-side synchronization and the already proposed
RLY056-002/AFF03 prepared set as separate experiments. RLY056-003 is a conditional
generic-service coordination item, not permission to implement it. RLY056-004
is an existing-capability documentation gap; RLY056-005 needs no new feature.
The Author and Golem decide assignments centrally. Rally preserves its fixtures,
source ownership and current task gates. No compile, benchmark, emulator,
hardware, firmware/SDK change or commit/push was performed for this response.
