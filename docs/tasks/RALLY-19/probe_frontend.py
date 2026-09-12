"""Headless interactive frontend validation; captures are not performance data."""
from argparse import ArgumentParser,Namespace
from pathlib import Path
import csv,json
from profile import TASK,prepare
from native_run import sha
from capture_frontend import capture

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--build',required=True)
    p.add_argument('--track',choices=['oval','fuji'],required=True)
    p.add_argument('--case',choices=['demo','right','left','takeover','autosteer','oracle'],required=True);a=p.parse_args()
    work=TASK/'.work/frontend'/a.build;build=json.loads((work/'manifest.json').read_text())
    for file,digest in build['outputs'].items():assert sha(Path(file))==digest,file
    root=TASK/'evidence/golem-frontend'/a.name;root.mkdir(parents=True,exist_ok=False)
    if a.case in ['demo','oracle']:
        args=a.track+(' oracle' if a.case=='oracle' else '')
        frames='30,70';keys='escape:40:46,escape:100:106';quit_frame=140
    elif a.case in ['right','autosteer']:
        args=a.track+' race'+(' autosteer' if a.case=='autosteer' else '')
        frames='30,100,150';keys='up:10:160,right:20:100,equals:30:100,escape:180:186';quit_frame=220
    elif a.case=='left':
        args=a.track+' race';frames='30,100,150'
        keys='up:10:160,left:20:100,minus:30:100,escape:180:186';quit_frame=220
    else:
        args=a.track+' demo';frames='30,90,150'
        keys='space:35:41,up:45:165,right:55:100,left:110:145,equals:60:120,minus:135:155,escape:190:196';quit_frame=230
    profile=prepare(TASK/'.emulator'/('frontend-'+a.name),work/'bin/rally.bin',args);app=profile/'sdcard/rally'
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr']:(app/(track+ext)).symlink_to(work/(track+ext))
    expected=[app/'exit.viz',app/'play-result.csv']
    if a.case!='oracle':expected.append(app/'golem-result.csv')
    (root/'inputs.json').write_text(json.dumps({'scope':__doc__,'case':a.case,'track':a.track,'arguments':args,'build':build,
            'source_hashes':{str(p):sha(p) for p in [Path(__file__),TASK/'capture_frontend.py',TASK/'visual_capture_frontend.c']}},indent=2)+'\n')
    capture(Namespace(profile=profile,output=root/'capture',ready_file=app/'play-ready.viz',expect_file=expected,
                      frames=frames,keys=keys,quit_frame=quit_frame,timeout=180))
    rows=list(csv.DictReader((root/'capture/guest-play-result.csv').read_text().splitlines()));assert len(rows)==1
    play={k:int(v) for k,v in rows[0].items()};checks={'takeover_or_race':play['demo']==0,'frames':play['frames']>0,
                                                  'progress':play['position']>0,'speed':0<play['speed']<=300}
    renderer={}
    if a.case!='oracle':
        rows=list(csv.DictReader((root/'capture/guest-golem-result.csv').read_text().splitlines()));assert len(rows)==1
        renderer={k:int(v) for k,v in rows[0].items()}
        checks.update(state_valid=renderer['state_invalid']==0,cleanup=renderer['cleanup_ok']==1,
                      frame_count=renderer['frames']==play['frames'],scene_bytes=renderer['scene_bytes']==97*renderer['frames'],
                      track=renderer['track']==int(a.track=='fuji'))
        if a.case in ['right','autosteer']:checks.update(held_steering=play['steering']==21,grip_increase=renderer['grip']==200)
        if a.case=='left':checks.update(held_steering=play['steering']==-21,grip_decrease=renderer['grip']==25)
        if a.case=='takeover':checks.update(steering_reversed=play['steering']<0,grip_range=25<=renderer['grip']<=200)
    report={'scope':__doc__,'case':a.case,'track':a.track,'pass':all(checks.values()),'checks':checks,'play':play,'renderer':renderer}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],report
    print('Headless frontend controls pass:',a.track,a.case,play,renderer)

if __name__=='__main__':main()
