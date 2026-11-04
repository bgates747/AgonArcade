# Oryx emulator reservations and checkout

## Availability — 2026-11-01

The Author returned and explicitly resumed GOLEM-057: “oryx is back online.
you may proceed on task.” The2026-10-31 testing hold is lifted;
`testing-hold.json` retains both instructions and timestamps. Resume only
already selected technical scopes with fresh input/idle checks and ordinary
self-service FIFO checkout. No extra process, automatic retry, GUI launch,
hardware or publication approval follows.

Agents reserve Oryx emulator time themselves in one shared FIFO queue. When
first in line and Oryx is free, check it out, run the authorized test, release
it and notify the next agent. **Golem approval is not required for scheduling.**
Only one Oryx emulator session may run at a time, including headless libraries,
audio diagnostics and human reviews. This self-service policy was requested by
the Author on 2026-10-31 and supersedes the earlier coordinator-grant procedure.

## Shared files

All scheduling lives in **agon-dev-env on the Pi**, at:

`/Agon/mystuff/agon-dev-env/cross-agent/vdplet-rollout/`

| File | Purpose |
| --- | --- |
| `state/reservations.json` | FIFO requests, including the current request until its owner finishes |
| `state/checkout.json` | Current owner, task, profile, checkout token and generation; `active: null` means free |
| `oryx_lease.py` | Atomic reserve/checkout/release operations under one file lock |
| `inspect_oryx.py` | Read-only whole-host emulator/process inspection |
| `state/events.jsonl` | Reservation, checkout and release history |

Use this shared copy, even if your project or current session is elsewhere.
Do not create a project-local queue or edit the JSON files by hand. The helper
prevents simultaneous checkouts. Live state is intentionally not committed.
`state/current.json` is a compatibility view, not another scheduling authority.

## Reserve

1. Prepare the test and its finite run/cleanup plan before joining the queue.
   Keep project source, firmware, human-review and hardware approvals in their
   existing scope. A reservation grants machine time, not unrelated work.
2. From the shared Pi directory, use the agon-dev-env environment:

```bash
cd /Agon/mystuff/agon-dev-env/cross-agent/vdplet-rollout
../../.venv/bin/python oryx_lease.py reserve \
  --owner YOUR-AGENT-MAIL-NAME --task YOUR-TASK \
  --purpose 'finite test or Author review' \
  --profile /absolute/oryx/profile \
  --notify-thread YOUR-CODEX-THREAD-ID \
  --notify-host YOUR-CODEX-HOST-ID
../../.venv/bin/python oryx_lease.py status
```

Use your own existing chat's thread/host identifiers so the previous agent can
notify you directly. `--notify-host` may be omitted when the thread needs no
host override. Save the returned `request` ID. Repeating reserve for the same
owner/task returns the existing request without moving it. To change or
withdraw it, cancel first and reserve again if needed.

3. Wait until your reservation is first and `active` is null. Do not ask Golem
   for a grant. If the queue is empty when you reserve, proceed straight to the
   checkout step. Waiting agents can continue source/build work.

## Check out and run

1. When first in line, verify that no emulator remains on Oryx. Use the canonical
   SSH setup from `codex/environment.md` and its machine-local connections guide.
   From this shared directory:

```bash
ssh -o BatchMode=yes oryx-linuxlite python3 - \
  < inspect_oryx.py > /tmp/oryx-YOUR-AGENT-idle.json
../../.venv/bin/python oryx_lease.py checkout \
  --owner YOUR-AGENT-MAIL-NAME --request YOUR-REQUEST-ID \
  --idle-evidence /tmp/oryx-YOUR-AGENT-idle.json
```

The helper requires fresh empty-host evidence, an empty checkout and the first
reservation's exact owner/request. A competing or out-of-order checkout fails.
If a real process is present, identify its owner and arrange release; do not
kill it or assume a stale checkout has expired.

2. Save the returned `lease` token. Assert ownership immediately before each
   permitted emulator process:

```bash
../../.venv/bin/python oryx_lease.py assert-owner \
  --owner YOUR-AGENT-MAIL-NAME --lease YOUR-LEASE-TOKEN
```

3. Launch through the selected profile's real wrapper on Oryx: `cd` to that
   profile, then `./flexe-agon-emulator` or `./fab-agon-emulator` as appropriate.
   Keep headless tests headless and honor the frozen test/cleanup limits.
   The checkout covers the entire process lifetime, not just guest completion.
   Run the reserved tranche, then release; rejoin the tail for another tranche
   rather than retaining Oryx for unrelated follow-on work.

## Release and hand off

1. Stop only your own processes through their normal teardown. Retrieve and
   preserve the required results, verify owned emulator/collector processes are
   gone, then take a **new** whole-host idle snapshot. Release before doing
   lengthy offline analysis:

```bash
ssh -o BatchMode=yes oryx-linuxlite python3 - \
  < inspect_oryx.py > /tmp/oryx-YOUR-AGENT-release-idle.json
../../.venv/bin/python oryx_lease.py release \
  --owner YOUR-AGENT-MAIL-NAME --lease YOUR-LEASE-TOKEN \
  --idle-evidence /tmp/oryx-YOUR-AGENT-release-idle.json
```

2. Release clears the checkout and removes your completed reservation. Its
   output includes `next_request` with the next agent's contact details.
   **Notify that agent in its existing chat immediately** that Oryx is free
   and its request is next. Use the recorded `notify_thread`/`notify_host`,
   steering an active chat rather than queuing the message. Record substantive
   results in the normal durable mailbox. No notification is needed when
   `next_request` is null. The helper does not send chat messages for you.
3. A useful handoff is: “Oryx released; your request ID is next. Read
   agon-dev-env/cross-agent/vdplet-rollout/README.md and check out the machine.”
   If delivery fails, record it and tell the Author instead of silently leaving
   the next agent waiting. Checkout still requires the agent's fresh idle proof.

To withdraw a reservation before checkout:

```bash
../../.venv/bin/python oryx_lease.py cancel \
  --owner YOUR-AGENT-MAIL-NAME --request YOUR-REQUEST-ID
```

If you withdraw from first position while Oryx is free, notify the new first
agent. An active request must be released, not cancelled. There is no automatic
expiry, priority bypass or removal of another owner's reservation. If first in
line but no longer ready, cancel and rejoin later rather than blocking the queue.

## Human reviews and existing checkouts

1. The responsible project agent reserves/checks out **under its own identity**
   and acts as review custodian. Reserve when the Author is ready. Stage stopped,
   provide local launch commands and clear expected controls, and let the Author
   launch the GUI. No agent launches a graphical emulator for the Author.
2. Hold checkout until the Author closes/reports and the custodian retrieves
   evidence and verifies shutdown. Then release and notify the next agent.
   Elapsed time or a quiet chat is not permission to take over an active review.
3. Pre-policy checkouts, including a legacy `author` owner, retain their exact
   owner/token and may use the existing `release` command. Migration preserves
   their generation, current occupancy and queued requests. Old `grant
   --coordinator golem` is retired; use FIFO `checkout` for new sessions.

The Author will announce this policy to agents. Golem is not broadcasting it;
if an uninformed agent asks Golem for time, it receives this document's path
and uses the same self-service queue as everyone else.

## Scope and verification

Human review evidence and stopped-profile guidance are indexed in
[human-reviews.md](human-reviews.md), independently of the live FIFO.
Runtime/SDK and consumer coordination remain documented in
[interfaces-v1.md](interfaces-v1.md) and [assignments.md](assignments.md).
The separate [sender-observer integration](uart-observer-v1.md) pins host-only
diagnostics for6502/Rally; it grants no machine time or additional target run.
Scheduling itself needs no mailbox negotiation or Golem approval. Ordinary
source ownership, physical flashing and explicit human/publication requirements
remain in force.

The helper uses only Python's standard library. Device-free checks run from
this directory with `../../.venv/bin/python test_oryx_lease.py`. They use isolated
temporary state and never start an emulator or modify the live queue.
