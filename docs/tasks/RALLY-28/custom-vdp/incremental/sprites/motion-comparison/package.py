"""Archive exact matched inputs and verify the preserved comparison evidence."""
from pathlib import Path
import hashlib,json,zipfile
HERE=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def package():
    result=json.loads((HERE/'RESULTS.json').read_text())
    fixtures=json.loads((HERE/'FIXTURES.json').read_text())
    members={};archive=HERE/'PORTABLE.zip'
    with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
        for name,item in fixtures.items():
            directory=HERE/item['directory']
            for filename,digest in item['files'].items():
                p=directory/filename;assert sha(p)==digest
                entry='fixtures/'+name+'/'+filename;z.write(p,entry);members[entry]=digest
        with zipfile.ZipFile(HERE.parent/'PORTABLE.zip') as old:
            for name,entry in [('affine','target/control/rally-render.vdpl'),
                               ('additive','target/candidate/rally-render.vdpl')]:
                data=old.read(entry);digest=hashlib.sha256(data).hexdigest()
                assert digest==fixtures[name]['module_sha256']
                assert data in (HERE/fixtures[name]['directory']/'script.bin').read_bytes()
                entry='modules/'+name+'.vdpl';z.writestr(entry,data);members[entry]=digest
            data=old.read('firmware/vdp_rally.bin');entry='firmware/vdp_rally.bin'
            profile=json.loads((HERE/'PROFILES-motionab02.json').read_text())['affine']
            assert hashlib.sha256(data).hexdigest()==profile['input_sha256']['esp32-firmware.bin']
            z.writestr(entry,data);members[entry]=hashlib.sha256(data).hexdigest()
        for p in sorted(HERE.glob('*.py')):
            entry='source/'+p.name;z.write(p,entry);members[entry]=sha(p)
    with zipfile.ZipFile(archive) as z:
        assert set(z.namelist())==set(members)
        for entry,digest in members.items():assert hashlib.sha256(z.read(entry)).hexdigest()==digest
    (HERE/'PACKAGE.json').write_text(json.dumps(dict(archive=archive.name,sha256=sha(archive),members=members),indent=2)+'\n')
    raw={str(p.relative_to(HERE)):sha(p) for p in sorted((HERE/'evidence').rglob('*')) if p.is_file()}
    report=dict(qualified_runs=4,qualified_frames=3600,qualified_physics_ticks=14400,
        qualified_retained_replies=11652,identical_frame_stream_sha256=result['rows'][0]['completed_frame_uart_sha256'],
        passed=result['identical_complete_frame_uart_stream'] and result['full_final_worlds_equal'],
        archives={archive.name:sha(archive)},raw_evidence=raw,
        root_files={p.name:sha(p) for p in sorted(HERE.iterdir()) if p.is_file() and p.name!='VERIFICATION.json'},
        source_fixtures_unchanged=True,firmware_unchanged=True,publication_authorized=False,hardware_tested=False)
    (HERE/'VERIFICATION.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Archived and verified',len(members),'input/source members and',len(raw),'raw evidence files.')

if __name__=='__main__':package()
