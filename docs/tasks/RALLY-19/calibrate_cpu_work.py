"""Conservatively bound sink/marker cost using unchanged native wrapper code.

Subtract the full calibrated call/loop cost from oracle work; do not subtract
anything from candidate work. This intentionally understates construction savings.
"""
import argparse,csv,io,json,math,os,re,shutil,signal,subprocess,time
from pathlib import Path
from profile import TASK,prepare
from capture import runtime_identity
from native_run import sha
from measure_swap_overhead import no_emulators

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--build',required=True);a=p.parse_args()
    no_emulators();base=TASK/'.work/cpu-work'/a.build;identity=json.loads((base/'manifest.json').read_text())
    for path,digest in {**identity['source_hashes'],**identity['outputs']}.items():assert sha(Path(path))==digest,path
    root=TASK/'evidence/golem-cpu-calibration'/a.name;root.mkdir(parents=True,exist_ok=False)
    work=TASK/'.work/cpu-calibration'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copytree(base/'include',work/'include');shutil.copy2(base/'src/main.cpp',work/'src/main.cpp');shutil.copy2(base/'Makefile',work/'Makefile')
    header=(base/'include/cpu_work.hpp').read_text().split('int r19CpuBenchmark(){',1)[0]+(TASK/'cpu_calibration.inc').read_text()
    (work/'include/cpu_work.hpp').write_text(header);(root/'cpu_work.hpp').write_text(header)
    source_hashes={str(p):sha(p) for p in [Path(__file__),TASK/'cpu_calibration.inc',base/'include/cpu_work.hpp',work/'src/main.cpp',work/'include/cpu_work.hpp']}
    with (root/'build.txt').open('w') as log:subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    objdump='/home/smith/Agon/agondev/release/bin/ez80-none-elf-objdump'
    listings={}
    for name,path in [('measured',base),('calibration',work)]:
        listing=subprocess.check_output([objdump,'-dr',str(path/'obj/main.o')],text=True)
        (root/(name+'-object.txt')).write_text(listing);listings[name]=listing
    fragments={}
    for symbol in ['__wrap__mos_puts','__wrap__putch','_r19WorkBegin','_r19WorkEnd']:
        values=[]
        for listing in listings.values():
            match=re.search(r'^[0-9a-f]+ <'+re.escape(symbol)+r'>:\n(.*?)(?=\n[0-9a-f]+ <|\Z)',listing,re.M|re.S)
            assert match,symbol
            # The relocatable object's same functions must retain actual
            # instruction bytes and relocation targets. Normalize offsets only.
            values.append(re.sub(r'^\s*[0-9a-f]+:',':',match[1],flags=re.M).strip())
        assert values[0]==values[1],symbol
        fragments[symbol]=values[0]
    (root/'identical-wrappers.json').write_text(json.dumps(fragments,indent=2)+'\n')
    profile=prepare(TASK/'.emulator'/('cpu-calibration-'+a.name),work/'bin/rally.bin','oval oracle measure compute')
    app=profile/'sdcard/rally';before=runtime_identity(profile)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','R19_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV','SDL_VIDEO_DRIVER')}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    launch=['./fab-agon-emulator','--renderer','sw','-d'];mapping=(work/'bin/rally.map').read_text()
    for symbol in ['r19WorkBegin','r19WorkEnd']:
        launch+=['-b',str(int(re.search(r'(0x[0-9a-f]+)\s+_'+symbol+r'\s*$',mapping,re.M)[1],16))]
    manifest={'scope':__doc__,'headless':True,'command':launch,'runtime_before':before,'source_hashes':source_hashes,
              'measured_build':identity,'binary_sha256':sha(work/'bin/rally.bin'),'completed':False}
    begin=time.monotonic()
    with (root/'emulator.log').open('w') as log:
        proc=subprocess.Popen(launch,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,stdin=subprocess.PIPE,start_new_session=True)
        proc.stdin.write(b'state\ncontinue\n'*64);proc.stdin.flush()
        try:
            while time.monotonic()-begin<120:
                if (app/'cpu-calibration.snk').exists():manifest['completed']=True;break
                if proc.poll() is not None:raise RuntimeError('Calibration emulator exited early')
                time.sleep(.01)
            assert manifest['completed'],'Timed out; retain failed calibration'
        finally:
            if proc.poll() is None:
                os.killpg(proc.pid,signal.SIGTERM)
                try:proc.wait(timeout=5)
                except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
            manifest.update(returncode=proc.returncode,wall_seconds_with_startup=time.monotonic()-begin)
            (root/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    after=runtime_identity(profile);assert all(after.get(k)==v for k,v in before.items())
    (root/'cpu-calibration.csv').write_bytes((app/'cpu-calibration.csv').read_bytes())
    rows=[{k:int(v) for k,v in r.items()} for r in csv.DictReader(io.StringIO((root/'cpu-calibration.csv').read_text().split('# complete')[0]))]
    assert len(rows)==32
    breaks=[int(v) for v in re.findall(r'Cycles since last break: (\d+)',(root/'emulator.log').read_text())]
    assert len(breaks)==64;cycles=breaks[1::2]
    for i,r in enumerate(rows):
        kind=i//4;seed=[0,250,65530,0xfffffff0][i%4];size=[0,1,1,3,9,14,97,2048][kind];count=64 if kind else 0
        assert r=={'kind':kind,'seed':seed,'bytes':(seed+count*size)%(2**32),'calls':(seed+count)%(2**32)}
        r['cycles']=cycles[i]
    empty=max(cycles[:4]);per_call=max(math.ceil(c/64) for c in cycles[4:])
    report={'scope':__doc__,'pass':True,'cases':32,'repeated_calls':64,'empty_upper_cycles':empty,
            'call_loop_upper_cycles':per_call,'identical_wrapper_and_marker_object_instructions':True,
            'rows':rows,'runtime_inputs_unchanged':True,'source_hashes':source_hashes,
            'interpretation':'For each oracle frame subtract empty_upper_cycles + calls*call_loop_upper_cycles; retain full raw candidate cycles. '
                             'Includes conservative loop/argument overhead and both32-bit counter carries/wrap. Excludes actual UART/MOS driver work.'}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k not in ['rows','source_hashes']},indent=2))

if __name__=='__main__':main()
