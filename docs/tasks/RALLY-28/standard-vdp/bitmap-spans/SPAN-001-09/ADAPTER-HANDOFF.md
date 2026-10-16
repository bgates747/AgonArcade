# Concrete live-adapter requirements before Olimex chain execution

Rally's finite cases, exact package, offline coordinator and raw-output verifier are prepared. This is a requirements handoff, not permission to access/flash/reserve the bench. No owner message was sent in this tranche.

The live adapter must supply the same authoritative facts required by Extender's accepted lifecycle coordinator:

1. Positive resident foreground ownership (`cli` versus application) and visible responsive CLI handback. A saved done file alone is insufficient because return/CRT/CLI output follows it; keyboard-ready or delivered input alone is insufficient.
2. Fresh mainboard and P4 boot identities. P4 keyboard-admission epochs are separate; a mainboard reset must invalidate dispatch, without automatic recovery/replay.
3. Fresh committed EMOS route and separate mode descriptors for both displays, supported state-preserving route/mode operations, minimum one-second confirmed settling, and truthful status-cue receipts without changing restored state. Current fixtures gate double-buffered entry rather than guess cleanup.
4. Verified immutable mainboard diagnostic image, EMOS/input admission and P4 identities, read-only ordinary startup hash, exclusive bench reservation and commissioned Pi lock. The package pins the intended VDP image; current installed state has not been queried.
5. Deployed input readback verification, new result paths, explicit standalone CLI launches, exact output retrieval only after actual application completion and hashes for all required outputs. Route/input installation and firmware flash/rollback are separate operations.
6. JSON request/receipt binding to run UUID/sequence/action; no hidden retry, reset, startup write, flashing, card ownership takeover or implicit resume. On ambiguous launch/result/transport/reset, stop further device actions and preserve journal.

The existing Extender scrolling live adapter is itself documented unqualified; Rally has not invented a convenience adapter from P4-only observations. `PLAN.json` stays not-ready until these capabilities and actual bench availability are commissioned/verified. Individual Author-controlled invocations can use the prepared command files after separate deployment/firmware/lifecycle preflight; they do not qualify the unattended chain.
