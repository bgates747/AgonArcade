"""Build two standalone stock-VDP probes without changing any game source."""
from pathlib import Path
import hashlib,json,os,re,shutil,subprocess
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
WORK=HERE/'.work'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def build():
    results={}
    for name,gp in [('key',0),('poll',1)]:
        work=WORK/name; (work/'src').mkdir(parents=True,exist_ok=True)
        for p in (HERE/'src').iterdir():shutil.copyfile(p,work/'src'/p.name)
        (work/'Makefile').write_text(f'NAME=probe\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\ninclude /Agon/agondev/release/config/makefile.inc\nCXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -DPROBE_GP={gp}\n')
        env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH'])
        subprocess.run(['make','-C',str(work)],env=env,check=True)
        mapping=(work/'bin/probe.map').read_text()
        for section in ('init_array','ctors','dtors','fini_array'):
            m=re.search(r'^\.'+section+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M)
            assert m and int(m[1],16)==0,section
        results[name]={'binary_sha256':sha(work/'bin/probe.bin'),'bytes':(work/'bin/probe.bin').stat().st_size}
    results['source']={str(p.relative_to(HERE)):sha(p) for p in [HERE/'build.py',*sorted((HERE/'src').iterdir())]}
    (WORK/'build.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(results,indent=2))
if __name__=='__main__':build()
