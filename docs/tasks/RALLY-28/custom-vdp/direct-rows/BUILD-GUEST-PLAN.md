# ROW-001 common guest build

One serial AgonDev compile/link of the isolated common synchronous bitmap/rows guest, following Author-selected ROW-001 task0715d5f and VDPlet guidance01. Only shared startup adds actual mode-reply/geometry and capability admission before LOAD. No async transport or scheduler change. Preserve existing gameplay/presentation/900-frame work.

Expected under30seconds, under512MiB,180second subprocess timeout; one compiler child at a time. Check Pi temperature below80C before launch. On compile failure retain logs and correct only build errors before a new attempt; no target launch. Release after children join and fixture preparation completes. No emulator, firmware build, remote or physical operations in this build reservation.
