"""Analyze only retrieved, independently audited native-state campaign results."""
from pathlib import Path
import hashlib,json,statistics,zipfile,csv
HERE=Path(__file__).resolve().parent


def main():
 evidence=HERE/'evidence/native01';rows={};pooled={}
 campaign=json.loads((HERE/'CAMPAIGN-native01.json').read_text());assert len(campaign)==9 and all(x['audit']['passed'] for x in campaign.values())
 for name in ['baseline900a','state900a','coarse900a','coarse900b','state900b','baseline900b']:
  d=evidence/name;a=json.loads((d/'audit.json').read_text());r=json.loads((d/'result.json').read_text())
  assert a['passed'] and r['frames']==900
  rows[name]={'mos_fps':a['nominal_mos_fps'],'prt_fps':a['nominal_prt_fps'],'mos_ticks':r['elapsed_mos_ticks'],'prt_ticks':r['prt_ticks'],'state_sha256':a['state_sha256'],'wire_bytes':r['timed_wire_bytes'],'stack_before':r['stack_before'],'stack_after':r['stack_after'],'host_process_seconds':json.loads((d/'run.json').read_text())['host_seconds'],'phase_totals_prt_ms':{k:int(v) for k,v in next(csv.DictReader((d/'stages.csv').read_text().splitlines())).items()}}
 for arm in ['baseline','state','coarse']:
  runs=[rows[arm+'900'+x] for x in 'ab'];pooled[arm]={'prt_fps':1800000/sum(x['prt_ticks'] for x in runs),'mos_fps':216000/sum(x['mos_ticks'] for x in runs),'prt_frame_ms':sum(x['prt_ticks'] for x in runs)/1800,'timed_wire_bytes':runs[0]['wire_bytes']}
 base=pooled['baseline']['prt_fps']
 for arm in pooled:pooled[arm]['prt_gain_percent']=100*(pooled[arm]['prt_fps']/base-1)
 selected=max(['state','coarse'],key=lambda a:pooled[a]['prt_fps'])
 report={'passed':True,'scope':'nine first-failure processes, no retries','full_runs':rows,'pooled':pooled,'selected_candidate':selected,'host_checks':json.loads((HERE/'HOST-ordinary.json').read_text()),'clock_limit':'Uncalibrated emulator clocks. No physical FPS or speedup claim.','runtime':'a50/7e7d/plain086, frozen correctedSDK10947e0','hardware_deployed':False,'hardware_flashed':False,'emulator_performance_winner':'baseline','emulator_gain_demonstrated':False,'phase_limit':'Buckets overlap and include native/transport/presentation; no exclusive processor attribution.'}
 (HERE/'REPORT.json').write_text(json.dumps(report,indent=2)+'\n')
 kit=HERE/'hardware-kit';p=kit/'README.txt';s=p.read_text();s=s.replace('LOCAL PREPARATION: Oryx target qualification pending; do not infer a pass.','All nine silent Oryx cases passed exact state/wire/completion/cleanup checks.\nEmulator clocks are uncalibrated; Console8 and Author visual truth remain open.\nPrimary new candidate for comparison: '+selected+'. No emulator FPS gain was found.')
 s=s.replace('Preliminary best candidate: '+selected+'.','Primary new candidate for comparison: '+selected+'. No emulator FPS gain was found.')
 p.write_text(s)
 pins={str(p.relative_to(kit)):hashlib.sha256(p.read_bytes()).hexdigest() for p in kit.rglob('*') if p.is_file() and p.name!='SHA256SUMS'}
 (kit/'SHA256SUMS').write_text(''.join(v+'  '+n+'\n' for n,v in sorted(pins.items())))
 with zipfile.ZipFile(HERE/'HARDWARE-KIT.zip','w',zipfile.ZIP_DEFLATED,compresslevel=1) as z:
  for p in sorted(kit.rglob('*')):
   if p.is_file():z.write(p,str(p.relative_to(kit)))
 (HERE/'HARDWARE-KIT.json').write_text(json.dumps({'deployed':False,'flashed':False,'target_qualified':True,'candidate':selected,'files':pins,'zip_sha256':hashlib.sha256((HERE/'HARDWARE-KIT.zip').read_bytes()).hexdigest()},indent=2)+'\n')
 print(json.dumps(pooled,indent=2));print('Selected preliminary candidate:',selected)

if __name__=='__main__':main()
