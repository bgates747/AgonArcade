# Offline phase-cost and assembly audit return

**Existing compact reference: 36.1930 completed-frame FPS — 900 frames in
24.8667 nominal MOS seconds.** Separate PRT: **34.9610 FPS — 900/25.743 seconds**.
This offline audit measured no new FPS and identifies no new rendering gain.
The prior two-order compact cohort remains separately recorded at36.5730
nominal MOS FPS. Do not pool it with the latest control or the partial prepared
comparison.

All prior dirt and the scope were committed in four logical groups and pushed
to `origin/main`, ending at **2ac6a32**. The work returned here is uncommitted.
COST-001-01–04 are complete as offline research/design, without an Oryx
connection, reservation, emulator, peer request, game/fixture edit or new native
build. The unchanged AgonDev translation unit was emitted to annotated assembly;
no qualified binary was replaced.

1. [Phase map](PHASE-MAP.md): the existing PRT brackets overlap. Reply wait is
   not VDP render time; native RUN ends before later stock plotting. In the
   pinned double-buffered mode ordinary primitives execute inline, while swap
   waits for VSync. Completed FPS includes swap; requested hot-loop/drawing
   timing needs to show that wait separately.
2. [Generated-code findings](ASSEMBLY-REVIEW.md): HUD/footer perform eight string
   formats per race frame before retained-cell suppression. The four-step
   fixture executes eight wide remainder helpers. Both have relevant shared
   game callers. Native endpoint floats use actual FPU instructions; the
   additive sampler already avoids division in its pixel loop.
3. [Timing contract](TIMING-CONTRACT.md): completion-qualified stock execution
   markers plus internal preparation counters can use the existing ABI/stock
   drain, with separate diagnostic variants, finite retained records and no
   readback during timing. The current image has only504bytes text headroom;
   code-fit is a real first gate, not a promise that all hooks fit unchanged.
4. [Input accounting](INPUTS.json), [call sites](ASSEMBLY-CALLS.json) and
   [existing evidence](EXISTING-EVIDENCE.json): 163 exact input hashes,
   97 frozen control inputs and seven protected archive/source checks pass.
   One shared firmware source had changed; its exact original was recovered
   from the local pinned Git object, not substituted with the newer file.

## Proposed next experiments, in order

These are proposals, not new actionable tasks or an implementation/test release.
Choose a bounded tranche before changing anything.

| Rank | Change and likely relevance | Cost/uncertainty | Decision evidence |
| ---: | --- | --- | --- |
| 1 | **Cache HUD/footer formatted values before string construction.** Shared by direct-eZ80 and native full-race presentation; known redundant work, exact visuals possible | Small/moderate. Lap time changes often; broad presentation estimate is not a measured HUD budget | Preserve text/color/page invalidation and footer drawing across race/results/record changes. Same complete-race motion and wire/state checks, both-order FPS. Count formatting calls to show work actually removed |
| 2 | **Replace bounded station/phase modulo at proven forward-step callers.** Removes wide helpers from eZ80 updates; apply shared range reasoning to both versions | Small code change, moderate proof. General negative/arbitrary wrap callers must retain normalization | Exact exhaustive/boundary range checks for supported advances and lap lengths; generated assembly confirms helper removal; isolated ≥10s physics plus integrated full-race FPS/wire timing |
| 3 | **Batch small resident outgoing packets without altering bytes.** Saves repeated writer/timer/counter overhead | Small/moderate; does not reduce serial bytes. Preserve error boundaries and stored packet lifetimes | Entire guest→VDP timed stream byte equality and native replies/state; assembly call counts, matched FPS. Separate any later actual byte-reduction experiment |
| 4 | **Implement only the smallest admitted phase diagnostic.** Measures road prep/actors/sky/HUD/swap and repeated validation before choosing deeper native work | Moderate, only504bytes current text margin; split builds may be needed | Exact fit/stack/lease/fault proofs, hook overhead versus no-hook control, completed FPS plus separate clock-domain phase observations; no silent limit change |
| 5 | **Reuse validated clipped actor plans.** Same dimensions/mirror/skips currently derived twice | Small/moderate. Dynamic benefit and extra metadata cost unknown | Exact commands/pixels/clipping/order, bounded lifetime and lease proofs, no generation while plotting; whole-frame FPS |
| 6 | **Integer/rational road endpoints and explicit geometry approximation.** Remove float setup/conversion or coarsen bands if measured worthwhile | Moderate; Xtensa already has FPU. One-pixel/stripe errors need disclosure; visual quality may trade for speed | Measure geometry versus fill first, retain float control, quantify boundary changes and FPS, then Author moving visual review |
| 7 | **Composition/source cropping/sky repair changes**, only after phase evidence | Higher integration risk. Road bitmap is filled then copied; large alpha images and repair can matter, but sizes alone are not timings | Source-owned framebuffer contract if needed, complete camera/traffic/effects bounds, full-scene matched FPS and Author visual gate |

The recommended first implementation is rank1 alone, keeping all rendering,
physics, motion, native module, firmware and completion checks. It improves
shared production presentation rather than exploiting a fixture-only shortcut.
Do not combine it with arithmetic changes in the first comparison. The benchmark
decides adoption; this audit does not estimate an FPS gain.

The prepared-image capacity/functional successes and partial performance failure
remain unchanged. No retry/fourth run, cache adoption, GUI/hardware operation or
later optimization follows from this return.

## Reproduce the offline checks

From the project root:

```sh
.venv/bin/python docs/tasks/RALLY-28/research/phase-cost/audit.py
git diff --check
```

The checker reads files and verifies saved derivations. It neither imports a
runner nor contacts a machine. `--write` regenerates only this audit's three
derived JSON files. [EMISSION.json](assembly/EMISSION.json) retains the precise
assembly-only compiler invocation. `stock/PROVENANCE.json` records the read-only
recovery; other project files and historical freezes were not changed.
