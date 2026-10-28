"""Verify and preserve the exact host-qualified span candidate and sources."""
from pathlib import Path
import hashlib
import json
import struct
import subprocess
import zipfile
from span_build import HERE,PACED,CONTROL,WORK,BUFFER,BYTES,WIDTH,HEIGHT,setup_bytes,cleanup_bytes,sha
from freeze_control import records

def package():
    build=json.loads((HERE/'span-BUILD.json').read_text())
    for mode in ('ordinary','sanitized'):
        result=json.loads((HERE/('span-HOST-'+mode+'.json')).read_text())
        for name,digest in result['source_files'].items():assert sha(HERE/name)==digest,name
        assert result['replay']['stock_quad_rasters_equal']==900
    for name,digest in build['source_files'].items():assert sha(HERE/name)==digest,name
    for name,digest in build['helper_files'].items():assert sha(WORK/'package'/name)==digest,name
    assert sha(WORK/'target/rally-render.vdpl')==build['module']['sha256']
    for name,digest in build['fixture']['files'].items():assert sha(WORK/'fixture'/name)==digest,name
    control=json.loads((PACED/'CONTROL.json').read_text())
    for name,digest in control['immutable_files'].items():assert sha(PACED/name)==digest,name
    fixture=WORK/'fixture';tape=(fixture/'script.bin').read_bytes();parsed=records(tape)
    for r in parsed:
        if r['opcode']==6:assert r['payload_bytes']==(fixture/r['filename']).stat().st_size,r
    native=(fixture/'native.vdu').read_bytes();old=(CONTROL/'fixture/native.vdu').read_bytes()
    assert native==old+setup_bytes()
    clean=parsed[-2];assert clean['opcode']==1 and not clean['loop']
    assert tape[clean['payload_offset']:clean['payload_offset']+clean['payload_bytes']]==cleanup_bytes()
    setup=setup_bytes();assert setup[:6]==cleanup_bytes()
    assert setup[6:12]==b'\x17\0\xa0'+struct.pack('<H',BUFFER)+b'\0'
    assert struct.unpack_from('<H',setup,12)[0]==BYTES and setup[14:14+BYTES]==bytes(BYTES)
    assert setup[14+BYTES:]==b'\x17\x1b\x20'+struct.pack('<H',BUFFER)+b'\x17\x1b\x21'+struct.pack('<HHB',WIDTH,HEIGHT,1)
    frames={line.split('\t')[0].rsplit(':',1)[-1]:int(line.split('\t')[1]) for line in (WORK/'target/rally-render.su').read_text().splitlines()}
    upstream=Path('/Agon/mystuff/agon-vdplet/build/firmware')
    pin='1056ee38ec1cc68ed327bd32ee47d04b1c30597c';stock={}
    for name in ('video/agon_palette.h','video/vdu_sprites.h','video/context/graphics.h','video/sprites.h'):
        data=subprocess.check_output(['git','-C',str(upstream/'upstream.git'),'show',pin+':'+name])
        assert (upstream/'firmware-src'/name).read_bytes()==data,name
        stock[name]=hashlib.sha256(data).hexdigest()
    final=dict(schema=1,module_sha256=build['module']['sha256'],protected_files_unchanged=len(control['immutable_files']),
        fixture_external_lengths_verified=True,one_contiguous_bitmap_block=True,setup_bytes=len(setup),
        post_unload_cleanup_verified=True,static_target_stack_frames=frames,
        stack_limitations='Compiler frames only; runtime callers/callbacks/interrupts not dynamically qualified',
        ordinary_and_sanitized_replay_equal=json.loads((HERE/'span-HOST-ordinary.json').read_text())['replay']==json.loads((HERE/'span-HOST-sanitized.json').read_text())['replay'],
        pinned_vdp_source=pin,palette_bitmap_lifetime_sources_byte_identical_to_pin=stock,
        emulator_launched=False,firmware_changed=False,sdk_changed=False)
    (HERE/'span-FINAL.json').write_text(json.dumps(final,indent=2)+'\n')
    files={p.name:p for p in HERE.iterdir() if p.is_file() and (p.name.startswith('span-') or p.name in ('span.inc','span_build.py','span_check.py','span_package.py')) and p.name not in ('span-PACKAGE.zip','span-PACKAGE.json')}
    for section in ('fixture','target'):
        for p in sorted((WORK/section).iterdir()):
            if p.is_file():files[section+'/'+p.name]=p
    for p in sorted((WORK/'package').rglob('*')):
        if p.is_file() and (p.suffix in ('.c','.h','.inc','.json') or p.name.startswith('array-') or p.name in ('state.bin','common-install.bin','native-install.bin')):
            files['package/'+str(p.relative_to(WORK/'package'))]=p
    archive=HERE/'span-PACKAGE.zip'
    with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as out:
        for name,p in sorted(files.items()):
            info=zipfile.ZipInfo(name,(2026,10,28,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o644<<16
            out.writestr(info,p.read_bytes())
    receipt=dict(schema=1,archive=archive.name,sha256=sha(archive),members=len(files),module_sha256=build['module']['sha256'],
        member_sha256={name:sha(p) for name,p in sorted(files.items())},purpose='Exact host-qualified span candidate; no target timing/visual acceptance')
    (HERE/'span-PACKAGE.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(final,indent=2));print(archive,receipt['sha256'])
    return receipt

if __name__=='__main__':package()
