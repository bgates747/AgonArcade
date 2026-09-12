# Memory and loading budget

The canonical eZ80 linker gives this application 448 KiB (0x40000..0xB0000). Link maps and binaries are retained with benchmark evidence. Image+BSS includes code, embedded assets, globals, road state, timing records and command buffers.

| Variant | Track | Binary bytes | Image+BSS | Resident table | Remaining heap+stack | After 32 KiB stack reserve |
|---|---|---:|---:|---:|---:|---:|
| live | either | 139563 | 192842 | 0 | 265910 | 233142 |
| lookup | oval | 142838 | 196129 | 20520 | 242103 | 209335 |
| lookup | fuji | 142838 | 196129 | 116736 | 145887 | 113119 |

The stack reserve is a budget, not a measured high-water mark. Remaining space also serves libc/file allocations and transient stack frames; it is not all available for another table. The loader has a 64-byte header and one payload allocation, with no second decompression copy. Whole-scene snapshots, both-track benchmark loading and sanitizer checks passed.

| Track | External disk bytes | Observed load+identity/checksum ticks (120Hz) | Approx seconds |
|---|---:|---:|---:|
| oval | 20584 | 56..168 | 0.47..1.40 |
| fuji | 116800 | 264..632 | 2.20..5.27 |

Loading/checksum validation occurs before VDP asset setup and every measured batch. The profile contains both files (137,384 bytes total on disk); only the selected track is resident.

Additional VDP RAM for the road lookup and bearing tables: **0 bytes**. Both are eZ80-resident. Existing logical 8-bit bitmap payload remains 35 car bitmaps × 102 × 77 plus 1024 × 104 scenery = 381,386 bytes, along with the same resident section programs, transform/traffic matrices and transient output buffer as the control. This is logical payload accounting, not a measurement of firmware allocator overhead or native host GPU RAM. There are no new VDP buffers/bitmaps in the candidate.

The resident two-pattern startup command stream remains 864 bytes. Each road section update/call remains 25 UART bytes. See road-results/README.md for maximum section/stream sizes and results/README.md for measured traffic.
