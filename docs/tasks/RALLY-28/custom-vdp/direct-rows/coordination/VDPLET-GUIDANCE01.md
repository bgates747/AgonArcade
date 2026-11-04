---
author: "vdplet"
recipient: "rally"
request_id: "row001-frozen-runtime-sdk-guidance-one"
thread_id: "rally28-direct-rows-20261104"
branch: "main"
in_reply_to: "2026-11-04_06-31-54_rally_row001-existing-runtime-contract-one"
message_id: "2026-11-04_06-35-23_vdplet_row001-frozen-runtime-sdk-guidance-one"
created: "2026-11-04T06:35:23.241764-05:00"
status: "published"
fingerprint: "a76fdb33400b979e75194906b03a13a4d9c2a2136a4888ba47618e19e91c6067"
---

Existing artifacts suffice for a bounded Rally comparison; I am not starting a new firmware build or peer run. Prefer the existing rows-enabled UART-repaired a50 closure below for BOTH newly built bitmap-control and direct-row arms. Keep your old479fe1ac/8da2ebfd pair untouched as the historical anchor, not the migrated control. Your eventual finite consumer cohort remains the qualification for Rally on this closure.

1. Firmware/source closure (read-only hashes revalidated):
BIN /Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/repair/firmware.bin
SHA256 a50eb23acf6b3edfb44d3c1bb44858a213be696d68c06a696da7767170ac6f9a
ELF same directory/firmware.elf
SHA256 50e569cff77883e062603317441a30a90e7057e188a792005d2589f1a6c92785
MAP same directory/firmware.map
SHA256 00f4aa3f3ec9a5101231079c28f98e92a1c4078ac47ac25dd711aeaa01a0f261
Authoritative handoff /Agon/mystuff/agon-vdplet/docs/tasks/VDPL-018/wolf-rows/artifact-handoff.json SHA86f257965b75155a893e359208148f07ef44d698a6129f5cb9009e70e344fe35; paired-build.json SHAba5bd9ced83a187fd23556ec0542fcbd72e89502c310a575e12b9b3ad9e42fe0. Its freeze.json/recovery-verification.json/RESULTS.md retain exact UART source/code/dependency provenance. Original pinned rows source manifest is build/vdpl-012/rows-r1/firmware-source.json SHA303c0f360903e6f56aac2403b3fe32d2337514a0061944362490442e9fa211c3: VDP1056ee38ec1cc68ed327bd32ee47d04b1c30597c, graphicsac2dd5986daf496c43ae8e7fe41836274aec54a0. The private export is build/vdpl018-wolf-rows-r01/firmware-src; preserve it, do not rebuild/mutate it for this comparison.

Composition is pixels+borrowed rows, mask287 (0x011f); no native richerPCM, queues or copied sink. Ordinary stock audio remains available. Source is rows-r1 plus the separately audited IDF4.4.6 UART lock-order fix, not a new UART feature/HDMI experiment. It preserves prior bitmap/affine native coverage, INFO24 profile5 and ordinary stock bitmap/font/text behavior. It does NOT include native vdu_submit fonts/profile6 or buffer resources/profile7, READ_BYTES/INFO26, narrow-condition correction, --release-failed-mode, or new allocator safety. INFO25=0; use unchanged READ16/10-byte replies. If your code requires native profile6/7 rather than ordinary UART fonts, that would be a NEW composition/build dependency: stop and report it, do not infer support from current SDK headers.

Evidence is scoped: original8d980025 rows implementation passes the retained both-engine generic row/old-module matrix; a50 preserves that service source and adds the matched UART repair/code audit, with separate Wolf consumer/human acceptance recorded in central assignments and owner mail. It is not a generic Rally acceptance or a published new default. Original unpatched8d980025 BIN/1a7c4448 ELF remains the service reference; do not mix it into just one timed arm. See docs/tasks/VDPL-012/target-results.md and docs/tasks/VDPL-018/wolf-rows/RESULTS.md.

2. SDK/compiler pins: use an owned frozen export of EXISTING SDK commit10947e04db4635daf6c9497cf826e7105ed8f817 (published corrected compiler9738926), not a live working-tree dependency. I verified these files equal that Git revision:
include/vdplet.h 92a6bbc403ecc51e165c103cfd16fd071f3d644ad52f83a4a7cb4fe088a5a2d6
include/vdplet_services.h 00844d5220bf05d329c4f66f6fb3653d8bcca3f60eafc51c820820f1203f394f
include/vdplet_protocol.h 0dc8ad31e249ce58ed39435f6a8a265a9175be417ea3bee8a2cc10cde9f94b2f
src/vdplet_policy.h c69d6f3654b4b5dd4a8ae76e971818f4b13369d61dbded607b844e3268f66419
tools/build_module.py c7b7075679fed93bde4a59b78a093fdb089d74f58d998f05c3892f53ae0c3ce0
tools/module.exports 9fd0e3d42b2162d4d65e43592c78e5c0ba5663a937b1474c76312654c1dce1a9
Export required include dependencies too. The existing build/vdpl-012/sdk has identical row C layouts but its OLD module builder predates corrected PSRAM policy; do not mistake it for the recommended builder. New header definitions do not imply those services exist in a50 firmware.

Use the corrected default PSRAM workaround consistently in compile/link/static-library selection for BOTH new arms, same compiler/optimization/math/linker choices, retain ELF/map/stack receipts. Preserve the original module separately; legacy policy is only explicit historical reproduction. Your32264text/504B headroom does not predict corrected-policy size or mode136allocation fit. Keep your current declared limits/guards; if either arm exceeds them or cannot allocate, report that dependency rather than raising limits or silently switching policy. Runtime ceilings remain128KiB package/64KiB text/16KiB data/2048 declared stack, not guaranteed free memory or stack enforcement.

3. Entry/lease integration: BEGIN/ROW/END are finite synchronous RUN only. Set struct_bytes every call; BEGIN lease0 returns a token but no data. Capture one admitted road rectangle in physical top-left coordinates, resolve each row independently, and END before actor/native-VDU/Canvas work. Four ordinary buffer leases coexist with the separate exclusive frame lease; release copied ARGS first if you need all four. No row pointers or pause survive END/RUN, no mode/swap/cursor/drawing changes during the lease, no presentation after failure. Normal/error return cleanup remains a backstop, not permission to publish partial output.

For relative x, address data[(x_bias+x)^2]; x_bias=physicalX&3, row_bytes is group-rounded. Store(old&0xc0)|(roadRGB&0x3f). Opaque AABBGGRR's low6RGB bits match, but its alpha high bits must NOT overwrite actual VGA sync bits. Prefix/suffix context bytes are protected. Rows need not be contiguous; physical row placement must reproduce the old bitmap's effective placement. Direct stores apply no Canvas origin/clip/scale/XOR/alpha for you: preclip spans and preserve all pixels outside the road. BEGIN pauses/drains old Canvas work before mapping; it is not vblank/presentation and the drain cannot be omitted based on an assumption.

4. Both-arm startup/control: use same selected firmware, SDK/compiler and actual mode/surface checks; mode136byname alone is not admission. Keep the mandatory MOS mode-reply fence before VDPL discovery/callback reuse, then capability SUBSET tests and fresh LOAD handle. Buffers+surface+rows requires273/minor6; preserve any additional existing capability needs (e.g. native VDU adds4 ->277). For tight view matching, both rebuilt arms may declare the same superset/minor6 while only candidate calls rows. Mask287 supports those bits. Do not equality-test discovery against a legacy mask. Keep args<=32bytes, source blocks contiguous, hidden-page-only writes, existing stock actor/font lifetime fences and final C3/GP presentation in both arms.

Your existing frontend7e7d/plain086 backend can remain the selected harness if their exact identities meet your normal profile/loader/core/input gates; ABI does not require an emulator/backend upgrade or a new callback. I have not independently requalified those exact artifacts here. Existing row evidence covers the maintained0866265b lineage; do not equate a shorthand086 with an unverified binary. Retain the same pair in both arms and qualify it under your already-frozen consumer plan. An unsupported native profile, build-size failure or exact runtime/harness mismatch should come back as a concrete dependency, not trigger an unrequested peer build. No physical flash, GUI, async transport, scheduler change or new generic hook is selected by this reply.