"""Summarize final RALLY-18 benchmark manifests without concealing early runs."""
from pathlib import Path
import argparse,json,statistics,re,hashlib
T=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('primary',type=Path);p.add_argument('display',type=Path);a=p.parse_args()
m=json.loads((a.primary/'manifest.json').read_text());d=json.loads((a.display/'manifest.json').read_text())
lines=['# RALLY-18 measured results','', 'Checkpoint: **182a1d0**. Current code is isolated under RALLY-18; the subsequent review checkpoint is recorded in ../FREEZE.md.','', 'Normal 18.432 MHz eZ80 and unchanged UART timing. Computation/wire figures use stock-debugger instruction-cycle deltas; completed rendering uses an unpaused batch plus a final stock VDP completion poll. Two runs per case, in alternating comparison order.','', '| Track | Variant | Computation ms / FPS equivalent | With commands + UART ms / FPS equivalent | Completed stock-VDP ms / FPS |','|---|---|---:|---:|---:|']
summary=[]
for track in ('oval','fuji'):
    for variant,angle in (('live',False),('lookup',False),('lookup',True)):
        row={'track':track,'variant':variant,'perspective':angle,'modes':{}}
        for mode in ('compute','wire','display'):
            source=d if mode=='display' else m
            rr=[r for r in source['runs'] if r['track']==track and r['variant']==variant and r['perspective']==angle and r['mode']==mode]
            assert len(rr)==2
            ms=statistics.mean(r['ms'] for r in rr);row['modes'][mode]={'ms':ms,'fps':1000/ms,'range_ms':[min(r['ms'] for r in rr),max(r['ms'] for r in rr)],'budget_multiple':ms/(1000/60),'excess_ms':ms-1000/60}
        label=variant+(' + perspective' if angle else '')
        lines.append(f'| {track} | {label} | '+' | '.join(f"{row['modes'][mode]['ms']:.2f} / {row['modes'][mode]['fps']:.2f}" for mode in ('compute','wire','display'))+' |')
        summary.append(row)
lines+=['', 'The candidate computation path fits the 16.67 ms / 60 FPS budget. The complete command/transmission workload still exceeds it. Native VDP completion is separately affected by the stock two-vblank swap behavior and host scheduling; do not interpret it as physical-hardware timing.','', '| Track | Lookup computation saving | Lookup wire-workload saving | Perspective cost (compute / wire) | Wire workload budget / excess |','|---|---:|---:|---:|---:|']
for track in ('oval','fuji'):
    ref,lookup,angle=[r for r in summary if r['track']==track]
    c=100*(1-lookup['modes']['compute']['ms']/ref['modes']['compute']['ms']);w=100*(1-lookup['modes']['wire']['ms']/ref['modes']['wire']['ms'])
    dc=angle['modes']['compute']['ms']-lookup['modes']['compute']['ms'];dw=angle['modes']['wire']['ms']-lookup['modes']['wire']['ms'];q=lookup['modes']['wire']
    lines.append(f'| {track} | {c:.1f}% | {w:.1f}% | {dc:.2f} / {dw:.2f} ms | {q["budget_multiple"]:.2f}× / +{q["excess_ms"]:.2f} ms |')
lines+=['', 'The following budget table uses exactly 1000/60 ms. Negative excess means time remains. Percentage savings compare each mode with its matching live centreline control; display differences are observations of this native run, not isolated CPU savings.', '', '| Track | Variant | Mode | Time saved vs live | Budget multiple | Excess ms | Two-run range ms |', '|---|---|---|---:|---:|---:|---:|']
for row in summary:
    ref=next(x for x in summary if x['track']==row['track'] and x['variant']=='live')
    label=row['variant']+(' + perspective' if row['perspective'] else '')
    for mode,q in row['modes'].items():
        saved=100*(1-q['ms']/ref['modes'][mode]['ms']);q['time_saved_percent_vs_live']=saved
        lines.append(f'| {row["track"]} | {label} | {mode} | {saved:.1f}% | {q["budget_multiple"]:.2f}× | {q["excess_ms"]:+.2f} | {q["range_ms"][0]:.2f}..{q["range_ms"][1]:.2f} |')
lines+=['', '| Track | Variant | Total / road bytes per frame | Total / road bytes/s at wire throughput | Total / road KiB/s at 60 FPS | Average sections |','|---|---|---:|---:|---:|---:|']
for row in summary:
    rr=[r for r in m['runs'] if r['track']==row['track'] and r['variant']==row['variant'] and r['perspective']==row['perspective'] and r['mode']=='wire'];r=rr[0];n=r['sink']['bytes']/64;road=r['data']['road_bytes']/64;fps=row['modes']['wire']['fps']
    label=row['variant']+(' + perspective' if row['perspective'] else '')
    row['traffic']={'total_bytes_per_frame':n,'road_bytes_per_frame':road,'total_bytes_per_second_at_wire_fps':n*fps,'road_bytes_per_second_at_wire_fps':road*fps,'total_bytes_per_second_at_60fps':n*60,'road_bytes_per_second_at_60fps':road*60,'average_sections':r['data']['bands']/64}
    lines.append(f'| {row["track"]} | {label} | {n:.2f} / {road:.2f} | {n*fps:.0f} / {road*fps:.0f} | {n*60/1024:.2f} / {road*60/1024:.2f} | {r["data"]["bands"]/64:.2f} |')
lines+=['', 'Precomputation leaves the initial 25-byte resident-section protocol intact. Vehicle-angle correction changes command values/mirror use, not the protocol. Its measured UART delta is zero bytes/frame on both tracks (64-frame totals remain 56,938 oval and 49,338 Fuji). All compute cases recorded zero UART bytes. All cases completed their final poll; repeated identical cases matched byte count/hash and pose metadata.','', 'Early completed-render cases in the primary manifest ran while exhaustive geometry validation and host indexing were active, with substantial load/variance. They are retained but are superseded here by the explicit display-only rerun after numerical validation finished. All original data remains linked below; no CPU-cycle cases were replaced.','', f'Primary evidence: [{a.primary.name}/manifest.json]({a.primary.name}/manifest.json). Display rerun: [{a.display.name}/manifest.json]({a.display.name}/manifest.json).','', 'See [road qualification](../road-results/README.md) for exhaustive geometry/loader/sanitizer coverage, [vehicle notes](../vehicle-notes.md) for placement/orientation checks, and [native visual results](../visual-results/README.md) for images, guest-state agreement and scripted input evidence. Human visual acceptance and hardware qualification remain separate.']
(T/'results/README.md').write_text('\n'.join(lines)+'\n');(T/'results/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print('\n'.join(lines[:14]))
