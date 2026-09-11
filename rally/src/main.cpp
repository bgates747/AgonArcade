#include "road.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>
namespace {
rally::Motion motion;
rally::Road road;
rally::Stream stream;
bool key(int code) { return vdp_getKeyMap((code-1)/8) & (1<<((code-1)%8)); }
void text(int x,int y,const char *s) {
    vdp_cursor_tab(x,y);
    mos_puts(const_cast<char *>(s),strlen(s),0);
}
}
int main(int argc, char **argv) {
    road.init();
    // Optional world-distance start for repeatable native curve captures.
    if(argc>1) {
        long start=strtol(argv[1],nullptr,10);
        if(start>=0 && start<rally::TrackLength) {
            motion.position=start*100; motion.phase=(start%rally::Period)*100;
        }
    }
    if (vdp_mode(136)<0) return 1;
    vdp_set_pixel_coordinates();
    vdp_reset_sprites();
    vdp_cursor_enable(false);
    vdp_set_text_colour(15);
    vdp_set_text_bg_colour(0);
    clock_t previous=clock(), next=previous;
    while (!key(113)) {
        clock_t now=clock();
        unsigned elapsed=unsigned(now-previous);
        previous=now;
        bool up=key(58), down=key(42);
        for (unsigned i=0;i<elapsed;++i) motion.tick(up,down);
        if (long(now-next)<0) continue;
        next=now+4;
        road.render(stream,motion.phase,motion.position);
        if (stream.overflow) break;
        mos_puts(reinterpret_cast<char *>(stream.data),stream.size,0);
        char hud[41];
        snprintf(hud,sizeof(hud),"SPEED %03ld    UP + / DOWN -    ESC QUIT",(long)motion.speed);
        text(1,28,hud);
        snprintf(hud,sizeof(hud),"TRACK %02ld%%   AUTO FOLLOW   %u BANDS",
                 (long)(motion.position/(rally::TrackLength)),road.bands);
        text(1,29,hud);
        vdp_swap();
    }
    vdp_mode(0);
    vdp_set_logical_coordinates();
    vdp_cursor_enable(true);
    printf("Agon Rally: road prototype ended.\n");
    return 0;
}
