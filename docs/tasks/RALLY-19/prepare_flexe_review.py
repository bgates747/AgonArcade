"""Stage the exact final R19 Golem buffered-command product; never launch it."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,shutil,subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2];INPUTS=HERE/'.work/flexe-inputs'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def prepare(name):
    assert Path(name).name==name and name.startswith('rally19-flexe-')
    p=ROOT/'.emulator'/name;assert not p.exists()
    delivery=json.loads((HERE/'FLEXE-INPUTS.json').read_text())
    for n,info in delivery['production_files'].items():assert sha(INPUTS/n)==info['sha256']
    assert sha(INPUTS/'firmware.bin')=='b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f'
    shutil.copytree(ROOT/'.emulator/rally28-road-sparse-flexe-1-final05',p,symlinks=True)
    assert not (p/'sdcard').is_symlink();shutil.rmtree(p/'sdcard');(p/'sdcard/rally').mkdir(parents=True)
    for n in delivery['production_files']:shutil.copyfile(INPUTS/n,p/'sdcard/rally'/n)
    shutil.copyfile(INPUTS/'firmware.bin',p/'esp32-firmware.bin')
    (p/'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\nCD /rally\r\nLOAD rally.bin\r\nRUN . fuji demo\r\n')
    if (p/'last-run').exists():shutil.rmtree(p/'last-run')
    for n in ['frontend.log','human-frontend.log','human-result.json','identity.json','.runtime.sha256']:
        if (p/n).exists():(p/n).unlink()
    spec=importlib.util.spec_from_file_location('canonical_flexe',INPUTS/'flexe_profile.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);m.name_flexe_profile(p)
    assert not (p/'fab-agon-emulator').exists() and 'export SDL_AUDIODRIVER=dummy' in (p/'flexe-agon-emulator').read_text()
    names=['flexe-agon-emulator','flexe-agon-emulator.bin','flexe-vdp.so','mos_platform.bin','mos_platform.map','esp32-firmware.bin','sdcard/autoexec.txt']+['sdcard/rally/'+n for n in delivery['production_files']]
    identity=dict(version='RALLY-19 final hardware-inline Golem buffered-command production',track='fuji',options='demo',firmware='official stock VDP 2.16.0',audio='dummy',files={n:sha(p/n) for n in names})
    (p/'identity.json').write_text(json.dumps(identity,indent=2)+'\n');(p/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in identity['files'].items()))
    subprocess.run(['bash','-n',str(p/'flexe-agon-emulator')],check=True)
    assert all(sha(p/n)==h for n,h in identity['files'].items())
    receipt=dict(status='staged-stopped-not-launched',profile=str(p),identity=identity,input_and_wrapper_checks=True,gameplay_not_qualified_under_flexe=True)
    (HERE/'FLEXE-REVIEW.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt,indent=2))
if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--name',required=True);prepare(a.parse_args().name)
