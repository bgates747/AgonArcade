# 2026-10-28 — Rally native throughput investigation

The Author releases a fresh baseline and an isolated native road renderer experiment toward60Hz. Existing renderer evidence and the new work contract will be committed/pushed before implementation. No prior visual/hardware gate is accepted by this checkpoint. Scope: [RALLY-28 HZ60-001](tasks/RALLY-28/custom-vdp/throughput/PLAN.md).

Initial read-only checks find Oryx reachable with the canonical SSH identity, the preserved native review runtime present, no emulator running, and CPU boost enabled (`1`). Existing thermal safeguards require boost disabled for unattended runs; no power setting has been changed and no emulator has been launched. Continue independent source/host work; actual timing remains conditional on the guard.

Two parallel read-only audits identified the frozen ABI's limitations (no native timer service and only single-buffer monochrome frame access) and a supported alternative: write an application-owned RGBA2222 buffer through existing buffer leases, then draw it through the stock bitmap command. The finite900-frame flat-background Fuji fixture remains the comparison workload; full playable-game performance is not implied. The new contract separately identifies unpaced and diagnostic cases and preserves historic benchmark bytes.
