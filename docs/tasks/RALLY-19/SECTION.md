# R19-06 section implementation notes

R19-06 is complete; qualification is below. R19-05 qualified full admission,
resident records and lifecycle. Full-road/full-scene integration remains later
work. Root TODO.md is authoritative.
These are working implementation notes and evidence references, not another
checklist or a relaxation of the frozen contract.

## Accepted evaluator and data

The oracle is the accepted 949f618 build preserved by foundation.py, with source
in `.work/oracle/include/lookup_road.hpp`, `lookup_format.hpp`, `section_road.hpp`
and `section_protocol.hpp`. RALLY-18's tracked versions describe the same data.
`position` is normalized integer hundredths of a world unit. The exact evaluator:

```text
interval = position / 6400
local = position % 6400
fractionQ14 = (local/100)*256 + (local%100)*256/100
fractionQ12 = fractionQ14/4
squareQ12 = fractionQ12*fractionQ12/4096
q = row - 96
k = (fractionQ14 + DepthQ8[q]) >> 14
lineA = a*4 + b*fractionQ12/4096
lineB = c + d*fractionQ12/4096 + e*squareQ12/4096
centreQ8 = lineA + lineB*q/16
centrePixel = round-to-nearest, ties away from zero (centreQ8/256)
```

Integer divisions truncate toward zero. Do not replace quantization points with
an assumed equivalent float formula without bounding/measuring the difference
against the frozen oracle. The camera is fixed to the centreline; lateral motion
must not displace the road. Phase is independent of lap position.

Each interval owns 19 little-endian 12-byte records: s16 a,b, s32 c, s16 d,e.
The road files have a validated 64-byte header followed by the coefficient data.
Oval has 90 intervals / 1710 records; Fuji has 512 / 9728. Observed coefficient
bounds in the unchanged files:

| Track | a | b | c | d | e |
| --- | --- | --- | --- | --- | --- |
| Oval | -98..10272 | -3740..7058 | -6712..66929 | -5243..8964 | -1315..9 |
| Fuji | -28..20605 | -6488..13748 | -61932..77934 | -6683..9570 | -2287..943 |

One 228-byte Table record per interval plus typed LoadElement of its 12-byte
coefficient is the initial construction. This avoids dedicating a VDP buffer to
each of the 9728 individual Fuji coefficients. Account for the admission program's
306 IDs alongside tables/scratch under the 1024-ID ceiling; both-track layout or
shared helpers may need packing before full integration.

The accepted section endpoints combine curve-band boundaries with the exact
phase patterns in section_phase.hpp. Markings begin at row116; the full road
spans rows104..223, with shared endpoint224. Source protocol.py in RALLY-15
specifies the accepted normalized strips:

- kerb: -106..106, red9 or white15;
- road: -90..90, grey8;
- shoulders: -86..-84 and 84..86, yellow11 or white15;
- marked centreline: -2..2, yellow11 only in the painted phase.

The old section kernel derives an affine/bilinear 4x4 transform from
[centreTop,centreBottom,yTop,yBottom,1], then transforms triangle strips. Its
25-byte eZ80 section update is the oracle, not the intended offloaded protocol.
Golem must derive endpoints/materials from world state and resident coefficients.
Stock unsigned casts for negative fixed output must receive the qualified bias
handling; do not copy the old raw transform blindly or change the firmware.

## First compiler checkpoint

`LoadElement(dst,src,index,status)` selects a typed fixed-width record within a
resident buffer. It validates repeated source/destination layouts and index bounds,
computes byte offset by exact bounded integer double/add, patches offset13 in a
separate copy instruction, then executes it. The source ID is fixed; the earlier
LoadIndexed selects among consecutive table IDs. Invalid selection clears status
and preserves the previous record.

`WidenUnsigned` explicitly zero-extends u8/u16 into a containing signed integer
field for stock matrix loads. `StoreU16Floor` qualifies 0..65534 scalar outputs
without the signed path's 32768 bias. That bias would discard useful fractional
precision near interval boundaries; the unsigned path directly transforms zero
with a proved nonnegative translation before copying the word.

`probe_elements.py retained-copy` passes eight varied native cases using the
unchanged stock admission loader as opaque byte transport. The fixture selects
32 twelve-byte records, including indices21/22 across byte offset255, rejects
32 and65535 without modifying the record/product, widens65535 positively, and
compares interval floor to exact integer division at positions6399/6400/6401 and
3276799. Values around511.999847,32768 and65534 exercise positive conversion.
It does not draw a road or qualify scene timing. The initial native attempt and
host golden caught an accidentally erased copy-instruction template; both failed
evidence and the corrected native report are retained.

Next integration uses these helpers for real coefficients and phase/boundary
selection, then compares complete materials/geometry to the frozen oracle and
measures alternative batching. Do not check R19-06 from the helper test alone.

## Real track projection and complete-band checkpoint

Golem compiler checkpoint: f54651a9ed3df87fc3d1e4240264cf44888cc951.
`build_projection_kernel.py` repacks the unchanged selected track's coefficients
and emits readable hosted source. The existing C++ compiler emits every VDU
instruction. Dynamic interval/record selection, fraction quantization, depth
lookup and scalar arithmetic execute in stock VDP. `projection_reference.cpp`
uses the actual accepted LookupRoad implementation; it is not a duplicate float
model or a source of candidate screen coordinates.

The first construction deferred the b/d/e and final Q8 truncations while retaining
fractionQ14, fractionQ12 and squareQ12. Its theoretical four-truncation centre
error is less than(2+q/8)/256, at most0.0703125px before float roundoff. A declared
0.075px numeric allowance passed186 oval and294 Fuji native queries, with maximum
errors0.042999267578125 and0.042236328125px. Selected records and every integer
index stage matched. `evidence/golem-projection/fetched-scale-{oval,fuji}` retains
raw readbacks, source/loader/compiler/runtime identities, full Golem source and
resource maps. The earlier `initial-oval` fails because a compiler helper omitted
the fetched-scalar bit in matrix operation0x27. It is retained, not overwritten.

`build_section_kernel.py` adds immutable phaseIndex/pattern/curve-band assets
derived from the accepted tables. For this proof the curve and stripe descriptors
bracket diagnostic anchor row160; they do not precompute projected endpoints.
The VDP selects the curve bin and stripe pattern from position and independent
phase, intersects the bounds, chooses paint parity, evaluates both endpoints,
calculates the normalized five strips and plots two triangles for each strip.
The eZ80 transports raw position/phase (plus ignored lateral in visual tests).
One selected track is resident at a time. The raw diagnostic packet is not a
replacement for the already frozen80-byte production ABI or its admission guard.

`probe_section.py` passes61 oval and79 Fuji selection/corner queries using the
original deferred-truncation variant (`evidence/golem-section/initial-*`). Every
boundary/material agrees and rounded centres differ by at most1px. Crucially,
the first complete-section visual run (`loader-oval`) nevertheless fails the
shoulder metric at position72000/phase3999: one centre rounds to153 instead of
154, and the thin shoulder only reaches0.877049 one-pixel agreement. This is an
actual raster discrepancy, not grounds to relax the frozen regional metric.

The section generator now restores the four truncations with MatTrunc and uses
MatRoundAway for accepted half-away endpoint rounding. Both compiler intrinsics
extract positive binary32 magnitude and sign, convert only nonnegative values
with stock fixed conversion, reload an exact signed32 integer and restore sign.
This avoids negative-float-to-unsigned undefined conversion and preserves signed
zero. The rounding half constant uses nextafter(0.5,0) to avoid prematurely
rounding the input immediately below0.5 up to1. Host tests qualify all half-value
discontinuities and neighbours through8388607, and reject invalid shapes/ranges
and aliasing. Native `evidence/golem-rounding/signed-boundaries` passes122 varied
values. The scalar truncation domain is |x|<=16777215; nearest rounding<=8388607.

`visual_section.py` compiles separate oracle and candidate guest paths, renders
both buffers, captures through the existing Linux SDL observer and advances poses
with scheduled headless right-arrow events. Escape must produce a zero exit.viz.
Each renderer reports its own geometry; masks classify that renderer's actual
native pixels. They use the frozen same-material RGB radius-one metric separately
for asphalt, kerb, shoulder and centreline. No candidate receives oracle corners
or uses the oracle's mask as its own. Background is scored separately. GP is
only a parser echo; captures wait additional host presents before inspection.

All28 oval visual cases pass with the restored quantization:24 frozen cases plus
four extra seam/lateral poses, under `evidence/golem-section-visual/quantized-oval`.
The initial corrected four-case run also passes; its predecessor's failure remains
available. Fuji's wider images and the construction timing comparison are still
in progress at this checkpoint, so R19-06 is deliberately unchecked.

The alternative batching measurement compares shared per-position preparation
against repeating that same preparation for the second endpoint. `time_section.py`
uses serial ABBA, normal guest clock/UART, warmed64-pose groups,256 finite resident
calls/group and two measured passes. No observer is loaded. Raw120Hz guest-tick
spans end at a stock GP parser echo and are construction-cost evidence only:
they do not qualify raster completion, full-scene speed, eZ80 savings or R19-10.
Full-road boundary enumeration and admission/resource integration remain later
milestones; the anchor descriptor table is specifically a one-band proof.

Reproduce from the Rally execution worktree (always choose unused run names):

```sh
.venv/bin/python docs/tasks/RALLY-19/probe_projection.py NAME --track oval
.venv/bin/python docs/tasks/RALLY-19/probe_rounding.py NAME
.venv/bin/python docs/tasks/RALLY-19/probe_section.py NAME --track fuji
.venv/bin/python docs/tasks/RALLY-19/visual_section.py NAME --track oval
.venv/bin/python docs/tasks/RALLY-19/visual_section.py NAME --track fuji --limit 35
.venv/bin/python docs/tasks/RALLY-19/visual_section.py NAME --track fuji --offset 35
.venv/bin/python docs/tasks/RALLY-19/time_section.py NAME --track oval
```

Requirements remain agondev on PATH, each project's own Python environment,
Pillow for native-image masks, stock Fab1.2.4/MOS3.0.2 and canonical wrapper
generation. The visual observer uses Linux clang/libdl/SDL3; it is not timing
instrumentation. Nothing is launched graphically or deployed to hardware.

## R19-06 qualification

`evidence/golem-section/qualification.json` passes. The preceding checkpoints
remain dated evidence of the experiments; this section records their final
outcome without editing or discarding the failed runs. Compiler implementation
is Golem f54651a; cross-repository completion notes are committed at980024b.

All74 complete-band native image pairs pass:66 frozen poses plus8 extra seam and
lateral cases,28 oval and46 Fuji. The section endpoint centres exactly match the
oracle in every visual case. Minimum per-region radius-one agreement is100% for
asphalt, kerb, shoulders and centreline. Both tracks draw all expected materials,
exercise both buffers and exit through scheduled headless Escape. This qualifies
the band containing row160; it is not full-road or full-scene image acceptance.

Serial ABBA construction results (normal guest clock/UART, stock native VDP):

| Track | Shared preparation mean | Repeated preparation mean | Reduction |
| --- | --- | --- | --- |
| Oval | 0.169372559 ms/section | 0.183359782 ms/section | 7.63% |
| Fuji | 0.171661377 ms/section | 0.189717611 ms/section | 9.52% |

All grouped medians are0.1953125ms/call; timer granularity prevents a median
speedup claim. The initial16-call grouped attempt (`abba-oval-0-shared`) produced
zero-tick samples and was rejected. Final groups contain256 finite resident calls,
64 warm groups and two64-group measured passes, with separate serial runs in
ABBA order. MOS time advances in two120Hz ticks here, so the effective timestamp
step is16.667ms, or0.065104ms/call after dividing a256-call group. Each span ends
at a GP parser echo, not a raster-completion event. The runs contain no observer
interposer and no per-section counter. Separate `golem-section-repeat/counted-*`
probes verify exactly1024 invocations and correct final geometry/materials over
four varied states per track. Shared preparation is the measured selected choice.

The compiler regression suite passes with sanitizers, and the earlier R19-04
arithmetic kernel recompiles byte-for-byte identically (see
`arithmetic-bytecode-regression.json`). Host and native signed-quantization proof
remain as described above. MOS guest exit reports are preserved as raw CRLF;
task-local Git attributes now recognize their carriage returns as line endings.

| Section construction | Oval | Fuji |
| --- | ---: | ---: |
| Owned IDs | 455 | 877 |
| Resident payload bytes | 36804 | 139772 |
| Bootstrap bytes | 43236 | 152112 |
| Resident plus retained bootstrap payload | 80040 | 291884 |

These are compiler payload ledgers, not heap measurements. The unchanged earlier
admission kernel uses306 IDs; naively adding it to Fuji's877 would exceed1024.
R19-07 must pack/integrate the coefficient tables and shared resources before
full-scene integration. A practical next construction is a few immutable banks
below65535 bytes each, selecting an interval's228-byte record by source bank and
offset instead of assigning one ID to each of512 intervals. Keep raw coefficient
bytes, guards and the frozen ABI unchanged. Then enumerate and merge the complete
curve/stripe boundary lists, project shared endpoints once and draw every band.
The row160 bracket assets are only this milestone's diagnostic construction.
