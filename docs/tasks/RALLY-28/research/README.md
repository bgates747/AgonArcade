# RALLY-28 — research

Shared RALLY-28 research: hot-loop arithmetic review, algorithm/library findings, reusable references and measurement methodology.

Scope and stable subtask IDs are defined in [the parent task](../../RALLY-28.md); [root TODO](../../../../TODO.md) is the authoritative register. This directory has no separate task list. Keep local build/trace artifacts under ignored `.work/`. No game implementation has started.

MATH-001-01 is complete: [hot-loop review](HOT-LOOP-REVIEW.md), [static compiler/source receipt](AUDIT.json), and [reproduction tool](audit_hot_loop.py). Both unchanged-source inspection objects match their preserved standard/native eZ80 objects byte for byte. Counts identify software arithmetic and repeated work, not measured cycle costs or a demonstrated speedup. The next research item is intermediate bounds/rounding under MATH-001-02; standard implementation remains separately scoped.
