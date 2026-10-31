"""Reuse the independent protocol audit with explicitly distinct guest hashes."""
from pathlib import Path
import hashlib,importlib.util,json,struct
HERE=Path(__file__).resolve().parent
CONTROL=HERE.parent/'round-trips'
spec=importlib.util.spec_from_file_location('hud_raw_protocol',CONTROL/'raw_audit.py')
raw=importlib.util.module_from_spec(spec);spec.loader.exec_module(raw);raw.HERE=HERE

def fixture_inputs(info,profile):
    fixture=HERE/info['directory'];found=profile['input_sha256']
    for name,wanted in info['files'].items():
        assert raw.sha(raw.read(fixture/name))==wanted,(fixture,name)
        assert found['sdcard/rally25/'+name]==wanted
    build=raw.load(HERE/'BUILD.json')
    assert info['files']['probe.bin']==build['guests'][info['guest']]
    assert profile['stopped'] and profile['sound_driver']=='dummy'
    assert found['esp32-firmware.bin']==raw.FIRMWARE
    magic,schema,frames,module_bytes,flags,reserved=struct.unpack('<4sHHIHH',raw.read(fixture/'config.bin'))
    assert (magic,schema,flags,reserved)==(b'R28F',1,1,0)
    meta=raw.load(fixture/'expected.json')
    assert meta['frames']==frames and meta['module_bytes']==module_bytes and meta['config_flags']==flags
    image=raw.read(fixture/'module.vdu');prefix=b'\x17\0\xa0'+struct.pack('<H',50305)
    assert image[:14]==prefix+b'\2'+prefix+b'\0'+struct.pack('<H',module_bytes)
    assert len(image[14:])==module_bytes and raw.sha(image[14:])==info['module_sha256']==meta['module_sha256']
    assert raw.sha(raw.read(fixture/'motion.bin'))=='5ca7f145e3160618dc1708b3624741dcd1ccb7fc61db41fda8482881b50ed3e9'
    return fixture,meta,{name:found[name] for name in raw.RUNTIME}

def main():
    raw.fixture_inputs=fixture_inputs
    assert not (HERE/'RAW-AUDIT.json').exists()
    session=raw.session('hudsession01')
    assert session['completed']==['campaign:hudsmoke01','campaign:hudab01','campaign:hudba01']
    rows=[];streams={};runtimes=[]
    for campaign,registry_name in [('hudsmoke01','SMOKE-FIXTURES.json'),('hudab01','FIXTURES.json'),('hudba01','FIXTURES.json')]:
        profiles=raw.load(HERE/('PROFILES-'+campaign+'.json'))
        registry=raw.load(HERE/registry_name)
        receipt=raw.load(HERE/('CAMPAIGN-'+campaign+'.json'))
        for case,profile in profiles.items():
            assert receipt[case]['passed'] and receipt[case]['input_hashes_preserved']
            row,stream,frames,runtime=raw.completed_run(campaign,case,registry[case],profile)
            rows.append(row);streams[campaign+'/'+case]=stream;runtimes.append(runtime)
    assert all(r==runtimes[0] for r in runtimes)
    assert streams['hudsmoke01/control']==streams['hudsmoke01/cached']
    for key in ('hudab01/cached','hudba01/cached','hudba01/control'):
        assert streams[key]==streams['hudab01/control'],key
    assert len(streams['hudab01/control'])==291568
    freeze=json.loads((HERE/'READINESS-FREEZE.json').read_text())
    for name,wanted in freeze['files'].items():
        assert hashlib.sha256(Path(name).read_bytes()).hexdigest()==wanted,name
    out=dict(passed=True,runs=rows,session=session,all_runtime_inputs_identical=True,
        all_full_timed_uart_identical=True,timed_bytes_per_full_run=291568,
        smoke_timed_uart_identical=True,readiness_files_unchanged=len(freeze['files']),
        audit_source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        raw_protocol_auditor_sha256=hashlib.sha256((CONTROL/'raw_audit.py').read_bytes()).hexdigest())
    (HERE/'RAW-AUDIT.json').write_text(json.dumps(out,indent=2)+'\n')
    print('PASS: six complete runs; exact raw replies/state/cleanup and identical timed UART.')

if __name__=='__main__':main()
