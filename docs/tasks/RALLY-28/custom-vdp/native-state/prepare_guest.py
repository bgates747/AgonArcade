"""One new coarse-call guest; compatible arm retains exact ROW-001 guest binary."""
from pathlib import Path
import hashlib,json,os,shutil,struct,subprocess
HERE=Path(__file__).resolve().parent
DIRECT=HERE.parent/'direct-rows'

def main():
 guest=HERE/'guest-coarse'
 shutil.copytree(DIRECT/'guest',guest,dirs_exist_ok=True,ignore=shutil.ignore_patterns('obj','bin'))
 p=guest/'include/native.hpp';s=p.read_text();old='void tick(){command(TickWrapper,1);++world;++generation;}'
 new='''unsigned tickBatch=0;
void tick(){
    ++world;++generation;
    if(++tickBatch==4){
        // One direct silent native call; four logical steps execute natively.
        uint8_t b[]={23,0,216,12,0,1,2,0,0,0,0,0,0,17,0,9,0};
        put16(b+11,handle);send(b,sizeof b);tickBatch=0;
    }
}'''
 assert s.count(old)==1;s=s.replace(old,new);p.write_text(s)
 p=guest/'include/bindings.hpp';s=p.read_text().replace('constexpr uint32_t WrapperCount=17;','constexpr uint32_t WrapperCount=0;');p.write_text(s)
 env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH'])
 r=subprocess.run(['make','-C',str(guest),'-j1'],env=env,text=True,capture_output=True,timeout=180)
 (HERE/'GUEST-BUILD.txt').write_text(r.stdout+r.stderr)
 if r.returncode:print(r.stdout+r.stderr);raise SystemExit(r.returncode)
 modules={'baseline':DIRECT/'build-r02/rows/rally-render.vdpl','state':HERE/'build/rally-state.vdpl','coarse':HERE/'build/rally-state.vdpl'}
 result={}
 for frames in (60,900):
  for name,modulepath in modules.items():
   src=DIRECT/'fixtures'/('rows'+str(frames));dst=HERE/'fixtures'/(name+str(frames));shutil.copytree(src,dst,dirs_exist_ok=True)
   module=modulepath.read_bytes();prefix=b'\x17\0\xa0'+struct.pack('<H',50305)
   (dst/'module.vdu').write_bytes(prefix+b'\2'+prefix+b'\0'+struct.pack('<H',len(module))+module)
   (dst/'config.bin').write_bytes(b'R28F'+struct.pack('<HHIHH',1,frames,len(module),1,0))
   if name=='coarse':
    (dst/'probe.bin').write_bytes((guest/'bin/probe.bin').read_bytes())
    # Remove only the unused native invocation wrapper installations; bitmap
    # registration/data and the two-byte native argument block remain exact.
    d=(src/'native.vdu').read_bytes();at=0;out=bytearray()
    while at<len(d):
     if d[at:at+3]!=b'\x17\0\xa0':out+=d[at:];break
     id,op=struct.unpack_from('<HB',d,at+3)
     if op==2:stop=at+6
     elif op==0:stop=at+8+struct.unpack_from('<H',d,at+6)[0]
     else:out+=d[at:];break
     if not 10<=id<=26:out+=d[at:stop]
     at=stop
    (dst/'native.vdu').write_bytes(out)
   meta=json.loads((src/'expected.json').read_text())
   meta.update(renderer=name,native_owned_state=name!='baseline',coarse_physics_entry=17 if name=='coarse' else None,module_bytes=len(module),module_sha256=hashlib.sha256(module).hexdigest())
   meta['files']={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in dst.iterdir() if p.name!='expected.json'}
   (dst/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
   result[name+str(frames)]={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in dst.iterdir() if p.is_file()}
 (HERE/'FIXTURES.json').write_text(json.dumps(result,indent=2)+'\n')
 print('Six input fixtures prepared; baseline/state retain exact common guest binary.')
if __name__=='__main__':main()
