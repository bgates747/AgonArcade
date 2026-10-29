"""Clone the accepted sampler; change only the native road fill primitive."""
from pathlib import Path
import hashlib,json,shutil,struct,subprocess,sys,zipfile
HERE=Path(__file__).resolve().parent
INC=HERE.parent
SPRITES=INC/'sprites'
ROOT=HERE.parents[5]
PACED=INC.parent/'paced-road'
WORK=HERE/'.work'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def build():
    assert not (HERE/'BUILD.json').exists(),'Preserve prior outcomes'
    control=WORK/'control/package';candidate=WORK/'candidate/package'
    control.mkdir(parents=True,exist_ok=False)
    archive=SPRITES/'PORTABLE.zip'
    manifest=json.loads((SPRITES/'PACKAGE.json').read_text())
    assert sha(archive)==manifest['sha256']
    with zipfile.ZipFile(archive) as z:
        for name,digest in manifest['members'].items():
            if name.startswith('source/candidate/'):
                data=z.read(name);assert hashlib.sha256(data).hexdigest()==digest
                path=control/name.removeprefix('source/candidate/');path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
        target=WORK/'control/target';target.mkdir()
        for name in z.namelist():
            if name.startswith('target/candidate/'):
                (target/Path(name).name).write_bytes(z.read(name))
    old_module=WORK/'control/target/rally-render.vdpl'
    assert sha(old_module)=='310779643769adde8413b93ea282115990dfebfe873e3395ac5545ac9d506702'
    shutil.copytree(control,candidate)
    core=(candidate/'helper/render_core.inc').read_text()
    old='''static void r28_span_fill(uint8_t *row, int left, int right, uint8_t colour) {
    if (left < right) memset(row + left, colour, (unsigned)(right - left));
}'''
    assert core.count(old)==1
    (candidate/'helper/render_core.inc').write_text(core.replace(old,'#include "wide_fill.inc"',1))
    shutil.copyfile(HERE/'wide_fill.inc',candidate/'helper/wide_fill.inc')
    target=WORK/'candidate/target'
    command=[sys.executable,str(PACED/'control/sdk/tools/build_module.py'),str(candidate/'native.c'),
        '--name','rally-render','--build-id','0x52385731','--output',str(target),
        '--text-limit','32768','--data-limit','4096','--stack-limit','2048','--image-limit','65536']
    result=subprocess.run(command,capture_output=True,text=True)
    (HERE/'BUILD-OUTPUT.txt').write_text(result.stdout+result.stderr)
    assert result.returncode==0,result.stdout+result.stderr
    metadata=json.loads(result.stdout);new_module=target/'rally-render.vdpl'
    fixture_registry=json.loads((SPRITES/'motion-comparison/FIXTURES.json').read_text())['additive']
    source=SPRITES/'motion-comparison'/fixture_registry['directory']
    assert all(sha(source/n)==h for n,h in fixture_registry['files'].items())
    fixtures={}
    for name in ('byte','word'):
        out=HERE/'fixtures'/name;shutil.copytree(source,out)
        if name=='word':
            old_tape=(out/'script.bin').read_bytes()
            assert old_tape[0]==1
            first_end=3+int.from_bytes(old_tape[1:3],'little')
            body=old_tape[3:first_end];meta=json.loads((out/'expected.json').read_text())
            staging=meta['resources']['staging'];marker=b'\x17\0\xa0'+struct.pack('<H',staging)
            image=new_module.read_bytes()
            assert body==marker+b'\2'+marker+b'\0'+struct.pack('<H',old_module.stat().st_size)+old_module.read_bytes()
            assert old_tape[first_end]==2
            wire_size=int.from_bytes(old_tape[first_end+9:first_end+11],'little')
            second_end=first_end+11+wire_size;second=bytearray(old_tape[first_end:second_end])
            assert second[11:14]==b'\x17\0\xd8' and second[17]==1
            assert int.from_bytes(second[24:28],'little')==old_module.stat().st_size
            second[24:28]=struct.pack('<I',len(image))
            new_body=marker+b'\2'+marker+b'\0'+struct.pack('<H',len(image))+image
            tape=b'\1'+struct.pack('<H',len(new_body))+new_body+second+old_tape[second_end:]
            assert tape[3+len(new_body)+len(second):]==old_tape[second_end:]
            (out/'script.bin').write_bytes(tape)
            meta.update(candidate='INC-001-03 aligned word road fill; accepted additive sampler unchanged',
                module_sha256=sha(new_module),package=str(candidate),comparison_scope='Only native road fill primitive; exact accepted moving traffic, sampler and timed commands')
            meta['files']['script.bin']=sha(out/'script.bin')
            (out/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
        fixtures[name]=dict(directory=str(out.relative_to(HERE)),files={p.name:sha(p) for p in out.iterdir() if p.is_file()},
            module_sha256=sha(old_module if name=='byte' else new_module),diagnostic=False,foreground_paced=False)
    for n,h in fixtures['byte']['files'].items():
        if n not in ('script.bin','expected.json'):assert fixtures['word']['files'][n]==h,n
    old_files={str(p.relative_to(control)):sha(p) for p in control.rglob('*') if p.is_file()}
    new_files={str(p.relative_to(candidate)):sha(p) for p in candidate.rglob('*') if p.is_file()}
    changed=[n for n,h in old_files.items() if new_files[n]!=h]
    assert changed==['helper/render_core.inc']
    assert set(new_files)-set(old_files)=={'helper/wide_fill.inc'}
    output=dict(checkpoint='84fa64d',module=metadata['module'],compiler=metadata['compiler'],control_module_sha256=sha(old_module),
        source_archive_sha256=sha(archive),source_packages=dict(control=str(control),candidate=str(candidate)),
        changed_source_files=changed,added_source_files=['helper/wide_fill.inc'],package_files=new_files,
        only_module_upload_and_load_length_changed=True,all_after_load_tape_bytes_unchanged=True,
        driver_assets_motion_native_buffers_and_timed_uart_unchanged=True,outbound_uart_bytes_per_frame=347,
        firmware_or_sdk_changed=False,new_allocations_or_leases=False)
    (HERE/'FIXTURES.json').write_text(json.dumps(fixtures,indent=2)+'\n')
    (HERE/'BUILD.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps(metadata['module'],indent=2))

if __name__=='__main__':build()
