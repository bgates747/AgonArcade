"""Run serial headless timing samples. Graphical launch is reserved for review."""
from pathlib import Path
import argparse
import csv
import hashlib
import io
import json
import os
import platform
import statistics
import subprocess
import sys
import tempfile
import time

ROOT=Path(__file__).resolve().parents[3]/'rally'
CASES=('full-free','full-fence','nosky-fence','notraffic-fence','mirror-fence','light-fence')

def read_report(report):
    content=report.read_text()
    if not content.endswith('# complete\n'):
        raise ValueError('incomplete report')
    lines=content.splitlines()
    metadata={key:int(value) for key,value in
              (item.split('=') for item in lines[0].lstrip('# ').split(','))}
    rows=[{key:int(value) for key,value in row.items()}
          for row in csv.DictReader(io.StringIO('\n'.join(line for line in lines[1:] if not line.startswith('#'))))]
    if len(rows)!=metadata['recorded']: raise ValueError('incomplete rows')
    return metadata,rows

def validate(metadata,rows,workload):
    if metadata['timeout'] or metadata['unrecorded']: raise RuntimeError('timeout or dropped samples')
    if metadata['fenced'] and metadata['acknowledged']!=metadata['submitted']:
        raise RuntimeError('missing frame acknowledgments')
    if workload:
        if metadata['submitted']!=64: raise RuntimeError('incomplete fixed workload')
        if not metadata['light']:
            if [row['pose'] for row in rows]!=list(range(64)): raise RuntimeError('pose sequence mismatch')
            if any(row['cars']!=(0 if metadata['no_traffic'] else 6) for row in rows):
                raise RuntimeError('traffic count mismatch')
            if any(row['mirrored']!=metadata['mirror'] for row in rows):
                raise RuntimeError('player reflection mismatch')
    for row in rows:
        if row['projection']!=row['geometry']+row['bands']: raise RuntimeError('stage totals mismatch')

def run_case(output,label,track,workload=None,fenced=False,fixed_bands=False):
    profile=output/label
    prepare=[sys.executable,str(ROOT/'tools/prepare_emulator.py'),'--profile',str(profile),'--track',track]
    prepare+=['--workload',workload] if workload else ['--bench']
    if fenced: prepare.append('--fence')
    if fixed_bands: prepare.append('--fixed-bands')
    subprocess.run(prepare,check=True,stdout=subprocess.DEVNULL)
    report=profile/'sdcard/rally'/('timing-fence.csv' if fenced else 'timing-free.csv')
    env=os.environ.copy()
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
    for variable in ('BASH_ENV','DYLD_INSERT_LIBRARIES','LD_PRELOAD'):
        env.pop(variable,None)
    begin=time.monotonic();load_before=os.getloadavg()
    with (profile/'bench.log').open('w') as log:
        process=subprocess.Popen(['./fab-agon-emulator','--renderer','sw'],cwd=profile,
                                 env=env,stdout=log,stderr=subprocess.STDOUT)
        try:
            while time.monotonic()-begin<120:
                try:
                    metadata,rows=read_report(report)
                    time.sleep(.5)
                    break
                except (OSError,ValueError,TypeError,KeyError,IndexError): pass
                if process.poll() is not None:
                    raise RuntimeError(f'{label} exited before a complete report; see {profile}/bench.log')
                time.sleep(.2)
            else: raise RuntimeError(f'{label}: no complete report in 120 seconds')
        finally:
            process.terminate()
            try: process.wait(timeout=5)
            except subprocess.TimeoutExpired: process.kill();process.wait()
    validate(metadata,rows,workload)
    if metadata.get('fixed_bands',0)!=int(fixed_bands): raise RuntimeError('band mode mismatch')
    result={'case':label,'metadata':metadata,'wall_seconds_including_startup_and_report':time.monotonic()-begin,
            'load_before':load_before,'load_after':os.getloadavg()}
    result['mean_ticks']={key:statistics.mean(row[key] for row in rows)
                          for key in ('physics','geometry','bands','submit','fence')} if rows else {}
    (output/f'{label}.csv').write_bytes(report.read_bytes())
    print(label, 'batch ticks',metadata['run_ticks']+metadata['drain_ticks'],
          'mean stages',result['mean_ticks'],flush=True)
    return result

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--reverse',action='store_true')
    parser.add_argument('--track',choices=('oval','fuji'),default='oval')
    parser.add_argument('--workloads',action='store_true',help='Use fixed 64-pose fixtures')
    parser.add_argument('--cases',nargs='+',choices=CASES,default=CASES)
    parser.add_argument('--passes',type=int,choices=(1,2,3,4),default=1)
    args=parser.parse_args()
    base=ROOT/'.emulator/benchmarks';base.mkdir(parents=True,exist_ok=True)
    output=Path(tempfile.mkdtemp(prefix='workloads-' if args.workloads else 'pair-',dir=base))
    runtime=Path.home()/'Agon/fab-agon-emulator'
    files=[ROOT/'bin/rally.bin',ROOT/'src/main.cpp',ROOT/'include/road.hpp',ROOT/'include/workload.hpp',
           runtime/'fab-agon-emulator',runtime/'firmware/vdp_platform.so',runtime/'firmware/mos_platform.bin']
    manifest={'host':platform.platform(),'track':args.track,'headless':True,'renderer':'sw',
              'identities':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files},'runs':[]}
    print(f'Evidence: {output}',flush=True)
    for repeat in range(args.passes):
        cases=list(args.cases if args.workloads else ('full-free','full-fence'))
        if bool(repeat%2)!=args.reverse: cases.reverse()
        for case in cases:
            workload,mode=case.rsplit('-',1)
            result=run_case(output,f'{repeat+1:02d}-{case}',args.track,
                            workload if args.workloads else None,mode=='fence')
            manifest['runs'].append(result)
            (output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    if args.workloads:
        keys=('pose_hash','road_bytes')
        if any(len({run['metadata'][key] for run in manifest['runs']})!=1 for key in keys):
            raise RuntimeError('Workloads did not use identical poses/road bytes')
    print('All workload invariants verified.',flush=True)

if __name__=='__main__': main()
