# 2026-09-12 — Linux replay of Mac Rally benchmarks

1. At the Author's request, built the transferred worktree on Linux and passed
   road, pacing and fixed-band sanitizer tests. Launched the documented full-road
   fixedbands/fence review configuration. No source changes or commits.
2. Author requested equivalent headless performance tests against the Mac.
   Replayed all 32 later deterministic fixture runs using SHA-256-identical
   archived guest binaries, the existing timing helper and official Fab 1.2.4.
   Stopped the review window during timing. All 2,048 measured poses and byte
   budgets match; 1,920 expected frame acknowledgments, no timeouts or omissions.
3. Linux is broadly similar to Mac: current full-road equivalent rates are
   7.97/8.87 versus 7.81/8.74 on oval/Fuji. Pavement-only is 12.49/13.71 versus
   14.01/13.64. The host change does not remove the performance limitation.
   CPU emulation remains at its default 18.432 MHz; no unlimited-speed flag.
4. Detailed methods, raw CSVs, manifests, repeated-case/stage tables and caveats:
   [Linux comparison](tasks/RALLY-10/linux-comparison/README.md).
   Original Mac evidence and current game binary remain unchanged. RALLY-10
   remains open; no hardware deployment, promotion of pavement, or commit.
5. Author requested unlimited CPU mode and then equivalent benchmarks.
   Replayed all 32 with valid Fab `-u`; all counts/poses/bytes pass. Current
   full-road and pavement fixtures reach 30 FPS-equivalent, bounded by the
   unchanged four-tick application pacing. This is not an unpaced maximum.
   [Unlimited comparison](tasks/RALLY-10/linux-comparison/UNLIMITED.md) retains
   raw evidence and documents the misleading long-option spelling in Fab help.

6. Interpretation: raising only emulated eZ80 execution speed lets the tested
   full-road and pavement renderers reach the application's 30 Hz limit. This
   strongly supports eZ80-side work as the limiting factor in those versions;
   the emulated VDP keeps up at 30 Hz. It does not establish 60 Hz capacity or
   an unpaced maximum. These Linux unlimited runs do not test the newer
   RALLY-15 VDP-resident section renderer.
7. Imported all 76 Linux additions into the Mac checkout and verified all 319
   Linux repository files were preserved here before restoring the Linux
   worktree to clean revision a981184. Ignored Linux environments/build outputs
   were retained. The Author then explicitly authorized a local commit of the
   accumulated work and findings and requested a stop. This is a development
   checkpoint; pending hardware/renderer acceptance tasks remain open, and
   RALLY-15 stays isolated in its task bucket. No push was requested.
