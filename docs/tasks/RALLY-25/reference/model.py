"""Independent integer reference. No imports from the game/generator/oracle."""
from dataclasses import dataclass,field

def quotient(n,d):
    if d==0:raise ZeroDivisionError
    q=abs(n)//abs(d)
    return -q if (n<0)!=(d<0) else q

def remainder(n,d):return n-quotient(n,d)*d

def cyclic(a,b,lap):
    distance=(a-b)%lap
    return distance-lap if distance>lap//2 else distance

def contact(position,lateral,player,player_lateral,lap):
    return abs(cyclic(position,player,lap))<3200 and abs(lateral-player_lateral)<6144

def sine(heading,table):
    magnitude=abs(heading)
    if magnitude>16384:magnitude=32768-magnitude
    i,f=divmod(magnitude,64)
    result=table[i]
    if i<256:result+=quotient((table[i+1]-result)*f,64)
    return -result if heading<0 else result

@dataclass
class Cursor:
    record:int=0
    remaining:int=60
    heading:int=0
    lateral:int=0
    def advance(self,records,table):
        if self.remaining==0:
            self.record=(self.record+1)%len(records)
            self.remaining,_,self.heading,_=records[self.record]
        _,speed,_,rate=records[self.record]
        self.heading+=rate
        self.lateral+=quotient(2*speed*sine(self.heading,table),12800)
        self.remaining-=1
        return speed*2

@dataclass
class Car:
    active:int=0
    generation:int=0
    order:int=0
    progress:int=0
    position:int=0
    lateral:int=0
    finish:int=0

class Traffic:
    def __init__(self,data,policy,lap,grid,laps):
        self.data,self.policy,self.lap,self.grid=data,policy,lap,grid
        self.finish_distance,self.next_spawn=lap*laps,0
        self.pace=Cursor(remaining=data['records'][0][0]);self.cars=[Car() for _ in range(6)]
        if policy=='circuit':
            for i,c in enumerate(self.cars):
                c.active=c.generation=1
                c.order=i+1+(i+1>=grid)
                offset=grid-1-i
                if offset<=0:offset-=1
                c.progress=offset*10000;c.position=c.progress%lap
                self.place(i)
    def place(self,i):
        self.cars[i].lateral=(i%3-1)*9216+(1 if i%2==0 else -1)*(self.pace.lateral-self.data['half_excursion_q8'])
    def spawn(self,progress):
        if self.policy!='arcade':return False
        free=None
        for i,c in enumerate(self.cars):
            if not c.active:
                if free is None:free=i
            elif abs(cyclic(c.progress,progress,self.lap))<9600:return False
        if free is None:return False
        c=self.cars[free];c.active=1;c.generation=(c.generation+1)&65535
        c.progress=progress;c.position=progress%self.lap;c.finish=0;self.place(free)
        return True
    def advance(self,player,tick):
        advance=self.pace.advance(self.data['records'],self.data['sine'])
        for i,c in enumerate(self.cars):
            if c.active:
                c.progress+=advance;c.position=(c.position+advance)%self.lap
                self.place(i)
                if self.policy=='circuit' and not c.finish and c.progress>=self.finish_distance:c.finish=tick
                if self.policy=='arcade' and c.progress<player-12000:c.active=0
        if self.policy=='arcade' and player>=self.next_spawn:
            self.spawn(player+60000);self.next_spawn+=90000
    def row(self,tick,player,lateral):
        p=self.pace
        contact_any=any(c.active and contact(c.position,c.lateral,player%self.lap,lateral,self.lap) for c in self.cars)
        rank=1+sum(c.active and c.progress>player for c in self.cars)
        values=[tick,p.record,p.remaining,p.heading,p.lateral,self.next_spawn,rank,int(contact_any)]
        for c in self.cars:values.extend([c.active,c.generation,c.order,c.progress,c.position,c.lateral,c.finish])
        return values
