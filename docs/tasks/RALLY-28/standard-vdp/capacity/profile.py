"""Prepare a fresh stopped stock-Flexe actual-physics measurement profile."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4];PROBE=HERE.parent/'completion-probe'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def prepare(name,rounds,kind="capacity"):
    assert kind in ("capacity","wirecpu")
    assert 0<rounds<=1000
    spec=importlib.util.spec_from_file_location('probe_profile',PROBE/'profile.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    runtime=HERE/'.work/runtime';runtime.mkdir(parents=True,exist_ok=True)
    frozen=ROOT/'.emulator/rally28-completion-poll02'
    for src,dst in [('flexe-agon-emulator.bin','flexe-agon-emulator'),('flexe-vdp.so','flexe-vdp.so')]:shutil.copyfile(frozen/src,runtime/dst)
    assert sha(runtime/'flexe-agon-emulator')=='7e78e991a32c7bc94e84d70e8ad1792e3b840c48adc2e3aae7f635a88f4878ad'
    assert sha(runtime/'flexe-vdp.so')=='200f28cbe399b1fdc60cba1e5fed4c2bb86042b5e92f6e422539a5388c079a30'
    profile=m.prepare(name,'key',HERE/('.work/target/bin/capacity.bin' if kind=='capacity' else '.work/cpu/bin/wirecpu.bin'),PROBE/'.work/stock-v2.16.0.bin',runtime,ROOT.parent/'golem/.emulator/runtime/fab-1.2.5')
    app=profile/'sdcard/test/arcade/rally28/key';dest=app.with_name(kind);app.rename(dest);(dest/'probe.bin').rename(dest/'capacity.bin');(dest/'count.txt').write_text(str(rounds)+'\n')
    autoexec=profile/'sdcard/autoexec.txt';autoexec.write_bytes(f'SET KEYBOARD 1\r\nCD /test/arcade/rally28/{kind}\r\nLOAD capacity.bin\r\nRUN .\r\n'.encode())
    identity=json.loads((profile/'identity.json').read_text());identity['kind']=kind;identity['rounds']=rounds
    identity['files'].pop('sdcard/test/arcade/rally28/key/probe.bin')
    for p in [autoexec,dest/'capacity.bin',dest/'count.txt']:identity['files'][str(p.relative_to(profile))]=sha(p)
    (profile/'identity.json').write_text(json.dumps(identity,indent=2)+'\n');(profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in identity['files'].items()))
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('name');p.add_argument('--rounds',type=int,required=True);p.add_argument('--kind',default='capacity',choices=['capacity','wirecpu']);a=p.parse_args();prepare(a.name,a.rounds,a.kind)
