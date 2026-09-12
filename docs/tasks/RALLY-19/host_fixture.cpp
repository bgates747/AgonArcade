#include "lookup_road.hpp"
#include "fixture_state.hpp"
#include <cstdio>
#include <cstring>
int main(int argc,char **argv){
 if(argc!=4)return 2;
 rally::Motion motion;rally::Traffic traffic;rally::LookupRoad road;rally::SceneryHistory history;
 const auto *track=strcmp(argv[1],"fuji")==0?&rally::Fuji:&rally::TriOval;
 motion.track=road.track=track;road.init();traffic.init(0,track->length*100);
 if(!road.load(argv[2])||!rally::r19::loadFixture(argv[3],motion,traffic))return 3;
 volatile rally::r18::SceneState scene{};history.swapped();
 for(int i=0;i<2;++i){rally::r18::prepareScene(motion,traffic,road,history,scene,false);history.swapped();}
 printf("%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\r\n",long(scene.skyOffset),long(scene.skyDelta),long(scene.skyLeft),long(scene.skyRight),long(scene.skyRepaint),long(scene.playerBitmap),long(scene.playerMirror),long(scene.playerX),long(scene.cars));
 for(unsigned i=0;i<road.boundaryCount;++i)printf("R,%u,%ld,%u\r\n",unsigned(road.rows[i]),long(road.centersQ8[i]),unsigned(i<road.bands?road.materials[i]:0));
 for(unsigned i=0;i<scene.cars;++i){volatile const auto &c=scene.traffic[i];printf("C,%d,%d,%d,%d,%d,%d\r\n",c.bitmap,c.scale,c.mirrored,c.x,c.y,c.translation);}
}
