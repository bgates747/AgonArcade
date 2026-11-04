"""Offline exercise of exact staging, changed-sector composition and no-replay guards."""
import importlib.util,json,tempfile,types,hashlib
from pathlib import Path
HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('rallyphysical',HERE/'physical.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
inv=json.loads((HERE/'INVENTORY.json').read_text());checks=[]
for n,h in inv['files'].items():assert m.sha((HERE.parent/n).read_bytes())==h
checks.append('31 exact fixture and firmware hashes')
with tempfile.TemporaryDirectory(prefix='rally-olimex-preflight-')as tmp:
 b=object.__new__(m.Bench);b.out=Path(tmp);b.remote='/test/arcade/rally/native01-olimex01';b.package=HERE.parent/'hardware-kit';b.inventory=inv
 store={};operations=[]
 class Meta:
  lock=types.SimpleNamespace(close=lambda:None)
  def make_directory(self,*a,**kw):operations.append(('mkdir',a[0]))
 b.metadata=lambda *a:Meta();b.exit=lambda *a:operations.append(('exit',None));b.own=lambda:None
 def transfer(folder,label,op,remote,local):
  assert remote.startswith(b.remote+'/')and 'autoexec'not in remote
  operations.append((op,remote))
  if op=='put':assert remote not in store;store[remote]=Path(local).read_bytes()
  else:Path(local).write_bytes(store[remote])
 b.transfer=transfer;b.stage()
 assert len([op for op in operations if op[0]=='get'])==60
 for case in inv['order']:
  data=store[b.remote+'/'+case+'/invoke.txt'].decode();assert data.count('RUN .')==1 and 'RESET'not in data.upper()
  assert data.endswith('EMOS sdserve --fast /\n')
  assert '/'+case+'/current-mode.bin &BC349 &1' in store[b.remote+'/'+case+'/verify-mode.txt'].decode()
 checks.append('six isolated exact-file staged/readback flows and explicit CLI scripts; no startup writes')
 # Exercise real backup/install/restore composition with local retained bytes and stubbed esptool.
 original=Path('/Agon/mystuff/agon-6502/build/cpu003/olimex-physical-flags-r01/restore/full.bin').read_bytes()
 assert m.sha(original)=='17caa5b0b2ede84bb627e207f10994b13dd3abfa2d04fc807ec393414fe33378'
 b.c={'firmware':str(b.package/'vdp_rally.bin')};b.port='/nonexistent-offline-only';b.get=lambda path:{'online':False,'phase':0}
 realrun=m.subprocess.run;current=original
 def run(argv,**kw):
  global current
  if argv[0]=='fuser':return types.SimpleNamespace(returncode=1,stdout=b'')
  assert '--baud'in argv and argv[argv.index('--baud')+1]=='115200'
  if 'read-flash'in argv:Path(argv[-1]).write_bytes(current)
  elif 'write-flash'in argv:
   assert argv[-2]=='0x150000';data=Path(argv[-1]).read_bytes();current=current[:0x150000]+data+current[0x150000+len(data):]
  else:raise AssertionError(argv)
  return types.SimpleNamespace(returncode=0)
 m.subprocess.run=run
 try:
  b.flash('backup');b.flash('install');assert current!=original
  assert current[:0x150000]==original[:0x150000]and current[0x150000+1097728:]==original[0x150000+1097728:]
  b.flash('restore');assert current==original
  try:b.flash('restore')
  except FileExistsError:checks.append('repeated action refused before second firmware write')
  else:raise AssertionError('Consumed action replayed')
 finally:m.subprocess.run=realrun
 checks.append('actual partition parser, sector-tail preservation, entire-image comparison and exact restoration offline')
print(json.dumps(dict(passed=True,device_access=False,checks=checks),indent=2))
