"""Offline exact-input hardware package/plan; no SD writes or autoexec."""
from pathlib import Path
import hashlib,json,shutil,zipfile
HERE=Path(__file__).resolve().parent;BASE=HERE.parent;ROOT=HERE.parents[5];OUT=HERE/'.work/package';OUT.mkdir(parents=True,exist_ok=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();jobs=[]
for v in range(4):
 for live in (0,1):
  if v==3 and not live:continue
  name=('polygons','bitmap-arithmetic','bitmap-lookup','empty')[v]+('-live' if live else '-cpu');dest=OUT/name;dest.mkdir(exist_ok=True)
  shutil.copyfile(BASE/'SPAN-001-07/.work/bin/roadbench.bin',dest/'roadbench.bin');shutil.copyfile(BASE.parents[0]/'candidates/evidence/data/fuji.road',dest/'fuji.road')
  frames=32 if v==3 else 128 if live else 1024;diag=live
  (dest/'config.txt').write_text(f'{v} {live} {diag} {frames}\n')
  directory='/test/arcade/rally/r28-road/'+name
  (OUT/(name+'.txt')).write_bytes(('EMOS LEGACY --keep-display\r\nCD '+directory+'\r\nLOAD roadbench.bin\r\nRUN .\r\n').encode())
  jobs.append({'id':name,'kind':'road','directory':directory,'binary':'roadbench.bin','variant':v,'live':live,'diagnostic':diag,'frames':frames,'timeout_seconds':600,'package':str(dest.resolve()),'inputs':{f.name:sha(f) for f in dest.iterdir()}})
for live in (0,1):
 name='polygons-sparse'+('-live' if live else '-cpu');dest=OUT/name;dest.mkdir(exist_ok=True)
 shutil.copyfile(BASE/'SPAN-001-07/.work/sparse/bin/roadbench.bin',dest/'roadbench.bin');shutil.copyfile(BASE.parents[0]/'candidates/evidence/data/fuji.road',dest/'fuji.road')
 frames=128 if live else 1024;(dest/'config.txt').write_text(f'0 {live} {live} {frames}\n');directory='/test/arcade/rally/r28-road/'+name
 (OUT/(name+'.txt')).write_bytes(('EMOS LEGACY --keep-display\r\nCD '+directory+'\r\nLOAD roadbench.bin\r\nRUN .\r\n').encode())
 jobs.append({'id':name,'kind':'road','directory':directory,'binary':'roadbench.bin','variant':0,'live':live,'diagnostic':live,'frames':frames,'timeout_seconds':600,'package':str(dest.resolve()),'inputs':{f.name:sha(f) for f in dest.iterdir()}})
dest=OUT/'physics';dest.mkdir(exist_ok=True);shutil.copyfile(HERE/'.work/physics/bin/physics.bin',dest/'physics.bin');(dest/'count.txt').write_text('2\n')
(OUT/'physics.txt').write_bytes(b'EMOS LEGACY --keep-display\r\nCD /test/arcade/rally/r28-road/physics\r\nLOAD physics.bin\r\nRUN .\r\n')
jobs.insert(0,{'id':'physics','kind':'physics','directory':'/test/arcade/rally/r28-road/physics','binary':'physics.bin','timeout_seconds':180,'package':str(dest.resolve()),'inputs':{f.name:sha(f) for f in dest.iterdir()}})
firmware=BASE/'SPAN-001-08/firmware.bin';shutil.copyfile(firmware,OUT/'vdp_rally_benchmark.bin')
manifest={'schema':1,'status':'prepared-not-deployed','hardware':'Olimex mainboard Legacy; Extender remote input','jobs':jobs,'firmware_sha256':sha(firmware),'startup_files_included':False,'source_commit':__import__('subprocess').check_output(['git','-C',str(ROOT),'rev-parse','HEAD'],text=True).strip(),'files':{str(p.relative_to(OUT)):sha(p) for p in OUT.rglob('*') if p.is_file()}}
(HERE/'PACKAGE.json').write_text(json.dumps(manifest,indent=2)+'\n')
plan={'schema':1,'ready':False,'settle_seconds':1,'bench_lock':'/requires-commissioning/rally-bench.lock','adapter':{'qualified':False,'argv':[],'inputs':{}},'runtime':{'vdp_sha256':sha(firmware),'emos_sha256':None,'extender_sha256':None},'jobs':jobs};(HERE/'PLAN.json').write_text(json.dumps(plan,indent=2)+'\n')
with zipfile.ZipFile(HERE/'PORTABLE.zip','w',compression=zipfile.ZIP_DEFLATED) as z:
 for p in sorted(OUT.rglob('*')):
  if p.is_file():z.write(p,str(p.relative_to(OUT)))
print(len(jobs),'standalone cases packaged; live plan NOT READY')
