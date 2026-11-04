"""Report matched Olimex FPS from retained per-case guest validation."""
from pathlib import Path
import json,csv,statistics
HERE=Path(__file__).resolve().parent
order=json.loads((HERE/'INVENTORY.json').read_text())['order'];rows=[]
for case in order:
 p=HERE/'evidence'/('returned-'+case)
 x=json.loads((p/'verified.json').read_text());phase=next(csv.DictReader((p/'stages.csv').read_text().splitlines()))
 rows.append(dict(case=case,arm=case[:-1],frames=x['frames'],mos_seconds=x['nominal_mos_seconds'],prt_seconds=x['nominal_prt_seconds'],mos_fps=x['nominal_mos_fps'],prt_fps=x['nominal_prt_fps'],state_sha256=x['state_sha256'],retained_replies=x['retained_replies'],timed_wire_bytes=x['timed_wire_bytes'],phases={k:int(v) for k,v in phase.items()},raw_file_sha256=x['raw_file_sha256']))
assert len({r['state_sha256']for r in rows})==1
pooled={}
for arm in ('baseline','state','coarse'):
 group=[r for r in rows if r['arm']==arm];frames=sum(r['frames']for r in group)
 pooled[arm]=dict(n=len(group),mos_fps=frames/sum(r['mos_seconds']for r in group),prt_fps=frames/sum(r['prt_seconds']for r in group),prt_ms_per_frame=1000*sum(r['prt_seconds']for r in group)/frames,repeat_prt_fps_range=[min(r['prt_fps']for r in group),max(r['prt_fps']for r in group)])
for arm in pooled:pooled[arm]['prt_fps_percent_vs_baseline']=100*(pooled[arm]['prt_fps']/pooled['baseline']['prt_fps']-1)
report=dict(passed=True,board='Olimex AgonLight2',fixture_bytes_unchanged=True,rows=rows,pooled=pooled,clock_limit='MOS120 units/sec and PRT1000 units/sec nominal. On-device counters; agreement is reported, no scanout/optical/calibration claim. Do not pool with Oryx or Console8.',sound='Enabled, unassessed',scope='Full race 900 rendered frames,3600 logical steps,two warm frames; fixed four physics steps/render comparison, not independent real-time scheduler. Printer mirror instrumentation enabled.')
(HERE/'REPORT.json').write_text(json.dumps(report,indent=2)+'\n')
lines=['# Olimex matched native-state results','','All six exact fixtures passed guest validation. Native firmware was temporary; see physical handback/restoration evidence.','','| Arm | MOS FPS | PRT FPS | PRT ms/frame | PRT FPS vs baseline |','|---|---:|---:|---:|---:|']
for arm,x in pooled.items():lines.append(f"| {arm} | {x['mos_fps']:.2f} | {x['prt_fps']:.2f} | {x['prt_ms_per_frame']:.3f} | {x['prt_fps_percent_vs_baseline']:+.2f}% |")
lines+=['',report['clock_limit'],'',report['scope'],'','Sound remains enabled and unassessed. Counters do not grant human visual acceptance.','', '| Case | MOS seconds | PRT seconds | MOS FPS | PRT FPS |','|---|---:|---:|---:|---:|']
for r in rows:lines.append(f"| {r['case']} | {r['mos_seconds']:.3f} | {r['prt_seconds']:.3f} | {r['mos_fps']:.2f} | {r['prt_fps']:.2f} |")
(HERE/'RESULTS.md').write_text('\n'.join(lines)+'\n');print(json.dumps(pooled,indent=2))
