"""Reproduce meaningful host checks and serializers in fresh directories."""
from pathlib import Path
import gzip,json,subprocess,tempfile
HERE=Path(__file__).resolve().parent;WORK=HERE/'.work';OUT=HERE/'evidence'
VARIANTS=('dense','lookup','lookup-buffer','coarse','coarse-buffer')
if __name__=='__main__':
    checks=[]
    for kind in ('ordinary','sanitized'):
        r=subprocess.run([str(WORK/('checks-'+kind)),str(OUT/'data')],check=True,capture_output=True,text=True)
        checks.append(json.loads(r.stdout))
    assert checks[0]==checks[1]
    with tempfile.TemporaryDirectory(prefix='host-qualification-',dir=WORK) as tmp:
        for name in VARIANTS:
            dirs=[]
            for kind in ('ordinary','sanitized'):
                d=Path(tmp)/name/kind;d.mkdir(parents=True);dirs.append(d)
                with (d/'frames.csv').open('w') as f:subprocess.run([str(WORK/('host-'+name+'-'+kind)),'wire',str(OUT/'data')],cwd=d,stdout=f,check=True)
            for f in dirs[0].iterdir():
                assert f.read_bytes()==(dirs[1]/f.name).read_bytes(),(name,f.name)
                # The saved census is also the independent target-stream reference.
                saved=OUT/'host'/name/(f.name+'.gz')
                plain=saved.with_suffix('')
                if saved.exists():assert f.read_bytes()==gzip.decompress(saved.read_bytes()),(name,f.name,'saved census differs')
                elif plain.exists():assert f.read_bytes()==plain.read_bytes(),(name,f.name,'saved census differs')
    (OUT/'host-checks.json').write_text(json.dumps(checks[0])+'\n')
    subprocess.run([str(HERE.parents[4]/'.venv/bin/python'),str(HERE/'shadow_check.py')],check=True)
    print('Both-track geometry/buffer models and all ten full-scene serializers pass.')
