"""Observe accepted/opposite VDU24 Y ordering, full reset and one-pixel width."""
from argparse import ArgumentParser,Namespace
from pathlib import Path
import json,subprocess,shutil
from profile import TASK,prepare
from native_run import GOLEM,sha
from capture import capture
from scene_masks import game_image

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    root=TASK/'evidence/golem-viewport-order'/a.name;root.mkdir(parents=True,exist_ok=False)
    work=TASK/'.work/viewport-order'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    source=TASK/'viewport_order_loader.cpp'
    shutil.copy2(source,work/'src/main.cpp');shutil.copy2(GOLEM/'examples/native_admission/main.cpp',work/'src/transport.inc')
    shutil.copy2(GOLEM/'examples/native_admission/Makefile',work/'Makefile')
    with (root/'build.txt').open('w') as log:subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    profile=prepare(TASK/'.emulator'/('viewport-order-'+a.name),work/'bin/probe.bin','');app=profile/'sdcard/rally'
    frames=[30+120*i for i in range(6)]
    keys=[f'right:{60+120*i}:{65+120*i}' for i in range(5)]+[f'escape:{frames[-1]+20}:{frames[-1]+25}']
    capture(Namespace(profile=profile,output=root/'capture',ready_file=app/'ready.viz',expect_file=[app/'exit.viz'],
                      frames=','.join(map(str,frames)),keys=','.join(keys),quit_frame=frames[-1]+40,timeout=90))
    assert (root/'capture/guest-exit.viz').read_text().strip()=='0'
    names=['accepted-order','opposite-order','accepted-then-accepted-full','opposite-then-accepted-full',
           'accepted-one-pixel-width','opposite-one-pixel-width']
    results=[]
    for name,frame in zip(names,frames):
        im=game_image(root/'capture'/f'frame-{frame:06d}.png')
        red=[(x,y) for y in range(240) for x in range(320) if im.getpixel((x,y))==(255,0,0)]
        results.append({'case':name,'red_pixels':len(red),'red_bounds':None if not red else
                        [min(x for x,y in red),min(y for x,y in red),max(x for x,y in red),max(y for x,y in red)]})
    report={'scope':__doc__,'observations':results,'source_hashes':{str(f):sha(f) for f in [Path(__file__),source]}}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))

if __name__=='__main__':main()
