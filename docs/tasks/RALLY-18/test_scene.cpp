#include "section_road.hpp"
#include "scene.hpp"
#include "task_workload.hpp"
#include <cassert>
#include <cstring>
#include <cstdio>
#include <initializer_list>
int main(){
    unsigned comparisons=0;
    for(const rally::TrackDef *track:{&rally::TriOval,&rally::Fuji}){
        rally::Motion motion;rally::Traffic traffic;rally::SectionRoad road;rally::SceneryHistory sky;
        volatile rally::r18::SceneState scene{};motion.track=road.track=track;road.init();
        for(unsigned pose=0;pose<64;++pose){
            rally::r18::pose(pose,motion,traffic);rally::r18::prepareScene(motion,traffic,road,sky,scene,false);
            assert(scene.cars==6);
            int32_t centers[rally::SectionRoad::MaxSections+1];uint8_t rows[rally::SectionRoad::MaxSections+1];
            unsigned count=road.boundaryCount;memcpy(centers,road.centersQ8,sizeof centers);memcpy(rows,road.rows,sizeof rows);
            int expected=road.centerAt(rally::r18::PlayerContactY)+int(motion.lateral*rally::r18::PlayerProjectionQ/(50L*256));assert(scene.playerCentre==expected);
            for(int side:{-94,-78,0,78,94}){
                motion.lateral=side*256L;motion.steering=side<0?-21:21;
                rally::r18::prepareScene(motion,traffic,road,sky,scene,true);
                assert(road.boundaryCount==count);
                for(unsigned i=0;i<count;++i){assert(centers[i]==road.centersQ8[i]);assert(rows[i]==road.rows[i]);}
                assert(scene.playerBitmap<=4);assert(scene.cars==6);++comparisons;
            }
        }
    }
    printf("Camera invariance and scene placement: %u comparisons passed\n",comparisons);
}
