# Additive car/sign sampling improves completed Flexe frames by 42%

The corrected sampler completes this fixture at **38.42 nominal MOS FPS**, versus
**26.98** for the matched affine control: **+42.40%**, saving **11.04 ms/frame**.
Four 900-frame runs pass independent state, retained replies, input hashes, timer
restoration and backend checks. All four final shutdown images are pixel-identical.
These are Oryx Flexe estimates; real hardware and the Author's moving visual
review remain open. [Review launch](HUMAN-REVIEW.md).

All prior dirt and the released INC-001-02 scope were committed/pushed as
**32a7cb4** before implementation. New source/evidence remains uncommitted.

## What changed

1. Traffic and signs use a restricted integer additive scale/mirror sampler in
   native preparation, followed by ordinary stock RGBA2222 bitmap plots. Source
   increments and an x-map are calculated once per visible object. There is no
   per-pixel matrix multiplication or division. Geometry, view/livery selection,
   painter order, physics, Native road spans, split clear, player and firmware/
   SDK/driver remain unchanged.
2. Six 99×75 car backing images and two 62×62 sign images use **52,238 additional
   retained VDP bytes**, allocated once. Only the visible clipped region is
   sampled/plotted. Distinct buffers preserve every queued object. Sampling
   occurs after the command-output lease is released, keeping root+asset+source+
   destination within the actual four-slot runtime limit. [Resource map](RESOURCES.json).
3. Graphics viewport changes require a PLOT 4 move to activate canvas clipping
   before the ordinary bitmap plot. The corrected candidate does this explicitly.
   Only the clipped scaled rectangle is sampled and plotted; unused scratch
   padding is excluded. Transparent pixels inside that rectangle are still
   processed. Recurring bitmap reallocation, size buckets and opaque-run
   compression are not part of this change.
4. The timed eZ80 command tape remains byte-identical between variants:
   **277 outbound bytes/frame**, including the same six checked transactions and
   final post-swap fence. Native resident actor-list bytes average 193.81 rather
   than 202.30; these are VDP-side commands, not UART bytes.
5. Native text grows from 30,928 to 31,844 bytes; data remains 1,004. The same declared
   text/data/stack/image limits remain 32,768/4,096/2,048/65,536. The corrected
   module SHA256 is
   `310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702`.

## Matched completed-frame comparison

Each run has 900 frames and 3,600 ticks with foreground pacing removed, stock swap/VSync
retained and one complete rendering fence per frame. Both variants load their
module before the artwork/mode change; the startup workaround is applied equally.

| Run order | Variant | Nominal MOS FPS | Nominal PRT FPS |
| --- | --- | ---: | ---: |
| First pair, first | Affine | 26.8657 | 25.9568 |
| First pair, second | Additive | 38.9892 | 37.6664 |
| Reverse pair, first | Additive | 37.8682 | 36.6092 |
| Reverse pair, second | Affine | 27.0948 | 26.1864 |
| **Pooled, 1,800 frames each** | **Affine** | **26.9798** | **26.0711** |
| **Pooled, 1,800 frames each** | **Additive** | **38.4205** | **37.1302** |

Pooling divides total completed frames by total elapsed seconds. Pairwise MOS
gains are 45.13% and 39.76%; pooled MOS and PRT gains are 42.40% and 42.42%. Nominal
MOS frame time falls from 37.0648 to 26.0278 ms, a 29.78% reduction. MOS assumes 120 units/s; PRT assumes the
emulator's nominal 18.432 MHz instruction clock. Host durations include startup/
teardown and are preserved separately. This does not establish hardware FPS,
60 Hz capability, independent 120 Hz physics or full playable-game performance.

## Actor cost attribution

Two separate 128-frame actor-only diagnostics pass all 512 physics ticks and
independent final-state checks. Raw per-core CCOUNT means are:

| Actor interval | Affine | Additive |
| --- | ---: | ---: |
| Preparation, including deferred sampling | 5,550 | 86,263 |
| Resident dispatch, drawing and flush | 1,163,847 | 373,676 |
| **Preparation plus execution** | **1,169,397** | **459,939** |

Combined actor work falls **60.67%**. Preparation rises because it now performs
the sampling; drawing alone falls 67.89%. This is why the combined interval is
the useful comparison. These are uncalibrated emulated counter deltas with
interrupt/dispatch/flush overhead, not physical cycles or milliseconds, and not
a 61% reduction in the whole frame. [Raw-derived phase results](ACTOR-PHASE-RESULTS.json).

The original full diagnostic could measure the current control but its larger
candidate could not load. A compact version also failed admission. The final
actor-only diagnostic retains ordering, per-core, count, bounds and ownership
checks while fitting: 31,312 bytes of control text and 32,212 of candidate text.
It uses two resident markers and 1,373 retained replies per run. All failed
attempts are preserved; headline modules remain uninstrumented and unchanged.

## Qualification and preserved failures

1. Ordinary and ASan/UBSan actual generated-C replay each pass 900 frames and 3,600 ticks
   against independent Traffic/contact state and the accepted control. Road
   pixels and road/player commands are exact. 6,575,164 sampled pixels across 3,409 draws
   match an independent rational oracle, including geometry, clipping, painter
   order, stale sibling storage and padding. 110 failure cases and 16 additional
   six-car scenes pass with four peak balanced leases. The second sign slot
   receives preflight/failure coverage but was not visible in supplied scenes.
   [Ordinary](host_clipfix_ordinary.json), [sanitized](host_clipfix_sanitized.json).
2. Pure sampler tests each pass 16,940 plans, 9,460 visible samples and 13,662,237 pixels
   across all 119 even scales, reflections, alpha values and border cases. A
   binary32 boundary model differs at 15 of 16,235 source coordinates, by one source
   pixel; this is not exact DSP inverse emulation or a visual rejection threshold.
   [Unit report](sampler_unit-sanitized.json).
3. All four target runs pass 2,913 retained replies each, exact final root/arrays,
   timer-vector restoration, unchanged inputs and clean zero-error backend exits.
   Final RGB shutdown snapshots differ by **zero pixels** across all 320×240.
   They are not per-frame motion instrumentation. Max sampled temperature is 57°C
   during the headline comparisons; all sessions restore boost from 0 to its
   original 1 after stopping emulators. Stack watermark observations after runs
   are 2,052–2,116 bytes affine and 1,972–2,004 additive, not exhaustive bounds.
4. The original late-load candidate was rejected at LOAD with MEMORY6 before
   simulation/rendering. Mode setup competes for executable-capable internal
   memory, consistent with the larger module's admission problem. Moving LOAD before the entire artwork/mode stream works on both
   variants; INIT does not require the later assets. The workaround changes
   setup ordering, not firmware or timed work. [Exact record reorder](EARLY-LOAD.json).
5. The first early-load sampler had a clipping activation bug and displayed
   stale sign pixels. Its four-run timings are **rejected** as performance evidence
   for the corrected candidate; raw inputs/results remain preserved. The host
   decoder now distinguishes stored viewport state from activated canvas clipping
   and rejects a missing-PLOT 4 regression.
6. Full and compact all-phase candidate diagnostics exceeded available executable
   memory at LOAD despite fitting the declared SDK ceiling. Their failure
   receipts remain preserved; no timing is inferred from them. The admitted
   actor-only comparison above supplies the targeted phase measurement.

## Evidence and next gate

[Machine-readable comparison](RESULTS.json), [exact inputs and source package](PORTABLE.zip),
[archive manifest](PACKAGE.json), [build](BUILD-candidate-clipfix.json),
[raw runs](evidence/), [diagnostic/rejected inputs](DIAGNOSTICS.zip) and their
[manifest](DIAGNOSTICS.json). Qualified target binaries have their own `target/`
archive paths; inherited binaries within source packages are provenance only.
The archive includes unchanged `vdp_rally.bin`; no physical
media was written or firmware flashed. Old controls/production games/SDK remain
unchanged. Future integration must reserve the scratch range in the generated
resource contract; the current fixture map proves disjoint IDs without editing
peer-owned frozen manifests.

The fresh stopped Oryx profile is ready for Author motion review. Follow that
with byte-identical hardware comparison when released. Keep the new scalar
sampler available to future native development; stock-compatible caching and
the unchanged player's mirror path remain separately scoped work. Do not mix
another optimization into this result.

Regenerate the headline report without launching an emulator:

```bash
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/sprites/report.py
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/sprites/verify.py
```

[Final verification](VERIFICATION.json) covers archive readbacks, source/fixture
identities and the preserved raw evidence. It performs no build or emulator run.
