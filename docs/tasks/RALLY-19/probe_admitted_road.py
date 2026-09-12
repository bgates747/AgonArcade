"""Qualify complete road dispatch behind the unchanged80-byte admitted-state ABI.

The original210 admission cases are retained, including byte cuts and wrap.
Rejected/missing triggers must leave all road diagnostic outputs unchanged.
"""
import argparse,json,struct
from profile import TASK
from native_run import execute,GOLEM
from build_admitted_road import build
from probe_admission import cases
from probe_road import reference

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');a=p.parse_args()
    source=build(a.track,TASK/'.work/admitted-road-source'/a.name)
    events,encoded=cases(int(a.track=='fuji'))
    states=[bytes.fromhex(e['expected'])[:80] for e in events if e['accepted']]
    wanted=iter(reference(a.track,[(struct.unpack_from('<i',s,8)[0],struct.unpack_from('<H',s,12)[0]) for s in states]))
    loader=TASK/'.work/admitted-road-loader'/a.name;loader.mkdir(parents=True,exist_ok=False)
    text=(GOLEM/'examples/native_admission/main.cpp').read_text()
    old='    if (vdp_mode(8) < 0 || !upload() || !poll(0xa5))\n        return 1;';assert text.count(old)==1
    text=text.replace(old,'    if(vdp_mode(136)<0)return 1;\n    vdp_set_pixel_coordinates();vdp_cursor_enable(false);\n    if(!upload() || !poll(0xa5))return 1;')
    old='!collect(output, 1102, 4))';assert text.count(old)==1
    text=text.replace(old,'!collect(output, 1102, 4) || !collect(output, 1020, 80) || !collect(output, 1021, 10) || !collect(output, 1600, 198))')
    (loader/'main.cpp').write_text(text);(loader/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text())
    root,raw=execute('golem-admitted-road',a.name,source,encoded,loader=loader,timeout=300)
    (root/'cases.json').write_text(json.dumps(events,indent=2)+'\n');assert len(raw)==len(events)*384
    lastRoad=bytes(288);results=[]
    for i,event in enumerate(events):
        record=raw[i*384:(i+1)*384];admission=record[:96]==bytes.fromhex(event['expected']);diagnostics=record[96:]
        if event['kind']==1:lastRoad=bytes(288)
        result={'name':event['name'],'admission_pass':admission,'accepted':event['accepted']}
        if event['accepted']:
            want=next(wanted);count,active=struct.unpack_from('<2H',diagnostics,60);flags=struct.unpack_from('<5H',diagnostics,80)
            entries=[struct.unpack_from('<HhH',diagnostics,90+6*j) for j in range(min(count,32)+1)]
            rows=count==len(want)-1 and [r[0] for r in entries]==[r[0] for r in want]
            parity=rows and [r[2] for r in entries[:-1]]==[r[2] for r in want[:-1]]
            error=max(abs(x[1]-y[1]) for x,y in zip(entries,want)) if rows else None
            road=rows and parity and error<=1 and active==0 and flags==(1,1,1,1,1)
            result.update(actual=entries,oracle=want,band_count=count,active=active,flags=flags,max_centre_error=error,road_pass=road)
            lastRoad=diagnostics
        else:
            road=diagnostics==lastRoad;result['road_unchanged']=road
        result['pass']=admission and road;results.append(result)
    assert next(wanted,None) is None
    report={'scope':__doc__,'track':a.track,'cases':len(events),'accepted':len(states),'pass':all(r['pass'] for r in results),'results':results,'limits':'Still road only. GP is parser echo, not raster completion; raw interrupted writes use the existing diagnostic idle recovery. No frontend/traffic acceptance.'}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');assert report['pass'],[r for r in results if not r['pass']][:3]
    print('Admitted full-road dispatch pass:',a.track,len(events),'events,',len(states),'accepted frames')
if __name__=='__main__':main()
