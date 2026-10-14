"""Check the demo derivative against the independent retained world model."""
from pathlib import Path
import hashlib,json,struct,sys
HERE=Path(__file__).resolve().parent
BASE=HERE.parent
sys.path.insert(0,str(BASE/'generated-state'))
sys.path.insert(0,str(BASE/'reference'))
from adapter import Interface
from host import Runtime
from model import Traffic,contact
from compose import START,GAPS,LAP

def check(directory):
    directory=Path(directory);s=Interface(directory);r=Runtime(s,directory/'host.so')
    tables=json.loads((BASE/'reference/tables.json').read_text())
    model=Traffic(tables,'circuit',LAP,1,99)
    for car,gap in zip(model.cars,GAPS):car.active=1;car.progress=START+gap;car.position=(START+gap)%model.lap;car.lateral=0
    def call(name):
        r.store(r.root_id,28,struct.pack('<H',s.entries[name]));assert r.invoke(name)==0,name
    call('InitRace');player=START;frames=[];contact_ticks=0
    for tick in range(1,3601):
        # Independent Cursor computes this tick's forward advance before model.tick.
        speed=tables['records'][(model.pace.record+1)%6 if model.pace.remaining==0 else model.pace.record][1]
        player+=speed*2;model.advance(player,tick);call('Tick120');root,arrays=r.snapshot()
        expected=dict(worldTick=tick,playerStation=player%model.lap,playerUnwrapped=player,renderPhase=player%8000,
                      routeRecord=model.pace.record,routeRemaining=model.pace.remaining,routeHeading=model.pace.heading,routeLateral=model.pace.lateral)
        for name,value in expected.items():assert s.get(root,name)==value,(tick,name,s.get(root,name),value)
        contacts=[]
        for i,car in enumerate(model.cars):
            hit=int(contact(car.position,car.lateral,player%model.lap,0,model.lap));contacts.append(hit)
            for name,value in [('active',car.active),('position',car.position),('progress',car.progress),('lateral',car.lateral),('contacts',hit)]:
                assert s.array_get(arrays,name,i)==value,(tick,name,i,s.array_get(arrays,name,i),value)
        assert s.get(root,'contactAny')==bool(any(contacts));contact_ticks+=bool(any(contacts))
        if tick%4==0:
            call('Render30');root,_=r.snapshot();assert s.get(root,'renderRequest')==tick//4
            frames.append({'frame':tick//4,'tick':tick,'player':player%model.lap,'phase':player%8000})
    root,arrays=r.snapshot();assert not r.live and r.grants==r.releases;r.canaries()
    result={'scope':'actual generated C demo physics on host, independent world model; renderer binding and target execution not covered',
            'ticks':3600,'frames':900,'contact_ticks':contact_ticks,'final_root_hex':bytes(root).hex(),
            'final_arrays':{a['name']:bytes(arrays[a['buffer']]).hex() for a in s.arrays.values()},
            'peak_views':r.peak,'source_sha256':hashlib.sha256((HERE/'demo.golem').read_bytes()).hexdigest(),
            'final_frame':frames[-1]}
    (HERE/'SOURCE-RESULTS.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('ticks','frames','contact_ticks','final_frame','peak_views')}))
if __name__=='__main__':check(sys.argv[1])
