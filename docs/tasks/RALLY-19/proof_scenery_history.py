"""Exhaustive host page-history arithmetic and reachable heading witnesses."""
import argparse,json,subprocess
from pathlib import Path
from profile import TASK
from native_run import sha

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    root=TASK/'evidence/golem-scenery-history'/a.name;root.mkdir(parents=True,exist_ok=False)
    work=TASK/'.work/scenery-history-proof'/a.name;work.mkdir(parents=True,exist_ok=False)
    source=TASK/'host_history_proof.cpp';exe=work/'proof'
    command=['g++','-std=c++17','-Wall','-Wextra','-Werror','-O1','-g','-ffp-contract=off','-fsanitize=address,undefined',
             '-I'+str(TASK/'.work/oracle/include'),str(source),'-o',str(exe)]
    with (root/'build.txt').open('w') as log:subprocess.run(command,check=True,stdout=log,stderr=subprocess.STDOUT)
    report=json.loads(subprocess.check_output([str(exe)]));assert report['pass'] and report['history_checks']==4194304
    report['scope']=__doc__;report['build_command']=command
    report['source_hashes']={str(p):sha(p) for p in [Path(__file__),source,*sorted((TASK/'.work/oracle/include').glob('*.hpp'))]}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    print('History host proof:',report['history_checks'],'cases;',[(r['track'],r['bearings']) for r in report['tracks']])

if __name__=='__main__':main()
