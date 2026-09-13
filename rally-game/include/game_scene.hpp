// RALLY-22: accepted projection with sparse route heading added to traffic yaw.
#pragma once
#include "road.hpp"
#include "traffic.hpp"
#include "scenery.hpp"
#include "vehicle.hpp"
#include "scene.hpp"
#include "race_traffic.hpp"
namespace rally { namespace game {
using r18::CarState;
using r18::SceneState;
template<class R> void prepareGameScene(Motion &motion,Traffic &traffic,const RaceTraffic &routes,R &road,
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
        int yaw=int(r18::headingFromCross(cross))+((index&1)?-1:1)*routes.cars[index].cursor.heading;
        if(perspective)yaw-=r18::viewingBearing(center);
        auto pose=r18::quantizeYaw(yaw);
        volatile auto &c=out.traffic[visible++];
        c.bitmap=(index+1)*5+pose.view;c.matrix=TrafficMatrixBase+index;
        c.scale=scale;c.xx=pose.mirrored?-scale:scale;c.translation=pose.mirrored?101*scale:0;
        c.mirrored=pose.mirrored;c.x=center-51*scale/256;c.y=y-70*scale/256;
    }
    out.cars=visible;
    int centre=r18::playerCenterX(motion,road.centerAt(r18::PlayerContactY));
    auto pose=r18::playerPose(motion.steering,centre,perspective);
    out.playerCentre=centre;out.playerBitmap=pose.view;out.playerMirror=pose.mirrored;
    out.playerX=centre-(pose.mirrored?r18::PlayerMirrorAnchorX:r18::PlayerAnchorX);
}
}}
