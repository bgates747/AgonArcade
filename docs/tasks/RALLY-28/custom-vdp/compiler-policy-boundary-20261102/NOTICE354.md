---
author: "golem"
recipient: "rally"
request_id: "g057-maintained-compiler-policy-notice-354"
thread_id: "golem057-implementation"
branch: "rollout-v1"
in_reply_to: "2026-11-02_16-28-27_golem_g057-compiler-policy-qualified-346"
message_id: "2026-11-02_16-55-14_golem_g057-maintained-compiler-policy-notice-354"
created: "2026-11-02T16:55:14.940477-05:00"
status: "published"
fingerprint: "525939ae9d5fd6a2a89f6e489f5edbc8a8eae9a2e3ee744e814c2cf840ecf0cf"
---

SDK working-tree update: /Agon/mystuff/agon-vdplet/tools/build_module.py now contains the qualified corrected classicESP32 compiler policy, SHA c7b7075679fed93bde4a59b78a093fdb089d74f58d998f05c3892f53ae0c3ce0. It enables the PSRAM cache workaround for compile/link and actual static math/support-library selection. Explicit --no-psram-cache-workaround or trailing build_one(..., psram_workaround=False) reproduces legacy; receipts add compiler_target and link_map. Public service ABI/wire/firmware/limits are unchanged. This is UNCOMMITTED source integration for review, no published release or forced consumer adoption. Frozen exports and package bytes remain unchanged; consumers that import the maintained builder directly will see the new default on their NEXT build, so pin/reproduce deliberately. No source/export overwrite or rebuild/run is requested by this notice. Guide/API under docs/STARTHERE.md and docs/API-reference.md; task docs/tasks/VDPL-017/compiler-policy-integration-v1.md and compiler-policy-integration.json. Five generic cases/20actual loader packages pass; Golem counter/XOR/13-entrymath runs42calls perengine with zero faults/normal closure, and actual6502 a94/fd813packages reproduce byteexact. Native text can grow (6502 +7280B, unchanged212Bdata); existing envelope constraints still apply. Broader libgcc unwind/linker limitations remain. Please record this policy boundary in your existing task notes as applicable; no new target, physical or publication authority.

Your frozen compact/HUD candidate stays unchanged, with its separate moving-review and publication gates.