# Platform notes

1. Native C++17 via the installed agondev toolchain. eZ80 `int` is 24 bits;
   scores and PRNG state explicitly use `uint32_t`. World coordinates are
   fixed point at eight units per pixel, wrapping at 2,048 pixels.
2. Simulation targets 50 Hz using the MOS centisecond clock. Rendering targets
   25 Hz. The loop caps catch-up after a slow frame rather than spiralling.
3. Mode 136 provides 320×240, 64 colors and double buffering. Graphics use
   physical coordinates. Each rendered frame is composed off-screen before
   swapping. Moving objects use ordinary bitmap plots, not VDP software sprites.
4. Fixed-capacity pools hold 18 enemies, ten people, 24 projectiles and 32 sparks.
   Thirteen small RGBA2222 bitmaps occupy buffers 64000–64012; visible objects
   are plotted onto the back buffer each frame. There are no active VDP sprites
   and no heap allocations in the simulation.
5. The current MOS keyboard implementation is authoritative: physical keys
   left 26, right 122, up 58, down 42, Space 99, X 67, Return 74, P 56,
   Escape 113, and M 102. Bitmap byte `(key-1)/8`, bit `(key-1)%8`.
   Older keyboard charts disagree with arrows/Return on MOS v3.0.2.
6. Four audio channels separate laser pitch sweeps, noise explosions, rescue
   tones and abduction alerts. No external sound assets are needed.
7. The profile uses the canonical generated launcher, verified MOS image/map,
   and the clean official Fab 1.2.4 runtime already installed under
   `~/Agon/mystuff/AgonJukebox/.emulator/runtime/fab-1.2.4`. No upstream
   checkout or other project's profile is modified.

## Local primary references consulted

1. `~/Agon/agon-docs/docs/vdp/Screen-Modes.md` — physical coordinates and mode 136.
2. `~/Agon/agon-docs/docs/vdp/Bitmaps-API.md` — buffer-backed sprites and bitmap formats.
3. `~/Agon/agon-mos/src/keyboard.asm` — actual physical key numbers.
4. `~/Agon/agondev/release/include/agon/vdp.h` — rendering and audio declarations.
5. `~/Agon/agondev/release/config/makefile.inc` — native C++ build contract.
6. `~/Agon/agondev/src/lib/libvdp/vdp_line_to.c` and `vdp_move_to.c` — absolute lines.

## Double-buffer rendering decision

1. Initial mode-8 software sprites worked, but incremental background redraw
   flickered. Mode 136 with software sprites baked old object positions into
   frames; repeatedly removing/reinstating the sprite list also crashed one
   headless emulator run. No upstream code was changed to investigate this.
2. The user confirmed that software sprites should not be combined with double
   buffering and recommended ordinary bitmap plotting. The final renderer uses
   that approach: clear the back buffer, draw landscape/HUD/bitmaps, then swap.
   Hardware sprites have not been tested and are not required.
