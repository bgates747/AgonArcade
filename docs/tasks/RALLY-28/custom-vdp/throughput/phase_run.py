"""Explicit finite phase-profile runner hook; silent and boost-off only."""
from pathlib import Path
import argparse
import hashlib
import json
import os
from phase_shared import ROOT,support_module
from phase_verify import verify


def run(profile,timeout=180):
    profile=Path(profile).resolve()
    assert profile.parent==ROOT/'.emulator' and profile.name.startswith('rally28-')
    assert (profile/'flexe-agon-emulator').is_file(),'Expected the named Flexe profile entry point'
    boost=Path('/sys/devices/system/cpu/cpufreq/boost')
    if boost.exists() and boost.read_text().strip()!='0':
        raise RuntimeError('CPU boost is enabled; silent phase run rejected before launch. Disable boost before retrying.')
    assert not (profile/'last-run').exists(),'Use a fresh phase profile; preserve existing evidence'
    pins={n:h for h,n in (line.split('  ',1) for line in (profile/'.runtime.sha256').read_text().splitlines())}
    sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
    assert all(sha(profile/n)==h for n,h in pins.items())
    os.environ.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    receipt=support_module('run_headless').run(profile,timeout)
    result=verify(profile/'sdcard/rally25',receipt['result'])
    assert all(sha(profile/n)==h for n,h in pins.items())
    if boost.exists():assert boost.read_text().strip()=='0','Boost changed during phase run'
    result['host_seconds_including_startup']=receipt['host_seconds']
    (profile/'last-run/phase-verified.json').write_text(json.dumps(result,indent=2)+'\n')
    print('PASS',result['candidate'],result['frames'],'raw-cycle diagnostic frames; not hardware timing')
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('profile');parser.add_argument('--timeout',type=float,default=180)
    a=parser.parse_args();run(a.profile,a.timeout)
