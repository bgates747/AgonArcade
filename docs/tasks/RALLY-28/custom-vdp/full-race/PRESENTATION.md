# Shared real race presentation

The common guest executes the maintained AgonDev C++ scenery, race HUD and engine
work every frame. It does not replay a precomputed drawing stream. The frozen
native modules retain their player/traffic/contact/road/sign/finish computations;
all cases use the same actual eZ80 program and original artwork. The timed native
player follows the preserved route pace, and the unchanged accepted motion table
provides the same approaching/receding traffic in every case.

`presentation_build.py` extracts `drawScenery`, `clockText`, `drawHud`, `bottom`
and `drawPlayer` from the maintained `rally-game/src/main.cpp`. The only changes
inside extracted functions count panorama operations. The script also executes
the maintained original artwork, scenery and font upload functions through
stock-command byte shims to produce setup-only external files. These files have
no diagnostic title or attract panel. No original game or historical fixture is
edited.

## Drawing and ownership

The guest starts Fuji circuit race rules directly: 85 seconds remaining, two
laps and a controlled empty record table. The screen shows the actual racing HUD:
TOP/TIME/LAP, SCORE/SPEED/POS, and the RACE LAP footer. The visible race rank follows
the deterministic scripted opponent gaps; that presentation policy does not
replace or reinterpret the frozen module's authoritative progress array.

Two complete pages are warmed outside timing. Each timed frame executes four
native physics steps and the matching maintained local route/rules update,
uploads the accepted six stations and lanes, updates engine pitch, then prepares
the current page's panorama. Retained scenery scrolls and repairs exposed edges;
rows 88–103 are restored when required to erase previous traffic over texture.
The native road output uses rows104–239 to erase expired footer text; actors and
player use the game viewport24–223 so effects cannot spill into the footer.
A full-screen viewport restores
HUD/footer drawing, then the stock swap is followed by a checked native generation
read before the frame timestamp. The native road's black footer rectangle remains
visible so expired footer notices cannot leave trails.

Both-page panorama history and changed-cell HUD retention already exist in the
game and are common to every rebuilt variant. The old flat-sky optimization is
inapplicable. No new baseline waste is introduced to manufacture a gain.

The shared guest admits the native module before mode136 and the large
artwork/bitmap allocations, retaining the qualified early-LOAD order. `config.bin` supplies only validated frame count and module length;
all normal variants use the same program. Configurations support 1–900 measured
frames, with arrays sized for 900. The maximum transcript is bounded at 100,000
bytes. `GUEST-BUILD.json` records the actual link map, zero dynamic initializer
sections, source identities and a reserved 64 KiB stack region below MOS.

## Coverage and captures

The main comparison retains the existing no-damage policy. Contacts still run;
no explosion is silently added to its performance results. A separate profile
containing `coverage.req` executes 272 frozen-camera frames using the maintained
`Crash` countdown and `drawPlayer` explosion/blink/recovery logic, with the effect
anchored to the actual native player's emitted pose. Native physics does not run
during these coverage frames. The effect receives real engine-idle commands.
Coverage outputs and deliberately interrupted captures are excluded from timing.

An optional four-byte `capture.req` contains little-endian stage and frame.
Stage 0 selects completed main frame 1–configured count; stage 1 selects coverage
index 0–271. After the matching swap and rendering fence, the guest writes
`capture.ready` and holds without display or VDP traffic for 24,000 MOS units.
The headless capture supervisor interrupts that profile during the hold. Such
profiles establish scene output, not cleanup. Normal profiles omit the request,
restore PRT/vector ownership, unload/release graphics, restore mode 8 and cursor,
save their results, and return to MOS.

## Host qualification and limits

`presentation_host.py` compiles the actual extracted functions ordinarily and
with ASan/UBSan. Its independent stock-command/page model checks panorama pixels
against direct source-image sampling, including dirty prior traffic on both pages
through all 900 frames. It checks every HUD glyph pixel and dynamic field,
expired footer erasure on both pages, and the maintained 150-frame explosion,
60 hidden blink frames and one recovery transition. Sanitizer leak detection is
disabled for the ptrace environment; address and undefined checks remain active.

These host checks do not model native road/actor rasterization, physical scanout
or hardware speed. Full native state and emulator scene captures are independently
qualified by the surrounding comparison. Four physics steps per unpaced render
do not establish autonomous 120 Hz physics or any hardware frame rate.

The local synchronized route cursor computes additional route heading/lateral
work that is common to all variants. This is a controlled renderer comparison,
not a measurement of the eventual manual player's physics cost or CPU headroom.
