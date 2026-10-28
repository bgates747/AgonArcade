"""INC-001-01: isolated clear-only fixture, existing pinned runner, fresh profiles."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import sys

HERE = Path(__file__).resolve().parent
THROUGHPUT = HERE.parent / 'throughput'
ROOT = HERE.parents[4]
sys.path.insert(0, str(THROUGHPUT))
from fixtures import sha
from freeze_control import records

BASE = 'native-span-native-fenced-unpaced'
OLD = bytes.fromhex('19 04 00 00 18 00 19 65 3f 01 ef 00')
NEW = bytes.fromhex('19 04 00 00 18 00 19 65 3f 01 67 00 '
                    '19 04 00 00 e0 00 19 65 3f 01 ef 00')


def save(name, value):
    (HERE / name).write_text(json.dumps(value, indent=2) + '\n')


def raw_records(tape):
    parsed = records(tape)
    return [(r, tape[r['offset']:parsed[i+1]['offset'] if i+1 < len(parsed) else len(tape)])
            for i, r in enumerate(parsed)]


def patch(tape):
    before = raw_records(tape)
    output = bytearray()
    changed = []
    for i, (r, data) in enumerate(before):
        if r['opcode'] == 1 and r['loop']:
            body = tape[r['payload_offset']:r['payload_offset']+r['payload_bytes']]
            if OLD in body:
                assert body.count(OLD) == 1
                body = body.replace(OLD, NEW, 1)
                data = b'\x01' + len(body).to_bytes(2, 'little') + body
                changed.append(i)
        output += data
    assert len(changed) == 1
    after = raw_records(output)
    assert len(before) == len(after)
    for i, ((_, a), (_, b)) in enumerate(zip(before, after)):
        assert i in changed or a == b, i
    assert len(output) == len(tape) + 12
    # Every semantic record other than the paint SEND remains identical.
    return bytes(output), dict(changed_record=changed[0], other_records_exact=True,
                               additional_wire_bytes_per_frame=12,
                               old_paint_bytes=before[changed[0]][0]['payload_bytes'],
                               new_paint_bytes=after[changed[0]][0]['payload_bytes'])


def coverage_proof():
    # Compare arbitrary old page contents after the clear and a full opaque
    # road replacement. Exercise both pages and different prior-frame dirt.
    width, height = 320, 240
    road = bytes((195, 200, 207, 213, 255)[i % 5] for i in range(320*120))
    removed = 0
    for y in range(height):
        old = 24 <= y <= 239
        new = 24 <= y <= 103 or 224 <= y <= 239
        if old != new:
            assert old and not new and 104 <= y <= 223
            removed += width
    assert removed == len(road) == 38400
    checks = 0
    for page in range(2):
        for dirty in (0, 71, 233):
            initial = bytearray((i * 17 + page * 113 + dirty) & 255
                                for i in range(width*height))
            a, b = initial.copy(), initial.copy()
            a[24*width:240*width] = bytes([16]) * (216*width)
            b[24*width:104*width] = bytes([16]) * (80*width)
            b[224*width:240*width] = bytes([16]) * (16*width)
            a[104*width:224*width] = road
            b[104*width:224*width] = road
            assert a == b
            checks += 1
    for report in ('span-HOST-ordinary.json', 'span-HOST-sanitized.json'):
        prior = json.loads((THROUGHPUT/report).read_text())
        assert prior['replay']['stock_quad_rasters_equal'] == 900
        assert prior['replay']['unchanged_actor_player_commands']
        assert all(v >> 6 == 3 for v in prior['replay']['opaque_pixel_values'])
    return dict(removed_clear_pixels=removed, retained_clear_pixels=30720,
                two_page_dirty_patterns_passed=checks,
                equality_after_opaque_road=True,
                existing_900_frame_raster_proofs={
                    'ordinary_sha256': sha(THROUGHPUT / 'span-HOST-ordinary.json'),
                    'sanitized_sha256': sha(THROUGHPUT / 'span-HOST-sanitized.json')},
                drawing_order='unchanged title, sky/bottom clear, opaque road, actors/player, swap, fence',
                comparison_basis='All prior span-raster qualifications retained; no module or pixels changed')


def prepare():
    assert not (HERE / 'FIXTURES.json').exists(), 'Preserve existing incremental inputs'
    old_registry = json.loads((THROUGHPUT / 'FIXTURES.json').read_text())
    original = old_registry[BASE]
    source = THROUGHPUT / original['directory']
    assert all(sha(source/n) == h for n, h in original['files'].items())
    before = sha(THROUGHPUT / 'FIXTURES.json')
    registry = {}
    change = None
    for name in ('clear-control', 'clear-split'):
        destination = HERE / '.work/fixtures' / name
        destination.mkdir(parents=True, exist_ok=False)
        for n in original['files']:
            shutil.copyfile(source/n, destination/n)
        if name == 'clear-split':
            tape, change = patch((source/'script.bin').read_bytes())
            (destination/'script.bin').write_bytes(tape)
            meta = json.loads((destination/'expected.json').read_text())
            meta['candidate'] = 'INC-001-01 split clear, accepted Native-span module unchanged'
            meta['files']['script.bin'] = sha(destination/'script.bin')
            meta['clear_only_change'] = change
            (destination/'expected.json').write_text(json.dumps(meta, indent=2)+'\n')
        files = {n: sha(destination/n) for n in original['files']}
        differences = [n for n in files if files[n] != original['files'][n]]
        assert differences == ([] if name == 'clear-control' else ['expected.json', 'script.bin'])
        registry[name] = dict(directory=str(destination.relative_to(HERE)), files=files,
                              module_sha256=original['module_sha256'], foreground_paced=False,
                              differences_from_control=differences, diagnostic=False)
    assert before == sha(THROUGHPUT / 'FIXTURES.json')
    save('FIXTURES.json', registry)
    save('CLEAR-PROOF.json', dict(source_case=BASE, source_files=original['files'],
                                 source_registry_unchanged=True, patch=change,
                                 coverage=coverage_proof(), emulator_launched=False))
    print('Prepared isolated clear control/candidate; removed 38400 clear writes, +12 bytes/frame')


def stage(campaign, cases):
    import stage as prior_stage
    prior_stage.HERE = HERE
    prior_stage.stage(campaign, cases)


def run_campaign(campaign):
    assert Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip() == '0'
    os.environ.update(SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
    pins = json.loads((THROUGHPUT/'RUNNER-PINS.json').read_text())
    assert all(sha(THROUGHPUT/'support'/n) == h for n, h in pins.items())
    sys.path.insert(0, str(THROUGHPUT/'support'))
    from run_headless import run
    profiles = json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
    reference = json.loads((THROUGHPUT.parent/'paced-road/CONTROL-FINAL.json').read_text())['final_buffers']
    summary = {}
    evidence = HERE/'evidence'/campaign
    evidence.mkdir(parents=True, exist_ok=False)
    for name, info in profiles.items():
        profile = Path(info['profile'])
        assert not (profile/'last-run').exists(), 'Use a fresh campaign'
        assert all(sha(profile/n) == h for n, h in info['input_sha256'].items())
        print('Running', campaign, name, 'video=dummy audio=dummy boost=0', flush=True)
        try:
            receipt = run(profile, 180)
            guest = receipt['result']
            assert guest['frames'] == 900 and guest['physics_ticks'] == 3600
            assert guest['validated_reply_records'] == 2913
            assert guest['final_buffers'] == reference
            assert guest['prt']['previous_vector_restored']
            entry = dict(passed=True, frames=900, physics_ticks=3600,
                         nominal_mos_fps=guest['observed_fps'],
                         nominal_mos_seconds=guest['elapsed_seconds'], prt=guest['prt'],
                         host_seconds_including_startup=receipt['host_seconds'],
                         retained_replies=2913, final_world_exact=True,
                         backend_stats=receipt['backend_stats'], process_exit=receipt['process_exit'])
        except Exception as exc:
            entry = dict(passed=False, error=repr(exc))
        target = evidence/name
        target.mkdir()
        if (profile/'last-run').is_dir():
            for p in (profile/'last-run').iterdir():
                if p.is_file():
                    shutil.copyfile(p, target/(p.with_suffix('.txt').name if p.suffix == '.log' else p.name))
        app = profile/'sdcard/rally25'
        for n in ('replies', 'ticks', 'prt', 'clock', 'failure'):
            if (app/(n+'.log')).exists():
                shutil.copyfile(app/(n+'.log'), target/(n+'.bin'))
        entry['input_hashes_preserved'] = all(sha(profile/n) == h for n, h in info['input_sha256'].items())
        entry['boost_after'] = Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip()
        summary[name] = entry
        save('CAMPAIGN-'+campaign+'.json', summary)
        assert entry['passed'], entry
        assert entry['input_hashes_preserved'] and entry['boost_after'] == '0'
        print(name, 'PASS', round(entry['nominal_mos_fps'], 3), 'nominal MOS FPS', flush=True)


def session(name, campaigns):
    import oryx_session as supervisor
    supervisor.HERE = HERE
    supervisor.run_campaign = run_campaign
    supervisor.session(name, campaigns, [])


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='action', required=True)
    sub.add_parser('prepare')
    p = sub.add_parser('stage')
    p.add_argument('campaign')
    p.add_argument('cases', nargs='+', choices=['clear-control', 'clear-split'])
    p = sub.add_parser('session')
    p.add_argument('name')
    p.add_argument('campaigns', nargs='+')
    args = parser.parse_args()
    if args.action == 'prepare':
        prepare()
    elif args.action == 'stage':
        stage(args.campaign, args.cases)
    else:
        session(args.name, args.campaigns)
