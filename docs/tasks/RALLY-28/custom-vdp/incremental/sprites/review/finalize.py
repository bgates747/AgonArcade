"""Preserve review-only inputs and verify returned scene/exit evidence; no runs."""
from pathlib import Path
import binascii,hashlib,json,struct,sys,zipfile,zlib
HERE=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def finalize():
    case=json.loads((HERE/'CAMPAIGN-motiontest04.json').read_text());assert case['passed']
    trace=(HERE/'evidence/motiontest04/mos-to-vdp.bin').read_bytes()
    restore=bytes([22,8,23,0,192,0,23,1,1,26,12])
    a=trace.rfind(restore);b=trace.rfind(b'RALLY-25 DONE: logs saved.');c=trace.find(b'/rally25 *',b)
    assert 0<=a<b<c
    assert trace[b-5:b]==bytes([26,12,31,0,0])
    module_sha='310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702'
    with zipfile.ZipFile(HERE.parent/'PORTABLE.zip') as z:
        module=z.read('target/candidate/rally-render.vdpl')
    assert hashlib.sha256(module).hexdigest()==module_sha
    assert module in (HERE/'fixture04/script.bin').read_bytes()
    registry=json.loads((HERE/'FIXTURES.json').read_text())['motion']
    for n,h in registry['files'].items():assert sha(HERE/registry['directory']/n)==h
    profile=json.loads((HERE/'PROFILES-motionreview02.json').read_text())['motion']
    assert profile['stopped'] and profile['sound_driver']=='dummy'
    session=json.loads((HERE/'SESSION-motionsession04.json').read_text())
    assert session['boost_restored'] and not session['owned_emulator_processes_after']
    sys.path.insert(0,str(HERE.parent.parent));from clear_report import read_ppm
    rgb=read_ppm(HERE/'evidence/motiontest04/final.ppm');assert len(rgb)==320*240*3
    def chunk(t,d):return struct.pack('>I',len(d))+t+d+struct.pack('>I',binascii.crc32(t+d)&0xffffffff)
    rows=b''.join(b'\0'+rgb[y*960:(y+1)*960] for y in range(240))
    (HERE/'MOS-RETURN.png').write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',320,240,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(rows))+chunk(b'IEND',b''))
    archive=HERE/'REVIEW-INPUTS.zip';members={}
    with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
        for folder in ('fixture','fixture02','fixture03','fixture04'):
            for p in sorted((HERE/folder).rglob('*')):
                if p.is_file():n=str(p.relative_to(HERE));z.write(p,n);members[n]=sha(p)
        for p in sorted(HERE.iterdir()):
            if p.is_file() and p.suffix in {'.py','.asm','.inc'}:
                n='source/'+p.name;z.write(p,n);members[n]=sha(p)
        p=HERE/'.work/mos_api.inc';n='source/.work/mos_api.inc';z.write(p,n);members[n]=sha(p)
    with zipfile.ZipFile(archive) as z:
        assert set(z.namelist())==set(members)
        for n,h in members.items():assert hashlib.sha256(z.read(n)).hexdigest()==h
    (HERE/'PACKAGE.json').write_text(json.dumps(dict(archive=archive.name,sha256=sha(archive),members=members,
        qualified_fixture='fixture04',other_fixtures='Preserved startup failure/intermediate cleanup versions'),indent=2)+'\n')
    report=dict(passed=True,benchmark_verification_unchanged_sha256=sha(HERE.parent/'VERIFICATION.json'),
        module_sha256=module_sha,benchmark_inputs_unchanged=True,frames=900,physics_ticks=3600,retained_replies=2913,
        scripted_positions_and_lanes_exact=True,independent_player_station_exact=True,
        exit_trace=dict(mode8_full_text_restore_offset=a,completion_message_offset=b,mos_prompt_offset=c,clear_before_done=True),
        human_profile=profile['profile'],boost_restored=True,emulators_stopped=True,moving_human_review_pending=True,
        not_benchmark_timing=True,extra_review_uart_bytes_per_frame=70,
        raw_files={str(p.relative_to(HERE)):sha(p) for p in sorted((HERE/'evidence').rglob('*')) if p.is_file()},
        inputs=registry,sources={p.name:sha(p) for p in HERE.iterdir() if p.is_file() and p.suffix in {'.py','.asm','.inc'}})
    (HERE/'VERIFICATION.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Review inputs, exact native module and visible MOS return verified; moving human review pending.')

if __name__=='__main__':finalize()
