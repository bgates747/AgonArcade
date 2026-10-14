"""Rally game replay against the preserved independent model and published vectors."""
import hashlib,json,struct,sys,time
from pathlib import Path
from delivery import HERE
from adapter import Interface
from host import Runtime
REFERENCE=HERE.parent/'reference';sys.path.insert(0,str(REFERENCE))
from model import Cursor,Traffic,sine,cyclic,contact,quotient,remainder
SINE_SCRATCH={'headingChecked','magnitude','sineQuotient','sineFraction','sineIndex','sineValue','work','quotient','remainder'}
ROUTE_SCRATCH=SINE_SCRATCH|{'routeIndex','speed'}
CONTACT_SCRATCH={'lap','work','quotient','remainder','halfLap','separation','lateralSeparation','contactResult'}
MOTION_SCRATCH=CONTACT_SCRATCH|{'slot','laneQuotient','laneRemainder','placedLateral','activeChecked','opponentStation','opponentLateral'}

def get32(p,off):return struct.unpack_from('<I',p,off)[0]
class Check:
    def __init__(self,spec,library):
        self.spec=spec;self.runtime=Runtime(spec,library);self.counts={};self.digest=hashlib.sha256();self.calls=0
        self.runtime.store(self.runtime.root_id,16,struct.pack('<I',0x76543210))
    def call(self,name,updates=None,expect=None,arrays=None,allowed=(),error=0,category='kernel'):
        r,s=self.runtime,self.spec
        for field,value in (updates or {}).items():r.put(field,value)
        r.store(r.root_id,28,struct.pack('<H',s.entries[name]));before,old_arrays=r.snapshot()
        rc=r.invoke(name);actual,actual_arrays=r.snapshot()
        assert rc==(1 if error else 0),(name,category,'sdk',rc,error)
        assert struct.unpack_from('<HH',actual,12)==(0,error),(name,category,'status',struct.unpack_from('<HH',actual,12),error)
        assert actual[16:20]==before[16:20]
        if error:assert actual[20:26]==before[20:26] and actual[32:36]==before[32:36],(name,'failed success suffix')
        else:
            assert get32(actual,20)==(get32(before,20)+1)&0xffffffff
            assert struct.unpack_from('<H',actual,24)[0]==s.entries[name] and actual[32:36]==actual[8:12]
        expect=expect or {}
        for field in s.globals:
            value=s.get(actual,field)
            if field in expect:assert value==expect[field],(name,category,field,value,expect[field])
            elif field not in allowed:assert value==s.get(before,field),(name,category,'unexpected source effect',field,value,s.get(before,field))
        assert actual_arrays==(old_arrays if arrays is None else arrays),(name,category,'retained arrays')
        self.digest.update(bytes(actual));self.digest.update(struct.pack('<i',rc))
        for a in s.arrays.values():self.digest.update(actual_arrays[a['buffer']])
        self.counts[category]=self.counts.get(category,0)+1;self.calls+=1
        return actual,actual_arrays
    def report(self):
        r=self.runtime;assert not r.live and r.grants==r.releases;r.canaries()
        return dict(calls=self.calls,categories=self.counts,complete_output_sha256=self.digest.hexdigest(),peak_views=r.peak,granted_leases=r.grants,releases=r.releases)

def route_expected(cursor,forward,advance):return dict(routeRecord=cursor.record,routeRemaining=cursor.remaining,routeHeading=cursor.heading,routeLateral=cursor.lateral,routeForward=forward,forwardAdvance=advance,headingInput=cursor.heading)
def traffic_arrays(spec,before,model,player,lateral_):
    result={id:bytearray(v) for id,v in before.items()}
    for i,c in enumerate(model.cars):
        for name,value in [('active',c.active),('progress',c.progress),('position',c.position),('lateral',c.lateral),('contacts',int(c.active and contact(c.position,c.lateral,player%model.lap,lateral_,model.lap)))]:
            spec.array_put(result,name,i,value)
    return result

def worker(library,directory,label):
    started=time.monotonic();spec=Interface(directory);tables=json.loads((REFERENCE/'tables.json').read_text());vectors=json.loads((REFERENCE/'vectors.json').read_text());numeric=json.loads((REFERENCE/'numeric-vectors.json').read_text());reports=[]
    test=Check(spec,library)
    for heading in range(-32768,32768):
        test.call('Sine',{'headingInput':heading},dict(sineValue=sine(heading,tables['sine'])),allowed=SINE_SCRATCH,category='exhaustive-sine')
    for heading in (-2147483648,-32769,32768,2147483647):test.call('Sine',{'headingInput':heading},allowed=(),error=32,category='sine-domain-rejection')
    test.call('ResetRace',expect=dict(routeRecord=0,routeRemaining=60,routeHeading=0,routeLateral=0,routeForward=0,worldTick=0),category='route-reset')
    cursor=Cursor();forward=0
    for tick in range(1,1801):
        advance=cursor.advance(tables['records'],tables['sine']);forward+=advance
        test.call('RouteTick',expect=route_expected(cursor,forward,advance),allowed=ROUTE_SCRATCH,category='route-cycle')
    assert cursor.record==5 and cursor.heading==cursor.lateral==cursor.remaining==0
    for v in vectors['contact_cases']:
        separation=cyclic(v['position'],v['player'],v['lap'])
        test.call('Contact',{'opponentStation':v['position'],'opponentLateral':v['lateral_q8'],'playerStation':v['player'],'playerLateral':v['player_lateral_q8'],'lapInput':v['lap']},
                  dict(contactResult=v['contact'],separation=separation,lateralSeparation=abs(v['lateral_q8']-v['player_lateral_q8'])),allowed=CONTACT_SCRATCH,category='contact-boundary')
    for lap in (3276800,576000):
        for n in (-2147483648,-lap*2-1,-lap,-1,0,1,lap-1,lap,lap*2+1,2147483647):
            test.call('Normalize',{'normalizeInput':n,'lapInput':lap},dict(lap=lap,normalPosition=n%lap,quotient=quotient(n,lap),remainder=n%lap),category='signed-lap-normalization')
    test.call('Normalize',{'lapInput':0},error=32,category='invalid-lap')
    # Exact published primitive surface, including paired-output failures and prefix effects.
    for v in numeric['checked_arithmetic']:
        if v['operation']!='mul':continue
        signed=v['type']=='sint32';dest='sq' if signed else 'uq';error=3 if 'error' in v else 0
        test.call('MultiplySigned' if signed else 'MultiplyUnsigned',{('sa' if signed else 'ua'):v['left'],('sb' if signed else 'ub'):v['right']},
                  {} if error else {dest:v['result']},error=error,category='published-multiplication')
    for v in numeric['division']:
        signed=v['type']=='sint32';effect=spec.get(test.runtime.data(test.runtime.root_id),'effect')+1
        error=4 if v.get('error')=='division_by_zero' else 6 if v.get('error')=='division_overflow' else 0
        expect={'effect':effect}
        if not error:expect.update({('sq' if signed else 'uq'):v['quotient'],('sr' if signed else 'ur'):v['remainder']})
        test.call('DivideSigned' if signed else 'DivideUnsigned',{('sa' if signed else 'ua'):v['numerator'],('sb' if signed else 'ub'):v['denominator']},expect,error=error,category='published-divmod')
        if not error:assert v['numerator']==v['quotient']*v['denominator']+v['remainder'] and abs(v['remainder'])<abs(v['denominator'])
    for v in numeric['route_products']:
        effect=spec.get(test.runtime.data(test.runtime.root_id),'effect')+1
        # Published integer fields are checked below by their immutable names.
        numerator=v['product'];q=quotient(numerator,12800);r=remainder(numerator,12800)
        test.call('DivideSigned',{'sa':numerator,'sb':12800},dict(effect=effect,sq=q,sr=r),category='published-route-division')
    for v in numeric['signed_shift_examples']:
        test.call('ShiftSigned',{'sa':v['value'],'shiftCount':v['shift']},dict(signedShift=v['arithmetic_shift']),category='published-floor-shift')
    for value in (-2147483648,-65,-1,0,1,65,2147483647):
        for bits in range(32):test.call('ShiftSigned',{'sa':value,'shiftCount':bits},dict(signedShift=value//(1<<bits)),category='shift-extrema-counts')
    for value in (0,1,2147483648,4294967295):
        for bits in range(32):test.call('ShiftUnsigned',{'ua':value,'shiftCount':bits},dict(unsignedShift=value>>bits),category='shift-extrema-counts')
    for bits in (32,33,65535):
        test.call('ShiftSigned',{'shiftCount':bits},error=32,category='shift-invalid-count')
        test.call('ShiftUnsigned',error=32,category='shift-invalid-count')
    for n,d in [(7,3),(-7,3),(100,3),(7,10),(-7,10),(10,0),(-2147483648,-1)]:
        effect=spec.get(test.runtime.data(test.runtime.root_id),'effect')+1;error=4 if not d else 6 if (n,d)==(-2147483648,-1) else 0
        q=r=0
        if not error:
            q,r=quotient(n,d),remainder(n,d)
            if not -10<=q<=10 or not -3<=r<=3:error=32
        expect={'effect':effect}
        if not error:expect.update(boundedQ=q,boundedR=r)
        test.call('BoundedPair',{'sa':n,'sb':d},expect,error=error,category='paired-bounds-failure')
    for n,d in [(-7,3),(7,-3),(-7,-3),(2147483647,12800)]:
        test.call('AliasPair',{'sa':n,'sb':d},dict(sa=quotient(n,d),sb=remainder(n,d)),category='paired-input-output-alias')
    for n,d,code in [(10,0,4),(-2147483648,-1,6)]:
        test.call('AliasPair',{'sa':n,'sb':d},error=code,category='paired-alias-failure')
    test.call('RouteTick',{'routeRecord':6,'routeRemaining':60},dict(routeIndex=24),error=5,category='route-index-before-heading')
    reports.append(test.report())
    # Each scenario begins from a complete frozen-model snapshot; no sparse reconstruction.
    for track in ('Fuji','TriOval'):
        lap=tables['tracks'][track]['lap_hundredths']
        for grid in (1,4,7):
            check=Check(spec,library);model=Traffic(tables,'circuit',lap,grid,99)
            for i,c in enumerate(model.cars):
                if grid==4 and i%2:c.active=0;c.lateral=321+i
                if grid==7 and i!=5:c.active=0;c.lateral=-321-i
            _,old=check.runtime.snapshot();initial=traffic_arrays(spec,old,model,0,0)
            for id,data in initial.items():check.runtime.store(id,0,bytes(data))
            forward_total=0
            for tick in range(1,1801):
                player=tick*400;lat=(-38400,0,38400)[(tick//60)%3];model.advance(player,tick)
                advance=tables['records'][model.pace.record][1]*2
                forward_total+=advance;expect=route_expected(model.pace,forward_total,advance)
                expect.update(worldTick=tick,contactAny=int(any(c.active and contact(c.position,c.lateral,player%lap,lat,lap) for c in model.cars)))
                _,old=check.runtime.snapshot();wanted=traffic_arrays(spec,old,model,player,lat)
                check.call('Tick120',{'lapInput':lap,'playerStation':player%lap,'playerLateral':lat},expect,wanted,ROUTE_SCRATCH|MOTION_SCRATCH,category='six-slot-'+track+'-grid'+str(grid))
            assert model.pace.heading==model.pace.lateral==model.pace.remaining==0
            before=check.runtime.snapshot()
            for kind in ('native','buffered'):
                assert check.runtime.invoke(operation=3)==0;check.runtime.cleanup(kind);assert check.runtime.invoke(operation=1)==0;assert check.runtime.snapshot()==before
            reports.append(check.report())
    # Tick failure after a valid route advance preserves earlier effects; no rollback.
    for invalid in ('active','lap','progress','tick'):
        check=Check(spec,library);model=Traffic(tables,'circuit',3276800,1,99)
        _,old=check.runtime.snapshot();initial=traffic_arrays(spec,old,model,0,0)
        if invalid=='active':spec.array_put(initial,'active',0,2)
        if invalid=='progress':spec.array_put(initial,'progress',3,2147483647)
        for id,data in initial.items():check.runtime.store(id,0,bytes(data))
        if invalid=='lap':check.runtime.put('lapInput',0)
        if invalid=='tick':check.runtime.put('worldTick',0xffffffff)
        cursor=Cursor();advance=cursor.advance(tables['records'],tables['sine']);expect=route_expected(cursor,advance,advance)
        expect['contactAny']=0;wanted={id:bytearray(v) for id,v in initial.items()}
        if invalid in ('progress','tick'):
            model.advance(0,1);complete=traffic_arrays(spec,initial,model,0,0)
            for i in range(6 if invalid=='tick' else 3):
                for field in ('progress','position','lateral','contacts'):spec.array_put(wanted,field,i,spec.array_get(complete,field,i))
            if invalid=='tick':expect['contactAny']=int(any(spec.array_get(wanted,'contacts',i) for i in range(6)))
        check.call('Tick120',expect=expect,arrays=wanted,allowed=ROUTE_SCRATCH|MOTION_SCRATCH,error=32 if invalid in ('active','lap') else 1,category='partial-tick-'+invalid)
        reports.append(check.report())
    return dict(label=label,asan_ubsan=label=='sanitized',groups=reports,total_calls=sum(r['calls'] for r in reports),peak_mock_views=max(r['peak_views'] for r in reports),host_seconds=round(time.monotonic()-started,3))
