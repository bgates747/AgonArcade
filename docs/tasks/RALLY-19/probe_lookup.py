"""Native stock-VDP resident records, arbitrary byte readback and owned cleanup.

Normal CPU/UART, dummy SDL, no graphics hook or upstream modifications.
GP is a parser/echo diagnostic; none of these checks assert raster completion.
"""
from pathlib import Path
import argparse, hashlib, json, os, shutil, signal, struct, subprocess, time
from profile import prepare, TASK
from capture import runtime_identity
GOLEM=Path('/home/smith/Agon/mystuff/golem-rally19')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');args=p.parse_args()
    root=TASK/'evidence/golem-lookup'/args.name;root.mkdir(parents=True,exist_ok=False)
    build=GOLEM/'build/native-lookup'/args.name;(build/'src').mkdir(parents=True,exist_ok=False)
    source=GOLEM/'examples/native_lookup'
    for a,b in [('main.cpp','src/main.cpp'),('Makefile','Makefile')]:shutil.copy2(source/a,build/b)
    with (root/'build.txt').open('w') as log:
        subprocess.run([str(GOLEM/'.venv/bin/python'),str(source/'make_assets.py')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run(['make','-C',str(GOLEM/'src')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source/'kernel.golem'),str(build/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run(['make','-C',str(build)],check=True,stdout=log,stderr=subprocess.STDOUT)
    mapping=(build/'program.bin.map').read_text()
    ids=[int(line.split()[1]) for line in mapping.splitlines() if line.startswith('owned ')]
    assert len(ids)==len(set(ids)) and 55555 not in ids and 1999 not in ids
    profile=prepare(TASK/'.emulator'/('lookup-'+args.name),build/'bin/probe.bin','')
    app=profile/'sdcard/rally'
    (app/'program.bin').symlink_to(build/'program.bin');(app/'program.clear').symlink_to(build/'program.bin.clear')
    (app/'owned.dat').write_bytes(struct.pack('<'+'H'*len(ids),*ids))
    files=[source/'kernel.golem',source/'main.cpp',source/'records.dat',source/'bytes.dat',source/'make_assets.py',GOLEM/'src/hosted.hpp',GOLEM/'src/golemc.cpp',GOLEM/'build/golemc',build/'program.bin',build/'program.bin.clear',build/'bin/probe.bin']
    (root/'identity.json').write_text(json.dumps({str(f.relative_to(GOLEM)):sha(f) for f in files},indent=2)+'\n')
    for f in [source/'kernel.golem',source/'main.cpp',build/'program.bin.map']:shutil.copy2(f,root/f.name)
    before=runtime_identity(profile)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV')}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    command=['./fab-agon-emulator','--renderer','sw'];started=time.monotonic()
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(command,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while not (app/'exit.txt').exists():
                if proc.poll() is not None:raise RuntimeError('emulator exited before guest completion')
                if time.monotonic()-started>120:raise TimeoutError('resident lookup/lifecycle test')
                time.sleep(.02)
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
    after=runtime_identity(profile)
    for name in ['results.dat','bytes.dat','lifecycle.dat','exit.txt']:
        if (app/name).exists():shutil.copy2(app/name,root/('guest-'+name))
    (root/'manifest.json').write_text(json.dumps({'command':command,'runtime_before':before,'runtime_after':after,'scope':__doc__,'host_seconds':time.monotonic()-started},indent=2)+'\n')
    assert all(after[k]==v for k,v in before.items())
    assert (root/'guest-exit.txt').read_text().strip()=='0',(root/'guest-exit.txt').read_text()
    records=[(7,9),(-4,6),(31,2),(80,1)];indices=[0,3,1,2,4,65535,65534,0];expected=[]
    for cycle in range(3):
        for round_ in range(3):
            previous=None
            for index in indices:
                if index<len(records):previous=records[index]
                a,b=previous;expected.append((a,b,float(a*b),index,int(index<len(records))))
    raw=(root/'guest-results.dat').read_bytes();actual=list(struct.iter_unpack('<iifHH',raw))
    assert actual==expected,[(i,a,e) for i,(a,e) in enumerate(zip(actual,expected)) if a!=e]
    assert (root/'guest-bytes.dat').read_bytes()==bytes(range(256))*9
    life=(root/'guest-lifecycle.dat').read_bytes();offset=0;checks=[]
    for cycle in range(3):
        assert life[offset:offset+6]==b'\x34\x12'*3;offset+=6
        present=life[offset:offset+len(ids)];offset+=len(ids)
        missing=life[offset:offset+len(ids)];offset+=len(ids)
        assert len(present)==len(ids) and all(v!=0x55 for v in present),present
        assert missing==b'\x55'*len(ids),missing
        assert life[offset:offset+2]==b'\x34\x12';offset+=2
        checks.append({'cycle':cycle,'owned_ids':ids,'before_clear_first_bytes':list(present),'after_clear_missing_copy_tags':list(missing),'foreign_canary':4660})
    assert offset==len(life)
    report={'pass':True,'lookup_cases':len(actual),'records':records,'indices':indices,'lookup_results':actual,'complete_reloads':9,'mode_resets':9,'cleanup_cycles':checks,'all_256_bytes_roundtrips':9,'limitations':['Cleanup checks buffer readability and foreign ownership; static owned-ID/payload counts are not live allocator/metadata measurements.','GP confirms parser/echo progress, not raster completion.','This small lookup probe does not qualify complete Rally packet admission or the final scene.']}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Native resident lookup: 72 selections, nine all-byte readbacks/reloads, three owned cleanups pass')
if __name__=='__main__':main()
