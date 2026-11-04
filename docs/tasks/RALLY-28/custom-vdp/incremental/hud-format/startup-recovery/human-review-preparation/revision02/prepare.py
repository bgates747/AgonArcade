"""Correct only human wrapper/text; preserve the first frozen local profile."""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import subprocess
import tarfile

HERE = Path(__file__).resolve().parent
ORIGINAL = HERE.parent
ROOT = next(p for p in HERE.parents if (p / 'rally-game').is_dir())
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def canonical():
    spec = importlib.util.spec_from_file_location('canonical_rhp02', ORIGINAL / 'reference/flexe_profile.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def prepare():
    old = json.loads((ORIGINAL / 'PROFILE.json').read_text())
    source = Path(old['local_stopped_profile'])
    target = ROOT / '.emulator/rally28-hz60-rhp02-cached'
    assert not target.exists() and not (HERE / 'PROFILE.json').exists()
    assert all(sha(source / n) == h for n, h in old['input_sha256'].items())
    target.mkdir(parents=True)
    for n in old['input_sha256']:
        p = target / n
        p.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source / n, p)
    text = (source / 'flexe-agon-emulator').read_text()
    start = text.index('# Human launch only after Rally obtains fresh custodian checkout.')
    end = text.index('export FLEXE_UART_OBSERVER_OUTPUT=', start)
    replacement = '''# Human launch only after the custodian writes a fresh local checkout.
python3 "${profile_dir}/review_custody.py" check || exit 1
if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
    echo 'Review not launched: a desktop display is required. Contact Golem.' >&2
    exit 1
fi
if [[ "${SDL_VIDEODRIVER:-}" == dummy ]]; then
    echo 'Review not launched: video is dummy; use the Author desktop. Contact Golem.' >&2
    exit 1
fi
'''
    text = text[:start] + replacement + text[end:]
    assert 'RALLY_ORYX_LEASE' not in text
    (target / 'flexe-agon-emulator').write_text(text)
    (target / 'flexe-agon-emulator').chmod(0o755)
    shutil.copyfile(HERE / 'review_custody.py', target / 'review_custody.py')
    guide = (source / 'sdcard/rally25/review.txt').read_bytes()
    guide = guide.replace(b'Check the cursor, type DIR, then close.', b'Type DIR; close and report in Golem.')
    guide = guide.replace(b'If stuck, close and report to Rally.', b'If stuck, close and report in Golem.')
    (target / 'sdcard/rally25/review.txt').write_bytes(guide)
    tool = canonical()
    tool.name_flexe_profile(target)
    tool.verify_profile_executables(target / 'flexe-agon-emulator', target / 'flexe-agon-emulator.bin')
    subprocess.run(['bash', '-n', str(target / 'flexe-agon-emulator')], check=True)
    pins = {str(p.relative_to(target)): sha(p) for p in sorted(target.rglob('*')) if p.is_file()}
    changed = [n for n, h in old['input_sha256'].items() if pins[n] != h]
    assert set(changed) == {'flexe-agon-emulator', 'sdcard/rally25/review.txt'}
    assert set(pins) - set(old['input_sha256']) == {'review_custody.py'}
    assert not (target / '.review-custody.json').exists()
    (target / '.runtime.sha256').write_text(''.join(h + '  ' + n + '\n' for n, h in pins.items()))
    (HERE / '.work').mkdir(exist_ok=True)
    with tarfile.open(HERE / '.work/PROFILE.tar.gz', 'w:gz') as bundle:
        for p in sorted(target.rglob('*')):
            if p.is_file():
                bundle.add(p, arcname=str(p.relative_to(target)), recursive=False)
    record = dict(local_stopped_profile=str(target), planned_oryx_profile=old['planned_oryx_profile'],
        input_sha256=pins, runtime_manifest_sha256=sha(target / '.runtime.sha256'),
        changed_from_first_preparation=changed, added_files=['review_custody.py'],
        custody_file='.review-custody.json', custody_in_archive=False, custody_populated=False,
        human_exports_required=False, game_runtime_changed=False, emulator_executed=False,
        oryx_staged=False, human_prompted=False)
    (HERE / 'PROFILE.json').write_text(json.dumps(record, indent=2) + '\n')
    (HERE / 'STAGED-LAUNCHER.sh').write_text(text)
    (HERE / 'REVIEW-TEXT.txt').write_bytes(guide)
    print(json.dumps(record, indent=2))


if __name__ == '__main__':
    prepare()
