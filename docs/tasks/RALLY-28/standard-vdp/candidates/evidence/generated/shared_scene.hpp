#pragma once
#include "projection.hpp"
#include "game_scene.hpp"
#include "signs.hpp"
namespace rally::r28 {
template<class R> void prepareScene(Motion &motion,Traffic &traffic,const game::RaceTraffic &routes,R &road,
                SceneryHistory &history,volatile r18::SceneState &out,bool perspective) {
    road.project(motion.position,motion.phase,0);
    auto update=history.prepare(road.heading);
    out.skyOffset=road.heading;out.skyDelta=update.delta;out.skyLeft=update.left;out.skyRight=update.right;out.skyRepaint=update.repaint;
    int order[6];int32_t distances[6];const int32_t lap=motion.track->length*100;
    for(int i=0;i<6;++i){order[i]=i;distances[i]=Traffic::ahead(traffic.cars[i].position,motion.position,lap);}
    for(int i=0;i<5;++i)for(int j=i+1;j<6;++j)if(distances[order[i]]<distances[order[j]]){const int t=order[i];order[i]=order[j];order[j]=t;}
    unsigned visible=0;
    for(int index:order) {
        const int32_t z=distances[index]/100;if(z<64||z>1100)continue;
        const int y=R::depthRow(z),q=y-96,scale=q*2;
        const auto &car=traffic.cars[index];const int centre=road.centerAt(y)+car.lane*q/50;
        const auto h=tangentAt(car.position/100*100,*motion.track);
        const int32_t cross=(road.yawCamera.tx*h.ty-road.yawCamera.ty*h.tx)/4096;
        int yaw=int(r18::headingFromCross(cross))+((index&1)?-1:1)*routes.cars[index].cursor.heading;
        if(perspective)yaw-=r18::viewingBearing(centre);const auto pose=r18::quantizeYaw(yaw);
        volatile auto &c=out.traffic[visible++];c.bitmap=(index+1)*5+pose.view;c.matrix=TrafficMatrixBase+index;
        c.scale=scale;c.xx=pose.mirrored?-scale:scale;c.translation=pose.mirrored?101*scale:0;c.mirrored=pose.mirrored;
        c.x=centre-51*scale/256;c.y=y-70*scale/256;
    }
    out.cars=visible;
    // |lateral|<=38400; multiply by118<=4531200 fits signed ADL24.
    const int centre=road.centerAt(214)+int(motion.lateral)*118/12800;
    const auto pose=r18::playerPose(motion.steering,centre,perspective);
    out.playerCentre=centre;out.playerBitmap=pose.view;out.playerMirror=pose.mirrored;
    out.playerX=centre-(pose.mirrored?50:51);
}
struct SharedSigns:game::Billboards {
    const TrackDef *owner=nullptr;unsigned total=0;
    int32_t station[68]={},threshold[68]={};
    template<class R> void prepare(const Motion &motion,const R &road) {
        const int32_t lap=motion.track->length*100;
        if(owner!=motion.track) {
            owner=motion.track;total=unsigned(lap/48000);
            for(unsigned i=0;i<total;++i){station[i]=game::wrap(int32_t(i)*lap/total+24000,lap);threshold[i]=(int32_t(i)*lap+total-1)/total;}
        }
        count=0;unsigned lo=0,hi=total;
        while(lo+1<hi){const unsigned mid=(lo+hi)/2;if(motion.position>=threshold[mid])lo=mid;else hi=mid;}
        const int near=int(lo);
        for(int offset=-1;offset<=2;++offset) {
            int index=near+offset;if(index<0)index+=int(total);if(index>=int(total))index-=int(total);
            const int32_t z=Traffic::ahead(station[index],motion.position,lap)/100;if(z<64||z>500)continue;
            const int ground=R::depthRow(z),q=ground-96,scale=q*2,y=ground-64*scale/256;
            if(y<104||ground>223)continue;
            const int side=(index&1)?-1:1,x=road.centerAt(ground)+side*134*q/50-32*scale/256;
            if(x>=320||x+64*scale/256<=0)continue;
            if(count<2)visible[count++]={x,y,scale,game::SignBitmapBase+unsigned(index%8)};
        }
        if(count==2 && visible[0].scale>visible[1].scale){const auto t=visible[0];visible[0]=visible[1];visible[1]=t;}
    }
};
}
