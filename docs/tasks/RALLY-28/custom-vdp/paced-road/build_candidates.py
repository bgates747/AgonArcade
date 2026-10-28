"""Build isolated native variants and patch only their setup image in the tape."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import struct
import subprocess
import sys
from freeze_control import records

HERE = Path(__file__).resolve().parent
CONTROL = HERE/'control'
WORK = HERE/'.work/candidates'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
VARIANTS = {
    'control': None,
    'float-tri-layered': (0,0,0,0),
    'integer-tri-layered': (1,0,0,0),
    'float-quad-layered': (0,1,0,0),
    'integer-quad-layered': (1,1,0,0),
    'float-tri-strips': (0,0,1,0),
    'integer-tri-strips': (1,0,1,0),
    'float-quad-strips': (0,1,1,0),
    'integer-quad-strips': (1,1,1,0),
    'integer-quad-segments': (1,1,1,1),
    'float-quad-segments': (0,1,0,1),
}


def patch_tape(image):
    tape = (CONTROL/'fixture/script.bin').read_bytes()
    old = (CONTROL/'package/rally-render.vdpl').read_bytes()
    patched = bytearray()
    changes = []
    for r in records(tape):
        start = r['offset']
        if 'payload_offset' in r and r['opcode'] in (1,2):
            at, n = r['payload_offset'], r['payload_bytes']
            body = tape[at:at+n]
            if r['opcode'] == 1 and old in body:
                assert body.startswith(b'\x17\0\xa0\x81\xc4\2\x17\0\xa0\x81\xc4\0')
                assert body[14:] == old and len(image)<60000
                body = body[:12]+struct.pack('<H',len(image))+image
                patched += b'\1'+struct.pack('<H',len(body))+body
                changes.append('setup module upload')
            elif r['opcode'] == 2 and body[:3] == b'\x17\0\xd8' and body[6] == 1:
                body = bytearray(body)
                assert struct.unpack_from('<I',body,13)[0] == len(old)
                struct.pack_into('<I',body,13,len(image))
                patched += tape[start:at]+body
                changes.append('setup LOAD image size')
            else:
                patched += tape[start:at+n]
        else:
            # Every record's end is the next record offset; compute below instead.
            all_records = records(tape)
            pos = next(i for i,x in enumerate(all_records) if x['offset']==start)
            end = all_records[pos+1]['offset'] if pos+1<len(all_records) else len(tape)
            patched += tape[start:end]
    assert changes == ['setup module upload','setup LOAD image size']
    # Exact byte equality for every hot-loop record, including the pacer/swap.
    old_records = records(tape); new_records = records(patched)
    assert len(old_records)==len(new_records)
    for i,(a,b) in enumerate(zip(old_records,new_records)):
        if not a['loop']:continue
        ae=old_records[i+1]['offset'];be=new_records[i+1]['offset']
        assert tape[a['offset']:ae] == patched[b['offset']:be]
    return bytes(patched)


def build(only=None):
    control = json.loads((HERE/'CONTROL.json').read_text())
    for n,digest in control['immutable_files'].items():assert sha(HERE/n)==digest,n
    report = json.loads((HERE/'CANDIDATE-BUILD.json').read_text()) if only else {}
    for name,flags in VARIANTS.items():
        if only and name not in only:continue
        out = WORK/name
        out.mkdir(parents=True,exist_ok=True)
        package = out/'package'
        shutil.copytree(CONTROL/'package',package,dirs_exist_ok=True)
        core=(CONTROL/'package/helper/render_core.inc').read_text()
        if flags is not None:
            integer,quad,strips,segments=flags
            start=core.index('static void section(');end=core.index('static int ahead(',start)
            macros=f'#define R28_INTEGER {integer}\n#define R28_QUAD {quad}\n#define R28_STRIPS {strips}\n'
            core=core[:start]+macros+(HERE/'road_candidate.inc').read_text()+'\n'+core[end:]
            if segments:
                core=core.replace('int yc = *curve + 1, ys = *stripe, yy = yc < ys ? yc : ys;',
                    'int k = (a->fraction14 + s32(a->t[7] + (y-96)*4)) >> 14;\n'
                    '        int yc = y+1;\n'
                    '        while (yc < 224 && ((a->fraction14 + s32(a->t[7] + (yc-96)*4)) >> 14) == k) ++yc;\n'
                    '        int ys = *stripe, yy = yc < ys ? yc : ys;')
                core=core.replace('if (yy == yc)\n            ++curve;', '/* Segment boundaries are discovered from the frozen depth/lookup table. */')
        (package/'helper/render_core.inc').write_text(core)
        assert sha(package/'native.c')==sha(CONTROL/'package/native.c')
        result=subprocess.run([sys.executable,str(CONTROL/'sdk/tools/build_module.py'),str(package/'native.c'),
            '--name','rally-render','--build-id','0x474c3731','--output',str(out/'target'),
            '--text-limit','32768','--data-limit','4096','--stack-limit','2048','--image-limit','65536'],
            check=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
        module=json.loads(result.stdout)['module']
        if name=='control':assert module['sha256']==control['immutable_files']['control/package/rally-render.vdpl']
        fixture=out/'fixture';fixture.mkdir(exist_ok=True)
        for n in ('probe.bin','artwork.vdu','assets.vdu','common.vdu','native.vdu'):
            shutil.copyfile(CONTROL/'fixture'/n,fixture/n)
        (fixture/'script.bin').write_bytes(patch_tape((out/'target/rally-render.vdpl').read_bytes()))
        meta=json.loads((CONTROL/'fixture/expected.json').read_text())
        meta.update(module_sha256=module['sha256'],package=str(package),candidate=name,
                    comparison_scope='Only road helper code/module setup changed; exact reviewed driver and per-frame tape retained')
        meta['files']={n:sha(fixture/n) for n in ('probe.bin','script.bin','artwork.vdu','assets.vdu','common.vdu','native.vdu')}
        (fixture/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
        (fixture/'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
        report[name]=dict(flags=flags,module=module,helper_sha256=sha(package/'helper/render_core.inc'),
            fixture_files={p.name:sha(p) for p in sorted(fixture.iterdir())},
            per_frame_tape_byte_identical=True,driver_byte_identical=True,firmware_changed=False)
        print(name,module['resident_text_bytes'],module['resident_data_bytes'],module['sha256'][:16],flush=True)
    (HERE/'CANDIDATE-BUILD.json').write_text(json.dumps(report,indent=2)+'\n')


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--only',nargs='+',choices=list(VARIANTS));a=p.parse_args();build(a.only)
