# RALLY-10: frozen band-boundary experiment contract

Frozen 2026-09-11 after the user authorized the experiment and requested a
checkpoint before implementation. Changes to this scope require a separately
recorded decision; retain this document as the experiment's baseline.

## Change

Replace the runtime greedy geometric band search with precomputed screen-row
band boundaries. Keep material transitions exact by splitting bands where the
existing paint classification changes. Select the table offline against the
existing projected-row reference, covering both tracks, and record the sample
coverage and observed approximation error. Preserve the greedy implementation
as a selectable baseline for the comparison.

## Boundaries

Keep projection, track data, artwork, physics coefficients, steering semantics,
scenery, traffic and stock VDP commands unchanged. No asynchronous scheduler,
assembly rewrite, new asset container or second optimization in this experiment.
Existing one-pixel centreline tolerance is the quality target; sampled validation
must not be described as an exhaustive proof. Shared band endpoints must remain
gap-free and command streams must fit their allocated buffer.

## Evidence and review

1. Snapshot all currently changed tracked and untracked files and the current
   binary, with HEAD identity and SHA-256 manifest, before renderer edits.
   Preserve staged/worktree state; this checkpoint is an archive, not a commit
   or an assertion that earlier emulator changes passed human review.
2. Validate the table against projection samples on both tracks, including lap
   seams, independent material phases and lateral offsets. Run existing host
   sanitizer checks and add targeted coverage for band continuity, material
   transitions, approximation error and stream capacity.
3. Build using the established Linux fallback. Run the same deterministic
   headless fixture for greedy and table variants in alternating order. Record
   band-stage and frame costs, band counts, bytes and binary identity.
4. Inspect headless native captures for both tracks. Report quality or command
   volume costs alongside timing gains; reject an unsuitable candidate rather
   than disguising a regression as a speedup.
5. Prepare autoexec and launch a graphical emulator for the user's review only
   when the candidate is ready. Leave changes uncommitted pending that review
   and explicit commit approval.

Root TODO.md remains the sole authoritative task checklist. This contract
defines the scope and acceptance evidence for the current RALLY-10 iteration.
