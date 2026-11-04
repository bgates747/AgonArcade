# Shared sender-progress observer integration v1

Prepare separate consumer profiles using one pinned host observer. It records
which serial API call last entered or returned, owning eZ80 batch progress and
existing public VDP counters. It changes no firmware or flow-control policy.
The package is host-tested and statically compatible with both named backends;
actual consumer execution remains a separate gate. This document authorizes
integration preparation, not a new emulator process or a repair claim.

## Frozen producer and tools

| Item | Identity |
| --- | --- |
| Original host frontend | `82e8492297fd9df07678fddbea83b563d0543fdfadb39ac77984a0bacf56b448`; rebuilt byte-identically before instrumentation |
| New observer r02 | `7e7d0e1bc89af72bde7ffbd6c06446aaefda4d1803f89eb1faf3167307ee1e01`; 1,954,496 host-executable bytes |
| Final producer readiness | `948bf79143738927ac7998f61a4d91bd4766c9aa2f9b1ccdf0af2245970fe1d2` |
| Source/reader/evidence archive | `464582cc7045412f27050e256c751f43c2f265b4733772bc3265b30fd4a656c2` |
| Offline reader | `12817411df487931407d1ec7cf4e51c9742a5f350582af2efce5db3fb4a96cde` |

Producer: `/Agon/mystuff/flexe-agon-emulator/docs/tasks/FX-114/readiness.md`
and its adjacent readiness.json/observer-contract.md/read_record.py.
Oryx binary: `/home/smith/Agon/mystuff/flexe-agon-emulator/build/fx114/candidate-r02/flexe-agon-emulator`.
Oryx reader/tools: the same project's `build/fx114/contract-r02/`.
Root independently verifies the actual candidate, 11 source/evidence files
and 19 archive members. Eight Rust observer tests, the pinned eZ80 library
suite and eight Python reader tests on each host pass. No target ran for this
preparation. Original r01, source and consumer failures remain preserved.

## Opt-in configuration and record

1. Set only `FLEXE_UART_OBSERVER_OUTPUT=/absolute/new/output.jsonl` in the
   selected child environment. The parent directory must exist; an existing
   output file is refused. Preserve SDL, backend, firmware, application, assets,
   send chunks and other settings. A new host binary is an explicit cohort
   change, even with observation disabled; it is not the historical baseline.
2. Fixed configuration: schema `fx114-sender-v1`, stasis trigger 50,000 ms,
   poll 100 ms, sample offsets 0/250/500 ms, lifetime 630,000 ms, at most five
   JSONL lines. Sender snapshots try at most four times. Do not tune these per
   consumer or change the consumer's deadline silently.
3. Sender fields: `publication`, `phase`, `cts_result`, `completed_sends`,
   `batches`, `ez80_cycles`, `paused`. Phases are `idle`, `entered_cts`,
   `returned_cts`, `entered_send`, `returned_send`. CTS is null except on
   `returned_cts`, where it is true/false. Null sender means unavailable.
4. Entered publications complete before calling the original function;
   completed-send count advances after return. Batch cycle/paused data is the
   most recent owner-thread publication, not the exact call-site clock or PC.
   Sampled VDP cycles/frames/failed are separate atomic scalar reads; neither
   they nor the sender record form a coherent cross-thread processor snapshot.
5. A reason string is not a diagnosis. Compare actual phase/publication/counts
   across samples; do not infer a persistent blocked call from repeated phase
   names with changing publications. Returned false does not locate the MOS
   instruction. Static sender map `7ab6c7f1` is interpretation only, no live PC.
   Producer nonprogress, OS scheduling and receiver consumption remain separate.

## Consumer ownership and compatibility

| Consumer | Keep fixed | Declared host change |
| --- | --- | --- |
| 6502, primary | Failed mode21 app `9b7290bd`, module `a94fec8f`, backend `0866265b`, firmware `f30b299a`/ELF `3ea64b06`, MOS/ROM/font/assets/history | Original host `82e849` to observer `7e7d0e1b`, plus the single opt-in output variable/new evidence paths |
| Rally | Frozen original guest `685f4b4c`, application closure `b986dbf9`, explicit one-frame config `13950bb0`, assets/module, old backend `200f28cb`, firmware `8da2ebfd` | Old host `28f50e87` to new observer `7e7d0e1b` is a distinct cohort, not a single observer-only comparison |

Exact old200f and maintained086 export the required cycles/frames/failed getters.
Actual-library/source inspection finds direct atomic loads, no calls/locks.
No backend rebuild, firmware hook, runtime offset or plain-state fallback is
required by this static integration. Missing getters fail opt-in admission.
This is not yet proof of live old200f compatibility. Rally applies the same
eventual qualified runtime to both fresh arms and excludes old FPS from any
HUD-only causal comparison.

## Preparation and next target boundary

1. Preserve every failed profile/output. Make a new stopped canonical profile
   with a real generated wrapper and pinned raw `.bin`, backend/firmware/ELF,
   MOS tags, unchanged consumer payload and exact diagnostic child environment.
   Freeze source, artifacts, predicted observations, commands and cleanup first.
2. Return readiness through the central mailbox plus immediate chat. 6502
   prepares one observed reproduction of its exact failed startup history;
   existing 600 s startup/900 s overall/30 s normal-quit limits remain ceilings.
   It may propose a separately frozen early normal stop after a complete
   observation at the same still-stalled font boundary, without calling that
   a functional pass or changing target pacing. No automatic retry.
3. Rally's existing START-001 budget stays at most two explicitly selected
   300 s processes with its evidence-bearing 60 s progress/95-degree guard and
   owned power restoration. This contract adds no process. Freeze the observed
   startup-control choice before any target; cached/performance successors
   remain gated on startup success. Do not rerun the old unobserved failure.
4. A 50 s trigger normally leaves 9.5 s before Rally's 60 s guard; scheduling
   can still delay collection. Missing/interrupted/late samples are incomplete,
   not permission to extend a timeout. The observer never stops the guest or
   forces progress. Main cleanup waits at most 250 ms for reader finalization;
   external normal/forced teardown and whole-host process proof stay required.
5. After the separately selected technical scope is frozen, use the shared
   self-service FIFO. No Golem machine-time approval, queue hold or human-review
   takeover. Assert ownership/guards, preserve first output, stop owned processes,
   retrieve/hash-check, release/notify-next before lengthy analysis. No GUI,
   hardware, default adoption or publication follows.

## Analysis and acceptance

Run the pinned `read_record.py RECORD.jsonl` with a project-local Python.
It reads at most 65,536 bytes/five lines and imports no emulator. Exit 0 means
finalized schema-valid only; exit 1 means missing final; exit 2 means invalid.
Report window completeness, actual elapsed times/100 ms offset-lateness rule,
sender availability and resumed/unchanged sends independently. Null is not zero.
Even a complete three-sample record does not prove receiver/FIFO/IRQ/PC state,
sustained stasis or a cause. A valid shutdown record is not a functional pass.

Keep raw UART/returned-delivered bytes, app phase/state, observer JSONL/reader
result, backend counters, exact pins and normal/forced process cleanup. Report
functional success/failure separately from observation collection. Changes in
timing or nonreproduction under instrumentation are not a repair. A coherent
receiver snapshot or source fix needs a new evidence-justified contract.
