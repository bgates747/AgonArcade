# Exact row-phase lookup

All960000combinations of8000phases and120rows match the independent original division/remainder formula under ASan/UBSan. Rows104–115remain unpainted; rows116–223use a resident16bit depth-modulo8000table. The changing sum is at most15998; one conditional subtraction and comparison replace recurring division and wide remainder.

`phase.s` is ordinary same-target/Oz compiler assembly. Lookup uses native-width addressing/shift helper and comparisons, with no32bit arithmetic/division/remainder helper. The original comparison function retains24bit division and32bit addition/remainder/comparison. inspect.cpp/verify.cpp preserve the probes. Host command: compile verify.cpp with `c++ -std=c++17 -O2 -fsanitize=address,undefined`, then run it. This proves all valid phases in the declared120rowdomain, not arbitrary out-of-range phases or changed camera parameters.

The new finite benchmark retains original and lookup arithmetic as separate runtime-selected candidates with identical outgoing bitmap records. The visual demo/current game and all old fixtures are preserved. Measured packing times and full pipeline interpretation are recorded in the parent results, not inferred from instruction counts.
