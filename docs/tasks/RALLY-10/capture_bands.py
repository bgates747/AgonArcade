"""Headless native stills of identical stationary road poses in both band modes."""
from pathlib import Path
import os
import subprocess
import sys
import tempfile
from PIL import Image

TASK=Path(__file__).resolve().parent
ROOT=TASK.parents[2]/'rally'
base=ROOT/'.emulator/captures';base.mkdir(parents=True,exist_ok=True)
out=Path(tempfile.mkdtemp(prefix='bands-',dir=base))
library=out/'capture.dylib';home=Path.home()
subprocess.run(['clang','-dynamiclib',f'-I{home}/.local/include',f'-L{home}/.local/lib',
                '-lSDL3',str(TASK/'capture_macos.c'),'-o',str(library)],check=True)
startup=out/'capture-env.sh';startup.write_text('export DYLD_INSERT_LIBRARIES="$RALLY_CAPTURE_LIBRARY"\n')
print(out,flush=True)
for track,position in (('oval',4000),('fuji',4800)):
    for fixed in (False,True):
        label=track+('-fixed' if fixed else '-greedy')
        profile=out/label
        subprocess.run([sys.executable,str(ROOT/'tools/prepare_emulator.py'),
                        '--profile',str(profile),'--track',track,'--fence'],check=True,stdout=subprocess.DEVNULL)
        options=f'{track} {position} race fence'+(' fixedbands' if fixed else '')
        (profile/'sdcard/autoexec.txt').write_bytes(
            f'SET KEYBOARD 1\r\ncd /rally\r\nload rally.bin\r\nrun . {options}\r\n'.encode())
        env=os.environ.copy()
        for key in ('RALLY_TEST_KEYS','LD_PRELOAD','DYLD_INSERT_LIBRARIES'): env.pop(key,None)
        env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',BASH_ENV=str(startup),
                   RALLY_CAPTURE_LIBRARY=str(library),RALLY_CAPTURE_DIR=str(profile))
        with (profile/'capture.log').open('w') as log:
            result=subprocess.run(['./fab-agon-emulator','--renderer','sw'],cwd=profile,env=env,
                                  stdout=log,stderr=subprocess.STDOUT,timeout=45)
        captures=list(profile.glob('frame-*.bmp'))
        if len(captures)!=4: raise RuntimeError(f'{label}: expected four captures, got {len(captures)}')
        for capture in captures: Image.open(capture).save(capture.with_suffix('.png'))
        print(label,'captured; requested-quit exit',result.returncode,flush=True)
