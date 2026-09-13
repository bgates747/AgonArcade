// Private BENCH-001 snapshot v2. Every wire field has an explicit width.
#pragma once
#include "road.hpp"
#include "traffic_observation.hpp"
#include <string.h>
namespace rally::bench {
inline void put16(uint8_t *p,uint16_t v){p[0]=v;p[1]=v>>8;}
inline void put32(uint8_t *p,uint32_t v){put16(p,uint16_t(v));put16(p+2,uint16_t(v>>16));}
inline uint32_t crc32(const uint8_t *p,unsigned n){
    uint32_t c=UINT32_C(0xffffffff);
    while(n--){c^=*p++;for(unsigned i=0;i<8;++i)c=(c>>1)^(UINT32_C(0xedb88320)&uint32_t(-int32_t(c&1)));}
    return ~c;
}
inline int32_t bends(const Motion &m,int16_t *values){
    const int32_t p=(m.position/100)*256+(m.position%100)*256/100;
    Sample a=trackSample(p,*m.track);int32_t maximum=0;
    for(unsigned i=0;i<8;++i){
        const auto b=trackSample(p+(i+1)*64L*256,*m.track);
        const int32_t bend=(a.tx*b.ty-a.ty*b.tx)/4096;
        values[i]=int16_t(bend);a=b;
        const auto magnitude=bend<0?-bend:bend;
        if(magnitude>maximum)maximum=magnitude;
    }
    return maximum;
}
inline void snapshot(uint8_t *p,const Motion &m,uint32_t run,uint32_t frame,
                     uint32_t clock,uint32_t physics,uint32_t elapsed,
                     bool demo,bool engine,uint8_t held,
                     const Traffic &traffic,const TrafficObservation &observation,
                     unsigned steeringStep=3){
    memset(p,0,140);p[0]='R';p[1]='T';p[2]=2;
    p[3]=1|(demo?2:0)|(m.cornerAssist?4:0)|(engine?8:0);
    put32(p+4,run);put32(p+8,frame);put32(p+12,clock);
    put32(p+16,m.position);put32(p+20,m.speed);put32(p+24,m.lateral);
    put32(p+28,m.lateralVelocity);put16(p+32,m.steering);put16(p+34,m.grip);
    put32(p+36,m.track->length);
    int16_t samples[8];put32(p+44,bends(m,samples));put32(p+40,int32_t(samples[0]));
    p[48]=uint8_t(m.surface());p[49]=m.track==&Fuji;p[50]=held;
    put32(p+52,physics);
    for(unsigned i=0;i<8;++i)put16(p+56+i*2,samples[i]);
    put16(p+72,RoadHalfWidth*256);put16(p+74,KerbOuterWidth*256);
    put16(p+76,elapsed>65535?65535:elapsed);p[78]=steeringStep;
    p[80]=TrafficCount;p[81]=observation.mask;
    p[82]=CarHalfWidth;p[83]=CarHalfLength;put32(p+84,observation.contacts);
    for(unsigned i=0;i<TrafficCount;++i){
        const auto &car=traffic.cars[i];auto *record=p+88+i*8;
        put32(record,relativePosition(m,car));
        put16(record+4,car.lane*256);put16(record+6,car.speed);
    }
    put32(p+136,crc32(p,136));
}
}
