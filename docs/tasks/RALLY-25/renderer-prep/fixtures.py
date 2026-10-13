"""Expand frozen renderer comparisons and retained-page host observations."""
import importlib.util,json,struct,subprocess,time
from common import HERE,ROOT,WORK,stage,sha,dump

def extra_states(lap):
    cases=[];seq=100000
    positions=[0,1,6399,6400,6401,lap-1,lap-6400,lap-6800,lap-100000]
    for pos in positions:
        for phase in [0,3999,4000,7999]:
            for flags in range(8):
                for lateral,steer in [(-38400,-21),(-1,-1),(0,0),(1,1),(38400,21)]:
                    seq+=1;s=bytearray(112)
                    struct.pack_into('<4sHHIIIiHhiHHHH',s,0,b'R24S',1,112,7,seq,seq*4,pos,phase,steer,lateral,flags,0,0,0)
                    # Equal-depth slots, exact visibility thresholds, lap seams.
                    for i,z in enumerate([6399,6400,110000,110099,110100,6400]):
                        struct.pack_into('<iihBB',s,40+12*i,(pos+z)%lap,[-14260,14260,-1,0,1,9216][i],[-1920,1920,0,1,-1,1920][i],1,0)
                    cases.append((f'boundary:{pos}:{phase}:{flags}:{lateral}:{steer}',bytes(s)))
    for station in [i*lap//(lap//48000)+24000 for i in range(lap//48000)]:
        for distance in [6399,6400,50000,50099,50100]:
            seq+=1;s=bytearray(cases[0][1]);struct.pack_into('<I',s,12,seq);struct.pack_into('<i',s,20,(station-distance)%lap)
            cases.append((f'sign:{station}:{distance}',bytes(s)))
    return cases

def history_check(source):
    exe=WORK/'history'
    subprocess.run(['c++','-std=c++17','-O1','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer',str(HERE/'history.cpp'),'-I'+str(source/'rally-game/include'),'-I'+str(source/'rally-production/include'),'-o',str(exe)],check=True)
    sequence=[(0,0,0)]*4+[(1,1,0)]*4+[(1,1023,0)]*4+[(1,600,0)]*4+[(1,600,1),(1,600,0),(1,600,0),(1,600,0)]
    output=subprocess.check_output([str(exe)],input=''.join(f'{v} {o} {r}\n' for v,o,r in sequence),text=True)
    rows=[list(map(int,line.split(','))) for line in output.splitlines()]
    assert len(rows)==len(sequence)
    valid=[False,False];previous=[None,None];offsets=[0,0];skyvalid=[False,False]
    for frame,((version,offset,reset),row) in enumerate(zip(sequence,rows)):
        page=frame%2
        if reset:valid=[False,False];skyvalid=[False,False]
        changed=not valid[page] or previous[page]!=version
        delta=(offset-offsets[page]+1536)%1024-512
        full=not skyvalid[page] or abs(delta)>255
        expected=[page,None,0 if full else delta,0 if full or delta<=0 else 320-delta,319 if full or delta>0 else -delta-1 if delta else 0,int(full or delta!=0),24,0]
        assert (row[1]>0)==changed,(frame,row)
        assert [row[i] for i in range(8) if i!=1]==[expected[i] for i in range(8) if i!=1],(frame,row,expected)
        valid[page]=skyvalid[page]=True;previous[page]=version;offsets[page]=offset
    dump('page-history-cases.json',dict(scope='actual frozen host HUD/sky-cache commands; not VDP pixel/page execution',inputs=sequence,columns=['page','hud_command_bytes','sky_delta','sky_left','sky_right','repaint','viewport_top_low','viewport_top_high'],observed=rows))
    return len(rows)

def main():
    for name in ['FIXTURE-RECEIPT.json','scene-cases.json','page-history-cases.json']:
        (HERE/name).unlink(missing_ok=True)
    started=time.monotonic();source,exp,pins=stage()
    includes=['-I'+str(source/'rally-production/include'),'-I'+str(source/'rally-game/include')]
    subprocess.run(['c++','-std=c++17','-O2',*includes,str(exp/'assets.cpp'),'-o',str(WORK/'assets')],check=True)
    subprocess.run([str(WORK/'assets'),str(source/'rally-production'),str(WORK)],check=True)
    (exp/'.work').mkdir(exist_ok=True)
    (exp/'.work/asset_meta.h').write_bytes((WORK/'asset_meta.h').read_bytes())
    subprocess.run(['c++','-std=c++17','-O2','-ffp-contract=off',*includes,str(exp/'oracle.cpp'),'-o',str(WORK/'oracle')],check=True)
    subprocess.run(['cc','-O2','-ffp-contract=off','-fno-builtin','-shared','-fPIC','-DVDPL_VARIANT=2','-I'+str(ROOT.parent/'agon-vdplet/include'),str(exp/'module.c'),'-o',str(WORK/'module-B.so')],check=True)
    subprocess.run(['cc','-O1','-g','-ffp-contract=off','-fsanitize=address,undefined','-fno-omit-frame-pointer','-DVDPL_VARIANT=2','-I'+str(ROOT.parent/'agon-vdplet/include'),str(exp/'unit.c'),'-o',str(WORK/'unit')],check=True)
    subprocess.run([str(WORK/'unit')],check=True)
    spec=importlib.util.spec_from_file_location('frozen_r24_bench',exp/'test.py');benchmod=importlib.util.module_from_spec(spec);spec.loader.exec_module(benchmod)
    benchmod.WORK=benchmod.MODULES=WORK
    summaries=[];manifest=[]
    for track,lap in [('fuji',3276800),('oval',576000)]:
        base=[(f'preserved:{i}',s) for i,s in enumerate(benchmod.states(lap))];extra=extra_states(lap);cases=base+extra
        reference=subprocess.check_output([str(WORK/'oracle'),str(source/'rally-production'),track,'B'],input=b''.join(s for _,s in cases))
        bench=benchmod.Bench('B',track);at=0;counts=[];maxima=[0,0,0];aggregate=bytearray()
        for label,state in cases:
            lengths=struct.unpack_from('<6I',reference,at);at+=24;expected=[]
            for n in lengths[:3]:expected.append(reference[at:at+n]);at+=n
            assert bench.render(state)==0,(track,label);actual=bench.output();assert actual==expected,(track,label)
            assert struct.unpack_from('<3H',bytes(bench.data[31004]),18)==lengths[3:]
            aggregate.extend(b''.join(actual));counts.append(lengths[3:])
            maxima=[max(a,b) for a,b in zip(maxima,lengths[:3])]
            manifest.append(dict(track=track,label=label,state_hex=state.hex(),state_sha256=sha(state),output_sha256=[sha(x) for x in actual],counts=list(lengths[3:])))
        assert at==len(reference)
        summaries.append(dict(track=track,poses=len(cases),preserved_poses=len(base),new_poses=len(extra),max_command_lengths=maxima,
                              bands=[min(c[0] for c in counts),max(c[0] for c in counts)],cars=sorted({c[1] for c in counts}),signs=sorted({c[2] for c in counts}),
                              peak_leases=bench.peak,full_output_sha256=sha(aggregate),asset_sha256=sha((WORK/(track+'.r24')).read_bytes())))
    dump('scene-cases.json',dict(schema=1,scope='host exact commands against frozen independent R22/R24 oracle; no pixels or timing qualification',cases=manifest))
    pages=history_check(source)
    dump('FIXTURE-RECEIPT.json',dict(schema=1,pins=pins,rows=summaries,page_history_steps=pages,sanitizers='ASan/UBSan for retained histories and candidate capacity/rounding leaf; command comparisons use ordinary host shared library',elapsed_host_seconds=round(time.monotonic()-started,3),
        scene_cases_sha256=sha((HERE/'scene-cases.json').read_bytes()),files={p.name:sha(p.read_bytes()) for p in [HERE/'common.py',HERE/'fixtures.py',HERE/'history.cpp']}))
    print(json.dumps(summaries,indent=2));print('Retained-page steps:',pages)
if __name__=='__main__':main()
