"""Stop only this campaign's owned frontends after sustained UART inactivity."""
from pathlib import Path
import json,os,signal,time
ROOT=Path(__file__).resolve().parents[5]
if __name__=='__main__':
    names=[f'rally28-{v}-{k}05' for v in ('dense','lookup','lookup-buffer','coarse','coarse-buffer') for k in ('live','shadow')]
    until=time.monotonic()+1800
    while time.monotonic()<until:
        for name in names:
            p=(ROOT/'.emulator'/name).resolve();art=p/'last-run';trace=art/'mos-to-vdp.bin'
            if not trace.exists() or (art/'result.json').exists() or (art/'external-stop.json').exists():continue
            age=time.time()-trace.stat().st_mtime
            if age<120:continue
            for q in Path('/proc').glob('[0-9]*'):
                try:
                    if (q/'exe').resolve()==p/'flexe-agon-emulator.bin':
                        os.kill(int(q.name),signal.SIGTERM)
                        (art/'external-stop.json').write_text(json.dumps({'reason':'sustained-uart-inactivity','seconds_since_trace_progress':age,'pid':int(q.name),'profile':name})+'\n')
                        print(name+' stopped after UART inactivity',flush=True)
                except OSError:pass
        if all((ROOT/'.emulator'/f'rally28-{v}-cpu05/last-run/result.json').exists() for v in ('dense','lookup','lookup-buffer','coarse','coarse-buffer')):
            # The batch may still start its one shadow case; cover its full window.
            until=min(until,time.monotonic()+430)
        time.sleep(1)
