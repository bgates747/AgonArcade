#pragma once
#include <stdio.h>
#include "scene.hpp"
// Diagnostic input only: identical simulation/renderer, explicitly frozen poses.
namespace rally { namespace r19 {
constexpr unsigned FixtureWords=17;
inline bool loadFixture(const char *filename,Motion &motion,Traffic &traffic) {
    FILE *f=fopen(filename,"rb");if(!f)return false;
    int32_t word[FixtureWords];
    bool ok=fread(word,sizeof(word),1,f)==1 && fgetc(f)==EOF;fclose(f);
    const int32_t lap=motion.track->length*100;
    if(!ok || word[0]<0 || word[0]>=lap || word[1]<0 || word[1]>=Period*100 ||
       word[2]<-150L*256 || word[2]>150L*256 || word[3]<-21 || word[3]>21 ||
       word[4]<0 || word[4]>300)return false;
    for(unsigned i=0;i<TrafficCount;++i)
        if(word[5+i*2]<0 || word[5+i*2]>=lap || word[6+i*2]<-90 || word[6+i*2]>90)return false;
    motion.position=word[0];motion.phase=word[1];motion.lateral=word[2];
    motion.steering=int16_t(word[3]);motion.speed=word[4];
    motion.lateralVelocity=0;motion.demoCurveSteering=0;
    for(unsigned i=0;i<TrafficCount;++i) {
        traffic.cars[i].position=word[5+i*2];traffic.cars[i].lane=word[6+i*2];
    }
    return true;
}
}}
