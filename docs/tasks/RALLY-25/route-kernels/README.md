# Rally route/contact kernels

Actual generated Golem C now reproduces Rally's historical route pace, six-slot movement/placement and pure contact geometry against the preserved independent reference. Ordinary and ASan/UBSan runs pass79,768 invocations per layout,319,072 total. This prepares game logic for composition; complete traffic lifecycle, renderer bindings, autonomous scheduling and target qualification remain separate. Golem's newly reported D2 resource gate also requires an Author decision before composition can proceed.

Replay from the repository root:

```bash
.venv/bin/python docs/tasks/RALLY-25/route-kernels/verify.py
```

The script verifies accepted multiplication/division/right-shift exports against their published commits, copies the right-shift compiler closure into Rally's ignored work directory, and builds that immutable compiler. No live peer compiler or peer builder is executed in its checkout. Source/tables, default/relocated metadata/generated C and repeated-generation controls are built under `../.work/route-kernels/`. The accepted SDK header/tool hashes are checked without changing SDK files. Automatically created receipts are [dependency](DEPENDENCY-RECEIPT.json), [ordinary](ordinary-results.json), [sanitized](sanitized-results.json) and [master](RESULTS.json); old receipts are removed before replay so failed runs cannot present an old master as current. Result timing/library hashes change on replay; preserve the published manifest as a historical snapshot.

## Source and reuse

[kernels.golem](kernels.golem) is the exact expanded source consumed by the compiler. [state.golem](state.golem) declares the retained interface; [sine](sine.goleminc), [route](route.goleminc), [contact](contact.goleminc) and [motion](motion.goleminc) contain the authored formulas. [compose.py](compose.py) expands these shared fragments into standalone conformance Subs and combined `Tick120`; it introduces no compiler intrinsic, source-language call feature or wire schema. After editing fragments, regenerate the expanded file with:

```bash
.venv/bin/python docs/tasks/RALLY-25/route-kernels/compose.py
```

Normal verification requires the saved expanded source to match the fragments exactly. [probes.golem](probes.golem) adds finite arithmetic/error checks and fixture cursor reset/stop. These probe entries are not additional game features. Root/buffer/entry IDs and widths come from actual generated metadata through the previously qualified [adapter](../generated-state/adapter.py). The two binding maps use prior [fixture role ranges](../generated-state/bindings.json), explicitly labeled admission placeholders rather than player/event packet layouts.

The route starts at record0/countdown60/heading0/lateral0. On countdown0 it loads the next record/initial heading, adds rate before movement, uses exact quarter-wave interpolation, divides the signed product by12800 before accumulating lateral, advances forward by twice route speed and decrements countdown. The shared cursor advances once per `Tick120`, independently of active slot count. Six-slot placement uses the historical shared excursion and lane/sign formula; inactive slots retain progress/position/lateral while their computed contact flag is cleared. Active slots move before contact is evaluated. A contact is only an internal Boolean; it does not remove cars, damage the player or emit a callback.

Sine interpolation and route delta use signed division truncating toward zero. Signed `>>` is separately qualified as floor/sign-extending behavior; it is not substituted for these divisions. Both normalization and cyclic contact use positive lap residues, preserving the reference's positive exact-half-lap separation convention and strict longitudinal3200/lateral6144 thresholds.

## Domains and evidence boundaries

Inputs are complete supplied snapshots in original units. Normal positions are0..lap−1; supported track laps are3,276,800 (Fuji) and576,000 (TriOval). Player Q8 lateral is±38,400; opponent placement is±14,260; angle input spans signed16 turns−32768..32767. Route indices/countdowns represent the six frozen records. Progress uses signed32 and the exercised historical race range. Arbitrary raw root writes are not an ingress-validation service: later packet publication must preserve/coherently validate these domains. Heading, lap, active flags, placement and arithmetic checks shown in source are explicit, not evidence of concurrent snapshot safety.

| Boundary | Evidence here | Still open |
| --- | --- | --- |
| Primitive input identity |393files,78 exported source files versus accepted commits, nine packages/initializations, SDK files and five tool hashes | Peer target/human evidence is read/recorded, not rerun |
| Generated source | Accepted right-shift compiler includes multiply/divmod; actual C replay and repeat-generation hashes pass | Real stock/Xtensa Rally replay and composed native resource admission |
| Sine | All65,536 signed16 input headings match preserved reference; four outside-domain inputs reject | No regenerated float sine or changed table |
| Route |1,800 cursor ticks /three cycles; exact record/countdown/heading/lateral/forward state | Complete historic spawn/retire/rank/finish handling is not migrated |
| Contact/normalization |504 boundary cases,20 signed normalization cases, both tracks/half-lap/seams | Collision events, removal/recovery/reintroduction policy and callbacks |
| Six-slot replay | Six1,800-tick scenarios: both tracks, full/alternating/single active slots; all retained arrays and meaningful route/tick/contact state match | Sparse snapshot reconstruction and autonomous120/30-Hz cadence |
| Failure semantics | Index/Bounds/overflow, first/second paired result Bounds, zero/minimum overflow, aliases and partial-tick earlier effects | No rollback or concurrent ownership guarantee |
| Resources |292-byte root, seven arrays totaling658bytes, mock peak3; balanced granted leases/canaries | Actual combined renderer/firmware stack/text/data limits; see resource gate below |

[checks.py](checks.py) uses the original independently verified [reference model](../reference/model.py), route/contact cases and numeric vectors. It imports no Golem AST, model or emitter to compute expectations. Replay compares every retained array byte and all meaningful kernel state; transient implementation scratch globals are excluded from the independent semantic comparison. Primitive-only calls compare all globals except their explicit expected writes. Complete root/array output digests additionally agree between ordinary and sanitized builds for each layout. Relocated layout digests naturally differ because installed IDs are different.

The reused [SDK service mock](../generated-state/host.py) owns persistent buffers; no expected arrays overwrite them between ticks. FINI/INIT and generated private cleanup preserve state. ctypes uses the host C/pointer ABI, not Xtensa execution. Timings are host verification durations, not frame/physics performance. World counter/progress arithmetic is checked; root success-generation alone wraps deliberately. Four partial-tick failures verify earlier route/slot effects remain while root success is suppressed.

## D2 resource gate

Golem's [first linked resource report](../../../../../golem/docs/tasks/GOLEM-037/README.md) arrived during this tranche. [Receipt](D2-RESOURCE-RECEIPT.json) records its identity and owner-reported results, not a Rally rerun: unchanged helper/minimal dispatcher7600text bytes and544-byte resolved module stack path; tiny generated program plus helper8224text bytes and576-byte path. Current policies are8192text/512stack, with callbacks and real D2 glue omitted. The combined builder rejects the text envelope; there is no valid combined `.vdpl`. Data/image stay within their current limits.

These are exact measurements of those builds, not universal minimums or measured hardware ceilings. The source here has not been measured in that target composition. Golem returned its resource-failure branch before implementing actual binding/publication. An SDK budget review or separately authorized Rally helper reduction is the next resource decision; neither was implemented here. Increasing text alone does not settle stack, and trimming32bytes would provide no useful budget for omitted glue/game logic. Full traffic lifecycle, source-to-helper marshaling, player presentation, events/scheduler and Author visual review remain separate gates. Original helper ABI, renderer manifests and pixel disposition are unchanged.
