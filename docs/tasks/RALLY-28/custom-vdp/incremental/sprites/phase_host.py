"""Qualify isolated phase modules against actual uninstrumented C and world model.

The host counter is a fake sequencing aid and supplies no timing evidence.
Outputs stay inside an already-built .work/phase-CASE directory.
"""
import argparse
import ctypes as C
import hashlib
import json
from pathlib import Path
import struct
import subprocess
import sys

from phase_test import HERE, THROUGHPUT, PACED, CONTROL, LOG, HEADER, ROW, PRIVATE, save, sha
sys.path.insert(0, str(THROUGHPUT))
sys.path.insert(0, str(PACED))
from span_check import SpanRuntime
from qualify_candidates import specification, Traffic, contact, BASE
from host import Request
from phase_verify import decode
from phase_qualify import ordered_tail


def install_sprites(runtime, package, fixture):
    if not (package/'helper/sprite_io.inc').exists():
        return
    resources = json.loads((package/'native-bindings.json').read_text())['bindings']['resources']
    for base, count, size in ((resources['traffic_bitmap_base'],30,102*77),
                              (resources['sign_bitmap_base'],8,64*64)):
        for bitmap in range(base, base+count):
            key = 64000+bitmap
            width, height = (102,77) if bitmap<120 else (64,64)
            image = bytes(((x*13+y*17+bitmap*7)&63)|(((x+y+bitmap)&3)<<6)
                          for y in range(height) for x in range(width))
            assert len(image) == size
            runtime.install(key,image,1)
    for slot in range(8):
        runtime.install(50710+slot, bytes(99*75 if slot<6 else 62*62))


def qualify(case):
    work = HERE/'.work'/('phase-'+case)
    report = json.loads((work/'BUILD.json').read_text())
    package, fixture = work/'package', work/'fixture'
    source = Path(report['source_package'])
    meta = json.loads((fixture/'expected.json').read_text())
    assert meta['frames'] == 128
    lite_mode=meta.get('phase_lite',False)
    libraries = {}
    for kind, path in (('phase',package),('plain',source)):
        library = work/('phase-host-'+kind+'.so')
        subprocess.run(['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',
                        '-I'+str(CONTROL/'sdk/include'), str(path/'native.c'),'-o',str(library)],check=True)
        libraries[kind] = library
    phased = SpanRuntime(specification(package), libraries['phase'])
    plain = SpanRuntime(specification(source), libraries['plain'])
    for runtime, path in ((phased,package),(plain,source)):
        install_sprites(runtime,path,fixture)
        assert runtime.invoke('InitRace') == 0
    phased.install(LOG, bytes(meta['phase_header_bytes']+128*meta['phase_row_bytes']))

    def private(op):
        request = Request(C.sizeof(Request),2,PRIVATE+op,phased.argument_id,0,2)
        rc = phased.lib.vdplet_entry(C.byref(phased.host),C.byref(request))
        assert not phased.live
        phased.canaries()
        return rc

    if not lite_mode:assert private(0) == 0
    tables = json.loads((BASE/'reference/tables.json').read_text())
    model = Traffic(tables,'circuit',3276800,1,99)
    player = 3246800
    for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
        car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
    spec = phased.spec
    digest = hashlib.sha256()
    command_digest = hashlib.sha256()
    for tick in range(1,513):
        speed=tables['records'][(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record][1]
        player += speed*2
        model.advance(player,tick)
        assert phased.invoke('Tick120') == plain.invoke('Tick120') == 0
        root,arrays = phased.snapshot()
        assert (root,arrays) == plain.snapshot()
        expected=dict(worldTick=tick,playerStation=player%model.lap,playerUnwrapped=player,
            renderPhase=player%8000,routeRecord=model.pace.record,routeRemaining=model.pace.remaining,
            routeHeading=model.pace.heading,routeLateral=model.pace.lateral)
        for field,value in expected.items():
            assert spec.get(root,field) == value,(case,tick,field)
        hits=[]
        for index,car in enumerate(model.cars):
            hit=int(contact(car.position,car.lateral,player%model.lap,0,model.lap));hits.append(hit)
            for field,value in [('active',car.active),('position',car.position),('progress',car.progress),
                                ('lateral',car.lateral),('contacts',hit)]:
                assert spec.array_get(arrays,field,index) == value,(case,tick,field,index)
        assert spec.get(root,'contactAny') == bool(any(hits))
        if tick%4:
            continue
        assert phased.invoke('Render30') == plain.invoke('Render30') == 0
        root,arrays=phased.snapshot()
        assert (root,arrays) == plain.snapshot()
        completion=phased.data(50304)
        assert completion == plain.data(50304)
        for key,n in zip((50301,50302,50303),struct.unpack_from('<III',completion,24)):
            commands=phased.data(key)[:n]
            assert commands == plain.data(key)[:n]
            command_digest.update(commands)
        assert phased.data(50700) == plain.data(50700)
        if (package/'helper/sprite_io.inc').exists():
            for key in range(50710,50718):
                assert phased.data(key) == plain.data(key)
        digest.update(bytes(root)+b''.join(bytes(arrays[k]) for k in sorted(arrays)))
        for op in (range(2) if lite_mode else range(1,8)):
            assert private(op) == 0
        assert (root,arrays) == phased.snapshot()
    if not lite_mode:assert private(8) == 0
    if lite_mode:
        from phase_lite import decode as lite_decode,tail_check
        decoded=lite_decode(phased.data(LOG),128)
    else:decoded=decode(phased.data(LOG),128)
    final={'1':bytes(root).hex(),**{str(a['buffer']):bytes(arrays[a['buffer']]).hex()
        for a in spec.arrays.values() if a['access']==3}}
    tail = (tail_check if lite_mode else ordered_tail)(meta,(fixture/'script.bin').read_bytes())
    for runtime in (phased,plain):
        assert runtime.invoke('StopRace') == 0 and runtime.invoke(operation=3) == 0
        assert runtime.grants == runtime.releases and not runtime.live
        runtime.canaries()
        assert runtime.peak == 4
    result=dict(candidate=case,frames=128,ticks=512,phase_rows=decoded['frames'],
        phase_lite=lite_mode,
        independent_world_contact_model=True,all_state_matches_actual_uninstrumented_C=True,
        all_drawing_and_pixel_buffers_match_actual_uninstrumented_C=True,
        full_frame_state_sha256=digest.hexdigest(),drawing_command_sha256=command_digest.hexdigest(),
        final_buffers=final,peak_leases=4,balanced_leases=True,guards_unchanged=True,
        tail=tail,phase_clock='HOST FAKE COUNTER: sequencing/protocol proof only; no timing evidence',
        artwork='Deterministic synthetic colors and all four alpha values; final authoritative state is independent of sprite pixels.',
        libraries={kind:sha(path) for kind,path in libraries.items()},
        source_files={p.name:sha(p) for p in (HERE/'phase_host.py',HERE/'phase_test.py',HERE/'phase_entry.inc')},
        firmware_changed=False,sdk_changed=False,emulator_run=False)
    save(work/'HOST-EXPECTED.json',result)
    print(case,'PASS:128frames/512ticks;all-state/output equality,independent model,phase protocol,4leases')
    return result


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--case',required=True)
    args=parser.parse_args()
    qualify(args.case)
