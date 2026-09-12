"""Recompute the complete frozen scene comparison for the stack-fix candidate."""
from pathlib import Path
import csv,hashlib,json
from profile import TASK
from fixtures import cases as frozen_cases
from native_run import sha
from scene_masks import game_image,masks
from visual_metric import compare,road_geometry,calibrate

def main():
 assert all(calibrate().values())
 work=TASK/'.work/production/inline-b'
 required={c['name'] for c in frozen_cases()};seen=set();results=[];evidence={}
 def record(p):evidence[str(p.relative_to(TASK))]=sha(p);return p
 for track,total in [('oval',24),('fuji',42)]:
  for offset in range(0,total,8):
   name='hardware-inline-'+track+(f'-{offset}' if offset else '')
   root=TASK/'evidence/golem-scenery-visual'/name
   inputs=json.loads(record(root/'inputs.json').read_text());assert inputs['track']==track
   cases=inputs['cases'];assert len(cases)==min(8,total-offset)
   for path,digest in inputs['source_hashes'].items():assert sha(Path(path))==digest,path
   manifests={v:json.loads(record(root/v/'manifest.json').read_text()) for v in ['oracle','candidate']}
   for v,m in manifests.items():
    assert m['headless'] and m['runtime_inputs_unchanged'] and not m['timed_out']
    assert record(root/v/'guest-exit.viz').read_text().strip()=='0'
    assert len(m['captures'])==len(cases)
   binaries=[v for p,v in manifests['candidate']['runtime_before'].items() if p.endswith('/program.bin')]
   assert len(binaries)==1 and binaries[0]['sha256']==sha(work/(track+'.vdp'))
   for i,case in enumerate(cases):
    name=case['name'];assert name in required and name not in seen;seen.add(name)
    pair=[]
    for variant,m in manifests.items():
     capture=m['captures'][i];ip=record(root/variant/capture['file']);assert sha(ip)==capture['sha256']
     sp=record(root/variant/f'guest-scene-{i:02d}.csv')
     pair.append((game_image(ip),masks(sp,ip),list(csv.reader(sp.read_text().splitlines()))))
    (ei,em,er),(ai,am,ar)=pair
    frozen=TASK/'evidence/oracle'/name
    assert (frozen/'verified.json').is_file(),name
    fi=record(frozen/'frame-000010.png');fs=record(frozen/'guest-scene.csv')
    assert compare(game_image(fi),ei,masks(fs,fi),em)['pass'],(name,'frozen oracle bridge')
    pixels=compare(ei,ai,em,am)
    rows=lambda data,kind:[r for r in data if r[0]==kind]
    geometry=road_geometry([list(map(int,r[1:3])) for r in rows(er,'R')],[list(map(int,r[1:3])) for r in rows(ar,'R')])
    assert er[0]==ar[0] and rows(er,'C')==rows(ar,'C') and geometry['pass'] and pixels['pass'],name
    results.append({'case':name,'track':track,'geometry':geometry,'pixels':pixels})
 assert seen==required
 destination=TASK/'evidence/hardware-production/inline-candidate/frozen-qualification.json'
 assert not destination.exists()
 report={'pass':True,'frozen_cases':len(seen),'scope':__doc__,'candidate_bootstraps':{t:sha(work/(t+'.vdp')) for t in ['oval','fuji']},'results':results,'evidence':evidence,'qualifier_sha256':sha(Path(__file__)),'hardware':'Separate physical stock-stack and official-release test required.'}
 destination.write_text(json.dumps(report,indent=2)+'\n');print('PASS: all',len(seen),'frozen scene comparisons recomputed.')
if __name__=='__main__':main()
