# Prepared native consumer built and host-qualified

The separate opt-in consumer builds within the existing native limits and passes
ordinary plus ASan/UBSan host checks. It plots pre-generated actor bitmaps using
the frozen table, without sampling their pixels during racing. This image has
not been loaded in an emulator and has no measured game FPS. The existing
checked/compact additive control remains36.57nominal MOS FPS.

1. **Capacity prerequisite passed.** Sibling capacity-02/RAW-AUDIT.json proves
   901retained/registered images,963pixel checks and exact source/table/generation
   bytes in the frozen Flexe runtime. Retained PSRAM delta2,429,496B leaves
   1,013,415B; cleanup restores89buffers with10,960PSRAM/52internal-byte residuals.
   New consumer code does not replace that evidence with a calculated budget.
2. **Actual compiled image.** `target/rally-prepared.vdpl` SHA256
   `f3a1f8d01a9cef835d165fc92747f28a00b0d2645592c106c6682de0dc6c055b`,
   35,216package bytes; resident text32,452/data1,128. Existing declared ceilings
   remain text32,768/data4,096/stack2,048/image65,536. Text headroom316B; no SDK,
   policy, compiler or firmware limit changed. `source/checked.c` is the new
   compilation unit; copied old source-package binaries are provenance only.
   The new target file above is authoritative.
3. **Ownership and hot work.** One-time bind checks the exact frozen64-byte
   header and body FNV. Immutable table/images are an application ownership
   contract through the final draw fence/Stop. No pointers survive a lookup
   lease: the temporary pointer exists only in entry-local Assets during actor
   construction, then is cleared and released before output/player work.
   Root+asset+actor-output+lookup peaks at four leases. Existing unused sampler
   buffers stay allocated/preflighted for a conservative unchanged resource
   baseline but their pixels are never written by this image.
4. **Independent host proof.** Each ordinary/sanitized run covers10,531direct
   actor cases: all6,927full-domain keys plus four clipping-edge placements for
   each901selected image. Selected lookup, original centre/ground anchors,
   reflection, painter order, exclusive319/223edges and24/88/104top bounds match
   an independent recipe/serializer. Exact entire actor command streams contain
   only activated viewports/ordinary plots/identity setup/end, excluding hidden
   transform generation or allocation commands.
5. **Full simulation replay.** Each run also executes two warm renders plus
   900frames/3,600physics ticks with identical deterministic motion. Every tick
   matches the independent world model and unchanged control; final406-byte
   state matches the prior reference. Road commands/pixels, player commands,
   actor plans and completion metadata are unchanged except actor output length
   where substituted size changes clipping. New native counters report4,873actor
   lookup attempts,4,871plots, two clipped, zero missing keys and zero cache
   generation/allocation/replacement/fallback. Counts include the warm renders;
   they are host proof, not a target telemetry/FPS result. Both modes agree and
   preserve balanced leases/canaries.
6. **Failure semantics.** All36groups reject:13header/body corruptions, seven
   table service faults at bind and render, seven full publication faults,
   deliberate missing keys after admission and missing counter-publication
   buffer. No fallback occurs. Missing/short/null/access/release failures return
   nonzero before a successful frame can be submitted. Existing generated
   simulation and native full publication checker remain byte-identical source.
7. **Stack evidence and limit.** Same-flags compiler dump produces an object
   byte-identical to the actual target. All26reported module frames are static;
   the conservative acyclic direct-call path totals1,280B:
   entry368→prepare672→preflight208→acquire32. Entry rises16B from the control.
   This excludes caller/SDK callback/interrupt frames and is not an end-to-end
   task-stack bound. New-image loader admission and actual command-task stack
   watermark remain unobserved; verify those in a later finite target smoke
   before interpreting any race timing. No allowance increase is inferred.
8. **Remaining integration gate.** These are the concrete native-image and host
   pins requested before performance execution. The prepared race guest still
   needs setup installation before Init/bind, private32-byte counter buffer51996,
   setup/memory logging, full cleanup after the final fence and unchanged timed
   full-race controls. It is not yet a runnable replacement of the reviewed
   game fixture. Return this capacity/image/proof to Golem before any performance
   request; a new central grant is required for every target run. No emulator
   launched after generation18release, no human/GUI/hardware/commit/push.

Approximate appearance and size stepping remain unaccepted. Preserve the
preparation error census, including small-object colour/mask changes and stock
generation versus additive-sampler differences; the later Author moving review
is the appearance gate. This work supplies no new road/traffic/player/sky phase
profile, independent120Hzscheduler or physical ESP32 performance claim.
