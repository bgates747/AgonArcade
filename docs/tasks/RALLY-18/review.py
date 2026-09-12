"""Prepare or launch the isolated RALLY-18 game for human review."""
import argparse,json,os,subprocess
from pathlib import Path
import build as b
from bench import prepare

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--track',choices=('oval','fuji'),default='oval');p.add_argument('--orientation',choices=('control','perspective'),default='perspective');p.add_argument('--prepare-all',action='store_true');p.add_argument('--launch',action='store_true');a=p.parse_args()
    b.protect();state=json.loads(b.STATE.read_text());info=state['variants']['lookup'];assert b.sha(Path(info['root'])/'bin/rally.bin')==info['sha256']
    base=b.TASK/'.emulator';base.mkdir(exist_ok=True)
    pairs=[(t,o) for t in ('oval','fuji') for o in ('control','perspective')] if a.prepare_all else [(a.track,a.orientation)]
    profiles=[]
    for track,orientation in pairs:
        profile=base/f'review-{track}-{orientation}'
        if profile.exists():
            # Keep old profiles reviewable and never modify a running profile.
            import tempfile
            profile=Path(tempfile.mkdtemp(prefix=f'review-{track}-{orientation}-',dir=base))
        prepare(info,profile,track,'demo fence'+(' perspective' if orientation=='perspective' else ''))
        profiles.append({'track':track,'orientation':orientation,'profile':str(profile)});print('Ready:',profile)
    result=b.TASK/'review-profiles.json';result.write_text(json.dumps({'binary':info,'profiles':profiles},indent=2)+'\n')
    if a.launch:
        target=next(x for x in profiles if x['track']==a.track and x['orientation']==a.orientation)
        env=os.environ.copy()
        for name in ('SDL_VIDEODRIVER','SDL_AUDIODRIVER','DYLD_INSERT_LIBRARIES','LD_PRELOAD','BASH_ENV','RALLY_STOCK_VDP','RALLY_SINK_DIR','RALLY_SINK_MODE'):env.pop(name,None)
        with (b.WORK/'review-launch.log').open('w') as log:
            process=subprocess.Popen(['./fab-agon-emulator','--renderer','sw'],cwd=target['profile'],env=env,stdin=subprocess.DEVNULL,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        (b.WORK/'review-process.json').write_text(json.dumps({'pid':process.pid,**target},indent=2)+'\n');print('Launched PID',process.pid)
    b.protect()
if __name__=='__main__':main()
