"""Generate a deterministic pose contract, before candidate renderer development."""
from pathlib import Path
import json,struct,hashlib
TASK=Path(__file__).resolve().parent
PLAN=TASK/'fixtures.json'
SUPPLEMENT=TASK/'fixtures-bends.json'
def cases():
    return json.loads(PLAN.read_text())['cases']+json.loads(SUPPLEMENT.read_text())['cases']
def encoded(case):
    p=case['player'];words=[p['position'],p['phase'],p['lateral'],p['steering'],p['speed']]
    for car in case['cars']:words += [car['position'],car['lane']]
    assert len(words)==17
    return struct.pack('<17i',*words)
def plan():
    cases=[]
    for track,length in [('oval',5760),('fuji',32768)]:
        lap=length*100
        positions=[i*lap//16+(3210 if i%2 else 0) for i in range(16)]
        positions += [lap-1,0,6399,6400,lap-6401,lap-6400,lap//4+1234,lap*3//4+5678]
        for i,position in enumerate(positions):
            position%=lap
            lateral=[0,-35,35,-70,70,-95,95,0,0,-150,150,0][i%12]
            steering=[0,-7,7,-14,14,-21,21,0][i%8]
            phase=[0,1,3999,4000,4001,7999][i%6]
            cars=[{'id':j,'position':(position+(160+j*90)*100)%lap,'lane':[-45,0,45][j%3]} for j in range(6)]
            tags=['fractional' if position%6400 else 'sample-boundary']
            if i in (16,17):tags+=['lap-seam']
            if i>=18:tags+=['interval-seam'] if i<22 else ['overlap']
            if abs(lateral)>94:tags+=['grass-extreme']
            if i>=22:
                for j in range(3):cars[j].update(position=(position+(200+j*12)*100)%lap,lane=0)
            case={'name':f'{track}-{i:02d}','track':track,'length':length,'tags':tags,'player':{'position':position,'phase':phase,'lateral':lateral*256,'steering':steering,'speed':300},'cars':cars}
            case['input_sha256']=hashlib.sha256(encoded(case)).hexdigest();cases.append(case)
    return {'version':1,'oracle':'949f618','input_layout':'17 little-endian signed int32 words: position,phase,lateralQ8,steering,speed, then 6 position/lane pairs','perspective':False,'cases':cases}
if __name__=='__main__':
    value=json.dumps(plan(),indent=2)+'\n'
    if PLAN.exists() and PLAN.read_text()!=value:raise RuntimeError('Frozen fixtures differ; explicit contract amendment required')
    PLAN.write_text(value);print('Frozen',len(plan()['cases']),'poses:',PLAN)
