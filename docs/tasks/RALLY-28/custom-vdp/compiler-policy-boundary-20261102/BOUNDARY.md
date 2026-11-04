# Maintained native compiler policy boundary —2026-11-02

Golem354 notifies an **uncommitted maintained SDK working-tree update**, not a
published release or a consumer adoption request. The qualified builder at
/Agon/mystuff/agon-vdplet/tools/build_module.py has hashc7b7075679fed93bde4a59b78a093fdb089d74f58d998f05c3892f53ae0c3ce0.
It defaults to the classicESP32 PSRAM cache workaround at compile and link,
including actual mathematical/support-library multilib selection. Receipts
add compiler_target and link_map. Public ABI/wire/firmware/limits are unchanged.

1. **Existing Rally outputs stay fixed.** Native479fe1ac, cached guestc6d75022,
   accepted runtime/firmware, all qualification proofs and the stopped human
   profile remain unchanged. No package/export/source overwrite, rebuild,
   emulator, Oryx contact or publication occurs for this notice.
2. **Current Rally build provenance is frozen.** Incremental round-trips/build.py
   and prepared-bitmap-set/runtime/build.py call the project-local
   paced-road/control/sdk/tools/build_module.py export. They do not directly
   import the newly changed maintained builder. That frozen export is not
   repinned here. HUD guest builds use AgDev eZ80 tooling; the notice concerns
   Xtensa native VDPlet machine code, not a new eZ80 compiler default.
3. **Future maintained imports are a different build policy.** An explicitly
   selected next build using the maintained SDK would default to
   -mfix-esp32-psram-cache-issue for compile/link and matching esp32-psram
   libraries. Deliberate legacy reproduction uses the original frozen export
   or explicit --no-psram-cache-workaround / build_one(...,
   psram_workaround=False). Do not silently label changed output a byte-identical
   rebuild. Record compiler_target, argv, library hashes and link_map.
4. **Capacity remains a separate admission gate.** The accepted compact module
   reports32264/32768 text bytes, only504B headroom. Workaround growth depends
   on workload; the reported6502 +7280B is not a Rally estimate. Any later
   selected policy migration must measure actual text/data/package/resource
   effects under existing limits and qualify a separate image/cohort. No
   limit increase, rebuild or adoption is selected now. Broader libgcc unwind/
   linker limits remain; firmware settings do not retrofit separately uploaded
   machine code.

Authoritative guidance: agon-vdplet/docs/STARTHERE.md and API-reference.md;
provider task VDPL-017/compiler-policy-integration-v1.md and its JSON receipt.
NOTICE354.md preserves exact owner evidence/scope. Existing human/manual-flow,
publication/default/hardware, clock calibration and old startup-cause limits
remain. No reply-to-ack or additional owner work is required by this record.
