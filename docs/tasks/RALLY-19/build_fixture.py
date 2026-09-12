"""Add only file-fed snapshot state to the byte-identical reviewed oracle."""
from pathlib import Path
import hashlib,json,shutil,subprocess
TASK=Path(__file__).resolve().parent
ROOT=TASK/'.work/fixture'
if ROOT.exists():raise RuntimeError('Existing fixture build: inspect before rebuilding')
shutil.copytree(TASK/'.work/oracle',ROOT,ignore=shutil.ignore_patterns('obj','bin'))
shutil.copy2(TASK/'fixture_state.hpp',ROOT/'include/fixture_state.hpp')
src=ROOT/'src/main.cpp';s=src.read_text()
anchor='        motion.lateral=snapshotLateral*256L;motion.steering=snapshotSteering;'
# The original diagnostic include is expanded in generated main.cpp.
if anchor not in s:anchor='        motion.lateral=snapshotLateral*256L;motion.steering=snapshotSteering;'
assert s.count(anchor)==1
s='#include "fixture_state.hpp"\n'+s
s=s.replace(anchor,anchor+'\n        if(!rally::r19::loadFixture("pose.dat",motion,traffic))return 31;')
src.write_text(s)
with (TASK/'evidence/fixture-build.txt').open('w') as log:
    subprocess.run(['make','-B'],cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,check=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
(TASK/'evidence/fixture-build.json').write_text(json.dumps({'oracle_sha256':sha(TASK/'.work/oracle/bin/rally.bin'),'fixture_sha256':sha(ROOT/'bin/rally.bin'),'fixture_source_sha256':sha(src),'input_loader_sha256':sha(TASK/'fixture_state.hpp'),'change':'Snapshot mode loads validated 17-word pose input; original renderer/physics and other launch paths unchanged.'},indent=2)+'\n')
print('Fixture binary:',sha(ROOT/'bin/rally.bin'))
