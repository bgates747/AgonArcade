# Stock VDP drawing-completion probes

Two small standalone applications test completion notification while the eZ80 continues foreground work. Both use the unmodified official VDP 2.16.0 binary and official MOS 3.0.2. The keyboard version requests virtual key zero after flushing drawing; the control version uses a general-poll token. This is a mechanism experiment, not Rally physics or a performance benchmark. Results and remaining review are in [RESULTS.md](RESULTS.md).

## What runs

1. The guest stores four drawing buffers and 52 short frame buffers through the stock buffered API. Each frame buffer calls a drawing buffer, then executes exactly seven completion bytes: `23,0,CA,23,0,99,key` or `23,0,CA,23,0,80,token` (selectors in hexadecimal).
2. The key application tests 24 light and 24 heavier frames with `VK_NONE=0`, then four light frames with `VK_F12=170` as a comparison. The poll application uses 52 distinct primary tokens. The heavier drawing repeats a filled rectangle 192 times; alternating final marker colours provide a simple drawing check.
3. A foreground counter advances from the interrupt-updated MOS clock while completion is pending. The app targets at most 30 submissions per nominal second, skips render catch-up after a late completion and keeps one frame outstanding. This counter is a stand-in; it does not execute Rally's physics or establish its CPU budget.
4. Only **after the primary callback/token arrives**, the foreground requests a pixel readback and separate verification poll. Those extra commands are outside the stored frame and cannot be required to elicit its primary completion. The host verifier checks their order against actual VDP UART packets.
5. Two one-second request-free controls detect unsolicited marker responses. The callback captures raw key packets without modifying them. Its ISR makes no MOS/VDU/file calls. The previous callback is saved and restored; only the probe's buffers are cleared.
6. At completion the guest creates `summary.txt`, `events.csv` and `done.txt` in its current MOS directory. Existing results are preserved: use a fresh profile/directory for another run. The CSV contains labelled frame and key sections with their respective headers. Failed guest checks remain explicit in the summary/done file.

## Author visual/input review on Oryx

Author has now launched the callback profile and its returned summary passes 52/52. Its review directory contains saved results; use a fresh directory/profile for another run. The mechanism is accepted for further planning, with broader input and Console8 confirmation still open. The instructions below preserve the original launch procedure, not a new request to repeat the visual test.

The callback profile was prepared stopped before that Author launch. Its launch command on Oryx's desktop was:

```bash
cd ~/Agon/mystuff/AgonArcade/.emulator/rally28-completion-review
./flexe-agon-emulator
```

Allow approximately 11 seconds including boot. Expect the titled test screen, a coloured drawing area and alternating green/blue marker, followed by `PASS: 52/52 completions` and the counter total. Try holding/releasing arrows and A/Z during drawing, then verify ordinary typing at the returned MOS prompt. F12 is intentionally also a physical-key comparison in the last four requests; pressing/releasing it in that interval can produce an ambiguous-marker failure. Virtual key zero is the proposed application marker. Report failures and which keys were held. Close the emulator when finished.

The general-poll control has its own untouched profile:

```bash
cd ~/Agon/mystuff/AgonArcade/.emulator/rally28-completion-poll-review
./flexe-agon-emulator
```

Both launchers force dummy audio even for Author video review. Agents launch only with **both** dummy video and audio, through `run.py`; no visible session is started automatically. These are one-run review directories so saved evidence is not overwritten.

## Reproduce

Build on the development Pi using the repository Python and installed AgonDev:

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/completion-probe/build.py
```

Outputs are `.work/key/bin/probe.bin` and `.work/poll/bin/probe.bin`; `.work/build.json` records source and binary hashes. All four CRT initializer/finalizer tables must be empty. Game sources and existing fixtures are not rebuilt or modified.

Download `firmware.bin` from the [official VDP 2.16.0 release](https://github.com/AgonPlatform/agon-vdp/releases/tag/v2.16.0) into `.work/stock-v2.16.0.bin`. Its required SHA-256 is `b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f`. `profile.py` refuses another image. Stage the probe directory on Oryx with the compiled binaries, this firmware and the canonical setup helper available; no firmware build or flashing is involved. `profile.py` uses the canonical `agon-dev-env/scripts/setup_emulator.py`, or its identity-recorded `.work/setup_emulator.py` export when the canonical repository is absent on that host.

On Oryx, prepare a fresh stopped profile (substitute `poll` and its binary for the control):

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/completion-probe/profile.py \
  --name rally28-completion-new-key --kind key \
  --binary docs/tasks/RALLY-28/standard-vdp/completion-probe/.work/key/bin/probe.bin \
  --firmware docs/tasks/RALLY-28/standard-vdp/completion-probe/.work/stock-v2.16.0.bin
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/completion-probe/run.py \
  .emulator/rally28-completion-new-key --timeout 60
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/completion-probe/verify.py \
  .emulator/rally28-completion-new-key
```

Optional `input.c` compiles as an SDL3 preload library on Oryx. `run.py --keys PATH` feeds eight down/up events through SDL, Flexe's PS/2 model and executed firmware after the guest's readiness marker; use `verify.py --expect-input` for that key-probe run. It does not inject UART packets or change emulated RAM. Ordinary automated runs also force both SDL dummy drivers.

## Limits

1. This exact build pins MOS 3.0.2: saving the prior callback reads its published map's callback slot at `sysvars+0x6c`. The profile validates the official ROM/map hashes. Do not assume this address is portable to another MOS build; no MOS code is patched.
2. The zero-key marker has no sequence token. One outstanding request and request-free controls are essential. Console-mode serial input can also use virtual key zero; the tested profile uses normal PS/2 mode. A later application adapter must own marker/input policy explicitly.
3. Completion means preceding drawing has drained, not physical monitor presentation or a double-buffer swap. The probe uses single-buffer mode 8 and issues no VBlank wait. Callback latency includes firmware keyboard/event scheduling and UART delivery; light intervals below clock resolution are recorded as zero, not zero execution cost.
4. Emulator timing and the cheap counter establish neither physical performance nor a guaranteed 120 Hz physics workload. Human visual/input review and a byte-identical Console8 run remain open. General poll is documented for internal synchronization and remains a workaround.
