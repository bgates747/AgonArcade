"""Final paired comparison; failures are retained and do not erase other axes."""
from pathlib import Path
import contextlib,io,json
from profile import prepare
from run import run
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
if __name__=='__main__':
    jobs=[('dense',1)]+[(n,0) for n in ('dense','lookup','lookup-buffer','coarse','coarse-buffer')]+[(n,1) for n in ('lookup','lookup-buffer','coarse','coarse-buffer')]
    successful=[]
    for variant,mode in jobs:
        name=f'rally28-{variant}-'+('cpu' if mode==0 else 'live')+'02'
        with contextlib.redirect_stdout(io.StringIO()):prepare(name,variant,mode)
        print('RUN '+name,flush=True);profile=ROOT/'.emulator'/name
        try:
            with contextlib.redirect_stdout(io.StringIO()):run(profile,600,stall_seconds=60 if mode else None)
        except SystemExit:pass
        result=json.loads((profile/'last-run/result.json').read_text());print(json.dumps({'profile':name,'reason':result['reason'],'host_seconds':result['host_seconds'],'summary':result.get('summary')}),flush=True)
        if mode and result['reason']=='guest-files' and result.get('summary',{}).get('frames')=='900':successful.append((900*120/int(result['summary']['mos_units']),variant))
    candidates=[(fps,n) for fps,n in successful if n!='dense']
    if candidates:
        _,variant=max(candidates);name=f'rally28-{variant}-shadow02'
        with contextlib.redirect_stdout(io.StringIO()):prepare(name,variant,2)
        print('RUN '+name,flush=True);profile=ROOT/'.emulator'/name
        try:
            with contextlib.redirect_stdout(io.StringIO()):run(profile,600,stall_seconds=60)
        except SystemExit:pass
        result=json.loads((profile/'last-run/result.json').read_text());print(json.dumps({'profile':name,'reason':result['reason'],'host_seconds':result['host_seconds'],'summary':result.get('summary')}),flush=True)
