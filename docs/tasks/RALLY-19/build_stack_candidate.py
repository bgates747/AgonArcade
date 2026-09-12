"""Rebuild unchanged production frontend with Golem's explicit call inlining."""
import argparse,hashlib,json,shutil,subprocess
from pathlib import Path
from profile import TASK
from asset_integrity import generate
GOLEM=Path.home()/'Agon/mystuff/golem-rally19'
TARGETS='renderProof, road_projectRow, road_drawSection, vpProcess, vehicleComputeDistance, vpComputeHeading, road_fullRoad, vpProjectAll, vdDrawAll'
def main():
 p=argparse.ArgumentParser();p.add_argument('name');a=p.parse_args()
 parent=TASK/'.work/production/hardware-oval';source=TASK/'.work/frontend/checked-cleanup'
 work=TASK/'.work/production'/a.name;work.mkdir(parents=True,exist_ok=False)
 for d in ['src','include']:shutil.copytree(parent/d,work/d)
 shutil.copy2(parent/'Makefile',work/'Makefile')
 for track in ['oval','fuji']:
  kernels=work/'kernels'/track;shutil.copytree(source/'kernels'/track,kernels)
  golem=kernels/(track+'-scenery-draw.golem');golem.write_text(golem.read_text()+'\nInlineCalls('+TARGETS+');\n')
  subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(golem),str(work/(track+'.vdp'))],check=True)
  shutil.copy2(work/(track+'.vdp.clear'),work/(track+'.clr'))
 generate(work)
 subprocess.run(['make','-C',str(work)],check=True)
 files=[work/'bin/rally.bin',*[work/(t+e) for t in ['oval','fuji'] for e in ['.vdp','.clr']]]
 (work/'hardware-manifest.json').write_text(json.dumps({'parent':str(parent),'targets':TARGETS,'sha256':{str(x.relative_to(work)):hashlib.sha256(x.read_bytes()).hexdigest() for x in files},'unchanged_production_source':(work/'src/main.cpp').read_bytes()==(parent/'src/main.cpp').read_bytes()},indent=2)+'\n')
 print(work)
if __name__=='__main__':main()
