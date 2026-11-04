"""Reuse the actual checked-C library with the existing independent900-frame model."""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import shutil
import subprocess
import sys

HERE = Path(__file__).resolve().parent
START = HERE.parent
HUD = START.parent
CUSTOM = HUD.parents[1]
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def worker(mode):
    spec = importlib.util.spec_from_file_location('full_race_reference', CUSTOM/'full-race/host_reference.py')
    reference = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(reference)
    reference.WORK = HERE/'.work/reference'
    reference.PACKAGE = HUD.parent/'round-trips/.work/package'
    reference.worker(mode, 900)


def main():
    work = HERE/'.work/reference'
    work.mkdir(parents=True, exist_ok=True)
    reports = {}
    for mode in ('ordinary', 'sanitized'):
        original = json.loads((START/f'HOST-{mode}.json').read_text())
        source = START/'.work'/f'reference-{mode}.so'
        assert sha(source) == original['host_library_sha256']
        checked = HUD.parent/'round-trips/source/checked.c'
        assert sha(checked) == original['source_checked_sha256']
        shutil.copyfile(source, work/(mode+'.so'))
        environment = dict(os.environ)
        if mode == 'sanitized':
            environment.update(LD_PRELOAD=subprocess.check_output(['cc', '-print-file-name=libasan.so'], text=True).strip(),
                               ASAN_OPTIONS='detect_leaks=0:halt_on_error=1', UBSAN_OPTIONS='halt_on_error=1')
        subprocess.run([sys.executable, __file__, '--worker', mode], env=environment, check=True)
        report = json.loads((work/(mode+'-900.json')).read_text())
        assert report['valid'] and report['frames'] == 900 and report['physics_ticks'] == 3600
        assert report['final_buffers'] == json.loads((HUD/'EXPECTED-FINAL-900.json').read_text())
        report['actual_checked_c_sha256'] = sha(checked)
        (HERE/f'HOST-{mode}-900.json').write_text(json.dumps(report, indent=2)+'\n')
        reports[mode] = report
    assert reports['ordinary']['final_buffers'] == reports['sanitized']['final_buffers']
    assert reports['ordinary']['tick_states_sha256'] == reports['sanitized']['tick_states_sha256']
    print('PASS actual checked C/independent3600ticks/900motion rows/2024-reply final reference; no emulator.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--worker', choices=['ordinary', 'sanitized'])
    arguments = parser.parse_args()
    worker(arguments.worker) if arguments.worker else main()
