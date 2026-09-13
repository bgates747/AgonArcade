// BENCH-001 isolated derivative of rally-production; accepted renderer/physics retained.
#include "telemetry.hpp"
#include "controls.hpp"
#include "engine.hpp"
#include "road.hpp"
#include "car.hpp"
#include "traffic.hpp"
#include "traffic_policy.hpp"
#include "scenery.hpp"
#include "demo.hpp"
#include "pacing.hpp"
#include "scene.hpp"
#include "lookup_road.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
extern "C" unsigned emos_gateway_call(uint8_t *request);
namespace {
bool telemetryRequested=false,telemetryOpen=false,engineRequested=false;
unsigned steeringStep=2;
uint8_t gateway[66],telemetryInput[141];
uint32_t telemetryRun=0,telemetryFrame=0,physicsTicks=0;
rally::bench::Engine engine;
void sendAudio(const uint8_t *p,unsigned n){mos_puts((char*)p,n,0);}
void put24(uint8_t *p,unsigned v){p[0]=v;p[1]=v>>8;p[2]=v>>16;}
unsigned telemetryCall(uint8_t operation){
    telemetryInput[0]=operation;memset(gateway,0,sizeof(gateway));
    gateway[0]=66;gateway[2]=1;gateway[4]=3;gateway[5]=9;gateway[6]=2;
    memcpy(gateway+25,"ext",3);memcpy(gateway+41,"telemetry",9);
    put24(gateway+10,(unsigned)telemetryInput);put24(gateway+13,operation==1?141:1);
    return emos_gateway_call(gateway);
}
bool autosteer=false,perspective=false;
volatile rally::r18::SceneState scene{};
rally::Motion motion;
rally::LookupRoad road __attribute__((no_destroy));
rally::Traffic traffic;
rally::bench::TrafficObservation trafficObservation;
rally::DemoDriver demoDriver;
bool demoMode=true,demoInputArmed=false,escapeArmed=true;
rally::SceneryHistory sceneryHistory;
rally::Stream stream;
constexpr unsigned CarWidth=102,CarHeight=77;
uint8_t carUpload[CarWidth*CarHeight],heldKeys[16];
bool key(int code){return heldKeys[(code-1)/8]&(1<<((code-1)%8));}
uint32_t rawClock() {
    uint32_t first,second;
    do {first=sys_vars->time;second=sys_vars->time;} while(first!=second);
    return second;
}
void trafficMatrix(unsigned id,int xx,int scale,int translation) {
    rally::Stream command;
    command.byte(23);command.byte(0);command.byte(0xa0);command.word(id);command.byte(32);command.byte(0);
    command.byte(23);command.byte(0);command.byte(0xa0);command.word(id);command.byte(32);command.byte(11);command.byte(0xc8);
    command.word(xx);command.word(0);command.word(translation);command.word(0);command.word(scale);command.word(0);
    mos_puts((char*)command.data,command.size,0);
}
unsigned drawTraffic(){
    for(unsigned i=0;i<scene.cars;++i){volatile const auto &c=scene.traffic[i];
        trafficMatrix(c.matrix,c.xx,c.scale,c.translation);vdp_select_bitmap(c.bitmap);
        vdp_adv_use_affine_matrix(1,c.matrix);vdp_draw_bitmap(c.x,c.y);
    }
    vdp_adv_use_affine_matrix(1,65535);return scene.cars;
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
void drawScenery() {
    int offset=scene.skyOffset;
    rally::SceneryUpdate update={scene.skyDelta,scene.skyLeft,scene.skyRight,scene.skyRepaint};

    vdp_adv_use_affine_matrix(1,65535);
    if(update.delta) {
        vdp_set_graphics_viewport(0,0,319,rally::RoadTop-1);
        vdp_scroll_screen_extent(2,update.delta>0?1:0,
                                 update.delta>0?update.delta:-update.delta);
    }
    vdp_select_bitmap(100);
    if(update.repaint) {
        vdp_set_graphics_viewport(update.left,0,update.right,rally::RoadTop-1);
        if(1024-offset>update.left) vdp_draw_bitmap(-offset,0);
        if(1024-offset<=update.right) vdp_draw_bitmap(1024-offset,0);
    }
    // Foreground triangles and distant cars can overlap the bottom of the sky.
    // Repair that narrow band after scrolling, including when heading is static.
    if(!update.repaint || update.delta) {
        vdp_set_graphics_viewport(0,rally::RoadTop-16,319,rally::RoadTop-1);
        vdp_draw_bitmap(-offset,0);
        if(offset>1024-320) vdp_draw_bitmap(1024-offset,0);
    }
    vdp_set_graphics_viewport(0,0,319,239);
}
void text(int x,int y,const char *s) {
    vdp_cursor_tab(x,y);
    mos_puts(const_cast<char *>(s),strlen(s),0);
}
void prepareScene(){rally::r18::prepareScene(motion,traffic,road,sceneryHistory,scene,perspective);}
void drawPlayer(){
    vdp_select_bitmap(scene.playerBitmap);
    vdp_adv_use_affine_matrix(1,scene.playerMirror?63984:65535);
    vdp_draw_bitmap(scene.playerX,rally::r18::PlayerDrawY);
    vdp_adv_use_affine_matrix(1,65535);
}
}
int gameMain(int argc,char**argv){
    const rally::TrackDef*track=&rally::TriOval;
    for(int i=1;i<argc;++i){
        if(strcmp(argv[i],"oval")==0)track=&rally::TriOval;
        else if(strcmp(argv[i],"fuji")==0)track=&rally::Fuji;
        else if(strcmp(argv[i],"demo")==0)demoMode=true;
        else if(strcmp(argv[i],"race")==0)demoMode=false;
        else if(strcmp(argv[i],"autosteer")==0)autosteer=true;
        else if(strcmp(argv[i],"perspective")==0)perspective=true;
        else if(strcmp(argv[i],"telemetry")==0)telemetryRequested=true;
        else if(strcmp(argv[i],"engine")==0)engineRequested=true;
        else if(strcmp(argv[i],"mute")==0)engineRequested=false;
        else if(strcmp(argv[i],"grip200")==0)motion.grip=200;
        else if(strcmp(argv[i],"steer1")==0)steeringStep=1;
        else if(strcmp(argv[i],"steer2")==0)steeringStep=2;
        else if(strcmp(argv[i],"steer3")==0)steeringStep=3;
        else {printf("Usage: rally [oval|fuji] [demo|race] [autosteer] [perspective] [telemetry] [engine|mute] [grip200] [steer1|steer2|steer3]\n");return 1;}
    }
    motion.cornerAssist=demoMode||autosteer;
    motion.track=road.track=track;road.init();
    if(!road.load(track==&rally::Fuji?"fuji.road":"oval.road")){
        printf("Road data invalid or unavailable.\n");return 30;
    }
    if(telemetryRequested){
        const auto status=telemetryCall(0);
        if(status){printf("EMOS telemetry unavailable (%u).\n",status);return 31;}
        telemetryOpen=true;
    }
    (void)rally::bench::CirculatingTraffic::initialise(traffic,motion.position,track->length*100);
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
    mos_puts((char*)rally::section::Startup,rally::section::StartupSize,0);
    vdp_set_text_colour(15);
    vdp_set_text_bg_colour(0);

    if(engineRequested)engine.start(sendAudio);
    uint32_t previous=rawClock(),next=previous;
    telemetryRun=previous^UINT32_C(0xB001D12E);
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
        else rally::bench::steerFrame(motion,key(26),key(122),steeringStep);
        motion.gripFrame(key(24),key(94));
        bool up=key(58), down=key(42);
        // Elapsed-time physics may catch up; steering is applied only once above.
        for (uint32_t i=0;i<elapsed;++i) {
            motion.cornerAssist=demoMode||autosteer;
            if(demoMode) demoDriver.tick(motion);else motion.tick(up,down);
            rally::bench::CirculatingTraffic::tick(traffic,track->length*100);
            if(telemetryOpen)trafficObservation.tick(motion,traffic);
        }
        physicsTicks+=elapsed;++telemetryFrame;
        engine.update(motion.speed,sendAudio);
        if(telemetryOpen){
            rally::bench::snapshot(telemetryInput+1,motion,telemetryRun,telemetryFrame,
                now,physicsTicks,elapsed,demoMode,engine.active,
                (key(26)?1:0)|(key(122)?2:0)|(up?4:0)|(down?8:0),traffic,trafficObservation,steeringStep);
            const auto status=telemetryCall(1);
            // BUSY drops this publication; never stall rendering or queue old state.
            if(status && status!=31)telemetryOpen=false;
        }
        prepareScene();road.emit(stream,false);
        if(stream.overflow)break;
        drawScenery();mos_puts((char*)stream.data,stream.size,0);
        drawTraffic();drawPlayer();
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
        sceneryHistory.swapped();

    }
    engine.stop(sendAudio);
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    return 0;
}
int main(int argc,char**argv){
    const int result=gameMain(argc,argv);
    engine.stop(sendAudio);
    if(telemetryOpen){(void)telemetryCall(2);telemetryOpen=false;}
    road.~LookupRoad();return result;
}
