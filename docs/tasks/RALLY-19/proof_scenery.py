"""Exhaustive host proof before implementing VDP scenery arithmetic."""
from pathlib import Path
import argparse,hashlib,json,subprocess
from profile import TASK

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    root=TASK/'evidence/golem-scenery-proof'/a.name;root.mkdir(parents=True,exist_ok=False)
    work=TASK/'.work/scenery-proof'/a.name;work.mkdir(parents=True,exist_ok=False)
    source=TASK/'host_scenery_proof.cpp';exe=work/'proof'
    command=['g++','-std=c++17','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-O1','-g','-ffp-contract=off',
             '-fsanitize=address,undefined','-I'+str(TASK/'.work/oracle/include'),str(source),'-o',str(exe)]
    with (root/'build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    data=subprocess.check_output([str(exe)]);report=json.loads(data);assert report['pass']
    paths=[Path(__file__),source,*sorted((TASK/'.work/oracle/include').glob('*.hpp'))]
    report['build_command']=command;report['source_hashes']={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k not in ['source_hashes','build_command']},indent=2))

if __name__=='__main__':main()
