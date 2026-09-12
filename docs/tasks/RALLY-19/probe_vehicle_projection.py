"""Native complete-road plus numeric car projection from production state.

Compare all 156 frozen/reference poses, including every steering tick, with
the accepted host oracle. No projected vehicle values are sent to the VDP.
"""
import argparse,json,struct
from profile import TASK
from native_run import execute,GOLEM
from vehicle_reference import cases,admitted
from build_vehicle_projection import build
from probe_admission import update,CALL

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name')
    p.add_argument('--track',choices=['oval','fuji'],default='oval');a=p.parse_args()
    source=build(a.track,TASK/'.work/vehicle-projection-source'/a.name)
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
        ref=reference[case['name']]
        visible={c['id']:c for c in ref['traffic_ordered']};projected=[]
        for _,distance,_,car_id in cars:
            if car_id not in visible:
                assert not 64<=distance//100<=1100
                projected.append([0,car_id,0,14,0,0,0,0])
            else:
                c=visible[car_id]
                projected.append([1,car_id,c['bitmap'],c['scale'],int(c['mirror']),c['x'],c['y'],c['translation']])
        player=ref['player'];player_values=[player['bitmap'],int(player['mirror']),player['x'],player['y'],
                                         player['x']+(50 if player['mirror'] else 51),0]
        flags=[1,1,projected[-1][0],len(visible)]
        header=record+struct.pack('<6Hf',1,1,i+1,i,0,i+1,2*position)
        expected.append((header,cars,projected,player_values,flags))
    loader=TASK/'.work/vehicle-projection-loader'/a.name;loader.mkdir(parents=True,exist_ok=False)
    text=(GOLEM/'examples/native_admission/main.cpp').read_text()
    old='    if (vdp_mode(8) < 0 || !upload() || !poll(0xa5))\n        return 1;';assert text.count(old)==1
    text=text.replace(old,'    if(vdp_mode(136)<0)return 1;\n    vdp_set_pixel_coordinates();vdp_cursor_enable(false);\n    if(!upload() || !poll(0xa5))return 1;')
    old='!collect(output, 1102, 4))';assert text.count(old)==1
    text=text.replace(old,'!collect(output, 1102, 4) || !collect(output, 1702, 72) ||\n'
                          '            !collect(output, 1714, 96) || !collect(output, 1716, 12) || !collect(output, 1711, 8))')
    (loader/'main.cpp').write_text(text);(loader/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text())
    root,raw=execute('golem-vehicle-projection',a.name,source,encoded,loader=loader,timeout=300)
    size=284;assert len(raw)==len(selected)*size;results=[]
    for i,(case,(header,order,projected,player,flags)) in enumerate(zip(selected,expected)):
        record=raw[i*size:(i+1)*size]
        actual_order=[list(struct.unpack_from('<iihH',record,96+j*12)) for j in range(6)]
        actual_projected=[list(struct.unpack_from('<5HhhH',record,168+j*16)) for j in range(6)]
        actual_player=list(struct.unpack_from('<HHhhhH',record,264))
        actual_flags=list(struct.unpack_from('<4H',record,276))
        checks={'admission':record[:96]==header,'order':actual_order==order,
                'projection':actual_projected==projected,'player':actual_player==player,'flags':actual_flags==flags}
        results.append({'case':case['name'],'pass':all(checks.values()),'checks':checks,
                        'expected_order':order,'actual_order':actual_order,
                        'expected_projection':projected,'actual_projection':actual_projected,
                        'expected_player':player,'actual_player':actual_player,
                        'expected_flags':flags,'actual_flags':actual_flags})
    report={'scope':__doc__,'track':a.track,'cases':len(results),'pass':all(r['pass'] for r in results),
            'remaining':'Bitmap drawing and native scene image qualification remain pending. This is numeric evidence only.',
            'results':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Native admitted vehicle projection passes:',a.track,len(results),'cases')

if __name__=='__main__':main()
