# Recommended private prepared-image table

Use a compact read-only buffer with constant-time source/size lookup. Keep the
recipe JSON as the producer's full provenance/error/install record. This is a
proposed Rally application interface for central review, not a new firmware API
or an implemented runtime policy. CONTRACT-v1.md and FREEZE.json still govern.

## Layout, version 1

All integers are little endian; use checked byte reads, not compiler structure
packing. Every offset is relative to the beginning of index buffer51999.

| Header byte | Type | Meaning |
| ---: | --- | --- |
| 0 | 4 bytes | Magic `R3PI` |
| 4 | u16 | Schema1 |
| 6 | u16 | Header bytes64 |
| 8 | u32 | Complete table length |
| 12 | u32 | FNV-1a of bytes64 through end; existing helper hash routine |
| 16 | u16 | Source/reflection directory count68 |
| 18 | u16 | Selection-map family count18 |
| 20 | u16 | Image record count |
| 22 | u16 | Explicit policy flags; unknown bits reject |
| 24 | u32 | Directory offset64 |
| 28 | u32 | Selection-map offset1152 |
| 32 | u32 | Image-record offset3420 |
| 36 | u32 | Generator identity from the recipe |
| 40 | u32 | Recipe identity tag |
| 44 | u16 | Map entries per family126 (q0..125) |
| 46 | u16 | First owned image ID52000 |
| 48 | u16 | Owned image count |
| 50 | u16 | Reserved0 |
| 52 | u32 | Original artwork/projection source tag |
| 56 | 8 bytes | Reserved0 |

Short tags detect accidental mismatches; the full manifest SHA256 pins source,
generator and table outside this header. No approximate policy is accepted by
merely assigning a flag. The initial proposed full-set consumer rejects hybrid
flags; a fallback policy would receive its own contract and benchmark row.

Directory entries are16bytes: original source bitmap u16, family u8, flags u8
(reflection/kind), first image-record index u16, image count u16, map offset u32,
source width u8, source height u8, reserved u16. Traffic contributes30sources
times two reflections; signs contribute8sources. Six traffic liveries share
the same ten geometry-family selection maps. Signs have eight independent maps
because their actually visible domains differ by placement and artwork index.

Each selection map is126bytes. Legal requested `q=scale_q8/2` maps to a local
record index;255means invalid/missing and must return an error. The unused q
holes are not silently converted to a new size. Representatives come from
ordered disjoint request intervals, so selected sizes never reverse with depth.

Image records are8bytes: bitmap ID u16, width u8, height u8, integer source-anchor
offset x i16, y i16. Destination IDs are simple distinct IDs; the measured exact
content deduplication saves only132pixel bytes, which does not justify a more
complex initial index. Table bytes are `3420 + 8*image_count`:58,836 exact,
19,740 one-pixel,10,628 two-pixel. Even the exact table fits one65535-byte upload
block. Each bitmap is separately bounded to at most99x75pixels/7425bytes.

## Producer and installation

1. Reserve index51999, setup matrix51998, telemetry51997, probe51996 and images
   beginning52000, ending58926 for the full exact6927-entry set. RESOURCES.json
   inventories current state/array/wrapper/art/scene/matrix/font IDs and verifies
   no overlap. Do not infer an8000-image RAM allowance from the free ID interval.
2. Original artwork is loaded once. The proposed stock generator uses existing
   matrix commands and transform-to-bitmap command40 with explicit width/height
   (options3). This omits the natural transform's extra unused row and column.
   Its host-model footprint matches the active additive-sampler rectangle.
   Matrix coefficients are `[s,0,0,0,s,0]` or `[-s,0,101*s,0,s,0]`, with
   `s=2*q`, signed Q8. The largest translation25250 fits signed16. No rotated,
   sheared, translated-y or out-of-domain matrix is admitted under this version.
3. Validate every producer record, table bound, source pin and supported key.
   Check actual installed buffer lengths/content, not just commands emitted.
   Buffer presence alone does not prove Bitmap registration: qualify a standard
   screen-pixel readback probe for each nontransparent installed image over a
   contrasting cleared area, and validate which double-buffer page it reads.
   Perform any setup swaps/cleanup before warming both race pages. This probe is
   proposed and unimplemented; the existing stock read-pixel command supplies
   the route without a generic service. Transparent images are explicitly known.
4. Record generation and verification duration, installed count, retained and
   observed peak memory, free internal/PSRAM memory and cleanup. Original native
   INFO18–21 are absent: use the pinned stock bufferReadVariable route for free
   PSRAM, and native INFO13–16 for internal free/largest blocks. No largest-PSRAM
   query exists in this frozen interface; actual image allocation/installation
   is still required. Expose that measurement limitation; do not change firmware
   for convenience or present a calculated heap figure as a measurement.

## Consumer and anchors

Select the source/reflection directory in constant time, index its map by q,
copy one8-byte record and release the table lease. Root+asset+output+lookup is
the existing four-lease ceiling. Retain numeric identities/verified epoch only,
not borrowed pointers. Validate and checksum at installation/session change;
immutable table/pixel ownership lasts through the last draw fence.

Recover the original integer world anchor before substituting a size:
traffic centre=`r.x+floor(51*s/256)`, ground=`r.y+floor(70*s/256)`;
sign centre=`r.x+floor(32*s/256)`, ground=`r.y+floor(64*s/256)`.
Subtract the selected record's anchor offsets for its plot coordinates. Use its
dimensions for clipping with the existing exclusive right/bottom319/223 rules
and normal24/88 or sign104 top. A position is never an image-cache key. Keep
depth ordering based on the original world distance, not substituted size.
The fixed-size player and its ordinary reflection path remain unchanged.

RUN failure handling, full native publication validation, final stock swap and
checked reply remain. Missing keys fail visibly; full-set timed counters must
show zero generation, replacement, allocation and fallback. Read counters after
the timed window, preserving compact per-frame traffic. Restore/clear all owned
resources after the final fence, including partial-install failure paths.

No consumer code or table has been installed. The current native text uses
32,264 of its declared32,768-byte budget; actual consumer admission/stack must
be checked before target use. A full prepared implementation can remove the
old timed sampler, but no code-size saving is assumed. Return an actual failure
before changing the SDK/runtime limits. Human visual/publication gates remain.
