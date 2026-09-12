"""Headless Mac visual checks; capture-instrumented runs are excluded from timings."""
from pathlib import Path
import argparse
import os
import subprocess
import sys
import tempfile
from PIL import Image

TASK=Path(__file__).resolve().parent
ROOT=TASK.parents[2]/'rally'
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--fixed-bands',action='store_true')
parser.add_argument('--cases',nargs='+',choices=('full','nosky','notraffic','mirror','game'),default=('full','nosky','notraffic','mirror','game'))
args=parser.parse_args()
base=ROOT/'.emulator/captures';base.mkdir(parents=True,exist_ok=True)
out=Path(tempfile.mkdtemp(prefix='controlled-',dir=base))
library=out/'capture.dylib';home=Path.home()
subprocess.run(['clang','-dynamiclib',f'-I{home}/.local/include',f'-L{home}/.local/lib','-lSDL3',str(TASK/'capture_macos.c'),'-o',str(library)],check=True)
startup=out/'capture-env.sh';startup.write_text('export DYLD_INSERT_LIBRARIES="$RALLY_CAPTURE_LIBRARY"\n')
print(out,flush=True)
for case in args.cases:
    profile=out/case
    prepare=[sys.executable,str(ROOT/'tools/prepare_emulator.py'),'--profile',str(profile),'--fence']
    if args.fixed_bands: prepare.append('--fixed-bands')
    if case!='game': prepare+=['--workload',case]
    subprocess.run(prepare,check=True,stdout=subprocess.DEVNULL)
    env=os.environ.copy();env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',BASH_ENV=str(startup),RALLY_CAPTURE_LIBRARY=str(library),RALLY_CAPTURE_DIR=str(profile))
    if case=='game': env['RALLY_TEST_KEYS']='1'
    with (profile/'capture.log').open('w') as log:
        result=subprocess.run(['./fab-agon-emulator','--renderer','sw'],cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=45)
    captures=list(profile.glob('frame-*.bmp'))
    if not captures: raise RuntimeError(f'No captures for {case}; exit {result.returncode}')
    for image in captures: Image.open(image).save(image.with_suffix('.png'))
    print(case,len(captures),'captures; exit',result.returncode,flush=True)
