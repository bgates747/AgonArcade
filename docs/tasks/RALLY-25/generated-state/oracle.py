"""Independent expectations for the authored fixture; no compiler AST/emitter/model imports."""
import struct
from adapter import TYPES
class Fault(Exception):
    def __init__(self,code):self.code=code

def expected(spec,root,arrays,entry):
    root=bytearray(root);arrays={k:bytearray(v) for k,v in arrays.items()}
    def get(name):return spec.get(root,name)
    def set_(name,value):
        type_=spec.globals[name]['type'];_,lo,hi=TYPES[type_]
        if not lo<=value<=hi:raise Fault(32)
        if name=='boundedStation' and not 0<=value<=3276799:raise Fault(32)
        if name=='boundedLateral' and not -38400<=value<=38400:raise Fault(32)
        spec.put(root,name,value)
    def checked(value,type_,code):
        _,lo,hi=TYPES[type_]
        if not lo<=value<=hi:raise Fault(code)
        return value
    def index(name,n):
        # Explicit source-declared logical limits, not candidate bound interpretation.
        last={'stations':5,'laterals':5,'headings':5,'active':5,'routes':23,'sine':256}[name]
        if not 0<=n<=last:raise Fault(5)
        return n
    def read_array(name,n):return spec.array_get(arrays,name,index(name,n))
    def write_array(name,n,value):spec.array_put(arrays,name,index(name,n),value)
    struct.pack_into('<HH',root,12,0,0);error=0
    try:
        if entry=='InitRace':set_('running',1)
        elif entry=='StopRace':set_('running',0)
        elif entry=='ResetRace':
            set_('running',1)
            for j in range(6):
                set_('slot',j)
                for a,g in [('stations','inputStation'),('laterals','inputLateral'),('headings','inputHeading'),('active','inputActive')]:write_array(a,j,get(g))
        elif entry=='Tick120':set_('worldTick',checked(get('worldTick')+1,'uint32',1))
        elif entry=='Render30':
            for a,g in [('stations','selectedStation'),('laterals','selectedLateral'),('headings','selectedHeading'),('active','selectedActive')]:set_(g,read_array(a,get('slot')))
        elif entry in ('StoreStation','StoreLateral'):
            set_('priorEffect',checked(get('priorEffect')+1,'uint16',1))
            a,base,delta,type_=('stations','inputStation','increment','uint32') if entry=='StoreStation' else ('laterals','inputLateral','lateralDelta','sint32')
            n=index(a,get('slot')) # before RHS arithmetic
            write_array(a,n,checked(get(base)+get(delta),type_,1))
        elif entry=='StoreNarrow':
            write_array('headings',get('slot'),get('inputHeading'));write_array('active',get('slot'),get('inputActive'))
        elif entry in ('ReadRoute','ReadSine'):set_('selectedTable',read_array('routes' if entry=='ReadRoute' else 'sine',get('tableIndex')))
        elif entry in ('CheckStation','CheckLateral'):set_('boundedStation' if entry=='CheckStation' else 'boundedLateral',get('inputStation' if entry=='CheckStation' else 'inputLateral'))
        elif entry in ('AddUnsigned','SubtractUnsigned','AddSigned','SubtractSigned'):
            signed=entry.endswith('Signed');a,b,dest,type_=('sa','sb','sr','sint32') if signed else ('ua','ub','ur','uint32')
            add=entry.startswith('Add');set_(dest,checked(get(a)+get(b) if add else get(a)-get(b),type_,1 if add else 2))
        elif entry in ('UnsignedToSigned','SignedToUnsigned','NarrowUnsigned','NarrowSigned','SignedToNarrowUnsigned','UnsignedToNarrowSigned'):
            source,dest={'UnsignedToSigned':('ua','sr'),'SignedToUnsigned':('sa','ur'),'NarrowUnsigned':('ua','un'),
                         'NarrowSigned':('sa','sn'),'SignedToNarrowUnsigned':('sa','un'),'UnsignedToNarrowSigned':('ua','sn')}[entry]
            set_(dest,get(source))
        elif entry in ('IdentityUnsigned','IdentitySigned'):
            set_('ur' if entry=='IdentityUnsigned' else 'sr',get('ua' if entry=='IdentityUnsigned' else 'sa'))
        elif entry in ('WidenBefore','WidenAfter'):
            value=get('un')+1
            if entry=='WidenAfter':checked(value,'uint16',1)
            set_('ur',value)
        elif entry.startswith('Compare'):
            signed=entry.endswith('Signed');a,b=(get('sa'),get('sb')) if signed else (get('ua'),get('ub'))
            op=entry[len('Compare'):-len('Signed' if signed else 'Unsigned')]
            set_('comparison',int({'Equal':a==b,'NotEqual':a!=b,'Less':a<b,'Greater':a>b,'LessEqual':a<=b,'GreaterEqual':a>=b}[op]))
        else:raise AssertionError(entry)
    except Fault as e:error=e.code
    if error:struct.pack_into('<H',root,14,error)
    else:
        struct.pack_into('<I',root,20,(struct.unpack_from('<I',root,20)[0]+1)&0xffffffff)
        struct.pack_into('<H',root,24,spec.entries[entry]);root[32:36]=root[8:12]
    return root,arrays,1 if error else 0
