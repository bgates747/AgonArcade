# R19-09 frontend integration

Implementation work is tracked under the frozen root TODO R19-09; this document
is an integration précis, not another task register. The frontend audit passes
all12 both-track native runs and638 host state-mapping records. Performance and
long stability remain separate unfinished milestones.

Use the accepted949f618 main.cpp and headers as the immutable source baseline.
Keep the same input snapshots, once-per-frame steering/grip, elapsed-tick physics,
demo takeover/escape arming, optional autosteer, both tracks, speed/surface rules
and HUD. The new task-local frontend defaults to Golem; an explicit `oracle`
argument retains the old renderer and its diagnostic switches. Root rally/ and
the read-only oracle remain untouched. Perspective remains OFF in the Golem
path; its explicit experimental option belongs to the oracle renderer.

The Golem path constructs only the existing80-byte state and finite97-byte
update/call packet from Motion/Traffic. It must not call prepareScene, road.emit,
vehicle projection, sorting or scenery heading/history on the eZ80. The host
keeps physics, game input and HUD; demo steering's track sampling is simulation,
not rendering work. Flags preserve demo/autosteer state. The resident program
computes the complete scenery/road/car frame and advances its logical page; the
host writes HUD and performs exactly one swap after each valid submission.

Load the selected track's generated bootstrap once (`oval.vdp` or `fuji.vdp`),
alongside unchanged original artwork/livery setup. Compiler output already
contains static coefficients, tangent/atan tables, programs and reset state.
Upload via private bootstrap buffer0, call it finitely, then clear that temporary
after the call returns. The compiler-owned resident IDs remain live. Reset and
exit use the compiler's matching `.clear` stream, with original external artwork
ownership handled separately. No recurrent bitmap upload or custom firmware.

Build in a fresh task-local output directory using agondev, the current C++ Golem
compiler and the explicit project venv for auxiliary generation. Copy/hash the
accepted include sources into that build, stage both generated bootstraps and
cleanup streams, and use only canonical headless profiles. The same binary's
oracle option is for feature/reference access; frozen timing comparison still
uses the independently identified accepted oracle binary.

Legacy diagnostic geometry counters cannot truthfully describe the Golem path
without VDP readback. Keep those modes behind the explicit oracle option until
the separate R19-10 measurement path provides clearly identified Golem metrics.
Do not fill unavailable car/band counts with invented measurements. Startup,
frame packet bytes, sequence wrap and final input/motion state are observable
without per-frame geometry readback.

Validation must include host state mapping against existing fixture bytes,
headless launch in default demo and explicit race modes on both tracks, held-key
steering/grip/throttle, demo takeover and armed Escape, and orderly MOS exit.
Historical Linux/hardware validation of the original game does not validate this
new frontend. All emulator work remains headless; no alert, deployment or push.

## Initial integration evidence

`proof_frontend_state.py` passes638 complete98-byte records under host ASan/UBSan:
the156 existing scene fixtures with all demo/autosteer flag combinations, varied
grip and sequence, plus14 invalid producer states. It compares all97 packet bytes
against the independent existing fixture encoding. Invalid input leaves the
destination unchanged. Producer-range checks precede narrowing, including values
that would otherwise wrap at65536. No geometry enters the packet constructor.

The initial `controls` frontend build returned before its ready marker because
the experimental-option guard included `road.fixedBands`, whose accepted default
is true. `demo-oval` retains the timeout evidence; `startup-diagnostic` captures
the actual error screen headlessly. The corrected `fixed-default` build removes
that guard term: the default remains120 road rows, and explicit `fixedbands` is
the same already-enabled setting. Other experimental options still require the
oracle renderer. This was a frontend option error, not a bootstrap/VDP deadlock.

Both tracks pass demo takeover/armed Escape/normal cleanup and emit97 bytes per
submitted scene. Held right/left tests reach exactly +/-21 steering and200/25
grip, respectively. The combined takeover case reverses held steering after
taking control; optional autosteer and the explicit oracle option pass too.
Full results and source/build/runtime identities live in
`evidence/golem-frontend/qualification.json`. Scheduled
keys use host SDL presents only for input timing, not measured game-frame counts.
All scheduled injections are verified once; guest reports establish their effects.
The audit also compares the entire input/physics and HUD source blocks with the
immutable accepted frontend and confirms they are unchanged. Normal exit reports
show cleanup-stream submission and a subsequent parser barrier; this is not yet
a live memory/leak or malformed-bootstrap cleanup qualification.

Fresh reproduction from this worktree (choose unused evidence/build names):

```sh
PATH=/home/smith/Agon/agondev/release/bin:$PATH .venv/bin/python docs/tasks/RALLY-19/build_frontend.py NEW
.venv/bin/python docs/tasks/RALLY-19/probe_frontend.py NEW-demo --build NEW --track oval --case demo
```

The build stages `rally.bin`, both `.vdp` bootstraps and `.clr` cleanup streams.
Original `.road` files support the explicit oracle option. Fresh canonical
profiles are generated by the probe; no graphical launcher is involved.
