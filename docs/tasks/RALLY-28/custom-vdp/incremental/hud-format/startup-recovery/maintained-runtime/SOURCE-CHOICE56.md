# Old200f versus maintained086: source choice before more instrumentation

Executive summary: prefer ONE separately prepared current086 qualification of
the frozen failing Rally fixture before investing in old200f instrumentation.
The change is small and understood, and086 has an accepted exact build closure.
However, NONE of its identified corrections directly repairs the sampled CTS
refusal. A success would qualify a new cohort, not explain or repair old74.
No backend switch, build or run is selected by this source-only recommendation.

1. **Concrete retained old artifacts found.** FX017 final-fix-evidence contains
   baseline.so exactly200f28cb and its baseline-core.a d405901f. Compared to
   maintained core93af5e66, both archives have59members;58 are BYTE-IDENTICAL.
   Only peripherals.c.o differs (84e1ef79 ->7aada3a9). ELF function-body byte
   comparison finds all20UART-named functions identical; the only differing
   peripheral function bodies are i2s_process_tx_descriptor, i2s_seed_ring,
   i2s_refresh_active. Recorded FX017 source diff is the I2S EOF latching change.
   This is stronger than assuming same vendor pin, but it is NOT a fresh
   byte-identical200f rebuild or proof of its entire producer/toolchain closure.
2. **Source/bridge chain.** Retained adapterce5dc901 (git25fb3f6/bbd0343;
   independently reproduced with fixed core as108ec5b in FX072) differs from
   maintained5b07 in ONLY added clock.h/include, overflow-safe target conversion
   and the six-line classic ISYNC range override. ULP/PS2.c/.h source hashes are
   identical. FX017 deployment receipt explicitly records200f ->108ec for the
   EOF-only correction; FX072 baseline108ec ->f7e5 for ISYNC, then maintained
   source/pacing produces086. Existing exact086 reproduction remains separate
   from unreplayed200f producer history. Offline comparison evidence is under
   build/fx114/rally74-review/{old-core-comparison,uart-function-comparison,
   bridge-comparison}.json and old-adapter-to-maintained.patch.

| Maintained difference | Qualified scope | Relevance to current stall |
| --- | --- | --- |
| I2S EOF descriptor/buffer registers latch only on EOF descriptor | FX017 regression/human judder correction | Changes I2S refill/interrupt behavior; could affect scheduling indirectly, but no UART recovery/gate repair is shown |
| Classic ISYNC shadow expands40080000..400AA000 to40070000..400C0000 | FX072 range checks and eight CPU/lifecycle cells in both engines | Corrects uploaded-code coherence; stall is ordinary payload before Init, so no direct receive fix established |
| Overflow-safe cycle->ns pacing conversion | FX046 arithmetic/pacing evidence, included in086 | First old multiply overflow at18,446,744,074cycles (~76.861nominal guest seconds); cached74 final9,176,660,911cycles is BELOW it, so that overflow is not active in this saved witness |

3. **No maintained UART delta identified.** Old200f actual CTS disassembly and
   retained source use ready&&!failed&&(hostqueue+publishedpending<128), unchanged
   in086.20UART function bodies match; no timeout/IRQ/read-recovery repair is
   inserted by these maintained changes. Do NOT advertise086 as the fix for
   FX006 or this failure. Old FX031 timeout modeling was already in this line,
   not a new200f->086 repair. Changed I2S execution/IRQ timing could alter
   reproducibility; source similarity or nonreproduction cannot locate cause.
4. **Clock question remains separate.** Frontend7e7d is unchanged by the
   backend transition. Its native-frame-change GPIO/MOS gate remains;086 does
   not port FX032 or calibrate MOS/PRT. A current-runtime qualification cannot
   validate60FPS or choose a denominator merely because startup succeeds.
5. **Proportionate proposed next preparation.** Preserve old74/71062298/200f/
   firmware8da2/guest/streams/clocks and existing65file audit. Freeze a NEW
   stopped profile using exact plain maintained086 (NOT audio943f/0f4b), same
   frontend7e7d/sender12817411, original failed cached fixture/history/firmware/
   ELF/MOS/assets/native code and finite guards. Declare only backend identity,
   fresh output/profile/guard-admission differences. Prepare one process with
   original complete functional/cleanup checks, no ABBA successors, automatic
   retry or gain comparison. If later selected and successful, say only that
   the NEW supported-runtime cohort qualified; do not rewrite the old stasis.
   No such profile or test is prepared/launched by this review.
6. **When old diagnostic remains worthwhile.** If the explicit goal becomes
   explaining the exact old74 event or making an upstream claim about it,
   reconstruct/reproduce200f and collect last-decision operands on that line.
   If the supported086 cohort still stalls, prefer the same minimal decision
   discriminator on already source-closed086 rather than paying for obsolete
   producer reconstruction first. Either preparation/target needs a separately
   selected contract. No expensive broad core audit/build/test or switch is
   selected now. Wolf results remain separate. Next free local ID134 unchanged.
