# Generated state qualification results

TRF-001-31–35 are complete at the released host scope. Actual C from the accepted Golem foundation compiler passes731 independent invocation checks per layout in ordinary and ASan/UBSan builds:2,924 checked invocations total. Both layouts preserve every expected root/array byte, all granted leases are released, and repeated compiler generation produces identical artifacts. The tranche returns for Author review; full simulation and combined renderer/target qualification remain open.

The reviewed state/scope was pushed as checkpoint `4489f58` before execution. New source/results remain uncommitted. [Master receipt](RESULTS.json), [dependency receipt](DEPENDENCY-RECEIPT.json) and [replay/boundary ledger](README.md) record exact inputs, generated artifacts, source/tool hashes, durations and limitations.

## Evidence

| Check | Result |
| --- | --- |
| Accepted deliveries | D1a139files + foundation122files independently hash-verified |
| Exported source lineage |26 +18 files match their published commits |
| Package identity/initialization | Six delivered packages, actual root/array/common installation and cleanup metadata |
| Tool identities | Five executable hashes and pinned SDK files match locally |
| Rally fixture |38 finite entries;196-byte root; six retained arrays totaling634bytes |
| Source initialization | Scalar literals/types, four mutable array initial images and exact frozen route/sine tables match |
| Actual generated C invocations |731 per layout/build; both default and relocated layouts |
| Table read checks | All281 route/sine entries per layout/build; out-of-range rejection preserves destinations |
| Independent published vectors | All8 supported add/subtract and29 representable conversion/identity vectors per layout/build |
| Explicitly deferred conversion inputs | Two values outside delivered source domains |
| Metadata consumer failures |40 malformed metadata cases rejected across both layouts |
| Failure/lifecycle coverage | Six-slot reads/writes, index before RHS overflow, failed stores/prior effects, Bounds, casts/widening, comparisons, physical array/role/root failures, pre-entry/metadata rejection, persistence/reset and generation wrap |
| Ordinary/sanitized output | Complete root/array result digests match for each layout |
| Mock maximum views |3: argument+root+one array; granted leases balanced with releases; no leaks/canary changes |
| Repeat generation | All saved generated artifact hashes identical for both layouts |

The first run's final accounting assertion incorrectly compared all acquisition attempts, including deliberately rejected requests, with releases. Corrected the host harness to count granted leases separately, then reran full verification. Generated C and its semantic expectations were not changed to conceal a product failure. Added explicit identity-cast and independent literal-initialization checks before final qualification.

## Integration disposition

TRF-001-12 now has independent generated-storage/descriptor/persistence host evidence; actual installation/backend/target qualification remains open. TRF-001-13 has foundation add/subtract/comparison/conversion evidence, not full Tick120 route/contact simulation. Multiplication and paired division are later compiler dependencies and were not silently adopted in this fixed foundation tranche. Wide shifts/exact wider helpers/full route replay remain open.

D2 still needs delivered native-only helper binding parsing, actual source/array marshaling, the agreed464-byte private renderer context, separate48-byte completion installation, early argument release, helper/publication status ordering, a single combined dispatcher and native stack/resource qualification. This tranche leaves the compiler's ordinary argument+root lifetime intact; the future composed helper requires the accepted early-release refinement. Firmware clocks/snapshots/callback events, recovery choices and120/30-Hz cadence need their separately released services and Author decisions. No game/compiler/SDK/firmware source changes, combined native link, target runs, deployment, capacity probes or further pixel research occurred. The Author's own visual confirmation remains the final visual gate.
