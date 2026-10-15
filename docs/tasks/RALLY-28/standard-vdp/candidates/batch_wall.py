"""Matched stock comparisons with file-witness host timing; one emulator at a time."""
from pathlib import Path
import contextlib,io,json
from profile import prepare
from run import run
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
if __name__=='__main__':
    variants=('lookup-buffer','coarse-buffer','dense','lookup','coarse')
    jobs=[(n,1) for n in variants]+[(n,0) for n in variants]
    passed=[]
    for variant,mode in jobs:
        name=f'rally28-{variant}-'+('cpu' if mode==0 else 'live')+'05'
        with contextlib.redirect_stdout(io.StringIO()):prepare(name,variant,mode,'eof-fixed','interp')
        print('RUN '+name,flush=True);profile=ROOT/'.emulator'/name
        try:
            with contextlib.redirect_stdout(io.StringIO()):run(profile,420,stall_seconds=60 if mode else None)
        except SystemExit:pass
        result=json.loads((profile/'last-run/result.json').read_text());print(json.dumps({'profile':name,'reason':result['reason'],'host_seconds':result['host_seconds'],'host_window_seconds':result['host_window_seconds'],'summary':result.get('summary')}),flush=True)
        if mode and result['reason']=='guest-files' and result.get('summary',{}).get('frames')=='900' and result['summary']['failure']=='none':passed.append((900/result['host_window_seconds'],variant))
    if passed:
        _,variant=max((p for p in passed if p[1]!='dense'),default=max(passed));name=f'rally28-{variant}-shadow05'
        if variant!='dense':
            with contextlib.redirect_stdout(io.StringIO()):prepare(name,variant,2,'eof-fixed','interp')
            print('RUN '+name,flush=True);profile=ROOT/'.emulator'/name
            try:
                with contextlib.redirect_stdout(io.StringIO()):run(profile,420,stall_seconds=60)
            except SystemExit:pass
            result=json.loads((profile/'last-run/result.json').read_text());print(json.dumps({'profile':name,'reason':result['reason'],'host_seconds':result['host_seconds'],'host_window_seconds':result['host_window_seconds'],'summary':result.get('summary')}),flush=True)
