"""Independently audit long replay sequences, raw state, finite values and growth."""
import argparse,csv,hashlib,json,struct
from pathlib import Path
from profile import TASK
from native_run import sha

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--oval',required=True);p.add_argument('--fuji',required=True);a=p.parse_args()
    destination=TASK/'evidence/golem-stability'/a.name;destination.mkdir(exist_ok=False)
    reports=[];sources={}
    for track,name in [('oval',a.oval),('fuji',a.fuji)]:
        root=TASK/'evidence/golem-stability'/name
        def record(file):
            path=root/file;sources[str(path)]=sha(path);return path
        manifest=json.loads(record('manifest.json').read_text());assert manifest['completed'] and manifest['headless'] and manifest['track']==track
        assert manifest['runtime_before']==manifest['runtime_after']
        assert not any(s in manifest['actual_command'] for s in ['-u','--unlimited_cpu'])
        assert record('host-sanitizers.txt').read_bytes()==b''
        expected=record('expected.dat').read_bytes();calls=list(csv.DictReader(record('calls.csv').open()))
        summary=next(csv.DictReader(record('replay-summary.csv').read_text().splitlines()[:2]));count=int(summary['frames'])
        assert count==len(calls) and len(expected)==count*80 and count>=18000
        assert int(summary['ticks'])>=72000 and manifest['done_ns']-manifest['go_ns']>=600*10**9
        assert int(summary['scene_bytes'])==count*97 and int(summary['cleanup'])==1
        controls={key:set() for key in ['steering','grip','surface','flags']};positions=[];phases=[];laterals=[];speeds=[];seams=0;phaseSeams=0;overlapPoses=0
        for i,row in enumerate(calls):
            assert int(row['call'])==i and [int(row[k]) for k in ['valid','wrap','count','last','error','expected']]==[1,1,i+1,i,0,i+1]
            assert int(row['read_errors'])==int(row['nonfinite'])==0
            state=expected[i*80:(i+1)*80];assert bytes.fromhex(row['active_hex'])==state
            assert struct.unpack_from('<HHHH',state)==(1,80,i,int(track=='fuji'))
            position=struct.unpack_from('<i',state,8)[0];phase=struct.unpack_from('<H',state,12)[0]
            steering=struct.unpack_from('<h',state,14)[0];lateral=struct.unpack_from('<i',state,16)[0];speed,surface=struct.unpack_from('<HH',state,20)
            flags,grip,duplicate,seal=struct.unpack_from('<4H',state,72);assert duplicate==i and seal==0x5a19
            for key,value in [('steering',steering),('grip',grip),('surface',surface),('flags',flags)]:controls[key].add(value)
            # Count natural lap/stripe crossings only in continuous simulation,
            # excluding the64 injected frozen fixtures and their next boundary.
            if i and i%1200>64:
                seams+=position<positions[-1];phaseSeams+=phase<phases[-1]
            lap=576000 if track=='oval' else 3276800
            visible=[((struct.unpack_from('<i',state,24+8*j)[0]-position+lap)%lap)//100 for j in range(6)]
            visible=[z for z in visible if 64<=z<=1100]
            # Nearby visible depths exercise draw ordering; this is a coverage
            # count, not a replacement for frozen per-object image masks.
            overlapPoses+=any(abs(x-y)<=100 for j,x in enumerate(visible) for y in visible[j+1:])
            positions.append(position);phases.append(phase);laterals.append(lateral);speeds.append(speed)
        assert {-21,0,21}<=controls['steering'] and {25,200}<=controls['grip']
        assert controls['surface']=={0,1,2} and {0,1,2}<=controls['flags'] and seams>0 and phaseSeams>0 and overlapPoses>0
        assert min(laterals)==-38400 and max(laterals)==38400
        # Cache warmup may allocate once; after one complete input/pose cycle,
        # every frame must have the identical final live allocation signature.
        keys=['matrices','live_allocs','live_bytes'];signatures=[tuple(int(row[k]) for k in keys) for row in calls]
        last=signatures[-1];warmEnd=max([i+1 for i,value in enumerate(signatures) if value!=last],default=0)
        assert warmEnd<1200 and all(value==last for value in signatures[warmEnd:]),(track,warmEnd,last)
        raw=record('replay-readback.dat').read_bytes();assert raw[:12]==struct.pack('<6H',1,1,count,count-1,0,count) and raw[12:]==expected[-80:]
        memory=list(csv.reader(record('memory.csv').open()));assert [int(r[0]) for r in memory]==[100,200]
        report={'track':track,'source_run':name,'frames':count,'guest_seconds':int(summary['ticks'])/120,'wall_seconds_including_final_readback':(manifest['done_ns']-manifest['go_ns'])/1e9,
            'all_payloads_exact':True,'missing_duplicate_or_protocol_errors':0,'nonfinite':0,'natural_lap_crossings':seams,'natural_stripe_crossings':phaseSeams,'nearby_visible_depth_poses':overlapPoses,
            'steering_values':sorted(controls['steering']),'grip_range':[min(controls['grip']),max(controls['grip'])],'surfaces':sorted(controls['surface']),'flags':sorted(controls['flags']),
            'lateral_range_q8':[min(laterals),max(laterals)],'speed_range':[min(speeds),max(speeds)],'warmup_last_growth_frame':warmEnd-1,
            'steady_signature':dict(zip(keys,last)),'steady_frames':count-warmEnd,'after_cleanup':list(map(int,memory[-1][1:3]))}
        reports.append(report)
    result={'pass':True,'scope':__doc__,'runs':reports,'source_hashes':sources,'auditor_sha256':sha(Path(__file__)),
        'limits':'Synthetic deterministic keys/clock; real keyboard-map chain is covered by separate native frontend tests. Observer allocations exclude malloc paths bypassing heap_caps. No hardware or performance claim. Lifecycle and final loader qualification remain separate.'}
    (destination/'qualification.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result['runs'],indent=2))
if __name__=='__main__':main()
