"""Run bounded RALLY-18 native visual comparisons and optional control checks."""
from pathlib import Path
import argparse
import csv
import io
import json
import subprocess
import sys
import tempfile

import build as b
from bench import prepare
from compare_scene import compare as compare_host_scene

TASK=b.TASK


def scene_case(track,pose,lateral=0,perspective=False,steering=0):
    side=('m'+str(-lateral)) if lateral<0 else str(lateral)
    name=f'{track}-p{pose:02d}-l{side}-s{steering}-'+('perspective' if perspective else 'control')
    return dict(name=name,track=track,pose=pose,lateral=lateral,steering=steering,perspective=perspective)


def case_plan(args):
    scenes=[scene_case('oval',0,-35),scene_case('oval',0),scene_case('oval',0,35),
            scene_case('fuji',16,-35),scene_case('fuji',16,35,True),scene_case('fuji',63)]
    if args.extended:
        scenes += [scene_case('oval',16),scene_case('oval',63),
                   scene_case('oval',0,-35,True),scene_case('oval',0,35,True),
                   scene_case('fuji',0,-35),scene_case('fuji',0),scene_case('fuji',0,35),
                   scene_case('fuji',16,-35,True),scene_case('fuji',16,35),
                   scene_case('oval',16,70),scene_case('fuji',16,-70,True)]
    if args.quick:scenes=[scene_case('fuji',16)]
    if args.mode=='controls':scenes=[]
    controls=[] if args.mode=='snapshots' else [dict(track='oval',perspective=False),dict(track='fuji',perspective=True)]
    return dict(scenes=scenes,controls=controls,snapshot_runs=len(scenes)*2,control_runs=len(controls))


def read_scene(path):
    rows=list(csv.reader(io.StringIO(path.read_text())))
    if not rows or len(rows[0])!=9:raise RuntimeError(f'Invalid scene header: {path}')
    header=[int(v) for v in rows[0]]
    roads=[];cars=[]
    for row in rows[1:]:
        if row[0]=='R' and len(row)==4:roads.append([int(v) for v in row[1:]])
        elif row[0]=='C' and len(row)==7:cars.append([int(v) for v in row[1:]])
        else:raise RuntimeError(f'Invalid scene record: {path}: {row}')
    if len(cars)!=header[8] or not roads or roads[0][0]!=104 or roads[-1][0]!=224:
        raise RuntimeError(f'Incomplete scene: {path}')
    return dict(header=header,roads=roads,cars=cars)


def pixel_mask(a,b):
    from PIL import ImageChops
    difference=ImageChops.difference(a,b)
    channels=difference.split()
    maximum=ImageChops.lighter(ImageChops.lighter(channels[0],channels[1]),channels[2])
    return difference,maximum.point(lambda value:255 if value else 0)


def unmatched_nearby(a,b,radius=2):
    """Color displacement diagnostic; not an independent road-geometry proof."""
    from PIL import Image,ImageChops,ImageDraw
    w,h=a.size;matched=Image.new('L',a.size,0)
    for dy in range(-radius,radius+1):
        for dx in range(-radius,radius+1):
            shifted=Image.new('RGB',a.size);shifted.paste(b,(dx,dy))
            _,different=pixel_mask(a,shifted)
            same=ImageChops.invert(different)
            valid=Image.new('L',a.size,0)
            ImageDraw.Draw(valid).rectangle((max(0,dx),max(0,dy),min(w,w+dx)-1,min(h,h+dy)-1),fill=255)
            matched=ImageChops.lighter(matched,ImageChops.darker(same,valid))
    return ImageChops.invert(matched)


def compare_pair(live,lookup,output):
    from PIL import Image,ImageChops
    output.mkdir()
    a=Image.open(live/'frame-000010.png').convert('RGB')
    z=Image.open(lookup/'frame-000010.png').convert('RGB')
    if a.size!=z.size:raise RuntimeError('Native scanout sizes differ')
    difference,mask=pixel_mask(a,z)
    difference.save(output/'difference.png');mask.save(output/'changed-mask.png')
    near_a=unmatched_nearby(a,z);near_z=unmatched_nearby(z,a)
    near=ImageChops.lighter(near_a,near_z);near.save(output/'unmatched-within-2-native-pixels.png')
    state_a=read_scene(live/'guest-scene.csv');state_z=read_scene(lookup/'guest-scene.csv')
    if [r[::2] for r in state_a['roads']]!=[r[::2] for r in state_z['roads']]:
        raise RuntimeError('Section boundary rows or material patterns differ')
    error=max(abs(a[1]-z[1]) for a,z in zip(state_a['roads'],state_z['roads']))
    if error>256:raise RuntimeError(f'Sampled road centre error exceeds one pixel: {error}/256')
    if state_a['header'][:5]!=state_z['header'][:5] or len(state_a['cars'])!=len(state_z['cars']):
        raise RuntimeError('Scenery history or visible traffic count differs')
    metrics={'native_size':a.size,'different_pixels':mask.histogram()[255],
             'different_pixel_fraction':mask.histogram()[255]/(a.width*a.height),
             'maximum_channel_difference':max(top for _,top in difference.getextrema()),
             'difference_bounds':mask.getbbox(),
             'unmatched_colors_within_2_native_pixels':near.histogram()[255],
             'neighborhood_scope':'Exact RGB color existence in either direction within a 5x5 native neighborhood; diagnostic only',
             'section_boundary_count':len(state_a['roads']),'maximum_saved_centre_error_q8':error,
             'maximum_saved_centre_error_pixels':error/256,
             'player_state_live':state_a['header'][5:8],'player_state_lookup':state_z['header'][5:8],
             'traffic_state_differences':[dict(index=i,live=x,lookup=y)
                 for i,(x,y) in enumerate(zip(state_a['cars'],state_z['cars'])) if x!=y],
             'acceptance_scope':'No full-frame exact-pixel requirement. Saved endpoints are checked; exhaustive table/trapezoid geometry validation is separate.'}
    (output/'comparison.json').write_text(json.dumps(metrics,indent=2)+'\n')
    return metrics


def check_builds(state):
    for variant in ('live','lookup'):
        info=state['variants'][variant];root=Path(info['root'])
        if b.sha(root/'bin/rally.bin')!=info['sha256'] or b.sha(root/'src/main.cpp')!=info['source_sha256']:
            raise RuntimeError(f'{variant}: build identity changed')
        for header in TASK.glob('*.hpp'):
            if not (root/'include'/header.name).is_file() or b.sha(root/'include'/header.name)!=b.sha(header):
                raise RuntimeError(f'{variant}: stale task header {header.name}; rebuild before captures')


def run_capture(profile,output,ready,frames,keys,quit_frame,reports,timeout):
    command=[sys.executable,str(TASK/'capture.py'),'--profile',str(profile),'--output',str(output),
             '--ready-file',str(profile/'sdcard/rally'/ready),'--frames',frames,'--keys',keys,
             '--quit-frame',str(quit_frame),'--timeout',str(timeout)]
    for report in reports:command += ['--expect-file',str(profile/'sdcard/rally'/report)]
    subprocess.run(command,check=True)
    return json.loads((output/'manifest.json').read_text())


def controls_case(state,profile,output,case,timeout):
    options='demo fence'+(' perspective' if case['perspective'] else '')
    prepare(state['variants']['lookup'],profile,case['track'],options)
    run_capture(profile,output,'play-ready.viz','30,90,170',
                        'space:10:16,up:20:200,right:40:80,left:110:150,escape:220:226',260,
                        ('exit.viz','play-result.csv'),timeout)
    rows=list(csv.DictReader(io.StringIO((output/'guest-play-result.csv').read_text())))
    if len(rows)!=1:raise RuntimeError('Expected exactly one gameplay result row')
    row={key:int(value) for key,value in rows[0].items()}
    if not (row['demo']==0 and row['frames']>0 and row['position']>0 and row['speed']>0):
        raise RuntimeError(f'Demo takeover/progress evidence failed: {row}')
    result={**case,'variant':'lookup','guest':row,'capture':str(output),
            'exit_report_verified':True,
            'scope':'Guest confirms demo takeover, progress and exit; inspect the three images for steering and lateral placement.'}
    (output/'control-result.json').write_text(json.dumps(result,indent=2)+'\n')
    return result


def invariance_checks(records):
    groups={}
    for record in records:
        for variant in ('live','lookup'):
            key=(record['track'],record['pose'],variant)
            scene=read_scene(Path(record['captures'][variant])/'guest-scene.csv')
            groups.setdefault(key,[]).append((record,scene))
    results=[]
    for (track,pose,variant),scenes in groups.items():
        if len(scenes)<2:continue
        reference=scenes[0][1]['roads']
        if any(scene['roads']!=reference for _,scene in scenes):
            raise RuntimeError(f'Road changes with lateral/steering/orientation input: {track} {pose} {variant}')
        controls=sorted((record['lateral'],scene['header'][7]) for record,scene in scenes if not record['perspective'])
        if any(x2<=x1 for (l1,x1),(l2,x2) in zip(controls,controls[1:]) if l2>l1):
            raise RuntimeError('Player screen X does not increase with lateral position')
        results.append(dict(track=track,pose=pose,variant=variant,scene_count=len(scenes),
                            road_state_identical=True,control_lateral_player_x=controls))
    return results


def run(args):
    plan=case_plan(args)
    if args.plan:
        print(json.dumps(plan,indent=2));return
    b.protect();state=json.loads(b.STATE.read_text());check_builds(state)
    base=TASK/'visual-results';base.mkdir(exist_ok=True)
    if args.output:
        output=args.output.resolve()
        if not output.is_relative_to(TASK):raise RuntimeError('Keep output in the RALLY-18 task bucket')
        output.mkdir(parents=True,exist_ok=False)
    else:output=Path(tempfile.mkdtemp(prefix='run-',dir=base))
    profile_base=TASK/'.emulator';profile_base.mkdir(exist_ok=True)
    profiles=Path(tempfile.mkdtemp(prefix='visuals-',dir=profile_base))
    manifest={'purpose':'headless native visual/input validation, excluded from performance evidence',
              'plan':plan,'profiles':str(profiles),'builds':state,'scenes':[],'controls':[],
              'sources':{p.name:b.sha(p) for p in (Path(__file__),TASK/'capture.py',TASK/'visual_capture_macos.c')},
              'data':{p.name:b.sha(p) for p in (TASK/'data').glob('*.road')}}
    def save(): (output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    save();print('Visual evidence:',output,flush=True)
    for case in plan['scenes']:
        captures={}
        options=f'snapshot pose={case["pose"]} lateral={case["lateral"]} steering={case["steering"]}'
        if case['perspective']:options+=' perspective'
        for variant in ('live','lookup'):
            name=case['name']+'-'+variant;profile=profiles/name;destination=output/name
            prepare(state['variants'][variant],profile,case['track'],options)
            run_capture(profile,destination,'ready.viz','10','escape:20:26',50,
                        ('exit.viz','scene.csv'),args.timeout)
            host=compare_host_scene(destination/'guest-scene.csv',variant,case['track'],case['perspective'],
                                    (case['pose'],case['lateral'],case['steering']))
            (destination/'host-scene-comparison.json').write_text(json.dumps(host,indent=2)+'\n')
            if not host['exact_match']:raise RuntimeError(f'Guest snapshot state differs from host: {destination}')
            captures[variant]=str(destination)
            b.protect();check_builds(state)
        comparison=compare_pair(Path(captures['live']),Path(captures['lookup']),output/(case['name']+'-comparison'))
        manifest['scenes'].append({**case,'captures':captures,'comparison':comparison});save()
    manifest['camera_invariance']=invariance_checks(manifest['scenes']);save()
    for case in plan['controls']:
        name='controls-'+case['track']+'-'+('perspective' if case['perspective'] else 'control')
        result=controls_case(state,profiles/name,output/name,case,args.timeout)
        manifest['controls'].append(result);save();b.protect();check_builds(state)
    manifest['status']='automated capture/state/input checks passed; human image review remains separate'
    save();(b.WORK/'latest-visuals.json').write_text(json.dumps({'results':str(output),'profiles':str(profiles)},indent=2)+'\n')
    print('Visual checks complete:',output,flush=True)


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--mode',choices=('snapshots','controls','all'),default='snapshots')
    parser.add_argument('--quick',action='store_true',help='Only one paired Fuji curve snapshot')
    parser.add_argument('--extended',action='store_true',help='Additional track/pose/orientation and grass captures')
    parser.add_argument('--output',type=Path,help='New task-local results directory')
    parser.add_argument('--timeout',type=float,default=120,help='Maximum seconds per headless emulator run')
    parser.add_argument('--plan',action='store_true',help='Print cases without preparing profiles or launching anything')
    run(parser.parse_args())
