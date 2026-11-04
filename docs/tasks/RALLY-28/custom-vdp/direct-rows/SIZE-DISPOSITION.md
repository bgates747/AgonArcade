# First native build and bounded size correction

Both first-attempt variants compiled/linked, then correctly failed their
unchanged32768-byte text admission guard with the maintained PSRAM compiler
policy: bitmap35,728bytes, rows35,912bytes; data1,004bytes each. The row output
change itself is only184text bytes in that attempt. No package/target was
admitted, no limit was raised and no legacy compiler switch was selected.
Keep build/ and BUILD-ATTEMPT01.json as first-attempt evidence.

Source inspection finds the old generated package exports seventeen entries,
including stand-alone Sine/RouteTick/Contact/arithmetic diagnostic calls and a
duplicate ResetRace. The complete race only calls entry3Tick120,13InitRace,
15Render30and16StopRace. Entry3contains its required numerical work in its own
case; it does not dispatch through the stand-alone public test entries.

The next source correction removes those UNUSED dispatcher case bodies from
BOTH new arms and explicitly refuses their entry IDs before state mutation.
It retains byte-identical used case bodies, entry numbers, root layout,
simulation/render arithmetic, validation, publication and cleanup. The old
full package remains untouched. This is a task-local race package, not a new
generic ABI or public replacement of the historical kernel-test package.
SOURCE.json records hashes of all retained case bodies for review.

Rebuild in separate build-r02directories under the same32768/4096/2048/65536
guards and corrected compiler policy, then qualify actual generated-C world
and rendering output against the untrimmed old source. This avoids changing
the native compiler policy or hiding a larger allocation behind raised limits.
No target execution follows a second size/admission failure.

The Author also reports6502and FSIM VDPlet applications underperforming, with
FSIM nearly2×faster using bespoke VDP functionality. Record this as an Author
observation requiring matched-path attribution, not proof of a generic runtime
penalty. This experiment isolates the road output target; later shared entry,
validation, copies and command-submission costs remain possible explanations.
