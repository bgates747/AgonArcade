"""Reuse established helper lifecycle/failure cases for each changed helper."""
import argparse
import ctypes as C
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
from build_candidates import HERE,WORK,VARIANTS

BASE=HERE.parents[4]/'docs/tasks/RALLY-25'


def worker(mode,only=None):
    spec=importlib.util.spec_from_file_location('r25_helper_cases',BASE/'renderer-helper/verify.py')
    old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
    cases=json.loads((BASE/'renderer-prep/scene-cases.json').read_text())['cases']
    sample=next(x for x in cases if x['track']=='fuji' and x['label'].startswith('boundary:') and x['counts'][1]>=2)
    report={}
    for name in VARIANTS:
        if only and name not in only:continue
        lib=C.CDLL(str(WORK/name/('host-sanitized.so' if mode=='sanitized' else 'host.so')))
        lib.rally_render_bind_v1.argtypes=[C.POINTER(old.Host),C.POINTER(old.Context),C.POINTER(old.Bindings),C.POINTER(old.Completion)]
        lib.rally_render_prepare_v1.argtypes=[C.POINTER(old.Host),C.POINTER(old.Context),C.POINTER(old.State),C.POINTER(old.Completion)]
        lib.rally_render_stop_v1.argtypes=[C.POINTER(old.Context),C.POINTER(old.Completion)]
        for f in ('bind','prepare','stop'):getattr(lib,'rally_render_'+f+'_v1').restype=C.c_int32
        report[name]=old.failures(lib,bytes.fromhex(sample['state_hex']))
    target=HERE/('FAILURES-'+mode+'.json')
    if only:
        original=json.loads(target.read_text());original.update(report);report=original
    target.write_text(json.dumps(report,indent=2)+'\n')
    print(mode,report)


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--worker');p.add_argument('--only',nargs='+',choices=list(VARIANTS));a=p.parse_args()
    if a.worker:worker(a.worker,a.only)
    else:
        for mode in ('ordinary','sanitized'):
            env=os.environ.copy()
            if mode=='sanitized':
                env['LD_PRELOAD']=subprocess.check_output(['cc','-print-file-name=libasan.so'],text=True).strip()
                env['ASAN_OPTIONS']='detect_leaks=0:halt_on_error=1';env['UBSAN_OPTIONS']='halt_on_error=1'
            subprocess.run([sys.executable,__file__,'--worker',mode,*(['--only',*a.only] if a.only else [])],env=env,check=True)
