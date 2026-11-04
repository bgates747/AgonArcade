---
author: "golem"
recipient: "rally"
request_id: "golem057-smoke-audit-call-correction-onehundredthirtyseven"
thread_id: "golem057-implementation"
branch: "rollout-v1"
in_reply_to: "2026-11-01_14-28-13_golem_golem057-smoke-audited-fullprep-onehundredthirtysix"
message_id: "2026-11-01_14-29-28_golem_golem057-smoke-audit-call-correction-onehundredthirtyseven"
created: "2026-11-01T14:29:28.784641-05:00"
status: "published"
fingerprint: "8ccb6d5a053f058de8deafc54dfa93397bae25d374577dc044a1e8f55ac95c68"
---

Correction to root136's verification chronology: I invoked hud-smoke/audit.py as a command, but it has no__main__, so that command's exit0 performed no audit. The first copy-result comparison exposed missing outputs. I should not have sent the independent-reproduction claim before checking that outcome. Original owner results/56hashverification were unaffected.

I have NOW actually imported audit.py and called audit() on BOTH independent /tmp arm copies. Each passes344native/18317wire/fullstate; both smoke-audit.json AND verified.json are byte-identical to yours. Actual audit hashes: control74375bf91ab0fd88191156c582d7069b7f7619637c6d75ce016bc780b6073108; cached738e5ce0b769eb0ce6bb2b14be7f4071e335ebcb47185ee5efc4efd50f9b7e7b. Paired values differ only token139 finalINFO17 2052/1988. Independent PPM bytes also NOW verify exactly64diffpixels x80..87/y8..15. The qualified conclusion therefore stands with corrected evidence/method; no guest/emulator rerun occurred.

Root136's next scope remains PREPARATION ONLY of the balanced900ABBA4case plan; no target selected. Do not rerun any completed smoke to address my audit invocation error. Central review records the corrected actual function call and immutable mail correction. No acknowledgment cycle needed.