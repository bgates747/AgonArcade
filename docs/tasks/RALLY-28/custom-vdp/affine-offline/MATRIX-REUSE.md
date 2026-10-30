# Repeated matrices in the exact baseline replay

The original affine baseline rebuilds its matrix before every traffic/sign plot.
Of its 4,867 measured rebuild events, 3,129 (64.29%) write exactly the same six
Q8 coefficients as the last write to that matrix buffer. This is an offline
opportunity count, not an implemented optimization or a frame-rate estimate.
The accepted additive sampler already avoids these traffic/sign affine calls.

| Measured draws | Rebuild events | Same as last write to this ID | Could retain existing matrix |
|---|---:|---:|---:|
| Traffic | 4,158 | 3,015 | 72.51% |
| Signs | 709 | 114 | 16.08% |
| Total | 4,867 | 3,129 | 64.29% |

`matrix_reuse.py` reads `OBSERVED-DRAWS.jsonl` in its original draw order, including
the two warm renders before the 900 measured renders. Its state starts unknown
and records the last six-coefficient matrix **per buffer ID**. There are six
separate traffic matrix IDs, 63970–63975, but every sign shares ID63930. The
shared sign state is compared across all sign draws; caching a value separately
for each sign object would give an incorrect answer when two signs interleave.
The two warm renders contribute six rebuilds, of which three repeat. Including
warm renders gives 4,873 events and 3,132 repeats; those extra three repeats are
excluded from the measured table.

An identical matrix does not make an actor static. Of the measured repeats,
989 use a different plot position and 129 select a different source bitmap from
the preceding use of the same ID. The draw, selection, clipping and placement
must still happen. The stock inverse depends on the matrix rather than the
selected artwork or plot position, so those changes do not themselves require
rebuilding that inverse. This replay has no unchanged-matrix repeat separated
by an invisible-frame gap; retaining state across such a gap is nevertheless
part of the stated per-ID algorithm.

Each original rebuild emits 27 bytes: a seven-byte identity operation followed
by a twenty-byte six-value Q8 set operation. Omitting the 3,129 identical events
would remove 84,483 bytes from generated resident VDP command lists, averaging
93.87 bytes per measured frame. The custom native fixture generates these lists
inside VDP; the eZ80 sends resident-buffer calls rather than these matrix bytes.
This count therefore establishes **no reduction in that fixture's UART traffic**.
The corresponding standard renderer sends its matrix commands over UART, but
its actual savings would require a separate matched workload and qualification.

The official VDP source at commit
`1056ee38ec1cc68ed327bd32ee47d04b1c30597c` confirms the cache mechanism:

1. `bufferAffineTransform` allocates the replacement matrix and clears its old
   buffer, discarding the prior inverse block even if the coefficients match.
2. `checkTransformBuffer` constructs an inverse when only the matrix's first
   block exists, then appends the inverse as a second block. Later plots can
   retain both blocks while the buffer contents remain unchanged.
3. `Context::setAffineTransform` changes the selector. Selecting another matrix
   or selecting65535 to disable transforms does not clear an existing matrix.
4. `Context::drawBitmap` checks the selected transform buffer and supplies its
   cached forward/inverse pair to the transformed plotting routine.

`MATRIX-REUSE.json` records hashes for those exact official source files and
functions, the trace, baseline/current helper, bindings and relevant local
presentation/control sources. It also records every matrix ID's event counts
and example repeated events. The pinned fixture gives each traffic slot its
own matrix; the sign path owns the shared sign matrix. The player reflection
uses a different ID63984 loaded once by artwork setup. All 902 observed player
draws select65535, so no player matrix rebuild is counted. Panorama/HUD drawing
changes the current selector or viewport without writing those seven actor
matrix buffers in this fixture.

Any proposed application cache must be invalidated when another consumer writes
or clears one of these IDs, IDs are rebound, VDP restarts/resets, buffers are
cleared, the application/profile is reloaded, or delivery/state is uncertain.
It must start unknown at initialization and recovery until the actual matrix
contents are established. The ownership finding applies to this pinned isolated
fixture; it is not a global reservation of these IDs for every application.
No game implementation, fixture input, firmware, target run or benchmark timing
was changed by this analysis.

Recheck locally, without an emulator or network access:

```sh
.venv/bin/python docs/tasks/RALLY-28/custom-vdp/affine-offline/matrix_reuse.py
```
