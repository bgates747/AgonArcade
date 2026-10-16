# Olimex diagnostic installed — manual suite launch

The Author-authorized mainboard diagnostic was flashed from the Pi and independently read back byte-for-byte. [Installation receipt](MAINBOARD-FLASH.json) pins image36edc736…,1,085,168bytes at app0/0x10000 and mainboard MAC10:06:1c:0b:46:e0. Incoming affected flash is preserved in the Rally workspace. Bootloader/partition/NVS/OTA bytes and the unwritten app tail compare unchanged; normal common mainboard reset completed. No P4/EMOS/startup change or test invocation occurred. Actual post-reset CLI execution is not asserted by the flash receipt.

Use the **remote Agon CLI from Oryx**. These are Agon commands, not laptop shell or Pi scripts. At a visible responsive MOS prompt, select mainboard output:

```text
EMOS LEGACY --keep-display
```

Then preselect the single-buffer test mode:

```text
VDU 22 8
```

Wait at least one whole second after the monitor changes. Start the suite:

```text
EXEC /test/arcade/rally/r28-road/suite.txt
```

The first five cases measure physics/CPU work and show text. The sixth is the empty timing control; the final four draw roads. Each app saves its own files in its case directory and restores its entry mode. Because manual preselection sets the entry mode, it returns to mode8; no earlier mode was recorded by this manual launch. Root startup is unchanged and does not start/resume a suite on reset.

This is an explicit MOS command chain using the exact standalone cases, not the unqualified Pi coordinator. MOS EXEC stops when a nested command returns an error; a stalled workload also blocks the chain. Saved summaries/state/counts still require independent verification after collection. There is no hardware five-minute reset or automatic replay. Preserve partial results if a case fails. Do not run again into existing result files. Keep the card in the board during execution; return/remount it on Oryx after the run is finished for collection.

The physical live completion/cadence/FPS results remain unqualified until returned. Read the card readme for individual case commands and expected outputs. All new source, flash receipt and handoff notes remain uncommitted pending review/publication instructions.
