from pathlib import Path
import os,subprocess,shutil,json,hashlib
HERE=Path(__file__).resolve().parent
subprocess.run([str(HERE.parents[5]/'.venv/bin/python'),str(HERE/'generate.py')],check=True)
w=HERE/'.work';(w/'src').mkdir(parents=True,exist_ok=True)
for p in (HERE/'src').iterdir():shutil.copyfile(p,w/'src'/p.name)
(w/'Makefile').write_text('NAME=spans\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\ninclude /Agon/agondev/release/config/makefile.inc\nCXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror\n')
subprocess.run(['make','-C',str(w)],env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH']),check=True)
b=w/'bin/spans.bin';(HERE/'BUILD.json').write_text(json.dumps({'binary_sha256':hashlib.sha256(b.read_bytes()).hexdigest(),'bytes':b.stat().st_size},indent=2)+'\n')
