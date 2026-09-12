# R19-06 section implementation notes

R19-06 is open. R19-05 qualified full admission, resident records and lifecycle;
it did not implement any full-scene road geometry. Root TODO.md is authoritative.
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
