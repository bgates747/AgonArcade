"""Full native scenery, road and vehicles against the untouched accepted oracle.

Background is included using the frozen region metric; each renderer supplies
its own geometry mask. Scenery commands in the reference retain original behavior.
"""
from argparse import ArgumentParser,Namespace
from pathlib import Path
import copy,csv,hashlib,json,struct,subprocess,shutil
from profile import TASK,prepare
from native_run import GOLEM,sha
from capture import capture
from scene_masks import game_image,masks
from visual_metric import compare,road_geometry
from vehicle_reference import cases,admitted
from build_scenery_draw import build
from fixtures import encoded

def history_cases(track):
    base=next(c for c in cases() if c['track']==track)
    proof=json.loads((TASK/'evidence/golem-scenery-history/host-proof/results.json').read_text())
    row=next(r for r in proof['tracks'] if r['track']==track);assert proof['pass'] and row['bearings']==1024
    headings=[0,0,1,2,3,4,1023,0,255,256,511,512,767,768,1023,1022,767,766,511,510,255,254,0,1023]
    for delta in [-512,-256,-255,-1,0,1,255,256,511]:headings.extend([0,0,delta%1024,delta%1024])
    result=[]
    for i,heading in enumerate(headings):
        c=copy.deepcopy(base);c['name']=f'{track}-scenery-sequence-{i}';c['tags']=['scenery-history-sequence']
        position=row['positions'][heading];c['player'].update(position=position,phase=position%8000)
        c['input_sha256']=hashlib.sha256(encoded(c)).hexdigest();result.append(c)
    return result

def render(root,track,variant,selected,frames_per_pose):
    work=TASK/'.work/scenery-visual'/root.name/variant;(work/'src').mkdir(parents=True,exist_ok=False)
    shutil.copy2(TASK/'scenery_loader.cpp',work/'src/main.cpp');shutil.copy2(GOLEM/'examples/native_admission/main.cpp',work/'src/transport.inc')
    flags=' -DVEHICLE_ORACLE' if variant=='oracle' else ''
    flags+=f' -DSCENERY_FRAMES_PER_POSE={frames_per_pose}'
    if track=='fuji':flags+=' -DVEHICLE_FUJI'
    (work/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text()+f'\nCXXFLAGS += -I{TASK/".work/oracle/include"} -I{TASK}{flags}\n')
    with (root/(variant+'-build.txt')).open('w') as log:
        if variant=='candidate':
            source=build(track,work)
            subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source),str(work/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
            shutil.copy2(source,root/'kernel.golem');shutil.copy2(work/'program.bin.map',root/'program.map')
        subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    profile=prepare(TASK/'.emulator'/('scenery-visual-'+root.name+'-'+variant),work/'bin/probe.bin','');app=profile/'sdcard/rally'
    if variant=='candidate':(app/'program.bin').symlink_to(work/'program.bin')
    (app/'poses.dat').write_bytes(struct.pack('<H',len(selected))+b''.join(admitted(c,frames_per_pose*i) for i,c in enumerate(selected)))
    frames=[30+180*i for i in range(len(selected))]
    keys=[f'right:{90+180*i}:{95+180*i}' for i in range(len(selected)-1)]+[f'escape:{frames[-1]+20}:{frames[-1]+25}']
    scene_names=[f'scene-{i:02d}.csv' for i in range(len(selected))]
    capture(Namespace(profile=profile,output=root/variant,ready_file=app/'ready.viz',expect_file=[app/'exit.viz',*[app/n for n in scene_names]],frames=','.join(map(str,frames)),keys=','.join(keys),quit_frame=frames[-1]+40,timeout=210))
    assert (root/variant/'guest-exit.viz').read_text().strip()=='0'
    output=[]
    for frame,name in zip(frames,scene_names):
        image_path=root/variant/f'frame-{frame:06d}.png';scene_path=root/variant/('guest-'+name)
        image=game_image(image_path);mask=masks(scene_path,image_path);mask.save(image_path.with_name(image_path.stem+'-mask.png'))
        rows=list(csv.reader(scene_path.read_text().splitlines()))
        output.append((image,mask,rows))
    return output

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval')
    p.add_argument('--offset',type=int,default=0);p.add_argument('--limit',type=int,default=8)
    p.add_argument('--single-frame',action='store_true');p.add_argument('--history',action='store_true');a=p.parse_args()
    selected=(history_cases(a.track) if a.history else [c for c in cases() if c['track']==a.track])[a.offset:a.offset+a.limit]
    assert 0<len(selected)<=8;frames_per_pose=1 if a.single_frame else 2
    root=TASK/'evidence/golem-scenery-visual'/a.name;root.mkdir(parents=True,exist_ok=False)
    paths=[Path(__file__),TASK/'scenery_loader.cpp',TASK/'scene_masks.py',TASK/'visual_metric.py',TASK/'build_scenery_draw.py',TASK/'build_scenery_history.py',TASK/'build_scenery_heading.py',GOLEM/'src/hosted.hpp',GOLEM/'examples/native_admission/main.cpp']
    paths+=sorted((TASK/'.work/oracle/include').glob('*.hpp'))
    (root/'inputs.json').write_text(json.dumps({'scope':__doc__,'track':a.track,'frames_per_pose':frames_per_pose,'cases':selected,'source_hashes':{str(p):sha(p) for p in paths}},indent=2)+'\n')
    expected=render(root,a.track,'oracle',selected,frames_per_pose);bridges=[]
    for case,(image,mask,rows) in zip(selected,expected):
        frozen=TASK/'evidence/oracle'/case['name']
        if (frozen/'verified.json').exists():
            metric=compare(game_image(frozen/'frame-000010.png'),image,masks(frozen/'guest-scene.csv',frozen/'frame-000010.png'),mask)
            bridges.append({'case':case['name'],**metric})
    (root/'oracle-bridge.json').write_text(json.dumps({'pass':all(r['pass'] for r in bridges),'results':bridges},indent=2)+'\n')
    assert all(r['pass'] for r in bridges),[r for r in bridges if not r['pass']][:2]
    actual=render(root,a.track,'candidate',selected,frames_per_pose);results=[]
    for case,(ei,em,er),(ai,am,ar) in zip(selected,expected,actual):
        ec=[list(map(int,r[1:])) for r in er if r[0]=='C'];ac=[list(map(int,r[1:])) for r in ar if r[0]=='C']
        player=er[0][5:]==ar[0][5:];scenery=er[0][:5]==ar[0][:5]
        geometry=road_geometry([list(map(int,r[1:3])) for r in er if r[0]=='R'],[list(map(int,r[1:3])) for r in ar if r[0]=='R'])
        metric=compare(ei,ai,em,am)
        results.append({'case':case['name'],'pass':ec==ac and player and scenery and geometry['pass'] and metric['pass'],
                        'scenery_state_pass':scenery,'car_geometry_pass':ec==ac,'player_geometry_pass':player,'geometry':geometry,'pixels':metric})
    report={'scope':__doc__,'cases':len(selected),'pass':all(r['pass'] for r in results),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:2]
    print('Native full-scene image qualification passes:',len(selected),'cases')

if __name__=='__main__':main()
