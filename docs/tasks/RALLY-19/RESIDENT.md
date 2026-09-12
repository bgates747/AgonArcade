# R19-05 resident state, lookup and lifecycle

Golem implementation: `af8d91ee65416cde80ab8afb28d8adb7f310c007` in the isolated
sibling `golem-rally19` worktree. Its authoritative implementation specification
is `docs/design/rally19-resident-v1.md`. Root Rally TODO.md owns task progress.

## What is qualified

The existing C++ Golem compiler imports exact-size source-relative assets and
fixed-record tables, validates every imported record against its typed destination,
guards dynamic indices, patches a separate copy instruction and performs stock
matrix arithmetic on the selected data. Cleanup is compiler-generated direct
stream commands for owned IDs only. Aggregate data/program/scratch/ID budgets
are enforced; the map separates payload categories and bootstrap footprint.

`admission.golem` implements the frozen 80-byte wire-state checks on stock VDP.
Sticky RequireRange/RequireEqual lower to normalized byte comparisons, handling
negative values and legitimate position words of 0xFFFF without the firmware's
missing-value collision. The complete typed record is copied only after every
check passes. A finite numerical proof doubles admitted progress, then records
accepted count/sequence. It is deliberately a proof entrypoint, not the road/car
renderer. Seal clearing after every submit prevents a short following prefix
from reusing the previous seal. Track identity is fixed by bootstrap/reload.

Status buffer 1002 has u16 valid at 0, wrap-test result at 2, accepted count at 4,
last accepted sequence at 6, and error at 8 (0 accepted, 1 rejected). Buffer 1003
holds next expected u16 sequence, modulo 65535. Complete ordered state update
plus trigger remains 97 bytes; the ABI and final 100-byte including-swap budget
are unchanged. The eZ80 probe supplies opaque bytes and diagnostic transport;
it does not perform the tested VDP validation, selection or numerical proof.

## Native evidence

| Evidence | Result |
| --- | --- |
| `golem-admission/recovery-oval` | 210 cases pass |
| `golem-admission/recovery-fuji` | 210 cases pass |
| `golem-lookup/large-allocation` | 72 record selections, nine reloads, all-byte and large-asset reads, three owned cleanups pass |
| Same lookup, external observer | Nine 4096-call batches retain identical live allocation counts/bytes; outer Escape received |
| `golem-lookup/host-tests-final.json` | Ordinary/hosted/import/admission ASan+UBSan and frozen design corpus pass |
| `golem-lookup/final-compiler-reproduction.json` | Final compiler reproduces exact qualified arithmetic, large lookup and admission byte streams |

Admission covers all invalid field classes, all declared short prefixes 0..79,
valid negative limits/-1, valid low words 0xFFFF, loaded-track mismatch, duplicate
and skipped sequence, diagnostic seed-and-wrap 65534->0, reload and first frame.
It separately interrupts ten header positions, five payload positions and five
trigger positions. Accepted state and proof remain unchanged for rejected/cut
inputs. Complete staging alone does not dispatch; one later trigger dispatches
once. A repeat trigger is rejected. These are ordered trusted-loader guarantees,
not a claim of arbitrary-corruption-resistant UART framing.

The large lookup imports 65535 bytes, samples offsets 0/255/256/32767/32768/65534,
and crosses record IDs 4095->4096. Its 66288-byte bootstrap spans multiple blocks
in buffer 0. It owns 18 IDs / 66016 resident payload bytes (65823 asset, 162 program,
31 scratch); cleanup is 108 bytes. The bootstrap is deliberately retained during
this probe and separately cleared on cleanup. Full admission owns 306 IDs / 8854
payload bytes, with 13171 bootstrap bytes. These are not allocator totals.

The Linux external observer tracks stock heap_caps_malloc and actual libc frees,
including delete[] paths, at explicit guest idle phases. Every warmed lookup
sample is 239 live allocations / 222600 bytes before and after each 4096-call
batch. Each cleared cycle is 32 / 83832; initial sample is 31 / 83600. The stable
232-byte increase is retained warmed container capacity, not recurring growth.
Peak tracked bytes are 304498 including mode changes and retained bootstrap.
Allocations bypassing heap_caps_malloc, fragmentation, full host RSS and physical
ESP32 limits are outside this measurement. No timing claim uses the observer.
Original runtime hashes before/after match. GP observes parser/buffer progress,
never documented raster completion. This does not qualify full-scene bitmap cache
lifecycle or ten-minute replay; those remain later milestones.

## Retained failures and parser caveat

The initial admission build failed on an unused loader constant; its log remains.
The first memory sampler expected LF and ignored MOS CRLF markers, so the final
Escape was not injected and the guest reported failure. The corrected sampler
passes and preserves the failed evidence.

`golem-admission/complete-oval` intentionally expands the earlier 180-case suite
with raw header/trigger cuts. At header cut length 6 (after buffered command 5),
500 ms idle was insufficient: stock bufferAdjust continues several reads before
checking `command == -1`. Each absent read can wait another 200 ms. A diagnostic
GP sent too soon can become header data and fail to echo. Final tests use **2000
ms idle for header/trigger cuts**, 500 ms for payload cuts, and then verify parser
recovery before the next complete packet. No trigger follows an interrupted
write. These delays exist only in fault-injection diagnostics. No stock firmware
patch or custom callback was introduced; the ordinary ordered frame is unchanged.

## Reproduce / continue

From this Rally worktree, with agondev and canonical stock runtime available:

```sh
.venv/bin/python docs/tasks/RALLY-19/probe_admission.py NEW_OVAL
.venv/bin/python docs/tasks/RALLY-19/probe_admission.py NEW_FUJI --track fuji
.venv/bin/python docs/tasks/RALLY-19/probe_lookup.py NEW_LOOKUP --memory
```

Use fresh names; evidence and profiles must not be reused. All emulator work is
headless and normal-clock via the generated profile wrapper. The memory observer
requires Linux glibc, g++, SDL3 headers and libdl; no timing run should preload it.
No alerts, pushes, SD deployment or original-worktree changes are authorized.

R19-06 now replaces the finite admission proof with one complete road section
computed from actual compact track coefficients and state. Preserve the existing
integer quantization points, independent stripe phase, signed lateral behavior
and every road material against the frozen oracle. Measure construction choices;
do not infer that a correct arithmetic/admission probe is a fast full renderer.
The current admission program uses 306 IDs; account for that alongside both
tracks when choosing the renderer's table/scratch layout under the 1024-ID cap.
