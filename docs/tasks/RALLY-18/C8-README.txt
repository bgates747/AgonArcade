RALLY-18 PRESERVED REVIEW / CONSOLE8

Exact historical unfenced review binary: 142838 bytes, SHA256
20622e05c82431b58552be533a749779e30a7e2cfdb7b3352e582896fdf2ab70
Original Fuji/oval road files included. Artwork is embedded in the binary.

REQUIRED VDP: official stock AgonPlatform VDP 2.16.0.
Included application image: vdp_rally.bin, 1077840 bytes, SHA256
b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f
This is EXACTLY THE SAME VDP IMAGE as /test/rally-19/vdp_rally.bin.
One correct stock VDP installation serves both versions.
No firmware flashed, startup edited or other game changed by this deployment.

From the Console8 MOS CLI:
EXEC /test/rally-18/run-fuji.txt

For oval instead:
EXEC /test/rally-18/run-oval.txt

Equivalent manual commands:
CD /test/rally-18
LOAD rally.bin
RUN . fuji demo

Demo starts automatically. Press a key to take over; arrows drive,
minus/equal adjust grip; Escape exits. Original four-tick pacing retained.
This is a driving prototype with stock buffered-section rendering, not the
R19 Golem experiment or the R22 complete title/qualifying/race game.
Author reported a lower-left rendering defect under Flexe; it is preserved
for this exact-version comparison. No new hardware FPS/visual claim.
This review binary creates play-ready.viz and play-result.csv/exit.viz on exit;
these are old review hooks, not a qualified new performance fixture.
