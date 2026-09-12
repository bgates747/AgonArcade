"""Native numeric retained-page history from production state and accepted oracle.

Every page is advanced logically per admitted call. This is not scenery image
or actual buffer-swap qualification; all road/car/heading computations remain active.
"""
import argparse,copy,hashlib,json,struct,subprocess
from pathlib import Path
from profile import TASK
from native_run import execute,GOLEM,sha
from vehicle_reference import cases,admitted
from fixtures import encoded
from build_scenery_history import build
from probe_admission import update,CALL

def fixtures(track):
    selected=[c for c in cases() if c['track']==track];base=selected[0]
    proof=json.loads((TASK/'evidence/golem-scenery-history/host-proof/results.json').read_text())
    assert proof['pass'] and proof['history_checks']==4194304
    for p,digest in proof['source_hashes'].items():assert sha(Path(p))==digest,p
    row=next(r for r in proof['tracks'] if r['track']==track);assert row['bearings']==1024
    for old in [0,1,511,1023]:
        for delta in [-512,-256,-255,-1,0,1,255,256,511]:
            for step,bearing in enumerate([old,old,(old+delta)%1024,(old+delta)%1024]):
                case=copy.deepcopy(base);position=row['positions'][bearing]
                case['name']=f'{track}-history-{old}-{delta}-{step}';case['tags']=['history-boundary','both-pages']
                case['player'].update(position=position,phase=position%8000)
                case['input_sha256']=hashlib.sha256(encoded(case)).hexdigest();selected.append(case)
    return selected

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],required=True)
    p.add_argument('--limit',type=int,default=512);a=p.parse_args()
    selected=fixtures(a.track)[:a.limit];assert 0<len(selected)<=512
    work=TASK/'.work/scenery-history-native'/a.name;work.mkdir(parents=True,exist_ok=False)
    source=build(a.track,work/'source');host=work/'reference';host_source=TASK/'host_scenery_history.cpp'
    command=['g++','-std=c++17','-Wall','-Wextra','-Werror','-O1','-g','-fsanitize=address,undefined',
             '-I'+str(TASK/'.work/oracle/include'),str(host_source),'-o',str(host)]
    subprocess.run(command,check=True)
    rows=subprocess.check_output([str(host),a.track],input=''.join(str(c['player']['position'])+'\n' for c in selected).encode()).decode().splitlines()
    packet=bytearray(b'G19A'+struct.pack('<H',len(selected)));expected=[];left_raw=right_raw=0
    for i,(case,row) in enumerate(zip(selected,rows)):
        heading,old,old_valid,slot,delta,left,right,repaint,next_slot,offset0,valid0,offset1,valid1=map(int,row.split(','))
        raw=heading-old+1536;q=raw//1024;remainder=raw%1024;unwrapped=remainder-512
        full=int(not old_valid or abs(unwrapped)>255);direction=0
        if not full and delta>0:left_raw=320-delta;direction=1
        if not full and delta<0:right_raw=-delta-1
        record=admitted(case,i);wire=update(record)+CALL;assert len(wire)==97
        packet+=struct.pack('<BHH',0,len(wire),0)+wire
        out=bytearray(record+struct.pack('<6Hf',1,1,i+1,i,0,i+1,2*case['player']['position']))
        state=bytearray(58)
        unsigned={0:next_slot,2:offset0,4:valid0,6:offset1,8:valid1,10:old,12:old_valid,14:raw,16:q,
                  22:remainder,26:full,36:repaint,44:direction,46:abs(delta),48:abs(delta)}
        signed={18:remainder,20:remainder,24:delta,28:left_raw,30:right_raw,32:left,34:right,38:heading,
                40:-heading,42:1024-heading,50:old,52:raw,54:q,56:slot}
        assert len(unsigned)+len(signed)==29
        for offset,value in unsigned.items():struct.pack_into('<H',state,offset,value)
        for offset,value in signed.items():struct.pack_into('<h',state,offset,value)
        out+=state+struct.pack('<4H',1,1,1,1);assert len(out)==162;expected.append(bytes(out))
    loader=work/'loader';loader.mkdir()
    # This preserved loader already bootstraps original art and the native ABI.
    text=(TASK/'evidence/golem-scenery-heading/intervals-oval/loader.cpp').read_text()
    old='!collect(output,1730,64) || !collect(output,1731,4) ||\n            !collect(output,1732,14) || !collect(output,1733,2) || !collect(output,1734,2) || !collect(output,1735,1)'
    assert text.count(old)==1;text=text.replace(old,'!collect(output,1740,58) || !collect(output,1741,8)')
    (loader/'main.cpp').write_text(text)
    (loader/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text()+'\nCXXFLAGS += -I'+str(TASK/'.work/oracle/include')+'\n')
    root,result=execute('golem-scenery-history',a.name,source,packet,loader=loader,timeout=600)
    results=[{'case':c['name'],'pass':result[i*162:(i+1)*162]==want,'expected_hex':want.hex(),'actual_hex':result[i*162:(i+1)*162].hex()}
             for i,(c,want) in enumerate(zip(selected,expected))]
    report={'scope':__doc__,'track':a.track,'cases':len(selected),'pass':result==b''.join(expected),
            'host_command':command,'host_source_sha256':sha(host_source),'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Native numeric page history passes:',a.track,len(selected),'complete records')

if __name__=='__main__':main()
