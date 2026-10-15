# RALLY-28 — standard-vdp

RALLY-28 standard-VDP implementation area, first priority. Pseudo3D computation stays on eZ80; preserve standard firmware compatibility.

Scope and stable subtask IDs are defined in [the parent task](../../RALLY-28.md); [root TODO](../../../../TODO.md) is the authoritative register. This directory has no separate task list. Keep local build/trace artifacts under ignored `.work/`. No full-game implementation has started.

SYNC-001-01 proposes a minimal standalone stock buffered-command completion probe under `completion-probe/`: drawing flush followed by a requested key-state packet, MOS callback/mailbox, simple drawing and an independent elapsed-time counter. [Review scope](../../RALLY-28.md#stock-vdp-completion-signal--minimal-test-application) specifies input/order checks, self-created logs and a general-poll fallback. Planning is awaiting Author review; no probe code, build, profile or run is released.

LOOKUP-001-01 includes isolated host/code-generation feasibility: `lookup_direct.hpp` shares a direct integer emitter between preserved LookupRoad and live endpoint-only SectionRoad; `lookup_study.cpp` checks geometry/material/command behavior; `lookup_probe.cpp` inspects actual eZ80 arithmetic/types. These are not installed game backends or a runnable emulator fixture. [Assessment and reproduction](../research/LOOKUP-ENGINE-REVIEW.md) record9,930 host poses in ordinary/sanitized modes and the remaining full-scene timing/visual work.

Before selecting further implementation, POS-001-01/REUSE-001-01 audit positioning and repeated work across the complete standard hot loop. REUSE-001-02 requires applying each selected optimization to all compatible active consumers through the STD subtasks; REUSE-001-04 records coverage/exceptions and qualification. Preserve existing lookup/endpoint improvements when changing the emitter, and share only state with matching inputs, rounding and lifetime.
