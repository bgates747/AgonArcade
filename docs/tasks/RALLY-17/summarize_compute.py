from pathlib import Path
import gzip,json,hashlib
T=Path(__file__).resolve().parent;out=T/'compute-results'
m=json.loads((out/'manifest.json').read_text());prior=json.loads((T/'cycle-results/manifest.json').read_text())
lines=['# Computation and RAM-state results','', 'Current section renderer, normal 18.432 MHz eZ80, stock debugger CPU-cycle counts. Two 64-cycle batches per track; all runs headless.','', '| Track | Computation/state ms | Computation cycles/s | Prior combined ms | Difference ms | Computation share | 60 Hz budget used by computation |','|---|---:|---:|---:|---:|---:|---:|']
for track in ('oval','fuji'):
    rr=[r for r in m['runs'] if r['track']==track]
    pp=[r for r in prior['runs'] if r['track']==track and r['variant']=='sections' and r['mode']=='sink']
    c=sum(r['frame_ms'] for r in rr)/len(rr);p=sum(r['frame_ms'] for r in pp)/len(pp)
    lines.append(f'| {track} | {c:.2f} | {1000/c:.2f} | {p:.2f} | {p-c:.2f} | {100*c/p:.1f}% | {c/(1000/60):.2f}× |')
lines+=['', 'The computation-only path retains deterministic pose setup, one physics update, traffic movement, road section/material selection and projection, scenery heading/history, traffic sorting/visibility/projection/orientation/scaling, and player view/position calculations. Results are stored as typed RAM fields; volatile scene stores prevent unused calculations from being removed. Road projection updates its existing arrays. Frame/car counters and post-physics pose hashing remain included, as in the prior fixture.','', 'No VDP command construction, packing, text formatting or API submission occurs inside the measured loop. Startup and original rendered warmup occur before it; report-file writes and final VDP synchronization occur afterward. The shared final UART TEMT check remains but has no traffic to drain. The native proxy counted **zero measured UART bytes in all four runs**.','', 'All four runs matched prior pose hashes, frame counts and visible-car counts. Final typed scene fields (road centers/rows, scenery state, player and traffic placement) matched the sanitizer-enabled host calculation reference. The isolated Linux build passed the existing sanitizer tests and section-renderer tests. Accepted rally sources/binary and native runtime identities remained unchanged.','', 'The difference from the previous combined benchmark estimates the extra cost of command construction, API calls and UART submission/waiting together. It is **not pure wire time** or a perfectly additive profile: the computation-only path stores typed state instead of packed commands and omits command-specific work. Host reference comparison checks cross-platform numerical agreement, not an independent physics model. These fixed-input fixture rates are not displayed FPS.','', 'All code/evidence remains in RALLY-17. No game or upstream emulator edits, commits or Linux game-worktree changes were made.']
(out/'README.md').write_text('\n'.join(lines)+'\n')
for p in out.glob('*-debugger.txt'):
    with gzip.open(str(p)+'.gz','wb') as f:f.write(p.read_bytes())
    p.unlink()
(out/'task-source-hashes.json').write_text(json.dumps({p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in T.iterdir() if p.is_file()},indent=2)+'\n')
print('\n'.join(lines[:9]))
