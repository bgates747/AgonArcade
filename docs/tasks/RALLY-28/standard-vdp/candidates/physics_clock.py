"""Observe existing CAP_BEGIN/CAP_END on the unchanged 8192-step physics fixture."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,os,shutil
from run import run
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4];PROBE=HERE.parent/'completion-probe'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
if __name__=='__main__':
    assert os.getuid()!=0
    spec=importlib.util.spec_from_file_location('probe_profile',PROBE/'profile.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    args=argparse.ArgumentParser();args.add_argument('--name',default='rally28-physics-wall-boostoff');name=args.parse_args().name
    binary=HERE/'evidence/physics-wall-boostoff/capacity.bin'
    if not binary.exists():binary=ROOT/'.emulator/rally28-capacity-baseline02/sdcard/test/arcade/rally28/capacity/capacity.bin'
    assert sha(binary)=='12fa08e3217db0f03cafefeae3743d260d380a6cd5696d26e8658c53799e40c6'
    profile=m.prepare(name,'key',binary,PROBE/'.work/stock-v2.16.0.bin',HERE/'.work/runtime',ROOT.parent/'golem/.emulator/runtime/fab-1.2.5')
    old=profile/'sdcard/test/arcade/rally28/key';app=old.with_name('capacity');old.rename(app);(app/'probe.bin').rename(app/'capacity.bin');(app/'count.txt').write_text('2\n')
    auto=profile/'sdcard/autoexec.txt';auto.write_bytes(b'SET KEYBOARD 1\r\nCD /test/arcade/rally28/capacity\r\nLOAD capacity.bin\r\nRUN .\r\n')
    launch=profile/'flexe-agon-emulator';launch.write_text(launch.read_text().replace('export AGON_FLEXE_ENGINE=jit','export AGON_FLEXE_ENGINE=interp'))
    r=json.loads((profile/'identity.json').read_text());r.update(kind='capacity',rounds=2,engine='interp',adapter_delivery='eof-fixed')
    r['files'].pop('sdcard/test/arcade/rally28/key/probe.bin')
    for p in (auto,launch,app/'capacity.bin',app/'count.txt'):r['files'][str(p.relative_to(profile))]=sha(p)
    assert r['files']['flexe-vdp.so']=='108ec5b02122381e6c3ae851508188ec0a96240ca5f74be804fd2201b141e6e9'
    (profile/'identity.json').write_text(json.dumps(r,indent=2)+'\n');(profile/'.runtime.sha256').write_text(''.join(v+'  '+k+'\n' for k,v in r['files'].items()))
    for p in (*(profile/n for n in r['files']),profile/'identity.json',profile/'.runtime.sha256'):
        with p.open('rb') as f:os.fsync(f.fileno())
    run(profile,90,uart_markers=(b'CAP_BEGIN',b'CAP_END'))
