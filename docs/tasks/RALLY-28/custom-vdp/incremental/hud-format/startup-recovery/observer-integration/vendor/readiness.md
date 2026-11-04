# Sender observer r02 preparation readiness

Executive summary: a separate diagnostic frontend is built and tested from the
byte-identically reproduced failing baseline. The offline reader and integration
input contract are frozen. This prepares observations of a future stall; it
neither reproduces the problem nor qualifies a repair. No emulator was launched.

1. Candidate SHA256 is
   `7e7d0e1bc89af72bde7ffbd6c06446aaefda4d1803f89eb1faf3167307ee1e01`,
   1,954,496 bytes, on Oryx at
   `/home/smith/Agon/mystuff/flexe-agon-emulator/build/fx114/candidate-r02/flexe-agon-emulator`.
   Exact base82e849 was reproduced first. Five existing files plus one new
   owned module change in a generated source export; Cargo.lock is unchanged.
   Full source deltas/hashes/configuration are in [readiness.json](readiness.json).
2. Eight device-free Rust observer tests, pinned eZ80 library tests and release
   compilation pass on Oryx. Eight synthetic offline-reader tests pass on Pi
   and Oryx. None initializes SDL or executes the frontend/backend. The reader
   validates bounded JSONL and explicitly reports finalization, timing,
   unavailable sender records and resumed-send counts independently.
3. Exact old Rally200f and maintained086 public getter static audits support
   the same cycles/frames/failed ABI without backend/firmware changes. This
   does not rebuild old200f or prove live compatibility. Required getter absence
   fails diagnostic admission; no plain state fallback or runtime offsets.
4. [Contract](observer-contract.md) freezes50s stasis trigger,100ms poll,
   three0/250/500ms samples,630s reader lifetime and at most5 lines. Actual
   elapsed time matters: offline100ms sample-lateness rule admits timing only,
   not a diagnosis. Existing Rally60s and6502 consumer guards remain unchanged.
   Missing final, interrupted/late series and unavailable snapshots are visible.
5. Reproducible input/evidence archive is local
   `build/fx114/preparation-r02.tar`, 4,454,400 bytes, SHA256
   `464582cc7045412f27050e256c751f43c2f265b4733772bc3265b30fd4a656c2`.
   Every archived file hash was checked; includes original source archive,
   exact hostfs patch/builder, candidate/source delta/new module/build log,
   static audit receipt and contract/reader/tests. Reproduction copies the
   exact baseline then applies the recorded five-file diffs and adds the
   new module; preparation script records the original build/test recipe.
6. Stopped-profile contract is an INPUT pointer, not a deployed consumer.
   Root coordinates6502 primary and Rally integration; Rally applies this new
   frontend cohort equally to both fresh arms and excludes old28f50 FPS.
   Future execution needs separately selected scope and self-service FIFO.
   No target, attach, device, profile mutation, reservation, default, repair,
   commit or push occurred. Original r01 and consumer profiles are preserved.
