# Standalone Agon Rally production build

This directory preserves the source for the hardware-accepted desktop package.
It builds independently of the research directories. Game code, required
headers and track files are unchanged; the Makefile omits unavailable historical
remote-build, asset-generation and test targets. Generated graphics are already
in the headers. Editable asset generators remain in the parent project's history.

## Build

Install agondev and expose `agondev-config` on PATH. Then, from this directory:

```sh
make
```

Or from the repository root: `make -C rally-production`.
The output is `bin/rally.bin`. Deploy it with `oval.road`, `fuji.road` and
`readme.txt` in one SD directory. See `readme.txt` for launch commands, all
supported options and controls. No debug options or instrumentation are enabled.
No Python, Blender, emulator or asset regeneration is needed to build this snapshot.

The local verification used agondev-config 1.0 and its eZ80 Clang 15.0.7
(c76386c0083e6a6236ff774275227e2389f85538), retaining C++17, no exceptions and
no RTTI. Different toolchain releases may produce different bytes.

## Provenance and verification

Source baseline commit: `949f6186853ab99f257906e95786593a7a2e098f`.
This is the production derivative with diagnostics removed, not an assertion
that the baseline commit alone contains the stripped source. The original
stripping procedure is `docs/tasks/RALLY-19/build_pre_golem_production.py`
in the parent repository; it is not required for this standalone build.
For the standalone snapshot commit, run `git log -1 --format=%H -- rally-production`
from the parent repository. The baseline hash above identifies its source lineage.

The standalone rebuild matched the hardware-accepted and desktop ZIP binary
byte for byte. Expected `bin/rally.bin` SHA256:

```text
e14e5c0f155a4f035e925b1da5971e8f7202fe47c7147e24a5726ef937d4fe5f
```

`provenance.json` records source/input hashes. `bin/` and `obj/` are generated
and ignored. Both `.road` files are intentional build-package inputs.
This preservation does not start RALLY-20 optimization or change the SD card.
