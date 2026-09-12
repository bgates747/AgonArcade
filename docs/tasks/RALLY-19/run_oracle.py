"""Capture the frozen final-tuning poses serially on stock Linux Fab."""
from pathlib import Path
import argparse,hashlib,json,subprocess,sys
from fixtures import encoded,PLAN,SUPPLEMENT,cases as frozen_cases
from profile import prepare,TASK
import capture
BASE=TASK.parent/'RALLY-18'
OUT=TASK/'evidence/oracle'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def run():
    OUT.mkdir(exist_ok=True)
    host=TASK/'.work/host_fixture'
    subprocess.run(['g++','-std=c++17','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-g','-I'+str(TASK/'.work/fixture/include'),str(TASK/'host_fixture.cpp'),'-o',str(host)],check=True)
    cases=frozen_cases()
    manifest={'plan_sha256':sha(PLAN),'supplement_sha256':sha(SUPPLEMENT),'fixture_binary_sha256':sha(TASK/'.work/fixture/bin/rally.bin'),'scope':'native frozen snapshot images and exact host/guest scene state; excludes timing','scenes':[]}
    for i,case in enumerate(cases):
        out=OUT/case['name'];profile=TASK/'.emulator'/('oracle-'+case['name'])
        done=out/'verified.json'
        if done.exists():
            r=json.loads(done.read_text())
            assert r['input_sha256']==case['input_sha256'] and r['binary_sha256']==manifest['fixture_binary_sha256']
            assert r['image_sha256']==sha(out/'frame-000010.png') and r['scene_sha256']==sha(out/'guest-scene.csv')
        else:
            prepare(profile,TASK/'.work/fixture/bin/rally.bin',case['track']+' snapshot')
            app=profile/'sdcard/rally';(app/'pose.dat').write_bytes(encoded(case))
            assert sha(app/'pose.dat')==case['input_sha256']
            capture.capture(argparse.Namespace(profile=profile,output=out,frames='10',keys='escape:20:26',quit_frame=50,timeout=90,ready_file=app/'ready.viz',expect_file=[app/'scene.csv',app/'exit.viz']))
            expected=subprocess.check_output([str(host),case['track'],str(BASE/'data'/(case['track']+'.road')),str(app/'pose.dat')])
            actual=(out/'guest-scene.csv').read_bytes()
            (out/'host-scene.csv').write_bytes(expected)
            if actual!=expected:raise RuntimeError(f'{case["name"]}: host/guest scene differs')
            r={'case':case['name'],'input_sha256':case['input_sha256'],'binary_sha256':manifest['fixture_binary_sha256'],'scene_sha256':sha(out/'guest-scene.csv'),'image_sha256':sha(out/'frame-000010.png'),'host_guest_exact':True}
            done.write_text(json.dumps(r,indent=2)+'\n')
        manifest['scenes'].append(r)
        (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
        print(f'{i+1}/{len(cases)} {case["name"]}: scene exact',flush=True)
if __name__=='__main__':run()
