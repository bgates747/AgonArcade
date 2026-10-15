"""Sequential headless comparisons; retain every profile and stop on failure."""
from pathlib import Path
import contextlib,io,json
from profile import prepare
from run import run
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
if __name__=='__main__':
    jobs=[(n,0) for n in ('dense','lookup','lookup-buffer','coarse','coarse-buffer')]
    jobs += [(n,1) for n in ('dense','lookup','coarse','coarse-buffer')]
    for variant,mode in jobs:
        name=f'rally28-{variant}-'+('cpu' if mode==0 else 'live')+'01'
        with contextlib.redirect_stdout(io.StringIO()):prepare(name,variant,mode)
        print('RUN '+name,flush=True)
        profile=ROOT/'.emulator'/name
        with contextlib.redirect_stdout(io.StringIO()):run(profile,600)
        result=json.loads((profile/'last-run/result.json').read_text())
        print(json.dumps({'profile':name,'host_seconds':result['host_seconds'],'summary':result['summary']}),flush=True)
