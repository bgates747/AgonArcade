"""Malformed synthetic capture checks for target_verify; no target timing claim."""
from pathlib import Path
import copy
import csv
import importlib.util
import json
import shutil
import struct
import tempfile
from target_verify import HERE,APP,METHODS,sha,expected_schedule,verify


def main():
    runtime_reference=json.loads((HERE/'evidence/pi-runtime01/runtime/result.json').read_text())['identity']['files']
    source_profile=HERE.parents[4]/'.emulator/rally28-affine-pi-smoke01'
    # The earlier staged profile's runtime files are the same pinned local build;
    # authoritative fixture inputs are copied fresh from TARGET-FIXTURES below.
    assert source_profile.exists()
    work=HERE/'.work/target-verifier-checks'
    if work.exists():shutil.rmtree(work)
    work.mkdir(parents=True)
    registry=json.loads((HERE/'TARGET-FIXTURES.json').read_text())
    results=[]
    for fixture in ('smoke','full','smoke-poll'):
        profile=work/fixture
        fixture_source=HERE/registry[fixture]['directory']
        app=profile/APP;shutil.copytree(fixture_source,app)
        identity_files={}
        for name in ('flexe-agon-emulator.bin','flexe-vdp.so','esp32-firmware.bin','mos_platform.bin','mos_platform.map'):
            target=profile/name;target.symlink_to(source_profile/name)
            identity_files[name]=sha(target)
        for name in registry[fixture]['files']:
            identity_files[str(APP/name)]=sha(app/name)
        metadata=json.loads((app/'expected.json').read_text())
        tx,rx,rows,intervals,_,_=expected_schedule(metadata,(app/'artwork.vdu').read_bytes())
        runtime=profile/'last-run';runtime.mkdir()
        tx=b'SYNTHETIC VALIDATOR INPUT ONLY\n'+tx+b'RALLY AFFINE PASS: logs saved.\r\n/test/arcade/rally28/affine *'
        rx=b''.join(bytes([op|128,len(payload if payload is not None else b'\0\0\xff\x0c')])+
            (payload if payload is not None else b'\0\0\xff\x0c') for op,payload in rx)
        for name,data in [('mos-to-vdp.bin',tx),('vdp-to-mos.bin',rx),('vdp-to-mos-delivered.bin',rx)]:
            (runtime/name).write_bytes(data)
        summary=dict(schema=1,valid=True,failure='none',completed_batches=len(rows),planned_batches=len(rows),
            mode=136,timed_swaps=0,draw_repeats=metadata['draw_repeats'],setup_repeats=metadata['setup_repeats'],
            samples=metadata['samples'],case_mask=metadata['case_mask'],primary_completion='poll' if fixture=='smoke-poll' else 'key-zero',
            fallback_used=False,callback_restored=True,prt_restored=True,mos_hz_nominal=120,prt_hz_nominal=1000,
            keyboard_packets=0 if fixture=='smoke-poll' else len(rows))
        (app/'summary.json').write_text(json.dumps(summary))
        (app/'done.txt').write_text('PASS\n')
        fields=['case_index','case','method','sample','operations','mos_ticks','prt_ticks','submit_prt_ticks','wait_prt_ticks','callback_hits','gp','marker_pixel','valid']
        original_rows=[dict(row,mos_ticks=3,prt_ticks=20,submit_prt_ticks=1,wait_prt_ticks=19) for row in rows]
        def csv_output(data):
            with (app/'timings.csv').open('w',newline='') as f:
                writer=csv.DictWriter(f,fieldnames=fields);writer.writeheader();writer.writerows(data)
        csv_output(original_rows)
        stats=dict(failed=False,unhandled=0,unregistered=0,unmapped=0,uart_rx=len(tx),uart_tx=len(rx),uart_delivered=len(rx),engine='synthetic-validator-input')
        result=dict(reason='guest-files',exit=0,identities_unchanged=True,forced_sdl=dict(video='dummy',audio='dummy'),
            identity=dict(files=identity_files,platform=dict(architecture='aarch64'),runtime_build_sha256=sha(HERE/'PI-RUNTIME-BUILD.json')),backend_stats=stats)
        (runtime/'stats.json').write_text(json.dumps(stats));(runtime/'result.json').write_text(json.dumps(result))
        verify(profile,fixture,work/('positive-'+fixture))
        results.append(dict(name='accept-'+fixture,passed=True,synthetic_input=True))
        if fixture!='smoke':continue
        def rejected(name,edit,restore,manifest=None):
            edit()
            try:verify(profile,fixture,work/('unexpected-'+name),runtime_manifest=manifest)
            except AssertionError as error:
                results.append(dict(name=name,passed=True,rejected=str(error)))
            else:raise AssertionError(('Malformed capture accepted',name))
            finally:restore()
        bad=bytearray(tx);bad[tx.index(b'\x17\0\xa0')+4]^=1
        rejected('resident-setup-byte',lambda:(runtime/'mos-to-vdp.bin').write_bytes(bad),lambda:(runtime/'mos-to-vdp.bin').write_bytes(tx))
        bad=bytearray(tx);bad[len(b'SYNTHETIC VALIDATOR INPUT ONLY\n')+intervals[0]['offset']+3]^=1
        rejected('timed-call-byte',lambda:(runtime/'mos-to-vdp.bin').write_bytes(bad),lambda:(runtime/'mos-to-vdp.bin').write_bytes(tx))
        def rx_edit(data):
            (runtime/'vdp-to-mos.bin').write_bytes(data);(runtime/'vdp-to-mos-delivered.bin').write_bytes(data)
        # Setup/warm are3B each; first primarykey is6B and markerpixel is6B.
        bad=rx[:6]+rx[12:18]+rx[6:12]+rx[18:]
        rejected('pixel-before-primary',lambda:rx_edit(bad),lambda:rx_edit(rx))
        bad=rx.replace(b'\x84\4\0\0\xff\x0c',b'\x84\4\0\0\xff\x0b',1)
        rejected('wrong-marker-index',lambda:rx_edit(bad),lambda:rx_edit(rx))
        bad=rx.replace(b'\x84\4\0\0\xff\x0c',b'\x84\4\0\xff\0\x0c',1)
        rejected('wrong-marker-rgb',lambda:rx_edit(bad),lambda:rx_edit(rx))
        bad_rows=copy.deepcopy(original_rows);bad_rows[1]['operations']+=1
        rejected('wrong-operation-count',lambda:csv_output(bad_rows),lambda:csv_output(original_rows))
        bad_rows=copy.deepcopy(original_rows);bad_rows[1]['method']='empty'
        rejected('wrong-method',lambda:csv_output(bad_rows),lambda:csv_output(original_rows))
        bad_rows=copy.deepcopy(original_rows);bad_rows[1]['prt_ticks']+=1
        rejected('inconsistent-prt-split',lambda:csv_output(bad_rows),lambda:csv_output(original_rows))
        bad_summary=dict(summary,prt_restored=False)
        rejected('timer-not-restored',lambda:(app/'summary.json').write_text(json.dumps(bad_summary)),lambda:(app/'summary.json').write_text(json.dumps(summary)))
        bad_stats=dict(stats,unhandled=1)
        bad_result=dict(result,backend_stats=bad_stats)
        def bad_backend():
            (runtime/'stats.json').write_text(json.dumps(bad_stats));(runtime/'result.json').write_text(json.dumps(bad_result))
        def good_backend():
            (runtime/'stats.json').write_text(json.dumps(stats));(runtime/'result.json').write_text(json.dumps(result))
        rejected('backend-unhandled',bad_backend,good_backend)
        mode_packet=b'\x86\x08'+struct.pack('<HHBBBB',320,240,40,25,64,136)
        auxiliary_rx=rx[:6]+mode_packet+rx[6:]
        def with_auxiliary(data):
            rx_edit(data)
            changed=dict(stats,uart_tx=len(data),uart_delivered=len(data))
            (runtime/'stats.json').write_text(json.dumps(changed))
            (runtime/'result.json').write_text(json.dumps(dict(result,backend_stats=changed)))
        with_auxiliary(auxiliary_rx)
        verify(profile,fixture,work/'positive-modeinfo')
        results.append(dict(name='accept-valid-modeinfo',passed=True,synthetic_input=True))
        bad=rx[:6]+b'\x86\x08'+struct.pack('<HHBBBB',320,240,40,25,64,8)+rx[6:]
        rejected('unexpected-mode8-in-batch',lambda:with_auxiliary(bad),lambda:with_auxiliary(auxiliary_rx))
        bad=rx[:6]+b'\x86\x08'+struct.pack('<HHBBBB',640,240,40,25,64,136)+rx[6:]
        rejected('unexpected-dimensions-in-batch',lambda:with_auxiliary(bad),lambda:with_auxiliary(auxiliary_rx))
        with_auxiliary(rx)
        verify(profile,fixture,work/'positive-explicit-pi-runtime',runtime_manifest=HERE/'PI-RUNTIME-BUILD.json')
        results.append(dict(name='accept-explicit-pi-runtime',passed=True,synthetic_input=True))
        runtime_build=json.loads((HERE/'PI-RUNTIME-BUILD.json').read_text())
        def changed_manifest(name,build,identity_changes=None):
            path=work/(name+'.json');path.write_text(json.dumps(build))
            modified=copy.deepcopy(result)
            modified['identity']['runtime_build_sha256']=sha(path)
            if identity_changes:identity_changes(modified['identity'])
            return path,modified
        def alter_result(value):(runtime/'result.json').write_text(json.dumps(value))
        def restore_result():alter_result(result)
        changed=copy.deepcopy(runtime_build);changed['files']['flexe-vdp.so']='0'*64
        manifest,modified=changed_manifest('wrong-runtime-build-hash',changed)
        rejected('wrong-runtime-build-hash',lambda:alter_result(modified),restore_result,manifest)
        manifest,modified=changed_manifest('wrong-runtime-file-hash',changed,
            lambda identity:identity['files'].update({'flexe-vdp.so':'0'*64}))
        rejected('wrong-runtime-file-hash',lambda:alter_result(modified),restore_result,manifest)
        changed=copy.deepcopy(runtime_build);changed['architecture']='x86_64'
        manifest,modified=changed_manifest('wrong-runtime-elf-architecture',changed,
            lambda identity:identity['platform'].update({'architecture':'x86_64'}))
        rejected('wrong-runtime-elf-architecture',lambda:alter_result(modified),restore_result,manifest)
        modified=copy.deepcopy(result);modified['identity']['runtime_build_sha256']='0'*64
        rejected('wrong-runtime-manifest-reference',lambda:alter_result(modified),restore_result)
        changed=copy.deepcopy(runtime_build);changed['passed']=False
        manifest,modified=changed_manifest('unqualified-runtime-build',changed)
        rejected('unqualified-runtime-build',lambda:alter_result(modified),restore_result,manifest)
    report=dict(schema=1,passed=True,purpose='Synthetic malformed-capture audit checks only; no emulator or timing evidence',
        verifier_sha256=sha(HERE/'target_verify.py'),cases=results)
    (HERE/'TARGET-VERIFIER-CHECKS.json').write_text(json.dumps(report,indent=2)+'\n')
    print('PASS',len(results),'synthetic target verifier checks; no emulator was launched')

if __name__=='__main__':main()
