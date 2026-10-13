"""Build task-local portable SD fixtures. No emulator or hardware access."""
from pathlib import Path
import hashlib, importlib.util, json, shutil, struct, subprocess, sys
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
EXP=HERE.parent/'experiment'
WORK=HERE/'.work'
sys.path.insert(0,str(EXP))
import protocol as p

def mod(name,path):
    spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
road=mod('road_protocol',ROOT/'docs/tasks/RALLY-15/protocol.py')
sha=lambda data:hashlib.sha256(data).hexdigest()
def fnv(data):
    h=2166136261
    for x in data:h=((h^x)*16777619)&0xffffffff
    return h

def write(id,data):
    b=p.command(id,2)
    for off in range(0,len(data),60000):
        part=data[off:off+60000];b+=p.command(id,0)+p.word(len(part))+part
    if len(data)>60000:b+=p.command(id,14) # consolidate for contiguous module lease
    return b
class Tape:
    def __init__(self):self.data=bytearray();self.checks=[];self.token=0;self.wire=0;self.marks=0
    def send(self,b):
        assert len(b)<65536
        self.data+=b'\1'+p.word(len(b))+b;self.wire+=len(b)
    def patch(self,b,offset):
        self.data+=b'\4'+p.word(offset)+p.word(len(b))+b;self.wire+=len(b)
    def mark(self):self.data+=b'\5';self.marks+=1
    def tx(self,op,fields,kind,value,label,handle=False,capture=False):
        self.token+=1
        body=struct.pack('<BBHBB',1,op,self.token,1,0)+fields
        b=b'\x17\0\xd8'+p.word(len(body))+body
        self.data+=b'\2'+struct.pack('<HBBHHH',self.token,kind,1 if capture else 2 if value is None else 0,value or 0,11 if handle else 65535,len(b))+b
        self.checks.append(dict(token=self.token,kind=kind,value=value,label=label));self.wire+=len(b)
    def run(self,entry,label):self.tx(2,struct.pack('<HHH',0,entry,p.ARGS),3,0,label,handle=True)
    def read(self,id,offset,value,label):self.tx(5,struct.pack('<HI',id,offset),4,value,label)
    def call(self,entry):self.patch(p.run(1,entry),11)

def inputs(track):
    asset=(EXP/'.work'/f'{track}.r24').read_bytes();lap=struct.unpack_from('<I',asset,20)[0]*100
    states=[]
    for i in range(32):
        pos= (lap*i//28)%lap if i<28 else [lap-1,lap-6500,1,lap//4][i-28]
        cars=[((pos+z)%lap,lane*256,(-1 if j%2 else 1)*320) for j,(z,lane) in enumerate(zip([6400,10000,20000,35000,60000,109999],[-30,25,-20,15,0,30]))]
        states.append(p.frame(7,i+1,i*4,pos,[0,3999,4000,7999][i%4],[-21,0,21,1][i%4],[-90*256,0,90*256,0][i%4],cars=cars))
    return asset,states

def reference(track,variant,states):
    b=subprocess.check_output([str(EXP/'.work/oracle'),str(ROOT/'rally-production'),track,variant],input=b''.join(states));at=0;out=[]
    for state in states:
        sizes=struct.unpack_from('<6I',b,at);at+=24;row=[]
        for n in sizes[:3]:row.append(b[at:at+n]);at+=n
        out.append(row)
    assert at==len(b);return out

def build():
    WORK.mkdir(exist_ok=True)
    sdk=ROOT.parent/'agon-vdplet';golem=ROOT.parent/'golem'
    shutil.copyfile(golem/'reference/agnb-asm/lib/mos_api.inc',HERE/'mos_api.inc')
    subprocess.run([str(golem/'docs/tasks/GOLEM-007/build/ez80asm'),'probe.asm','.work/probe.bin','-l','-c'],cwd=HERE,check=True)
    assert (WORK/'probe.bin').stat().st_size<65536
    subprocess.run(['g++','-std=c++17','-O2','-I'+str(ROOT/'rally-production/include'),'-I'+str(ROOT/'rally-game/include'),str(HERE/'artwork.cpp'),'-o',str(WORK/'artwork')],check=True)
    art=subprocess.check_output([str(WORK/'artwork')])
    for v in ('A','B'):
        subprocess.run([sys.executable,str(sdk/'tools/build_module.py'),str(HERE/'diagnostic.c'),'--compiler',str(Path.home()/'.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc'),'--output',str(WORK/v),'--name','rally-'+v.lower(),'--variant',str(1 if v=='A' else 2),'--build-id',hex(0x52324400+ord(v))],check=True,stdout=subprocess.DEVNULL)
    for v in ('A','B'):
        subprocess.run([str(EXP/'.work/admission'),str(WORK/v/f'rally-{v.lower()}.vdpl')],check=True)
        frames={}
        for line in (WORK/v/f'rally-{v.lower()}.su').read_text().splitlines():
            name,size,kind=line.split('\t');assert kind=='static'
            frames[name.rsplit(':',1)[-1]]=int(size)
        chains=[['bitmap','affine','word','byte'],['viewport','plot','word','byte'],['rect','plot','word','byte'],['command','word','byte'],['cx','centre_exact','u32'],['acquire'],['memcpy'],['memset']]
        core=frames['rally_entry']+max(sum(frames.get(n,0) for n in chain) for chain in chains)
        bound=frames['vdplet_entry']+max(core,frames['finish']+frames['acquire'])
        assert bound<=512,(v,bound,frames)
        (WORK/v/'stack.json').write_text(json.dumps(dict(module_source_bound_bytes=bound,frames=frames,excludes='host callbacks, interrupt and window spill overhead'),indent=2)+'\n')

    for track in ('fuji','oval'):
      asset,states=inputs(track)
      for mode in ('replay','A','B'):
        variant='A' if mode=='replay' else mode
        outputs=reference(track,variant,states)
        out=WORK/'fixtures'/f'{track}-{mode.lower()}';out.mkdir(parents=True,exist_ok=True)
        image=(WORK/variant/f'rally-{variant.lower()}.vdpl').read_bytes()
        setup=bytes([22,136,23,0,192,0,23,0,0xf8,1,0,1,0])+road.startup()+art
        setup+=bytes([23,0,0xa0,0xf0,0xf9,32,0,23,0,0xa0,0xf0,0xf9,32,11,0xc0,255,255,0,0,101,0,0,0,1,0,0,0])
        setup+=write(p.ASSETS,asset)
        assert len(setup)<=0x40000
        t=Tape();t.data+=b'\6'+len(setup).to_bytes(3,'little')+b'setup.vdu\0'
        t.send(write(31000,image));t.tx(1,struct.pack('<HIH',31000,len(image),0),2,None,'load',capture=True)
        for id,data in [(p.ARGS,p.arguments(7,struct.unpack_from('<I',asset,12)[0])),(p.STATE,bytes(112)),(p.STATUS,bytes(32)),(p.ROAD,bytes(20480)),(p.ACTORS,bytes(2048)),(p.PLAYER,bytes(256)),(31012,bytes(1024))]:t.send(write(id,data))
        t.run(0,'bind')
        # Wrapper handle patched in the upload; the compiled module is real Xtensa.
        for id,commands in p.wrappers(1).items():
            b=write(id,commands)
            if id==p.PREPARE:t.patch(b,b.index(p.run(1))+11) # handle within embedded RUN
            else:t.send(b)
        t.tx(4,p.word(17),4,None,'stack-before')
        t.mark();frame_wire=[]
        viewport=bytes([24])+struct.pack('<4h',0,223,319,24)+bytes([25,4])+struct.pack('<hh',0,24)
        for i,state in enumerate(states):
            before=t.wire
            t.mark()
            # Reset each test page to a deterministic flat sky; no scrolling/HUD/audio workload.
            t.send(bytes([26,18,0,16,16])+viewport)
            if mode=='replay':
                t.call(3)
                for b in outputs[i]:t.send(b[:-6]) # remove buffered RETURN for serial stream
            else:
                for part in p.submit_parts(state):t.send(part)
            t.mark()
            t.send(bytes([23,0,195]));t.call(2)
            frame_wire.append(t.wire-before)
        # INFO is ordered after every silent post-swap mark.
        t.tx(4,p.word(17),4,None,'stack-after');t.mark()
        for i,row in enumerate(outputs):
            expected=[i+1,None,None,None]+([0,0,0] if mode=='replay' else [fnv(b) for b in row])+[0]
            for field,value in enumerate(expected):
                for half in range(2):
                    t.read(31012,i*32+field*4+half*2,None if value is None else (value>>(half*16))&65535,f'metric:{i}:{field}:{half}')
        t.tx(3,b'\0\0',3,0,'unload',handle=True)
        t.data+=b'\0'
        assert len(t.data)<=0x30000 and len(t.checks)*10<=32768 and t.marks<=256
        for name,data in [('setup.vdu',setup),('script.bin',t.data),('probe.bin',(WORK/'probe.bin').read_bytes())]:(out/name).write_bytes(data)
        meta=dict(schema=1,track=track,mode=mode,samples=32,warmup_samples=4,checks=t.checks,marks=t.marks,frame_wire_bytes=frame_wire,expected_hashes=[[fnv(b) for b in row] for row in outputs],state_sha256=sha(b''.join(states)),files={n:sha((out/n).read_bytes()) for n in ('setup.vdu','script.bin','probe.bin')},module_sha256=sha(image),nominal_cpu_hz=240000000,nominal_mos_tick_hz=120,scope='diagnostic scene replay/native generation, not full-game FPS')
        (out/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
        (out/'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
        (out/'README.txt').write_text('RALLY-24 '+track+' '+mode+'\nRequires the matching runtime-enabled VDP firmware, not stock VDP.\nFrom MOS: cd to this directory, then exec run.txt\nWait for RALLY-24 DONE. replies.log and ticks.log are saved here.\nfailure.log means a failed check; keep it and both other logs.\nCopy logs aside before rerunning (filenames are reused).\nDecode on host with decode.py DIRECTORY. No per-frame disk writes.\n')
        print(out.name,len(t.data),'tape bytes;',len(setup),'startup bytes')
if __name__=='__main__':build()

# Small arithmetic diagnostic, added after actual VGA comparison found edge differences.
def matrix_probe():
    out=WORK/'fixtures/matrix';out.mkdir(parents=True,exist_ok=True);t=Tape();t.send(bytes([22,8,23,0,192,0])+road.startup());rows=[]
    for track in ('fuji','oval'):
        asset,states=inputs(track);a=reference(track,'A',[states[-1]])[0][0];b=reference(track,'B',[states[-1]])[0][0]
        at=15;bt=15;band=0
        while a[at:at+6]==p.command(30000,5):
            params=struct.unpack_from('<4h',a,at+11);painted=struct.unpack_from('<H',a,at+22)[0]==30008
            strips=5 if painted else 4;n=strips*27
            if params[2]>=120:
                t.send(road.draw_section(*params,painted)+p.command(30007,14))
                for strip in range(strips):
                    for vertex in range(4):
                        expected=struct.unpack_from('<h',b,bt+strip*27+5+vertex*6)[0]
                        index=len(t.checks)
                        t.read(30007,strip*35+5+vertex*8,None,f'x:{track}:{band}:{strip}:{vertex}')
                        rows.append(dict(check=index,track=track,band=band,params=list(params),strip=strip,vertex=vertex,native_signed_x=expected))
            at+=25;bt+=n;band+=1
        assert band>0
    t.mark();t.data+=b'\0'
    assert len(t.checks)*10<=32768
    for name,data in [('setup.vdu',b''),('script.bin',t.data),('probe.bin',(WORK/'probe.bin').read_bytes())]:(out/name).write_bytes(data)
    (out/'expected.json').write_text(json.dumps(dict(kind='matrix',checks=t.checks,rows=rows),indent=2)+'\n')
    (out/'run.txt').write_bytes(b'load probe.bin\r\nrun .\r\n')
    (out/'README.txt').write_text('RALLY-24 matrix coordinate probe.\nRequires matching runtime-enabled VDP. From this directory: exec run.txt\nSaves replies.log and ticks.log. Decode with decode.py DIRECTORY.\nThis checks actual matrix conversion; differences from signed native arithmetic\nare recorded, not treated as failed transport transactions.\n')
    print('matrix probe',len(rows),'coordinate reads')
if __name__=='__main__':matrix_probe()
