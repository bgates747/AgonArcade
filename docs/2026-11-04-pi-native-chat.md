# Pi-native interagent notifications — 2026-11-04

Read the Pi5 manager's durable notice
`2026-11-04_05-52-22_pi5-manager_codex003-rally-native-route-one`, the canonical
[Pi-native sender instructions](/Agon/mystuff/agon-dev-env/cross-agent/agentcoms/pi-chat.md),
and the Pi-hosted section of the
[mailbox README](/Agon/mystuff/agon-dev-env/cross-agent/agentcoms/README.md).
For authorized Pi-hosted notifications these supersede the desktop-only recipe.

Rally's verified source chat UUID is
`01a1346d-a74a-7211-b5b7-de3bcb8a28e5`. Resolve the recipient from its current
verified contact; never substitute another agent's source identity.

```bash
/Agon/mystuff/agon-dev-env/.venv/bin/python \
  /Agon/mystuff/agon-dev-env/scripts/pi_chat.py send \
  --source-thread 01a1346d-a74a-7211-b5b7-de3bcb8a28e5 \
  --thread ACTUAL_TARGET_UUID \
  --resume \
  --delivery-id YOUR_UNIQUE_STABLE_ID \
  --message-file -
```

Supply UTF-8 text through stdin or use an existing file for `--message-file`.
Publish substantive coordination as durable mail, then immediately send its
short chat alert. The helper steers active chats and can resume stored unloaded
chats with saved settings; it does not authorize paused work. Preserve the
existing recipient and omit configuration overrides.

Use ordinary justified native escalation if the sandbox blocks Unix socket
access; do not change socket permissions or host settings. Receipts live under
`/Agon/mystuff/agon-dev-env/.local/pi-chat/deliveries/`. Acceptance is not proof
of reading. An identical accepted delivery ID is idempotent; changed content
needs a new ID. Resolve uncertain outcomes through recipient history or a
receipt before retrying. Do not send acknowledgment-only ping-pong.

This procedure update selected no project work, machine reservation, build,
emulator, human review or publication. No notification was sent to test or
acknowledge the memo. Existing freezes and the stopped profile remain unchanged;
the historical Golem feedback route still needs a separately selected readiness
update as recorded in the runtime-owner handoff.
