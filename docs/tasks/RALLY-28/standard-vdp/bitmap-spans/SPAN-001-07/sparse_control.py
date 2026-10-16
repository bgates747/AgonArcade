import profiles,run
from pathlib import Path
HERE=Path(__file__).resolve().parent
for live,diag,frames,backend in [(0,0,1024,'fab'),(1,0,128,'fab')]:
 name=f'rally28-road-sparse-{live}-control05';profiles.prepare(name,0,live,diag,frames,backend,HERE/'.work/sparse/bin/roadbench.bin');run.run(name,180)
