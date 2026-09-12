"""Summarize emulated-cycle evidence, retaining original logs compressed."""
from pathlib import Path
import gzip,hashlib,json
T=Path(__file__).resolve().parent
m=json.loads((T/'cycle-results/manifest.json').read_text())
lines=['# RALLY-17 results','', 'Normal 18.432 MHz eZ80 execution; unchanged UART FIFO and baud timing.', 'The sink discards bytes only at the VDP receive boundary and keeps CTS ready.', 'Each cycle includes fixed-pose setup, one physics update, traffic update, complete scene command generation, transmission and fixture bookkeeping. These are **cycles per second, not displayed FPS**.','', 'Primary measurements use the stock emulator debugger cycle counter between existing batch boundary instructions. The 64-cycle batch ends after UART TEMT. No per-frame pacing or completion waits. Breakpoint pause time is excluded from cycle counts; debugger-run MOS wall ticks are not used.','', '| Renderer | Track | ms/cycle (two sink runs) | Cycles/s | 60 Hz budget used |','|---|---|---:|---:|---:|']
for variant in ('full','pavement','sections'):
    for track in ('oval','fuji'):
        rr=[r for r in m['runs'] if r['variant']==variant and r['track']==track and r['mode']=='sink']
        ms=sum(r['frame_ms'] for r in rr)/len(rr)
        lines.append(f'| {variant} | {track} | '+', '.join(f"{r['frame_ms']:.2f}" for r in rr)+f' | {1000/ms:.2f} | {ms/(1000/60):.2f}× |')
lines+=['','All three runs per renderer/track (one passthrough, two sink) matched transmitted byte count and FNV-1a64 hash, road bytes, cars and post-physics pose hash. Every final stock poll completed. All runs were headless, with no unlimited CPU flag. Mainline fingerprints passed before and after. Linux scratch builds passed the existing sanitizer tests and applicable renderer tests. Proxy unit checks cover CTS, exact accounting and delivery restoration; the canonical launcher rejected a missing module without fallback.','', 'Unpaused wall-clock runs are retained in ../results; their variance motivated instruction-cycle measurement. CPU cycles still include MOS interrupt service and UART transmission waits. This establishes CPU-plus-wire cost with an uncongested receiver, not pure arithmetic cost, physical-hardware FPS or VDP rendering performance. Passthrough results retain host VDP behavior/backpressure and are primarily an equal-output control.','', 'No game or upstream emulator changes were made. All implementation, profiles and evidence are inside this task bucket. Nothing has been committed.']
(T/'cycle-results/README.md').write_text('\n'.join(lines)+'\n')
for p in (T/'cycle-results').glob('*-debugger.txt'):
    with gzip.open(str(p)+'.gz','wb') as f:f.write(p.read_bytes())
    p.unlink()
for v in m['variants']:
    for suffix in ('.map','-disasm.txt'):
        p=T/'.work'/(v+suffix);(T/'cycle-results'/p.name).write_bytes(p.read_bytes())
identity={str(p.relative_to(T)):hashlib.sha256(p.read_bytes()).hexdigest() for p in T.iterdir() if p.is_file()}
(T/'cycle-results/task-source-hashes.json').write_text(json.dumps(identity,indent=2)+'\n')
print('\n'.join(lines))
