# Minimal sender observation preparation contract

Executive summary: the exact failing host binary82e849 has been reproduced
byte-identically from its retained source/archive/private hostfs patch. The
candidate adds only opt-in owning-thread serial/batch publication and a bounded
atomic reader. It does not inspect UART/model state, add firmware bytes, alter
flow control or qualify a fix. Target execution remains unapproved.

1. Frozen base: a35b archiveeff797d9 plus hostfs patch8f799a19/machine de18bc75,
   original builderfda2d0f6/Cargo.lockb80ae5fa/rustc+cargo1.97.1. All227 source
   files verified and baseline1,924,872B reproduces82e849 exactly. Candidate is
   a NEW generated export; no current dirty checkout or CS0 patch is substituted.
2. Single owning eZ80/frontend writer publishes phase Idle/EnteredCTS/
   ReturnedCTS/EnteredSend/ReturnedSend, CTS result unknown/false/true,
   completed-send count, batch sequence, owning eZ80 total cycles and paused
   state. Each entered publication finishes BEFORE invoking the original call;
   a call cannot hold an odd/incomplete publication. Returned values/bytes and
   original branch semantics remain unchanged. No per-byte timestamps/files.
3. Shared record fields are atomic with sequentially consistent access and a
   complete publication version. Readers try at most four times; unstable or
   odd publication is unavailable, not zero or a reason to wait. Batch updates
   occur on the owning eZ80 thread. There are no live plain-model/CPU reads,
   lock-taking CTS calls from the reader or coherent UART/IRQ extension.
4. Reader combines snapshots only with existing backend atomic exports for
   VDP cycles/frames/failed. Exact086 exports are verified from maintained
   source. No new backend export or DLL change. Absence of required public
   getters fails opt-in admission; ordinary disabled launch stays disabled.
5. Proposed target input values, not execution authority: observer output path
   must be new/absolute; stall observation50,000ms, polling100ms, snapshots at
   0/250/500ms after first observed no-send-progress window, maximum reader
   lifetime630,000ms. It labels an observation, never declares a fault, stops
   the guest, forces progress or changes the owner's existing600s startup/
   900s overall/30s normalquit supervision. Metadata+three samples+final are
   at most five output lines. Required configuration and these values will be
   pinned before any separately scoped target; no defaults silently tune pacing.
6. Reader stop is atomic and sleeps in short cancellable pieces. Main cleanup
   allows at most250ms to observe reader completion, joins only a finished
   thread and reports missing finalization rather than introducing an unbounded
   wait. Existing external target supervision and fresh process-idle proof
   remain mandatory. Missing/unavailable record is not a transport diagnosis.
7. Device-free tests cover entered state while a fake original call remains
   blocked, exact once-only callback/return forwarding, completion count only
   after return, paused/batch coherence, bounded odd-sequence reader, concurrent
   publication, output bound/overwrite refusal and finite shutdown. Compile/test
   only on Oryx from immutable generated source, no actual SDL/device/backend
   target, attach, new FIFO request or peer profile deployment.
8. Frozen failed cohort: host frontend82e849, eZ80 APPLICATION9b7290bd,
   maintained backend086, firmwaref30b/ELF3ea6, MOSd564/mapd69e, modulea94fec8f,
   mode21, original fontfd6f284f and failed command history. The static sender
   report7ab6c7f1 maps future interpretation, not a live PC. Pinned objdump2.45
   negative-JR displays are0x100 high; use owner's signed-byte edges. No PC is
   sampled in this minimal candidate, and no ARM debugger offsets are reused.
9. Return exact candidate/source/schema/test/reader configuration and input
   contract closure before any target selection. A future owner must create a
   new stopped profile, preserve all original consumer bytes/history and record
   exactly the permitted host-binary/diagnostic environment difference. No
   consumer/source/firmware promotion or target profile mutation is implicit.
   Instrumentation can perturb timing; nonreproduction is never a repair.

Preparation revision r02: root103 adds old Rally compatibility. Its unchanged
60-second file-progress guard can preempt r01's60-second trigger plus500ms
series. Preserve r01/e5ed5a83 as evidence; select r02's50-second observation
trigger, identical0/250/500ms samples, completing about9.5s before that guard
when the sender is stale. This changes diagnostic observation timing only, not
any consumer timeout, firmware bytes, send pacing or source branch result.
Same revision/parameters must be pinned in both fresh Rally arms;6502 remains
primary. OS scheduling can delay samples, so record actual elapsed times and
treat interrupted/late windows as incomplete, never a successful diagnosis.

## Frozen r02 record and offline admission

1. The bounded reader is `read_record.py`; invoke it with the project's
   `.venv/bin/python` and a saved JSONL path. It reads at most65,537 bytes,
   rejects files over64KiB, accepts at most5 lines, rejects duplicate keys and
   validates exact field sets/types. No emulator imports, control or libraries.
   Exit0 means a syntactically valid FINALIZED record, not a functional pass;
   exit1 means missing finalization, exit2 invalid input. Inspect all report
   fields separately. Synthetic validator fixtures are not target evidence.
2. First line is metadata with schema `fx114-sender-v1`, event `metadata`,
   stall_ms50000, poll_ms100, sample_offsets_ms[0,250,500],
   max_lifetime_ms630000, reader_attempts4. Subsequent lines have exactly
   schema,event,reason,elapsed_ns,samples,sender,vdp_cycles,vdp_frames,vdp_failed.
   All counts/times are nonnegative integers, flags Boolean. `sample` rows
   count1..3 with reason `no_completed_send_progress`; `final` repeats count
   and uses `stasis_window_observed`, `interrupted_window`, `shutdown` or
   `reader_lifetime_limit`. Actual elapsed_ns is host monotonic elapsed time.
3. Sender is null when no bounded coherent snapshot is available; otherwise
   exactly publication(even),phase,cts_result,completed_sends,batches,
   ez80_cycles,paused. Phase names: idle,entered_cts,returned_cts,entered_send,
   returned_send. Only returned_cts has Boolean cts_result; otherwise null.
   `entered` is a completed publication BEFORE invoking the call, not proof
   that the thread currently executes inside C or waits on a lock. Batch cycles
   and paused are the LAST owning-thread batch publication, not live PC/state.
4. Frontend snapshots are coherent within their publication. The three VDP
   getters are sampled separately and do not form a coherent cross-thread
   instant with each other or the sender. No source-PC, UART queue, IRQ/task,
   firmware parser or hardware observation is present. Counter movement alone
   does not prove application progress or identify the cause of a stall.
5. Offline `window_complete` requires a finalized three-sample series with
   actual offsets at least0/250/500ms and no more than100ms late for each,
   all before630s. This100ms tolerance is an explicit OFFLINE admission rule;
   it changes no runtime timeout. Finalized-but-late, missing-final, interrupted,
   null-sender and resumed-send observations remain separately visible. Even a
   complete series with unchanged sends is not a transport diagnosis. The
   reader can collect a series after progress resumes; inspect the reported
   completed_sends_unchanged flag, never assume the reason string proves stasis.

## Existing backend availability and stopped-profile input contract

1. Static inspection of exact old Rally backend
   `200f28cbe399b1fdc60cba1e5fed4c2bb86042b5e92f6e422539a5388c079a30`
   and maintained6502 backend
   `0866265bd6f3d73ad572f31dc1bb954f308ed9a5d857efa9414d37e1ade13374`
   finds all required public C exports: `flexe_vdp_cycles()->u64`,
   `flexe_vdp_frames()->u64`, `flexe_vdp_failed()->bool`. Actual x86_64
   functions are aligned counter loads/return, with no calls or locks. Old
   backend counter-writer inspection finds64-bit xchg/lock-add and byte xchg;
   retained adapter source declares atomic counters/getters. This is STATIC
   ABI/read-semantics evidence, not a full reproduction of old200f or a live
   qualification. No source offsets are used by the reader. No new backend,
   firmware hook or plain-field fallback is needed. Missing public getters
   fail opt-in admission; no unavailable getter is fabricated as zero.
2. Candidate Oryx binary remains stopped in OWNED
   `build/fx114/candidate-r02/flexe-agon-emulator`, SHA
   `7e7d0e1bc89af72bde7ffbd6c06446aaefda4d1803f89eb1faf3167307ee1e01`.
   This is an integration INPUT pointer, not a deployed/qualified consumer
   profile. Future owner creates a NEW stopped profile using the canonical
   setup tool, with real `flexe-agon-emulator` wrapper/raw `.bin` and naming
   migration. Preserve each consumer's original MOS, firmware, backend,
   guest/modules/SD streams/config/history except already declared owner deltas.
   Verify every input SHA before selection. Do not replace an existing profile.
3. Set only `FLEXE_UART_OBSERVER_OUTPUT` to a NEW absolute owned JSONL file;
   all observer timing is compiled/pinned above, not tuneable through an
   implicit env override. Disabled env means no observer file/reader. Preserve
   existing backend/host library wrapper environment and consumer supervisors.
   No special CTS polling, rescue, guest bytes or flow-control behavior added.
4. Primary6502 cohort: exact82e849 baseline identities in item8 above, same
   original command/font/application inputs; only declared candidate frontend
   and observer output environment difference. Keep600s startup/900s overall/
   30s normalquit guard unchanged. No observed hardware/root cause claim.
5. Rally freeze `APPLICATION-FREEZE.json`
   `b986dbf9ce25f80a5ca34d104b9afb8aed6fe2adb01893613a9ceb36c38683e1`
   keeps original guest685f/allstreams with explicit config60frames->1
   (13950bb0). Owner retains custom firmware8da2/backend200f and all original
   setup/warm/tick/StopUNLOAD behavior. Candidate82-derived frontend replaces
   old28f50 only as a NEW declared cohort applied equally to BOTH fresh arms;
   never pool old FPS. Keep300s supervisor/60s file-progress guard/normalquit
   and thermal/power ownership unchanged.50s trigger normally leaves9.5s for
   the series; scheduling/consumer termination can still prevent completion.
6. Profiles have NOT been created or changed in this preparation. Owner/root
   must select integration/execution separately, obtain self-service FIFO time
   with fresh idle proof, preserve normal teardown and release before analysis.
   No target/device/attach/repair/default/commit/publication permission follows
   from this document or from a successfully built diagnostic binary.
