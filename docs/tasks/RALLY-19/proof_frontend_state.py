"""Check raw frontend state mapping against frozen packets and bad producer state."""
import argparse,json,struct,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha
from vehicle_reference import cases,admitted
from fixtures import encoded
from probe_admission import update,CALL

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    root=TASK/'evidence/golem-frontend-state'/a.name;root.mkdir(parents=True,exist_ok=False)
    work=TASK/'.work/frontend-state'/a.name;work.mkdir(parents=True,exist_ok=False)
    records=[];expected=[];names=[]
    for i,case in enumerate(cases()):
        for flags in range(4):
            seq=[0,1,255,65534][flags];grip=[25,60,130,200][flags]
            records.append(struct.pack('<4H',int(case['track']=='fuji'),seq,flags,grip)+encoded(case))
            state=bytearray(admitted(case,seq));struct.pack_into('<HH',state,72,flags,grip)
            expected.append(b'\1'+update(state)+CALL);names.append(case['name']+'-flags-'+str(flags))
    base=bytearray(records[0])
    changes=[('unknown-track',0,'H',2),('bad-sequence',2,'H',65535),('bad-grip-low',6,'H',24),('bad-grip-high',6,'H',201),
             ('negative-position',8,'i',-1),('position-beyond-lap',8,'i',576000),('negative-phase',12,'i',-1),
             ('phase-would-wrap',12,'i',65536),('bad-lateral',16,'i',38401),('bad-steering',20,'i',22),
             ('negative-speed',24,'i',-1),('speed-would-wrap',24,'i',65536),('bad-car-position',28,'i',-1),('bad-car-lane',32,'i',91)]
    for name,offset,fmt,value in changes:
        record=bytearray(base);struct.pack_into('<'+fmt,record,offset,value);records.append(record)
        expected.append(bytes(98));names.append(name)
    source=TASK/'host_frontend_state.cpp';exe=work/'test'
    command=['g++','-std=c++17','-Wall','-Wextra','-Werror','-g','-O1','-fsanitize=address,undefined',
             '-I'+str(TASK/'.work/oracle/include'),'-I'+str(TASK),str(source),'-o',str(exe)]
    with (root/'build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    input_path=work/'cases.dat';output_path=work/'results.dat';input_path.write_bytes(struct.pack('<H',len(records))+b''.join(records))
    subprocess.run([str(exe),str(input_path),str(output_path)],check=True);raw=output_path.read_bytes()
    results=[{'case':name,'pass':raw[i*98:(i+1)*98]==want} for i,(name,want) in enumerate(zip(names,expected))]
    report={'scope':__doc__,'cases':len(records),'pass':raw==b''.join(expected),'build_command':command,'results':results,
            'source_hashes':{str(p):sha(p) for p in [Path(__file__),source,TASK/'frontend_state.hpp',TASK/'scene_protocol.hpp',*sorted((TASK/'.work/oracle/include').glob('*.hpp'))]}}
    (root/'input.dat').write_bytes(input_path.read_bytes());(root/'output.dat').write_bytes(raw)
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Frontend state mapping passes:',len(records),'full records')

if __name__=='__main__':main()
