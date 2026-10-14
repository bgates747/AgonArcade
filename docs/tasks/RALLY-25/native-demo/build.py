"""Build a real native MOS demo from Golem's delivered package and Rally assets."""
from pathlib import Path
import argparse,hashlib,json,shutil,struct,subprocess,sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
WORK=HERE/'.work'
word=lambda n:struct.pack('<H',n)
command=lambda key,op:b'\x17\0\xa0'+word(key)+bytes([op])
update=lambda key,offset,data:command(key,5)+b'\xc2'+word(offset)+word(len(data))+data
call=lambda key:command(key,1)
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def write(key,data):
    out=bytearray(command(key,2))
    for start in range(0,len(data),60000):
        part=data[start:start+60000];out+=command(key,0)+word(len(part))+part
    if len(data)>60000:out+=command(key,14)
    return bytes(out)

class Tape:
    def __init__(self):self.data=bytearray();self.token=0;self.checks=[];self.multiplier=1;self.marks=0;self.in_loop=False
    def send(self,data):
        # Split only at guest send boundaries; the VDP stream remains contiguous.
        for start in range(0,len(data),60000):
            part=data[start:start+60000];self.data+=b'\1'+word(len(part))+part
    def patch(self,data,offset):
        self.data+=bytes([4])+word(offset)+word(len(data))+data
    def tx(self,op,fields,kind,value,label,handle=False,capture=False,flags=0):
        self.token+=1
        body=struct.pack('<BBHBB',1,op,self.token,1,0)+fields
        wire=b'\x17\0\xd8'+word(len(body))+body
        flags|=1 if capture else 2 if value is None else 0
        self.data+=b'\2'+struct.pack('<HBBHHH',self.token,kind,flags,value or 0,11 if handle else 65535,len(wire))+wire
        self.checks.append(dict(token=self.token,kind=kind,value=value,label=label,flags=flags,repeats=self.multiplier,loop=self.in_loop))
    def read(self,key,offset,value,label,flags=0):self.tx(5,struct.pack('<HI',key,offset),4,value,label,flags=flags)
    def mark(self):self.data+=b'\5';self.marks+=self.multiplier
    def external(self,name,data,out):
        (out/name).write_bytes(data);self.data+=b'\6'+len(data).to_bytes(3,'little')+name.encode()+b'\0'
    def repeat(self,n):self.data+=b'\11'+word(n);self.multiplier=n;self.in_loop=True
    def endrepeat(self):self.data+=b'\12';self.multiplier=1;self.in_loop=False

def assets():
    WORK.mkdir(exist_ok=True)
    source=ROOT/'docs/tasks/RALLY-24/flexe/artwork.cpp'
    frozen=ROOT/'docs/tasks/RALLY-25/.work/reference/r22'
    if not frozen.exists():
        sys.path.insert(0,str(HERE.parent/'reference'));from freeze import prepare
        frozen,_=prepare()
    subprocess.run(['c++','-std=c++17','-O2','-I'+str(frozen/'rally-production/include'),'-I'+str(frozen/'rally-game/include'),str(source),'-o',str(WORK/'artwork')],check=True)
    artwork=subprocess.check_output([str(WORK/'artwork')])
    asset=ROOT/'docs/tasks/RALLY-25/.work/renderer-helper/fuji.r24'
    if not asset.exists():
        exporter=ROOT/'docs/tasks/RALLY-24/experiment/assets.cpp'
        subprocess.run(['c++','-std=c++17','-O2','-I'+str(frozen/'rally-production/include'),'-I'+str(frozen/'rally-game/include'),str(exporter),'-o',str(WORK/'assets')],check=True)
        subprocess.run([str(WORK/'assets'),str(frozen/'rally-production'),str(WORK)],check=True)
        asset=WORK/'fuji.r24'
    assert len(asset.read_bytes())==149518
    shutil.copyfile(ROOT.parent/'golem/reference/agnb-asm/lib/mos_api.inc',WORK/'mos_api.inc')
    assembler=ROOT.parent/'golem/docs/tasks/GOLEM-007/build/ez80asm'
    subprocess.run([str(assembler),'guest.asm','.work/probe.bin','-c'],cwd=HERE,check=True)
    assert (WORK/'probe.bin').stat().st_size<65536
    return artwork,asset.read_bytes()

def build(package,resources,frames=900,paced=True,review_fast=False,output=None):
    package=Path(package).resolve();resources=json.loads(Path(resources).read_text())
    iface=json.loads((package/'interface.json').read_text());meta=json.loads((package/'backends.json').read_text())
    names={e['name']:e['logical_id'] for e in iface['entries']};fields={g['name']:g for g in iface['globals']}
    assert all(n in names for n in ('InitRace','Tick120','Render30','StopRace'))
    images=list(package.glob('*.vdpl'));assert len(images)==1,'Expected exactly one actual packaged VDPL'
    image=images[0].read_bytes();assert image[:4]==b'VDPL','Not a real VDPL package'
    root=iface['state_buffer'];completion=resources['completion'];outputs=resources['outputs'];asset_range=resources['asset']
    assert len(outputs)==3 and all(r['offset']==0 for r in outputs),'Drawing buffers start at zero'
    assert resources['session']==7 and 1<=frames<=900
    out=Path(output).resolve() if output else WORK/('review-fast' if review_fast else 'review' if paced else 'headless');out.mkdir(parents=True,exist_ok=True)
    artwork,asset=assets();t=Tape()
    # Assets are distinct untimed streams so no temporary load exceeds upper RAM.
    base=bytes([22,136,23,0,192,0,23,0,0xf8,1,0,1,0,12])
    base+=bytes([31,0,0])+b'RALLY / GOLEM NATIVE DEMO\r\nFuji - centerline / no damage\r\n'
    base+=b'30-Hz target / foreground fixture\r\n' if paced else b'UNPACED experimental fixture\r\n'
    base+=artwork
    # Fixed mirror matrix used by the unchanged renderer (not exercised at steer0).
    base+=bytes([23,0,160,0xf0,0xf9,32,0,23,0,160,0xf0,0xf9,32,11,0xc0,255,255,0,0,101,0,0,0,1,0,0,0])
    t.external('artwork.vdu',base,out)
    t.external('assets.vdu',write(asset_range['buffer'],bytes(asset_range['offset'])+asset),out)
    t.send(write(resources['staging'],image))
    t.tx(1,struct.pack('<HIH',resources['staging'],len(image),0),2,None,'LOAD',capture=True)
    # Application-owned world/arrays, compiler-owned argument/wrapper storage.
    t.external('common.vdu',(package/'common-install.bin').read_bytes(),out)
    t.external('native.vdu',(package/'native-install.bin').read_bytes(),out)
    if review_fast:
        # Patch actual generated wrapper handles by their advertised byte offset.
        for wrapper in meta['native_wrappers']:
            t.patch(update(wrapper,meta['native_handle_offset'],b'\0\0'),11)
    # Full checks/direct Render RUN do not depend on wrapper patch layout.
    t.send(update(root,8,struct.pack('<I',7)))
    t.send(write(completion['buffer'],bytes(completion['offset']+48)))
    for desc,capacity in zip(outputs,(20480,2048,256)):
        assert desc['bytes']==capacity;t.send(write(desc['buffer'],bytes(desc['offset']+capacity)))
    def invoke(name,quiet=False):
        entry=names[name];t.send(update(root,28,word(entry)))
        t.send(update(completion['buffer'],completion['offset']+44,b'\0\0'))
        t.tx(2,struct.pack('<HHH',0,entry,meta['native_arguments']),3,0,name,handle=True,flags=4 if quiet else 0)
    invoke('InitRace');t.tx(4,word(17),4,None,'stack before');t.mark()
    t.repeat(frames)
    if review_fast:
        # Silent ordered finite physics calls; cumulative tick+fresh-generation
        # checks below catch any missed step before output may be drawn.
        t.send(call(meta['native_wrappers'][names['Tick120']])*4)
    else:
        for _ in range(4):invoke('Tick120',quiet=True)
    invoke('Render30')
    # Only fresh, matched successful publication can reach drawing.
    t.read(completion['buffer'],completion['offset']+44,1,'completion ready',4)
    if not review_fast:t.read(completion['buffer'],completion['offset']+12,7,'completion session',4)
    t.read(completion['buffer'],completion['offset']+16,0,'completion request = frame',16)
    t.read(completion['buffer'],completion['offset']+20,0,'completion tick = frame*4',8)
    t.read(root,20,0,'fresh root generation = frame*5+1',32|4)
    if not review_fast:
        t.read(root,24,names['Render30'],'root successful entry',4)
        t.read(root,12,0,'interface success',4);t.read(root,14,0,'language success',4)
    # Set the full playfield, clear old sky/cars and execute actual output buffers.
    paint=bytes([26,31,0,0])+b'RALLY / GOLEM NATIVE DEMO\r\nFuji - centerline / no damage\r\n'+bytes([18,0,16,25,4])+struct.pack('<hh',0,24)+bytes([25,101])+struct.pack('<hh',319,239)
    paint+=bytes([24])+struct.pack('<4h',0,223,319,24)+bytes([25,4])+struct.pack('<hh',0,24)
    paint+=b''.join(call(desc['buffer']) for desc in outputs)
    t.send(paint)
    if paced:t.data+=b'\13'
    t.send(bytes([23,0,195]));t.mark();t.endrepeat()
    t.tx(4,word(17),4,None,'stack after');t.mark()
    t.read(root,20,1+5*frames,'final generation');t.read(root,22,0,'final generation high')
    t.read(root,fields['worldTick']['offset'],4*frames,'final world tick')
    t.read(root,fields['renderRequest']['offset'],frames,'final render request')
    # Retain full final root/array bytes through existing READ16 diagnostics.
    for key,data in [(root,(package/'state.bin').read_bytes())]+[(a['buffer'],(package/a['initial_data']).read_bytes()) for a in iface['arrays'] if a['access']==3]:
        for offset in range(0,len(data),2):t.read(key,offset,None,f'final:{key}:{offset}')
    invoke('StopRace');t.tx(3,b'\0\0',3,0,'UNLOAD',handle=True)
    t.data+=b'\0'
    assert len(t.data)<=0x30000 and t.marks*3<=3000
    logged=sum(c['repeats']*10 for c in t.checks if not c['flags']&4);assert logged<=50000,logged
    for name,data in [('script.bin',t.data),('probe.bin',(WORK/'probe.bin').read_bytes())]:(out/name).write_bytes(data)
    (out/'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
    result=dict(schema=1,review_fast=review_fast,frames=frames,physics_ticks=4*frames,paced=paced,checks=t.checks,reply_bytes=logged,
                tick_samples=t.marks,mos_tick_hz=120,prt_instrumented=True,prt_cycles_per_tick=18432,package=str(package),module_sha256=hashlib.sha256(image).hexdigest(),
                source_sha256=sha(HERE/'demo.golem'),resources=resources,
                files={p.name:sha(p) for p in out.iterdir() if p.is_file() and p.name!='expected.json'})
    (out/'expected.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Built real native demo:',out,'script',len(t.data),'reply bytes',logged)
    return out

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--package');p.add_argument('--resources');p.add_argument('--frames',type=int,default=900);p.add_argument('--output-directory');p.add_argument('--unpaced',action='store_true');p.add_argument('--review-fast',action='store_true');p.add_argument('--assets-only',action='store_true');a=p.parse_args()
    if a.assets_only:
        art,asset=assets();print('Artwork',len(art),'asset',len(asset),'guest',(WORK/'probe.bin').stat().st_size)
    else:
        if not a.package or not a.resources:p.error('--package and --resources required')
        build(a.package,a.resources,a.frames,not a.unpaced,a.review_fast,a.output_directory)
