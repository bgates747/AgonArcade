#pragma once
#include "workload.hpp"
namespace rally { namespace r18 {
// Include left/centre/right displacement and both steering signs at matched
// positions. Independent phase advances to exercise non-lap-locked markings.
inline void pose(unsigned frame,Motion &motion,Traffic &traffic){
    workloadPose(frame,motion,traffic,false);
    constexpr int lateral[]={-70,-35,0,35,70,0,-10,10};
    constexpr int steering[]={-14,-7,0,7,14,0,14,-14};
    motion.lateral=lateral[frame%8]*256L;motion.steering=steering[frame%8];
    motion.phase=(motion.phase+int32_t(frame)*137)%(Period*100);
}
}}
