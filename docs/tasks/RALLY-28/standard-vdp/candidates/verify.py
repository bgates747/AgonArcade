"""Check exact target streams/completions and summarize paired candidate runs."""
from pathlib import Path
import argparse,io,gzip,csv,hashlib,importlib.util,inspect,json,statistics,struct,zlib,binascii
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4];WORK=HERE/'.work';EVIDENCE=HERE/'evidence'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
VARIANTS=('dense','lookup','lookup-buffer','coarse','coarse-buffer')
def read(path):
    return path.read_bytes() if path.exists() else gzip.decompress(path.with_name(path.name+'.gz').read_bytes())
NAMES=('road','traffic_signs','player','scenery','hud','panel','bottom','viewport','swap','audio')
def packets(data):
    out=[];at=0
    while at<len(data):
        assert at+2<=len(data) and data[at]&128,('framing',at)
        n=data[at+1];assert at+2+n<=len(data);out.append((data[at]&127,data[at+2:at+2+n]));at+=2+n
    return out

def expected(name,mode):
    directory=WORK/'census'/name/'ordinary'
    if not directory.exists():directory=EVIDENCE/'host'/name
    rows=list(csv.DictReader(io.StringIO(read(directory/'frames.csv').decode())))
    setup=read(directory/'setup.bin');streams={k:read(directory/('wire-'+k+'.bin')) for k in NAMES};at={k:0 for k in NAMES};frames=[]
    for row in rows:
        take={}
        for k in NAMES:
            n=int(row[k]);take[k]=streams[k][at[k]:at[k]+n];assert len(take[k])==n;at[k]+=n
        assert len(take['viewport'])==30
        frame=take['audio']+take['scenery']+take['road']+take['viewport'][:15]+take['traffic_signs']+take['player']+take['viewport'][15:]+take['panel']+take['hud']+take['bottom']+take['swap']
        if mode:frame+=bytes([23,0,202,23,0,153,0])
        frames.append(frame)
    assert all(at[k]==len(streams[k]) for k in NAMES)
    return setup,b''.join(frames),rows

def png(ppm):
    magic,size,depth,rgb=read(ppm).split(b'\n',3);w,h=map(int,size.split());assert magic==b'P6' and depth==b'255' and len(rgb)==w*h*3
    def chunk(k,v):return struct.pack('>I',len(v))+k+v+struct.pack('>I',binascii.crc32(k+v)&0xffffffff)
    raw=b''.join(b'\0'+rgb[y*w*3:(y+1)*w*3] for y in range(h))
    ppm.with_suffix('.png').write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',w,h,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(raw))+chunk(b'IEND',b''))
    return rgb

def shadow(s,directory):
    calls=int(s['shadow_calls']);assert calls>0;scenario=((calls-1)//1024)%4;steps=(calls-1)%1024+1
    source=HERE.parent/'capacity/reference.py';spec=importlib.util.spec_from_file_location('physics_reference',source);r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)
    namespace=dict(r.__dict__)
    text=inspect.getsource(r.simulate).replace('def simulate(which):','def simulate(which, steps=1024):').replace('range(1024)','range(steps)').replace('3 if which==2 else 6,1024,elapsed','3 if which==2 else 6,steps,elapsed')
    exec(compile(text,'<partial-independent-reference>','exec'),namespace)
    values,coverage=namespace['simulate'](scenario,steps)
    actual={int(k):int(v) for k,v in csv.reader((directory/'state.csv').open())};assert actual==dict(enumerate(values)),(scenario,steps)
    return {'scenario':scenario,'steps_in_current_block':steps,'fields_checked':105,'coverage_current_block':coverage}

def verify(name,kind):
    directory=EVIDENCE/name/kind;r=json.loads((directory/'runtime/result.json').read_text());s=r['summary'];mode=int(s['mode'])
    assert r['reason']=='guest-files' and r['exit']==0 and r['identities_unchanged'];assert r['forced_sdl']=={'video':'dummy','audio':'dummy'}
    assert s['failure']=='none' and s['frames']=='900' and s['vector_restored']=='1' and s['callback_restored']=='1'
    assert s['position']=='1202800' and s['phase']=='1600'
    for n,h in r['outputs'].items():assert sha(directory/n)==h
    for n in ('candidate.bin','mode.txt'):
        assert sha(directory/n)==r['identity']['files']['sdcard/test/arcade/rally28/candidate/'+n]
    if name!='dense':assert sha(directory/'fuji.road')==r['identity']['files']['sdcard/test/arcade/rally28/candidate/fuji.road']
    stats=r['backend_stats'];assert not stats['failed'] and all(stats[k]==0 for k in ('unhandled','unregistered','unmapped'))
    setup,framebytes,census=expected(name,mode);assert int(s['bytes'])==len(framebytes),(name,kind,s['bytes'],len(framebytes))
    rows=[{k:int(v) for k,v in row.items()} for row in csv.DictReader((directory/'frames.csv').open())];assert len(rows)==900
    marker_count=0
    if mode:
        sent=read(directory/'runtime/mos-to-vdp.bin');start=sent.find(setup);assert start>=0,(name,'target setup differs from host')
        start+=len(setup);fence=bytes([23,0,202,23,0,128,93]);assert sent[start:start+7]==fence;start+=7
        assert sent[start:start+len(framebytes)]==framebytes,(name,'target full scene stream differs from host')
        rx=read(directory/'runtime/vdp-to-mos.bin');assert rx==read(directory/'runtime/vdp-to-mos-delivered.bin')
        reply=packets(rx);fenced=next(i for i,p in enumerate(reply) if p==(0,bytes([93])))
        markers=[p for op,p in reply[fenced+1:] if op==1 and len(p)==4 and p[2]==0];marker_count=len(markers);assert marker_count==900
        for row in rows:assert row['submit_mos']<=row['callback_mos']<=row['mos_end']
        assert stats['uart_rx']>=len(setup)+len(framebytes)
    mos_seconds=int(s['mos_units'])/120;prt_seconds=int(s['prt_ticks'])/1000
    continuous=r.get('host_suspend_seconds') is not None and abs(r['host_suspend_seconds'])<.1
    report={'variant':name,'mode':mode,'verified':True,'frames':900,'mos_seconds':mos_seconds,'nominal_prt_seconds':prt_seconds,
        'completed_fps_mos':900/mos_seconds if mode else None,'construction_equivalent_fps_mos':900/mos_seconds if not mode else None,
        'bytes':len(framebytes),'bytes_per_frame':len(framebytes)/900,'setup_bytes':len(setup),'callbacks_verified':marker_count,
        'host_total_seconds':r['host_seconds'],'host_window_seconds':r.get('host_window_seconds'),'host_timing_continuous':continuous,'host_suspend_seconds':r.get('host_suspend_seconds'),'completed_fps_host':900/r['host_window_seconds'] if mode and continuous and r.get('host_window_seconds') else None,'construction_equivalent_fps_host':900/r['host_window_seconds'] if not mode and continuous and r.get('host_window_seconds') else None,'host_witness_poll_seconds':r.get('host_marker_poll_seconds'),'mean_nominal_prt_ms':{k:sum(row[k] for row in rows)/900 for k in ('advance_prt','geometry_prt','construct_prt','send_prt','wait_prt')},
        'max_nominal_prt_geometry_plus_construct_ms':max(row['geometry_prt']+row['construct_prt'] for row in rows),
        'frame_mos_units':{'median':statistics.median(row['mos_end']-row['mos_begin'] for row in rows),'max':max(row['mos_end']-row['mos_begin'] for row in rows)},
        'shadow_calls':int(s['shadow_calls']),'shadow_debt':int(s['shadow_debt']),'max_shadow_debt':int(s['max_shadow_debt'])}
    if mode==2:report['shadow_reference']=shadow(s,directory)
    image=directory/'runtime/final.ppm'
    if image.exists() or image.with_name(image.name+'.gz').exists():report['rgb_sha256']=hashlib.sha256(png(image)).hexdigest()
    (directory/'verified.json').write_text(json.dumps(report,indent=2)+'\n');return report
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--variant');p.add_argument('--kind',default='live');a=p.parse_args()
    if a.variant:print(json.dumps(verify(a.variant,a.kind),indent=2))
    else:
        reports=[verify(n,k) for n in VARIANTS for k in ('cpu','live')]
        (EVIDENCE/'COMPARISON.json').write_text(json.dumps(reports,indent=2)+'\n');print(json.dumps(reports,indent=2))
