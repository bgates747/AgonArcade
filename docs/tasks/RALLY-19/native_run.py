"""Shared normal-clock, stock, headless fixture transport for new R19 probes.

Diagnostic only. GP/guest exit markers are not raster-completion evidence.
"""
from pathlib import Path
import hashlib,json,os,shutil,signal,subprocess,time
from profile import prepare,TASK
from capture import runtime_identity
GOLEM=Path('/home/smith/Agon/mystuff/golem-rally19')
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def execute(category,name,source,case_bytes):
    root=TASK/'evidence'/category/name;root.mkdir(parents=True,exist_ok=False)
    build=GOLEM/'build'/category/name;(build/'src').mkdir(parents=True,exist_ok=False)
    loader=GOLEM/'examples/native_admission'
    for a,b in [('main.cpp','src/main.cpp'),('Makefile','Makefile')]:shutil.copy2(loader/a,build/b)
    with (root/'build.txt').open('w') as log:
        subprocess.run(['make','-C',str(GOLEM/'src')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source),str(build/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run(['make','-C',str(build)],check=True,stdout=log,stderr=subprocess.STDOUT)
    profile=prepare(TASK/'.emulator'/(category+'-'+name),build/'bin/probe.bin','')
    app=profile/'sdcard/rally';(app/'program.bin').symlink_to(build/'program.bin');(app/'cases.dat').write_bytes(case_bytes)
    identities={str(p):sha(p) for p in [source,loader/'main.cpp',GOLEM/'src/golemc.cpp',GOLEM/'src/hosted.hpp',GOLEM/'build/golemc',build/'program.bin',build/'bin/probe.bin',Path(__file__)]}
    identities['case_bytes']=hashlib.sha256(case_bytes).hexdigest()
    (root/'identity.json').write_text(json.dumps(identities,indent=2)+'\n')
    for source_,name_ in [(source,'kernel.golem'),(loader/'main.cpp','loader.cpp'),(build/'program.bin.map','program.map')]:shutil.copy2(source_,root/name_)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV')}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    command=['./fab-agon-emulator','--renderer','sw'];before=runtime_identity(profile);start=time.monotonic()
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(command,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while not (app/'exit.txt').exists():
                if proc.poll() is not None:raise RuntimeError('early emulator exit')
                if time.monotonic()-start>120:raise TimeoutError('native probe')
                time.sleep(.02)
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    after=runtime_identity(profile)
    (root/'manifest.json').write_text(json.dumps({'command':command,'runtime_before':before,'runtime_after':after,'host_seconds':time.monotonic()-start,'scope':__doc__},indent=2)+'\n')
    for filename in ['results.dat','exit.txt']:
        if (app/filename).exists():shutil.copy2(app/filename,root/('guest-'+filename))
    assert all(after[k]==v for k,v in before.items())
    assert (root/'guest-exit.txt').read_text().strip()=='0'
    return root,(root/'guest-results.dat').read_bytes()
