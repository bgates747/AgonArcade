# Generated hot-loop findings

This is an offline machine-code review, not a new benchmark. No speedup is
claimed. [Assembly emission](assembly/EMISSION.json) records the unchanged
source, Agon LLVM15.0.7 compiler hash and original `-Oz` options; `-S
-fverbose-asm` adds assembly output without linking/replacing the guest.
[Static call sites](ASSEMBLY-CALLS.json) are reproducible with `audit.py`.

## COST-F01 — Retained HUD output still pays repeated formatting cost

The Circuit/Race path performs seven `snprintf` calls in `drawHud` and one in
`bottom` every rendered frame. The compiler emitted all eight. `drawHud` alone
contains four direct `__ldivu`, two `__lremu` and one `__lmulu` call sites, before
any arithmetic inside the formatting library. Its stack frame is 336 bytes;
the generated code also uses extra address setup for locals beyond small indexed
offsets. See [drawHud assembly](assembly/ez80-main.s:8298) and
[footer assembly](assembly/ez80-main.s:8743).

`Hud::emit` suppresses unchanged transmitted cells only **after** all strings and
the new image have been constructed. Cache formatted field strings by their
displayed values before this work: top record, rounded countdown, displayed lap
time, score, speed, rank and footer lap/policy. Retain per-page cell/color history
and invalidation; do not skip changes to race/results/policy/grip/record state.
Lap hundredths change frequently, so caching alone will not remove every format.
Specialized bounded integer formatting is a separate possible follow-up.

This is shared production work: the functions come from
`rally-game/src/main.cpp:233–270`, not a benchmark-only display. The native road
output clears the footer each frame, so caching the footer's **string** must
still redraw it. Suppressing that redraw without changing/restoring its clear
would corrupt the picture. This audit proposes no static-sky substitution.

## COST-F02 — Bounded station wraps invoke 32-bit remainder helpers

The fixture's four-step loop contains two `__lrems` call sites at assembly lines
2880/2902, or **eight wide remainder calls per rendered frame**. They implement
`(position+advance)%lap` and `(phase+advance)%8000` in `guest/src/main.cpp:145`.
Fuji's lap is 3,276,800; route speeds give positive advances 300/340/360. A
normalized value plus one such advance crosses its modulus at most once, so
compare/subtract can preserve the exact result. Both positions fit unsigned
24 bits; this is a useful Agon-width candidate rather than a reason to narrow
every counter.

The real `Motion::tick`, `rally-production/include/road.hpp:110–111`, repeats
the same pattern. Its speed limits, multiplier and entry invariants need their
own range proof. `race_traffic.hpp:84–86` already uses conditional wrapping for
forward traffic; its general `wrap()` also serves negative inputs and arbitrary
progress. Audit all callers, but do not replace that general modulo helper with
one subtraction. Preserve exact world/state bytes for this first experiment.

`paint` has an additional wide remainder at assembly line6445 solely to count
finish-visible frames in diagnostics. Removing that statistic would make a
fixture cheaper without improving game rendering; it is not an optimization
candidate for the comparison. Likewise the shared `RouteCursor` computes
lateral/heading state used by real traffic, even though this fixture consumes
its advance. Do not delete that workload to manufacture a physics gain.

## COST-F03 — Many short writes add eZ80 work independent of wire bytes

`native.hpp:32–51` builds updates in three separate sends: buffer-command,
update-header, payload. Two `set16` updates plus a native RPC make seven
`send()` calls for a render invocation. Every send brackets `mos_puts` with PRT
reads and updates wide counters. The generated guest retains these calls.

A resident packet/template can concatenate these pieces while preserving exact
wire bytes and order. Measure both assembly/call overhead and whole-frame FPS;
byte-identical batching does not save physical serial transfer time. Further
buffered-API byte reduction is a separate experiment and must retain error and
post-swap validation. Do not attribute the already measured compact-query gain
to this unimplemented proposal.

## COST-F04 — Native admission deserves measurement before arithmetic surgery

Every generated RUN checks 88 root-header bytes and acquires/releases seven
array shapes (`checked.c:65–105`). Render adds snapshot reads and a 12-range
preflight (`rally_render.c:82–105,149–158`). These are real recurring checks, not
just setup. Measure their cost against actual useful simulation/preparation.
An optimization would need retained-identity/lifecycle and failure proofs with
the generator/runtime owner; this report does not authorize weakening them.

Render-time `asset_ok(...,0)` does **not** repeat the whole asset checksum;
the checksum runs on binding. Do not count a 149 KiB hash per frame that is not
there. Likewise 64-bit checked expressions in generated source do not prove a
software helper call; inspect the emitted instructions for each proposed change.

## COST-F05 — Some road edge math is floating point, on an actual FPU

The accepted native road is not fixed-point-only. Ten endpoint pairs per band
pass through float calculations and integer conversion in
`helper/render_core.inc:145–162`. The **actual checked target** disassembly,
lines4729–4770, contains `float.s`, `mul.s`, `trunc.s`; signed divides such as
`quos` appear elsewhere. These are Xtensa instructions, not eZ80 software-float
calls. The inner road rows then step integer edges and fill bytes.

An integer/rational endpoint variant is still reasonable, especially if a
one-pixel boundary tradeoff is visually acceptable. First measure band setup
versus fills/stock bitmap copy; preserve the current float rounding as control
and report any changed edge/stripe pixels explicitly. Half precision is not an
automatic native win. The prior aligned-word-fill experiment gave no sustained
whole-frame gain, so byte-loop `memset` alone does not justify repeating it.

## COST-F06 — Actor planning is repeated, but the pixel loop is already additive

`sprite.inc:46–48` computes a clipped plan while emitting commands;
`sprite_io.inc:8–10` computes it again before sampling, after the command lease
is released. The two paths need the same clip/size/skip/mirror facts. Reusing a
small validated plan is a bounded candidate; count this as source-confirmed
duplicate planning, **not a measured division bottleneck**. The compiler uses
both inlining and indirect calls, so static symbol-reference counts are not
dynamic invocation counts.

The current sampler already avoids per-pixel division/float: it prepares a
horizontal map and advances quotient/remainder by additions. The source artwork
is loaded once, scratch images are reused, and the fixed player is not one of
the resized traffic objects. Prepared multi-size caching has only the preserved
near-tied first pair; do not treat it as a new adopted remedy here.

## COST-F07 — Shared positioning is present; remaining duplication needs proof

`centre_exact` is used by road, traffic, signs and player, so the historical
"optimize only the road" problem is not a correct description of this current
native image. The eZ80 still computes sky heading through `trackSample` and
`sceneryHeading`; the native renderer also needs tangents/bearings. Those run
on different processors and have different ownership/precision needs. Propose
sharing a published heading only after its wire/round-trip cost and visual
quantization are compared with the local calculation. A source return structure
containing x/y does not by itself prove the optimizer retained unused x/y math.

The high-value first shared change is HUD formatting, followed by bounded wraps;
neither requires a rendering-accuracy sacrifice. Coarser geometry, integer edge
setup, source cropping and fewer sky repairs remain explicit tradeoffs to test,
not silently rejected inaccuracies. Sky repair removal requires proving what
can draw above the road under the full game camera and effects, not just this
fixture's traffic arrangement.
