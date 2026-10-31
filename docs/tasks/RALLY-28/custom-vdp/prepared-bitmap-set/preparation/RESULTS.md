# Prepared-image domain and fit findings

The complete current renderer domain needs **6,927 images and 14.87 MB of pixel data**. A one-pixel alternative needs5.44 MB; a two-pixel alternative2.21 MB. The two-pixel set is the smallest bounded full-coverage candidate found and is recommended for a later capacity/visual experiment, subject to central approval. No approximation is accepted or installed by this analysis.

No new FPS was measured. The preserved complete-race compact control remains **36.57 nominal MOS FPS**, separately35.35 PRT FPS. Cache performance, startup duration and actual target heap fit remain unmeasured.

## Full-domain coverage

1. Traffic uses `q=floor(8000/z)`, with integer z64..1100. There are108 distinct q values7..125 (Q8 scales14..250), not all119integers in that range. Actual legal, visible Fuji witnesses cover all five views/both reflections at every q; six independent liveries give6,480 required keys. Every constructed witness is checked by the original actor planner and state-range validator. Oval witnesses are retained separately; missing sampled Oval witnesses are never used to prune the union.
2. Signs were enumerated through **all3,852,800 integer camera positions** across Fuji and TriOval using the original planner, real sign placement, curve offsets, source index, two-slot selection and clipping. This leaves447 distinct source/scale keys, not the naive8x99=792cross product. Individual signs require50–59 sizes; actual q maxima65–74 depend on artwork/placement. Signs never reflect.
3. Both ordinary and undefined-behaviour sanitizer full scans produce identical witnesses. All6,927 reference images match the actual accepted C sampler with guard bytes intact;192 independent set-distance comparisons agree with the error census. All4,867 observed deterministic actor draws are covered; that trace was not used as the full domain. Original five fixed-size player images need no additional resized variants; their mirror path is outside this set.

## RAM/error alternatives

The error is maximum anchored bounding-edge displacement and symmetric opaque-mask distance in screen pixels. Integer ground/centre anchors remain fixed. Colour disagreement and silhouette overlap are supporting evidence, not acceptance criteria. These are analysis alternatives, not production policies.

| Alternative | Images | Pixel bytes | Lookup bytes | Pixels + lookup +256B/image scenario | Max edge/mask error |
| --- | ---: | ---: | ---: | ---: | ---: |
| Exact sampler reference | 6,927 | 14,874,209 | 58,836 | 16,706,357 | 0/0 |
| One pixel | 2,040 | 5,443,719 | 19,740 | 5,985,699 | 1/1 |
| Two pixels | 901 | 2,211,975 | 10,628 | 2,453,259 | 2/2 |
| One near / two far | 1,592 | 5,121,502 | 16,156 | 5,545,210 | 2/2 |

The256-byte allowance is a sensitivity scenario, **not measured allocator overhead or a proven upper bound**. FINDINGS.json also reports zero/128-byte scenarios, natural-size padding and one-largest-image+4096-byte setup-workspace scenarios. The near/far alternative preserves the existing large-image boundary q>=64(scale>=128) with one-pixel error, allowing two pixels farther away; it remains comparatively expensive.

The full exact set needs at least14,933,045 additional bytes including its table. It cannot fit any after-baseline free-memory budget of8 MiB or less. The two-pixel scenario needs2,453,259extra bytes before setup workspace; it is a plausible4 MiB-after-baseline option and does not fit2 MiB. **The actual available target budget is not known**, so no installed fit is claimed.

Source inventory accounts for910,787 bytes of known existing pixels/tables/module/arrays/wrappers/framebuffers. This excludes allocator, maps, framework, context, DMA and task overhead and does not assign every byte to a particular heap. Free-memory snapshots must be taken after baseline installation so existing resources are not ignored or counted twice. Bitmap objects point to their backing buffers; the stock path does not make a second full pixel copy on registration.

## Appearance and stock generation

1. Representatives are selected by minimum pixel+lookup cost over contiguous request intervals; selection is monotone. Each view/reflection geometry family has its own map, shared by traffic liveries. The complete set trades memory against explicit error; no single favourite race trace determines its sizes.
2. One- and two-pixel absolute bounds can be a large relative change for tiny cars. Worst opaque-region colour disagreement reaches100%, and worst silhouette intersection/union is23.08%/17.65% respectively. Nearby sharp paint/wheel edges also change. These numbers do not automatically reject faster rendering; the Author judges movement/stepping. Prepared q gaps reach7(one pixel) or11(two pixels), versus at most2 for exact reachable q values. [Enlarged offline examples](previews/CONTACT.svg) include far/middle/near cars and a large sign; they are not emulator screenshots or moving acceptance.
3. The stock transform model at identical sizes differs from the exact additive reference in120of6,927 images; worst opaque-region disagreement1.48%, silhouette distance1 pixel. Its inverse is the explicitly labelled host analytic model, so target generator/pixel qualification remains necessary. The one-/two-pixel stock-model alternatives include that model difference in their mask/error constraints. No further exact-parity research was pursued.
4. Use explicit-size stock command40 rather than its natural+1 row/+1 column output. Full natural outputs would require15,448,552 pixel bytes, versus14,874,209cropped. The two-pixel natural case costs2,291,454versus2,211,975. Original art loads once; generation happens inside VDP before timing. Offline reference blobs are analysis data, not pre-scaled game files to upload.

## Interface, telemetry and gate

1. [Packed interface recommendation](PACKED-INTERFACE-v1.md):64-byte header,68 source/reflection directories,18shared126-byte size maps,8-byte image records. Exact table58,836 bytes fits one standard block. Lookup is constant time; use the original world anchor, selected dimensions and unchanged depth ordering/clipping. New private IDs51996..51999 and52000..58926 do not collide with the frozen app inventory. Simple distinct images are preferred: exact content dedup saves only132 pixel bytes.
2. Frozen native INFO fields stop at17. Current upstream SDK fields18–21 must not be silently used. Pinned stock variables0210/0211 and bufferReadVariable(command48/options128) provide free PSRAM; read high/low/high consistently through a fixed telemetry buffer. Native13–16 cover internal free/largest blocks. Largest PSRAM block is not exposed by this frozen interface. Actual installation, free-memory measurements and cleanup still need qualification. Current live command40 includes a later audio-reservation guard; this preparation uses the frozen extracted code and does not adopt that new source.
3. Successful buffer allocation alone does not prove Bitmap registration. The proposed setup verifier validates source/table/content and performs a qualified contrasting-pixel probe through the existing stock read-pixel command for each nonempty cached image, resolving hidden/visible page behavior before use. Restore both pages before warming. No generic service request is needed. Missing keys fail; zero timed generation/allocation/replacement is required. No hidden fill or fallback is permitted.
4. Recommend returning the two-pixel full-set recipe for capacity and Author visual selection first; retain one-pixel and exact alternatives if measured memory permits. An approximate runtime policy is **not released** by this report. The native consumer has only504 bytes left under its current declared32KiB text budget; build/admission/stack must be checked, with actual failures returned before any limit change.
5. Keep the current checked/compact control, full race workload and final swap fence. Later FPS comparisons require fresh both-order controls and a new central Oryx lease. No emulator, Oryx access, target allocation, firmware/SDK/default change, hardware action or commit/push occurred in this host-only tranche. The separate missing road/traffic/player/sky phase profile remains outstanding; no cache estimate substitutes for it.

Reproduce the host preparation with the project .venv Python and run.py in this directory. DOMAIN/IMAGES/ERROR-PAIRS/FINDINGS/VERIFICATION/RESOURCES artifacts retain data and provenance. Root TODO owns review and subsequent release.
