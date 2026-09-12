from pathlib import Path
import json,statistics
root=Path(__file__).resolve().parent
unlimited=json.loads((root/'results-unlimited/manifest.json').read_text())
capped={r['case']:r for r in json.loads((root/'results/manifest.json').read_text())['runs']}
groups={}
for r in unlimited['runs']:
 p=r['mac_case'].split('-')
 case='-'.join(p[1:]) if r['suite'] in ('controlled','reflection') else p[0]+'/'+p[-1]
 groups.setdefault((r['suite'],case),[]).append(r)
lines=['| Suite / case | Mac capped FPS-equiv. | Linux capped FPS-equiv. | Linux unlimited FPS-equiv. | Unlimited ms/frame | Speedup vs Linux capped |','| --- | ---: | ---: | ---: | ---: | ---: |']
for (suite,case),runs in groups.items():
 def seconds(m): return (m['run_ticks']+m['drain_ticks'])/120/m['submitted']
 mac=statistics.mean(seconds(r['mac_metadata']) for r in runs)
 cap=statistics.mean(seconds(capped[r['case']]['metadata']) for r in runs)
 uncap=statistics.mean(seconds(r['metadata']) for r in runs)
 lines.append(f'| {suite} / {case} | {1/mac:.2f} | {1/cap:.2f} | {1/uncap:.2f} | {uncap*1000:.2f} | {cap/uncap:.2f}× |')
(root/'results-unlimited/table.md').write_text('\n'.join(lines)+'\n')
print('\n'.join(lines))
print('Runs:',len(unlimited['runs']),'Frames:',sum(r['metadata']['submitted'] for r in unlimited['runs']),'Acknowledged:',sum(r['metadata']['acknowledged'] for r in unlimited['runs']))
