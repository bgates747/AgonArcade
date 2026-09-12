"""Headless native R19-06 section images, independent geometry/masks per renderer.

Diagnostic raw input is position/phase/lateral. Lateral is deliberately unused:
the frozen camera follows the centreline. No host corners reach the candidate.
"""
from pathlib import Path
from argparse import ArgumentParser,Namespace
import json,struct,shutil,subprocess
from profile import TASK,prepare
from native_run import GOLEM,sha
from build_section_kernel import build
from capture import capture
from scene_masks import game_image
from visual_metric import compare
from PIL import Image

def poses(track):
    fixed=json.loads((TASK/'fixtures.json').read_text())['cases']+json.loads((TASK/'fixtures-bends.json').read_text())['cases']
    cases=[(p['player']['position'],p['player']['phase'],p['player']['lateral']) for p in fixed if p['track']==track]
    lap=(90 if track=='oval' else 512)*6400
    cases.extend((pos,phase,lat) for pos,phase,lat in [(0,3999,-38400),(0,4000,38400),(lap-1,7999,0),(1,0,0)])
    return cases

def mask(image,geometry):
    cxTop,cxBottom,top,bottom,paint=geometry
    result=Image.new('L',(320,240),1)
    for y in range(max(0,top),min(239,bottom)+1):
        centre=cxTop+(cxBottom-cxTop)*(y-top)/(bottom-top)
        for x in range(320):
            colour=image.getpixel((x,y));label=1
            if colour==(85,85,85):label=2
            elif colour in [(255,255,255),(255,255,0),(255,0,0)]:
                world=abs(x-centre)*50/(y-96)
                label=5 if world<8 else 4 if world<90 else 3
            result.putpixel((x,y),label)
    return result

def render(root,track,variant,cases):
    buildRoot=TASK/'.work/section-visual'/root.name/(track+'-'+variant)
    (buildRoot/'src').mkdir(parents=True,exist_ok=False)
    shutil.copy2(TASK/'section_loader.cpp',buildRoot/'src/main.cpp')
    shutil.copy2(GOLEM/'examples/native_admission/main.cpp',buildRoot/'src/transport.inc')
    flags=' -DSECTION_ORACLE' if variant=='oracle' else ''
    if track=='fuji':flags+=' -DSECTION_FUJI'
    (buildRoot/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text()+f'\nCXXFLAGS += -I{TASK/".work/oracle/include"}{flags}\n')
    with (root/(variant+'-build.txt')).open('w') as log:
        if variant=='candidate':
            source=build(track,buildRoot)
            subprocess.run(['make','-C',str(GOLEM/'src')],check=True,stdout=log,stderr=subprocess.STDOUT)
            subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source),str(buildRoot/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
            shutil.copy2(source,root/'kernel.golem');shutil.copy2(buildRoot/'program.bin.map',root/'program.map')
        subprocess.run(['make','-C',str(buildRoot)],check=True,stdout=log,stderr=subprocess.STDOUT)
    profile=prepare(TASK/'.emulator'/('section-visual-'+root.name+'-'+variant),buildRoot/'bin/probe.bin','')
    app=profile/'sdcard/rally'
    if variant=='candidate':(app/'program.bin').symlink_to(buildRoot/'program.bin')
    (app/'poses.dat').write_bytes(struct.pack('<H',len(cases))+b''.join(struct.pack('<iHhi',pos,phase,0,lat) for pos,phase,lat in cases))
    frames=[30+90*i for i in range(len(cases))]
    keys=[f'right:{60+90*i}:{65+90*i}' for i in range(len(cases)-1)]
    keys.append(f'escape:{frames[-1]+20}:{frames[-1]+25}')
    capture(Namespace(profile=profile,output=root/variant,ready_file=app/'ready.viz',expect_file=[app/'exit.viz',app/'geometry.dat'],frames=','.join(map(str,frames)),keys=','.join(keys),quit_frame=frames[-1]+40,timeout=180))
    assert (root/variant/'guest-exit.viz').read_text().strip()=='0'
    geometry=list(struct.iter_unpack('<hhHHH',(root/variant/'guest-geometry.dat').read_bytes()))
    assert len(geometry)==len(cases)
    images=[]
    for frame,entry in zip(frames,geometry):
        path=root/variant/f'frame-{frame:06d}.png';image=game_image(path)
        semantic=mask(image,entry);semantic.save(path.with_name(path.stem+'-mask.png'));images.append((image,semantic))
    return images,geometry

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');p.add_argument('--offset',type=int,default=0);p.add_argument('--limit',type=int,default=35);a=p.parse_args()
    cases=poses(a.track)[a.offset:a.offset+a.limit];assert 0<len(cases)<=40
    root=TASK/'evidence/golem-section-visual'/a.name;root.mkdir(parents=True,exist_ok=False)
    (root/'inputs.json').write_text(json.dumps({'track':a.track,'cases':cases,'source_hashes':{str(path):sha(path) for path in [Path(__file__),TASK/'section_loader.cpp',TASK/'build_section_kernel.py',TASK/'build_projection_kernel.py',GOLEM/'src/hosted.hpp',GOLEM/'examples/native_admission/main.cpp']}},indent=2)+'\n')
    expected,eg=render(root,a.track,'oracle',cases);actual,ag=render(root,a.track,'candidate',cases)
    results=[]
    for pose,(ei,em),(ai,am),e,a in zip(cases,expected,actual,eg,ag):
        metric=compare(ei,ai,em,am);geometry=e[2:]==a[2:] and max(abs(e[i]-a[i]) for i in range(2))<=1
        results.append({'pose':pose,'expected_geometry':e,'actual_geometry':a,'geometry_pass':geometry,'pixels':metric,'pass':geometry and metric['pass']})
    report={'pass':all(r['pass'] for r in results),'scope':__doc__,'cases':len(cases),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Complete native section pixels pass:',len(cases))
if __name__=='__main__':main()
