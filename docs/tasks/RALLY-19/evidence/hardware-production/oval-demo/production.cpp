// Hardware production build: gameplay clock only; no measurement or logs.
#include "road.hpp"
#include "car.hpp"
#include "traffic.hpp"
#include "scenery_data.hpp"
#include "demo.hpp"
#include "pacing.hpp"
#include "golem_renderer.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
namespace {
rally::Motion motion; rally::Traffic traffic; rally::DemoDriver demoDriver;
rally::r19::GolemRenderer golemRenderer;
bool demoMode=true,demoInputArmed=false,escapeArmed=true,autosteer=false;
constexpr unsigned CarWidth=102,CarHeight=77;
uint8_t carUpload[CarWidth*CarHeight],heldKeys[16];
bool key(int code){return heldKeys[(code-1)/8]&(1<<((code-1)%8));}
uint32_t rawClock() {
    uint32_t first,second;
    do {first=sys_vars->time;second=sys_vars->time;} while(first!=second);
    return second;
}
void loadScenery() {
    constexpr unsigned Source=63800,Bitmap=100;
    vdp_adv_clear_buffer(Source);
    vdp_adv_write_block_data(Source,sizeof(rally::SceneryPixels),(char *)rally::SceneryPixels);
    vdp_adv_clear_buffer(64000+Bitmap);
    rally::Stream command;
    command.byte(23);command.byte(0);command.byte(0xa0);command.word(64000+Bitmap);
    command.byte(72);command.byte(4);command.word(Source);
    for(auto colour:rally::SceneryPalette) command.byte(colour);
    mos_puts((char *)command.data,command.size,0);
    vdp_select_bitmap(Bitmap);vdp_adv_bitmap_from_buffer(1024,rally::RoadTop,1);
    vdp_adv_clear_buffer(Source);
}
void text(int x,int y,const char *s) {
    vdp_cursor_tab(x,y);
    mos_puts(const_cast<char *>(s),strlen(s),0);
}
bool cleanup(){
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    bool ok=golemRenderer.unload();
    for(unsigned bitmap=0;bitmap<35;++bitmap)vdp_adv_clear_buffer(64000+bitmap);
    vdp_adv_clear_buffer(64100);vdp_adv_clear_buffer(63984);
    return ok;
}
}
int main(int argc,char**argv){
    const rally::TrackDef*track=&rally::TriOval;
    for(int i=1;i<argc;++i){
        if(strcmp(argv[i],"oval")==0)track=&rally::TriOval;
        else if(strcmp(argv[i],"fuji")==0)track=&rally::Fuji;
        else if(strcmp(argv[i],"demo")==0)demoMode=true;
        else if(strcmp(argv[i],"race")==0)demoMode=false;
        else if(strcmp(argv[i],"autosteer")==0)autosteer=true;
        else {printf("Usage: rally [oval|fuji] [demo|race] [autosteer]\n");return 1;}
    }
    motion.track=track;traffic.init(0,track->length*100);
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_reset_sprites();vdp_cursor_enable(false);
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
    loadScenery();

    if(!golemRenderer.load(track==&rally::Fuji)){
        cleanup();printf("Golem scene data could not be loaded.\n");return 31;
    }
    vdp_set_text_colour(15);vdp_set_text_bg_colour(0);
    uint32_t previous=rawClock(),next=previous;
    bool stateInvalid=false;
    for(;;){
        uint32_t now=rawClock();
        if(!rally::tickDue(now,next))continue;
        next=now+4;
        for(unsigned i=0;i<16;++i)heldKeys[i]=vdp_getKeyMap(i);
        uint32_t elapsed=rally::ticksSince(now,previous);previous=now;
        bool anyKey=false;
        for(auto bits:heldKeys) anyKey=anyKey || bits!=0;
        bool startingRace=false;
        if(demoMode) {
            if(!anyKey) demoInputArmed=true; // Ignore a launch key still held.
            if(demoInputArmed && anyKey) {
                demoMode=false;startingRace=true;
                motion.steering-=motion.demoCurveSteering;
                if(motion.steering>21) motion.steering=21;
                if(motion.steering< -21) motion.steering=-21;
                motion.demoCurveSteering=0;
            }
        }
        if(startingRace && key(113)) escapeArmed=false;
        if(!key(113)) escapeArmed=true;
        if(!demoMode && !startingRace && escapeArmed && key(113)) break;
        if(demoMode) demoDriver.frame(motion);
        else motion.steerFrame(key(26),key(122));
        motion.gripFrame(key(24),key(94));
        bool up=key(58), down=key(42);
        // Elapsed-time physics may catch up; steering is applied only once above.
        for (uint32_t i=0;i<elapsed;++i) {
            motion.cornerAssist=demoMode||autosteer;
            if(demoMode) demoDriver.tick(motion);else motion.tick(up,down);
            traffic.tick(track->length*100);
        }
        if(!golemRenderer.prepare(motion,traffic,demoMode,autosteer)){stateInvalid=true;break;}
        golemRenderer.submit();
        char hud[41];
        if(demoMode) {
            text(7,28,"PRESS ANY KEY TO RACE");
        } else {
            snprintf(hud,sizeof(hud),"SPEED %03ld  UP/DN  -= GRIP  ESC QUIT",(long)motion.speed);
            text(1,28,hud);
            snprintf(hud,sizeof(hud),"%s L/R%+d GRIP%03d%% %s",
                     track==&rally::Fuji?"FUJI":"TRI-OVAL",motion.steering,motion.grip,motion.surfaceName());
            text(1,29,hud);
        }
        vdp_swap();

    }
    bool cleaned=cleanup();
    if(stateInvalid)printf("Scene state rejected.\n");
    if(!cleaned)printf("Scene cleanup could not be loaded.\n");
    return stateInvalid||!cleaned?1:0;
}
