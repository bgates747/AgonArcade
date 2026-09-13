#include "crash.hpp"
#include <assert.h>
#include <stdio.h>
using namespace rally::game;
int main(int argc,char **) {
    if(argc>1) {
        RouteCursor c;uint32_t forward=0;
        for(unsigned i=0;i<600;++i) {
            forward+=c.tick();printf("%u,%u,%d,%ld,%lu\n",unsigned(c.record),unsigned(c.remaining),
                c.heading,(long)c.lateral,(unsigned long)forward);
        }
        return 0;
    }
    RouteCursor c;for(unsigned i=0;i<600;++i)c.tick();assert(!c.heading && !c.lateral && !c.remaining);
    for(int h=-32768;h<=32767;++h)assert(routeSine(int16_t(h))>=-32767 && routeSine(int16_t(h))<=32767);
    for(unsigned grid=1;grid<=7;++grid) {
        RaceTraffic t;t.reset(Policy::Circuit,576000,uint8_t(grid),6);
        assert(t.rank(0)==grid && !t.spawn(0));
        for(unsigned tick=1;tick<=18000;++tick) {
            t.tick(tick*400,tick);
            for(unsigned i=0;i<6;++i) {
                assert(abs32(t.cars[i].lateral)<78*256);
                for(unsigned j=0;j<i;++j)assert(abs32(separation(t.cars[i].progress,t.cars[j].progress,t.lap))>=9600);
            }
        }
        for(const auto &car:t.cars)assert(car.finish && car.progress>int32_t(t.finishDistance));
    }
    RaceTraffic t;t.reset(Policy::Arcade,576000,1,6);
    for(unsigned tick=1;tick<=30000;++tick) {
        t.tick(tick*500,tick);
        for(unsigned i=0;i<6;++i)if(t.cars[i].active) {
            assert(t.cars[i].cursor.record==t.pace.record && t.cars[i].cursor.remaining==t.pace.remaining);
            for(unsigned j=0;j<i;++j)if(t.cars[j].active)
                assert(abs32(separation(t.cars[i].progress,t.cars[j].progress,t.lap))>=9600);
        }
    }
    t.reset(Policy::Arcade,576000,1,6);assert(t.spawn(0));assert(!t.spawn(9599));assert(t.spawn(9600));
    assert(t.contact(0,t.cars[0].lateral));
    assert(!t.contact(3200,t.cars[0].lateral));
    assert(!t.contact(0,t.cars[0].lateral+24*256));
    assert(forwardPass(400,-20,500));assert(!forwardPass(288000,-287900,500));
    assert(!forwardPass(400,-20,0));
    for(int32_t a=0;a<576000;a+=7919)for(int32_t b=0;b<576000;b+=1777)
        assert(stationSeparation(a,b,576000)==separation(a,b,576000));
    Crash crash;rally::Motion car;car.speed=200;crash.begin(car);assert(!car.speed && crash.remaining==150);
    for(unsigned i=0;i<149;++i)assert(crash.tick(car,t,0));
    assert(crash.remaining==1);assert(crash.tick(car,t,0));
    assert(!crash.remaining && crash.invulnerable==120 && !t.contact(0,car.lateral));
    for(unsigned i=0;i<120;++i)assert(!crash.tick(car,t,0));
    assert(!crash.invulnerable);
    t.reset(Policy::Circuit,576000,3,6);
    for(auto &c:t.cars)c.finish=100;
    assert(t.rank(1,100)==3); // Equal finish tick uses original grid-order tie.
    puts("Traffic repeated routes, grid ranks, lap wraps, spawn boundaries and finish latches passed");
}
