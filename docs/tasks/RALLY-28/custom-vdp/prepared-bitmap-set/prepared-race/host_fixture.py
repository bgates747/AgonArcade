"""Actual native60-frame smoke reference and source/installer ordering proof."""
from pathlib import Path
import ctypes as C
import hashlib
import importlib.util
import json
import struct

HERE=Path(__file__).resolve().parent
RUNTIME=HERE.parent/'runtime'
CONTROL=HERE.parents[1]/'incremental/round-trips'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def run():
    spec=importlib.util.spec_from_file_location('prepared_native_qualification',RUNTIME/'qualify.py')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    runtime=module.PreparedRuntime(module.specification(RUNTIME/'source'),RUNTIME/'.work/host/prepared-ordinary.so')
    assert struct.unpack_from('<I',runtime.data(1),20)[0]==0
    initial=module.snapshot(runtime)
    # The installer addresses only51996..52900; it cannot alter retained VM
    # roots/arrays. Actual source proves it performs no native Init or Tick.
    assert runtime.invoke('InitRace')==0
    for _ in range(2):assert runtime.invoke('Render30')==0
    tables=json.loads((module.BASE/'reference/tables.json').read_text())
    model=module.Traffic(tables,'circuit',3276800,1,99);player=3246800
    for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
        car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
    fixture=HERE/'fixtures/prepared';meta=json.loads((fixture/'expected.json').read_text())
    upload=(fixture/'common.vdu').read_bytes()+(fixture/'native.vdu').read_bytes();at=0;buffers={}
    while at<len(upload):
        if upload[at:at+3]==b'\x17\x1b\x20':at+=5;continue
        if upload[at:at+3]==b'\x17\x1b\x21':at+=8;continue
        assert upload[at:at+3]==b'\x17\0\xa0',(at,upload[at:at+9].hex())
        id,op=struct.unpack_from('<HB',upload,at+3);at+=6
        if op==2:buffers.pop(id,None)
        else:
            assert op==0,(id,op,at)
            n=struct.unpack_from('<H',upload,at)[0];at+=2
            buffers[id]=buffers.get(id,b'')+upload[at:at+n];at+=n
    uploaded_state={str(row['id']):buffers[row['id']].hex() for row in meta['state_buffers']}
    assert struct.unpack_from('<I',buffers[1],20)[0]==0
    (HERE/'INITIAL-UPLOAD-STATE.json').write_text(json.dumps(uploaded_state,indent=2)+'\n')
    motion=(fixture/'motion.bin').read_bytes();lanes=struct.pack('<6i',*meta['fixed_display_lanes'])
    for tick in range(1,241):
        record=(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record
        player+=tables['records'][record][1]*2;model.advance(player,tick)
        assert runtime.invoke('Tick120')==0;module.independent(runtime,model,player,tick)
        if tick%4:continue
        row=motion[(tick//4-1)*24:tick//4*24];runtime.store(4,0,row);runtime.store(5,0,lanes)
        for car,pos,lat in zip(model.cars,struct.unpack('<6I',row),meta['fixed_display_lanes']):car.position=pos;car.lateral=lat
        assert runtime.invoke('Render30')==0
    final=module.snapshot(runtime)
    assert final==json.loads((HERE/'EXPECTED-FINAL-60.json').read_text())
    assert runtime.invoke('StopRace')==0
    stop_generation=struct.unpack_from('<I',runtime.data(1),20)[0]
    counters=struct.unpack('<8I',runtime.data(51996));assert counters[3:]==(0,0,0,0,0)
    assert runtime.invoke(operation=3)==0;runtime.canaries();assert not runtime.live and runtime.grants==runtime.releases
    main=(HERE/'guest/src/main.cpp').read_text();native=(HERE/'guest/include/native.hpp').read_text()
    original=(CONTROL/'guest/src/main.cpp').read_text()
    start='        times[0]=fs::now();prts[0]=fs::timer();';end='        fs::reducedReads=false;'
    assert main[main.index(start):main.index(end)]==original[original.index(start):original.index(end)]
    setup=native[native.index('bool setup(){'):native.index('void startTimer(){')]
    assert setup.index('file("artwork.vdu")')<setup.index('prepared_setup::install()')<setup.index('invoke(Init)')
    stop=native[native.index('void stop(){'):native.index('bool save(')]
    assert stop.index('invoke(Stop)')<stop.index('transaction(3,p,2,3)')<stop.index('prepared_setup::finish()')<stop.index('mos_setkbvector(nullptr,0)')
    for n in ('capacity.hpp','recipe-pins.hpp','protocol.hpp','capacity-details.hpp'):
        assert sha(HERE/'guest/include'/n)==sha(HERE.parent/'capacity-02/guest/include'/n),n
    # Stable no-retry sequence follows the actual qualified901-image probe,
    # with new loader/warm/memory/counter/cleanup requests outside timed frames.
    prefix=16667;suffix=1156
    predicted={str(frames):dict(native_replies=prefix+2*frames+suffix,
        retained_bytes=10*(prefix+2*frames+suffix)) for frames in (60,900)}
    assert predicted['900']['retained_bytes']<220000
    output=dict(schema='rally.aff03.prepared-functional-host.v1',passed=True,
        frames=60,physics_ticks=240,warm_renders=2,final_state_exact=True,
        initial_generation_zero=True,installer_before_init=True,finish_after_stop_unload_before_callback_removal=True,
        expected_stop_generation=stop_generation,
        exact_original_hot_loop=True,expected_counters=list(counters),four_balanced_leases=runtime.peak==4,
        capacity_helpers_byte_identical=True,no_retry_expected_replies=predicted,
        transcript_capacity=220000,overflow_remains_fail_closed=True,
        memory_retry_headroom_is_finite=True,initial_state=initial,final_state=final,
        native_package_sha256=sha(RUNTIME/'target/rally-prepared.vdpl'),
        guest_sha256=sha(HERE/'guest/bin/probe.bin'),no_target_or_fps_claim=True)
    (HERE/'HOST-FIXTURE.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps({k:v for k,v in output.items() if k not in ('initial_state','final_state')},indent=2))


if __name__=='__main__':run()
