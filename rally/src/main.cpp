#include "road.hpp"
#include "car.hpp"
#include "traffic.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>
namespace {
rally::Motion motion;
rally::Traffic traffic;
rally::Road road;
rally::Stream stream;
constexpr unsigned CarWidth=102, CarHeight=77;
uint8_t carUpload[CarWidth*CarHeight];
uint8_t heldKeys[16];
bool key(int code) { return heldKeys[(code-1)/8] & (1<<((code-1)%8)); }
// One reusable matrix per opponent; coefficients are signed Q8 on the wire.
void trafficMatrix(unsigned id,int scale,bool mirror) {
    rally::Stream command;
    command.byte(23);command.byte(0);command.byte(0xa0);command.word(id);
    command.byte(32);command.byte(0);
    command.byte(23);command.byte(0);command.byte(0xa0);command.word(id);
    command.byte(32);command.byte(11);command.byte(0xc8);
    command.word(mirror?-scale:scale);command.word(0);
    command.word(mirror?101*scale:0);
    command.word(0);command.word(scale);command.word(0);
    mos_puts((char *)command.data,command.size,0);
}
void drawTraffic() {
    int order[rally::TrafficCount];int32_t distance[rally::TrafficCount];
    for(int i=0;i<rally::TrafficCount;++i) order[i]=i;
    const int32_t lap=motion.track->length*100;
    for(int i=0;i<rally::TrafficCount;++i) distance[i]=rally::Traffic::ahead(traffic.cars[i].position,motion.position,lap);
    for(int i=0;i<rally::TrafficCount-1;++i) for(int j=i+1;j<rally::TrafficCount;++j)
        if(distance[order[i]]<distance[order[j]]) {int t=order[i];order[i]=order[j];order[j]=t;}
    auto camera=rally::trackSample(motion.position/100*256,*motion.track);
    for(int index:order) {
        int32_t z=distance[index]/100;
        if(z<64 || z>1100) continue;
        int q=int(8000/z),y=rally::Horizon+q;
        const auto &car=traffic.cars[index];
        int center=int(road.centers[y]/256)+car.lane*q/rally::CameraHeight;
        int scale=q*2; // 102x77 source at the same near-plane size as the player.
        auto heading=rally::trackSample(car.position/100*256,*motion.track);
        int32_t cross=(camera.tx*heading.ty-camera.ty*heading.tx)/4096;
        int magnitude=int(cross<0?-cross:cross);
        int view=magnitude<264?0:magnitude<787?1:magnitude<1297?2:magnitude<1785?3:4;
        bool mirror=cross>0;
        trafficMatrix(rally::TrafficMatrixBase+index,scale,mirror);
        vdp_select_bitmap((index+1)*5+view);
        vdp_adv_use_affine_matrix(1,rally::TrafficMatrixBase+index);
        vdp_draw_bitmap(center-51*scale/256,y-70*scale/256);
    }
    vdp_adv_use_affine_matrix(1,65535);
}
void text(int x,int y,const char *s) {
    vdp_cursor_tab(x,y);
    mos_puts(const_cast<char *>(s),strlen(s),0);
}
}
int main(int argc, char **argv) {
    const rally::TrackDef *track=&rally::TriOval;
    int distanceArg=1;
    if(argc>1 && strcmp(argv[1],"fuji")==0) { track=&rally::Fuji; distanceArg=2; }
    else if(argc>1 && strcmp(argv[1],"oval")==0) distanceArg=2;
    motion.track=road.track=track;
    road.init();
    if(argc>distanceArg) {
        long start=strtol(argv[distanceArg],nullptr,10);
        if(start>=0 && start<track->length) {
            motion.position=start*100;motion.phase=(start%rally::Period)*100;
        }
    }
    traffic.init(motion.position,track->length*100);
    if (vdp_mode(136)<0) return 1;
    vdp_set_pixel_coordinates();
    vdp_reset_sprites();
    vdp_cursor_enable(false);
    // Upload only the five unmodified player views.
    for(unsigned i=0;i<5;++i) {
        vdp_adv_clear_buffer(64000+i);
        for(unsigned y=0;y<CarHeight;++y)
            for(unsigned x=0;x<CarWidth;++x)
                carUpload[y*CarWidth+x]=
                    rally::CarPixels[i][(y*48/CarHeight)*64+x*64/CarWidth];
        vdp_adv_write_block_data(64000+i,sizeof(carUpload),(char *)carUpload);
        vdp_select_bitmap(i);
        vdp_adv_bitmap_from_buffer(CarWidth,CarHeight,1);
    }
    // Command 72 maps each 8-bit source pixel through a 256-byte table.
    // Always derive from the original view, never a previously recoloured copy.
    constexpr unsigned ColourMapBuffer=63960;
    for(unsigned livery=1;livery<rally::LiveryCount;++livery) {
        for(unsigned pixel=0;pixel<256;++pixel)
            carUpload[pixel]=rally::carColour(pixel,livery);
        vdp_adv_clear_buffer(ColourMapBuffer);
        vdp_adv_write_block_data(ColourMapBuffer,256,(char *)carUpload);
        for(unsigned i=0;i<5;++i) {
            unsigned bitmap=livery*5+i;
            vdp_adv_clear_buffer(64000+bitmap);
            rally::Stream command;
            command.byte(23);command.byte(0);command.byte(0xa0);
            command.word(64000+bitmap);command.byte(72);
            command.byte(0x10); // 8 bits/pixel (0), mapping supplied in buffer.
            command.word(64000+i);command.word(ColourMapBuffer);
            mos_puts((char *)command.data,command.size,0);
            vdp_select_bitmap(bitmap);
            vdp_adv_bitmap_from_buffer(CarWidth,CarHeight,1);
        }
    }
    vdp_adv_clear_buffer(ColourMapBuffer);
    // Matrix feature flag, then x'=-x+101, y'=y. Q0 signed 16-bit inputs.
    // Reflection around the 102-pixel canvas keeps the ground anchor fixed.
    const uint8_t mirrorCommands[]={23,0,0xf8,1,0,1,0,
        23,0,0xa0,0xf0,0xf9,32,0,
        23,0,0xa0,0xf0,0xf9,32,11,0xc0,
        0xff,0xff,0,0,101,0,0,0,1,0,0,0};
    mos_puts((char *)mirrorCommands,sizeof(mirrorCommands),0);
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
        motion.gripFrame(key(24),key(94));
        bool up=key(58), down=key(42);
        // Elapsed-time physics may catch up; steering is applied only once above.
        for (unsigned i=0;i<elapsed;++i) {
            motion.tick(up,down);traffic.tick(track->length*100);
        }
        road.render(stream,motion.phase,motion.position,motion.cameraOffset());
        if (stream.overflow) break;
        mos_puts(reinterpret_cast<char *>(stream.data),stream.size,0);
        drawTraffic();
        vdp_select_bitmap(motion.view());
        vdp_adv_use_affine_matrix(1,motion.mirrored()?63984:65535);
        vdp_draw_bitmap(motion.carX()-19,149);
        vdp_adv_use_affine_matrix(1,65535);
        char hud[41];
        snprintf(hud,sizeof(hud),"SPEED %03ld  UP/DN  -= GRIP  ESC QUIT",(long)motion.speed);
        text(1,28,hud);
        snprintf(hud,sizeof(hud),"%s L/R%+d GRIP%03d%% %s",
                 track==&rally::Fuji?"FUJI":"TRI-OVAL",motion.steering,motion.grip,motion.offroad()?"GRASS":"ROAD ");
        text(1,29,hud);
        vdp_swap();
    }
    vdp_mode(0);
    vdp_set_logical_coordinates();
    vdp_cursor_enable(true);
    printf("Agon Rally: road prototype ended.\n");
    return 0;
}
