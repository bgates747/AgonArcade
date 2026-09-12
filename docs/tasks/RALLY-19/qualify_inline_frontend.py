"""Audit the stack-fix frontend's preserved controls, native input and MOS exit.

Retains R19-09's checks and adds the explicit qualified-inline asset bridge.
This does not qualify timing, long stability or physical hardware behavior.
"""
from pathlib import Path
import csv,json
from argparse import ArgumentParser
from profile import TASK
from native_run import sha
from frontend_bridge import verify

def main():
    p=ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    destination=TASK/'evidence/golem-frontend'/(a.name+'-qualification.json')
    assert not destination.exists()
    evidence={};runs=[];build_identity=None
    def record(path):evidence[str(path.relative_to(TASK))]=sha(path);return path
    def read(path):return json.loads(record(path).read_text())
    old=record(TASK/'.work/oracle/src/main.cpp').read_text()
    new=record(TASK/'frontend.cpp').read_text()
    # Preserve input snapshots, arming, demo/manual steering, held grip, elapsed
    # physics and traffic exactly. Renderer dispatch starts after this block.
    block=lambda s:s.split('        for(unsigned i=0;i<16;++i) heldKeys[i]=vdp_getKeyMap(i);',1)[1].split('        uint32_t physicsEnd=',1)[0]
    assert block(old)==block(new)
    hud=lambda s:s.split('        char hud[41];',1)[1].split('        vdp_swap();',1)[0]
    assert hud(old)==hud(new)
    host=read(TASK/'evidence/golem-frontend-state/initial/results.json')
    assert host['pass'] and host['cases']==638 and all(r['pass'] for r in host['results'])
    for path,digest in host['source_hashes'].items():assert sha(Path(path))==digest,path
    record(TASK/'evidence/golem-frontend-state/initial/input.dat')
    record(TASK/'evidence/golem-frontend-state/initial/output.dat')
    for track in ['oval','fuji']:
        for case in ['demo','right','left','takeover','autosteer','oracle']:
            root=TASK/'evidence/golem-frontend'/f'{case}-{track}-{a.name}'
            inputs=read(root/'inputs.json');saved=read(root/'results.json')
            assert inputs['case']==case and inputs['track']==track
            build=inputs['build']
            if build_identity is None:
                build_identity=build
                _,selected,bridge=verify(Path(build['work']),allow_inline=True)
                assert selected==build
            assert build==build_identity
            for path,digest in {**inputs['source_hashes'],**build['source_hashes'],**build['outputs']}.items():
                assert sha(Path(path))==digest,path
            manifest=read(root/'capture/manifest.json')
            assert manifest['headless'] and manifest['runtime_inputs_unchanged'] and not manifest['timed_out']
            assert manifest['capture_source_sha256']==sha(TASK/'visual_capture_frontend.c')
            assert manifest['capture_harness_sha256']==sha(TASK/'capture_frontend.py')
            events=record(root/'capture/events.txt').read_text()
            for action in manifest['schedule'].splitlines():
                words=action.split();kind,frame=words[:2]
                if kind=='key':expected=f'key frame={frame} name={words[2]} down={int(words[3]=="down")} '
                else:expected=f'{kind} frame={frame} '
                assert events.count(expected)==1,(root,expected)
            assert 'error ' not in events
            for capture in manifest['captures']:
                assert sha(record(root/'capture'/capture['file']))==capture['sha256']
            for report in manifest['guest_reports']:
                assert sha(record(root/'capture'/report['file']))==report['sha256']
            def guest(name):
                rows=list(csv.DictReader((root/'capture'/('guest-'+name+'.csv')).read_text().splitlines()))
                assert len(rows)==1
                return {k:int(v) for k,v in rows[0].items()}
            play=guest('play-result');renderer={}
            assert play['demo']==0 and play['frames']>0 and play['position']>0 and 0<play['speed']<=300
            if case!='oracle':
                renderer=guest('golem-result')
                assert renderer['state_invalid']==0 and renderer['cleanup_ok']==1
                assert renderer['frames']==play['frames'] and renderer['scene_bytes']==97*play['frames']
                assert renderer['track']==int(track=='fuji')
                if case in ['right','autosteer']:assert play['steering']==21 and renderer['grip']==200
                if case=='left':assert play['steering']==-21 and renderer['grip']==25
                if case=='takeover':assert play['steering']<0 and 25<=renderer['grip']<=200
            assert saved['pass'] and all(saved['checks'].values()) and saved['play']==play and saved['renderer']==renderer
            runs.append({'track':track,'case':case,'play':play,'renderer':renderer})
    report={'scope':__doc__,'pass':True,'native_runs':12,'host_state_records':638,
            'accepted_input_physics_and_HUD_source_unchanged':True,'audit_sha256':sha(Path(__file__)),
            'build':build_identity,'runs':runs,'evidence':evidence,'bridge':bridge,
            'failures_retained':['demo-oval','startup-diagnostic'],
            'remaining':'Final performance/stability audit, physical stock compatibility and R19-12 delivery.'}
    destination.write_text(json.dumps(report,indent=2)+'\n')
    print('Frontend audit passes:12 native runs,638 host records, unchanged input/physics/HUD source')

if __name__=='__main__':main()
