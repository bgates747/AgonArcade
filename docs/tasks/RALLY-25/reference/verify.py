"""Generate peer-ready conformance vectors and independently verify frozen C++."""
from pathlib import Path
import hashlib,json,subprocess,sys,time
from freeze import HERE,WORK,prepare,sha
from model import Cursor,Traffic,contact,sine

def main():
    started=time.monotonic();source,data=prepare();exe=WORK/'oracle'
    subprocess.run(['c++','-std=c++17','-O1','-g','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-fno-omit-frame-pointer',str(HERE/'oracle.cpp'),'-I'+str(source/'rally-game/include'),'-I'+str(source/'rally-production/include'),'-o',str(exe)],check=True)
    def run(*args,input=None):return subprocess.check_output([str(exe),*map(str,args)],input=input,text=True)
    route=[];cursor=Cursor();forward=0
    for tick in range(1,1801):
        forward+=cursor.advance(data['records'],data['sine'])
        route.append([tick,cursor.record,cursor.remaining,cursor.heading,cursor.lateral,forward])
    actual=[[int(x) for x in row.split(',')] for row in run('route').splitlines()]
    assert actual==route,'Route model differs from frozen C++'
    assert cursor.lateral==cursor.heading==cursor.remaining==0
    assert list(map(int,run('sine').splitlines()))==[sine(h,data['sine']) for h in range(-32768,32768)]
    cases=[]
    for name,track in data['tracks'].items():
        lap=track['lap_hundredths']
        for player in [0,1,lap//2,lap-1]:
            for longitudinal in [-3201,-3200,-3199,0,3199,3200,3201,-lap//2,lap//2]:
                for lateral in [-6145,-6144,-6143,0,6143,6144,6145]:
                    position=(player+longitudinal)%lap
                    cases.append({'track':name,'lap':lap,'position':position,'lateral_q8':lateral,'player':player,'player_lateral_q8':0,'contact':int(contact(position,lateral,player,0,lap))})
    stdin=''.join(f"{c['lap']} {c['position']} {c['lateral_q8']} {c['player']} {c['player_lateral_q8']}\n" for c in cases)
    assert list(map(int,run('contact',input=stdin).splitlines()))==[c['contact'] for c in cases]
    spawn_cases=[]
    for name,track in data['tracks'].items():
        lap=track['lap_hundredths']
        for positions in [[0,9599,9600,lap-9599,lap-9600],[0,10000,20000,30000,40000,50000,60000],[-100,lap-100,9500]]:
            model=Traffic(data,'arcade',lap,1,6);expected=[int(model.spawn(p)) for p in positions]
            got=list(map(int,run('spawn',input=f'{lap} {len(positions)}\n'+ ' '.join(map(str,positions))+'\n').strip().strip(',').split(',')))
            assert expected==got
            spawn_cases.append({'track':name,'positions':positions,'accepted':expected})
    scenarios=[];total=0;events={'spawn':0,'despawn':0,'finish':0,'slot_reuse':0}
    checkpoints={1,2,59,60,61,119,120,121,299,300,301,359,360,361,419,420,421,599,600,601}
    for name,track in data['tracks'].items():
        lap=track['lap_hundredths'];laps=2 if name=='Fuji' else 6
        configs=[('circuit',g,24000,400) for g in [1,4,7]]+[('arcade',1,12000,v) for v in [300,500]]
        for policy,grid,count,speed in configs:
            model=Traffic(data,policy,lap,grid,laps);expected=[];saved=[]
            for tick in range(1,count+1):
                previous=[(c.active,c.generation,c.finish) for c in model.cars]
                player=tick*speed;model.advance(player,tick);row=model.row(tick,player,0)
                expected.append(','.join(map(str,row)))
                changed=False
                for old,c in zip(previous,model.cars):
                    if not old[0] and c.active:events['spawn']+=1;changed=True
                    if old[0] and not c.active:events['despawn']+=1;changed=True
                    if not old[2] and c.finish:events['finish']+=1;changed=True
                    if c.generation>old[1] and old[1]:events['slot_reuse']+=1
                if tick in checkpoints or tick%600==0 or changed:saved.append(row)
            expected='\n'.join(expected)+'\n';actual=run('traffic',policy,lap,grid,laps,count,speed)
            assert actual==expected,(name,policy,grid,speed)
            total+=count
            scenarios.append({'track':name,'policy':policy,'grid':grid,'laps':laps,'ticks':count,'player_advance_per_tick':speed,'full_replay_sha256':sha(expected.encode()),'checkpoints':saved})
    assert all(events.values()),events
    vectors={'schema':1,'scope':'historical route/contact conformance; no new recovery, removal, sparse-telemetry or scheduler policy','source_commit':data['source_commit'],'route_columns':['tick','record','remaining','heading_turn16','lateral_q8','forward_hundredths'],'route':route[:600],'contact_cases':cases,'spawn_cases':spawn_cases,'scenario_columns':['tick','record','remaining','heading','pace_lateral_q8','next_spawn','rank','contact']+['car_'+str(i)+'_'+f for i in range(6) for f in ['active','generation','grid_order','progress','position','lateral_q8','finish_tick']],'scenarios':scenarios}
    (HERE/'vectors.json').write_text(json.dumps(vectors,indent=2)+'\n')
    from numeric import main as numeric_main
    numeric_main()
    numeric=json.loads((HERE/'numeric-vectors.json').read_text())
    for name in data['tracks']:
        cases_lookup=[v for v in numeric['lookup'] if v['track']==name]
        stdin=''.join(f"{v['position']} {v['q']}\n" for v in cases_lookup)
        asset=source/'rally-production'/('fuji.road' if name=='Fuji' else 'oval.road')
        assert list(map(int,run('lookup',asset,name,input=stdin).splitlines()))==[v['center_q8'] for v in cases_lookup]
    result={'schema':1,'source_commit':data['source_commit'],'route_ticks':len(route),'sine_inputs':65536,'contact_cases':len(cases),'spawn_cases':len(spawn_cases),'scenario_count':len(scenarios),'scenario_ticks':total,'lookup_cases':len(numeric['lookup']),'events':events,'sanitizers':'ASan + UBSan','elapsed_host_seconds':round(time.monotonic()-started,3),'vectors_sha256':sha((HERE/'vectors.json').read_bytes()),'numeric_vectors_sha256':sha((HERE/'numeric-vectors.json').read_bytes()),'files':{p.name:sha(p.read_bytes()) for p in [HERE/'model.py',HERE/'oracle.cpp',HERE/'verify.py',HERE/'numeric.py',HERE/'tables.json']}}
    (HERE/'verification.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
if __name__=='__main__':main()
