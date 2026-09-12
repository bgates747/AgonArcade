"""Native initialization-failure ownership check, including all uploaded artwork."""
import argparse,csv,json,os,shutil,signal,struct,subprocess,time
from pathlib import Path
from profile import TASK,prepare
from capture import runtime_identity
from native_run import sha
from measure_swap_overhead import no_emulators

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--frontend',required=True)
    p.add_argument('--track',choices=['oval','fuji'],required=True);p.add_argument('--case',choices=['missing-vdp','corrupt-vdp','missing-clr','corrupt-clr'],required=True);a=p.parse_args();no_emulators()
    base=TASK/'.work/frontend'/a.frontend;parent=json.loads((base/'manifest.json').read_text())
    for path,digest in parent['outputs'].items():assert sha(Path(path))==digest,path
    assert sha(base/'src/main.cpp')==parent['source_hashes'][str(TASK/'frontend.cpp')]
    root=TASK/'evidence/golem-failure'/a.name;root.mkdir(parents=True,exist_ok=False)
    work=TASK/'.work/failure'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copytree(base/'include',work/'include');shutil.copy2(base/'Makefile',work/'Makefile')
    for name in ['failure_work.hpp','render_readback.hpp','tagged_readback.hpp']:shutil.copy2(TASK/name,work/'include'/name)
    source=(base/'src/main.cpp').read_text();old='int main(int argc,char **argv){int result=gameMain(argc,argv);road.~LookupRoad();return result;}'
    assert source.count(old)==1
    source=source.replace(old,'#include "failure_work.hpp"\nint main(int argc,char**argv){return failureMain(argc,argv);}')
    (work/'src/main.cpp').write_text(source);shutil.copy2(work/'src/main.cpp',root/'main.cpp')
    with (root/'build.txt').open('w') as log:subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    library=root/'memory.so';shutil.copy2(TASK/'memory_probe_linux.cpp',root/'memory_probe_linux.cpp')
    subprocess.run(['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC','-I'+str(Path.home()/'.local/include'),str(root/'memory_probe_linux.cpp'),'-ldl','-o',str(library)],check=True)
    clear=(base/(a.track+'.clr')).read_bytes();ids=[int.from_bytes(clear[i+3:i+5],'little') for i in range(0,len(clear),6)]
    ids+=list(range(64000,64035))+[64100,63984,0];assert len(ids)==len(set(ids))
    profile=prepare(TASK/'.emulator'/('failure-'+a.name),work/'bin/rally.bin',a.track+' golem');app=profile/'sdcard/rally'
    for t in ['oval','fuji']:
        for ext in ['.vdp','.clr']:shutil.copy2(base/(t+ext),app/(t+ext))
    target=app/(a.track+('.vdp' if a.case.endswith('vdp') else '.clr'))
    if a.case.startswith('missing'):target.unlink()
    else:
        bad=bytearray(target.read_bytes());bad[len(bad)//2]^=0x80;target.write_bytes(bad)
    (app/'owned.dat').write_bytes(struct.pack('<'+'H'*len(ids),*ids))
    before=runtime_identity(profile);start=time.monotonic()
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER')}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',LD_PRELOAD=str(library),R19_VDP_MODULE=str(profile/'firmware/vdp_platform.so'),R19_MEMORY_PHASE=str(app/'memory.phase'),R19_MEMORY_REPORT=str(root/'memory.csv'))
    launch=['./fab-agon-emulator','--renderer','sw'];manifest={'scope':__doc__,'parent':parent,'track':a.track,'case':a.case,'command':launch,'runtime_before':before,'binary_sha256':sha(work/'bin/rally.bin'),'source_sha256':sha(TASK/'failure_work.hpp'),'runner_sha256':sha(Path(__file__)),'completed':False}
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(launch,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        try:
            while time.monotonic()-start<120:
                if (app/'failure-exit.snk').exists() and (root/'memory.csv').exists():manifest['completed']=True;break
                if proc.poll() is not None:raise RuntimeError('Emulator exited before failure report')
                time.sleep(.03)
            assert manifest['completed'],'Initialization-failure diagnostic timed out'
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
            manifest.update(returncode=proc.returncode,host_seconds=time.monotonic()-start,runtime_after=runtime_identity(profile))
            (root/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
            for name in ['failure-owned.dat','failure-summary.csv','failure-exit.snk']:
                if (app/name).exists():shutil.copy2(app/name,root/name)
    for k,v in before.items():assert manifest['runtime_after'][k]==v
    observed=(root/'failure-owned.dat').read_bytes();assert len(observed)==2*len(ids)
    present=[id for i,id in enumerate(ids) if observed[2*i:2*i+2]!=bytes([0x55,0xaa])]
    data=next(csv.DictReader((root/'failure-summary.csv').read_text().splitlines()[:2]))
    report={'pass':int(data['result'])==31 and not present,'scope':__doc__,'track':a.track,'case':a.case,'game_return':int(data['result']),'queried_ids':ids,'still_readable':present,'memory':(root/'memory.csv').read_text()}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(a.track,a.case,'return',report['game_return'],'remaining buffers',present,flush=True);assert report['pass'],present
if __name__=='__main__':main()
