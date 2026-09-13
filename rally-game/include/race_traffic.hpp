#pragma once
#include "routes_data.hpp"
#include "rules.hpp"
#include "traffic.hpp"
namespace rally::game {
inline int32_t abs32(int32_t v) {return v<0?-v:v;}
inline int32_t wrap(int32_t position,int32_t lap) {
    position%=lap;return position<0?position+lap:position;
}
inline int32_t separation(int32_t a,int32_t b,int32_t lap) {
    const int32_t d=wrap(a-b,lap);return d>lap/2?d-lap:d;
}
inline int32_t stationSeparation(int32_t a,int32_t b,int32_t lap) {
    int32_t d=a-b;if(d>lap/2)d-=lap;else if(d< -lap/2)d+=lap;return d;
}
inline bool forwardPass(int32_t before,int32_t after,uint32_t playerAdvance) {
    // Reject the opposite-side-of-track wrap from +lap/2 to -lap/2.
    return before>0 && uint32_t(before)<=playerAdvance && after<=0;
}
inline int16_t routeSine(int16_t heading) {
    bool negative=heading<0;int32_t h=abs32(heading);
    if(h>16384)h=32768-h;
    unsigned i=unsigned(h/64),fraction=unsigned(h%64);
    int32_t value=RouteSine[i];
    if(i<256)value+=(int32_t(RouteSine[i+1])-value)*fraction/64;
    return int16_t(negative?-value:value);
}
struct RouteCursor {
    uint8_t record=0;uint16_t remaining=Route[0].duration;
    int16_t heading=0;int32_t lateral=0;
    uint16_t tick() {
        if(!remaining) {
            record=uint8_t((record+1)%6);remaining=Route[record].duration;
            heading=Route[record].heading;
        }
        const auto &r=Route[record];heading+=r.rate;
        lateral+=int32_t(r.speed)*2*routeSine(heading)/12800;
        --remaining;return uint16_t(r.speed*2);
    }
};
struct RaceCar {
    bool active=false;uint16_t generation=0;
    uint8_t gridOrder=0;
    int32_t progress=0,position=0,lateral=0;uint32_t finish=0;
    RouteCursor cursor{};
};
struct RaceTraffic {
    RaceCar cars[6];RouteCursor pace{};
    Policy policy=Policy::Circuit;
    int32_t lap=0;uint32_t finishDistance=0,nextSpawn=0;uint8_t playerGrid=1;
    void reset(Policy kind,int32_t lapLength,uint8_t grid,uint8_t laps) {
        policy=kind;lap=lapLength;finishDistance=uint32_t(lap)*laps;nextSpawn=0;playerGrid=grid;
        pace=RouteCursor{};
        for(unsigned i=0;i<6;++i) {
            cars[i]=RaceCar{};
            if(kind==Policy::Circuit) {
                cars[i].active=true;cars[i].generation=1;
                cars[i].gridOrder=uint8_t(i+1+(i+1>=grid?1:0));
                int offset=int(grid)-1-int(i);if(offset<=0)--offset;
                cars[i].progress=int32_t(offset)*10000;
                cars[i].position=wrap(cars[i].progress,lap);
                place(i);
            }
        }
    }
    void place(unsigned i) {
        auto &c=cars[i];const int sign=(i&1)?-1:1;
        c.cursor=pace; // Shared phase: one sine evaluation, each slot retains its countdown.
        c.lateral=int32_t(int(i%3)-1)*36*256+sign*(pace.lateral-RouteHalfExcursion);
    }
    bool spawn(int32_t position) {
        if(policy!=Policy::Arcade)return false;
        int free=-1;
        for(unsigned i=0;i<6;++i) {
            if(!cars[i].active) {if(free<0)free=int(i);continue;}
            if(abs32(separation(cars[i].progress,position,lap))<9600)return false;
        }
        if(free<0)return false;
        auto &c=cars[free];++c.generation;c.active=true;c.progress=position;
        c.position=wrap(position,lap);c.finish=0;place(unsigned(free));return true;
    }
    void tick(uint32_t player,uint32_t elapsed) {
        const uint16_t advance=pace.tick();
        for(unsigned i=0;i<6;++i)if(cars[i].active) {
            auto &c=cars[i];c.progress+=advance;c.position+=advance;
            if(c.position>=lap)c.position-=lap;
            place(i);
            if(policy==Policy::Circuit && !c.finish && c.progress>=int32_t(finishDistance))c.finish=elapsed;
            if(policy==Policy::Arcade && c.progress<int32_t(player)-12000)c.active=false;
        }
        if(policy==Policy::Arcade && player>=nextSpawn) {
            spawn(int32_t(player)+60000);nextSpawn+=90000;
        }
    }
    uint8_t rank(uint32_t player,uint32_t playerFinish=0) const {
        unsigned place=1;
        for(const auto &c:cars)if(c.active) {
            if(playerFinish?c.finish && (c.finish<playerFinish ||
                 (c.finish==playerFinish && c.gridOrder<playerGrid)):c.progress>int32_t(player))++place;
        }
        return uint8_t(place);
    }
    bool contactStation(int32_t player,int32_t lateral) const {
        for(const auto &c:cars)if(c.active && abs32(stationSeparation(c.position,player,lap))<3200 &&
             abs32(c.lateral-lateral)<24*256)return true;
        return false;
    }
    bool contact(uint32_t player,int32_t lateral) const {return contactStation(wrap(int32_t(player),lap),lateral);}
    void view(Traffic &out,int32_t camera) const {
        for(unsigned i=0;i<6;++i) {
            out.cars[i].position=cars[i].active?cars[i].position:camera;
            out.cars[i].lane=int(cars[i].lateral/256);
        }
    }
};
}
