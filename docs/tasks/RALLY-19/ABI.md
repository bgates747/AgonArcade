# R19-03 — Stock-VDP resident scene ABI v1

Frozen design, 2026-09-12. The Golem language/lowering contract is
`../golem-rally19/docs/design/rally19-hosted-v1.md` relative to the repository
root. This ABI extends the accepted 949f618 full scene; it does not alter input,
physics, world scale, projection, surface behavior, artwork or the visual metric.
`scene_protocol.hpp` is an executable layout/validation contract, **not yet a
game integration or proof of resident VDP validation**.

## Responsibilities and immutable assets

The eZ80 retains the exact accepted key polling, incremental steering, throttle,
grip/surface rules, manual cornering with optional autosteer, demo controller,
opponent progression, and unchanged 30 Hz interactive deadline. It sends raw
world state and accepted HUD values. It must not send projected corners, car
scales, sorted display lists, road-section endpoints or scenery bearing.

Golem-owned resident programs select track records, evaluate the accepted
lookup polynomial, derive material/section boundaries from independent phase,
draw the road, compute player/traffic positions and yaw, order traffic, and
maintain retained scenery state per drawing buffer. Five original car views,
all seven VDP-generated liveries and native affine reflections remain intact.
The accepted road polynomial's quantization points and fixed-centreline camera
are the oracle; switching to mathematically different generic 3D is not allowed.

Existing static assets are uploaded once. Track points, compact projection
coefficients, phase/boundary tables and yaw-selection data are imported as
bounded resident tables. Offline layout/repacking is allowed; pre-rendered
per-frame projected geometry indexed by fixture number is not. The 66 visual
fixtures and 64-pose timing workload are validation inputs, never render assets.

## Exact recurring state

All integers are explicit little-endian; never memcpy a host C++ struct. Progress
is the accepted integer simulation value with 100 units/world unit, independent
from stripe phase. Wire integers are finite by construction; float matrices are
created on VDP from typed integer fields.

| Offset | Bytes | Field and range |
| --- | ---: | --- |
| 0 | 2 | Version, exactly 1 |
| 2 | 2 | Payload size, exactly 80 |
| 4 | 2 | Sequence, 0..65534; modulo 65535 |
| 6 | 2 | Track, 0 oval / 1 Fuji; must match loaded track |
| 8 | 4 | Player progress, signed32: 0..575999 oval, 0..3276799 Fuji |
| 12 | 2 | Independent stripe phase, 0..7999; never recompute from lap position |
| 14 | 2 | Steering, signed16: -21..21 in accepted 256-circle units |
| 16 | 4 | Player lateral, signed Q8: -38400..38400 |
| 20 | 2 | HUD/player speed, 0..300 |
| 22 | 2 | HUD surface, 0 road / 1 kerb / 2 grass |
| 24+8i | 4 | Opponent i progress, same per-track range, i=0..5 |
| 28+8i | 2 | Opponent i lane, signed16: -90..90 world units |
| 30+8i | 2 | Reserved, must be zero |
| 72 | 2 | Flags: bit0 demo, bit1 optional autosteer, bit2 optional perspective; all others zero |
| 74 | 2 | HUD grip percentage, 25..200; accepted default 60 |
| 76 | 2 | Duplicate sequence, must equal offset 4 |
| 78 | 2 | Seal, exactly 0x5A19 |

Opponent array order defines stable livery ID. The VDP derives distance/order;
no separate screen-space or sorting data is included. Perspective stays OFF in
the baseline/frozen fixtures; the flag preserves the accepted explicit option.
Lateral velocity and demo curve steering affect simulation but are not rendering
inputs; projected player view follows the accepted steering field, as before.

`test_scene_protocol.cpp` qualifies explicit LE layout, all short lengths,
trailing data, version/seal/duplicate-sequence/reserved fields, signed edge cases,
invalid track/state ranges, non-mutating rejection and sequence wrap under
ASan/UBSan. It deliberately includes legitimate position low words of 0xFFFF.
That value cannot be blindly fed to stock word conditionals (sentinel collision).
This test proves the host codec only. R19-05 must qualify the corresponding
finite VDP admission and transport failure paths natively.

## Ordered admission, dispatch and framing

1. A fresh load clears/initializes owned storage, imports the selected track,
   resets both retained scenery histories, sets the expected sequence to zero
   and installs all programs before admitting a frame. A track change requires
   the finite reload/reset entry, not a payload-only switch of table identity.
2. The host validates the complete state and builds the complete 97-byte packet
   in RAM. Failure returns without changing the output or writing UART bytes.
   One ordered write updates staging buffer 1000 with command 5 op 0xC2, offset
   zero, count 80; only after those bytes comes command 1 calling program 2000.
   Exact byte sizes: 11-byte adjust header + 80 state + 6-byte call = **97**.
   No HUD or unrelated command may interleave inside this packet.
3. Program 2000 checks loaded/version/length/seal/sequence/ranges before copying
   staging to active buffer 1001 or drawing. Reject by returning without changing
   accepted state, sequence or drawing-buffer history. Check expected sequence,
   rather than merely inequality, to catch duplicates/gaps. Sequence 65535 is
   reserved because stock buffer conditionals treat 0xFFFF as missing data.
   Use bounded high-word guards/normalization for full-width signed values;
   never reject a valid position just because its low word is 65535.
4. Accepted state dispatches one finite render. Mark that sequence consumed once
   when the resident command job has returned. This indicates accepted/computed
   submission, **not documented raster completion**. Diagnostics retain accepted
   count/last sequence/error code in owned status storage. No custom callback or
   firmware is part of production. R19-05 determines a stock-only, nonintrusive
   diagnostic readback path; it is not required on every production frame.
5. Initially eZ80 formats the accepted HUD text and emits its existing updates
   after the scene packet, then the stock three-byte swap. Stream ordering keeps
   these after the resident draw job. Count that swap as scene traffic:
   **100 scene bytes/frame**; actual HUD bytes are separate and total reported.
   Speed/surface/grip/flags in the packet preserve a complete state contract even
   while the eZ80 remains the HUD formatter. Moving HUD formatting to VDP is not
   necessary for this goal and must not expand its scope.

This is atomic-by-order at the hosted-job level, not a transaction added to the
stock UART parser. A cut write must not be followed by a trigger; the trusted
encoder/loader guarantees that. Sequence and seal are admission checks, not a
cryptographic checksum or arbitrary-corruption-resistant framing. A malformed
raw command can leave the stock parser awaiting bytes; diagnostic truncation
tests must prove a finite timeout/reset/reload path and never claim partial UART
headers are magically safe. No asynchronous in-flight overwrite of active state.

## Storage and lowering

| IDs | Ownership |
| --- | --- |
| 0 | Golem bootstrap, called once |
| 1..999 | Compiler-private legacy variables/constants/loop temporaries |
| 1000 | 80-byte staging state |
| 1001 | 80-byte accepted state |
| 1002..1099 | Status, expected sequence, constants and loaded-track metadata |
| 1100..1499 | Arithmetic matrices, never shared with pending bitmap transforms |
| 1500..1999 | Fixed-size command/coordinate templates and scratch |
| 2000..2999 | Finite hosted entrypoints; 2000 admission/render dispatch |
| 4000..4999 | Static track records, bounded indexed selection |
| 30000..30009 | Reserved accepted road programs while oracle is available |
| 63800..64100 | Existing artwork/livery/scenery/car-transform resources; explicitly imported, not automatically allocated |

Exact field and generated command operand offsets are compiler relocations and
must appear in its map. No magic Python patch offsets. An indexed record load
first validates its integer index, then patches a **separate** instruction
template's source ID/offset and calls it. It must not rewrite a running program.
24-bit offsets/block selection are allowed where needed by stock commands; a
segmented buffer-per-track-interval layout is an alternative within the ID budget.
Select the measured layout at R19-05/06; the state packet remains identical.

Evaluate compact A/B/C/D/E polynomials in bounded small float matrices or affine
data batches. Preserve signed quantization/error behavior against the frozen
road endpoints. Matrix32/33 supports affine inversion; matrix34 has no generic
inverse. Command41 transforms strided typed coordinates without perspective
division and preserves their numeric format. Golem's signed-store lowering uses
positive bias before unsigned stock conversion, with explicit bounds. Large
road batches use strided points, avoiding large padded square matrix multiplies.

Each opponent has its own bitmap affine matrix, invalidated/regenerated through
stock operations before reuse. A byte patch alone must not leave its inverse
cache stale. Material/plot templates and arithmetic scratch have disjoint IDs.
Only bootstrap uploads append blocks; recurring jobs replace/reuse a bounded set.
Mode reset/exit clears only owned resources and returns to MOS; never global-clear
another application's buffers. Buffer replacement allocation costs and cache
lifetime still require native testing, not assumptions from C++ source reading.

Preliminary additional-Golem ceilings: 1024 IDs, 512 KiB tables, 128 KiB programs,
64 KiB scratch, 1 MiB overall excluding existing artwork/framebuffers. Record
actual startup bytes/live retained bytes/peak memory in the final measurements.
These are design limits, not observed usage or guarantees of ESP32 throughput.

## Verification and next implementation boundary

Run the host layout contract from repository root:

```sh
g++ -std=c++17 -Wall -Wextra -Werror -fsanitize=address,undefined -g \
  docs/tasks/RALLY-19/test_scene_protocol.cpp \
  -o docs/tasks/RALLY-19/.work/test_scene_protocol
docs/tasks/RALLY-19/.work/test_scene_protocol
```

R19-04 implements arithmetic in the existing C++ compiler and proves varied
native results, signed stores and computed PLOT. R19-05 implements the remaining
resident admission/indexing/lifecycle, with tests of incomplete input and return
to input processing. Do not check later milestones from these design tests.
Compiler gets committed first, then Rally records its commit and R19-03 checkbox.
All emulator tests remain headless; no GUI alert, push or hardware deployment.
