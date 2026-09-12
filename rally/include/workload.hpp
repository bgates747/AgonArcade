#pragma once
#include "traffic.hpp"
namespace rally {
constexpr unsigned WorkloadFrames=64,WorkloadWarmup=2;
// One lap of fixed poses. No elapsed-time physics or render-rate-dependent
// steering. All variants use the same camera, phase, player anchor and traffic.
inline void workloadPose(unsigned frame,Motion &motion,Traffic &traffic,bool mirror) {
    motion.position=int32_t(frame%WorkloadFrames)*motion.track->length*100/WorkloadFrames;
    motion.phase=motion.position%(Period*100);
    motion.speed=160;motion.lateral=motion.lateralVelocity=0;
    motion.steering=mirror?14:-14;motion.demoCurveSteering=0;
    traffic.init(motion.position,motion.track->length*100);
}
inline uint32_t workloadHash(uint32_t hash,const Motion &motion,const Traffic &traffic) {
    hash=hash*33+uint32_t(motion.position);
    hash=hash*33+uint32_t(motion.phase);
    hash=hash*33+unsigned(motion.view()); // reflection deliberately excluded
    for(const auto &car:traffic.cars) hash=hash*33+uint32_t(car.position);
    return hash;
}
}
