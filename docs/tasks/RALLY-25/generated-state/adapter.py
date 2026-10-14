"""Rally consumer of actual root-v1 interface/array metadata; no new wire schema."""
from pathlib import Path
import json
import struct

FIELDS=dict(magic=0,schema=2,header_bytes=4,root_bytes=6,session=8,interface_status=12,language_status=14,runtime_result=16,
            last_success_generation=20,last_success_entry=24,descriptor_count=26,requested_entry=28,last_success_session=32,
            entry_count=36,globals_bytes=38,contract_tag=44,descriptors=48)
TYPES={'uint16':(2,0,65535),'sint16':(2,-32768,32767),'uint32':(4,0,4294967295),'sint32':(4,-2147483648,2147483647),
       'bool':(2,0,1),'float32':(4,None,None)}
class Rejected(ValueError):pass

def require(ok,message):
    if not ok:raise Rejected(message)
def number(n,lo,hi):return type(n) is int and lo<=n<=hi

def installation(data):
    """Decode only generated CLEAR + WRITE blocks, not arbitrary VDU execution."""
    result={};at=0
    while at<len(data):
        require(data[at:at+3]==b'\x17\x00\xa0' and at+6<=len(data),'installation command')
        id,op=struct.unpack_from('<HB',data,at+3);at+=6
        require(0<id<65535,'installation ID')
        if op==2:result.pop(id,None)
        elif op==0:
            require(at+2<=len(data),'installation length');n=struct.unpack_from('<H',data,at)[0];at+=2
            require(at+n<=len(data),'installation data');result[id]=result.get(id,b'')+data[at:at+n];at+=n
        else:raise Rejected('installation operation')
    return result

class Interface:
    def __init__(self,directory):
        self.directory=Path(directory)
        self.interface=json.loads((self.directory/'interface.json').read_text())
        self.root=json.loads((self.directory/'root.json').read_text())
        self.backends=json.loads((self.directory/'backends.json').read_text())
        self.validate()
        self.images={self.interface['state_buffer']:(self.directory/'state.bin').read_bytes()}
        require(len(self.images[self.interface['state_buffer']])==self.root['root_bytes'],'root image size')
        for a in self.arrays.values():
            p=(self.directory/a['initial_data']).resolve()
            require(p.is_relative_to(self.directory.resolve()),'array image path')
            data=p.read_bytes();require(len(data)==a['bytes'],'array image size')
            self.images[a['buffer']]=b'\x00'*a['offset']+data
        require(installation((self.directory/'common-install.bin').read_bytes())==self.images,'common installation images')
        if self.arrays:
            require(installation((self.directory/'arrays-install.bin').read_bytes())=={a['buffer']:self.images[a['buffer']] for a in self.arrays.values()},'array installation images')
        for kind in ('native','buffered'):
            cleanup=installation((self.directory/(kind+'-cleanup.bin')).read_bytes())
            require(not cleanup,'cleanup only clears')
            # Parse IDs explicitly as CLEAR packets; decoder above alone drops them.
            data=(self.directory/(kind+'-cleanup.bin')).read_bytes()
            require(len(data)%6==0,'cleanup packet count')
            require(all(data[j:j+3]==b'\x17\x00\xa0' and data[j+5]==2 for j in range(0,len(data),6)),'cleanup CLEAR packets')
            cleared={struct.unpack_from('<H',data,j+3)[0] for j in range(0,len(data),6)}
            require(cleared==set(self.backends[kind+'_owned']),'cleanup declared ownership')
            require(not cleared&set(self.images),'cleanup retained storage')
        self.validate_initial_root()

    def validate(self):
        i,r,b=self.interface,self.root,self.backends
        require(i['schema']==r['schema']==1 and r['family']=='R25-G0/root-v1','schema/family')
        require(r['fields']==FIELDS and r['header_bytes']==112 and r['byte_order']=='little' and r['argument_bytes']==2,'root ABI')
        require(number(r['root_bytes'],112,65535) and r['root_bytes']==i['state_bytes']==b['state_bytes'] and r['globals_bytes']==r['root_bytes']-112,'root size')
        require(i['state_buffer']==b['shared_state'] and number(i['state_buffer'],1,65534) and i['state_owner']=='application_shared','root owner/ID')
        require(i['error']['offset']==b['error_offset']==14 and b['root_header_bytes']==112 and b['root_schema']==1,'status layout')
        self.entries={e['name']:e['logical_id'] for e in i['entries']}
        require(len(self.entries)==len(i['entries']) and sorted(self.entries.values())==list(range(len(self.entries))),'entries')
        require(all(e['parameter_bytes']==e['result_bytes']==0 for e in i['entries']),'entry parameters')
        require([d['role'] for d in r['bindings']]==[1,2,3,4],'roles')
        retained={i['state_buffer']};self.bindings={}
        for d in r['bindings']:
            require(number(d['buffer'],0,65534) and number(d['offset'],0,4294967295) and number(d['bytes'],0,4294967295) and d['offset']+d['bytes']<=4294967295,'binding range')
            if d['buffer']:
                require(d['bytes']>0 and d['access']==(3 if d['role']==2 else 1) and d['installed_min_bytes']>=d['offset']+d['bytes'],'binding access/shape')
                require(d['buffer'] not in retained,'binding alias');retained.add(d['buffer']);self.bindings[d['buffer']]=d
            else:require(d['offset']==d['bytes']==d['access']==0,'unbound role')
        self.globals={g['name']:g for g in i['globals']};require(len(self.globals)==len(i['globals']),'global names')
        occupied=set()
        for g in self.globals.values():
            require(g['type'] in TYPES and g['bytes']==TYPES[g['type']][0],'global type')
            require(number(g['offset'],112,r['root_bytes']-g['bytes']),'global range')
            cells=set(range(g['offset'],g['offset']+g['bytes']));require(not occupied&cells,'global overlap');occupied|=cells
        require(len(occupied)==r['globals_bytes'],'global coverage')
        self.arrays={a['name']:a for a in i.get('arrays',[])};require(len(self.arrays)==len(i.get('arrays',[])),'array names')
        for a in self.arrays.values():
            require(a['type'] in ('uint16','sint16','uint32','sint32'),'array type')
            require(a['element_bytes']==TYPES[a['type']][0] and number(a['lower'],-32768,65535) and number(a['upper'],a['lower'],65535),'array type/bounds')
            require(a['count']==a['upper']-a['lower']+1 and a['bytes']==a['count']*a['element_bytes'] and 0<a['bytes']<=65535,'array count/bytes')
            require(number(a['offset'],0,4294967295-a['bytes']) and number(a['buffer'],1,65534) and a['buffer'] not in retained,'array range/ID')
            require(a['access'] in (1,3) and a['owner']=='application_retained','array access/owner')
            require(isinstance(a['initial_data'],str),'array initial image');retained.add(a['buffer'])
        for kind,key in [('native','native_wrappers'),('buffered','buffered_entries')]:
            ids=b[key];owned=b[kind+'_owned']
            require(len(ids)==len(self.entries) and len(set(ids))==len(ids) and set(ids)<=set(owned),'wrapper mapping')
            require(len(set(owned))==len(owned) and all(number(x,1,65534) for x in owned) and not retained&set(owned),'private ownership')
        require(b['native_arguments'] in b['native_owned'],'argument ownership')

    def validate_initial_root(self):
        p=self.images[self.interface['state_buffer']]
        expected={0:(0x4752,2),2:(1,2),4:(112,2),6:(len(p),2),24:(65535,2),26:(4,2),30:(0,2),36:(len(self.entries),2),38:(len(p)-112,2),40:(0,4),44:(0x52323530,4)}
        for off,(value,n) in expected.items():require(int.from_bytes(p[off:off+n],'little')==value,'initial root header')
        require(int.from_bytes(p[8:12],'little')!=0,'initial session')
        for j,d in enumerate(self.root['bindings']):
            require(p[48+j*16:64+j*16]==struct.pack('<HHIIHH',d['role'],d['buffer'],d['offset'],d['bytes'],d['access'],0),'initial descriptors')

    def installed(self):return {id:bytearray(data) for id,data in self.images.items()}
    def get(self,state,name):
        g=self.globals[name];return int.from_bytes(state[g['offset']:g['offset']+g['bytes']],'little',signed=g['type'].startswith('sint'))
    def put(self,state,name,value):
        g=self.globals[name];n,lo,hi=TYPES[g['type']];require(lo is not None and lo<=value<=hi,'host source type range')
        state[g['offset']:g['offset']+n]=value.to_bytes(n,'little',signed=lo<0)
    def array_get(self,arrays,name,index):
        a=self.arrays[name];require(a['lower']<=index<=a['upper'],'host index range');off=a['offset']+(index-a['lower'])*a['element_bytes']
        return int.from_bytes(arrays[a['buffer']][off:off+a['element_bytes']],'little',signed=a['type'].startswith('sint'))
    def array_put(self,arrays,name,index,value):
        a=self.arrays[name];require(a['lower']<=index<=a['upper'],'host index range');n,lo,hi=TYPES[a['type']];require(lo<=value<=hi,'host element range')
        off=a['offset']+(index-a['lower'])*n;arrays[a['buffer']][off:off+n]=value.to_bytes(n,'little',signed=lo<0)
