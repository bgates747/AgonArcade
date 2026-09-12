"""Prepare vehicle inputs and accepted numeric references for R19-08.

Uses the existing oracle host_fixture.cpp, not a second projection algorithm.
The original66 scenes must exactly match their frozen native guest CSV. Added
clipping/tie/steering cases are host references only until exercised natively.
"""
import copy,csv,hashlib,json,struct,subprocess
from pathlib import Path
from profile import TASK
from fixtures import cases as frozen_cases,encoded
from probe_admission import state,put

def cases():
    fixed=frozen_cases();extra=[]
    for track,lap in [('oval',576000),('fuji',3276800)]:
        base=copy.deepcopy(next(c for c in fixed if c['track']==track))
        base['player'].update(position=lap-1,phase=7999)
        for name,distances in [('depth-edges',[6399,6400,6499,110099,110100,lap-1]),
                               ('nonstable-ties',[20000,20000,40000,30000,20000,50000])]:
            case=copy.deepcopy(base);case['name']=track+'-'+name;case['tags']=[name,'supplemental-host-reference']
            for car,distance in zip(case['cars'],distances):
                car.update(position=(base['player']['position']+distance)%lap,lane=0)
            case['input_sha256']=hashlib.sha256(encoded(case)).hexdigest();extra.append(case)
        for steering in range(-21,22):
            case=copy.deepcopy(base);case['name']=track+'-steering-'+str(steering)
            case['tags']=['every-steering-tick','supplemental-host-reference']
            case['player'].update(steering=steering,lateral=[-38400,-1,0,1,38400][(steering+21)%5])
            case['input_sha256']=hashlib.sha256(encoded(case)).hexdigest();extra.append(case)
    return fixed+extra

def admitted(case,sequence):
    """Encode raw fixture state only; no projection or yaw/depth preparation."""
    assert 0<=sequence<=65534
    p=case['player'];out=state(sequence,int(case['track']=='fuji'),p['position'])
    outer=abs(p['lateral'])+12*256
    surface=2 if outer>106*256 else 1 if outer>90*256 else 0
    for offset,width,value in [(12,2,p['phase']),(14,2,p['steering']),
                               (16,4,p['lateral']),(20,2,p['speed']),
                               (22,2,surface),(72,2,0),(74,2,60)]:put(out,offset,width,value)
    assert [car['id'] for car in case['cars']]==list(range(6))
    for i,car in enumerate(case['cars']):
        put(out,24+8*i,4,car['position']);put(out,28+8*i,2,car['lane'])
    # Round-trip the fixture's17 input words, including signed fields.
    words=[struct.unpack_from('<i',out,8)[0],struct.unpack_from('<H',out,12)[0],
           struct.unpack_from('<i',out,16)[0],struct.unpack_from('<h',out,14)[0],
           struct.unpack_from('<H',out,20)[0]]
    for i in range(6):words.extend([struct.unpack_from('<i',out,24+8*i)[0],struct.unpack_from('<h',out,28+8*i)[0]])
    assert struct.pack('<17i',*words)==encoded(case)
    return bytes(out)

def main():
    destination=TASK/'evidence/golem-cars/reference.json';assert not destination.exists()
    work=TASK/'.work/vehicle-reference';work.mkdir(parents=True,exist_ok=False)
    executable=work/'host_fixture'
    command=['g++','-std=c++17','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-g',
             '-I'+str(TASK/'.work/oracle/include'),'-I'+str(TASK),str(TASK/'host_fixture.cpp'),'-o',str(executable)]
    subprocess.run(command,check=True)
    fixed={c['name'] for c in frozen_cases()};results=[]
    for i,case in enumerate(cases()):
        raw=encoded(case);assert hashlib.sha256(raw).hexdigest()==case['input_sha256']
        path=work/'pose.dat';path.write_bytes(raw)
        output=subprocess.check_output([str(executable),case['track'],str(TASK.parent/'RALLY-18/data'/(case['track']+'.road')),str(path)])
        native=case['name'] in fixed
        if native:assert output==(TASK/'evidence/oracle'/case['name']/'guest-scene.csv').read_bytes()
        rows=list(csv.reader(output.decode().splitlines()));header=list(map(int,rows[0]))
        cars=[list(map(int,row[1:])) for row in rows if row[0]=='C']
        assert len(cars)==header[8]
        results.append({'name':case['name'],'track':case['track'],'tags':case['tags'],
                        'native_oracle_verified':native,'input_sha256':case['input_sha256'],
                        'admitted_state_hex':admitted(case,i).hex(),
                        'scene_sha256':hashlib.sha256(output).hexdigest(),
                        'player':{'bitmap':header[5],'mirror':header[6],'x':header[7],'y':154},
                        'traffic_ordered':[{'id':r[0]//5-1,'bitmap':r[0],'scale':r[1],
                                            'mirror':r[2],'x':r[3],'y':r[4],'translation':r[5]} for r in cars]})
    assert len(results)==156 and sum(r['native_oracle_verified'] for r in results)==66
    files=[Path(__file__),TASK/'host_fixture.cpp',TASK/'fixture_state.hpp',TASK/'fixtures.json',TASK/'fixtures-bends.json']
    files+=sorted((TASK/'.work/oracle/include').glob('*.hpp'))
    report={'scope':__doc__,'cases':len(results),'native_oracle_exact':66,'supplemental_host_only':90,
            'candidate_tested':False,'build_command':command,
            'source_sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files},'results':results}
    destination.parent.mkdir(parents=True,exist_ok=True)
    destination.write_text(json.dumps(report,indent=2)+'\n')
    print('Vehicle references:',len(results),'cases;',66,'exact existing native oracle scenes;',90,'new host-only cases')

if __name__=='__main__':main()
