"""Final v5 shared candidates; unchanged dense v4 control; one owned run at a time."""
from pathlib import Path
import contextlib,io,json
from profile import prepare
from run import run
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
if __name__=='__main__':
    variants=('lookup-buffer','coarse-buffer','lookup','coarse')
    jobs=[(v,0) for v in variants]+[(v,1) for v in ('lookup-buffer','coarse-buffer','lookup','coarse')]+[('lookup-buffer',2)]
    for variant,mode in jobs:
        kind=('cpu','live','shadow')[mode];name=f'rally28-{variant}-{kind}07'
        with contextlib.redirect_stdout(io.StringIO()):prepare(name,variant,mode,'eof-fixed','interp')
        print('RUN '+name,flush=True);profile=ROOT/'.emulator'/name
        try:
            with contextlib.redirect_stdout(io.StringIO()):run(profile,360,stall_seconds=60 if mode else None)
        except SystemExit:pass
        result=json.loads((profile/'last-run/result.json').read_text())
        print(json.dumps({'profile':name,'reason':result['reason'],'window':result.get('host_window_seconds'),'host_suspend_seconds':result.get('host_suspend_seconds'),'summary':result.get('summary')}),flush=True)
