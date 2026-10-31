# Fewer serial waits per race frame

Move intermediate publication checks into the native call, then compare a rich
diagnostic guest with a guest that waits only for RUN status and the final
post-swap generation query. Both cases retain the same checked native renderer,
complete race drawing, motion, physics and completion boundary. The experiment
tests serial overhead; it does not change rendering or simulation scheduling.

GOLEM-057 assignment G057-RLY-001 releases existing INC-001-05. The Author's
2026-10-30 standing delegation authorizes Golem's requests on Rally. Durable
assignment: `2026-10-30_18-29-45_golem_golem057-rally-round-trips-one`.
Root TODO is the only authoritative checklist. This is the bounded scope:

1. Preserve existing archives, pending AFF02 review and accepted additive race
   renderer. Use frozen generated source94d92d10..., additive module31077964...
   and firmware8da2ebfd... as the reference. Shared rollout preparation baseline
   is agon-vdplet2541f10; no service/ABI/firmware change is needed. Confirm target
   runtime pins with Golem before emulator use; do not silently adopt new SDKs.
2. Add a Rally-owned finite native wrapper to check the successful render's
   completion readiness, session, request, simulation tick and full root
   generation/publication. Reacquire scoped buffers after the underlying entry
   releases them. Propagate all original and validation/acquire/release errors.
   No raw pointers survive return. Use this identical module in both cases.
3. Build one shared eZ80 guest with an explicit configuration switch. Diagnostic
   control retains all four intermediate READ16s; candidate omits those reads
   after successful checked RUN. Keep the final post-swap generation query,
   serialized RUN/error callback, timeouts, final full-state dump and clean exit.
   Warm renders remain diagnostic in both cases. No pacing/scheduler changes.
4. Host-check actual generated C for900frames/3600ticks against the independent
   world and original module; compare road pixels/all output commands. Inject
   stale completion/generation, nonready/error and lease failures into the new
   checker and reject them. Check balanced leases, cleanup and callback count/
   guest source/binary invariants. Keep all protected input hashes.
5. Prepare isolated silent Oryx smoke/control/candidate profiles. Request the
   central lease with exact pins/profiles/estimate; wait for grant, assert owner
   immediately before every launch and follow original95°C/temporary-boost guard.
   Both SDL drivers dummy; no competing compilation during timing. Never stop
   another owner's emulator. Preserve failures, retry pre-timing only with fresh
   identical inputs. Release after every owned process stops and fresh occupancy
   inspection confirms no emulator remains; report to Golem.
6. Run fresh900frame control/candidate then reverse order. Independently audit
   full final state, exact per-frame request/error/fence sequence, all nonquery
   commands, timers, backend and MOS exit. Expected savings are four17-byte
   queries/four12-byte replies per timed frame:68outgoing/48incoming bytes;
   actual raw captures decide. Lead results with separate nominal MOS/PRT FPS,
   complete-race bytes/replies/wait totals and paired variation. Retain captures
   and stopped human review profile; moving review/publication remain gates.

AFF03 multi-size preparation is separately released for later/independent host
work, but is not combined into this comparison. No hardware, graphical launch,
peer-source edit, shared runtime replacement or commit/push is authorized here.
