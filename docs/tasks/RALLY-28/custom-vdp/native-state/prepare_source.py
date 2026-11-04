"""Prepare native-owned typed state; old generated source is read-only evidence."""
from pathlib import Path
import hashlib,json,re,shutil,struct
HERE=Path(__file__).resolve().parent
BASE=HERE.parent/'direct-rows/source/rows'
TYPES={'uint16':'uint16_t','sint16':'int16_t','uint32':'uint32_t','sint32':'int32_t','bool':'uint16_t'}


def main():
 target=HERE/'source';shutil.copytree(BASE,target,dirs_exist_ok=True)
 iface=json.loads((BASE/'interface.json').read_text());text=(BASE/'checked.c').read_text()
 fields={g['offset']:g for g in iface['globals']}
 arr={a['buffer']:a for a in iface['arrays']}
 common=(BASE/'common-install.bin').read_bytes();images={};at=0
 while at<len(common):
  assert common[at:at+3]==b'\x17\0\xa0';id,op=struct.unpack_from('<HB',common,at+3);at+=6
  if op==2:images.pop(id,None)
  else:
   assert op==0;n=struct.unpack_from('<H',common,at)[0];at+=2;images[id]=common[at:at+n];at+=n

 define='''/* Native-owned state. No pointer here refers to a borrowed VDP buffer. */
typedef struct { int32_t progress; uint32_t position; int32_t lateral;
                 uint16_t active,contacts; } NativeOpponent;
_Static_assert(sizeof(NativeOpponent)==16,"native opponent layout");
typedef struct {\n'''
 for g in iface['globals']:define+=f"    {TYPES[g['type']]} {g['name']};\n"
 define+='    NativeOpponent opponents[6];\n    uint16_t failure;\n} NativeWorld;\n'
 define+='static NativeWorld world;\nstatic uint32_t owner_session;\nstatic uint16_t initialized,poisoned;\n'
 for id,name in [(7,'native_routes'),(8,'native_sine')]:
  values=struct.unpack('<'+'h'*(len(images[id])//2),images[id])
  define+=f'static const int16_t {name}[{len(values)}]={{'+','.join(map(str,values))+'};\n'
 define+='static void import_globals(NativeWorld*w,const uint8_t*p){\n'
 for off,g in fields.items():define+=f"w->{g['name']}=({TYPES[g['type']]}){'get32' if g['bytes']==4 else 'get'}(p+{off});\n"
 define+='}\nstatic void export_globals(uint8_t*p,const NativeWorld*w){\n'
 for off,g in fields.items():define+=f"{'put32' if g['bytes']==4 else 'put'}(p+{off},(uint32_t)w->{g['name']});\n"
 define+='}\n'
 def scalar(s):
  def read(m):
   off=int(m[2])
   if off<112:return m[0]
   assert off in fields,off
   return f"(uint32_t)w->{fields[off]['name']}"
  s=re.sub(r'(get32|get)\(state\+(\d+)\)',read,s)
  def store(m):
   off=int(m[2]);assert off in fields,off;g=fields[off]
   return f"w->{g['name']}=({TYPES[g['type']]})({m[3]});"
  return re.sub(r'(put32|put)\(state\+(\d+),([^;]+)\);',store,s)
 def numerical(s):
  # Replace a complete generated scalar-access scope, not just its pointer.
  pattern=r'\{vdplet_view_v1 (\w+)=\{sizeof\(\1\),0,0,0,0\};\s*rc=h->buffer_acquire\(h->context,(\d+),VDPL_(READ|WRITE),\(uint32_t\)\((.*?)\)\*(\d+)u,(\d+),&\1\);\s*if\(rc\)\{ROOT_FAIL\(8,rc\);\}\s*(.*?)\s*rc=h->buffer_release\(h->context,\1.lease\);if\(rc\)\{ROOT_FAIL\(8,rc\);\}\}'
  def access(m):
   view,id,mode,index,width,n,op=m.groups();a=arr[int(id)];assert int(width)==int(n)==a['element_bytes']
   index=re.sub(r'-\(0\)$','',index)
   expr=f"w->opponents[{index}].{a['name']}" if int(id)<7 else f"{'native_routes' if id=='7' else 'native_sine'}[{index}]"
   if mode=='READ':
    q=re.fullmatch(r'(\w+)=(get32|get)\('+view+r'.data\);',op);assert q,op
    cast='uint32_t' if int(width)==4 else 'uint16_t'
    return f'{q[1]}=({cast})({expr});'
   q=re.fullmatch(r'(put32|put)\('+view+r'.data,([^;]+)\);',op);assert q,op
   return f"{expr}=({TYPES[a['type']]})({q[2]});"
  s=re.sub(pattern,access,s,flags=re.S)
  s=scalar(s)
  assert 'buffer_acquire' not in s and 'ROOT_FAIL' not in s and 'state+' not in s
  s=s.replace('break;}','return 0;\n}')
  return s
 starts={e:text.index(f'case {e}:{{',text.index('switch(r->entry_id){')) for e in [3,13,15,16]}
 end=text.index('\n}\nrc=renderer_hook',starts[16])
 body={}
 for i,e in enumerate([3,13,15,16]):
  stop=starts[[3,13,15,16][i+1]] if i<3 else end
  case=text[starts[e]:stop];case=case.replace(f'case {e}:{{',f'static int32_t native_{e}(NativeWorld*w){{',1)
  body[e]=numerical(case)
 validate=text[text.index('if((int64_t)',text.index('put(state+14,0);')):text.index('switch(r->entry_id){')]
 validate='static int32_t native_validate(NativeWorld*w){\n'+scalar(validate)+'return 0;\n}\n'
 numeric='#undef FAIL\n#define FAIL(n) do {w->failure=(n);return VDPL_E_ARGUMENT;}while(0)\n'+validate+'\n'.join(body.values())+'\n#undef FAIL\n'
 hook=text[text.index('static int32_t renderer_hook'):text.index('#include "publication.inc"')]
 hook=hook.replace('unsigned entry,uint8_t*state)','unsigned entry,uint8_t*state,const NativeWorld*w)')
 for id,field in [(4,'station'),(5,'lateral_q8'),(2,'active')]:
  lines=hook.splitlines();line=next(x for x in lines if 'rc=h->buffer_acquire' in x and f'context,{id},' in x)
  source={4:'position',5:'lateral',2:'active'}[id]
  hook=hook.replace(line,f'for(unsigned i=0;i<6;++i)s.opponents[i].{field}=w->opponents[i].{source};')
 # Root fields used by the helper become native fields; header session stays external.
 hook=scalar(hook)
 export='''/* Legacy diagnostics are boundary exports, never live numerical storage. */
static int32_t export_arrays(const vdplet_host_v1*h,const NativeWorld*w){
'''
 for id,a in arr.items():
  if id>=7:continue
  export+=f'''{{vdplet_view_v1 v={{sizeof(v),0,0,0,0}};
int32_t rc=h->buffer_acquire(h->context,{id},VDPL_WRITE,0,{a['bytes']},&v);if(rc)return rc;
for(unsigned i=0;i<6;++i){'put32' if a['element_bytes']==4 else 'put'}(v.data+i*{a['element_bytes']},(uint32_t)w->opponents[i].{a['name']});
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}}\n'''
 export+='return 0;\n}\nstatic int32_t import_overrides(const vdplet_host_v1*h,NativeWorld*w){\n'
 for id,name in [(4,'position'),(5,'lateral')]:
  export+=f'''{{vdplet_view_v1 v={{sizeof(v),0,0,0,0}};
int32_t rc=h->buffer_acquire(h->context,{id},VDPL_READ,0,24,&v);if(rc)return rc;
for(unsigned i=0;i<6;++i)w->opponents[i].{name}=({'uint32_t' if id==4 else 'int32_t'})get32(v.data+i*4);
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}}\n'''
 export+='return 0;\n}\n'
 header=text[text.index('static const uint8_t offsets'):text.index('put(state+14,0);')]
 # Remove seven generic bound-array shape probes, retaining immutable header check.
 header=header[:header.index('{vdplet_view_v1 bound=')]
 # Header requested-entry checks are handled once below, including batch normalization.
 header=header.replace('if(get(state+28)>=17u||get(state+28)!=r->entry_id)ROOT_FAIL(7,VDPL_E_ARGUMENT);','')
 entry='''#undef ROOT_FAIL
#define ROOT_FAIL(n,code) do {put(state+12,(n));rc=(code);goto done;}while(0)
__attribute__((visibility("default")))
int32_t vdplet_entry(const vdplet_host_v1*h,const vdplet_request_v1*r){
if(!h||!r||h->struct_bytes<sizeof(*h)||r->struct_bytes<sizeof(*r)||h->abi_major!=1||!(h->capabilities&VDPL_CAP_BUFFERS)||!h->buffer_acquire||!h->buffer_release)return VDPL_E_ABI;
if(r->operation==VDPL_INIT){initialized=poisoned=0;owner_session=0;renderer.bound=0;return identity==0x474c3332u?0:VDPL_E_INIT;}
if(r->operation==VDPL_FINI){initialized=poisoned=0;owner_session=0;renderer.bound=0;return 0;}
if(r->operation!=VDPL_RUN || (r->entry_id!=3 && r->entry_id!=13 && r->entry_id!=15 && r->entry_id!=16 && r->entry_id!=17))return VDPL_E_UNSUPPORTED;
if(r->argument_bytes!=2)return VDPL_E_ARGUMENT;
vdplet_view_v1 args={sizeof(args),0,0,0,0},view={sizeof(view),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,r->argument_buffer,VDPL_READ,0,2,&args);if(rc)return rc;
uint16_t id=get(args.data);rc=h->buffer_release(h->context,args.lease);if(rc)return rc;
rc=h->buffer_acquire(h->context,id,VDPL_WRITE,0,VDPL_WHOLE_BUFFER,&view);if(rc)return rc;
if(view.bytes!=310){h->buffer_release(h->context,view.lease);return VDPL_E_BOUNDS;}
uint8_t*state=view.data;put(state+12,0);
unsigned entry=r->entry_id==17?3:r->entry_id;
if(r->entry_id!=17 && get(state+28)!=entry)ROOT_FAIL(7,VDPL_E_ARGUMENT);
'''+header+'''
if(entry!=13 && (!initialized || owner_session!=get32(state+8)))ROOT_FAIL(4,VDPL_E_INIT);
if(poisoned && entry!=13 && entry!=16)ROOT_FAIL(4,VDPL_E_INIT);
if(entry==13){import_globals(&world,state);owner_session=get32(state+8);initialized=1;poisoned=0;}
world.failure=0;put(state+14,0);
unsigned count=r->entry_id==17?4:1;
for(unsigned i=0;i<count;++i){
 put(state+28,entry);
 rc=native_validate(&world);
 if(!rc){switch(entry){case 3:rc=native_3(&world);break;case 13:rc=native_13(&world);break;case 15:rc=import_overrides(h,&world);if(!rc)rc=native_15(&world);break;case 16:rc=native_16(&world);break;}}
 if(rc){poisoned=1;break;}
 if(entry==3){put32(state+20,get32(state+20)+1u);put(state+24,3);put32(state+32,get32(state+8));}
}
export_globals(state,&world);put(state+14,world.failure);
if(entry==3 || entry==13){int32_t exported=export_arrays(h,&world);if(!rc)rc=exported;}
if(rc)goto done;
if(entry!=3){
 uint32_t next_generation=get32(state+20)+1u,next_request=world.renderRequest;
 rc=renderer_hook(h,entry,state,&world);if(rc)goto done;
 put32(state+20,next_generation);put(state+24,entry);put32(state+32,get32(state+8));
 if(entry==15)rc=r28_check_publication(h,state,next_generation,next_request);
}
done:{int32_t rr=h->buffer_release(h->context,view.lease);return rr?rr:rc;}
}
'''
 top=text[:text.index('static RallyRenderContextV1 renderer')]
 renderer=text[text.index('static RallyRenderContextV1 renderer'):text.index('static int32_t renderer_hook')]
 result=top+define+numeric+renderer+hook+'#include "publication.inc"\n'+export+entry
 (target/'checked.c').write_text(result)
 pins={str(p.relative_to(target)):hashlib.sha256(p.read_bytes()).hexdigest() for p in target.rglob('*') if p.is_file()}
 (HERE/'SOURCE.json').write_text(json.dumps({'baseline':'direct-rows/source/rows','source':pins,
   'authoritative_state':'module-private native typed structures','tables_bytes':562,
   'new_batch_entry':17,'legacy_exports':'boundary only','scalar_physics_acquisitions':0},indent=2)+'\n')
 print('Prepared typed native world, direct array accesses and four-step entry17')

if __name__=='__main__':main()
