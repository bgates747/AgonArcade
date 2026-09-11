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
}
