"""Final matched v5 campaign with Author's boost-off host condition; fresh09."""
from pathlib import Path
import contextlib,hashlib,io,json,os,subprocess
from profile import prepare
from run import run
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
if __name__=='__main__':
    assert os.getuid()!=0
    assert Path('/sys/devices/system/cpu/cpufreq/boost').read_text().strip()=='0'
    expected=json.loads((HERE/'.work/build-v5.json').read_text())['variants']
    for v,r in expected.items():assert hashlib.sha256((HERE/'.work'/v/'bin/candidate.bin').read_bytes()).hexdigest()==r['sha256']
    inhibitors=subprocess.check_output(['systemd-inhibit','--list','--no-pager'],text=True)
    assert 'Rally' in inhibitors and 'sleep:idle' in inhibitors
    (HERE/'.work/campaign09-inhibitors.txt').write_text(inhibitors)
    variants=('lookup-buffer','coarse-buffer','lookup','coarse','dense')
    jobs=[(v,0) for v in variants]+[(v,1) for v in variants]+[('lookup-buffer',2)]
    for variant,mode in jobs:
        kind=('cpu','live','shadow')[mode];name=f'rally28-{variant}-{kind}09'
        with contextlib.redirect_stdout(io.StringIO()):prepare(name,variant,mode,'eof-fixed','interp')
        print('RUN '+name,flush=True);profile=ROOT/'.emulator'/name
        try:
            with contextlib.redirect_stdout(io.StringIO()):run(profile,360,stall_seconds=60 if mode else None)
        except SystemExit:pass
        result=json.loads((profile/'last-run/result.json').read_text())
        print(json.dumps({'profile':name,'reason':result['reason'],'window':result.get('host_window_seconds'),'host_suspend_seconds':result.get('host_suspend_seconds'),'summary':result.get('summary')}),flush=True)
        if result['reason']=='cpu-boost-enabled':break
