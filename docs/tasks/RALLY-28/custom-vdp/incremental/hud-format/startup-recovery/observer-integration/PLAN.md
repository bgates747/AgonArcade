# Observed original-control startup — technical readiness only

Prepare exactly one observed control using the frozen startup application.
Golem111 selects this integration preparation under the existing START-001
budget; it does not select execution or a HUD performance cohort. No emulator
has run and no queue time is reserved. The second possible START-001 process is
unselected: it has no profile, launch command or automatic condition here.

- **START-001-02-OBS01** [x] — Consume the shared `uart-observer-v1.md` contract
  `e143d4a7…`, producer readiness `948bf791…`, observer `7e7d0e1b…`, archive
  `464582cc…` and offline reader `12817411…`. Save immutable local copies of
  the contract/producer/reader/static compatibility evidence under `vendor/`.
- **START-001-02-OBS02** [x] — Prepare one fresh stopped canonical profile,
  `rally28-hz60-startobs01-control` on Oryx. Preserve original application freeze
  `b986dbf9…`, guest `685f4b4c…`, one-frame config `13950bb0…`, old adapter
  `200f28cb…`, firmware `8da2ebfd…`, ELF/MOS/assets/native/motion/history. Only
  the host frontend and diagnostic wrapper/output paths change. Canonical
  naming, real wrapper/raw binary, shell syntax and file-hash checks pass.
- **START-001-02-OBS03** [ ] — Return exact technical readiness through canonical
  mail and immediate chat. Freeze source/input/profile/predictions/cleanup before
  a future target selection. This subtask completes when delivery succeeds.
- **START-001-03-OBS01** [ ] — Held: separately selected one-process diagnostic
  only after technical return and FIFO checkout. No automatic second process,
  retry, cached guest, smoke suite, full benchmark, repair or firmware change.

## Exact chosen diagnostic

Oryx profile:
`/home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-startobs01-control`.
The application still performs original asset/setup, two warm pages, one race
frame/four ticks, then Stop/UNLOAD/timer restoration/normal MOS exit. The complete
226-native-reply prediction and exact311-byte frame are frozen one level above.

The actual host changes from Rally's old `28f50e87…` to observer `7e7d0e1b…`,
whose baseline was independently reproduced as `82e84922…`. This is a declared
new host cohort. Static old-adapter getters are direct atomic reads; live
compatibility is unqualified until this selected consumer actually runs. There
is no backend/firmware rebuild. Later fresh HUD arms must share the same
eventually qualified runtime, and must not pool old FPS.

The wrapper hard-sets video/audio dummy and JIT. Its only new diagnostic variable
is the fixed child `FLEXE_UART_OBSERVER_OUTPUT`:
`/home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-startobs01-control/last-run/sender-progress.jsonl`.
That file must be absent; the normal runner creates its parent before launch.
Existing output is refused, preserving every earlier attempt.

Fixed schema `fx114-sender-v1`:50,000ms trigger,100ms poll, samples0/250/500ms,
630,000ms observer lifetime, at most5JSONL lines, four bounded snapshot attempts.
The observer lifetime never extends the consumer deadline. Native/drawing
command bytes, chunks and target pacing remain unchanged.

## Predicted outcomes and separate gates

1. **Successful startup/one-frame exit:**226 exact ordered native replies,
   generation8/request3/world4, exact final state and311-byte timed stream;
   original clean MOS prompt/timer/Stop/UNLOAD. If no50s send stasis occurred,
   observation normally contains metadata and final shutdown with zero samples.
   That is not a three-sample transport observation. Valid schema/finalization
   plus actual functional evidence are separate qualifications, never new FPS.
2. **The upload still stalls:**the50s trigger may collect three samples before
   the unchanged60s UART-file progress guard. Save actual elapsed times, sender
   phase/publication/counts, separate VDP scalar reads, raw UART and exact partial
   command. At the guard use normal shutdown; do not extend it for missing/late
   samples. This is a diagnostic stop, not functional success or a repair. The
   tranche ends with no retry even when the stall was anticipated.
3. **Admission/observer/guest/cleanup failure:**preserve its first evidence and
   stop. Null sender means unavailable, never zero. Reader exit0 means finalized
   schema only; exit1 means missing final; exit2 means invalid/missing record.
   Incomplete/interrupted/late or resumed-send observations retain those labels.

The reader's100ms sample-lateness rule is offline admission only. Repeated phase
names do not prove a blocked call if publication/counts change. Owning eZ80
cycles/paused are last-batch publications; VDP cycles/frames/failed are separate
scalar reads. Neither side is a coherent cross-processor snapshot. There is no
live PC/FIFO/IRQ/parser witness and no generic cause claim from these fields.
Instrumentation may change timing; nonreproduction does not fix the old stall.

## Frozen supervision and future commands

The prepared runner reuses the unchanged HUD control's60s UART guard and its
Pi live-owner assertion immediately before the canonical profile launcher.
The unchanged Oryx session supervisor retains95°C stop, temporary boost0 and
restoration of actual initial boost after owned teardown. Work deadline287s
reserves10s normal TERM grace and3s forced-cleanup wait within300s of process
lifetime. Forced cleanup is a failure. Offline reader processing follows child
stop; collector/child evidence is copied even when its record is unavailable.

Only after separate technical selection, shared FIFO reserve/fresh whole-host
idle/checkout and exact readiness assertion, the prepared command **on Oryx** is:

```bash
cd /home/smith/Agon/mystuff/AgonArcade
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/startup-recovery/observer-integration/runner.py --lease CHECKED_OUT_RALLY_LEASE
```

The runner invokes `./flexe-agon-emulator` inside the selected profile. No raw
frontend or graphical entrypoint is used. Retrieve/hash-check all `last-run`,
guest result/state/timers/replies/stages/player, observer JSONL/reader result,
run/campaign/session receipts and failure files. Stop only owned processes,
take fresh whole-host idle proof, release FIFO and immediately notify next chat
before lengthy offline analysis. Then run the application raw/state audit and
pinned offline reader locally. A normal frontend exit or valid record alone is
never application success. No physical hardware, default or publication change.
