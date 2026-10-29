"""Separate motion-review tape; leave measured sprite comparison bytes intact."""
from pathlib import Path
import hashlib,json,shutil,struct,subprocess,sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[6]
SPRITES=HERE.parent
BASE=ROOT/'docs/tasks/RALLY-25/native-demo'
sys.path.insert(0,str(SPRITES.parent))
from clear_test import raw_records
sys.path.insert(0,str(BASE.parent/'reference'))
from model import Cursor
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def build(directory='fixture'):
    out=HERE/directory;out.mkdir(exist_ok=False)
    old=json.loads((SPRITES/'FIXTURES.json').read_text())['clipfix-additive']
    source=SPRITES/old['directory']
    for n,h in old['files'].items():
        assert sha(source/n)==h,n
        shutil.copyfile(source/n,out/n)
    work=HERE/'.work';work.mkdir(exist_ok=True)
    shutil.copyfile(BASE/'.work/mos_api.inc',work/'mos_api.inc')
    shutil.copyfile(BASE/'prt.inc',HERE/'prt.inc')
    asm=(BASE/'guest.asm').read_text()
    load='''    ld hl,motion_name
    ld de,0x0A8000
    ld bc,21600
    push iy
    MOSCALL mos_load
    pop iy
    or a
    jp nz,failed
'''
    asm=asm.replace('    ld hl,script_name\n',load+'    ld hl,script_name\n',1)
    asm=asm.replace('    cp 9\n','    cp 13\n    jp z,review_motion\n    cp 9\n',1)
    motion='''; Review-only opcode13: next six scripted stations, fixed display lanes.
review_motion:
    ld hl,motion_header
    ld bc,motion_header_end-motion_header
    call send
    ld hl,(motion_cursor)
    ld bc,24
    push hl
    call send
    pop hl
    ld bc,24
    add hl,bc
    ld (motion_cursor),hl
    ld hl,lane_command
    ld bc,lane_command_end-lane_command
    call send
    jp next_record
motion_cursor: dl 0x0A8000
motion_name: asciz "motion.bin"
motion_header: db 23,0,160,4,0,5,194,0,0,24,0
motion_header_end:
lane_command: db 23,0,160,5,0,5,194,0,0,24,0
    dl -9216,-1,-1, 0,0,0 ; replaced by exact little-endian32 lane data below
lane_command_end:
'''
    # ez80asm DL is24-bit; use explicit bytes for the 32-bit array contract.
    lanes=struct.pack('<6i',-9216,0,9216,-9216,0,9216)
    motion=motion.replace('    dl -9216,-1,-1, 0,0,0 ; replaced by exact little-endian32 lane data below',
                          '    db '+','.join(str(b) for b in lanes))
    asm=asm.replace('raw_record:\n',motion+'\nraw_record:\n',1)
    asm=asm.replace('finish:\n','finish:\n    push hl\n    ld a,l\n    or a\n    jr z,finish_text_ready\n    ld hl,restore_text\n    ld bc,restore_text_end-restore_text\n    call send\nfinish_text_ready:\n    pop hl\n',1)
    asm+='\nrestore_text: db 22,8,23,0,192,0,23,1,1,26,12\nrestore_text_end:\n'
    # Completion text is also shown on the visible single text page.
    asm=asm.replace('complete:\n','complete:\n    ld hl,restore_text\n    ld bc,restore_text_end-restore_text\n    call send\n',1)
    asm=asm.replace('    db 28,0,29,39,28,31,0,0','    db 26,12,31,0,0',1)
    (HERE/'guest.asm').write_text(asm)
    assembler=ROOT.parent/'golem/docs/tasks/GOLEM-007/build/ez80asm'
    subprocess.run([str(assembler),'guest.asm','.work/probe.bin','-c'],cwd=HERE,check=True)
    assert (work/'probe.bin').stat().st_size<65536
    shutil.copyfile(work/'probe.bin',out/'probe.bin')
    tables=json.loads((BASE.parent/'reference/tables.json').read_text())
    cursor=Cursor(remaining=tables['records'][0][0]);player=3246800;data=bytearray();gaps=[]
    for frame in range(900):
        for _ in range(4):player+=cursor.advance(tables['records'],tables['sine'])
        distances=[]
        for car in range(6):
            phase=(frame+car*47)%300
            gap=110000-phase*450 if car<3 else -24550+phase*450
            distances.append(gap)
            data+=struct.pack('<I',(player+gap)%3276800)
        gaps.append(distances)
    assert len(data)==21600 and 0xA8000+len(data)<0xB0000
    assert max((source/n).stat().st_size for n in ('artwork.vdu','assets.vdu','native.vdu','common.vdu'))<0x28000
    (out/'motion.bin').write_bytes(data)
    tape=bytearray();inserted=0
    for r,b in raw_records((source/'script.bin').read_bytes()):
        if r['loop'] and r['opcode']==1 and not inserted:
            tape+=b+b'\15';inserted+=1;continue
        if r['loop'] and r['opcode']==1 and r.get('payload_bytes')==3:
            tape+=b'\13'  # Review target30Hz, four nominal MOS units/frame.
        tape+=b
    assert inserted==1
    (out/'script.bin').write_bytes(tape)
    sys.path.insert(0,str(ROOT/'docs/tasks/RALLY-28/custom-vdp/paced-road'))
    from quiet_startup import blank_status
    blank_status(out)
    meta=json.loads((out/'expected.json').read_text())
    meta.update(candidate='Review only: scripted approaching/overtaking traffic; not benchmark',paced=True,
                review_motion=True,player_final_station=player%3276800,
                final_scripted_positions=list(struct.unpack('<6I',data[-24:])),fixed_display_lanes=list(struct.unpack('<6i',lanes)))
    meta['files'].update({n:sha(out/n) for n in ('script.bin','probe.bin','motion.bin')})
    (out/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
    files={p.name:sha(p) for p in out.iterdir() if p.is_file()}
    (HERE/'FIXTURES.json').write_text(json.dumps({'motion':dict(directory=directory,files=files,module_sha256=old['module_sha256'])},indent=2)+'\n')
    (HERE/'BUILD.json').write_text(json.dumps(dict(module_unchanged=True,benchmark_inputs_unchanged=True,
        motion_table_bytes=len(data),gap_min=min(map(min,gaps)),gap_max=max(map(max,gaps)),
        traffic='Three approaching/slower and three passing/faster, cycling every300frames',
        pacing='30Hz foreground review only, not performance evidence',text_mode_on_exit=8,
        driver_bytes=(out/'probe.bin').stat().st_size,files=files),indent=2)+'\n')

if __name__=='__main__':build(sys.argv[1] if len(sys.argv)>1 else 'fixture')
