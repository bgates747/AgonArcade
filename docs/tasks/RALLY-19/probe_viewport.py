"""Exact native images for viewport/scroll and full-view restoration.

Reference uses direct agondev calls with qualified pixel-mode Y wire order.
Compiler candidate receives rectangle/direction/amount fields, not command bytes.
"""
from argparse import ArgumentParser,Namespace
from pathlib import Path
import json,struct,subprocess,shutil
from profile import TASK,prepare
from native_run import GOLEM,sha
from capture import capture
from scene_masks import game_image

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--offset',type=int,default=0)
    p.add_argument('--limit',type=int,default=8);a=p.parse_args()
    # Stock scroll precondition: magnitude cannot exceed the region's axis size.
    cases=[(20,30,79,89,d,n) for d in range(4) for n in [0,1,7,59,60]]
    cases += [(*rect,d,1) for rect in [(20,30,20,49),(20,30,39,30),(0,0,319,239),(0,0,0,0)] for d in [0,3]]
    cases += [(0,0,319,239,d,255) for d in [0,1]]
    cases=cases[a.offset:a.offset+a.limit];assert 0<len(cases)<=8
    root=TASK/'evidence/golem-viewport'/a.name;root.mkdir(parents=True,exist_ok=False)
    source=GOLEM/'examples/native_quantization/viewport.golem'
    inputs={'scope':__doc__,'offset':a.offset,'cases':cases,'source_hashes':{str(p):sha(p) for p in
            [Path(__file__),TASK/'viewport_loader.cpp',source,GOLEM/'src/hosted.hpp',GOLEM/'build/golemc']}}
    (root/'inputs.json').write_text(json.dumps(inputs,indent=2)+'\n');images={}
    for variant in ['oracle','candidate']:
        work=TASK/'.work/viewport-visual'/a.name/variant;(work/'src').mkdir(parents=True,exist_ok=False)
        shutil.copy2(TASK/'viewport_loader.cpp',work/'src/main.cpp');shutil.copy2(GOLEM/'examples/native_admission/main.cpp',work/'src/transport.inc')
        (work/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text()+('\nCXXFLAGS += -DVIEWPORT_ORACLE\n' if variant=='oracle' else ''))
        with (root/(variant+'-build.txt')).open('w') as log:
            if variant=='candidate':
                subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source),str(work/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
                shutil.copy2(source,root/'kernel.golem');shutil.copy2(work/'program.bin.map',root/'program.map')
            subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
        profile=prepare(TASK/'.emulator'/('viewport-visual-'+a.name+'-'+variant),work/'bin/probe.bin','');app=profile/'sdcard/rally'
        if variant=='candidate':(app/'program.bin').symlink_to(work/'program.bin')
        (app/'poses.dat').write_bytes(struct.pack('<H',len(cases))+b''.join(struct.pack('<4h2H',*c) for c in cases))
        frames=[30+120*i for i in range(len(cases))]
        keys=[f'right:{60+120*i}:{65+120*i}' for i in range(len(cases)-1)]+[f'escape:{frames[-1]+20}:{frames[-1]+25}']
        capture(Namespace(profile=profile,output=root/variant,ready_file=app/'ready.viz',expect_file=[app/'exit.viz'],
                          frames=','.join(map(str,frames)),keys=','.join(keys),quit_frame=frames[-1]+40,timeout=180))
        assert (root/variant/'guest-exit.viz').read_text().strip()=='0'
        images[variant]=[game_image(root/variant/f'frame-{f:06d}.png') for f in frames]
    results=[]
    for case,e,c in zip(cases,images['oracle'],images['candidate']):
        different=sum(x!=y for x,y in zip(e.get_flattened_data(),c.get_flattened_data()))
        marker=all(c.getpixel((x,y))==(255,255,255) for x in range(180,188) for y in range(180,188))
        # Small-region commands must leave the outside background unchanged.
        outside=c.getpixel((150,150))==(85,85,85) if case[2]<150 else True
        left,top,right,bottom,direction,amount=case
        outside=outside and all(c.getpixel((x,y))==(85,85,85)
             for y in range(240) for x in range(320)
             if not (left<=x<=right and top<=y<=bottom) and not (180<=x<188 and 180<=y<188))
        results.append({'case':case,'different_pixels':different,'marker_present':marker,'outside_unchanged':outside,
                        'pass':different==0 and marker and outside})
    report={'scope':__doc__,'cases':len(cases),'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Native viewport/scroll exact pixels pass:',len(cases),'poses')

if __name__=='__main__':main()
