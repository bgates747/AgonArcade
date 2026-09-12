"""Replay archived Mac fixed-pose benchmarks using identical guest binaries on Linux."""
from pathlib import Path
import sys, json, hashlib, shutil, platform, subprocess, os
REPO=Path(__file__).resolve().parents[4]
TASK=REPO/'docs/tasks/RALLY-10'
sys.path.insert(0,str(TASK))
import timing_unlimited as timing
OUT=Path(__file__).resolve().parent/'results-unlimited'
OUT.mkdir(exist_ok=True)
WORK=REPO/'rally/.emulator/benchmarks/linux-comparison-unlimited'
WORK.mkdir(parents=True,exist_ok=True)
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
binaries={sha(p):p for p in Path('/home/smith/Agon/mystuff').glob('rally-mac-build.*/bin/rally.bin')}
runtime=Path.home()/'Agon/mystuff/AgonJukebox/.emulator/runtime/fab-1.2.4'
manifest={'host':platform.platform(),'cpu':subprocess.check_output(['lscpu'],text=True),'headless':True,'cpu_mode':'unlimited (-u; Fab requests 1 GHz)','timing_helper_sha256':sha(Path(__file__).with_name('timing_unlimited.py')),'renderer':'sw','runtime':{str(p):sha(p) for p in [runtime/'fab-agon-emulator',runtime/'firmware/vdp_platform.so',runtime/'firmware/mos_platform.bin']},'runtime_revision':subprocess.check_output(['git','describe','--tags','--always'],cwd=runtime,text=True).strip(),'runs':[]}
suites=[('controlled',TASK/'results/2026-09-11-controlled/manifest.json'),('reflection',TASK/'results/2026-09-11-controlled/reflection-repeat/manifest.json'),('bands',TASK/'results/2026-09-11-bands/manifest.json'),('pavement',TASK/'pavement/results/manifest.json')]
for suite,reference in suites:
    mac=json.loads(reference.read_text())
    for original in mac['runs']:
        m=original['metadata'];variant=original.get('variant')
        digest=mac['variants'][variant]['binary_sha256'] if variant else next(v for k,v in mac['identities'].items() if k.endswith('/bin/rally.bin'))
        root=WORK/digest
        (root/'bin').mkdir(parents=True,exist_ok=True);(root/'tools').mkdir(exist_ok=True)
        shutil.copy2(binaries[digest],root/'bin/rally.bin')
        shutil.copy2(REPO/'rally/tools/prepare_emulator.py',root/'tools/prepare_emulator.py')
        timing.ROOT=root
        workload='nosky' if m['no_sky'] else 'notraffic' if m['no_traffic'] else 'mirror' if m['mirror'] else 'light' if m['light'] else 'full'
        label=suite+'-'+original['case']
        r=timing.run_case(WORK,label,original.get('track',mac.get('track','oval')),workload,bool(m['fenced']),bool(m.get('fixed_bands',0)))
        for key in ('pose_hash','road_bytes','submitted'):
            if r['metadata'][key]!=m[key]: raise RuntimeError(f'{label}: unequal {key}')
        r.update(suite=suite,mac_case=original['case'],reference=str(reference.relative_to(REPO)),binary_sha256=digest,mac_metadata=m,mac_mean_ticks=original.get('mean_ticks',{}))
        manifest['runs'].append(r)
        shutil.copy2(WORK/f'{label}.csv',OUT/f'{label}.csv')
        (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('All 32 matched fixed-pose runs complete; Mac/Linux poses, bytes and counts equal.',flush=True)
