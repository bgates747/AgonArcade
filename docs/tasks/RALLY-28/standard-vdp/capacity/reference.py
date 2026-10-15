"""Independent Python physics/rules reference plus preserved independent routes.

No imports from game C++ or the benchmark. Tables are immutable input data.
Signed division is explicit; Python's unlimited integers expose intermediate
range assumptions instead of silently relying on a host C ABI.
"""
from pathlib import Path
import copy,csv,json,re,sys
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
sys.path.insert(0,str(ROOT/'docs/tasks/RALLY-25/reference'))
from model import Traffic,quotient as q,cyclic
DATA=json.loads((ROOT/'docs/tasks/RALLY-25/reference/tables.json').read_text())
TRACK=[tuple(map(int,m)) for m in re.findall(r'\{(-?\d+),(-?\d+),(-?\d+),(-?\d+)\}',(ROOT/'rally-production/include/track.hpp').read_text().split('static const TrackDef Fuji')[0])]
assert len(TRACK)==512
LAP=3276800

def tangent(distance):
    index=(distance>>14)%512;f=distance&16383;a,b=TRACK[index],TRACK[(index+1)%512]
    return a[2]+((b[2]-a[2])*f>>14),a[3]+((b[3]-a[3])*f>>14)

def simulate(which):
    phase=0;position=(which*700000+500000)%LAP;speed=[300,160,150,220][which]
    if which==0:position=100000
    lateral=[0,96*256,140*256,-14260][which];velocity=steering=remaining=invulnerable=0
    policy='arcade' if which==1 else 'circuit'
    traffic=Traffic(DATA,policy,LAP,7,2)
    cursors=[copy.copy(traffic.pace) if c.active else None for c in traffic.cars]
    if which==0:
        c=traffic.cars[0];c.position=position+6800+5000;c.progress=5000
    if which==3:
        c=traffic.cars[0];c.position=(position+6800)%LAP;c.lateral=lateral;c.progress=0
    progress=score=remainder=elapsed=0;rank=7
    coverage={'motion':0,'recovery':0,'contacts':0,'road':0,'kerb':0,'grass':0,'passes':0}
    def contact(station,lat):return any(c.active and abs(cyclic(c.position,station,LAP))<3200 and abs(c.lateral-lat)<6144 for c in traffic.cars)
    for i in range(1024):
        t=(i&~3)&255
        if i%4==0 and not remaining and which!=0:
            steering=max(-21,min(21,steering+(-2 if t<64 else 2 if t<128 else 0)))
        station=(position+6800)%LAP;before=[cyclic(c.position,station,LAP) for c in traffic.cars]
        generations=[c.generation if c.active else 0 for c in traffic.cars]
        recovering=bool(remaining);advance=0
        if recovering:
            coverage['recovery']+=1;speed=velocity=0
            if remaining>1:remaining-=1
            else:
                for lane in [0,-36,36,-65,65]:
                    if not contact(progress%LAP,lane*256):
                        lateral=lane*256;steering=remaining=0;invulnerable=120;break
        else:
            if invulnerable:invulnerable-=1
            coverage['motion']+=1
            surface=2 if abs(lateral)+3072>106*256 else 1 if abs(lateral)+3072>90*256 else 0
            coverage[['road','kerb','grass'][surface]]+=1
            speed+=2 if t<208 else -4
            floor,drag=(90,4) if surface==2 else (160,3)
            if surface and speed>floor:speed=max(floor,speed-drag)
            speed=max(0,min(300,speed))
            p=q(position,100)*256+q((position%100)*256,100)
            ax,ay=tangent(p);bx,by=tangent(p+64*256)
            bend=q(ax*by-ay*bx,4096);centripetal=q(speed*speed*bend,1024)
            wanted=q(steering*speed*512,63);required=q((wanted-velocity)*100,12)
            limit=200*180*256//100
            if surface==2:limit=q(limit,2)
            elif surface==1:limit=q(limit*115,100)
            velocity+=q(max(-limit,min(limit,required))-centripetal,100)
            if not speed:velocity=0
            lateral+=q(velocity,100)
            if abs(lateral)>150*256:lateral=(1 if lateral>0 else -1)*150*256;velocity=0
            advance=speed*2;position=(position+advance)%LAP;phase=(phase+advance)%8000
        if which!=2:
            player=progress+advance;station=(station+advance)%LAP
            traffic.advance(player,elapsed+1)
            for k,c in enumerate(traffic.cars):
                if c.active:cursors[k]=copy.copy(traffic.pace)
            if not recovering and not invulnerable and contact(station,lateral):
                remaining=150;speed=velocity=0;coverage['contacts']+=1
            if not recovering and not remaining:
                for k,c in enumerate(traffic.cars):
                    after=cyclic(c.position,station,LAP)
                    if c.active and generations[k]==c.generation and before[k]>0 and before[k]<=advance and after<=0:
                        score+=100;coverage['passes']+=1
            if policy=='circuit':rank=1+sum(c.active and c.progress>player for c in traffic.cars)
        elapsed+=1;progress+=advance;remainder+=advance;score+=remainder//1600;remainder%=1600
        assert progress<LAP, 'Fixture must remain in its measured driving phase'
    values=[phase,position,speed,lateral,velocity,steering,200,remaining,invulnerable,
            3 if which==2 else 6,1024,elapsed,85*120-elapsed,progress,score,remainder,rank,0,0,0,0,0,
            traffic.next_spawn,traffic.pace.record,traffic.pace.remaining,traffic.pace.heading,traffic.pace.lateral]
    for k,c in enumerate(traffic.cars):
        cursor=cursors[k]
        # Inactive slots retain their cursor (default for never-spawned slots).
        values.extend([c.active,c.generation,c.order,c.progress,c.position,c.lateral,c.finish,
            cursor.record if cursor else 0,cursor.remaining if cursor else 60,cursor.heading if cursor else 0,cursor.lateral if cursor else 0,
            c.position if c.active else position,q(c.lateral,256)])
    assert len(values)==105
    return [v&0xffffffff for v in values],coverage

def verify(path):
    actual={(int(s),int(k)):int(v) for s,k,v in csv.reader(Path(path).open())};counts={}
    assert len(actual)==420
    for s in range(4):
        values,counts[s]=simulate(s)
        for k,v in enumerate(values):assert actual[s,k]==v,(s,k,actual[s,k],v)
    return counts
if __name__=='__main__':print(json.dumps(verify(sys.argv[1]),indent=2))
