"""Verify full-scene native output against the independent preserved world model."""
from pathlib import Path
import argparse,csv,hashlib,json,struct,sys
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'reference'))
from model import Traffic,contact

def verify(directory):
    directory=Path(directory);meta=json.loads((directory/'expected.json').read_text());r=json.loads((directory/'result.json').read_text())
    assert not (directory/'failure.txt').exists()
    assert r['valid'] and r['frames']==meta['frames'] and r['physics_ticks']==meta['physics_ticks']
    assert r['repaint_calls']>=2 and r['audio_changes']>0
    if r['frames']==900:assert r['scroll_calls']>0,'Full Fuji workload did not scroll'
    assert r['timer_restored'] and r['unloaded'] and r['request']==r['frames']+2
    data=(directory/'state.bin').read_bytes();assert len(data)==sum(b['bytes'] for b in meta['buffers'])
    buffers={};at=0
    for b in meta['buffers']:buffers[b['id']]=data[at:at+b['bytes']];at+=b['bytes']
    iface=meta['interface'];root=buffers[iface['state_buffer']]
    def get(name):
        f=next(g for g in iface['globals'] if g['name']==name)
        return int.from_bytes(root[f['offset']:f['offset']+f['bytes']],'little',signed=f['type'].startswith('sint'))
    tables=json.loads((HERE.parent/'reference/tables.json').read_text());lap=3276800
    model=Traffic(tables,'circuit',lap,7,2);player=lap-6800;phase=0
    for tick in range(1,r['physics_ticks']+1):
        record=(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record
        speed=tables['records'][record][1];player=(player+speed*2)%lap;phase=(phase+speed*2)%8000
        model.advance(player,tick)
    expected=dict(worldTick=r['physics_ticks'],playerStation=player,playerLateral=0,renderPhase=phase,renderSteering=0,
                  routeRecord=model.pace.record,routeRemaining=model.pace.remaining,routeHeading=model.pace.heading,
                  routeLateral=model.pace.lateral,renderRequest=r['request'],renderSession=7,renderFlags=3)
    for k,v in expected.items():assert get(k)==v,(k,get(k),v)
    contacts=[]
    for i,c in enumerate(model.cars):contacts.append(int(contact(c.position,c.lateral,(player+6800)%lap,0,lap)))
    assert get('contactAny')==bool(any(contacts))
    for a in iface['arrays']:
        if a['access']!=3:continue
        values={'active':[c.active for c in model.cars],'progress':[c.progress for c in model.cars],
                'position':[c.position for c in model.cars],'lateral':[c.lateral for c in model.cars],'contacts':contacts}[a['name']]
        actual=buffers[a['buffer']];wanted=b''.join(v.to_bytes(a['element_bytes'],'little',signed=a['type'].startswith('sint')) for v in values)
        assert actual==wanted,(a['name'],actual.hex(),wanted.hex())
    generation=int.from_bytes(root[20:24],'little');assert generation==1+r['physics_ticks']+r['request']
    assert r['generation']==generation+1 # StopRace succeeds after final-state capture.
    assert root[12:16]==b'\0'*4
    ticks=(directory/'ticks.bin').read_bytes();assert len(ticks)==(r['frames']+1)*4
    samples=struct.unpack('<'+'I'*(r['frames']+1),ticks);elapsed=(samples[-1]-samples[0])&0xffffff
    assert elapsed==r['elapsed_mos_ticks'] and elapsed>0
    prt=(directory/'prt.bin').read_bytes();assert len(prt)==len(ticks)
    ps=struct.unpack('<'+'I'*(r['frames']+1),prt);assert ((ps[-1]-ps[0])&0xffffff)==r['prt_ticks']
    p=list(csv.DictReader((directory/'player.csv').read_text().splitlines()))[0]
    for k,v in dict(station=player,phase=phase,speed=speed,lateral=0,steering=0,rules_ticks=r['physics_ticks']).items():assert int(p[k])==v,(k,p[k],v)
    result=dict(scope='Full-scene native fixture aggregate MOS timing including transport/checks/drawing/swap submission; no separate VDP completion timestamp',
                frames=r['frames'],physics_ticks=r['physics_ticks'],elapsed_mos_ticks=elapsed,elapsed_seconds=elapsed/120,
                observed_fps=r['frames']*120/elapsed,independent_final_world_match=True,
                state_sha256=hashlib.sha256(data).hexdigest(),player_driver='R27 centerline pace; simplified, not interactive Motion.tick headroom',
                timer_restored=True,unloaded=True,scene_counters={k:r[k] for k in ('scroll_calls','repaint_calls','audio_changes')},stack_before=r['stack_before'],stack_after=r['stack_after'],
                stages=list(csv.DictReader((directory/'stages.csv').read_text().splitlines()))[0],
                raw_files={n:hashlib.sha256((directory/n).read_bytes()).hexdigest() for n in ('state.bin','player.csv','ticks.bin','prt.bin','replies.bin','result.json','stages.csv')})
    (directory/'verified.json').write_text(json.dumps(result,indent=2)+'\n');return result
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('directory');a=p.parse_args();print(json.dumps(verify(a.directory),indent=2))
