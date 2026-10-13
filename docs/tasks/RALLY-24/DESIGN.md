# RALLY-24 proposed ABI and execution design

## Executive summary

Propose one buffer-only module, entry0 BIND and entry1 PREPARE. A112-byte world-state update describes all six opponents and the player/camera. PREPARE writes three bounded command lists. Existing VDU wrappers guard them and preserve frame order. Implemented and locally checked in experiment/ under LOCAL-CONTRACT.md; physical behaviour remains unqualified. See LOCAL-RESULTS.md for the completed local tranche.

## 1. IDs, entries and ownership

Reserve candidate IDs31000..31015 (no named allocation in the inspected Rally paths; recheck full build before implementation). Never borrow bitmap IDs64000+, existing section IDs30000..30009, scenery/font/sprite resources or externally owned buffers.

| ID | Role / allocation |
|---|---|
|31000|Module package, exact uploaded length ≤16KiB|
|31001|32-byte immutable arguments/config for a bound track/session|
|31002|112-byte state, updated in place by eZ80|
|31003|Selected-track immutable asset buffer; directory and arrays|
|31004|32-byte status, native writes / wrappers inspect|
|31005|20KiB road + finish-line command output|
|31006|2KiB merged signs/traffic command output|
|31007|256-byte player/existing crash visual command output|
|31008|PREPARE wrapper (clear ready, RUN); handle patched only after LOAD|
|31009..31011|Guarded road, actors, player wrappers|
|31012..31015|Reserved, unallocated initially|

Entry0 BIND validates arguments, asset directory, identities, lengths, table bounds and output sizes once per load/track/session; records IDs/lengths/checksum in private module state, never buffer pointers. Entry1 PREPARE rechecks state/header/ranges and acquires live views. INIT zeroes private state; FINI drops private state without owning application resources. Unknown entry returns unsupported. Changing buffers/config requires rebinding outside queued drawing.

32-byte argument layout, little-endian: magic`R24A` at0; ABI u16=1 at4; bytes u16=32 at6; session u32 at8; state/assets/status/road/actors/player buffer IDs u16 at12/14/16/18/20/22; track identity u32 at24; reserved u32=0 at28. Output sizes are fixed by ABI1 and checked against real view lengths.

Asset directory:32-byte header (magic/version/total length/track identity/count/lap length/checksum/reserved, with exact field packing finalized by serializer tests), ten16-byte records (tag:u16, elementBytes:u16, count:u32, offset:u32, bytes:u32); tables listed in REVIEW. Reject overlaps, bad widths/counts, arithmetic overflow and wrong selected-track checksum. The directory is generated from retained data without altering it. Exact bytes/header fields are specified below to eliminate serializer ambiguity: magic`R24T`0..3; version:u16 at4; count:u16=10 at6; bytes:u32 at8; trackIdentity:u32 at12; trackPointCount:u16 at16; reserved:u16 at18; lapWorld:u32 at20; FNV1a32 of bytes32..end at24; reserved:u32 at28. Align table offsets to four bytes, with zero padding; tags1..10 follow REVIEW table order, splitting band offsets/ends and phase index/offsets/rows into distinct records.

## 2. Frame state: exactly112 bytes

All multibyte values little-endian; no C struct cast across CPUs. All six slots are present, in stable livery order.

| Offset | Type | Meaning |
|---:|---|---|
|0|4 bytes|`R24S`|
|4|u16|Version1|
|6|u16|Bytes112|
|8|u32|Bound session ID|
|12|u32|Frame sequence, monotonic; rebind before wrap|
|16|u32|Physics tick snapshot, diagnostic/animation reference, not a new clock|
|20|s32|Camera station in hundredths, normalized to selected lap|
|24|u16|Stripe phase0..7999, independently supplied; cannot derive it from lap station|
|26|s16|Steering, -21..21 in256-circle units|
|28|s32|Player lateral Q8, current ±150×256 bound|
|32|u16|Flags: bit0 show traffic; bit1 panel visible; bit2 perspective; others zero|
|34|u16|Existing crash remaining ticks0..150|
|36|u16|Existing invulnerability remaining ticks0..120|
|38|u16|Reserved zero|
|40+12i|s32|Opponent i station, hundredths, normalized|
|44+12i|s32|Opponent i lateral Q8; native uses truncation `/256` matching current view|
|48+12i|s16|Opponent i route heading,65536 units/turn|
|50+12i|u8|Active bit0; others zero|
|51+12i|u8|Reserved zero|

Inactive slots require zero position/lateral/heading for canonical encoding; they emit no car. Local tranche validation uses the current routes proof: active lateral Q8 is -14260..14260 and route heading is -1920..1920. Packets beyond these bounds are rejected; widen the ABI contract explicitly if routes change. Slot index supplies bitmap/livery identity. No collision outcomes or traffic position integration move here.

## 3. Invocation and command publication

1. eZ80 serializes a coherent snapshot after its normal physics catch-up. Update31002 with stock buffered ADJUST set-multiple (`23,0,A0,id;5,C2,offset;length;data`):11 header bytes+112 payload=123.
2. CALL31008 (6 bytes). This resident wrapper sets status.ready=0 with an ordinary byte SET **before** the17-byte silent RUN. This catches runtime failures that occur before module entry. Module sets a default error/status, validates inputs and generates all three lists; write ready=1 only after all have valid terminators and status sequence/session match. Retrying a failed sequence is allowed; duplicate successful sequence is rejected. No checksum protects an incomplete stream against arbitrary corruption; transport integrity is a prerequisite, not supplied by a sequence number.
3. eZ80 draws existing scenery using its small heading/history path, independent of road projection. CALL31009 (6 bytes) conditionally calls31005 if ready==1, drawing road and finish stripe.
4. eZ80 sets existing actor viewport. CALL31010 (6 bytes) conditionally calls31006. Native list merges signs with traffic and restores expected transform/viewport state.
5. CALL31011 (6 bytes) conditionally calls31007 for player/current crash effect. Host panel/HUD/bottom and swap follow unchanged.

Total recurring road/car channel:123+24=**147 bytes**. These counts exclude other frame traffic, binding/install and diagnostic replies. Wrappers themselves execute buffered commands, but contain no road arithmetic. No per-frame readiness readback is required.

Each generated list ends with `23,0,A0,FFFF;7` (six-byte jump-to-end). Both docs and pinned dispatcher implement this as return from current buffer. Unused allocation tail is never parsed. Include terminator in capacity bounds; never patch executing wrappers. A stock conditional CALL reads ready from31004; the output header itself is not executable. No output buffer may alias state/config/assets/status, even under another ID: startup creates distinct buffers and BIND must reject aliasing via live view ranges.

Status layout: ready:u8 at0; reserved0 at1; moduleStatus:u16 at2; session:u32 at4; completedSequence:u32 at8; roadBytes:u16 at12; actorBytes:u16 at14; playerBytes:u16 at16; bands:u16 at18; cars:u16 at20; signs:u16 at22; reserved zero at24..31. Runtime INFO last-status is separate; report it on diagnostic failures. Ready gating prevents stale road/car execution, not successful rendering of a partial whole frame: host HUD/swap can continue on a failed request. In qualification every failure stops the run; production error-report cadence/abort behaviour is a later acceptance gate. A low-frequency requested INFO reply can detect failures without steady per-frame acknowledgements, but its cost must be included and keyboard coexistence qualified.

## 4. Buffer lifetime and stack

Acquire/read32-byte arguments and copy IDs, then release. Acquire/read112-byte state into bounded private scratch, then release. Hold asset READ, status WRITE, and one output WRITE at a time: at most three simultaneous leases; four if an implementation retains arguments temporarily. Every exit releases leases (runtime also closes them). Shared_ptr ownership protects a live view; it does not permit retaining its raw pointer across calls.

No per-frame heap allocation inside the module. Read tables in resident buffers; private scratch budget target ≤2KiB, hard ABI limit4KiB including rodata/data/BSS. Avoid copying large tables/arrays onto stack. Code must fit8KiB and package16KiB; build/stack/disassembly gates are not yet passed. VDU parsing/Canvas internals may allocate even if our module does not.

Use one active module for A/B initially. Packages remain ordinary buffers. Loading another changes the runtime handle and clears private state: rebind, patch wrappers, validate before use. At65535 admitted loads per runtime generation the current loader refuses further loads; lease-generation exhaustion also exists. Thus even capacity-fitting per-frame module swaps cannot be assumed indefinitely sustainable. Keep RALLY-26 state-transition loading proposal separate; propose runtime changes only to its owner.

## 5. Candidate separation

A: native lookup/band selection, car/sign/finish/player placement; generate existing25-byte section update/call sequences into road output. This isolates host offload/wire benefit and retains exact section matrix behaviour.

B: same state and ownership, but native road corner generation and direct colour/PLOT commands replace section matrix operations. Car bitmap scaling remains ordinary stock affine rendering; generated matrix packets are resident and need no eZ80 projection. Preserve source road strip extents/order and signed rounding. No new direct-colour framebuffer service.

Existing crash geometry must move because it uses player projected centre; eZ80 still supplies its counters and owns crash logic. This is a small port of current visuals, not RALLY-26's new resident animation/state-machine system. Signs/finish move for the same reason. Scenery, menus, HUD and audio remain explicit residual eZ80 traffic.
