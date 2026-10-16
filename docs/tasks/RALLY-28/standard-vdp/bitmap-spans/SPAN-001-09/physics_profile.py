from pathlib import Path
import importlib.util,hashlib,json,shutil
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5];script=HERE.parent/'SPAN-001-07/profiles.py';spec=importlib.util.spec_from_file_location('profiles',script);p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
profile=p.prepare('rally28-road-physics-lifecycle02',0,0,0,1,'fab');app=profile/'sdcard/test/arcade/rally28/road'
for f in app.iterdir():f.unlink()
shutil.copyfile(HERE/'.work/physics/bin/physics.bin',app/'physics.bin');(app/'count.txt').write_text('2\n');(profile/'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\nCD /test/arcade/rally28/road\r\nLOAD physics.bin\r\nRUN .\r\n')
identity=json.loads((profile/'identity.json').read_text());names=[n for n in identity['files'] if not n.startswith('sdcard/test/arcade/rally28/road/')]+[str(f.relative_to(profile)) for f in app.iterdir()];identity['files']={n:hashlib.sha256((profile/n).read_bytes()).hexdigest() for n in names};identity['kind']='physics';(profile/'identity.json').write_text(json.dumps(identity,indent=2)+'\n');(profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in identity['files'].items()));print(profile)
