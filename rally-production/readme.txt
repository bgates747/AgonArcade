AGON RALLY - standalone production package (12 September 2026)

Contains the same production binary accepted on physical Agon hardware.
Requires an Agon with VDP 2.16.0 (tested) and compatible MOS.
Uses 320x240 double-buffered video. Graphics are built into the binary;
the selected track's .road file must be in the current working directory.
No custom VDP is required. Debug options and instrumentation are absent.

INSTALL AND RUN
Extract rally.bin, oval.road and fuji.road into one directory on the Agon
SD card, for example /mystuff/arcade/rally. At the MOS prompt enter:

  cd /mystuff/arcade/rally
  load rally.bin
  run . oval demo

The dot after run means the default program address; it is not a filename.
No autoexec.txt is supplied or changed by this package. On an EMOS system
using an Extender keyboard, enable it with EMOS KEYINPUT extender before
launching. Ordinary mainboard keyboards do not need that command.

CONTROLS
Any key: leave the opening demo and start racing.
Left / Right arrows: adjust steering while held; steering stays where set.
Up arrow: accelerate. Down arrow: brake / slow down.
Minus (-): reduce grip. Equals (=): increase grip.
Escape: quit racing to MOS. In demo, first press starts racing; release
and press Escape again to quit.

COMMAND-LINE OPTIONS (lowercase words, no leading hyphens)
  run . [oval|fuji] [demo|race] [autosteer] [perspective]

  oval         Tri-oval track (default); loads oval.road.
  fuji         Fuji track; loads fuji.road.
  demo         Start with automated driving and a press-any-key prompt
               (default). The demo slows for corners.
  race         Start directly in manual racing mode.
  autosteer    Enable cornering assistance during manual racing; off by
               default. This is assistance, not the complete demo driver.
  perspective  Use viewing-angle-aware car views; off by default.
               This changes car appearance, not screen resolution.

Options may be combined, for example:
  run . fuji race
  run . oval race autosteer perspective
With no options, run . starts the oval demo. If both track selections or
both start modes are given, the last selection of each kind wins.
Unknown options print usage and return to MOS.

Keep both .road files to make both tracks available. Old .vdp and .clr
files from other builds are not needed. No source, firmware, emulator,
logs or test files are included in this package.

BUILD REFERENCE
Source baseline commit: 949f6186853ab99f257906e95786593a7a2e098f
This is a production derivative of that commit with diagnostics removed.
Exact rally.bin SHA256:
e14e5c0f155a4f035e925b1da5971e8f7202fe47c7147e24a5726ef937d4fe5f
Standalone snapshot commit: use git log -1 --format=%H -- rally-production
from the parent source repository.
