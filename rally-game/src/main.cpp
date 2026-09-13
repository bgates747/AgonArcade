// RALLY-22 stock-VDP game; the accepted production and telemetry bench stay intact.
#include "rules.hpp"
#include "crash.hpp"
#include "record_file.hpp"
#include "signs.hpp"
#include "signs_data.hpp"
#include "hud.hpp"
#include "font_data.hpp"
#include "controls.hpp"
#include "engine.hpp"
#include "car.hpp"
#include "traffic.hpp"
#include "scenery.hpp"
#include "demo.hpp"
#include "pacing.hpp"
#include "game_scene.hpp"
#include "lookup_road.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
#if defined(RALLY_TEST_DRIVER) && !defined(RALLY_CAPTURE)
#error Assisted flow tests must be explicitly identified capture fixtures
#endif
#if defined(RALLY_TEST_CONTACT) && (!defined(RALLY_TEST_DRIVER) || !defined(RALLY_CAPTURE))
#error Contact fault injection requires an explicitly assisted capture fixture
#endif
#ifdef RALLY_HOST_TELEMETRY
#include "host_telemetry.hpp"
extern "C" unsigned emos_gateway_call(uint8_t *request);
#endif
namespace {
using namespace rally::game;
#ifdef RALLY_HOST_TELEMETRY
uint8_t gateway[66],telemetryInput[141];
bool telemetryOpen=false;
uint32_t telemetryRun=0,telemetryFrame=0,physicsTicks=0,hostContacts=0;
void put24(uint8_t *p,unsigned v){p[0]=v;p[1]=v>>8;p[2]=v>>16;}
unsigned telemetryCall(uint8_t operation){
    telemetryInput[0]=operation;memset(gateway,0,sizeof(gateway));
    gateway[0]=66;gateway[2]=1;gateway[4]=3;gateway[5]=9;gateway[6]=2;
    memcpy(gateway+25,"ext",3);memcpy(gateway+41,"telemetry",9);
    put24(gateway+10,(unsigned)telemetryInput);put24(gateway+13,operation==1?141:1);
    return emos_gateway_call(gateway);
}
#endif
rally::Motion motion;
rally::LookupRoad road __attribute__((no_destroy));
rally::Traffic traffic;
rally::DemoDriver demoDriver;
rally::SceneryHistory sceneryHistory;
rally::r18::SceneState scene{};
rally::Stream stream;
Rules rules;
RaceTraffic raceTraffic;
Crash crash;
Billboards billboards;
uint32_t attractProgress=0;
Hud hud;
Engine engine;
const rally::TrackDef *selected=&rally::TriOval;
bool muted=false,inputArmed=false,quit=false;
unsigned steeringStep=2;
constexpr unsigned CarWidth=102,CarHeight=77,Font=63940,LargeFont=63941;
uint8_t carUpload[CarWidth*CarHeight],heldKeys[16],previousKeys[16];
uint16_t shownRevision=65535;
char panelCache[2][160]{};
uint32_t topScore=0;
Records records;
bool savePending=false;
#ifdef RALLY_CAPTURE
struct PhaseEvent {uint32_t tick,elapsed,progress,score;uint8_t phase,laps;};
PhaseEvent events[64];unsigned eventCount=0;uint32_t testTicks=0;
void report() {
    FILE *file=fopen("report.txt","wb");if(!file)return;
    fputs("phase,tick,elapsed,progress,score,laps\n",file);
    for(unsigned i=0;i<eventCount;++i) {
        const auto &e=events[i];fprintf(file,"%u,%lu,%lu,%lu,%lu,%u\n",unsigned(e.phase),
          (unsigned long)e.tick,(unsigned long)e.elapsed,(unsigned long)e.progress,(unsigned long)e.score,unsigned(e.laps));
    }
    fclose(file);
}
#endif
bool key(int code) { return heldKeys[(code-1)/8]&(1<<((code-1)%8)); }
bool pressed(int code) { return key(code) && !(previousKeys[(code-1)/8]&(1<<((code-1)%8))); }
void send(const uint8_t *p,unsigned n) {
    // MOS length=0 means ASCIIZ, not an empty write. Cached unchanged HUDs
    // must emit nothing; otherwise stale buffer bytes become VDU commands.
    if(n)mos_puts((char*)p,n,0);
}
void flush() { send(stream.data,stream.size);stream.size=0;stream.overflow=false; }
uint32_t rawClock() {
    uint32_t a,b;do {a=sys_vars->time;b=sys_vars->time;} while(a!=b);return b;
}
void font(unsigned id) {
    const uint8_t cmd[]={23,0,0x95,0,uint8_t(id),uint8_t(id>>8),0};send(cmd,sizeof(cmd));
}
void fontCreate(unsigned id,unsigned size) {
    const uint8_t cmd[]={23,0,0x95,1,uint8_t(id),uint8_t(id>>8),uint8_t(size),uint8_t(size),uint8_t(size-1),0};
    send(cmd,sizeof(cmd));
}
void loadFont() {
    vdp_adv_clear_buffer(Font);
    vdp_adv_write_block_data(Font,sizeof(FontPixels),(char*)FontPixels);fontCreate(Font,8);
    // A nearest-neighbour 2x derivative uses the identical original glyphs.
    vdp_adv_clear_buffer(LargeFont);
    for(unsigned ch=0;ch<256;++ch) {
        uint8_t doubled[32];
        for(unsigned y=0;y<8;++y) {
            unsigned bits=0;for(unsigned x=0;x<8;++x)bits=(bits<<2)|((FontPixels[ch*8+y]&(128>>x))?3:0);
            doubled[y*4]=doubled[y*4+2]=uint8_t(bits>>8);
            doubled[y*4+1]=doubled[y*4+3]=uint8_t(bits);
        }
        vdp_adv_write_block_data(LargeFont,32,(char*)doubled);
    }
    // Font API requires one contiguous block, even when uploaded in pieces.
    const uint8_t consolidate[]={23,0,0xa0,uint8_t(LargeFont),uint8_t(LargeFont>>8),14};
    send(consolidate,sizeof(consolidate));fontCreate(LargeFont,16);font(Font);
}
void text(int x,int y,const char *s,int ink=15,int paper=SkyColour) {
    vdp_set_text_colour(ink);vdp_set_text_bg_colour(paper);vdp_cursor_tab(x,y);
    send((const uint8_t*)s,strlen(s));
}
void centre(int row,const char *s,int ink=15) { text((40-int(strlen(s)))/2,row,s,ink); }
bool panelVisible() { return !driving(rules.phase); }
void trafficMatrix(unsigned id,int xx,int scale,int translation) {
    stream.byte(23);stream.byte(0);stream.byte(0xa0);stream.word(id);stream.byte(32);stream.byte(0);
    stream.byte(23);stream.byte(0);stream.byte(0xa0);stream.word(id);stream.byte(32);stream.byte(11);stream.byte(0xc8);
    stream.word(xx);stream.word(0);stream.word(translation);stream.word(0);stream.word(scale);stream.word(0);flush();
}
void drawTraffic() {
    // Both populations use q*2 scale. Merge their already depth-sorted views.
    unsigned car=0,sign=0;
    while(car<scene.cars || sign<billboards.count) {
        if(sign<billboards.count && (car==scene.cars || billboards.visible[sign].scale<=scene.traffic[car].scale)) {
            const auto &s=billboards.visible[sign++];
            viewport(stream,0,rally::RoadTop,319,223);flush();
            trafficMatrix(SignMatrix,s.scale,s.scale,0);vdp_select_bitmap(s.bitmap);
            vdp_adv_use_affine_matrix(1,SignMatrix);vdp_draw_bitmap(s.x,s.y);
            viewport(stream,0,panelVisible()?88:HudHeight,319,223);flush();
        } else {
            const auto &c=scene.traffic[car++];trafficMatrix(c.matrix,c.xx,c.scale,c.translation);
            vdp_select_bitmap(c.bitmap);vdp_adv_use_affine_matrix(1,c.matrix);vdp_draw_bitmap(c.x,c.y);
        }
    }
    vdp_adv_use_affine_matrix(1,65535);
}
void loadScenery() {
    constexpr unsigned Source=63800,Bitmap=100;
    vdp_adv_clear_buffer(Source);
    vdp_adv_write_block_data(Source,sizeof(rally::SceneryPixels),(char*)rally::SceneryPixels);
    vdp_adv_clear_buffer(64000+Bitmap);
    stream.byte(23);stream.byte(0);stream.byte(0xa0);stream.word(64000+Bitmap);
    stream.byte(72);stream.byte(4);stream.word(Source);
    for(auto colour:rally::SceneryPalette)stream.byte(colour);
    flush();vdp_select_bitmap(Bitmap);vdp_adv_bitmap_from_buffer(1024,rally::RoadTop,1);
    vdp_adv_clear_buffer(Source);
}
void loadSigns() {
    constexpr unsigned Source=63800;
    for(unsigned i=0;i<SignCount;++i) {
        const auto &art=SignArtwork[i];const unsigned bitmap=SignBitmapBase+i;
        vdp_adv_clear_buffer(Source);vdp_adv_write_block_data(Source,sizeof(art.pixels),(char*)art.pixels);
        vdp_adv_clear_buffer(64000+bitmap);
        stream.byte(23);stream.byte(0);stream.byte(0xa0);stream.word(64000+bitmap);
        stream.byte(72);stream.byte(4);stream.word(Source);
        for(auto colour:art.palette)stream.byte(colour);
        flush();vdp_select_bitmap(bitmap);vdp_adv_bitmap_from_buffer(64,64,1);
    }
    vdp_adv_clear_buffer(Source);
}
void drawScenery() {
    const int top=panelVisible()?88:HudHeight,offset=scene.skyOffset;
    vdp_adv_use_affine_matrix(1,65535);
    if(scene.skyDelta) {
        skyViewport(stream,0,top,319,rally::RoadTop-1);flush();
        vdp_scroll_screen_extent(2,scene.skyDelta>0?1:0,scene.skyDelta>0?scene.skyDelta:-scene.skyDelta);
    }
    vdp_select_bitmap(100);
    if(scene.skyRepaint) {
        skyViewport(stream,scene.skyLeft,top,scene.skyRight,rally::RoadTop-1);flush();
        if(1024-offset>scene.skyLeft)vdp_draw_bitmap(-offset,0);
        if(1024-offset<=scene.skyRight)vdp_draw_bitmap(1024-offset,0);
    }
    if(!scene.skyRepaint || scene.skyDelta) {
        skyViewport(stream,0,rally::RoadTop-16,319,rally::RoadTop-1);flush();
        vdp_draw_bitmap(-offset,0);if(offset>704)vdp_draw_bitmap(1024-offset,0);
    }
    viewport(stream,0,rally::RoadTop,319,239);flush();
}
void resetMotion() {
    const int grip=motion.grip;motion=rally::Motion{};motion.track=selected;motion.grip=grip;
    motion.position=selected->length*100-6800;motion.cornerAssist=false;
    crash=Crash{};attractProgress=0;
    raceTraffic.reset(rules.phase==Phase::Attract?Policy::Circuit:rules.policy,
                      selected->length*100,rules.phase==Phase::Attract?7:rules.grid,rules.settings.laps);
#ifdef RALLY_TEST_CLEAR_ROAD
    // Isolate long-track phase/timer coverage from an assisted driver's crashes.
    if(rules.phase==Phase::RaceReady)for(auto &car:raceTraffic.cars)car.active=false;
#endif
    raceTraffic.view(traffic,motion.position);
}
bool loadTrack() {
    road.track=selected;road.init();
    return road.load(selected==&rally::Fuji?"fuji.road":"oval.road");
}
void phaseChanged() {
    if(shownRevision==rules.revision)return;
    shownRevision=rules.revision;
#ifdef RALLY_CAPTURE
    if(eventCount<64)events[eventCount++]={testTicks,rules.elapsed,rules.progress,rules.score,uint8_t(rules.phase),rules.laps};
#endif
    sceneryHistory.valid[0]=sceneryHistory.valid[1]=false;
    panelCache[0][0]=panelCache[1][0]=0;
    if(rules.phase==Phase::QualifyReady || rules.phase==Phase::RaceReady || rules.phase==Phase::Attract)
        resetMotion();
    if(rules.phase==Phase::Attract || result(rules.phase) || rules.phase==Phase::Select)inputArmed=false;
    if(result(rules.phase)) {
        motion.speed=0; // Result screens stop the vehicle and its engine pitch.
        const unsigned identity=Records::key(selected==&rally::Fuji,rules.policy==Policy::Arcade,steeringStep,rules.maxGrip);
#if !defined(RALLY_TEST_DRIVER) && !defined(RALLY_HOST_TELEMETRY)
        savePending=records.update(identity,rules.score,rules.bestLap) || savePending;
#else
        (void)identity; // Assisted fixtures never persist scores as manual play.
#endif
    }
}
void clockText(char *out,unsigned size,uint32_t ticks) {
    const uint32_t hundredths=ticks*100/Hz;
    snprintf(out,size,"%01lu'%02lu\"%02lu",(unsigned long)(hundredths/6000),
             (unsigned long)(hundredths/100%60),(unsigned long)(hundredths%100));
}
void drawHud(uint32_t interval) {
    HudImage image;char value[48],time[20];
    const bool active=driving(rules.phase) || result(rules.phase) || rules.phase==Phase::Qualified;
    const auto &record=records.entries[Records::key(selected==&rally::Fuji,rules.policy==Policy::Arcade,
        steeringStep,active?rules.maxGrip:motion.grip)];
    topScore=record.score;
    snprintf(value,sizeof(value),"TOP %07lu",(unsigned long)topScore);image.put(0,0,value,11);
    snprintf(value,sizeof(value),"TIME %03lu",(unsigned long)((rules.remaining+Hz-1)/Hz));image.put(14,0,value,11);
    clockText(time,sizeof(time),driving(rules.phase)?rules.elapsed-rules.lapBegin:rules.lapTime);
    snprintf(value,sizeof(value),"LAP %s",time);image.put(25,0,value,15);
    snprintf(value,sizeof(value),"SCORE %07lu",(unsigned long)rules.score);image.put(0,1,value);
    snprintf(value,sizeof(value),"SPEED %03ld",(long)motion.speed);image.put(16,1,value);
    if(rules.policy==Policy::Circuit && (rules.phase==Phase::Race || rules.phase==Phase::Finished || rules.phase==Phase::TimeUp)) {
        snprintf(value,sizeof(value),"POS %d/7",rules.rank);image.put(30,1,value,11);
    }
#ifdef RALLY_DEVELOPMENT
    snprintf(value,sizeof(value),"W%+03d G%03d%% %s DT%02lu B%02u C%u S%u",motion.steering,
             motion.grip,motion.surfaceName(),(unsigned long)interval,road.bands,scene.cars,steeringStep);
    image.put(0,2,value,14);
#else
    (void)interval;
#endif
    hud.emit(stream,sceneryHistory.slot,image);flush();
}
void drawPanel() {
    if(!panelVisible())return;
    char signature[160];
    const unsigned count=(3*Hz-rules.phaseTicks+Hz-1)/Hz;
    snprintf(signature,sizeof(signature),"%d/%s/%d/%u/%d",int(rules.phase),selected==&rally::Fuji?"FUJI":"OVAL",
             int(rules.policy),(rules.phase==Phase::QualifyReady || rules.phase==Phase::RaceReady)?count:0,rules.grid);
    if(strcmp(panelCache[sceneryHistory.slot],signature)==0)return;
    strcpy(panelCache[sceneryHistory.slot],signature);
    stream.rect(0,HudHeight,319,87,SkyColour);flush();
    switch(rules.phase) {
    case Phase::Attract:
        font(LargeFont);text(5,2,"AGON RALLY",11);font(Font);
        centre(7,"QUALIFY. RACE. BEAT THE CLOCK.");centre(9,"PRESS ANY KEY TO RACE",11);break;
    case Phase::Select:
        centre(4,"CHOOSE YOUR RACE",11);
        centre(6,selected==&rally::Fuji?"<  FUJI SPEEDWAY  >":"<    TRI-OVAL    >");
        centre(8,rules.policy==Policy::Circuit?"CIRCUIT RACE  -  UP/DOWN":"ARCADE TRAFFIC  -  UP/DOWN");
        centre(10,"SPACE / ENTER TO START",11);break;
    case Phase::QualifyReady:case Phase::RaceReady:
        centre(4,rules.phase==Phase::QualifyReady?"PREPARE TO QUALIFY":"PREPARE TO RACE",11);
        snprintf(signature,sizeof(signature),"%u",count);font(LargeFont);text(9,3,signature);font(Font);
        centre(10,"UP: GAS   DOWN: BRAKE   L/R: STEER");break;
    case Phase::Qualified:
        centre(4,"QUALIFIED!",11);snprintf(signature,sizeof(signature),"GRID POSITION %d OF 7",rules.grid);
        centre(7,signature);centre(9,"GET READY FOR THE RACE");break;
    case Phase::Finished:case Phase::TimeUp:case Phase::NotQualified:
        centre(4,rules.phase==Phase::Finished?"GOAL!":rules.phase==Phase::TimeUp?"TIME UP":"DID NOT QUALIFY",11);
        {char time[20];clockText(time,sizeof(time),rules.bestLap);
        snprintf(signature,sizeof(signature),"BEST LAP %s",time);centre(6,signature);}
        centre(8,"SPACE / ENTER: TRY AGAIN");centre(10,"ESC: TITLE",14);break;
    default:break;
    }
}
void bottom() {
    if(rules.phase==Phase::Attract)text(2,28,"ARROWS DRIVE   -= GRIP   M MUTE",15,0);
    else if(rules.phase==Phase::Qualify)text(1,28,"QUALIFYING LAP",11,0);
    else if(rules.phase==Phase::Race) {
        char s[40];snprintf(s,sizeof(s),"%s  LAP %u/%u",rules.policy==Policy::Circuit?"RACE":"ARCADE",
            unsigned(rules.laps+1),unsigned(rules.settings.laps));text(1,28,s,15,0);
        if(rules.extensionNotice)text(23,28,"TIME EXTENDED!",11,0);
    }
}
void input() {
    bool any=false;for(auto b:heldKeys)any=any || b!=0;
    if(!any)inputArmed=true;
    if(pressed(102)) {muted=!muted;if(muted)engine.stop(send);else engine.start(send);}
    if(pressed(113)) {
        if(rules.phase==Phase::Attract && inputArmed)quit=true;
        else {rules.enter(Phase::Attract);phaseChanged();}return;
    }
    if(rules.phase==Phase::Attract && inputArmed && any)rules.enter(Phase::Select);
    else if(rules.phase==Phase::Select) {
        if(pressed(26) || pressed(122)) {
            selected=selected==&rally::Fuji?&rally::TriOval:&rally::Fuji;
            if(!loadTrack())quit=true;
            resetMotion();sceneryHistory.valid[0]=sceneryHistory.valid[1]=false;
        }
        if(pressed(58) || pressed(42))rules.policy=rules.policy==Policy::Circuit?Policy::Arcade:Policy::Circuit;
        if(inputArmed && (pressed(99) || pressed(74)))
            rules.attempt(selected->length*100,selected==&rally::Fuji?FujiRules:OvalRules,motion.grip);
    } else if(result(rules.phase) && inputArmed && (pressed(99) || pressed(74)))
        rules.attempt(selected->length*100,selected==&rally::Fuji?FujiRules:OvalRules,motion.grip);
    if(driving(rules.phase) && !crash.remaining)steerFrame(motion,key(26),key(122),steeringStep);
    motion.gripFrame(key(24),key(94));
    if(motion.grip>rules.maxGrip)rules.maxGrip=motion.grip;
    phaseChanged();
}
void tick() {
#ifdef RALLY_CAPTURE
    ++testTicks;
#endif
    uint32_t advance=0;
    if(rules.phase==Phase::Attract) {
        motion.cornerAssist=true;demoDriver.tick(motion);
        attractProgress+=motion.speed*rally::WorldSpeedMultiplier;
        raceTraffic.tick(attractProgress,rules.phaseTicks+1);
        // Attract may run overnight indefinitely. Its unused race totals
        // need no lifetime accumulation; preserve bounded on-track positions.
        const uint32_t lap=uint32_t(selected->length)*100;
        if(attractProgress>=lap) {
            attractProgress-=lap;
            for(auto &opponent:raceTraffic.cars) {
                opponent.progress=opponent.position;opponent.finish=0;
            }
        }
    } else if(driving(rules.phase)) {
        const uint32_t oldProgress=rules.progress;
        const int32_t lap=selected->length*100;
        int32_t station=motion.position+6800;if(station>=lap)station-=lap;
        int32_t before[6];uint16_t generations[6];
        for(unsigned i=0;i<6;++i) {
            before[i]=stationSeparation(raceTraffic.cars[i].position,station,lap);
            generations[i]=raceTraffic.cars[i].active?raceTraffic.cars[i].generation:0;
        }
        motion.cornerAssist=false;
#ifndef RALLY_TEST_DRIVER
        motion.demoCurveSteering=0;
#endif
        const bool recovering=crash.tick(motion,raceTraffic,rules.progress);
        if(!recovering) {
#ifdef RALLY_TEST_DRIVER
            // Headless flow fixture only: the existing assisted demo drives the
            // real rules/traffic/contact loop. Never compiled into normal play.
            motion.cornerAssist=true;
#ifdef RALLY_TEST_RACE_TIMEOUT
            if(rules.phase==Phase::Race)motion.tick(false,true);else demoDriver.tick(motion);
#else
            demoDriver.tick(motion);
#endif
#else
            motion.tick(key(58),key(42));
#endif
            advance=motion.speed*rally::WorldSpeedMultiplier;
        }
        if(rules.phase==Phase::Race) {
            const uint32_t player=oldProgress+advance;
            station+=advance;if(station>=lap)station-=lap;
            raceTraffic.tick(player,rules.elapsed+1);
#ifdef RALLY_TEST_CONTACT
            // Deliberate one-tick overlap tests the normal contact/recovery path.
            // This is not a claim that the ordinary routes produced a collision.
            if(rules.elapsed==Hz) {
                auto &opponent=raceTraffic.cars[0];opponent.active=true;
                opponent.progress=player;opponent.position=station;
                motion.lateral=opponent.lateral;
            }
#endif
            if(!recovering && !crash.invulnerable && raceTraffic.contactStation(station,motion.lateral)) {
                crash.begin(motion);
#ifdef RALLY_HOST_TELEMETRY
                ++hostContacts;
#endif
            }
            if(!recovering && !crash.remaining)for(unsigned i=0;i<6;++i) {
                const auto &car=raceTraffic.cars[i];
                if(car.active && generations[i]==car.generation && forwardPass(before[i],
                   stationSeparation(car.position,station,lap),advance))rules.addScore(100);
            }
            if(rules.policy==Policy::Circuit)rules.rank=raceTraffic.rank(player);
        }
    }
    rules.tick(advance);
    if(rules.phase==Phase::Finished && rules.policy==Policy::Circuit)
        rules.rank=raceTraffic.rank(rules.progress,rules.elapsed);
    phaseChanged();raceTraffic.view(traffic,motion.position);
}
void finishLine() {
    const int32_t distance=rally::Traffic::ahead(0,motion.position,selected->length*100)/100;
    if(distance<64 || distance>1000)return;
    const int y=rally::Horizon+int(8000/distance);
    if(y<rally::RoadTop || y>rally::Bottom)return;
    int height=(y-rally::Horizon)/16;if(height<1)height=1;
    for(int row=0;row<2;++row) {
        int yy=y+row*height;if(yy>223)break;
        const int centre=road.centerAt(yy),half=(yy-rally::Horizon)*90/50;
        for(int x=0;x<12;++x) {
            const int left=centre-half+half*2*x/12,right=centre-half+half*2*(x+1)/12-1;
            int bottom=yy+height-1;if(bottom>223)bottom=223;
            stream.rect(left,yy,right,bottom,((x+row)&1)?15:0);
        }
    }
    flush();
}
void drawPlayer() {
    if(crash.remaining) {
        const int age=150-crash.remaining,centre=scene.playerCentre,y=193;
        // Original integer radial bursts, refreshed by road spans every frame.
        const int dx[]={0,7,10,7,0,-7,-10,-7},dy[]={-10,-7,0,7,10,7,0,-7};
        int radius=8+(age<60?age/3:20-(age-60)/5);if(radius<4)radius=4;
        for(unsigned i=0;i<8;++i) {
            int x=centre+dx[i]*radius/10,yy=y+dy[i]*radius/10;
            int size=3+(int(i)+age/8)%6;
            stream.rect(x-size,yy-size,x+size,yy+size,(i+unsigned(age/6))%3==0?15:((i&1)?11:9));
        }
        stream.rect(centre-6,y-6,centre+6,y+6,15);flush();return;
    }
    if(crash.invulnerable && ((crash.invulnerable/10)&1))return;
    vdp_select_bitmap(scene.playerBitmap);vdp_adv_use_affine_matrix(1,scene.playerMirror?63984:65535);
    vdp_draw_bitmap(scene.playerX,rally::r18::PlayerDrawY);vdp_adv_use_affine_matrix(1,65535);
}
void loadCars() {
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

}

}
int gameMain(int argc,char **argv) {
    for(int i=1;i<argc;++i) {
        if(!strcmp(argv[i],"oval"))selected=&rally::TriOval;
        else if(!strcmp(argv[i],"fuji"))selected=&rally::Fuji;
        else if(!strcmp(argv[i],"mute"))muted=true;
        else if(!strcmp(argv[i],"steer1"))steeringStep=1;
        else if(!strcmp(argv[i],"steer2"))steeringStep=2;
        else if(!strcmp(argv[i],"arcade"))rules.policy=Policy::Arcade;
        else if(!strcmp(argv[i],"circuit"))rules.policy=Policy::Circuit;
        #ifdef RALLY_HOST_TELEMETRY
        else if(!strcmp(argv[i],"grip200"))motion.grip=200;
#endif
        else if(!strcmp(argv[i],"demo")){} // Compatibility alias; attract is always the default.
        else {printf("Usage: rally [oval|fuji] [circuit|arcade] [steer1|steer2] [mute]\n");return 1;}
    }
    if(!readRecords("rally.sav",records))readRecords("rally.bak",records);
    if(!loadTrack()) {printf("Road data unavailable: %s\n",road.error());return 30;}
    #ifdef RALLY_HOST_TELEMETRY
    if(telemetryCall(0)){printf("Host telemetry unavailable.\n");return 31;}
    telemetryOpen=true;
#endif
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_reset_sprites();vdp_cursor_enable(false);
    loadCars();loadFont();loadSigns();resetMotion();phaseChanged();
    if(!muted)engine.start(send);
    #ifdef RALLY_CAPTURE
    FILE *ready=fopen("ready.txt","wb");if(ready) {fputs("test fixture ready\n",ready);fclose(ready);}
#endif
    uint32_t previous=rawClock(),next=previous;
#ifdef RALLY_HOST_TELEMETRY
    telemetryRun=previous^UINT32_C(0x522D12E);
#endif
    while(!quit) {
        const uint32_t now=rawClock();if(!rally::tickDue(now,next))continue;next=now+4;
        const uint32_t elapsed=rally::ticksSince(now,previous);previous=now;
        memcpy(previousKeys,heldKeys,sizeof(heldKeys));
        for(unsigned i=0;i<16;++i)heldKeys[i]=vdp_getKeyMap(i);
        input();if(quit)break;
        if(rules.phase==Phase::Attract)demoDriver.frame(motion);
#ifdef RALLY_TEST_DRIVER
        if(driving(rules.phase))demoDriver.frame(motion);
#endif
        for(uint32_t t=0;t<elapsed;++t)tick();
        engine.update(motion.speed,send);
#ifdef RALLY_HOST_TELEMETRY
        physicsTicks+=elapsed;++telemetryFrame;
        if(telemetryOpen) {
            host::snapshot(telemetryInput+1,motion,telemetryRun,telemetryFrame,now,
                physicsTicks,elapsed,rules,crash.remaining!=0,engine.active,
                (key(26)?1:0)|(key(122)?2:0)|(key(58)?4:0)|(key(42)?8:0),
                raceTraffic,hostContacts,steeringStep);
            const unsigned status=telemetryCall(1);
            if(status && status!=31)quit=true; // Close on error; never drive without a live stream.
        }
#endif
        rally::game::prepareGameScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);
        billboards.prepare(motion,road);
        if(rules.phase!=Phase::Attract && rules.phase!=Phase::Race)scene.cars=0;
        drawScenery();road.emit(stream,false);if(stream.overflow)break;flush();finishLine();
        viewport(stream,0,panelVisible()?88:HudHeight,319,223);flush();drawTraffic();
        drawPlayer();
        viewport(stream,0,0,319,239);flush();drawPanel();drawHud(elapsed);bottom();
        vdp_swap();sceneryHistory.swapped();
        if(savePending && result(rules.phase)) {
            (void)saveRecords(records);savePending=false;
            // Save I/O happens only on a stopped result screen, outside timing.
            previous=rawClock();next=previous+4;
        }
    }
    engine.stop(send);font(65535);
#ifdef RALLY_CAPTURE
    report();
#endif
    const unsigned fonts[]={Font,LargeFont};
    for(unsigned id:fonts) {
        const uint8_t cmd[]={23,0,0x95,4,uint8_t(id),uint8_t(id>>8)};send(cmd,sizeof(cmd));vdp_adv_clear_buffer(id);
    }
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);return 0;
}
int main(int argc,char **argv) {const int status=gameMain(argc,argv);engine.stop(send);
#ifdef RALLY_HOST_TELEMETRY
if(telemetryOpen){(void)telemetryCall(2);telemetryOpen=false;}
#endif
road.~LookupRoad();return status;}
