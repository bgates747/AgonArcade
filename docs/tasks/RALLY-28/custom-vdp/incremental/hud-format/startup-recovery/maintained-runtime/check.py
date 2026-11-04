"""Device-free candidate/guard/admission checks; never load either emulator."""
from pathlib import Path
import ast
import json
import shutil
import subprocess
import tempfile
import tarfile
from common import HERE, FULL, HUD, ROOT, BACKEND, FRONTEND, profile, check_profile, load, sha


def rejected(call):
    try:
        call()
    except AssertionError:
        return True
    raise AssertionError('Invalid candidate unexpectedly admitted')


def check():
    info = profile()
    local = HERE / info['local_prepared_profile']
    old = json.loads((FULL / 'PROFILES.json').read_text())['cached1']
    check_profile(local, info['input_sha256'])
    assert info['changed_input_files'] == ['flexe-vdp.so']
    assert set(info['input_sha256']) == set(old['input_sha256'])
    assert len(info['input_sha256']) == 22
    assert all(h == old['input_sha256'][n] for n, h in info['input_sha256'].items() if n != 'flexe-vdp.so')
    assert info['input_sha256']['flexe-agon-emulator.bin'] == FRONTEND
    assert info['input_sha256']['flexe-vdp.so'] == BACKEND
    assert not info['deployed'] and not info['target_executed']
    staging = load('offline_staging', HERE / 'stage.py')
    payloads = staging.candidate_payloads(HERE / '.work/CANDIDATE.tar.gz', info)
    assert len(payloads) == 23
    assert all(payload == (local / name).read_bytes() for name, payload in payloads.items())
    load('offline_runner_import', HERE / 'runner.py')
    # Inspect foreign-architecture ELF files statically, with no dlopen or
    # subprocess invocation of a frontend/library/firmware entry point.
    exports = subprocess.check_output(['readelf', '--dyn-syms', '--wide', str(local / 'flexe-vdp.so')], text=True)
    symbols = {line.split()[-1] for line in exports.splitlines() if len(line.split()) >= 8 and line.split()[6] != 'UND'}
    required = {'flexe_vdp_cycles', 'flexe_vdp_frames', 'flexe_vdp_failed', 'z80_uart0_is_cts',
                'z80_send_to_vdp', 'z80_recv_from_vdp'}
    assert required <= symbols
    (HERE / 'BACKEND-EXPORTS.txt').write_text(exports)
    for name in ('flexe-agon-emulator.bin', 'flexe-vdp.so'):
        header = subprocess.check_output(['readelf', '-h', str(local / name)], text=True)
        assert 'Advanced Micro Devices X86-64' in header
    receipt = json.loads((HERE / 'producer-evidence/receipt.json').read_text())
    assert receipt['passed'] and receipt['no_instrumentation'] and receipt['source_preserved']
    assert receipt['original_library_sha256'] == receipt['rebuilt_library_sha256'] == BACKEND
    assert receipt['rebuilt_core_sha256'] == sha(HERE / '.work/libxtensa-emu-lib.a')
    guards = {n: sha(p) for n, p in {
        'run_one': HUD / 'control.py',
        'qualified_stop': HERE.parent / 'observer-integration/runner.py',
        'supervisor': HUD.parents[1] / 'throughput/oryx_session.py',
        'full_audit': FULL / 'audit.py', 'full_verify': FULL / 'verify.py',
        'guest_verify': HUD / 'verify.py', 'reader': HERE.parent / 'observer-integration/vendor/read_record.py',
    }.items()}
    assert guards['reader'] == '12817411df487931407d1ec7cf4e51c9742a5f350582af2efce5db3fb4a96cde'
    tree = ast.parse((HERE / 'runner.py').read_text())
    calls = [n for n in ast.walk(tree) if isinstance(n, ast.Call) and isinstance(n.func, ast.Attribute)
             and n.func.attr == 'run_one']
    assert len(calls) == 1 and any(k.arg == 'timeout' and isinstance(k.value, ast.Constant)
                                 and k.value.value == 287 for k in calls[0].keywords)
    negative = {}
    with tempfile.TemporaryDirectory(prefix='offline-check-', dir=HERE / '.work') as tmp:
        scratch = Path(tmp)
        # Hardlinks in the scratch only save copying; mutate by replacement.
        candidate = scratch / 'profile'
        shutil.copytree(local, candidate, copy_function=lambda a, b: Path(b).hardlink_to(a))
        (candidate / 'last-run').mkdir()
        negative['occupied_output'] = rejected(lambda: check_profile(candidate, info['input_sha256']))
        (candidate / 'last-run').rmdir()
        p = candidate / 'flexe-vdp.so'
        p.unlink()
        p.write_bytes(b'wrong backend')
        negative['backend_tamper'] = rejected(lambda: check_profile(candidate, info['input_sha256']))
        p.unlink()
        p.hardlink_to(local / 'flexe-vdp.so')
        manifest = candidate / '.runtime.sha256'
        manifest.unlink()
        manifest.write_text('wrong manifest\n')
        negative['manifest_tamper'] = rejected(lambda: check_profile(candidate, info['input_sha256']))
        # The actual failed cached receipt differs only in backend identity:
        # it must not be relabelled as a new-runtime observation.
        failed = scratch / 'old-cached'
        failed.mkdir()
        shutil.copyfile(FULL / 'evidence/hud900abba01/cached1/run.json', failed / 'run.json')
        old_receipt = json.loads((failed / 'run.json').read_text())
        raw = load('offline_runtime_identity', HUD.parent / 'round-trips/raw_audit.py')
        found = raw.identities(old_receipt['runtime_identities'])
        assert [n for n in found if found[n] != info['input_sha256'][n]] == ['flexe-vdp.so']
        gate = load('offline_new_audit', HERE / 'audit.py')
        negative['old_backend_receipt'] = rejected(lambda: gate.audit(failed))
        assert not (failed / 'qualification.json').exists() and not (failed / 'full-audit.json').exists()
        bad_archive = scratch / 'incomplete.tar'
        with tarfile.open(bad_archive, 'w'):
            pass
        negative['incomplete_archive'] = rejected(lambda: staging.candidate_payloads(bad_archive, info))
    # No regenerated wire, game binary, state oracle or runtime build.
    old_freeze = json.loads((FULL / 'READINESS-FREEZE.json').read_text())
    for base, items in [(FULL, old_freeze['files']), (ROOT, old_freeze['project_dependencies'])]:
        for n, h in items.items():
            assert sha(base / n) == h, n
    results = json.loads((FULL / 'RESULTS-FREEZE.json').read_text())
    for n, h in results['files'].items():
        assert sha(FULL / n) == h, n
    evidence = dict(passed=True, profile_inputs=22, only_changed_file='flexe-vdp.so',
                    original_closure_files=320, old_result_files=len(results['files']),
                    producer_baseline_reproduction_evidence_verified=True,
                    required_backend_exports=sorted(required), archive_members_verified=23,
                    negative_admissions=negative,
                    unchanged_guard_sources=guards, candidate_invocations_intended=1,
                    emulator_processes=0, oryx_contact=False, deployed=False,
                    new_fps_measurement=False, no_old_failure_relabel=True)
    (HERE / 'DEVICE-FREE-CHECK.json').write_text(json.dumps(evidence, indent=2) + '\n')
    print(json.dumps(evidence, indent=2))


if __name__ == '__main__':
    check()
