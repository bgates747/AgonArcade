#pragma once
#include "section_road.hpp"
#include "traffic.hpp"
#include "scenery.hpp"
namespace computation {
struct Car { int32_t bitmap,scale,mirror,x,y,translation; };
struct Scene {
    int32_t skyOffset,skyDelta,skyLeft,skyRight,skyRepaint;
    int32_t playerView,playerMirror,playerX;
    int32_t sectionCount,sectionX[rally::SectionRoad::MaxSections+1];
    int32_t carCount;
    Car cars[rally::TrafficCount];
};
inline void calculate(rally::Motion &motion,rally::Traffic &traffic,
                      rally::SectionRoad &road,rally::SceneryHistory &history,
                      volatile Scene &state) {
    motion.tick(false,false);traffic.tick(motion.track->length*100);
    road.project(motion.position,motion.phase,motion.cameraOffset());
    state.sectionCount=road.bands;
    for(unsigned i=0;i<road.boundaryCount;++i)state.sectionX[i]=road.centersQ8[i]/256;
    int32_t p=motion.position/100*256+(motion.position%100)*256/100;
    auto heading=rally::trackSample(p,*motion.track);
    int offset=rally::sceneryHeading(heading.tx,heading.ty);
    auto update=history.prepare(offset);
    state.skyOffset=offset;state.skyDelta=update.delta;
    state.skyLeft=update.left;state.skyRight=update.right;state.skyRepaint=update.repaint;
    int order[rally::TrafficCount];int32_t distance[rally::TrafficCount];
    const int32_t lap=motion.track->length*100;
    for(int i=0;i<rally::TrafficCount;++i){order[i]=i;distance[i]=rally::Traffic::ahead(traffic.cars[i].position,motion.position,lap);}
    for(int i=0;i<rally::TrafficCount-1;++i)for(int j=i+1;j<rally::TrafficCount;++j)
        if(distance[order[i]]<distance[order[j]]){int t=order[i];order[i]=order[j];order[j]=t;}
    auto camera=rally::trackSample(motion.position/100*256,*motion.track);
    unsigned visible=0;
    for(int index:order){
        int32_t z=distance[index]/100;if(z<64||z>1100)continue;
        int q=int(8000/z),y=rally::Horizon+q;
        const auto &car=traffic.cars[index];
        int center=road.centerAt(y)+car.lane*q/rally::CameraHeight;
        int scale=q*2;
        auto h=rally::trackSample(car.position/100*256,*motion.track);
        int32_t cross=(camera.tx*h.ty-camera.ty*h.tx)/4096;
        int magnitude=int(cross<0?-cross:cross);
        int view=magnitude<264?0:magnitude<787?1:magnitude<1297?2:magnitude<1785?3:4;
        bool mirror=cross>0;
        auto &out=state.cars[visible++];
        out.bitmap=(index+1)*5+view;out.scale=mirror?-scale:scale;
        out.translation=mirror?101*scale:0;out.mirror=mirror;
        out.x=center-51*scale/256;out.y=y-70*scale/256;
    }
    state.carCount=visible;
    state.playerView=motion.view();state.playerMirror=motion.mirrored();state.playerX=motion.carX()-19;
    history.swapped();
}
}
