"""Prepare a fresh guarded Flexe timing profile; no graphical launches."""
from pathlib import Path
import argparse,importlib.util,json,hashlib,shutil
ROOT=Path(__file__).resolve().parents[4]
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def prepare(name,binary,firmware,elf,engine="jit"):
    helper=ROOT/'docs/tasks/RALLY-27/flexe_review.py'
    spec=importlib.util.spec_from_file_location('review',helper);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    p=m.prepare(name,binary,'fuji')
    for source,name in [(firmware,'esp32-firmware.bin'),(elf,'esp32-firmware.elf')]:shutil.copyfile(source,p/name)
    launch=p/'flexe-agon-emulator';launch.write_text(launch.read_text().replace('AGON_FLEXE_ENGINE="jit"','AGON_FLEXE_ENGINE="'+engine+'"'))
    ids=json.loads((p/'identity.json').read_text())
    for name in ids:ids[name]=digest(p/name)
    (p/'identity.json').write_text(json.dumps(ids,indent=2)+'\n')
    (p/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in ids.items()))
    (p/'sdcard/rally/identity.json').write_text(json.dumps(ids,indent=2)+'\n')
    print(p)
if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--engine',choices=['jit','interp'],default='jit');a.add_argument('--name',required=True);a.add_argument('--binary',type=Path,required=True);a.add_argument('--firmware',type=Path,required=True);a.add_argument('--elf',type=Path,required=True);args=a.parse_args();prepare(args.name,args.binary,args.firmware,args.elf,args.engine)
