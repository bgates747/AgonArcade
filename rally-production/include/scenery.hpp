#pragma once
#include "scenery_data.hpp"
namespace rally {
// Absolute track-tangent bearing in a 1024-unit circle. No per-frame floats.
inline int sceneryHeading(int32_t x,int32_t y) {
    int32_t ax=x<0?-x:x,ay=y<0?-y:y;
    if(ax==0 && ay==0) return 0;
    int angle=ax>=ay?HeadingAtan[ay*256/ax]:256-HeadingAtan[ax*256/ay];
    if(x<0) angle=512-angle;
    if(y<0) angle=1024-angle;
    return angle&1023;
}
struct SceneryUpdate {
    int delta,left,right;
    bool repaint;
};
struct SceneryHistory {
    int offsets[2]={0,0};
    bool valid[2]={false,false};
    unsigned slot=0;
    SceneryUpdate prepare(int offset) {
        offset&=1023;
        int delta=(offset-offsets[slot]+1536)%1024-512;
        bool full=!valid[slot] || delta>255 || delta< -255;
        offsets[slot]=offset;valid[slot]=true;
        if(full) return {0,0,319,true};
        if(delta==0) return {0,0,0,false};
        return delta>0?SceneryUpdate{delta,320-delta,319,true}
                      :SceneryUpdate{delta,0,-delta-1,true};
    }
    void swapped() { slot^=1; }
};

}
