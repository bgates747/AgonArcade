"""Oryx-side isolated canonical profile setup and bounded headless qualification."""
from pathlib import Path
import struct
import argparse,hashlib,importlib.util,json,os,shutil,signal,subprocess,time
from decode import decode
from report import image_check
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
WORK=HERE/'.work'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def prepare(case,engine):
    shared=ROOT.parent/'golem'
    runtime=shared/'docs/tasks/GOLEM-021/emulator/build'
    profile=ROOT/'.emulator/rally24'/f'{case}-{engine}'
    spec=importlib.util.spec_from_file_location('setup',WORK/'setup_emulator.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    sd=m.link_shared_runtime(profile,shared/'.emulator/runtime/fab-1.2.5')
    m.replace_symlink(profile/'fab-agon-emulator.bin',runtime/'fab-source/target/release/fab-agon-emulator')
    for name,src in [('flexe-vdp.so',runtime/'flexe-vdp.so'),('esp32-firmware.bin',WORK/'firmware.bin'),('esp32-firmware.elf',WORK/'firmware.elf')]:shutil.copyfile(src,profile/name)
    dest=sd/'r24'/case;dest.mkdir(parents=True,exist_ok=True)
    for src in (WORK/'fixtures'/case).iterdir():
        if src.is_file() and src.suffix not in ('.log',):shutil.copyfile(src,dest/src.name)
    for name in ('replies.log','ticks.log','failure.log','timings.json'):(dest/name).unlink(missing_ok=True)
    (sd/'autoexec.txt').write_bytes(('SET KEYBOARD 1\r\ncd /r24/'+case+'\r\nload probe.bin\r\nrun .\r\n').encode())
    (profile/'.bespoke-vdp-profile').write_text('flexe-vdp.so\n');m.write_profile_launcher(profile,strict_bespoke=True)
    launch=profile/'fab-agon-emulator';s=launch.read_text()
    env='''
export AGON_FLEXE_FIRMWARE="$profile_dir/esp32-firmware.bin"
export AGON_FLEXE_ELF="$profile_dir/esp32-firmware.elf"
export AGON_FLEXE_ENGINE="'''+engine+'''"
export AGON_FLEXE_ARTIFACTS="$profile_dir/last-run"
mkdir -p "$AGON_FLEXE_ARTIFACTS"
'''
    assert s.count('\nvdp_name=')==1
    launch.write_text(s.replace('\nvdp_name=',env+'\nvdp_name=',1))
    names=['fab-agon-emulator','fab-agon-emulator.bin','mos_platform.bin','mos_platform.map','flexe-vdp.so','esp32-firmware.bin','esp32-firmware.elf']
    (profile/'.runtime.sha256').write_text(''.join(sha(profile/n)+'  '+n+'\n' for n in names))
    return profile,dest

def run(case,engine,timeout):
    profile,dest=prepare(case,engine);art=profile/'last-run'
    if art.exists():
        history=profile/'history';history.mkdir(exist_ok=True)
        art.rename(history/str(time.time_ns()))
    art.mkdir()
    env={k:v for k,v in os.environ.items() if k not in ('LD_PRELOAD','BASH_ENV')};env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    started=time.monotonic();error=None;proc=None
    try:
        with (art/'frontend.log').open('w') as log:
            proc=subprocess.Popen(['./fab-agon-emulator','--renderer','sw','-z'],cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            while True:
                if (dest/'failure.log').exists():raise RuntimeError('Guest fixture failed; failure.log retained')
                if (dest/'replies.log').exists() and (dest/'replies.log').stat().st_size==len(json.loads((dest/'expected.json').read_text())['checks'])*10:
                    time.sleep(1);break
                if proc.poll() is not None:raise RuntimeError('Frontend exited early: '+str(proc.returncode))
                if time.monotonic()-started>timeout:raise TimeoutError('Fixture completion deadline exceeded')
                time.sleep(.2)
    except Exception as e:error=repr(e)
    finally:
        if proc and proc.poll() is None:
            for p in Path('/proc').glob('[0-9]*'):
                try:
                    if os.getpgid(int(p.name))==proc.pid and (p/'exe').resolve()==(profile/'fab-agon-emulator.bin').resolve():os.kill(int(p.name),signal.SIGTERM)
                except (OSError,PermissionError):pass
            try:proc.wait(timeout=15)
            except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    result=dict(case=case,engine=engine,host_elapsed_seconds=time.monotonic()-started,error=error,exit_code=proc.returncode if proc else None,runtime_identities=(profile/'.runtime.sha256').read_text())
    if not error:
        try:
            meta=json.loads((dest/'expected.json').read_text())
            if meta.get('kind')=='matrix':
                result['matrix_probe']=decode(dest)
            else:
                result['timings']=decode(dest)
                result['scene_check']=image_check(art/'final.ppm')
            stats=json.loads((art/'stats.json').read_text());result['backend_stats']=stats
            assert not any(stats.get(k) for k in ('failed','unhandled','unregistered','unmapped')),stats
            assert proc.returncode==0,proc.returncode
        except Exception as e:result['error']=repr(e)
    evidence=HERE/'evidence'/f'{case}-{engine}';evidence.mkdir(parents=True,exist_ok=True)
    for src in list(art.iterdir())+list(dest.glob('*.log'))+[dest/'expected.json']:
        if src.is_file():shutil.copyfile(src,evidence/src.name)
    (evidence/'result.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('timings','runtime_identities','backend_stats','matrix_rows','matrix_probe')}),flush=True)
    if result['error']:raise SystemExit(1)
if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--case',required=True);a.add_argument('--engine',choices=['jit','interp'],default='jit');a.add_argument('--timeout',type=float,default=600);args=a.parse_args();run(args.case,args.engine,args.timeout)
