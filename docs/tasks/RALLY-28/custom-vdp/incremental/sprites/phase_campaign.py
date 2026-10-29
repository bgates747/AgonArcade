"""Separate 128-frame phase campaign using the pinned silent Oryx runner.

No launch occurs on import, register, or stage. Session refuses to start while
any Agon emulator is running; the headline comparison must finish first.
"""
import argparse
import json
import math
import os
from pathlib import Path
import shutil
import statistics
import sys

from phase_test import HERE, THROUGHPUT, verify, save, sha
sys.path.insert(0,str(THROUGHPUT))
from fixtures import ROOT

CASES = {'phase-affine':'native-affine', 'phase-additive':'native-additive',
         'phase-early-affine':'early-affine', 'phase-early-additive':'early-additive',
         'phase-compact-affine':'compact-affine', 'phase-compact-additive':'compact-additive',
         'phase-actor-affine':'actor-affine','phase-actor-additive':'actor-additive'}
BACKEND_ERRORS = ('failed','unhandled','unregistered','unmapped')


def register():
    path=HERE/'FIXTURES.json'
    before=path.read_bytes()
    registry=json.loads(before)
    preserved={name:value for name,value in registry.items() if name not in CASES}
    for name,source_name in CASES.items():
        work=HERE/'.work'/('phase-'+source_name)
        fixture=work/'fixture'
        meta=json.loads((fixture/'expected.json').read_text())
        expected=work/'HOST-EXPECTED.json'
        model=json.loads(expected.read_text())
        assert meta['phase_candidate']==source_name and meta['frames']==128
        assert meta['physics_ticks']==512
        assert meta['reply_bytes']==(13730 if meta.get('phase_lite') else 39430)
        assert model['frames']==128 and model['ticks']==512
        assert model['independent_world_contact_model']
        entry=dict(directory=str(fixture.relative_to(HERE)),
            files={p.name:sha(p) for p in fixture.iterdir() if p.is_file()},
            module_sha256=meta['module_sha256'],diagnostic=True,foreground_paced=False,
            host_expected=str(expected.relative_to(HERE)),host_expected_sha256=sha(expected),
            phase_candidate=source_name,frames=128,physics_ticks=512)
        if name in registry:
            assert registry[name]==entry, 'Preserve existing phase registry entry'
        registry[name]=entry
    assert {name:value for name,value in registry.items() if name not in CASES}==preserved
    assert path.read_bytes()==before, 'Concurrent registry change; retry without overwriting it'
    save(path,registry)
    print('Registered',len(CASES),'separate phase cases; headline entries preserved')


def stage(campaign,cases):
    assert set(cases)<=set(CASES)
    import stage as previous
    previous.HERE=HERE
    return previous.stage(campaign,cases)


def no_running_emulators():
    running=[]
    for process in Path('/proc').glob('[0-9]*'):
        try:
            executable=(process/'exe').resolve(strict=True)
            if 'agon-emulator' in executable.name:
                running.append(dict(pid=int(process.name),executable=str(executable)))
        except (OSError,RuntimeError):
            continue
    assert not running, ('Finish/stop earlier emulator runs before phase campaign',running)


def distribution(values):
    ordered=sorted(values)
    return dict(mean=statistics.mean(ordered),median=statistics.median(ordered),
        min=ordered[0],p95_nearest_rank=ordered[math.ceil(len(ordered)*.95)-1],max=ordered[-1])


def phase_summary(phase):
    rows=phase['rows']
    categories={name:distribution([row[name] for row in rows]) for name in (
        'road_build_cycles','road_dispatch_draw_and_flush','road_preparation_and_execution',
        'actors_build_cycles','actors_dispatch_draw_and_flush','actors_preparation_and_execution',
        'physics4_call_cycles','prepare_call_cycles','clear_title_dispatch_and_flush',
        'player_build_cycles','player_dispatch_draw_and_flush','empty_marker_control',
        'swap_dispatch_and_flush') if name in rows[0]}
    return dict(unit='Raw per-core CCOUNT delta, uncalibrated; no MHz conversion',
        categories=categories,
        actor_comparison='Compare actors_preparation_and_execution: additive sampling moved from generic drawing into prepare.',
        road_comparison='Road preparation includes native raster; execution includes ordinary bitmap copy.',
        limits=['Interrupt/scheduler/marker/flush costs are included.',
                'Diagnostic runs are separate from uninstrumented 900-frame headline FPS.',
                'Swap ends at controller swap/drain; not physical monitor scanout.'],
        phase_lite=phase.get('phase_lite',False))


def run_campaign(campaign):
    assert campaign.isalnum()
    assert Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip()=='0'
    no_running_emulators()
    os.environ.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    pins=json.loads((THROUGHPUT/'RUNNER-PINS.json').read_text())
    assert all(sha(THROUGHPUT/'support'/name)==value for name,value in pins.items())
    sys.path.insert(0,str(THROUGHPUT/'support'))
    from run_headless import run
    profiles=json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
    assert profiles and set(profiles)<=set(CASES)
    registry=json.loads((HERE/'FIXTURES.json').read_text())
    result_file=HERE/('CAMPAIGN-'+campaign+'.json')
    evidence=HERE/'evidence'/campaign
    assert not result_file.exists() and not evidence.exists(), 'Use a fresh campaign'
    evidence.mkdir(parents=True)
    summary={}
    for name,info in profiles.items():
        no_running_emulators()
        entry_meta=registry[name]
        profile=Path(info['profile'])
        assert profile.parent==ROOT/'.emulator' and profile.name.startswith('rally28-hz60-')
        assert entry_meta['diagnostic']
        assert not (profile/'last-run').exists(), 'Use a fresh diagnostic profile'
        assert all(sha(profile/path)==value for path,value in info['input_sha256'].items())
        expected=HERE/entry_meta['host_expected']
        assert sha(expected)==entry_meta['host_expected_sha256']
        print('Running',campaign,name,'128-frame diagnostic; video=dummy audio=dummy boost=0',flush=True)
        outcome=dict(passed=False,diagnostic=True)
        try:
            receipt=run(profile,180)
            guest=receipt['result']
            meta=json.loads((profile/'sdcard/rally25/expected.json').read_text())
            assert guest['frames']==128 and guest['physics_ticks']==512
            expected_bytes=13730 if meta.get('phase_lite') else 39430
            assert meta['reply_bytes']==expected_bytes and guest['validated_reply_records']==expected_bytes//10
            assert guest['prt']['timer_borrowed'] and guest['prt']['previous_vector_restored']
            assert guest['prt']['elapsed_ticks']>0 and guest['elapsed_mos_ticks']>0
            assert receipt['process_exit']==0 and receipt['error'] is None
            assert not any(receipt['backend_stats'].get(key) for key in BACKEND_ERRORS)
            assert receipt['backend_stats']['cycles']>0
            if meta.get('phase_lite'):
                from phase_lite import verify as selected_verify
            else:selected_verify=verify
            phase=selected_verify(profile/'sdcard/rally25',guest,expected)
            save(profile/'last-run/phase-verified.json',phase)
            outcome=dict(passed=True,diagnostic=True,frames=128,physics_ticks=512,
                retained_reply_records=expected_bytes//10,full_final_state_matches_independent_host=True,
                nominal_mos_seconds=guest['elapsed_seconds'],
                nominal_prt_seconds=guest['prt']['nominal_seconds_at_18432000_hz'],
                host_seconds_including_startup=receipt['host_seconds'],
                prt=guest['prt'],backend_stats=receipt['backend_stats'],process_exit=receipt['process_exit'],
                phase=phase_summary(phase))
        except Exception as exc:
            outcome.update(error=repr(exc))
        target=evidence/name
        target.mkdir()
        if (profile/'last-run').is_dir():
            for path in (profile/'last-run').iterdir():
                if path.is_file():
                    shutil.copyfile(path,target/(path.with_suffix('.txt').name if path.suffix=='.log' else path.name))
        app=profile/'sdcard/rally25'
        for stem in ('replies','ticks','prt','clock','failure'):
            path=app/(stem+'.log')
            if path.exists():
                shutil.copyfile(path,target/(stem+'.bin'))
        if (app/'phase-verified.json').exists() and not (target/'phase-verified.json').exists():
            shutil.copyfile(app/'phase-verified.json',target/'phase-verified.json')
        outcome['input_hashes_preserved']=all(sha(profile/path)==value for path,value in info['input_sha256'].items())
        outcome['boost_after']=Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip()
        summary[name]=outcome
        save(result_file,summary)
        assert outcome['passed'],outcome
        assert outcome['input_hashes_preserved'] and outcome['boost_after']=='0'
        no_running_emulators()
        print(name,'PASS:128phase records; actor work combines preparation+execution',flush=True)
    return summary


def session(name,campaigns):
    # The supervisor changes boost only after this explicit no-overlap gate.
    no_running_emulators()
    import oryx_session as previous
    previous.HERE=HERE
    previous.run_campaign=run_campaign
    return previous.session(name,campaigns,[])


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    commands=parser.add_subparsers(dest='action',required=True)
    commands.add_parser('register')
    item=commands.add_parser('stage')
    item.add_argument('campaign')
    item.add_argument('cases',nargs='+',choices=tuple(CASES))
    item=commands.add_parser('session')
    item.add_argument('name')
    item.add_argument('campaigns',nargs='+')
    args=parser.parse_args()
    if args.action=='register':
        register()
    elif args.action=='stage':
        stage(args.campaign,args.cases)
    else:
        session(args.name,args.campaigns)
