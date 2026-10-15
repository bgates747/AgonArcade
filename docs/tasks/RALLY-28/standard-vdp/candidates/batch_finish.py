"""Bounded v5 comparisons under a task-local sleep inhibitor, fresh08 profiles."""
from pathlib import Path
import contextlib,hashlib,io,json,os,subprocess
from profile import prepare
from run import run
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
if __name__=='__main__':
    assert os.getuid()!=0,'Run the applications as the project owner'
    expected=json.loads((HERE/'.work/build-v5.json').read_text())['variants']
    for v,r in expected.items():assert hashlib.sha256((HERE/'.work'/v/'bin/candidate.bin').read_bytes()).hexdigest()==r['sha256']
    inhibitors=subprocess.check_output(['systemd-inhibit','--list','--no-pager'],text=True)
    assert 'Rally' in inhibitors and 'sleep:idle' in inhibitors
    (HERE/'.work/campaign08-inhibitors.txt').write_text(inhibitors)
    jobs=[(v,0) for v in ('lookup-buffer','coarse-buffer','lookup','coarse')]
    jobs += [(v,1) for v in ('lookup-buffer','coarse-buffer','dense','lookup','coarse')]
    jobs += [('lookup-buffer',2)]
    for variant,mode in jobs:
        kind=('cpu','live','shadow')[mode];name=f'rally28-{variant}-{kind}08'
        with contextlib.redirect_stdout(io.StringIO()):prepare(name,variant,mode,'eof-fixed','interp')
        print('RUN '+name,flush=True);profile=ROOT/'.emulator'/name
        try:
            with contextlib.redirect_stdout(io.StringIO()):run(profile,360,stall_seconds=60 if mode else None)
        except SystemExit:pass
        result=json.loads((profile/'last-run/result.json').read_text())
        print(json.dumps({'profile':name,'reason':result['reason'],'window':result.get('host_window_seconds'),'host_suspend_seconds':result.get('host_suspend_seconds'),'summary':result.get('summary')}),flush=True)
