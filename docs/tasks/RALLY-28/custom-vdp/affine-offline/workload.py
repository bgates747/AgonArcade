"""Recover actual affine inputs from the frozen full-race baseline; host only.

No historical source/fixture, firmware, repository or emulator is modified.
Generated C executes privately to recover actual commands, not estimated sizes.
"""
from pathlib import Path
import collections
import hashlib
import json
import struct
import subprocess
import sys

HERE = Path(__file__).resolve().parent
RACE = HERE.parent / 'full-race'
PACKAGE = RACE / '.work/packages/baseline'
WORK = HERE / '.work/workload'
ROOT = HERE.parents[4]
sys.path.insert(0, str(RACE))
from host_reference import independent, snapshot
from host_replay import PACED, BASE, Traffic, specification
from qualify_candidates import NativeRuntime


def digest(data):
    return hashlib.sha256(data).hexdigest()


def sha(path):
    return digest(Path(path).read_bytes())


def write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        assert path.read_bytes() == data, ('Preserve existing artifact', str(path))
    else:
        path.write_bytes(data)


def json_bytes(data):
    return (json.dumps(data, indent=2) + '\n').encode()


def artwork():
    """Interpret actual resident artwork upload, including stock command72 maps."""
    source = RACE / 'fixtures/baseline/artwork.vdu'
    stream = source.read_bytes()
    buffers, assets, matrices = {}, {}, {}
    at, bitmap = 0, None
    while at < len(stream):
        if stream[at:at+3] == b'\x17\0\xa0':
            key, op = struct.unpack_from('<HB', stream, at+3)
            at += 6
            if op == 2:
                buffers.pop(key, None)
            elif op == 0:
                n = struct.unpack_from('<H', stream, at)[0]
                at += 2
                buffers[key] = buffers.get(key, b'') + stream[at:at+n]
                at += n
            elif op == 72:
                options, source_id = struct.unpack_from('<BH', stream, at)
                at += 3
                assert options in (4, 16), options
                if options == 16:
                    map_id = struct.unpack_from('<H', stream, at)[0]
                    at += 2
                    values = buffers[map_id]
                    assert len(values) == 256
                    buffers[key] = bytes(values[p] for p in buffers[source_id])
                else:
                    values = stream[at:at+16]
                    at += 16
                    buffers[key] = bytes(values[p] for b in buffers[source_id] for p in (b >> 4, b & 15))
            elif op == 32:
                operation = stream[at]
                at += 1
                if operation == 0:
                    matrices[key] = [256,0,0,0,256,0]
                else:
                    assert operation == 11
                    number_format = stream[at]
                    at += 1
                    assert number_format == 192
                    coefficients = struct.unpack_from('<6h', stream, at)
                    at += 12
                    matrices[key] = [n*256 for n in coefficients]
            else:
                raise AssertionError(('artwork command', key, op, at))
        elif stream[at:at+3] == b'\x17\x1b\0':
            bitmap = stream[at+3]
            at += 4
        elif stream[at:at+3] == b'\x17\x1b\x21':
            width, height, pixel_format = struct.unpack_from('<HHB', stream, at+3)
            at += 8
            assert pixel_format == 1 and bitmap not in assets
            data = buffers[64000+bitmap]
            assert len(data) == width*height
            assets[bitmap] = (width, height, data)
        elif stream[at:at+3] == b'\x17\0\xf8':
            assert stream[at:at+7] == b'\x17\0\xf8\1\0\1\0'
            at += 7
        elif stream[at] == 17:
            at += 2
        else:
            raise AssertionError(('Unexpected artwork', at, stream[at:at+20].hex()))
    assert set(assets) == {*range(35), *range(120,128)}
    assert matrices == {63984:[-256,0,25856,0,256,0]}
    return assets, matrices


def decode(data, assets, matrices, clip, phase, frame, warm_index, buffer_id):
    """Decode emitted commands independently; retain actual Q8 matrices/positions."""
    at, bitmap, matrix_id = 0, None, 65535
    rows = []
    pending_clip = None
    while at < len(data):
        if data[at:at+6] == b'\x17\0\xa0\xff\xff\7':
            assert at+6 == len(data)
            at += 6
        elif data[at] == 24:
            left,bottom,right,top = struct.unpack_from('<4h', data, at+1)
            pending_clip = [left,top,right,bottom]
            at += 9
        elif data[at] == 25:
            assert data[at+1] == 4 and pending_clip is not None
            clip = pending_clip
            pending_clip = None
            at += 6
        elif data[at:at+3] == b'\x17\0\xa0':
            key, command, operation = struct.unpack_from('<HBB', data, at+3)
            assert command == 32
            at += 7
            if operation == 0:
                matrices[key] = [256,0,0,0,256,0]
            else:
                assert operation == 11 and data[at] == 200
                matrices[key] = list(struct.unpack_from('<6h', data, at+1))
                at += 13
        elif data[at:at+4] == b'\x17\0\x96\1':
            matrix_id = struct.unpack_from('<H', data, at+4)[0]
            at += 6
        elif data[at:at+3] == b'\x17\x1b\0':
            bitmap = data[at+3]
            at += 4
        elif data[at:at+3] == b'\x17\x1b\3':
            assert bitmap is not None and pending_clip is None
            x,y = struct.unpack_from('<hh', data, at+3)
            width,height,_ = assets[bitmap]
            matrix = matrices[matrix_id][:] if matrix_id != 65535 else [256,0,0,0,256,0]
            kind = 'player' if bitmap < 5 else ('traffic' if bitmap < 35 else 'sign')
            rows.append(dict(phase=phase,frame=frame,warm_index=warm_index,draw_index=len(rows),
                output_buffer=buffer_id,kind=kind,bitmap_id=bitmap,matrix_id=matrix_id,
                matrix_q8=matrix,x=x,y=y,clip=clip[:],source_width=width,source_height=height,
                affine_enabled=matrix_id != 65535,scale_q8=matrix[4],mirrored=matrix[0] < 0))
            at += 7
        else:
            raise AssertionError(('Unexpected emitted draw command', at, data[at:at+20].hex()))
    return rows,clip


def recover(assets, matrices):
    WORK.mkdir(parents=True,exist_ok=True)
    library = WORK / 'baseline.so'
    command = ['cc','-shared','-fPIC','-O1','-fno-builtin','-ffp-contract=off',
        '-I'+str(PACED / 'control/sdk/include'),str(PACKAGE/'native.c'),'-o',str(library)]
    subprocess.run(command,check=True)
    runtime = NativeRuntime(specification(PACKAGE), library)
    assert runtime.invoke('InitRace') == 0
    rows = []
    output_digest = hashlib.sha256()
    per_frame = []
    def render(phase, frame=0, warm_index=0):
        assert runtime.invoke('Render30') == 0
        completion = runtime.data(50304)
        lengths = struct.unpack_from('<III',completion,24)
        assert struct.unpack_from('<H',completion,44)[0] == 1
        clip = [0,24,319,223]
        count = 0
        for key,n in zip((50301,50302,50303), lengths):
            data = runtime.data(key)[:n]
            output_digest.update(data)
            if key != 50301:
                draws,clip = decode(data,assets,matrices,clip,phase,frame,warm_index,key)
                rows.extend(draws)
                count += len(draws)
        per_frame.append(dict(phase=phase,frame=frame,warm_index=warm_index,draws=count))
    render('warm',warm_index=1)
    render('warm',warm_index=2)
    fixture = RACE/'fixtures/baseline'
    metadata = json.loads((fixture/'expected.json').read_text())
    motion = (fixture/'motion.bin').read_bytes()
    assert sha(fixture/'motion.bin') == metadata['files']['motion.bin']
    tables = json.loads((BASE/'reference/tables.json').read_text())
    model = Traffic(tables,'circuit',3276800,1,99)
    player = 3246800
    for car,gap in zip(model.cars,[0,3199,3200,6400,18000,80000]):
        car.active=1;car.progress=player+gap;car.position=car.progress%model.lap;car.lateral=0
    lanes = struct.pack('<6i',*metadata['fixed_display_lanes'])
    tick_digest = hashlib.sha256()
    for tick in range(1,3601):
        record = (model.pace.record+1)%6 if model.pace.remaining == 0 else model.pace.record
        player += tables['records'][record][1]*2
        model.advance(player,tick)
        assert runtime.invoke('Tick120') == 0
        independent(runtime,model,player,tick)
        root,arrays = runtime.snapshot()
        tick_digest.update(bytes(root))
        for key in sorted(arrays):tick_digest.update(bytes(arrays[key]))
        if tick%4:continue
        frame = tick//4
        positions=[]
        for slot in range(6):
            position_phase = (frame-1+slot*47)%300
            gap = 110000-position_phase*450 if slot<3 else -24550+position_phase*450
            positions.append((player+gap)%model.lap)
        row = motion[(frame-1)*24:frame*24]
        assert row == struct.pack('<6I',*positions)
        runtime.store(4,0,row)
        runtime.store(5,0,lanes)
        for car,position,lateral in zip(model.cars,positions,metadata['fixed_display_lanes']):
            car.position,car.lateral = position,lateral
        render('measured',frame)
    final = snapshot(runtime)
    assert final == json.loads((RACE/'EXPECTED-FINAL-900.json').read_text())
    prior = json.loads((RACE/'STATE-PROOF-900.json').read_text())['ordinary']
    assert tick_digest.hexdigest() == prior['tick_states_sha256']
    assert runtime.invoke('StopRace') == 0 and runtime.invoke(operation=3) == 0
    runtime.canaries()
    assert not runtime.live and runtime.grants == runtime.releases
    return rows,dict(command=command,library_sha256=sha(library),full_output_sha256=output_digest.hexdigest(),
        tick_states_sha256=tick_digest.hexdigest(),exact_independent_final_state=True,
        balanced_leases=True,canaries=True,frames=900,warm_renders=2,physics_ticks=3600,
        per_frame_draws=per_frame)


def main():
    assets,matrices = artwork()
    pins = {str(p.relative_to(ROOT)):sha(p) for p in [
        Path(__file__),RACE/'fixtures/baseline/artwork.vdu',RACE/'fixtures/baseline/motion.bin',
        RACE/'fixtures/baseline/expected.json',RACE/'EXPECTED-FINAL-900.json',RACE/'STATE-PROOF-900.json',
        PACKAGE/'native.c',PACKAGE/'helper/rally_render.c',PACKAGE/'helper/render_core.inc',
        PACKAGE/'helper/rally_render.h',RACE/'host_reference.py',
        PACED/'qualify_candidates.py',PACED/'control/sdk/include/vdplet.h',
        BASE/'generated-state/adapter.py',BASE/'generated-state/host.py']}
    for path in sorted(PACKAGE.glob('*.bin')):
        pins[str(path.relative_to(ROOT))] = sha(path)
    for name in ('interface.json','root.json','backends.json','native-bindings.json'):
        path = PACKAGE/name
        pins[str(path.relative_to(ROOT))] = sha(path)
    bitmaps=[]
    for key,(width,height,data) in sorted(assets.items()):
        path=HERE/'assets'/('bitmap-%03d.rgba2222'%key)
        write(path,data)
        alpha=collections.Counter(p>>6 for p in data)
        bitmaps.append(dict(bitmap_id=key,kind='player' if key<5 else ('traffic' if key<35 else 'sign'),
            width=width,height=height,pixel_format='RGBA2222',format_id=1,path=str(path.relative_to(HERE)),
            bytes=len(data),sha256=digest(data),alpha_counts={str(k):alpha[k] for k in range(4)}))
    rows,replay = recover(assets,matrices)
    encoded = ''.join(json.dumps(row,separators=(',',':'))+'\n' for row in rows).encode()
    write(HERE/'OBSERVED-DRAWS.jsonl',encoded)
    measured = [row for row in rows if row['phase']=='measured']
    aggregated = collections.Counter(json.dumps({key:value for key,value in row.items() if key not in
        ('phase','frame','warm_index','draw_index')},sort_keys=True) for row in measured)
    observed_cases=[dict(json.loads(key),count=count) for key,count in sorted(aggregated.items())]
    summary={}
    target=[]
    for kind in ('traffic','sign','player'):
        selected=[row for row in measured if row['kind']==kind]
        scales=sorted({row['scale_q8'] for row in selected})
        summary[kind]=dict(draws=len(selected),bitmap_ids=sorted({r['bitmap_id'] for r in selected}),
            scale_q8_values=scales,scale_q8_min=min(scales),scale_q8_max=max(scales),
            mirrored_draws=sum(r['mirrored'] for r in selected),
            direct_no_transform_draws=sum(not r['affine_enabled'] for r in selected),
            y_min=min(r['y'] for r in selected),y_max=max(r['y'] for r in selected))
        wanted = [('far',scales[0]),('middle',scales[len(scales)//2]),('near',scales[-1])] if kind != 'player' else [('fixed',256)]
        for label,scale in wanted:
            row=next(r for r in selected if r['scale_q8']==scale)
            case={k:v for k,v in row.items() if k not in ('draw_index','warm_index','output_buffer')}
            case.update(name=kind+'-'+label,provenance='observed',observed_frame=row['frame'])
            target.append(case)
    # Synthetic reflection is explicit. It never becomes an observed player pose.
    player=next(row for row in measured if row['kind']=='player')
    mirrored={k:v for k,v in player.items() if k not in ('draw_index','warm_index','output_buffer')}
    mirrored.update(name='player-fixed-mirror',provenance='synthetic-coverage',frame=None,
        observed_frame=None,matrix_id=63984,matrix_q8=[-256,0,25856,0,256,0],mirrored=True,x=player['x']+1,
        affine_enabled=True,reason='Exercise full-size player reflection irrespective of replay yaw')
    target.append(mirrored)
    # Full-size and edge clips deliberately supplement, not describe, replay.
    for kind in ('traffic','sign'):
        seed=next(row for row in measured if row['kind']==kind)
        case={k:v for k,v in seed.items() if k not in ('draw_index','warm_index','output_buffer')}
        case.update(name=kind+'-fullsize',provenance='synthetic-coverage',frame=None,observed_frame=None,
            matrix_q8=[256,0,0,0,256,0],scale_q8=256,mirrored=False,x=110,y=110,
            affine_enabled=True,reason='Unit scale reference beyond observed shrinking range')
        target.append(case)
    seed=dict(target[1])
    for side,x,y in [('left',-10,110),('right',310,110),('top',110,15),('bottom',110,215)]:
        case=dict(seed,name='traffic-clipped-'+side,provenance='synthetic-coverage',frame=None,
            observed_frame=None,x=x,y=y,reason='Explicit clipping coverage; not an observed replay position')
        target.append(case)
    result=dict(schema=1,scope='Frozen full-race baseline host replay; no performance claims',
        matrix_layout='[xx,xy,tx,yx,yy,ty], each integer divided by256; source to destination',
        clip_layout='[left,top,right,bottom] inclusive screen pixels',
        bitmap_format='RGBA2222 one byte per source pixel; alpha in bits7..6',
        stock_upload_interpreted=True,bitmap_count=len(bitmaps),bitmaps=bitmaps,
        observed_draws=dict(path='OBSERVED-DRAWS.jsonl',sha256=digest(encoded),records=len(rows),
            measured_records=len(measured),warm_records=len(rows)-len(measured)),
        measured_summary=summary,observed_cases=observed_cases,target_cases=target,
        synthetic_coverage='Target entries explicitly tagged synthetic-coverage are not observed replay facts',
        source_sha256=pins,replay=replay)
    assert all(sha(ROOT/path)==value for path,value in pins.items())
    write(HERE/'WORKLOAD.json',json_bytes(result))
    print(json.dumps(dict(bitmaps=len(bitmaps),observed_draws=len(rows),summary=summary,
        target_cases=len(target),output=str(HERE/'WORKLOAD.json')),indent=2))

if __name__ == '__main__':main()
