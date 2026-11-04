"""Prepare a stopped human profile locally; never launch, reserve or contact Oryx."""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import subprocess
import tarfile

HERE = Path(__file__).resolve().parent
BASE = HERE.parent / 'maintained-runtime'
HUD = HERE.parent.parent
ROOT = HUD.parents[1].parents[3]
PROFILE_NAME = 'rally28-hz60-rhp01-cached'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()

LINES = [
    'RALLY: FUJI MOVING REVIEW',
    'Cached HUD and reduced serial waits.',
    '',
    'Automatic race; no steering needed.',
    'Watch road, scenery, cars and signs.',
    'Cars should approach and recede.',
    'Check HUD values on alternating pages.',
    'Look for flicker, stale text or trails.',
    'The footer must remain readable.',
    '',
    'Sound is disabled. This is not an FPS',
    'comparison or a manually played game.',
    '',
    'At the MOS prompt enter these commands:',
    '  LOAD PROBE.BIN',
    '  RUN .',
    '',
    'After 900 frames: FULL RACE DONE, MOS.',
    'Check the cursor, type DIR, then close.',
    'If stuck, close and report to Rally.',
]

GUARD = '''
# Human launch only after Rally obtains fresh custodian checkout.
lease="${RALLY_ORYX_LEASE:-}"
if [[ ! "$lease" =~ ^[0-9a-f]{32}$ ]]; then
    echo 'Review not launched: set the current Rally custodian lease first.' >&2
    exit 1
fi
if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
    echo 'Review not launched: a desktop DISPLAY or WAYLAND_DISPLAY is required.' >&2
    exit 1
fi
if [[ "${SDL_VIDEODRIVER:-}" == dummy ]]; then
    echo 'Review not launched: SDL video is dummy; use the Author desktop.' >&2
    exit 1
fi
ssh -o BatchMode=yes raspberrypi \\
    "/Agon/mystuff/agon-dev-env/.venv/bin/python /Agon/mystuff/agon-dev-env/cross-agent/vdplet-rollout/oryx_lease.py assert-owner --owner rally --lease $lease" >/dev/null || {
    echo 'Review not launched: Rally custodian ownership assertion failed.' >&2
    exit 1
}
'''


def helper():
    spec = importlib.util.spec_from_file_location('captured_canonical_profile', HERE / 'reference/flexe_profile.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def prepare():
    target = ROOT / '.emulator' / PROFILE_NAME
    assert not target.exists() and not (HERE / 'PROFILE.json').exists(), 'Preserve all prior profiles'
    original = json.loads((BASE / 'PROFILE.json').read_text())
    source = BASE / original['local_prepared_profile']
    for n, h in original['input_sha256'].items():
        assert sha(source / n) == h, n
    qualification = json.loads((BASE / 'evidence/maint08601/cached/qualification.json').read_text())
    assert qualification['functional_pass'] and qualification['frames'] == 900
    assert qualification['backend_sha256'] == original['new_backend']
    target.mkdir(parents=True)
    for n in original['input_sha256']:
        dest = target / n
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source / n, dest)
    wrapper = (source / 'flexe-agon-emulator').read_text()
    assert wrapper.count('export SDL_VIDEODRIVER=dummy\n') == 1
    wrapper = wrapper.replace('export SDL_VIDEODRIVER=dummy\n', '')
    anchor = 'profile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"'
    assert wrapper.count(anchor) == 1
    wrapper = wrapper.replace(anchor, anchor + '\n' + GUARD)
    assert wrapper.count('export SDL_AUDIODRIVER=dummy') == 1
    (target / 'flexe-agon-emulator').write_text(wrapper)
    (target / 'flexe-agon-emulator').chmod(0o755)
    # Only this fresh emulator SD tree changes. Original profiles/cards stay intact.
    (target / 'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\ncd /rally25\r\nCLS\r\nTYPE review.txt\r\n')
    (target / 'sdcard/rally25/review.txt').write_bytes(('\r\n'.join(LINES) + '\r\n').encode('ascii'))
    canonical = helper()
    canonical.name_flexe_profile(target)
    canonical.verify_profile_executables(target / 'flexe-agon-emulator', target / 'flexe-agon-emulator.bin')
    subprocess.run(['bash', '-n', str(target / 'flexe-agon-emulator')], check=True)
    pins = {str(p.relative_to(target)): sha(p) for p in sorted(target.rglob('*')) if p.is_file()}
    changed = [n for n in original['input_sha256'] if pins[n] != original['input_sha256'][n]]
    assert set(changed) == {'flexe-agon-emulator', 'sdcard/autoexec.txt'}
    assert set(pins) - set(original['input_sha256']) == {'sdcard/rally25/review.txt'}
    (target / '.runtime.sha256').write_text(''.join(h + '  ' + n + '\n' for n, h in pins.items()))
    subprocess.run(['sha256sum', '--check', '--status', '.runtime.sha256'], cwd=target, check=True)
    (HERE / '.work').mkdir(exist_ok=True)
    with tarfile.open(HERE / '.work/HUMAN-PROFILE.tar.gz', 'w:gz') as bundle:
        for p in sorted(target.rglob('*')):
            if p.is_file():
                bundle.add(p, arcname=str(p.relative_to(target)), recursive=False)
    record = dict(local_stopped_profile=str(target),
        planned_oryx_profile='/home/smith/Agon/mystuff/AgonArcade/.emulator/' + PROFILE_NAME,
        input_sha256=pins, changed_files=changed, added_files=['sdcard/rally25/review.txt'],
        runtime_manifest_sha256=sha(target / '.runtime.sha256'),
        original_qualified_profile=original['profile'], baseline_accepted='Golem224',
        video='Author desktop, not launched', audio='dummy', engine='jit',
        guest_changed=False, native_renderer_physics_timing_changed=False,
        deployed_to_oryx=False, emulator_executed=False, human_prompted=False,
        review_custody=False, source_of_finite_race='Unchanged cached900 guest c6d75022',
        startup='MOS text only; Author later issues LOAD PROBE.BIN and RUN .',
        live_gui_and_manual_start_qualified=False)
    (HERE / 'PROFILE.json').write_text(json.dumps(record, indent=2) + '\n')
    (HERE / 'REVIEW-TEXT.txt').write_bytes((target / 'sdcard/rally25/review.txt').read_bytes())
    (HERE / 'STAGED-LAUNCHER.sh').write_text(wrapper)
    print(json.dumps(record, indent=2))


if __name__ == '__main__':
    prepare()
