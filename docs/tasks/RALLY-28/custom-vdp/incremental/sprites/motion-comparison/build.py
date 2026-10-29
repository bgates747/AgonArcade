"""Reuse frozen modules and the accepted motion/exit driver; no compilation."""
from pathlib import Path
import hashlib,json,shutil,sys
HERE=Path(__file__).resolve().parent
SPRITES=HERE.parent
sys.path.insert(0,str(SPRITES.parent))
from clear_test import raw_records
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()

def derive(tape,paced=False):
    output=bytearray();motion=0
    for record,raw in raw_records(tape):
        if record['loop'] and record['opcode']==1 and not motion:
            output+=raw+b'\15';motion+=1;continue
        if paced and record['loop'] and record['opcode']==1 and record.get('payload_bytes')==3:
            output+=b'\13'
        output+=raw
    assert motion==1
    return bytes(output)

def timed(tape):
    return b''.join(raw for record,raw in raw_records(tape) if record['loop'])

def build():
    registry=json.loads((SPRITES/'FIXTURES.json').read_text())
    review=SPRITES/'review/fixture04'
    accepted=json.loads((SPRITES/'review/FIXTURES.json').read_text())['motion']
    assert accepted['directory']=='fixture04'
    assert all(sha(review/n)==h for n,h in accepted['files'].items())
    result={};bodies=[]
    for name,key in [('affine','clipfix-affine'),('additive','clipfix-additive')]:
        entry=registry[key];source=SPRITES/entry['directory']
        assert all(sha(source/n)==h for n,h in entry['files'].items())
        dest=HERE/'fixtures'/name;dest.mkdir(parents=True,exist_ok=False)
        for n in entry['files']:shutil.copyfile(source/n,dest/n)
        original=(source/'script.bin').read_bytes();bodies.append(timed(original))
        (dest/'script.bin').write_bytes(derive(original))
        for n in ('motion.bin','probe.bin','artwork.vdu'):shutil.copyfile(review/n,dest/n)
        if name=='additive':assert derive(original,True)==(review/'script.bin').read_bytes()
        meta=json.loads((dest/'expected.json').read_text())
        accepted_meta=json.loads((review/'expected.json').read_text())
        for key in ('review_motion','player_final_station','final_scripted_positions','fixed_display_lanes'):
            meta[key]=accepted_meta[key]
        meta.update(candidate='Matched moving traffic '+name,paced=False,
            timing_scope='Completed unpaced moving-traffic fixture, including physics, scripted station/lane UART updates, drawing, swap and post-swap fence; nominal MOS120units/s; not hardware',
            outbound_uart_bytes_per_frame=347)
        meta['files'].update({n:sha(dest/n) for n in ('script.bin','motion.bin','probe.bin','artwork.vdu')})
        (dest/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
        result[name]=dict(directory=str(dest.relative_to(HERE)),files={p.name:sha(p) for p in dest.iterdir() if p.is_file()},
            module_sha256=entry['module_sha256'],diagnostic=False,foreground_paced=False)
    assert bodies[0]==bodies[1]
    for n in ('probe.bin','motion.bin','artwork.vdu','assets.vdu','common.vdu','run.txt'):
        assert result['affine']['files'][n]==result['additive']['files'][n],n
    (HERE/'FIXTURES.json').write_text(json.dumps(result,indent=2)+'\n')
    (HERE/'MATCH-PROOF.json').write_text(json.dumps(dict(
        accepted_review_files=accepted['files'],original_baseline_case='clipfix-affine',
        original_additive_case='clipfix-additive',same_timed_records=True,
        same_scripted_motion_bytes=True,same_driver_artwork_assets_and_common=True,
        additive_matches_accepted_review_except_deadline=True,frames=900,physics_ticks=3600,
        outbound_uart_bytes_per_frame=347,review_extra_motion_uart_bytes=70,
        retained_stock_swap_and_post_swap_fence=True,firmware_or_sdk_changed=False,
        modules={n:e['module_sha256'] for n,e in result.items()}),indent=2)+'\n')
    print('Matched moving-traffic inputs ready; accepted driver and modules unchanged.')

if __name__=='__main__':build()
