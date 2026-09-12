"""Full native road-only comparisons for frozen poses plus seams/max-band witnesses.

The road is also checked where cars would normally occlude it. No vehicle or
background acceptance is claimed here. Masks use each renderer's native pixels
and own complete endpoint trace, with the frozen per-material metric.
"""
from pathlib import Path
from argparse import ArgumentParser,Namespace
import json,struct,subprocess,shutil
from PIL import Image,ImageDraw
from profile import TASK,prepare
from native_run import GOLEM,sha
from build_road_kernel import build
from visual_section import poses as section_poses
from road_bounds import proof
from capture import capture
from scene_masks import game_image
from visual_metric import compare,road_geometry
from probe_admission import state,put

def poses(track):
    cases=section_poses(track);w=proof()['tracks'][track]['witness']
    cases.extend([(w['position'],w['phase'],0),(w['position'],w['phase']+4000,0)])
    if track=='fuji':cases.extend([(1836799,3999,0),(1836800,4000,0),(1836801,7999,0)])
    return cases

def mask(image,rows):
    result=Image.new('L',(320,240),1);index=0
    assert rows[0][0]==104 and rows[-1][0]==224
    for y in range(104,224):
        while index+1<len(rows)-1 and y>rows[index+1][0]:index+=1
        a,b=rows[index:index+2];centre=a[1]+(b[1]-a[1])*(y-a[0])/(b[0]-a[0])
        for x in range(320):
            colour=image.getpixel((x,y));label=1
            if colour==(85,85,85):label=2
            elif colour in [(255,255,255),(255,255,0),(255,0,0)]:
                world=abs(x-centre)*50/(y-96);label=5 if world<8 else 4 if world<90 else 3
            result.putpixel((x,y),label)
    ImageDraw.Draw(result).rectangle((0,224,319,239),fill=0);return result

def render(root,track,variant,cases,admitted=False):
    work=TASK/'.work/road-visual'/root.name/variant;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copy2(TASK/'road_loader.cpp',work/'src/main.cpp');shutil.copy2(GOLEM/'examples/native_admission/main.cpp',work/'src/transport.inc')
    flags=' -DROAD_ORACLE' if variant=='oracle' else ''
    if track=='fuji':flags+=' -DROAD_FUJI'
    if admitted:flags+=' -DROAD_ADMITTED'
    (work/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text()+f'\nCXXFLAGS += -I{TASK/".work/oracle/include"}{flags}\n')
    with (root/(variant+'-build.txt')).open('w') as log:
        if variant=='candidate':
            builder=build
            if admitted:
                from build_admitted_road import build as builder
            source=builder(track,work)
            subprocess.run(['make','-C',str(GOLEM/'src')],check=True,stdout=log,stderr=subprocess.STDOUT)
            subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source),str(work/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
            shutil.copy2(source,root/'kernel.golem');shutil.copy2(work/'program.bin.map',root/'program.map')
        subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    profile=prepare(TASK/'.emulator'/('road-visual-'+root.name+'-'+variant),work/'bin/probe.bin','');app=profile/'sdcard/rally'
    if variant=='candidate':(app/'program.bin').symlink_to(work/'program.bin')
    payload=bytearray(struct.pack('<H',len(cases)))
    for i,(pos,phase,lat) in enumerate(cases):
        if admitted:
            record=state(2*i,int(track=='fuji'),pos);put(record,12,2,phase);put(record,16,4,lat);payload+=record
        else:payload+=struct.pack('<iHhi',pos,phase,0,lat)
    (app/'poses.dat').write_bytes(payload)
    frames=[30+180*i for i in range(len(cases))]
    keys=[f'right:{90+180*i}:{95+180*i}' for i in range(len(cases)-1)]+[f'escape:{frames[-1]+20}:{frames[-1]+25}']
    capture(Namespace(profile=profile,output=root/variant,ready_file=app/'ready.viz',expect_file=[app/'exit.viz',app/'geometry.dat'],frames=','.join(map(str,frames)),keys=','.join(keys),quit_frame=frames[-1]+40,timeout=180))
    assert (root/variant/'guest-exit.viz').read_text().strip()=='0'
    raw=(root/variant/'guest-geometry.dat').read_bytes();offset=0;geometry=[]
    for _ in cases:
        count=struct.unpack_from('<H',raw,offset)[0];offset+=2;assert 0<count<=32
        rows=[struct.unpack_from('<HhH',raw,offset+i*6) for i in range(count+1)];offset+=(count+1)*6;geometry.append(rows)
    assert offset==len(raw)
    images=[]
    for frame,rows in zip(frames,geometry):
        path=root/variant/f'frame-{frame:06d}.png';image=game_image(path);semantic=mask(image,rows)
        semantic.save(path.with_name(path.stem+'-mask.png'));images.append((image,semantic))
    return images,geometry

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');p.add_argument('--offset',type=int,default=0);p.add_argument('--limit',type=int,default=30);p.add_argument('--admitted',action='store_true');a=p.parse_args()
    cases=poses(a.track)[a.offset:a.offset+a.limit];assert 0<len(cases)<=40
    root=TASK/'evidence/golem-road-visual'/a.name;root.mkdir(parents=True,exist_ok=False)
    paths=[Path(__file__),TASK/'road_loader.cpp',TASK/'build_road_kernel.py',TASK/'build_packed_section.py',TASK/'build_section_kernel.py',TASK/'build_projection_kernel.py',GOLEM/'src/hosted.hpp',GOLEM/'examples/native_admission/main.cpp']
    if a.admitted:paths.append(TASK/'build_admitted_road.py')
    (root/'inputs.json').write_text(json.dumps({'track':a.track,'admitted':a.admitted,'cases':cases,'source_hashes':{str(path):sha(path) for path in paths}},indent=2)+'\n')
    expected,eg=render(root,a.track,'oracle',cases,a.admitted);actual,ag=render(root,a.track,'candidate',cases,a.admitted)
    results=[]
    for pose,(ei,em),(ai,am),e,a in zip(cases,expected,actual,eg,ag):
        metric=compare(ei,ai,em,am);geometry=road_geometry([[r[0],r[1]*256] for r in e],[[r[0],r[1]*256] for r in a])
        boundaries=[r[0] for r in e]==[r[0] for r in a];materials=[r[2] for r in e[:-1]]==[r[2] for r in a[:-1]]
        results.append({'pose':pose,'expected_geometry':e,'actual_geometry':a,'boundaries_pass':boundaries,'materials_pass':materials,'geometry':geometry,'pixels':metric,'pass':boundaries and materials and geometry['pass'] and metric['pass']})
    report={'scope':__doc__,'cases':len(cases),'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:2]
    print('Full native road pixels pass:',len(cases))
if __name__=='__main__':main()
