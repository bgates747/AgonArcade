# Independent attribution of Rally's original-art startup timeout

The timeout in Rally's recent FIFO handoff is a real, separately preserved
generation49 control run, before Rally initialization or rendering. It concerns
stock buffered artwork commands on the **older custom VDP firmware**, not an
official stock-firmware run or maintained086. The cache candidate never ran.
There is no new FPS or common-cause conclusion. This2026-10-31 return answers
Golem's `golem057-stock-upload-witness-eightysix` using saved evidence only.

## Exact witness

All paths below are under
`/Agon/mystuff/AgonArcade/docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/`.

1. **Identity:** `hudsmoke01/control`,60-frame configuration, native compact
   original guest. FIFO request`5c6fe3061222`, checkout generation49. This was
   the first process of the newly frozen HUD comparison; the candidate smoke
   and four900-frame cases are UNRUN. No retry occurred.
2. **Profile:** `/home/smith/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-hudsmoke01-control`
   on Oryx. `PROFILES-hudsmoke01.json` pins its full runtime/SD inputs.
   `SMOKE-FIXTURES.json`, `fixtures-smoke60/control/expected.json` and
   `READINESS-FREEZE.json` pin local fixtures. All84readiness files,
   103preserved control/archive inputs and21failure-witness files were rechecked
   without modification for this response.
3. **Runtime:** JIT frontend`28f50e87…`, adapter`200f28cb…`, custom firmware
   `8da2ebfd…`, MOS3.0.2. Native image`479fe1ac…` is successfully loaded; there
   is **one** exact LOAD reply token1/kind2/handle1, not an absence of native
   activity. No subsequent Rally Init/RUN13, Render/RUN15, warm or timed request
   is in the capture. `ATTRIBUTION-PINS.json` supplies the full hashes.

## Raw progress boundary and missing observations

1. Raw directory: `evidence/hudsmoke01/control/`. Outgoing capture is224,661B,
   SHA256`da97a4d4afb58a2fb101f36ab49bd12fd99e0c28aecec7d5ed8820fb68ee92ce`.
   Returned and eZ80-delivered streams are byte-identical345B,
   SHA256`b19015eb9719d772551b21e8274ae397a1a0809c21b1daefcab10fb1837e50e3`.
   All103multiplexed return packets decode, including the single native LOAD.
2. Original `assets.vdu` begins at outgoing offset35,335 and its149,554B are
   present in full. `artwork.vdu` begins at184,889 and its39,772B captured tail
   is an exact prefix of the58,780B expected file;19,008B are not captured.
3. Structured parsing skips all five complete7854B original-player uploads,
   bitmap registration commands and the first256B recolor table. The prefix
   ends9/11B into buffered command72 beginning at artwork offset39,763,
   absolute224,652: destination64008, source64003, map63960. Expected command
   bytes are`17 00 a0 08 fa 48 10 03 fa d8 f9`; only the first nine were
   host-enqueued. The final map-ID bytes`d8 f9` are absent.
4. These are **host-enqueued** bytes/counters, not proof of firmware consumption
   or its current parser PC. No live CTS/RTS, forward queue depth, FIFO, IRQ,
   task state, PC or per-byte progress timestamps were captured. The stock
   recoloring call at the boundary is not thereby proved to be the operation
   holding up firmware. Returned LOAD proves earlier consumption only.
5. The frozen guard watches both capture-file lengths and stops after60host
   seconds without a size change; the overall per-run limit remains300seconds.
   `file()` has no deliberate quiet interval while submitting the asset stream.
   The precise firmware quiet time, legitimate processing duration and root
   cause remain unqualified. Zero failed/unhandled/unregistered/unmapped backend
   counters do not prove forward progress. Backend2231scanout frames are not
   completed Rally frames or game FPS.

## Shutdown, release and the earlier distinct case

1. Process67.216host seconds; supervised session67.897host seconds, max63°C
   under the unchanged95°C guard. Both SDL drivers dummy. Actual original
   boost1 restored1. Frontend exits0 and stats are preserved, but there is no
   guest result/state/timer file, Stop/UNLOAD or MOS cleanup witness.
2. Raw was retrieved, fresh whole-host inspection was empty and generation49
   released before analysis. `CHECKOUT.json`, `SESSION-hudsession01.json`,
   `ORYX-AFTER.json`, `RELEASE.json` and `HANDOFF.json` record this. Checkout
   2026-10-31 15:00:33 EDT; release15:02:37 EDT. The successor request
   `543ca7e88e76`/agon-6502 was notified immediately in its verified-idle chat.
3. The earlier prepared-image third-arm failure is **generation28 on2026-10-30**,
   at `custom-vdp/prepared-bitmap-set/prepared-benchmark/`. It captured233,974B,
   six early native replies and48,640/58,780artwork bytes. Its last expected
   block was buffer63800's2048B upload with377payload bytes present and1671
   absent. That is not this generation49 command72-argument boundary. The
   earlier pair's completed FPS also does not belong to this failed smoke.
4. The reported6502 maintained086 UI-font observation has not been independently
   audited by Rally. Similar pre-RENDER placement is context only; no equivalence
   of firmware, stream boundary, clock/CPU path or cause is asserted.

Saved evidence is sufficient for independent source review, but not for adopting
a UART/CTS or command72 diagnosis. `failed_startup_audit.py` and the unchanged
21-file `FAILURE-FREEZE.json` reverify this witness offline. Original captures,
freezes and fixtures stay immutable. No emulator, Oryx contact, source edit,
retry, new test or commit/push was performed for this attribution response.
