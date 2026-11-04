# NAT-002 serial build and bounded ordinary checks

Author release 2026-11-04 and preimplementation checkpoint2f89f20 select this
scope. Serial native/host/eZ80 compiler children only, each180s timeout;
expected under4min and512MiB memory. No emulator, stress/soak, solver, remote
work or generic firmware build. Native uses frozen direct-rows SDK10947e0,
corrected PSRAM policy, capabilities273/minor6 and unchanged32768/4096/2048/
65536 text/data/stack/package guards. Preserve source, ELF/map/disassembly/stack
and failures. Ordinary bounded source checks may compare actual original/new C
for3600steps/900frames/two warm frames with independent state/pixels and finite
error/lifecycle probes in ordinary and ASan/UBSan modes. Native baseline binary
is reused exactly; no baseline rebuild. Two guest variants use the exact old
binary for compatible state and a new coarse-call guest. All children joined,
normal thermal sensor checked before work, stop at80C/missing sensor, release
shared build token and immediately notify any next owner after cleanup.
