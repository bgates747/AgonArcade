"""Native admitted road and cars, with independent geometry masks per renderer.

Use the frozen per-object RGB metric. Background/scenery is deliberately fixed
and excluded here; R19-09 owns that region. Fresh direct-command oracle car/road
images must first agree with the original frozen native captures where available.
"""
from argparse import ArgumentParser,Namespace
from pathlib import Path
import csv,json,struct,subprocess,shutil
from profile import TASK,prepare
from native_run import GOLEM,sha
from capture import capture
from scene_masks import game_image,masks
from visual_metric import compare,road_geometry
from vehicle_reference import cases,admitted
from build_vehicle_draw import build

def foreground(mask):return mask.point([0 if x==1 else x for x in range(256)])

def render(root,track,variant,selected):
    work=TASK/'.work/vehicle-visual'/root.name/variant;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copy2(TASK/'vehicle_loader.cpp',work/'src/main.cpp');shutil.copy2(GOLEM/'examples/native_admission/main.cpp',work/'src/transport.inc')
    flags=' -DVEHICLE_ORACLE' if variant=='oracle' else ''
    if track=='fuji':flags+=' -DVEHICLE_FUJI'
    (work/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text()+f'\nCXXFLAGS += -I{TASK/".work/oracle/include"} -I{TASK}{flags}\n')
    with (root/(variant+'-build.txt')).open('w') as log:
        if variant=='candidate':
            source=build(track,work)
            subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source),str(work/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
            shutil.copy2(source,root/'kernel.golem');shutil.copy2(work/'program.bin.map',root/'program.map')
        subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    profile=prepare(TASK/'.emulator'/('vehicle-visual-'+root.name+'-'+variant),work/'bin/probe.bin','');app=profile/'sdcard/rally'
    if variant=='candidate':(app/'program.bin').symlink_to(work/'program.bin')
    (app/'poses.dat').write_bytes(struct.pack('<H',len(selected))+b''.join(admitted(c,2*i) for i,c in enumerate(selected)))
    frames=[30+180*i for i in range(len(selected))]
    keys=[f'right:{90+180*i}:{95+180*i}' for i in range(len(selected)-1)]+[f'escape:{frames[-1]+20}:{frames[-1]+25}']
    scene_names=[f'scene-{i:02d}.csv' for i in range(len(selected))]
    capture(Namespace(profile=profile,output=root/variant,ready_file=app/'ready.viz',expect_file=[app/'exit.viz',*[app/n for n in scene_names]],frames=','.join(map(str,frames)),keys=','.join(keys),quit_frame=frames[-1]+40,timeout=210))
    assert (root/variant/'guest-exit.viz').read_text().strip()=='0'
    output=[]
    for frame,name in zip(frames,scene_names):
        image_path=root/variant/f'frame-{frame:06d}.png';scene_path=root/variant/('guest-'+name)
        image=game_image(image_path);mask=foreground(masks(scene_path,image_path));mask.save(image_path.with_name(image_path.stem+'-mask.png'))
        rows=list(csv.reader(scene_path.read_text().splitlines()))
        output.append((image,mask,rows))
    return output

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval')
    p.add_argument('--offset',type=int,default=0);p.add_argument('--limit',type=int,default=24);a=p.parse_args()
    selected=[c for c in cases() if c['track']==a.track][a.offset:a.offset+a.limit];assert 0<len(selected)<=40
    root=TASK/'evidence/golem-vehicle-visual'/a.name;root.mkdir(parents=True,exist_ok=False)
    paths=[Path(__file__),TASK/'vehicle_loader.cpp',TASK/'scene_masks.py',TASK/'visual_metric.py',TASK/'build_vehicle_draw.py',TASK/'build_vehicle_projection.py',GOLEM/'src/hosted.hpp',GOLEM/'examples/native_admission/main.cpp']
    paths+=sorted((TASK/'.work/oracle/include').glob('*.hpp'))
    (root/'inputs.json').write_text(json.dumps({'scope':__doc__,'track':a.track,'cases':selected,'source_hashes':{str(p):sha(p) for p in paths}},indent=2)+'\n')
    expected=render(root,a.track,'oracle',selected);bridges=[]
    for case,(image,mask,rows) in zip(selected,expected):
        frozen=TASK/'evidence/oracle'/case['name']
        if (frozen/'verified.json').exists():
            metric=compare(game_image(frozen/'frame-000010.png'),image,foreground(masks(frozen/'guest-scene.csv',frozen/'frame-000010.png')),mask)
            bridges.append({'case':case['name'],**metric})
    (root/'oracle-bridge.json').write_text(json.dumps({'pass':all(r['pass'] for r in bridges),'results':bridges},indent=2)+'\n')
    assert all(r['pass'] for r in bridges),[r for r in bridges if not r['pass']][:2]
    actual=render(root,a.track,'candidate',selected);results=[]
    for case,(ei,em,er),(ai,am,ar) in zip(selected,expected,actual):
        ec=[list(map(int,r[1:])) for r in er if r[0]=='C'];ac=[list(map(int,r[1:])) for r in ar if r[0]=='C']
        player=er[0][5:]==ar[0][5:]
        geometry=road_geometry([list(map(int,r[1:3])) for r in er if r[0]=='R'],[list(map(int,r[1:3])) for r in ar if r[0]=='R'])
        metric=compare(ei,ai,em,am)
        results.append({'case':case['name'],'pass':ec==ac and player and geometry['pass'] and metric['pass'],
                        'car_geometry_pass':ec==ac,'player_geometry_pass':player,'geometry':geometry,'pixels':metric})
    report={'scope':__doc__,'cases':len(selected),'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:2]
    print('Native car/road image qualification passes:',len(selected),'cases')

if __name__=='__main__':main()
