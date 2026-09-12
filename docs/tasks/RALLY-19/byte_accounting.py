"""Run exact accepted draw control flow with command-length host substitutes.

This is static/procedural byte accounting, not UART instrumentation or timing.
Function bodies are extracted unchanged; libvdp packet lengths are separately
grounded in its source and packed eZ80 command types. Native road byte totals
must match before the other totals are accepted.
"""
from pathlib import Path
import subprocess,json,hashlib,csv,io
TASK=Path(__file__).resolve().parent
SOURCE=TASK/'.work/oracle/src/main.cpp'
def function(source,name):
    import re
    match=re.search(r'^(?:void|unsigned) '+name+r'\(',source,re.M)
    if not match:raise ValueError(name)
    opening=source.index('{',match.start());depth=1;end=opening+1
    while depth:
        depth+=(source[end]=='{')-(source[end]=='}');end+=1
    return source[match.start():end]+'\n'
def main():
    source=SOURCE.read_text();work=TASK/'.work';generated=work/'byte_accounting.cpp'
    prelude='''#include "lookup_road.hpp"
#include "scene.hpp"
#include "task_workload.hpp"
#include <cstdio>
#include <cstring>
unsigned wire=0;
void mos_puts(char*,unsigned size,int){wire+=size;}
void vdp_select_bitmap(int){wire+=4;}
void vdp_adv_use_affine_matrix(int,int){wire+=6;}
void vdp_draw_bitmap(int,int){wire+=7;}
void vdp_set_graphics_viewport(int,int,int,int){wire+=9;}
void vdp_scroll_screen_extent(int,int,int){wire+=5;}
void vdp_cursor_tab(int,int){wire+=3;}
void vdp_swap(){wire+=3;}
volatile rally::r18::SceneState scene{};
rally::Motion motion;rally::Traffic traffic;rally::LookupRoad road;
rally::Stream stream;rally::SceneryHistory sceneryHistory;
'''
    bodies=''.join(function(source,n) for n in ['trafficMatrix','drawTraffic','drawScenery','text','drawPlayer','drawScene'])
    ending='''int main(int argc,char **argv){
 if(argc!=3)return 2;
 motion.track=road.track=strcmp(argv[1],"fuji")==0?&rally::Fuji:&rally::TriOval;
 road.init();if(!road.load(argv[2]))return 3;traffic.init(0,motion.track->length*100);
 sceneryHistory.swapped();
 printf("pose,road_bytes,scenery_bytes,vehicle_bytes,hud_bytes,swap_bytes,total_bytes\\n");
 for(int pose=-int(rally::WorkloadWarmup);pose<int(rally::WorkloadFrames);++pose){
  rally::r18::pose(pose<0?0:pose,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
  rally::r18::prepareScene(motion,traffic,road,sceneryHistory,scene,false);
  wire=0;drawScene();unsigned total=wire,roadBytes=stream.size;
  wire=0;drawScenery();unsigned sky=wire;
  wire=0;drawTraffic();drawPlayer();unsigned cars=wire;
  wire=0;text(9,28,"TIMING FIXTURE");unsigned hud=wire;
  if(total!=roadBytes+sky+cars+hud+3 || stream.overflow)return 4;
  if(pose>=0)printf("%d,%u,%u,%u,%u,3,%u\\n",pose,roadBytes,sky,cars,hud,total);
  sceneryHistory.swapped();
 }
}
'''
    generated.write_text(prelude+bodies+ending)
    binary=work/'byte_accounting'
    subprocess.run(['g++','-std=c++17','-Wall','-Wextra','-Werror','-fsanitize=address,undefined','-g','-I'+str(TASK/'.work/oracle/include'),str(generated),'-o',str(binary)],check=True)
    baseline=json.loads((TASK/'evidence/baseline/manifest.json').read_text())
    result={'scope':__doc__,'source_sha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(),'tracks':{}}
    lib=Path('/home/smith/Agon/agondev/src/lib/libvdp')
    paths=[lib/(n+'.c') for n in ['vdp_select_bitmap','vdp_adv_use_affine_matrix','vdp_draw_bitmap','vdp_set_graphics_viewport','vdp_scroll_screen_extent','vdp_cursor_tab','vdp_swap']]
    paths+=[Path('/home/smith/Agon/agondev/release/include/agon/vdp.h')]
    result['libvdp_sources']={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    for track in ['oval','fuji']:
        data=subprocess.check_output([str(binary),track,str(TASK.parent/'RALLY-18/data'/(track+'.road'))]).decode()
        (TASK/'evidence/baseline'/(track+'-bytes.csv')).write_text(data)
        rows=list(csv.DictReader(io.StringIO(data)));assert len(rows)==64
        totals={key:sum(int(row[key]) for row in rows) for key in rows[0] if key!='pose'}
        for run in baseline['runs']:
            if run['track']==track and run['mode']=='submit':assert run['data']['road_bytes']==totals['road_bytes']
        result['tracks'][track]={'batch_bytes':totals,'mean_bytes':{k:v/64 for k,v in totals.items()}}
    (TASK/'evidence/baseline/byte-accounting.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result['tracks'],indent=2))
if __name__=='__main__':main()
