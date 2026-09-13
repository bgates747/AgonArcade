#include "rules.hpp"
#include "hud.hpp"
#include <assert.h>
#include <stdio.h>
using namespace rally::game;
void advance(Rules &r,unsigned ticks,uint32_t distance=0) {
    for(unsigned i=0;i<ticks;++i)r.tick(distance);
}
int main() {
    Rules r;r.attempt(100000,OvalRules,60);
    advance(r,359);assert(r.phase==Phase::QualifyReady && r.remaining==2400 && !r.elapsed);
    r.tick();assert(r.phase==Phase::Qualify && !r.elapsed);
    advance(r,2399);r.tick(100000);
    assert(r.phase==Phase::Qualified && r.grid==7 && r.qualifyingTime==2400);
    assert(r.bestLap==2400);
    advance(r,479);assert(r.phase==Phase::Qualified);
    r.tick();assert(r.phase==Phase::RaceReady && !r.progress && !r.elapsed);
    advance(r,360);assert(r.phase==Phase::Race);
    advance(r,2399);r.tick(100000);
    assert(r.phase==Phase::Race && r.laps==1 && r.remaining==1920 && r.extensionNotice==240);
    for(unsigned lap=1;lap<6;++lap)r.tick(100000);
    assert(r.phase==Phase::Finished && r.laps==6);
    const auto score=r.score;advance(r,1439);assert(r.phase==Phase::Finished && r.score==score);
    r.tick();assert(r.phase==Phase::Attract);
    r.attempt(100000,OvalRules,100);advance(r,360+2400);
    assert(r.phase==Phase::NotQualified && r.maxGrip==100 && !r.progress);
    r.attempt(100000,FujiRules,60);assert(r.score==0 && r.bestLap==0 && r.remaining==10800);
    assert(r.qualifyingGrid(1)==1 && r.qualifyingGrid(7200)==1 && r.qualifyingGrid(10800)==7);
    uint8_t last=1;
    for(unsigned t=7200;t<=10800;++t) {auto g=r.qualifyingGrid(t);assert(g>=last && g<=7);last=g;}
    r.raceReady();advance(r,360+10200);assert(r.phase==Phase::TimeUp);
    r.addScore(0xffffffffUL);assert(r.score==9999999);
    // Same total physics ticks, uneven rendering batches, identical outcome.
    Rules a,b;a.attempt(100000,OvalRules,60);b=a;
    advance(a,360);advance(b,360);
    for(unsigned i=0;i<1000;++i)a.tick(101);
    const unsigned batches[]={1,19,180,3,797};
    unsigned n=0;for(unsigned batch:batches) {advance(b,batch,101);n+=batch;}
    assert(n==1000 && a.phase==b.phase && a.progress==b.progress && a.score==b.score);
    Hud hud;HudImage im;im.put(0,0,"TOP 0000000");rally::Stream s;
    for(unsigned page=0;page<2;++page) {s.size=0;hud.emit(s,page,im);assert(s.size>120 && !s.overflow);}
    for(unsigned page=0;page<2;++page) {s.size=0;hud.emit(s,page,im);assert(s.size==0);}
    im.put(10,0,"1");s.size=0;hud.emit(s,0,im);assert(s.size==8);
    s.size=0;hud.emit(s,1,im);assert(s.size==8);
    s.size=0;skyViewport(s,0,0,319,103);
    assert(s.size==15 && s.data[0]==24 && s.data[3]==103 && s.data[7]==24);
    assert(s.data[9]==25 && s.data[10]==4); // Apply clip before direct bitmap draws.
    puts("Rules deadlines/reset/catch-up and independent retained HUD pages passed");
}
