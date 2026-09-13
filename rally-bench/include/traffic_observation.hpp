// BENCH-001 measurement only: no collision response or changes to Motion.
#pragma once
#include "traffic.hpp"
namespace rally::bench {
constexpr int PlayerStation=68, CarHalfLength=16;
inline int32_t relativePosition(const Motion &m,const Opponent &car){
    const int32_t lap=m.track->length*100;
    int32_t d=car.position-m.position-PlayerStation*100;
    if(d>lap/2)d-=lap;
    if(d< -lap/2)d+=lap;
    return d;
}
struct TrafficObservation {
    uint32_t contacts=0;
    uint8_t mask=0;
    void tick(const Motion &m,const Traffic &traffic){
        uint8_t next=0;
        for(unsigned i=0;i<TrafficCount;++i){
            const auto &car=traffic.cars[i];
            const auto d=relativePosition(m,car);
            const auto lateral=m.lateral-car.lane*256L;
            if(d>=-CarHalfLength*200 && d<=CarHalfLength*200 &&
               lateral>=-CarHalfWidth*512L && lateral<=CarHalfWidth*512L){
                const uint8_t bit=1<<i;next|=bit;
                if(!(mask&bit))++contacts;
            }
        }
        mask=next;
    }
};
}
