#include "car.hpp"
#include "traffic.hpp"
#include "signs_data.hpp"
#include <cstdio>
static void byte(unsigned n) { putchar(n); }
static void word(unsigned n) {byte(n);byte(n>>8);}
static void cmd(unsigned id,unsigned op) {byte(23);byte(0);byte(160);word(id);byte(op);}
static void bitmap(unsigned id,unsigned w,unsigned h) {
    byte(23);byte(27);byte(0);byte(id);
    byte(23);byte(27);byte(33);word(w);word(h);byte(1);
}
int main() {
    for(unsigned i=0;i<5;++i) {
        cmd(64000+i,2);cmd(64000+i,0);word(102*77);
        for(unsigned y=0;y<77;++y)for(unsigned x=0;x<102;++x)
            byte(rally::CarPixels[i][(y*48/77)*64+x*64/102]);
        bitmap(i,102,77);
    }
    for(unsigned l=1;l<rally::LiveryCount;++l) {
        cmd(63960,2);cmd(63960,0);word(256);
        for(unsigned i=0;i<256;++i)byte(rally::carColour(i,l));
        for(unsigned i=0;i<5;++i) {
            unsigned b=l*5+i;cmd(64000+b,2);cmd(64000+b,72);
            byte(16);word(64000+i);word(63960);bitmap(b,102,77);
        }
    }
    cmd(63960,2);
    for(unsigned i=0;i<rally::game::SignCount;++i) {
        auto &art=rally::game::SignArtwork[i];
        cmd(63800,2);cmd(63800,0);word(2048);
        for(auto p:art.pixels)byte(p);
        cmd(64120+i,2);cmd(64120+i,72);byte(4);word(63800);
        for(auto p:art.palette)byte(p);
        bitmap(120+i,64,64);
    }
    cmd(63800,2);
}
