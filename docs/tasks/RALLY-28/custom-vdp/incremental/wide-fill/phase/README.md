# Preserved isolated fill probe

The qualified host probe, exact target build and exact guest fixture are retained
here without a dependency on the ignored build workspace. The fixture is ready
for the root agent's separately guarded silent Oryx run. This directory records
no target timing result by itself.

1. `FIXTURES.json` supplies the existing throughput staging tool's `fill` case.
   The six files under `fixture/` are byte-identical to qualified
   `phase-probe02`; neither guest bytecode nor expected metadata was rewritten.
2. `BUILD.json` uses paths relative to this directory. It records portable
   compilation-source, target, host and SDK references plus SHA256 identities.
   `MANIFEST.json` and `SHA256SUMS` cover the retained files. The frozen SDK is
   referenced at `../../../paced-road/control/sdk`; no SDK tree or firmware is
   duplicated here.
3. `target/` preserves every authoritative output from the real Xtensa build,
   including the VDPL image, ELF, object, stripped ELF, manifest, complete
   disassembly, inspected functions, ELF inspection and stack report. These
   files are exact copies. Historical absolute source/output paths remain in
   the original target manifest and original build logs as provenance only;
   current portable references are in `BUILD.json`.
4. `package/source/` contains the actual compiled C source, exact diagnostic
   candidate include and host harness. `source/` preserves the builder/decoder
   and unmodified candidate include snapshots. `input/` contains the exact
   selected span capture, capture metadata and packaged target input. Rebuilding
   the target requires only the preserved compilation source, pinned compiler
   and referenced frozen SDK, not the old `.work` package.
5. `host/` retains ordinary and ASan/UBSan raw binary outputs, process output and
   the full decoded qualification report. All80 sample windows pass expected
   CRC32, full-scratch equality, guards and balanced leases. Host clocks are
   fake format checks and supply no performance evidence.
6. `PRESERVED-FAILURE.txt` and `.json` retain the initial LeakSanitizer ptrace
   failure. That failed host-only qualification is excluded. The qualified
   second run disabled LeakSanitizer while retaining AddressSanitizer and
   UndefinedBehaviorSanitizer. It did not run an emulator or produce a timing
   result.

From this directory, the portable target rebuild command is:

```bash
"$PWD/../../../../../../../.venv/bin/python" \
  ../../../paced-road/control/sdk/tools/build_module.py \
  package/source/phase_probe.c --name fill-phase --build-id 0x52324631 \
  --output /tmp/rally28-fill-phase-rebuild \
  --text-limit 8192 --data-limit 1024 --stack-limit 512 --image-limit 16384
```

The resulting VDPL image must match
`98eb19d61d25590c56b1e4b4eb0100ff542681fcf0354eebd22475260e0732e5`.
The archived builder's relative `.work` layout is historical; the command above
uses the preserved portable compilation sources directly.
