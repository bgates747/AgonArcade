"""Native admitted-state car distances/order, with the complete road still active."""
import argparse,json,struct
from profile import TASK
from native_run import execute,GOLEM
from vehicle_reference import cases,admitted
from build_vehicle_sort import build
from probe_admission import update,CALL

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');a=p.parse_args()
    source=build(a.track,TASK/'.work/vehicle-sort-source'/a.name)
    selected=[c for c in cases() if c['track']==a.track]
    reference={c['name']:c for c in json.loads((TASK/'evidence/golem-cars/reference.json').read_text())['results']}
    encoded=bytearray(b'G19A'+struct.pack('<H',len(selected)));expected=[]
    for i,case in enumerate(selected):
        record=admitted(case,i);wire=update(record)+CALL;assert len(wire)==97
        encoded+=struct.pack('<BHH',0,len(wire),0)+wire
        lap=case['length']*100;position=case['player']['position']
        cars=[[c['position'],(c['position']-position+lap)%lap,c['lane'],c['id']] for c in case['cars']]
        for left in range(5):
            for right in range(left+1,6):
                if cars[left][1]<cars[right][1]:cars[left],cars[right]=cars[right],cars[left]
        visible=[c[3] for c in cars if 64<=c[1]//100<=1100]
        assert visible==[c['id'] for c in reference[case['name']]['traffic_ordered']]
        header=record+struct.pack('<6Hf',1,1,i+1,i,0,i+1,2*position)
        expected.append((header,cars))
    loader=TASK/'.work/vehicle-sort-loader'/a.name;loader.mkdir(parents=True,exist_ok=False)
    text=(GOLEM/'examples/native_admission/main.cpp').read_text()
    old='    if (vdp_mode(8) < 0 || !upload() || !poll(0xa5))\n        return 1;';assert text.count(old)==1
    text=text.replace(old,'    if(vdp_mode(136)<0)return 1;\n    vdp_set_pixel_coordinates();vdp_cursor_enable(false);\n    if(!upload() || !poll(0xa5))return 1;')
    old='!collect(output, 1102, 4))';assert text.count(old)==1
    text=text.replace(old,'!collect(output, 1102, 4) || !collect(output, 1702, 72))')
    (loader/'main.cpp').write_text(text);(loader/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text())
    root,raw=execute('golem-vehicle-sort',a.name,source,encoded,loader=loader,timeout=240)
    assert len(raw)==len(selected)*168;results=[]
    for i,(case,(header,want)) in enumerate(zip(selected,expected)):
        record=raw[i*168:(i+1)*168];actual=[list(struct.unpack_from('<iihH',record,96+j*12)) for j in range(6)]
        results.append({'case':case['name'],'expected_order':want,'actual_order':actual,
                        'admission_pass':record[:96]==header,'pass':record[:96]==header and actual==want})
    report={'scope':__doc__,'track':a.track,'cases':len(results),'pass':all(r['pass'] for r in results),
            'remaining':'Vehicle projection, yaw, bitmap drawing and native scene images are not implemented by this sorting probe.',
            'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Native admitted vehicle ordering passes:',a.track,len(results),'cases')

if __name__=='__main__':main()
