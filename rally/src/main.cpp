#include "road.hpp"
#include "car.hpp"
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
constexpr unsigned CarWidth=102, CarHeight=77;
uint8_t carUpload[CarWidth*CarHeight];
uint8_t heldKeys[16];
bool key(int code) { return heldKeys[(code-1)/8] & (1<<((code-1)%8)); }
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
    for(unsigned i=0;i<9;++i) {
        vdp_adv_clear_buffer(64000+i);
        // Nearest-neighbor resampling once at startup preserves the exact palette.
        for(unsigned y=0;y<CarHeight;++y)
            for(unsigned x=0;x<CarWidth;++x)
                carUpload[y*CarWidth+x]=rally::CarPixels[i][(y*48/CarHeight)*64+x*64/CarWidth];
        vdp_adv_write_block_data(64000+i,sizeof(carUpload),(char *)carUpload);
        vdp_select_bitmap(i);
        vdp_adv_bitmap_from_buffer(CarWidth,CarHeight,1);
    }
    vdp_set_text_colour(15);
    vdp_set_text_bg_colour(0);
    clock_t previous=clock(), next=previous;
    for (;;) {
        clock_t now=clock();
        if (long(now-next)<0) continue;
        next=now+4;
        for(unsigned i=0;i<16;++i) heldKeys[i]=vdp_getKeyMap(i);
        if(key(113)) break;
        unsigned elapsed=unsigned(now-previous);
        previous=now;
        motion.steerFrame(key(26),key(122));
        bool up=key(58), down=key(42);
        // Elapsed-time physics may catch up; steering is applied only once above.
        for (unsigned i=0;i<elapsed;++i) motion.tick(up,down);
        road.render(stream,motion.phase,motion.position,motion.cameraOffset());
        if (stream.overflow) break;
        mos_puts(reinterpret_cast<char *>(stream.data),stream.size,0);
        vdp_select_bitmap(motion.view());
        vdp_draw_bitmap(motion.carX()-19,149);
        char hud[41];
        snprintf(hud,sizeof(hud),"SPEED %03ld    UP + / DOWN -    ESC QUIT",(long)motion.speed);
        text(1,28,hud);
        snprintf(hud,sizeof(hud),"HOLD L/R   STEER %+d   %s",
                 motion.yawStep,motion.offroad()?"GRASS":"ROAD ");
        text(1,29,hud);
        vdp_swap();
    }
    vdp_mode(0);
    vdp_set_logical_coordinates();
    vdp_cursor_enable(true);
    printf("Agon Rally: road prototype ended.\n");
    return 0;
}
