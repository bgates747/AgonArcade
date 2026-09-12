#include "computation.hpp"
#include "workload.hpp"
#include <cstdio>
#include <cstring>
int main(int argc,char **argv){
    rally::Motion motion;rally::Traffic traffic;rally::SectionRoad road;
    rally::SceneryHistory history;volatile computation::Scene scene{};
    motion.track=road.track=argc>1&&strcmp(argv[1],"fuji")==0?&rally::Fuji:&rally::TriOval;
    road.init();history.swapped();
    for(unsigned i=0;i<rally::WorkloadWarmup;++i){rally::workloadPose(0,motion,traffic,false);computation::calculate(motion,traffic,road,history,scene);}
    for(unsigned pose=0;pose<rally::WorkloadFrames;++pose){rally::workloadPose(pose,motion,traffic,false);computation::calculate(motion,traffic,road,history,scene);}
    printf("%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",(long)scene.skyOffset,(long)scene.skyDelta,(long)scene.skyLeft,(long)scene.skyRight,(long)scene.skyRepaint,(long)scene.playerView,(long)scene.playerMirror,(long)scene.playerX,(long)scene.sectionCount,(long)scene.carCount);
    for(unsigned i=0;i<road.boundaryCount;++i)printf("%ld,%u,%ld\n",(long)scene.sectionX[i],unsigned(road.rows[i]),(long)road.centersQ8[i]);
    for(int i=0;i<scene.carCount;++i){const volatile auto &c=scene.cars[i];printf("%ld,%ld,%ld,%ld,%ld,%ld\n",(long)c.bitmap,(long)c.scale,(long)c.mirror,(long)c.x,(long)c.y,(long)c.translation);}
}
