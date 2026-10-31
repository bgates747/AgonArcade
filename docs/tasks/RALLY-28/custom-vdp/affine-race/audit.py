"""Reuse the independent full-race raw protocol audit; no benchmark launch."""
from pathlib import Path
import hashlib,importlib.util,json
HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('aff02_independent_race_audit',HERE.parent/'full-race/raw_audit.py')
raw=importlib.util.module_from_spec(spec);spec.loader.exec_module(raw);raw.HERE=HERE
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
    registry=json.loads((HERE/'FIXTURES.json').read_text());rows=[];wires=[];runtimes=[]
    guard=raw.session('affracesession01',require_complete=False)
    assert guard['source_session_error'].startswith('TimeoutError(')
    continuation=raw.session('afffinishsession01')
    for campaign in ('affab01','affba01','afffinish01'):
        profiles=json.loads((HERE/('PROFILES-'+campaign+'.json')).read_text())
        results=json.loads((HERE/('CAMPAIGN-'+campaign+'.json')).read_text())
        assert list(profiles)==(list(registry) if campaign=='affab01' else list(reversed(registry)) if campaign=='affba01' else ['rebuild'])
        for name,profile in profiles.items():
            if campaign=='affba01' and name=='rebuild':
                assert not results[name]['passed']
                entry=dict(results[name],retry_classification=json.loads((HERE/'STARTUP-EXCLUSION.json').read_text()))
                excluded=raw.startup_attempt(raw.locate(campaign,name),registry[name],profile,entry)
                continue
            assert results[name]['passed']
            row,wire,frames,runtime=raw.completed_run(campaign,name,registry[name],profile)
            rows.append(row);wires.append(wire);runtimes.append(runtime)
    assert len(rows)==8 and len(set(wires))==1
    assert all(r==runtimes[0] for r in runtimes)
    host=json.loads((HERE/'HOST-ordinary.json').read_text());san=json.loads((HERE/'HOST-sanitized.json').read_text())
    assert host['passed'] and san['passed']
    assert {k:v for k,v in host.items() if k!='mode'}=={k:v for k,v in san.items() if k!='mode'}
    assert all(row['frames']==900 and row['native_physics_ticks']==3600 for row in rows)
    data=dict(passed=True,rows=rows,session=guard,continuation_session=continuation,
        excluded_startup=excluded,frames_per_run=900,runs=8,
        timed_uart_streams_identical=True,timed_uart_bytes=len(wires[0]),timed_uart_sha256=hashlib.sha256(wires[0]).hexdigest(),
        runtime_identities_identical=True,runtime=runtimes[0],host_caches_and_world_verified=True,
        renderer_modules_are_only_measured_variant=True,raw_file_sha256=raw.SEEN,
        auditor_source_sha256=sha(HERE.parent/'full-race/raw_audit.py'))
    (HERE/'RAW-AUDIT.json').write_text(json.dumps(data,indent=2)+'\n')
    print('PASS:8x900 frames, all raw replies/state/wire/timer/MOS exit; identical timed streams.')

if __name__=='__main__':main()
