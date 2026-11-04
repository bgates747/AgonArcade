"""Prepared two-process smoke gate; no execution authority is implied."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import shutil
import socket
import subprocess
import sys

HERE = Path(__file__).resolve().parent
HUD = HERE.parent.parent
CUSTOM = HUD.parents[1]
ROOT = CUSTOM.parents[3]
INTEGRATION = HERE.parent/'observer-integration'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def preserve(profile,dest):
    artifact=profile/'last-run'
    if artifact.exists():
        for p in artifact.iterdir():
            if p.is_file():
                shutil.copyfile(p,dest/(p.with_suffix('.txt').name if p.suffix=='.log' else p.name))
    for name in ('expected.json','result.json','state.bin','ticks.bin','prt.bin','replies.bin',
                 'stages.csv','player.csv','failure.txt','verified.json'):
        p=profile/'sdcard/rally25'/name
        if p.exists():shutil.copyfile(p,dest/name)


def campaign(name):
    assert name=='hudsmoke02'
    entries=json.loads((HERE/'PROFILES.json').read_text())
    base=load('original_hud_control',HUD/'control.py')
    qualified=load('qualified_startup_runner',INTEGRATION/'runner.py')
    base.stop=qualified.stop
    sys.path.insert(0,str(HERE))
    gate=load('smoke_raw_gate',HERE/'audit.py')
    summary={};accepted={}
    for case in ('control','cached'):
        info=entries[case];profile=Path(info['profile'])
        assert all(sha(profile/n)==h for n,h in info['input_sha256'].items())
        assert not (profile/'last-run').exists()
        dest=HERE/'evidence/hudsmoke02'/case
        dest.mkdir(parents=True,exist_ok=False)
        entry=dict(passed=False,smoke_only=True,new_game_fps=None)
        try:
            base.run_one(profile,timeout=287)
            artifact=profile/'last-run'
            try:
                reader=subprocess.run([sys.executable,str(INTEGRATION/'vendor/read_record.py'),
                                       str(artifact/'sender-progress.jsonl')],
                                      text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=5)
                observation=dict(reader_exit=reader.returncode,stdout=reader.stdout,stderr=reader.stderr)
            except (OSError,subprocess.TimeoutExpired) as error:
                observation=dict(reader_exit=None,reader_error=repr(error))
            observation['reader_exit_zero_means']='Finalized schema only'
            (artifact/'observer-reader.json').write_text(json.dumps(observation,indent=2)+'\n')
            preserve(profile,dest)
            assert observation['reader_exit']==0,'Observer record missing/invalid/unfinalized'
            checked=gate.audit(dest)
            accepted[case]=checked
            if case=='cached':
                control=accepted['control']
                for field in ('state_sha256','player_sha256','timed_wire_sha256','native_replies'):
                    assert checked[field]==control[field],field
                rows=json.loads((HERE/'EXPECTED-PROTOCOL.json').read_text())['requests']
                for row,a,b in zip(rows,control['native_reply_values'],checked['native_reply_values']):
                    if not (row['operation']==4 and row['expected_value'] is None):
                        assert a==b,('Pair native reply mismatch',row['token'])
                entry['final_MOS_image_equal']=checked['MOS_image']['sha256']==control['MOS_image']['sha256']
                entry['race_pixel_equivalence_claimed']=False
            assert all(sha(profile/n)==h for n,h in info['input_sha256'].items())
            entry.update(passed=True,raw_and_state_gate=True,observer_finalized=True,
                         timed_wire_bytes=18317,retained_native_replies=344)
            print(case,'60-frame smoke functional/raw/cleanup PASS; no FPS conclusion.',flush=True)
        except BaseException as error:
            entry['error']=repr(error)
            raise
        finally:
            preserve(profile,dest)
            summary[case]=entry
            (HERE/'CAMPAIGN-hudsmoke02.json').write_text(json.dumps(summary,indent=2)+'\n')


def main():
    assert socket.gethostname()=='oryx-linuxlite'
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--lease',required=True)
    args=parser.parse_args();os.environ['RALLY_ORYX_LEASE']=args.lease
    frozen=json.loads((HERE/'READINESS-FREEZE.json').read_text())
    for n,h in frozen['files'].items():assert sha(HERE/n)==h,n
    for n,h in frozen['project_dependencies'].items():assert sha(ROOT/n)==h,n
    profiles=json.loads((HERE/'PROFILES.json').read_text())
    (HERE/'PROFILES-hudsmoke02.json').write_text(json.dumps(profiles,indent=2)+'\n')
    sys.path.insert(0,str(CUSTOM/'throughput'))
    supervisor=load('original_oryx_supervisor',CUSTOM/'throughput/oryx_session.py')
    supervisor.HERE=HERE;supervisor.run_campaign=campaign
    supervisor.session('hudsmoke02',['hudsmoke02'],[])


if __name__=='__main__':
    main()
