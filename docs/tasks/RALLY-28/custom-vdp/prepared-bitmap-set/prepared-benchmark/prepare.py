"""Prepare separate full900 inputs; never compile, stage or launch a guest."""
from pathlib import Path
import difflib
import hashlib
import json
import shutil
import struct

HERE = Path(__file__).resolve().parent
PRIOR = HERE.parent / 'prepared-race'
CONTROL = HERE.parents[1] / 'incremental/round-trips'
RUNTIME = HERE.parent / 'runtime'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()


def write(name, value):
    (HERE/name).write_text(json.dumps(value, indent=2)+'\n')


def prepare():
    assert not (HERE/'FIXTURES.json').exists(), 'Keep previous preparation immutable'
    for folder, filename in [(PRIOR,'READINESS-FREEZE.json'),
                             (PRIOR,'FIRST-FUNCTIONAL-WITNESS.json'),
                             (PRIOR,'POSE-AUDIT-FREEZE.json'),
                             (PRIOR,'FUNCTIONAL-RESULTS-FREEZE.json'),
                             (RUNTIME,'RUNTIME-FREEZE.json')]:
        for name, digest in json.loads((folder/filename).read_text())['files'].items():
            assert sha(folder/name) == digest, (filename, name)
    assert json.loads((PRIOR/'RAW-FUNCTIONAL-AUDIT.json').read_text())['passed']
    assert json.loads((PRIOR/'SAME-CAPTURE-AUDIT.json').read_text())['passed']
    assert (PRIOR/'QUALIFIED-RETURN-RECEIPT.json').is_file(), 'Return audit before preparation'
    registry = {}
    changes = {}
    for case, original in [('compact',CONTROL/'fixtures/compact'),
                           ('prepared',PRIOR/'fixtures/prepared')]:
        dst = HERE/'fixtures'/case
        shutil.copytree(original,dst)
        if case == 'prepared':
            before=(dst/'config.bin').read_bytes()
            magic,schema,frames,size,flags,reserved=struct.unpack('<4sHHIHH',before)
            assert (magic,schema,frames,flags,reserved)==(b'R28F',1,60,1,0)
            after=struct.pack('<4sHHIHH',magic,schema,900,size,flags,reserved)
            (dst/'config.bin').write_bytes(after)
            meta=json.loads((dst/'expected.json').read_text())
            meta.update(frames=900,physics_ticks=3600,functional_only=False,
                        timing_excluded=False,performance_comparison='bundled-retention-size-sampling',
                        isolated_cache_benefit=False,actor_pixel_identical=False)
            meta['files']={p.name:sha(p) for p in dst.iterdir() if p.name!='expected.json'}
            (dst/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
            changes[case]=dict(config_before=before.hex(),config_after=after.hex(),
                               changed_files=['config.bin','expected.json'],
                               guest_native_sources_unchanged=True)
        else:
            assert all(p.read_bytes()==(dst/p.name).read_bytes() for p in original.iterdir())
            changes[case]=dict(changed_files=[],accepted_full900_byte_identical=True)
        registry[case]=dict(directory='fixtures/'+case,
            files={p.name:sha(p) for p in sorted(dst.iterdir())},
            module_sha256=json.loads((dst/'expected.json').read_text())['module_sha256'],
            diagnostic=False,foreground_paced=False)
    # Existing independent900-frame references and qualified actual-C counters.
    for name in ['EXPECTED-FINAL-900.json','GUEST-BUILD.json']:
        shutil.copyfile(CONTROL/name,HERE/name)
    shutil.copyfile(PRIOR/'INITIAL-UPLOAD-STATE.json',HERE/'INITIAL-UPLOAD-STATE.json')
    host=json.loads((RUNTIME/'HOST-ordinary.json').read_text())
    assert host['passed'] and host['frames']==900 and host['physics_ticks']==3600
    assert host['counters']==[4873,4871,2,0,0,0,0,0]
    write('HOST-FIXTURE.json',dict(expected_counters=host['counters'],
        expected_stop_generation=4504,
        no_retry_expected_replies={'900':dict(native_replies=19626,retained_bytes=196260)},
        reused_qualified_actual_C_host_result_sha256=sha(RUNTIME/'HOST-ordinary.json'),
        reused_independent_final_sha256=sha(HERE/'EXPECTED-FINAL-900.json'),
        no_repeated_generic_host_qualification=True))
    write('PREDICTIONS.json',dict(frames=900,physics_ticks=3600,warm_renders=2,
        final_request=902,final_generation=4503,stop_generation=4504,
        compact_native_replies=2024,prepared_native_replies=19626,
        prepared_reply_bytes=196260,prepared_transcript_capacity=220000,
        prepared_no_retry_headroom_bytes=23740,prepared_prefix_replies=16670,
        prepared_suffix_replies=1156,prepared_counters=host['counters'],
        expected_timed_uart_bytes=291568,expected_native_token_normalizations=1800,
        expected_tick_commands=3600,expected_swaps=900,
        presentation=dict(scroll_calls=382,repaint_calls=382,sky_repair_calls=900,
                          hud_bytes=17056,footer_calls=900,audio_changes=24,
                          finish_frames=16,input_polls=900),
        target_full900_unrun=True,clock_units_separate=True))
    write('FIXTURES.json',registry)
    write('SOURCE-CHANGES.json',changes)
    # The audited oracle is copied into a new scope with only fixture binding,
    # frame count, profile selection and report destination changes.
    old=(PRIOR/'raw_audit_pose_v2.py').read_text();new=old
    replacements={
        "HERE/'EXPECTED-FINAL-60.json'":"HERE/'EXPECTED-FINAL-900.json'",
        'range(1,61)':'range(1,901)',
        "HERE/'PROFILES-prace01.json'":"HERE/('PROFILES-'+e.parent.name+'.json')",
        'functional_only=True':'functional_only=False',
        "(HERE/'RAW-FUNCTIONAL-AUDIT.json')":"(e/'RAW-PREPARED-AUDIT.json')"}
    for before,after in replacements.items():
        assert new.count(before)==1,before
        new=new.replace(before,after)
    (HERE/'raw_prepared.py').write_text(new)
    (HERE/'ORACLE-DIFF.patch').write_text(''.join(difflib.unified_diff(
        old.splitlines(True),new.splitlines(True),fromfile='prepared-race/raw_audit_pose_v2.py',
        tofile='prepared-benchmark/raw_prepared.py')))
    # Reuse original owner-scoped guard, lease assertion, cleanup and staging.
    old=(PRIOR/'control.py').read_text();new=old.replace(
        "print(case, 'PASS functional', receipt['result']['frames'], 'frames; timing excluded', flush=True)",
        "print(case, 'PASS', round(receipt['result']['nominal_mos_fps'],3), 'nominal MOS FPS; bundled tradeoff', flush=True)")
    assert new != old
    (HERE/'control.py').write_text(new)
    (HERE/'CONTROL-DIFF.patch').write_text(''.join(difflib.unified_diff(
        old.splitlines(True),new.splitlines(True),fromfile='prepared-race/control.py',
        tofile='prepared-benchmark/control.py')))
    write('PREPARATION.json',dict(passed=True,new_compile=False,emulator_launched=False,
        exact_guest_and_native_bytes=True,compact_full900_unchanged=True,
        original_setup_and_timed_source_unchanged=True,
        source_closure_sha256=sha(PRIOR/'SOURCE-CLOSURE.json'),
        parent_functional_freeze_sha256=sha(PRIOR/'FUNCTIONAL-RESULTS-FREEZE.json'),
        preserved_original_readiness_sha256=sha(PRIOR/'READINESS-FREEZE.json'),
        preserved_control_sha256=sha(CONTROL/'FROZEN-INPUTS.json')))
    print(json.dumps({'prepared':True,'new_guest_compile':False,'emulator_launched':False}))


if __name__ == '__main__':
    prepare()
