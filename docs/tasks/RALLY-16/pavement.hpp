#pragma once
#include "road.hpp"

namespace rally {
// Temporary RALLY-10 experiment. The existing projector is deliberately kept
// intact, including paint classification, to isolate pavement command emission.
struct PavementRoad : Road {
    int bandEnd(int y) const {
        if(fixedBands) {
            const uint8_t *limit=bandLimits;
            while(*limit<y) ++limit;
            return *limit;
        }
        int end=y;
        while(end<Bottom) {
            int candidate=end+1,endpoint=candidate+1;
            bool fits=true;
            for(int row=y+1;row<=candidate;++row) {
                int32_t error=(centers[y]-centers[row])*(endpoint-y)
                    +(centers[endpoint]-centers[y])*(row-y);
                int32_t tolerance=256L*(endpoint-y);
                if(error>tolerance || error< -tolerance) {fits=false;break;}
            }
            if(!fits) break;
            end=candidate;
        }
        return end;
    }
    void emit(Stream &s,bool fillSky=true) {
        s.size=0;s.overflow=false;bands=0;
        if(fillSky) s.rect(0,0,319,RoadTop-1,4);
        s.rect(0,RoadTop,319,Bottom,2);
        for(int y=RoadTop;y<=Bottom;) {
            int end=bandEnd(y);
            strip(s,y,end+1,-RoadHalfWidth,RoadHalfWidth,8);
            ++bands;y=end+1;
        }
        s.rect(0,Bottom+1,319,239,0);
    }
    void render(Stream &s,int32_t phase,int32_t position=0,int32_t cameraOffset=0,bool fillSky=true) {
        project(position,phase,cameraOffset);
        emit(s,fillSky);
    }
};
}
