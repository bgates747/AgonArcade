#pragma once
#include "race_traffic.hpp"
namespace rally::game {
constexpr unsigned SignBitmapBase=120,SignMatrix=63930;
struct SignPose {int x,y,scale;unsigned bitmap;};
struct Billboards {
    SignPose visible[2];unsigned count=0;
    template<class Road> void prepare(const Motion &motion,const Road &road) {
        count=0;
        const int32_t lap=motion.track->length*100;
        const int total=int(lap/48000),near=int(motion.position*total/lap);
        for(int offset=-1;offset<=2;++offset) {
            const int index=(near+offset+total)%total;
            const int32_t station=wrap(int32_t(index)*lap/total+24000,lap);
            const int32_t z=Traffic::ahead(station,motion.position,lap)/100;
            if(z<64 || z>500)continue;
            const int q=int(8000/z),ground=Horizon+q,scale=q*2;
            const int y=ground-64*scale/256;
            // Only road-refreshed pixels; signs can never dirty retained sky.
            if(y<RoadTop || ground>Bottom)continue;
            const int side=(index&1)?-1:1;
            const int x=road.centerAt(ground)+side*134*q/CameraHeight-32*scale/256;
            if(x>=320 || x+64*scale/256<=0)continue;
            if(count<2)visible[count++]={x,y,scale,SignBitmapBase+unsigned(index%8)};
        }
        if(count==2 && visible[0].scale>visible[1].scale) {
            const auto temp=visible[0];visible[0]=visible[1];visible[1]=temp;
        }
    }
};
}
