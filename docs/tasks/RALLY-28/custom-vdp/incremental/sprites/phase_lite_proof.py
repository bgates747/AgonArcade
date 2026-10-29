"""Bounded actor-only protocol/decoder failures; host fake clocks, no timing."""
import ctypes as C
import json
from pathlib import Path

from phase_host import SpanRuntime,specification,Request
from phase_lite import decode
from phase_test import HERE,save,sha


def qualify():
    work=HERE/'.work/phase-actor-affine'
    library=work/'phase-host-phase.so'
    cases={}
    class FaultRuntime(SpanRuntime):
        def acquire(self,context,key,access,offset,n,out):
            rc=super().acquire(context,key,access,offset,n,out)
            fault=getattr(self,'log_fault',None)
            if key==50305 and not rc:
                if fault=='partial-error':return 2
                if fault=='null-view':out.contents.data=C.POINTER(C.c_uint8)()
                if fault=='read-view':out.contents.access=1
            return rc
        def release(self,context,lease):
            is_log=lease in self.live and self.live[lease][0]==self.pointer(50305)
            rc=super().release(context,lease)
            return 8 if is_log and getattr(self,'log_fault',None)=='release-error' else rc

    def private(runtime,op,arguments=2,reserved=0):
        request=Request(C.sizeof(Request),2,60000+op,runtime.argument_id,reserved,arguments)
        result=runtime.lib.vdplet_entry(C.byref(runtime.host),C.byref(request))
        assert not runtime.live and runtime.grants==runtime.releases
        runtime.canaries()
        return int(result)

    def prepared(runtime):
        for _ in range(4):assert runtime.invoke('Tick120')==0
        assert runtime.invoke('Render30')==0

    for fault in ('start-before-render','end-before-start','repeated-start','unsupported','arguments',
                  'reserved','missing-log','short-log','read-only-log','partial-error',
                  'null-view','read-view','release-error','capacity'):
        runtime=FaultRuntime(specification(work/'package'),library)
        runtime.install(50305,bytes(1551 if fault=='short-log' else 1552),1 if fault=='read-only-log' else 3)
        assert runtime.invoke('InitRace')==0
        if fault=='start-before-render':rc=private(runtime,0)
        elif fault=='unsupported':rc=private(runtime,2)
        elif fault=='arguments':rc=private(runtime,0,1)
        elif fault=='reserved':rc=private(runtime,0,reserved=1)
        elif fault=='capacity':
            for _ in range(128):
                prepared(runtime);assert private(runtime,0)==private(runtime,1)==0
            prepared(runtime);rc=private(runtime,0)
        else:
            prepared(runtime)
            if fault=='end-before-start':rc=private(runtime,1)
            else:
                assert private(runtime,0)==0
                if fault=='repeated-start':rc=private(runtime,0)
                else:
                    if fault=='missing-log':
                        for mapping in (runtime.buffers,runtime.sizes,runtime.permissions):mapping.pop(50305)
                    runtime.log_fault=fault
                    rc=private(runtime,1)
        assert rc!=0,fault
        assert private(runtime,0)==rc,'Private error must remain latched'
        assert not runtime.live and runtime.grants==runtime.releases
        runtime.canaries()
        cases[fault]=rc
    save(HERE/'phase_LITE-PROOF.json',dict(protocol_failures=cases,
        error_latches=True,guards_unchanged=True,all_grants_released=True,
        source_files={p.name:sha(p) for p in (HERE/'phase_lite_proof.py',HERE/'phase_lite.py',HERE/'phase_lite.inc')},
        scope='Actual generated C with host fake counters: protocol/failure evidence only; no timing'))
    print('PASS:14 actor-only protocol, capacity and service-failure cases')


if __name__=='__main__':qualify()
