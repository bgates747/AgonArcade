#pragma once
#include "road.hpp"
#include "traffic.hpp"
#include "scenery.hpp"
#include "vehicle.hpp"
namespace rally { namespace r18 {
struct CarState { int bitmap,matrix,scale,xx,translation,x,y;bool mirrored; };
struct SceneState {
    int skyOffset,skyDelta,skyLeft,skyRight;bool skyRepaint;
    int playerBitmap,playerX,playerCentre;bool playerMirror;
    unsigned cars;CarState traffic[TrafficCount];
};
template<class R> void prepareScene(Motion &motion,Traffic &traffic,R &road,
                   SceneryHistory &history,volatile SceneState &out,bool perspective){
    road.project(motion.position,motion.phase,0);
    int32_t p=motion.position/100*256+(motion.position%100)*256/100;
    auto heading=trackSample(p,*motion.track);
    int offset=sceneryHeading(heading.tx,heading.ty);
    auto update=history.prepare(offset);
    out.skyOffset=offset;out.skyDelta=update.delta;out.skyLeft=update.left;
    out.skyRight=update.right;out.skyRepaint=update.repaint;
    int order[TrafficCount];int32_t distance[TrafficCount];
    const int32_t lap=motion.track->length*100;
    for(int i=0;i<TrafficCount;++i){order[i]=i;distance[i]=Traffic::ahead(traffic.cars[i].position,motion.position,lap);}
    for(int i=0;i<TrafficCount-1;++i)for(int j=i+1;j<TrafficCount;++j)
        if(distance[order[i]]<distance[order[j]]){int t=order[i];order[i]=order[j];order[j]=t;}
    auto camera=trackSample(motion.position/100*256,*motion.track);
    unsigned visible=0;
    for(int index:order){
        int32_t z=distance[index]/100;if(z<64||z>1100)continue;
        int q=int(8000/z),y=Horizon+q;const auto &car=traffic.cars[index];
        int center=road.centerAt(y)+car.lane*q/CameraHeight;
        int scale=q*2;
        auto h=trackSample(car.position/100*256,*motion.track);
        int32_t cross=(camera.tx*h.ty-camera.ty*h.tx)/4096;
        auto pose=trafficPose(cross,center,perspective);
        volatile auto &c=out.traffic[visible++];
        c.bitmap=(index+1)*5+pose.view;c.matrix=TrafficMatrixBase+index;
        c.scale=scale;c.xx=pose.mirrored?-scale:scale;c.translation=pose.mirrored?101*scale:0;
        c.mirrored=pose.mirrored;c.x=center-51*scale/256;c.y=y-70*scale/256;
    }
    out.cars=visible;
    int centre=playerCenterX(motion,road.centerAt(PlayerContactY));
    auto pose=playerPose(motion.steering,centre,perspective);
    out.playerCentre=centre;out.playerBitmap=pose.view;out.playerMirror=pose.mirrored;
    out.playerX=centre-(pose.mirrored?PlayerMirrorAnchorX:PlayerAnchorX);
}
}}
