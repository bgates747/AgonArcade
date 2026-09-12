"""Sanitized host checks of actual checked frontend loader with fake SDK output."""
import argparse,json,os,shutil,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--build',required=True);a=p.parse_args()
    work=TASK/'.work/frontend'/a.build;build=json.loads((work/'manifest.json').read_text())
    for path,digest in {**build['source_hashes'],**build['outputs']}.items():assert sha(Path(path))==digest,path
    root=TASK/'evidence/golem-loader'/a.name;root.mkdir(parents=True,exist_ok=False)
    run=TASK/'.work/loader'/a.name;run.mkdir(parents=True,exist_ok=False)
    shutil.copytree(work/'include',run/'include');(run/'include/agon').mkdir()
    for name in ['mos.h','vdp.h']:(run/'include/agon'/name).write_text('#pragma once\n// SDK calls defined by the test translation unit.\n')
    for track in ['oval','fuji']:
        for ext in ['.vdp','.clr']:shutil.copy2(work/(track+ext),run/(track+ext))
    source=TASK/'test_loader.cpp';shutil.copy2(source,root/source.name)
    command=['g++','-std=c++17','-O1','-g','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-fno-omit-frame-pointer','-I'+str(run/'include'),str(root/source.name),'-o',str(run/'test')]
    with (root/'build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    env=dict(os.environ,ASAN_OPTIONS='detect_leaks=1:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1')
    with (root/'run.txt').open('w') as log:subprocess.run([str(run/'test')],cwd=run,env=env,check=True,stdout=log,stderr=subprocess.STDOUT)
    report={'pass':True,'scope':__doc__,'build':build,'command':command,'source_sha256':sha(source),'test_sha256':sha(run/'test'),'result':(root/'run.txt').read_text()}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n');print(report['result'])
if __name__=='__main__':main()
