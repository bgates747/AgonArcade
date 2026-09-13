// Stock VDP enhanced audio: channel 0, sine, no RPM/gearing model.
#pragma once
#include <stdint.h>
namespace rally::bench {
struct Engine {
    bool active=false;
    unsigned frequency=0;
    template<class Send> void start(Send send){
        const uint8_t setup[]={23,0,0x85,0,8,23,0,0x85,0,10,23,0,0x85,0,4,3};
        send(setup,sizeof(setup));active=true;frequency=0;update(0,send);
        const uint8_t volume[]={23,0,0x85,0,2,40};send(volume,sizeof(volume));
    }
    template<class Send> void update(int32_t speed,Send send){
        if(!active)return;
        if(speed<0)speed=0;
        if(speed>300)speed=300;
        const unsigned hz=80+unsigned(speed/2)*4;
        if(hz==frequency)return;
        const uint8_t command[]={23,0,0x85,0,3,uint8_t(hz),uint8_t(hz>>8)};
        send(command,sizeof(command));frequency=hz;
    }
    template<class Send> void stop(Send send){
        if(!active)return;
        const uint8_t mute[]={23,0,0x85,0,2,0};send(mute,sizeof(mute));active=false;
    }
};
}
