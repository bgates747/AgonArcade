# Native state boundary and comparison contract

The live World is a private module object. Its six Opponent records and scalar
fields have native alignment; routes/sine are exact const native tables. No
field contains a borrowed buffer/framebuffer pointer. All numerical functions
operate on this owned state; checked integer rounding/overflow remains the
original semantics. First-pass diagnostic scratch fields remain in private RAM
to reproduce the independent old-state oracle. They are no longer PSRAM live
variables and incur no per-element service calls.

INIT initializes lifetime metadata; the caller's explicit InitRace initializes
World from the compatible scalar image and authored race defaults, resetting
all six mutable opponent records. A session mismatch rejects use before state
advancement. The large immutable asset is still one entry-scoped borrow.
FINI drops private binding/lifetime state, and UNLOAD frees the module. No raw
external pointer outlives RUN; the existing renderer's private context stores
only values and resource IDs. Stop preserves the prior race's flags/binding
semantics; a fresh InitRace can reuse the loaded module.

The current guest only changes root session/requested-entry/ready metadata and
scripted opponent position/lateral inputs. Render imports those two whole
arrays after the four physics steps, updating the same authoritative fields
that the next Tick will read. This retains the effect of visual overrides on
subsequent contact/position work. It does not make the native simulation ignore
the script or silently test a different traffic workload.

The 310-byte root and96-byte mutable-array image are compatibility exports.
Each Tick/Init exports scalar values and five arrays once; Render exports its
scalar/publication state, while positions/laterals already contain its imported
input. Root generation/session/last-success semantics and complete final406B
are byte-identical at the fixture's observation points. Read-only table images
remain installed in this first fixture but are not accessed by native physics.
A future compact protocol can remove diagnostic storage/export from timed work;
this tranche keeps it to establish a clean current-fixture comparison.

Native entry17 executes four ordinary native Tick functions under one outer
RUN, increments logical generation once per actual step, serializes once and
leaves requested/last-success entry3 in the legacy diagnostic view. It is an
application-native entry, not a seventeenth Golem language procedure; historical
root entry_count/unused probe metadata is preserved only for compatibility.
The coarse guest batches exactly four Tick submissions; warm renders and
separate coverage do not submit partial groups. It uses the same compiled
native module as the compatible state arm, reducing code/compiler differences.

Numerical failures preserve owned partial state, export diagnostics and latch
a failed state until reinitialization (Stop remains possible). A partial native
operation is never rolled back by the runtime. Row/helper failures do not leak
leases or report ready; bounded row-failure checks explicitly reinitialize.
Pre-entry failures and absent/failed calls are detected by requested Render
status and the fixture's expected cumulative generation/post-swap read. Silent
physics calls do not themselves produce round-trip acknowledgments.

The exact old guest is retained for baseline/state; the coarse timed change is
four six-byte Tick CALLs replaced with one17-byte silent RUN. Every other
recurring byte, requested callback token and final state is checked unchanged.
The actual captured target stream is compared against this precise replacement,
not filtered or normalized. Wrapper buffer installation/handle patches are
removed only from the coarse guest; the common state arm preserves startup.

The road/actor sampler, generated drawing lists, stock compositor/sky/HUD/audio,
C3/swap fence, synchronous UART and coupled fixture scheduler remain. This is
an integration experiment, not the final removal of every interpreter layer.
See NAT-NEXT-03 for remaining native composition work and later independent
physics/render scheduling. No data-ownership rewrite here establishes120Hz
real-time physics or60Hz physical presentation.
