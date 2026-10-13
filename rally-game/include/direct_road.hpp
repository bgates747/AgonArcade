#pragma once
#include "road.hpp"

namespace rally {
// RALLY-27: retain the original Road's live projection and direct PLOT geometry.
// The game keeps its current Motion, player anchor, traffic and rule machinery.
struct DirectRoad : Road {
    int32_t positionQ8=0, offsetQ8=0;
    Sample camera={0,0,4096,0};

    void project(int32_t position,int32_t phase,int32_t cameraOffset=0) {
        positionQ8=(position/100)*256+(position%100)*256/100;
        offsetQ8=cameraOffset;
        camera=trackSample(positionQ8,*track);
        Road::project(position,phase,cameraOffset);
    }
    int centerAt(int y) const {
        if(y>=RoadTop && y<=Bottom+1)return int(centers[y]/256);
        const int q=y-Horizon;
        if(q<=0)return 160;
        // Traffic requests row 103; do not read an unprojected centres entry.
        const int32_t depth=(160L*CameraHeight*256)/q;
        const Sample ahead=trackSample(positionQ8+depth,*track);
        const int32_t dx=ahead.x-camera.x,dy=ahead.y-camera.y;
        const int32_t lateral=(-dx*camera.ty+dy*camera.tx)/4096;
        return int((160L*256+(lateral-offsetQ8)*q/CameraHeight)/256);
    }
    template<class Send> void emitTo(Stream &s,Send send,bool fillSky=false) {
        s.size=0;s.overflow=false;bands=0;
        if(fillSky)s.rect(0,0,319,RoadTop-1,4);
        s.rect(0,RoadTop,319,Bottom,2);
        for(int y=RoadTop;y<=Bottom;) {
            // At most five 27-byte quads per band. Flush only between bands;
            // arbitrary curvature cannot exceed the fixed stream allocation.
            if(s.size+155>sizeof(s.data)) {send(s.data,s.size);s.size=0;}
            const int end=bandEnd(y);
            strip(s,y,end+1,-KerbOuterWidth,KerbOuterWidth,paint[y]?9:15);
            strip(s,y,end+1,-RoadHalfWidth,RoadHalfWidth,8);
            strip(s,y,end+1,-86,-84,paint[y]?11:15);
            strip(s,y,end+1,84,86,paint[y]?11:15);
            if(paint[y])strip(s,y,end+1,-2,2,11);
            ++bands;y=end+1;
        }
        if(s.size+15>sizeof(s.data)) {send(s.data,s.size);s.size=0;}
        s.rect(0,Bottom+1,319,239,0);
        if(s.size)send(s.data,s.size);
        s.size=0;
    }
};
}
