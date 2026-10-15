"""Independently verify the diagnostic's actual game state at partial blocks."""
from pathlib import Path
import ctypes,importlib.util,inspect,json,subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4];WORK=HERE/'.work'
def model():
    spec=importlib.util.spec_from_file_location('capacity_reference',HERE.parent/'capacity/reference.py');r=importlib.util.module_from_spec(spec);spec.loader.exec_module(r)
    namespace=dict(r.__dict__);text=inspect.getsource(r.simulate).replace('def simulate(which):','def simulate(which, steps=1024):').replace('range(1024)','range(steps)').replace('3 if which==2 else 6,1024,elapsed','3 if which==2 else 6,steps,elapsed')
    exec(compile(text,'<partial-independent-reference>','exec'),namespace);return namespace['simulate']
if __name__=='__main__':
    stub=WORK/'shadow_stub.cpp';stub.write_text('#include <agon/mos.h>\n#include <cassert>\nSYSVAR hostVars{};volatile SYSVAR *sys_vars=&hostVars;\nextern "C" void mos_puts(const char*,uint24_t,char){assert(false);}\n')
    subprocess.run(['c++','-std=c++17','-O2','-fPIC','-shared','-include',str(WORK/'hostprefix.hpp'),'-I'+str(WORK/'hostinclude'),'-I'+str(WORK/'include'),'-I'+str(ROOT/'rally-game/include'),'-I'+str(ROOT/'rally-production/include'),str(HERE/'src/physics.cpp'),str(stub),'-o',str(WORK/'shadow.so')],check=True)
    lib=ctypes.CDLL(str(WORK/'shadow.so'));lib.shadow_snapshot.argtypes=[ctypes.POINTER(ctypes.c_uint32)]
    reference=model();fields=cases=0
    for scenario in range(4):
        for prefix in (1,2,4,64,150,151,255,600,1024):
            lib.shadow_init()
            for i in range(scenario*1024+prefix):lib.shadow_step()
            out=(ctypes.c_uint32*105)();lib.shadow_snapshot(out);expected,_=reference(scenario,prefix)
            assert list(out)==expected,(scenario,prefix,[(i,a,b) for i,(a,b) in enumerate(zip(out,expected)) if a!=b])
            fields+=105;cases+=1
    report={'partial_cases':cases,'independent_fields_checked':fields,'all_pass':True}
    (HERE/'evidence/shadow-host.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
