"""Exercise actual old/new presentation, not a reimplementation of the cache."""
from pathlib import Path
import hashlib,json,os,subprocess,sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[5]
CUSTOM=HERE.parents[1]
sys.path.insert(0,str(CUSTOM/'full-race'))
from presentation_build import function

def run():
    work=HERE/'.work/host';work.mkdir(parents=True,exist_ok=True)
    old=(CUSTOM/'incremental/round-trips/guest/include/presentation-functions.inc').read_text()
    new=(ROOT/'rally-game/src/main.cpp').read_text()
    for name,source in [('reference',old),('candidate',new)]:
        (work/(name+'.inc')).write_text(''.join(function(source,n) for n in ('clockText','drawHud','bottom')))
    for name,flags in [('ordinary',[]),('sanitized',['-fsanitize=address,undefined','-fno-omit-frame-pointer']),('development',['-DRALLY_DEVELOPMENT'])]:
        target=work/name
        command=['c++','-std=c++17','-O1','-Wall','-Wextra','-Werror','-Wno-unused-variable',*flags,
                 '-I'+str(work),'-I'+str(ROOT/'rally-game/include'),'-I'+str(ROOT/'rally-production/include'),
                 str(HERE/'host_test.cpp'),'-o',str(target)]
        subprocess.run(command,check=True)
        result=subprocess.run([str(target),str(CUSTOM/'incremental/round-trips/fixtures/compact/motion.bin')],
            env=dict(os.environ,ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1'),
            text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        (HERE/('HOST-'+name+'.txt')).write_text(result.stdout+result.stderr)
        assert result.returncode==0,result.stderr
        report=json.loads(result.stdout);report.update(compiler_command=command,
            input_sha256={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in
                [HERE/'host_test.cpp',work/'reference.inc',work/'candidate.inc',ROOT/'rally-game/include/hud_format.hpp']},
            leak_sanitizer='disabled under ptrace; address/undefined enabled' if name=='sanitized' else None)
        (HERE/('HOST-'+name+'.json')).write_text(json.dumps(report,indent=2)+'\n')
        print(name,result.stdout.strip(),flush=True)

if __name__=='__main__':run()
