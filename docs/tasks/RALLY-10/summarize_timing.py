"""Summarize fixed-pose timing evidence without calling submission counts FPS."""
from pathlib import Path
import argparse
import json
import statistics

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('manifest',type=Path)
args=parser.parse_args()
data=json.loads(args.manifest.read_text())
groups={}
for run in data['runs']:
    case=run['case'].split('-',1)[1]
    groups.setdefault(case,[]).append(run)
print('| Case | Batch ticks, including final drain | Mean geometry ticks/frame | Mean bands ticks/frame | Mean submission ticks/frame | Mean fence ticks/frame |')
print('| --- | --- | --- | --- | --- | --- |')
for case,runs in groups.items():
    batches=', '.join(str(r['metadata']['run_ticks']+r['metadata']['drain_ticks']) for r in runs)
    values=[]
    for stage in ('geometry','bands','submit','fence'):
        samples=[r['mean_ticks'][stage] for r in runs if stage in r['mean_ticks']]
        values.append(f'{statistics.mean(samples):.3f}' if samples else 'not sampled')
    print('| '+' | '.join([case,batches,*values])+' |')
print('\nAll batches render 64 fixed poses after two unmeasured warm-up frames.')
print('120 ticks/second; per-frame timer resolution is two ticks. Values include host/emulator scheduling effects.')
print('Baseline drain is counted in batch duration; it is not a per-frame acknowledgment or a display counter.')
