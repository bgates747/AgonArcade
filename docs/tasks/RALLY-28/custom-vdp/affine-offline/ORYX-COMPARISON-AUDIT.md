# Independent Pi5 and Oryx affine comparison

Identical source and artwork pass cross-architecture pixel/checksum checks. All128 case/operation groups,640 trial rows and16 geometry checks agree. The isolated target fixtures also use identical guest inputs and identical110,240-byte application command streams; each passes124 batches and497 ordered completion/readback events.

| Target measurement | Pi5 Flexe | Oryx Flexe |
| --- | ---: | ---: |
| Raw PRT count total | 72,880 | 39,309 |
| Raw MOS units total | 1,944 | 1,958 |
| Nominal PRT/MOS ratio | 4.49877 | 2.40913 |
| Zero-MOS-delta batches | 13 | 10 |
| Whole-run host seconds | 83.086 | 49.168 |

The two emulator clocks remain separately reported. These count comparisons establish no physical VDP milliseconds or game FPS. Whole-run host seconds include startup/loading/warm operations/readback/file output/cleanup. Detailed raw per-method counts and native host CPU times remain separate in ORYX-COMPARISON-AUDIT.json.

| Host case | Pi cached affine µs | Oryx cached affine µs | Oryx/Pi CPU time |
| --- | ---: | ---: | ---: |
| traffic-far | 0.2338 | 0.1548 | 0.6621 |
| traffic-middle | 6.2534 | 3.5560 | 0.5686 |
| traffic-near | 62.2581 | 38.5223 | 0.6188 |
| sign-far | 0.7808 | 0.5160 | 0.6609 |
| sign-middle | 4.8553 | 3.0096 | 0.6199 |
| sign-near | 4.2127 | 2.5776 | 0.6119 |
| player-fixed | 63.7642 | 40.1048 | 0.6290 |
| player-fixed-mirror | 63.6251 | 38.8814 | 0.6111 |
| traffic-fullsize | 70.0439 | 42.7561 | 0.6104 |
| sign-fullsize | 43.1010 | 27.3885 | 0.6354 |
| traffic-clipped-left | 4.2835 | 2.3688 | 0.5530 |
| traffic-clipped-right | 1.7497 | 0.9747 | 0.5571 |
| traffic-clipped-top | 3.9324 | 2.2219 | 0.5650 |
| traffic-clipped-bottom | 2.0012 | 1.1533 | 0.5763 |
| synthetic-all-opaque | 7.6524 | 5.1722 | 0.6759 |
| synthetic-all-transparent | 5.3206 | 2.9493 | 0.5543 |

Host times execute the same extracted code on two different processors. Compiler versions and all raw samples are preserved. This audit neither changes old Pi results nor adopts a new renderer. No emulator, compiler or network action is performed by this comparison tool.
