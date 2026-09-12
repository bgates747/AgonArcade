# RALLY-18 implementation record

The user accepted the contract and authorized the checkpoint commit on
2026-09-12. Commit **182a1d0** freezes the previous dirty timing experiments and
accepted contract. Its input identities are in checkpoint-inputs.json. New
implementation remains task-local. The subsequent review/checkpoint decision is
recorded in FREEZE.md.

The candidate and live centreline reference share the same scene preparation,
player anchor, material boundaries, VDP resident programs, diagnostic poses and
physics. The reference performs live map projection. The candidate loads the
selected track's precomputed screen-coordinate coefficients once, then performs
small fixed-point interpolation and caches each needed screen line for a frame.
There are no runtime map coordinates, camera directions or trackSample calls
inside LookupRoad projection. Physics, scenery and vehicle heading work still
use their existing track sampling; this task does not claim to eliminate them.

A dense 16-world-unit table was rejected because its sampling errors exceeded
the geometry target. The selected representation uses 19 records for each
64-world-unit track interval. Each 12-byte record describes a projected screen
line as progress changes inside that interval. Payload sizes are 20,520 bytes
for the oval and 116,736 bytes for Fuji, plus a 64-byte disk header. The format
checks track/camera/version/dimensions, exact file length and payload checksum.
All data is startup-resident; no SD access or live-projection fallback is in the
frame loop. The final numeric coverage and storage evidence are recorded by the
lookup tests, not inferred from these sizes.

The task-local live and lookup emitters use the same nearest-pixel endpoint
rounding. This differs from the older renderer's truncation and allocates the
one-pixel final road tolerance across table error and trapezoid approximation.
It is a deliberate shared-reference adjustment, not a silent lookup-only image
change. Traffic's centreAt conversion retains legacy truncation.

Player placement uses the visible rear tyres in the actual 102x77 resampled
art: draw row154, ground-contact edge214 and centre anchor51 (50 when mirrored).
Its lateral displacement is projected at that contact row; root scene code
also anchors it to the road centre at that row on bends. Existing grip, car
half-width and off-road thresholds remain unchanged. See vehicle-notes.md for
the pixel/physics checks and angle-table error limits.

The optional perspective flag changes only sprite selection. Both its bearing
lookup and the traffic heading-proxy lookup are integer tables (1,092 bytes).
The control flag retains existing legal steering/cross-product pose choices.
No body-yaw physics, artwork generation, dynamic floating point or new VDP
rendering firmware is introduced.

SDK integration detail: the eZ80 runtime lacks C++ __cxa_atexit support. The
candidate's global LookupRoad is marked no_destroy, and a small main wrapper
explicitly destroys it after gameMain returns. This frees the startup allocation
on every normal return without changing the library or upstream SDK. Host
lookup tests retain normal RAII destruction.

Diagnostics share the actual scene calculations with interactive rendering.
They retain one physics update per fixed pose and independent stripe-phase /
left-centre-right steering/lateral inputs. Compute mode performs typed RAM-state
updates only, with zero commands. Wire mode emits the scene into the post-UART
sink. Display mode keeps stock VDP delivery and includes one final completion
poll in the batch wall interval. The debugger observes two dedicated boundary
functions for compute/wire; display runs omit the debugger so pause time cannot
inflate the completed-frame interval. Timing instrumentation and file output
are outside the frame loop except existing fixture counters/pose hashing.

Interactive gameplay retains the existing four-tick presentation deadline and
elapsed-tick physics update/catch-up rules. Review profiles also enable the
existing per-frame stock completion poll after each swap (`fence`). The unpaced diagnostic loop is not
used as a gameplay clock. Snapshot and scripted-input reports are separate
functional evidence; the native SDL capture interposer never runs in performance
profiles. CPU throttle and UART timing remain stock in every measurement.
