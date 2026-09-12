# RALLY-18 review checkpoint

The user reviewed the running candidate and requested: “we should freeze here
then talk.” This authorizes committing the isolated implementation and retained
results, then stopping development.

User observation: “it has the feel of an application staying within its budget,”
with the qualification that the Mac appears to be struggling with the emulator.
This is encouraging subjective feedback, not a new timing measurement or proof
of 60 FPS on hardware. The measured results and their limitations remain intact.

No game or timing changes were made for this checkpoint. Mainline remains
unchanged. The review emulator is left running. Further implementation,
mainline integration and physical-hardware qualification await discussion.

The accepted contract and prior work remain frozen at 182a1d0. Earlier audit
JSON files describe their original pre-commit state; their pending-commit fields
are historical, superseded by this checkpoint decision.

## Unfenced 30 Hz review checkpoint

The user subsequently played the stock-emulator/stock-VDP candidate with the
four-tick (30 Hz) presentation pacing retained and the `fence` option removed,
and explicitly authorized committing this configuration.

Working assumption: this candidate can sustain 30 Hz in normal play. Existing
computation/transmission measurements and the user's subjective play experience
support that supposition, but do not establish a guaranteed frame rate. No new
rigorous measurement of this unfenced interactive configuration was performed.
There is no physical-hardware qualification or worst-case frame-time proof.

The review launcher now omits all poll/profiling options. Startup/exit marker
files and the exit summary remain outside gameplay's frame loop. The binary,
road data, physics and 30 Hz presentation deadline are unchanged.

Correction to prior interpretation: a general-poll echo is not a documented
rendering-completion API. The suspected extra wait in the native emulator swap
path remains a hypothesis requiring an isolated test; it is not an established
universal 30 Hz ceiling, and says nothing about a hardware double-buffering
limit. Historical benchmark observations remain retained; their stronger
completion/ceiling interpretations must be read with this qualification.
