"""Read-only source/profile checks. No emulator or human launcher invocation."""
from pathlib import Path
import hashlib
import json
import struct
import subprocess
import tarfile
from prepare import HERE, BASE, HUD, ROOT, LINES, helper, sha


def check():
    record = json.loads((HERE / 'PROFILE.json').read_text())
    old = json.loads((BASE / 'PROFILE.json').read_text())
    target = Path(record['local_stopped_profile'])
    pins = record['input_sha256']
    assert len(pins) == 23
    assert not (target / 'last-run').exists() and not (target / '.last-run').exists()
    assert {str(p.relative_to(target)) for p in target.rglob('*') if p.is_file()} == set(pins) | {'.runtime.sha256'}
    assert all(sha(target / n) == h for n, h in pins.items())
    assert sha(target / '.runtime.sha256') == record['runtime_manifest_sha256']
    changed = [n for n, h in old['input_sha256'].items() if pins[n] != h]
    assert set(changed) == {'flexe-agon-emulator', 'sdcard/autoexec.txt'}
    assert set(pins) - set(old['input_sha256']) == {'sdcard/rally25/review.txt'}
    config = struct.unpack('<4sHHIHH', (target / 'sdcard/rally25/config.bin').read_bytes())
    assert config == (b'R28F', 1, 900, 34836, 1, 0)
    meta = json.loads((target / 'sdcard/rally25/expected.json').read_text())
    assert meta['hud_format_cache'] and meta['transactions_per_timed_frame'] == 2
    assert meta['module_sha256'] == '479fe1ac99bb2895af8a8b6cca49b90cb5c346a56a5f9e4020cab0b23c933918'
    text = (target / 'sdcard/rally25/review.txt').read_bytes()
    assert text == ('\r\n'.join(LINES) + '\r\n').encode('ascii')
    assert len(LINES) == 20 and max(map(len, LINES)) <= 39
    assert all(32 <= b <= 126 or b in (10, 13) for b in text)
    auto = (target / 'sdcard/autoexec.txt').read_bytes()
    assert auto == b'SET KEYBOARD 1\r\ncd /rally25\r\nCLS\r\nTYPE review.txt\r\n'
    assert b'RUN' not in auto and b'LOAD' not in auto
    wrapper = (target / 'flexe-agon-emulator').read_text()
    assert wrapper.count('export SDL_AUDIODRIVER=dummy') == 1
    assert 'export SDL_VIDEODRIVER=dummy' not in wrapper
    assert '--owner rally --lease $lease' in wrapper
    assert wrapper.index('Rally custodian ownership assertion failed') < wrapper.index('run_root=')
    assert 'SDL video is dummy' in wrapper and 'desktop DISPLAY' in wrapper
    assert 'export AGON_FLEXE_ENGINE=jit' in wrapper
    assert 'Observer output exists; preserve this profile and stop' in wrapper
    assert '.runtime.sha256' in wrapper and 'Runtime overrides are forbidden' in wrapper
    subprocess.run(['bash', '-n', str(target / 'flexe-agon-emulator')], check=True)
    before = {n: sha(target / n) for n in pins}
    canonical = helper()
    canonical.name_flexe_profile(target)
    canonical.verify_profile_executables(target / 'flexe-agon-emulator', target / 'flexe-agon-emulator.bin')
    assert before == {n: sha(target / n) for n in pins}
    # Static source evidence and actual accepted target result already cover
    # the unchanged game's normal cursor/cleanup path. Do not rerun it here.
    source = (HUD / 'guest/src/main.cpp').read_text()
    assert 'void restoreText(){font(65535);const uint8_t p[]={22,8,23,0,192,0,23,1,1,26,12};' in source
    assert 'engine.stop(send);fs::stop();' in source
    assert 'releaseGraphics();restoreText();' in source
    assert 'RALLY-28 FULL RACE DONE: logs saved.' in source
    result = json.loads((BASE / 'evidence/maint08601/cached/result.json').read_text())
    assert result['timer_restored'] and result['unloaded'] and result['clean_text_exit']
    map_text = (target / 'mos_platform.map').read_text()
    assert '_mos_cmdTYPE' in map_text and '_mos_cmdCLS' in map_text
    with tarfile.open(HERE / '.work/HUMAN-PROFILE.tar.gz') as bundle:
        members = bundle.getmembers()
        assert len(members) == 24 and {m.name for m in members} == set(pins) | {'.runtime.sha256'}
        for member in members:
            assert member.isfile()
            assert bundle.extractfile(member).read() == (target / member.name).read_bytes()
    preserved = {}
    for name in ['READINESS-FREEZE.json', 'RESULTS-FREEZE.json']:
        frozen = json.loads((BASE / name).read_text())
        for n, h in frozen['files'].items():
            assert sha(BASE / n) == h, n
        for n, h in frozen.get('project_dependencies', {}).items():
            assert sha(ROOT / n) == h, n
        preserved[name] = sha(BASE / name)
    proof = dict(passed=True, profile_inputs=23, unchanged_baseline_inputs=20,
        changed_files=changed, added_file='sdcard/rally25/review.txt', archive_members=24,
        instruction_lines=20, maximum_line_columns=39, no_startup_autorun=True,
        compact_config_flag=1, hud_cache_enabled=True, canonical_preflight_pass=True,
        canonical_idempotence_preserves_hashes=True,
        canonical_helper_sha256=sha(HERE / 'reference/flexe_profile.py'),
        original_cleanup_evidence_preserved=True, preserved_baseline_freezes=preserved,
        game_guest_changed=False, emulator_processes=0, library_invocations=0,
        oryx_contact=False, live_desktop_manual_start_verified=False,
        new_900_frame_test_required_by_game_code_change=False)
    (HERE / 'DEVICE-FREE-CHECK.json').write_text(json.dumps(proof, indent=2) + '\n')
    print(json.dumps(proof, indent=2))


if __name__ == '__main__':
    check()
