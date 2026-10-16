"""Recover exact R18 review inputs in fresh canonical Flexe profiles on Oryx."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import shutil
import signal
import subprocess
import time

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
INPUTS=HERE/'.work/flexe-inputs'
EXPECTED='20622e05c82431b58552be533a749779e30a7e2cfdb7b3352e582896fdf2ab70'
STOCK='b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def prepare(name):
    assert Path(name).name==name and name.startswith('rally18-flexe-')
    p=ROOT/'.emulator'/name
    assert not p.exists()
    assert sha(INPUTS/'rally.bin')==EXPECTED and sha(INPUTS/'firmware.bin')==STOCK
    data=json.loads((HERE/'data/manifest.json').read_text())['files']
    for n in ('fuji.road','oval.road'):assert sha(INPUTS/n)==data[n]['sha256']
    # Template has a real canonical guarded Flexe wrapper, official MOS and
    # corrected runtime. Only a new owned copy is customized.
    shutil.copytree(ROOT/'.emulator/rally28-road-sparse-flexe-1-final05',p,symlinks=True)
    assert not (p/'sdcard').is_symlink()
    shutil.rmtree(p/'sdcard');(p/'sdcard/rally').mkdir(parents=True)
    for n in ('rally.bin','fuji.road','oval.road'):shutil.copyfile(INPUTS/n,p/'sdcard/rally'/n)
    shutil.copyfile(INPUTS/'firmware.bin',p/'esp32-firmware.bin')
    (p/'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\nCD /rally\r\nLOAD rally.bin\r\nRUN . fuji demo\r\n')
    if (p/'last-run').exists():shutil.rmtree(p/'last-run')
    for n in ('frontend.log','human-frontend.log','human-result.json','identity.json','.runtime.sha256'):
        if (p/n).exists():(p/n).unlink()
    spec=importlib.util.spec_from_file_location('canonical_flexe',INPUTS/'flexe_profile.py')
    namer=importlib.util.module_from_spec(spec);spec.loader.exec_module(namer);namer.name_flexe_profile(p)
    assert not (p/'fab-agon-emulator').exists()
    assert 'export SDL_AUDIODRIVER=dummy' in (p/'flexe-agon-emulator').read_text()
    names=['flexe-agon-emulator','flexe-agon-emulator.bin','flexe-vdp.so','mos_platform.bin','mos_platform.map','esp32-firmware.bin','sdcard/autoexec.txt']
    names.extend('sdcard/rally/'+n for n in ('rally.bin','fuji.road','oval.road'))
    identity=dict(version='RALLY-18 exact unfenced review binary',track='fuji',options='demo',
                  firmware='official stock VDP 2.16.0',files={n:sha(p/n) for n in names},audio='dummy')
    (p/'identity.json').write_text(json.dumps(identity,indent=2)+'\n')
    (p/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in identity['files'].items()))
    print(p,flush=True)
    return p

def smoke(name):
    p=prepare(name);app=p/'sdcard/rally'
    assert Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip()=='0'
    start=time.monotonic();ready=None;reason='startup-timeout'
    with (p/'headless-smoke.log').open('w') as log:
        proc=subprocess.Popen(['./flexe-agon-emulator'],cwd=p,
                              env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy'),
                              stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while time.monotonic()-start<120:
                now=time.monotonic()
                if Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip()!='0':reason='boost-enabled';break
                if (app/'play-ready.viz').exists() and ready is None:ready=now
                if ready is not None and now-ready>=5:reason='startup-ready';break
                if proc.poll() is not None:reason='frontend-exit';break
                time.sleep(.2)
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    identity=json.loads((p/'identity.json').read_text())
    r=dict(reason=reason,host_seconds=time.monotonic()-start,ready_after_seconds=ready-start if ready else None,
           inputs_unchanged=all(sha(p/n)==h for n,h in identity['files'].items()),
           sdl_video='dummy',sdl_audio='dummy',stopped=True)
    stats=p/'last-run/stats.json'
    if stats.exists():r['backend_stats']=json.loads(stats.read_text())
    (p/'SMOKE.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r,indent=2),flush=True)
    return reason=='startup-ready' and r['inputs_unchanged']

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--name',required=True);parser.add_argument('--smoke',action='store_true');args=parser.parse_args()
    if args.smoke:raise SystemExit(0 if smoke(args.name) else 1)
    prepare(args.name)
