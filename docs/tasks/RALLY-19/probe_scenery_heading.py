"""Native fractional scenery bearing with complete road and car jobs active.

Only raw production state enters each frame. Compare entire diagnostic records
against accepted trackSample/sceneryHeading and the proven binary32 ratio.
"""
import argparse,copy,hashlib,json,math,re,struct,subprocess
from profile import TASK
from native_run import execute,GOLEM
from vehicle_reference import cases,admitted
from fixtures import encoded
from build_scenery_heading import build
from probe_admission import update,CALL

def fixtures(track):
    selected=[c for c in cases() if c['track']==track]
    base=selected[0];lap=base['length']*100
    proof=json.loads((TASK/'evidence/golem-scenery-proof/fraction-and-direct/results.json').read_text())
    row=next(r for r in proof['tracks'] if r['track']==track)
    positions=[i*6400+3245 for i in range(lap//6400)]
    positions += [(w['position']+d)%lap for w in row['witnesses'] for d in [-1,0,1]]
    for i,pos in enumerate(positions):
        c=copy.deepcopy(base);c['name']=f'{track}-scenery-{i}';c['tags']=['scenery-heading']
        c['player'].update(position=pos,phase=pos%8000)
        c['input_sha256']=hashlib.sha256(encoded(c)).hexdigest();selected.append(c)
    return selected

def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],required=True)
    p.add_argument('--offset',type=int,default=0);p.add_argument('--limit',type=int,default=384);a=p.parse_args()
    selected=fixtures(a.track)[a.offset:a.offset+a.limit];assert 0<len(selected)<=384
    work=TASK/'.work/scenery-heading-native'/a.name;work.mkdir(parents=True,exist_ok=False)
    source=build(a.track,work/'source')
    host=work/'reference';host_source=TASK/'host_scenery_heading.cpp'
    command=['g++','-std=c++17','-Wall','-Wextra','-Werror','-O1','-g','-fsanitize=address,undefined',
             '-I'+str(TASK/'.work/oracle/include'),str(host_source),'-o',str(host)]
    subprocess.run(command,check=True)
    data=''.join(str(c['player']['position'])+'\n' for c in selected)
    rows=subprocess.check_output([str(host),a.track],input=data.encode()).decode().splitlines()
    atan=list((work/'source/scenery-atan.dat').read_bytes())
    packet=bytearray(b'G19A'+struct.pack('<H',len(selected)));expected=[]
    for i,(case,row) in enumerate(zip(selected,rows)):
        tx,ty,heading,base,delta=map(int,row.split(','));ax,ay=abs(tx),abs(ty);minor,major=min(ax,ay),max(ax,ay)
        numerator=minor*256;estimate=math.floor(f32(f32(numerator)*f32(1/major)))
        q=numerator//major;assert q-estimate in [0,1]
        small=atan[q];base_angle=256-small if ax<ay else small
        angle_x=512-base_angle if tx<0 else base_angle;final=1024-angle_x if ty<0 else angle_x
        assert final%1024==heading
        record=admitted(case,i);wire=update(record)+CALL;assert len(wire)==97
        packet+=struct.pack('<BHH',0,len(wire),0)+wire
        out=bytearray(record+struct.pack('<6Hf',1,1,i+1,i,0,i+1,2*case['player']['position']))
        diag=bytearray(64)
        struct.pack_into('<3h17HII5H',diag,0,base,delta,ty,ax,ay,minor,major,int(ax<ay),estimate,estimate,q,q,
                         minor,major,small,base_angle,angle_x,final,heading,heading,numerator,(estimate+1)*major,
                         estimate+1,int(numerator<(estimate+1)*major),int(tx<0),int(ty<0),int(q>estimate))
        out+=diag+struct.pack('<2h7HHhB',tx,ty,*([1]*7),major,q,small)
        assert len(out)==183;expected.append(bytes(out))
    loader=work/'loader';loader.mkdir()
    text=(GOLEM/'examples/native_admission/main.cpp').read_text()
    artwork=(TASK/'vehicle_loader.cpp').read_text().split('uint8_t carUpload',1)[1].split('#ifdef VEHICLE_ORACLE',1)[0]
    prefix='#include "car.hpp"\n#include "traffic.hpp"\nuint8_t carUpload'+artwork+'\n'
    marker='int main(';assert text.count(marker)==1;text=text.replace(marker,prefix+marker,1)
    text='void artwork();\n'+text
    old='    if (vdp_mode(8) < 0 || !upload() || !poll(0xa5))\n        return 1;';assert text.count(old)==1
    text=text.replace(old,'    if(vdp_mode(136)<0)return 1;\n    vdp_set_pixel_coordinates();vdp_cursor_enable(false);artwork();\n    if(!upload() || !poll(0xa5))return 1;')
    old='!collect(output, 1102, 4))';assert text.count(old)==1
    text=text.replace(old,'!collect(output, 1102, 4) || !collect(output,1730,64) || !collect(output,1731,4) ||\n'
                          '            !collect(output,1732,14) || !collect(output,1733,2) || !collect(output,1734,2) || !collect(output,1735,1))')
    (loader/'main.cpp').write_text(text)
    (loader/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text()+'\nCXXFLAGS += -I'+str(TASK/'.work/oracle/include')+'\n')
    root,raw=execute('golem-scenery-heading',a.name,source,packet,loader=loader,timeout=600)
    results=[{'case':c['name'],'position':c['player']['position'],'pass':raw[i*183:(i+1)*183]==want,
              'expected_hex':want.hex(),'actual_hex':raw[i*183:(i+1)*183].hex()}
             for i,(c,want) in enumerate(zip(selected,expected))]
    report={'scope':__doc__,'track':a.track,'offset':a.offset,'cases':len(selected),'pass':raw==b''.join(expected),
            'host_command':command,'host_source_sha256':hashlib.sha256(host_source.read_bytes()).hexdigest(),
            'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Native scenery heading passes:',a.track,len(selected),'complete records')

if __name__=='__main__':main()
