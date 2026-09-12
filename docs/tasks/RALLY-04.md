# RALLY-04 — Physical-hardware validation

Validate the selected Rally candidate on physical hardware. The previously
deployed retained-scrolling binary was 97,244 bytes and predates default demo
mode. Its improvement over the lag/strobing build was inconclusive. Do not
assume the physical card contains the current Mac review candidate.

Identify and record the exact binary/hash, firmware and mode before testing.
Hardware performance acceptance remains open and depends on RALLY-10 findings.
Deployment requires a user request: write only the scoped Rally binary, preserve
unrelated card contents and leave physical `autoexec.txt` untouched. Record
human observations and measurements in the dated development log; successful
emulation is not hardware acceptance. Root TODO.md owns completion status.
