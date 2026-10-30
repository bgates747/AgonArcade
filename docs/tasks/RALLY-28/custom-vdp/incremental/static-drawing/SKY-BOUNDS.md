# Static-page and sky bounds

This candidate changes only the driver tape. The accepted additive sampler and
byte-fill module remains `310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702`.
`build.py` checks the actual target image and its source against the preserved
`sprites/PORTABLE.zip`: `target/candidate/` is the accepted sampler target,
and `source/candidate/` contains the corresponding source. The inherited old
target files inside that source package are not used as module identity evidence.
There is no rebuild, new bitmap, allocation, firmware or SDK change.

## Which rows can change

The proof concerns successful frames of this fixed Fuji fixture, its existing
camera/projection, default fonts and resources. It does not assert the same
boundary for a different camera, HUD, artwork placement or future game feature.

| Consumer | Actual accepted code or constraint | Earliest written row |
| --- | --- | ---: |
| Opaque road bitmap | `R28_SPAN_TOP=104`, height120 | 104 |
| Opponent cars | Admitted integer depth64..1100; equations below | 100 |
| Signs | Reject sign plans with `y<104`; sampler clips top to104 | 104 |
| Finish marking | Requires row104..223; clamps bottom to223 | 104 |
| Normal player bitmap | Fixed top154 | 154 |
| Crash effects | Countdown0..150, radius at most28 and size at most8; actual fixture does not enter crash animation | At least157 |
| Native lower black rectangle | Requested at224..239, outside active playfield24..223 | None; clipped |

For every admitted opponent depth `z`, the actual projection computes:

```text
q = floor(8000 / z)                  7 <= q <= 125
scale = 2*q
top = 96 + q - floor(70*scale/256)
```

Enumerating all1,037 integer depths establishes `top>=100`. Its minimum is100
at q7. Image selection, reflection and nominal image width do not subtract
anything further from that vertical origin. The sampler starts its destination
at the greater of this origin and the clip top, then plots the prepared image
at that destination; clipping can only remove rows. Its77-row source image
height affects the bottom edge, not the top edge. Different car views and
mirrors therefore preserve this minimum. Signs use their own104 minimum.

The per-frame playfield stays24..223. Actor output temporarily narrows it for
each sampled image and restores it; no accepted road/actor/player output emits
VDU26 to widen it. The native black lower rectangle is retained unchanged and
must not be counted as visible fill work. The independent actual generated-C
page replay separately checks emitted draws throughout900 moving frames.

Rows24..99 consequently contain invariant sky in this fixture. Rows100..103
can contain old opponents on either physical page and must still be restored
before each new frame. The opaque road overwrites104..223 before presentation.
Removing the entire sky clear would leave trails; this candidate does not do so.

## Two-page initialization and timing

Immediately before the original token3 `INFO17` checked query, the candidate
adds one184-byte SEND. Its payload repeats this92-byte sequence twice:

```text
VDU26; TAB0,0; original58-byte two-line title
GCOL0,16
filled rectangle (0,24)..(319,103)
filled rectangle (0,224)..(319,239)
stock buffer swap
```

Both pages receive the original title and the same logical16 sky/lower colour.
Do not substitute a guessed black pixel value for logical16. The title command
draws only the existing two text lines. The existing blank third row, y16..23,
and other untouched title-area pixels stay as established by the original mode
clear and artwork stream; no new full-page or title-area clear is introduced.

Two swaps restore the control's page phase. The pinned mode136 controller swap
blocks until its preceding primitive work and swap complete, as already
qualified in `../../throughput/COMPLETION-FENCE.json`. The unchanged checked
`INFO17` transaction follows both swaps, and the driver cannot take its first
timer sample until that reply arrives. Setup is therefore outside the900-frame
timing interval. It adds no replies and changes none of the original native
transactions, initial/final marks, physics operations, regular frame swaps or
post-swap fences. Its187 tape bytes include the3-byte SEND record header.

## Recurring commands and retained state

The old122-byte paint SEND becomes49 bytes:

```text
VDU26; GCOL0,16
filled rectangle (0,100)..(319,103)
original playfield viewport (0,223,319,24); original PLOT4(0,24)
original road, actor and player output-buffer CALLs
```

VDU26 remains necessary to reset viewports, cursor/origin and clipping before
the sky restoration. GCOL16 and the original playfield/PLOT4 activation remain
explicit. The title bytes and12-byte lower-strip rectangle account for the73
outbound UART bytes saved per frame:347→274. Restricting sky restoration does
not change command length, and reduces clear writes by24,320; retaining the
lower strip saves5,120 more. These are logical write counts, not measured bus
transactions or a predicted speedup. Full setup clears61,440 pixels once.

The baseline's title printing leaves the text cursor at row2; the reduced
paint's VDU26 leaves it at row0. This internal cursor difference is harmless
within this fixture: it writes no ordinary foreground text during the successful
frame loop, and the unchanged exit driver restores mode8, the full text viewport
and cursor before its completion message and MOS prompt. The candidate claims
equal displayed frame pixels and relevant graphics state, not byte identity of
all internal VDP context fields. Dynamic text or a changed HUD would need an
explicit repaint/invalidation rule before reusing this static arrangement.

`build.py` reconstructs the complete old tape by removing the one setup SEND
and replacing the one paint SEND. This must yield the original bytes exactly.
The control fixture is copied byte for byte from `wide-fill/fixtures/byte`;
the candidate changes only `script.bin` and explanatory `expected.json`.
