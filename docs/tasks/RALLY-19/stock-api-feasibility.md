# Stock VDP arithmetic feasibility

Research only. No rendering program, firmware patch, benchmark or compiler has
been implemented. The user explicitly restricts this task to stock buffered
commands, matrix transforms and VDP variables; no custom functions or firmware.

## Evidence and scope

Official documentation inspected:

1. [Buffered Commands API](https://agonplatform.github.io/agon-docs/vdp/Buffered-Commands-API/),
   especially commands 5–12, 32–34, 41 and 48.
2. [VDP Variables](https://agonplatform.github.io/agon-docs/vdp/VDP-Variables/).
3. [Official firmware implementation](https://github.com/AgonPlatform/agon-vdp/blob/main/video/vdu_buffered.h).

Documentation establishes resident matrix arithmetic, buffer-sourced operands,
rotation/inversion, transformation of stored command coordinates, and mutable
control flow. Matrix features are documented as experimental and flag-enabled:
that is a stock feature switch, not a custom firmware extension. Commands 32,
33/34/41 and variable integration were introduced in different releases; a
minimum supported stock firmware must be pinned before implementation.

Detailed implementation observations below come from read-only inspection of
`/Users/bgates/Agon/fab-agon-emulator/src/vdp/vdp-console8/video/` at commit
`7bcf28e0a2376e32328a6a5554d0df852b75c80e`. Its version header identifies Platform
2.16.0. This is the emulator firmware source branch, not proof of the user's
physical-hardware firmware version. The official main-branch dispatcher also
contains the matrix/data-transform operations. Do not equate source availability
with a runtime qualification of every operation in the installed binary.

## Implementation observations

`vdu_buffered.h:1613` implements affine operations. It uses `cosf` and `sinf`
for rotations, `tanf` for angular skew, and a matrix inverse for inversion.
Arguments can be read from another resident buffer; results are stored as
float matrices. This provides a route to consume one calculation in another
without sending results through the eZ80.

`vdu_buffered.h:1821` implements arbitrary matrix manipulation, including
addition, subtraction, matrix product, scalar product and extraction. Matrix
products call `dspm_mult_f32`; sizes are padded to square before multiplication.
A scalar can be represented as a 1x1 matrix. This avoids constructing a large
matrix for every ordinary product, although allocation/dispatch cost remains.

`vdu_buffered.h:2189` implements data transforms. It copies source blocks,
transforms selected value sets and replaces the destination buffer. The inner
loop at approximately 2340 reads typed numbers, performs matrix-vector product,
then writes converted values back at the selected offsets. It does NOT divide
coordinates by a homogeneous W component. An affine transform alone therefore
does not perform perspective projection.

`types.h:283` implements float-to-fixed/integer conversion using casts and
scaling, not an explicit round-to-nearest operation. Negative output, overflow,
nonfinite values and half-pixel boundary behavior need runtime tests. Do not
assume its conversion reproduces RALLY-18 endpoint rounding.

`vdp_variables.h` stores ordinary variables as uint16_t values. They can hold
small counters, flags and state. They are not a floating-point register bank or
an expression evaluator. For arithmetic intermediates, typed data/matrix buffers
are the more direct representation. Variable reads can patch command operands.
General-use variable IDs are 0x4000..0xFFFF; graphics/system IDs have side effects
and should not be used for arbitrary application storage.

The basic buffer-adjust operations work on bytes. Array adjustment is not a
native array of 16-/32-bit integers with automatic carries. Multi-byte arithmetic
requires deliberate handling, or matrix-based arithmetic instead. Conditional
code supports byte/word inputs; signed and floating-point comparisons require
an explicit representation/conversion strategy.

## Concrete arithmetic constructions to qualify

These are mathematical designs inferred from the inspected operations, not
claims that a complete buffered implementation has been tested.

1. Product: store a and b as 1x1 float matrices; command 34 matrix product yields
   a*b. A row vector times a column vector supplies a dot product.
2. Multiply-add: matrix-vector evaluation gives x'=a*x+b*y+c. A 3x3 affine
   matrix stores a,b,c in its first row and operates on [x,y,1].
3. Division: build diag(d,1,1) with an affine scale, then invert it. Its first
   entry is 1/d for nonzero d. Multiply that result by a to form a/d. Use known
   positive depth ranges and guard zero. A full inverse for every scalar divide
   may be wasteful; resident reciprocal tables or a bounded reciprocal
   refinement using multiply-add are alternatives to measure.
4. Trigonometry: create a rotation matrix from a resident angle. In the inspected
   2D implementation entry 0 contains cos(angle), entry 1 sin(angle), and entry 3
   -sin(angle). Those floats can feed later matrix operations. Skew supplies
   tangent. This does not expose arbitrary inverse trig; angle-view selection
   may still use the existing bearing lookup or comparisons.
5. Perspective: compute camera-space X and Z, obtain inverse Z, then compute
   screenX=160+160*X/Z. Similarly derive the projected road row from camera height
   and depth. Rotation is affine; the reciprocal/depth step is separate. Clip
   nonvisible depth before inversion and retain the current horizon convention.
6. Output: produce integer coordinate operands inside resident command templates
   using data transforms; execute the resulting buffer. Validate conversion,
   gaps/stride/offset, two-triangle winding and endpoint identity before extending
   this to all road materials.

The first arithmetic probes should use unmistakable results, such as 7*9=63,
84/7=12, a 90-degree rotation, and a transformed triangle at known screen
coordinates. Follow with variable-sourced operands, negative coordinates,
loop termination and an indexed lookup. The eZ80 must not supply the answers.

## Route to the whole road

Prefer moving the existing qualified compact projection representation to the
VDP before reintroducing expensive general track projection. RALLY-18's form is:

    screen_x(q,t) = A + B*t + q*(C + D*t + E*t*t)

It needs table selection and a handful of products/sums, not runtime trig for
every road section. Generic matrix capability is still useful for that formula,
vehicle projection and future experiments. Precomputed data and VDP arithmetic
are compatible approaches, not competing designs.

A canonical rectangle cannot be turned into every trapezoid with one affine
transform: affine maps preserve parallelism. Continue emitting section corner
coordinates and triangles, or explicitly divide into suitable pieces. Do not
mistake command 41's general coordinate processing for a perspective warp.

For stripes, store pitch once. Derive remainder and pattern parity, then advance
successive boundaries by adding pitch. Integer floor/modulo and dynamic table
indexing need their own lowering and boundary tests; a float reciprocal alone
does not establish exact integer quotient/remainder. No per-stripe state is
needed. Preserve independent lap/stripe phase as recorded in the parent task.

## Programming model and possible compiler

Mutable buffer bytes plus conditional branches and loops provide the ingredients
for substantial programs. Finite real memory prevents a literal unbounded-machine
claim; no formal Turing-completeness proof is offered. More importantly,
expressibility does not establish useful frame throughput.

A small offline compiler is reasonable. It would emit standard VDU bytes only;
there would be no new interpreter or custom function added to the VDP. Start
with named buffers/fields, fixed types, labels, bounds, calls, conditions and
matrix/data-transform intrinsics. Let it calculate byte lengths and relocation
positions and deliberately patch future command operands. Avoid hand-maintained
magic offsets. Keep special cached bitmap-transform buffers separate from
arithmetic scratch matrices until invalidation behavior is qualified.

Illustrative source notation (not implemented):

    inv_depth = reciprocal(depth)
    screen_x = 160 + 160 * camera_x * inv_depth
    patch_i16(road_commands, corner_x, screen_x)
    call(road_commands)

Its lowering must be inspectable: list buffer sizes, copies, allocations,
command counts and scratch lifetimes. Combine scalar work into vector operations
where useful. Do not build a broad programming language before the few required
kernels work on stock VDP.

## Performance questions and next bounded experiment

The next useful experiment is a small stock-command arithmetic-to-drawing proof,
then one road section driven solely by resident inputs. It should compare
matrix inversion with reciprocal lookup, and batch transformations with many
small commands. Command 41 copies source data; repeatedly copying a full frame
for each coordinate would squander the proposed gain. Memory allocation,
interpreter dispatch and firmware scheduling remain real costs.

Use a bounded render call that returns to command processing. Do not assume an
endless buffered loop will service newly arriving game state, keyboard events
or VSYNC callbacks as desired. Establish state-update boundaries before using
callbacks or asynchronous operation. No completion guarantee is inferred from
ordinary general-poll replies.

Only after numerical correctness and a minimal stock render are demonstrated
should the compiler and full-scene state packet be expanded. Report CPU-side
submission cost, UART reduction, VDP cost and observed frame throughput
separately. No frame-rate prediction is justified by this source review alone.
