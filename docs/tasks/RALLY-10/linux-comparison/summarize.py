"""Generate a matched Mac/Linux summary from the preserved replay manifest."""
from pathlib import Path
import json,statistics
ROOT=Path(__file__).resolve().parent
m=json.loads((ROOT/'results/manifest.json').read_text())
groups={}
for r in m['runs']:
 parts=r['mac_case'].split('-')
 case='-'.join(parts[1:]) if r['suite'] in ('controlled','reflection') else parts[0]+'/'+parts[-1]
 groups.setdefault((r['suite'],case),[]).append(r)
lines=['| Suite / case | Mac ms/frame | Linux ms/frame | Linux time change | Mac / Linux equivalent FPS | Linux batch ticks (runs) |','| --- | ---: | ---: | ---: | ---: | --- |']
stages=['| Suite / case | Mac / Linux geometry ms | Mac / Linux bands ms | Mac / Linux submission ms | Mac / Linux fence ms |','| --- | ---: | ---: | ---: | ---: |']
for (suite,case),runs in groups.items():
 def ms(key): return statistics.mean((r[key]['run_ticks']+r[key]['drain_ticks'])/r[key]['submitted']*1000/120 for r in runs)
 mac,linux=ms('mac_metadata'),ms('metadata')
 lines.append(f'| {suite} / {case} | {mac:.2f} | {linux:.2f} | {(linux/mac-1)*100:+.1f}% | {1000/mac:.2f} / {1000/linux:.2f} | '+', '.join(str(r['metadata']['run_ticks']+r['metadata']['drain_ticks']) for r in runs)+' |')
 pairs=[]
 for stage in ('geometry','bands','submit','fence'):
  def mean(key):
   vals=[r[key][stage]*1000/120 for r in runs if stage in r[key]]
   return f'{statistics.mean(vals):.2f}' if vals else '—'
  pairs.append(mean('mac_mean_ticks')+' / '+mean('mean_ticks'))
 stages.append('| '+suite+' / '+case+' | '+' | '.join(pairs)+' |')
(ROOT/'results/table.md').write_text('\n'.join(lines)+'\n\n'+'\n'.join(stages)+'\n')
print('\n'.join(lines))
print('runs',len(m['runs']),'frames',sum(r['metadata']['submitted'] for r in m['runs']),'acks',sum(r['metadata']['acknowledged'] for r in m['runs']))
print('load range',min(r['load_before'][0] for r in m['runs']),max(r['load_after'][0] for r in m['runs']))
