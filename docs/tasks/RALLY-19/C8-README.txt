RALLY-19 FINAL GOLEM DRIVING PROTOTYPE / CONSOLE8

Exact final production: 95822 bytes, SHA256
64c8b0734bcd253112d162173fc38f343eafbc96894dc1d09b4793766ed59129
Both tracks' original .vdp bootstrap and .clr cleanup files are included.
These game .vdp files are NOT firmware images.

REQUIRED VDP: official stock AgonPlatform VDP 2.16.0.
The application image is included as vdp_rally.bin, 1077840 bytes, SHA256
b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f
Install it using the normal Console8 VDP update procedure if another VDP
is currently installed. This deployment did not flash any firmware.
No MOS, startup, bootloader, partition or other game files were changed.

From the Console8 MOS CLI:
EXEC /test/rally-19/run-fuji.txt

For oval instead:
EXEC /test/rally-19/run-oval.txt

Equivalent manual commands:
CD /test/rally-19
LOAD rally.bin
RUN . fuji demo

Demo starts automatically. Press a key to take over; arrows drive,
minus/equal adjust grip; Escape exits. Preserve the game files on SD.
This is the final R19 Golem BUFFERED-COMMAND experiment, not a native Xtensa
VDPlet and not the later R22 title/qualifying/race game. Earlier physical
performance was slow. No fix for the Author's R18 lower-left defect is assumed.
This preserved production intentionally has no benchmark/file telemetry.
