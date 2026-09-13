#include "host_telemetry.hpp"
#include "latest.hpp"
#include <cassert>
#include <cstdio>
int main(){
    rally::Motion m;m.track=&rally::Fuji;m.cornerAssist=false;m.grip=200;
    rally::game::Rules rules;rules.phase=rally::game::Phase::Race;
    rally::game::RaceTraffic traffic;traffic.reset(rally::game::Policy::Arcade,m.track->length*100,1,2);
    traffic.spawn(60000);traffic.tick(0,1);
    unsigned char p[140];agon::extender::telemetry::Latest receiver;
    for(unsigned phase=0;phase<10;++phase){
        rules.phase=rally::game::Phase(phase);m.cornerAssist=phase==0;
        rally::game::host::snapshot(p,m,123,phase+1,100+phase,phase*4,4,rules,false,true,0,traffic,2,2);
        assert(receiver.receive(p,140,phase));
        assert(p[3]>>4==phase && !p[51] && !p[79]);
        assert((p[3]&1)==(phase==3 || phase==6));
        assert(p[84]==2);
        if(phase!=6)assert(agon::extender::telemetry::u32(p+88)==0x80000000u);
        else {assert(agon::extender::telemetry::u32(p+88)!=0x80000000u);assert(p[95]==0);}
        assert(fwrite(p,1,140,stdout)==140);
    }
    rules.phase=rally::game::Phase::Race;m.cornerAssist=false;
    rally::game::host::snapshot(p,m,123,11,111,44,4,rules,true,true,0,traffic,3,2);
    assert(!(p[3]&1) && p[84]==3);assert(receiver.receive(p,140,11));
    assert(fwrite(p,1,140,stdout)==140);
    p[88]^=1;assert(!receiver.receive(p,140,12));
}
