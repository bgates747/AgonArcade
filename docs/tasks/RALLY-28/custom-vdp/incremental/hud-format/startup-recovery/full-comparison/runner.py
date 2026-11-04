"""Prepared FOUR-process900-frame ABBA cohort; no authority implied by this CLI."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import subprocess
import sys
import socket

HERE=Path(__file__).resolve().parent
HUD=HERE.parent.parent
CUSTOM=HUD.parents[1]
ROOT=CUSTOM.parents[3]
ROLES={'control1':'control','cached1':'cached','cached2':'cached','control2':'control'}
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module


def campaign(name):
    assert name=='hud900abba01'
    profiles=json.loads((HERE/'PROFILES.json').read_text());assert list(profiles)==list(ROLES)
    base=load('original_hud_control',HUD/'control.py')
    stop=load('qualified_stop',HERE.parent/'observer-integration/runner.py').stop
    preserve=load('qualified_preserve',HERE.parent/'hud-smoke/runner.py').preserve
    conditions=load('host_conditions',HERE/'conditions.py')
    base.stop=stop;sys.path.insert(0,str(HERE))
    gate=load('full_raw_gate',HERE/'audit.py');summary={};accepted={}
    for case,role in ROLES.items():
        info=profiles[case];profile=Path(info['profile']);assert info['role']==role
        assert all(sha(profile/n)==h for n,h in info['input_sha256'].items())
        assert not (profile/'last-run').exists()
        dest=HERE/'evidence/hud900abba01'/case;dest.mkdir(parents=True,exist_ok=False)
        entry=dict(passed=False,role=role,frames_requested=900)
        try:
            (dest/'host-before.json').write_text(json.dumps(conditions.snapshot('before-'+case),indent=2)+'\n')
            base.run_one(profile,timeout=287)
            artifact=profile/'last-run'
            try:
                reader=subprocess.run([sys.executable,str(HERE.parent/'observer-integration/vendor/read_record.py'),
                    str(artifact/'sender-progress.jsonl')],text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=5)
                observation=dict(reader_exit=reader.returncode,stdout=reader.stdout,stderr=reader.stderr)
            except (OSError,subprocess.TimeoutExpired) as error:
                observation=dict(reader_exit=None,reader_error=repr(error))
            observation['reader_exit_zero_means']='Finalized schema only'
            (artifact/'observer-reader.json').write_text(json.dumps(observation,indent=2)+'\n')
            preserve(profile,dest);assert observation['reader_exit']==0,'Invalid/missing/unfinalized observer record'
            checked=gate.audit(dest);accepted[case]=checked
            if case!='control1':
                first=accepted['control1']
                for field in ('state_sha256','player_sha256','timed_wire_sha256','whole_wire_sha256','native_replies'):
                    assert checked[field]==first[field],field
                rows=json.loads((HERE/'EXPECTED-PROTOCOL.json').read_text())['requests']
                for row,a,b in zip(rows,first['native_reply_values'],checked['native_reply_values']):
                    if not (row['operation']==4 and row['expected_value'] is None):
                        assert a==b,('Deterministic native value differs',row['token'])
            assert all(sha(profile/n)==h for n,h in info['input_sha256'].items())
            entry.update(passed=True,frames_completed=900,physics_ticks=3600,raw_state_clock_cleanup_gate=True)
            print(case,'900-frame raw/state/clock/cleanup gate PASS; report after release.',flush=True)
        except BaseException as error:
            entry['error']=repr(error)
            raise
        finally:
            preserve(profile,dest)
            (dest/'host-after.json').write_text(json.dumps(conditions.snapshot('after-'+case),indent=2)+'\n')
            summary[case]=entry
            (HERE/'CAMPAIGN-hud900abba01.json').write_text(json.dumps(summary,indent=2)+'\n')


def main():
    assert socket.gethostname()=='oryx-linuxlite'
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--lease',required=True)
    args=parser.parse_args();os.environ['RALLY_ORYX_LEASE']=args.lease
    frozen=json.loads((HERE/'READINESS-FREEZE.json').read_text())
    for n,h in frozen['files'].items():assert sha(HERE/n)==h,n
    for n,h in frozen['project_dependencies'].items():assert sha(ROOT/n)==h,n
    profiles=json.loads((HERE/'PROFILES.json').read_text());assert list(profiles)==list(ROLES)
    (HERE/'PROFILES-hud900abba01.json').write_text(json.dumps(profiles,indent=2)+'\n')
    sys.path.insert(0,str(CUSTOM/'throughput'))
    supervisor=load('original_oryx_supervisor',CUSTOM/'throughput/oryx_session.py')
    supervisor.HERE=HERE;supervisor.run_campaign=campaign
    supervisor.session('hud900abba01',['hud900abba01'],[])


if __name__=='__main__':main()
