"""Native bitmap selection, signed placement, affine scale/reflection/cache/reset.

Compare exact native pixels against independent direct stock commands. Small
asymmetric RGBA2222 test bitmaps are diagnostic data, not new Rally artwork.
"""
from argparse import ArgumentParser,Namespace
from pathlib import Path
import json,struct,subprocess,shutil
from profile import TASK,prepare
from native_run import GOLEM,sha
from capture import capture
from scene_masks import game_image

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    cases=[(bitmap,80,80,scale,mirror) for scale in [14,64,128,256] for mirror in [0,1] for bitmap in [0,1]]
    cases += [(i%2,x,y,256,i//4) for i,(x,y) in enumerate([(-2,30),(300,40),(60,220),(0,0)]*2)]
    root=TASK/'evidence/golem-bitmap'/a.name;root.mkdir(parents=True,exist_ok=False)
    source=GOLEM/'examples/native_vehicle_math/bitmap.golem'
    inputs={'scope':__doc__,'cases':cases,'source_hashes':{str(p):sha(p) for p in [Path(__file__),TASK/'bitmap_loader.cpp',source,GOLEM/'src/hosted.hpp']}}
    (root/'inputs.json').write_text(json.dumps(inputs,indent=2)+'\n');images={}
    for variant in ['oracle','candidate']:
        work=TASK/'.work/bitmap-visual'/a.name/variant;(work/'src').mkdir(parents=True,exist_ok=False)
        shutil.copy2(TASK/'bitmap_loader.cpp',work/'src/main.cpp');shutil.copy2(GOLEM/'examples/native_admission/main.cpp',work/'src/transport.inc')
        (work/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text()+ ('\nCXXFLAGS += -DBITMAP_ORACLE\n' if variant=='oracle' else ''))
        with (root/(variant+'-build.txt')).open('w') as log:
            if variant=='candidate':
                subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source),str(work/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
                shutil.copy2(source,root/'kernel.golem');shutil.copy2(work/'program.bin.map',root/'program.map')
            subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
        profile=prepare(TASK/'.emulator'/('bitmap-visual-'+a.name+'-'+variant),work/'bin/probe.bin','');app=profile/'sdcard/rally'
        if variant=='candidate':(app/'program.bin').symlink_to(work/'program.bin')
        payload=struct.pack('<H',len(cases))+b''.join(struct.pack('<HhhHH',*c) for c in cases);(app/'poses.dat').write_bytes(payload)
        frames=[30+120*i for i in range(len(cases))]
        keys=[f'right:{60+120*i}:{65+120*i}' for i in range(len(cases)-1)]+[f'escape:{frames[-1]+20}:{frames[-1]+25}']
        capture(Namespace(profile=profile,output=root/variant,ready_file=app/'ready.viz',expect_file=[app/'exit.viz'],frames=','.join(map(str,frames)),keys=','.join(keys),quit_frame=frames[-1]+40,timeout=150))
        assert (root/variant/'guest-exit.viz').read_text().strip()=='0'
        images[variant]=[game_image(root/variant/f'frame-{f:06d}.png') for f in frames]
    results=[]
    for case,e,c in zip(cases,images['oracle'],images['candidate']):
        expected=e.tobytes();actual=c.tobytes()
        different=sum(x!=y for x,y in zip(e.get_flattened_data(),c.get_flattened_data()))
        # The untransformed second bitmap must actually appear in both images.
        plain_present=any(e.getpixel((x,y))!=(85,85,85) for x in range(180,188) for y in range(100,108))
        results.append({'case':case,'different_pixels':different,'plain_present':plain_present,'pass':expected==actual and plain_present})
    report={'scope':__doc__,'cases':len(cases),'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Native bitmap exact-pixel comparison passes:',len(cases),'poses')

if __name__=='__main__':main()
