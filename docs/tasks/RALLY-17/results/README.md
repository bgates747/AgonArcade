# Unpaused wall-clock runs

These 18 preliminary headless runs demonstrate identical transmitted payloads
between normal-delivery and sink modes, but wall times varied substantially.
Use [the stock-debugger cycle results](../cycle-results/README.md) for the
CPU-plus-UART cost. The emulator's instruction timing remains unchanged.

CSV compatibility names: `submit_ticks` is the measured batch including final
UART TEMT drain. `total_ticks` is the same interval. `drain_ticks` is outside
measurement and includes the stop handshake plus final VDP poll; it is not a
pure VDP rendering measurement. There are 120 MOS ticks per second. The cycle
results retain these CSV fields as diagnostic evidence, but debugger pauses
make those runs' wall ticks unsuitable for performance calculations.

Source and runtime identities, per-run output counts/hashes and normal CPU
process flags are retained in manifest.json. Linux build logs include tests.
The missing-module test confirms that the canonical launcher refuses fallback.
