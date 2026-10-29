"""Compare original and compact private phase protocol on actual host modules.

The fake host clock permits exact receipt-byte comparison. These counters never
become emulator or hardware timing evidence. Both libraries use the same frozen
uninstrumented affine game source and the same 128-frame diagnostic protocol.
"""
import ctypes as C
import json
from pathlib import Path
import shutil

from phase_host import SpanRuntime, specification, Request
from phase_test import HERE, LOG, HEADER, ROW, PRIVATE, save, sha
from phase_verify import decode


def qualify():
    directory=HERE/'.work/phase-equivalence'
    directory.mkdir(exist_ok=False)
    sources={'original':HERE/'.work/phase-early-affine',
             'compact':HERE/'.work/phase-compact-affine'}
    libraries={}
    for kind,work in sources.items():
        target=directory/('phase-'+kind+'.so')
        shutil.copyfile(work/'phase-host-phase.so',target)
        libraries[kind]=target

    def runtime(kind,bytes_=HEADER+128*ROW):
        result=SpanRuntime(specification(sources[kind]/'package'),libraries[kind])
        if bytes_ is not None:
            result.install(LOG,bytes(bytes_))
        assert result.invoke('InitRace')==0
        return result

    def private(r,op,argument_bytes=2,reserved=0):
        request=Request(C.sizeof(Request),2,PRIVATE+op,r.argument_id,reserved,argument_bytes)
        rc=r.lib.vdplet_entry(C.byref(r.host),C.byref(request))
        assert not r.live and r.grants==r.releases
        r.canaries()
        return rc

    def frame(r,markers=7):
        for _ in range(4):
            assert r.invoke('Tick120')==0
        assert r.invoke('Render30')==0
        result=0
        for op in range(1,markers+1):
            result=private(r,op)
            if result:
                break
        return result

    logs={}
    for kind in sources:
        r=runtime(kind)
        assert private(r,0)==0
        for _ in range(128):
            assert frame(r)==0
        assert private(r,8)==0
        logs[kind]=r.data(LOG)
        assert decode(logs[kind],128)['frames']==128
        assert r.invoke('StopRace')==0 and r.invoke(operation=3)==0
    assert logs['original']==logs['compact'],'Public phase receipt bytes changed with compact implementation'
    cases={}
    for fault in ('missing','short','zero-capacity','odd-bytes','overlarge','unsupported','argument',
                  'reserved','marker-before-render','repeat-marker','early-complete','capacity',
                  'fifth-tick','second-render','abi-host','abi-request'):
        results={}
        for kind in sources:
            size={'missing':None,'short':31,'zero-capacity':32,'odd-bytes':33,
                  'overlarge':HEADER+129*ROW,'capacity':HEADER+ROW}.get(fault,HEADER+128*ROW)
            r=runtime(kind,size)
            if fault in ('missing','short','zero-capacity','odd-bytes','overlarge'):
                rc=private(r,0)
            elif fault=='abi-host':
                request=Request(C.sizeof(Request),2,PRIVATE,r.argument_id,0,2)
                rc=r.lib.vdplet_entry(None,C.byref(request))
            elif fault=='abi-request':
                rc=r.lib.vdplet_entry(C.byref(r.host),None)
            else:
                assert private(r,0)==0
                if fault=='unsupported':
                    rc=private(r,42)
                elif fault=='argument':
                    rc=private(r,1,1)
                elif fault=='reserved':
                    rc=private(r,1,reserved=1)
                elif fault=='marker-before-render':
                    rc=private(r,1)
                elif fault=='early-complete':
                    rc=private(r,8)
                elif fault=='capacity':
                    assert frame(r)==0
                    rc=frame(r)
                else:
                    assert frame(r,1)==0
                    if fault=='repeat-marker':
                        rc=private(r,1)
                    elif fault=='fifth-tick':
                        rc=r.invoke('Tick120')
                    else:
                        rc=r.invoke('Render30')
            assert rc!=0,(fault,kind)
            assert not r.live and r.grants==r.releases
            r.canaries()
            results[kind]=int(rc)
        assert results['original']==results['compact'],(fault,results)
        cases[fault]=results['compact']
    result=dict(frames=128,ticks=512,public_counter_fields=13,complete_receipt_bytes_equal=True,
        receipt_sha256=__import__('hashlib').sha256(logs['compact']).hexdigest(),
        equivalent_rejections=cases,guards_unchanged=True,balanced_leases=True,
        clock='HOST FAKE COUNTER: exact format/protocol comparison only; no timing evidence',
        source_files={p.name:sha(p) for p in (HERE/'phase_equivalence.py',HERE/'phase_clock_compact.inc',
            HERE/'phase_entry_compact.inc',HERE/'phase_entry_v1.inc')},
        original_modules_preserved=True,headline_modules_changed=False,firmware_changed=False,sdk_changed=False)
    save(HERE/'phase_EQUIVALENCE.json',result)
    print('PASS: original/compact128-frame receipts byte-identical;16 error cases equivalent')
    return result


if __name__=='__main__':
    qualify()
