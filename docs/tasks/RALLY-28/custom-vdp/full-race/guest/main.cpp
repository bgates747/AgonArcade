// Real per-frame AgonDev production presentation shared by every renderer case.
#include "rules.hpp"
#include "crash.hpp"
#include "records.hpp"
#include "hud.hpp"
#include "controls.hpp"
#include "engine.hpp"
#include "scenery.hpp"
#include "scene.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
#include "native.hpp"
// Route stock plotting helpers through the same counted MOS writer. The VDU
// encodings are the pinned AgonDev library's encodings, with no extra commands.
extern "C" {
void vdp_scroll_screen_extent(int extent,int direction,int speed){const uint8_t b[]={23,7,uint8_t(extent),uint8_t(direction),uint8_t(speed)};fs::send(b,sizeof b);}
void vdp_select_bitmap(int id){const uint8_t b[]={23,27,0,uint8_t(id)};fs::send(b,sizeof b);}
void vdp_draw_bitmap(int x,int y){uint8_t b[]={23,27,3,0,0,0,0};fs::put16(b+3,uint16_t(x));fs::put16(b+5,uint16_t(y));fs::send(b,sizeof b);}
void vdp_adv_use_affine_matrix(uint8_t flags,uint16_t id){const uint8_t b[]={23,0,0x96,flags,uint8_t(id),uint8_t(id>>8)};fs::send(b,sizeof b);}
void vdp_set_text_colour(int ink){const uint8_t b[]={17,uint8_t(ink)};fs::send(b,sizeof b);}
void vdp_set_text_bg_colour(int paper){const uint8_t b[]={17,uint8_t(128+paper)};fs::send(b,sizeof b);}
void vdp_cursor_tab(int x,int y){const uint8_t b[]={31,uint8_t(x),uint8_t(y)};fs::send(b,sizeof b);}
void vdp_swap(){const uint8_t b[]={23,0,0xc3};fs::send(b,sizeof b);}
}
namespace {
using namespace rally::game;
rally::Motion motion;
rally::SceneryHistory sceneryHistory;
rally::r18::SceneState scene{};
rally::Stream stream;
Rules rules;
Crash crash;
RaceTraffic coverageTraffic;
Hud hud;
Engine engine;
Records records;
const rally::TrackDef *selected=&rally::Fuji;
unsigned steeringStep=2;
uint32_t topScore=0;
constexpr unsigned Font=63940,LargeFont=63941;
uint8_t motionBytes[21600];
uint32_t times[fs::FrameCount+1],prts[fs::FrameCount+1];
uint8_t finalState[fs::StateBytes];
uint32_t audioChanges=0,finishFrames=0,inputPolls=0;
uint32_t timedSend=0,timedWait=0,timedWire=0,mainRequest=0,mainGeneration=0;
uint16_t captureStage=65535,captureFrame=0;
void send(const uint8_t *p,unsigned n){fs::send(p,n);}
void flush(){send(stream.data,stream.size);stream.size=0;stream.overflow=false;}
bool panelVisible(){return false;}
void font(unsigned id){const uint8_t cmd[]={23,0,0x95,0,uint8_t(id),uint8_t(id>>8),0};send(cmd,sizeof cmd);}
void text(int x,int y,const char *s,int ink=15,int paper=SkyColour){vdp_set_text_colour(ink);vdp_set_text_bg_colour(paper);vdp_cursor_tab(x,y);send((const uint8_t*)s,strlen(s));}
// The following maintained functions are copied verbatim at build time.
#include "presentation-functions.inc"

bool loadMotion(){FILE *f=fopen("motion.bin","rb");if(!f){fs::fail("Motion open");return false;}bool ok=fread(motionBytes,1,sizeof motionBytes,f)==sizeof motionBytes&&fgetc(f)==EOF;fclose(f);if(!ok)fs::fail("Motion input size");return ok;}
bool loadCapture(){FILE *f=fopen("capture.req","rb");if(!f)return true;uint8_t p[4];bool ok=fread(p,1,sizeof p,f)==sizeof p&&fgetc(f)==EOF;fclose(f);if(!ok){fs::fail("Capture request size");return false;}captureStage=fs::get16(p);captureFrame=fs::get16(p+2);if(captureStage>1||(captureStage==0&&(!captureFrame||captureFrame>fs::frameCount))||(captureStage==1&&captureFrame>=272)){fs::fail("Capture request bounds");return false;}return true;}
void capture(unsigned stage,unsigned frame){
    if(captureStage!=stage||captureFrame!=frame)return;
    FILE *f=fopen("capture.ready","wb");if(!f){fs::fail("Capture ready open");return;}
    fprintf(f,"{\"schema\":1,\"timing_excluded\":true,\"stage\":%u,\"frame\":%u,\"generation\":%lu,\"request\":%lu,\"physics_ticks\":%lu,\"post_swap_fenced\":true}\n",stage,frame,(unsigned long)fs::generation,(unsigned long)fs::request,(unsigned long)fs::world);
    if(fclose(f)){fs::fail("Capture ready write");return;}
    // Capture profiles are deliberately interrupted during this bounded hold.
    // No display or VDP traffic occurs after capture.ready is written.
    uint32_t begin=fs::now();while(fs::now()-begin<24000){}
    captureStage=65535;
}
void prepareRace(){rules.settings=FujiRules;rules.policy=Policy::Circuit;rules.lapLength=selected->length*100;rules.maxGrip=200;rules.raceReady();rules.enter(Phase::Race);motion.track=selected;motion.grip=200;motion.position=3246800;motion.phase=6800;motion.lateral=0;motion.steering=0;motion.cornerAssist=false;}
void updateRank(unsigned frame){unsigned ahead=0;for(unsigned i=0;i<6;++i){int32_t gap=int32_t(fs::get32(motionBytes+frame*24+i*4))-motion.position;const int32_t lap=selected->length*100;if(gap>lap/2)gap-=lap;else if(gap<-lap/2)gap+=lap;if(gap>0)++ahead;}rules.rank=uint8_t(1+ahead);}
void scriptedTraffic(unsigned frame){fs::update(fs::PositionBuffer,0,motionBytes+frame*24,24);const int32_t lanes[6]={-9216,0,9216,-9216,0,9216};uint8_t p[24];for(unsigned i=0;i<6;++i)fs::put32(p+4*i,uint32_t(lanes[i]));fs::update(fs::LateralBuffer,0,p,sizeof p);}
void prepareSky(){
    int32_t p=motion.position/100*256+(motion.position%100)*256/100;
    auto heading=rally::trackSample(p,*motion.track);
    const int offset=rally::sceneryHeading(heading.tx,heading.ty);
    auto u=sceneryHistory.prepare(offset);
    scene.skyOffset=offset;scene.skyDelta=u.delta;scene.skyLeft=u.left;scene.skyRight=u.right;scene.skyRepaint=u.repaint;
    drawScenery();
}
void paint(){
    prepareSky();
    fs::render();if(!fs::healthy)return;
    viewport(stream,0,rally::RoadTop,319,239);flush();fs::command(fs::Outputs[0],1);
    viewport(stream,0,HudHeight,319,223);flush();
    fs::command(fs::Outputs[1],1);fs::command(fs::Outputs[2],1);
    viewport(stream,0,0,319,239);flush();
    uint32_t before=fs::wireBytes;drawHud(4);fs::hudBytes+=fs::wireBytes-before;bottom();++fs::footerCalls;
    // The native road output refreshes the black footer before bottom() writes
    // it, including erasure of an expired TIME EXTENDED notice.
    vdp_swap();sceneryHistory.swapped();fs::fence();
    const int32_t distance=(selected->length*100-motion.position)%(selected->length*100)/100;
    if(distance>=64&&distance<=1000)++finishFrames;
}
void warmLower(){viewport(stream,0,0,319,239);stream.rect(0,224,319,239,0);flush();}
void restoreText(){font(65535);const uint8_t p[]={22,8,23,0,192,0,23,1,1,26,12};send(p,sizeof p);}
void releaseGraphics(){for(unsigned id=64000;id<64035;++id)fs::command(id,2);for(unsigned id=64120;id<64128;++id)fs::command(id,2);const uint16_t ids[]={64100,Font,LargeFont,63984,63960,63800,50300,50301,50302,50303,50304,50305,50700};for(auto id:ids)fs::command(id,2);for(unsigned id=50710;id<50718;++id)fs::command(id,2);for(unsigned id=1;id<=26;++id)fs::command(id,2);}
void clearOutputs(){const char *names[]={"result.json","failure.txt","state.bin","ticks.bin","prt.bin","replies.bin","stages.csv","player.csv","coverage.json","capture.ready"};for(auto name:names)mos_del(name);}
bool saveResults(uint32_t cpu,uint32_t presentationCpu,uint32_t elapsedMos,uint32_t elapsedPrt,uint16_t stackBefore,uint16_t stackAfter){
    if(!fs::save("state.bin",finalState,sizeof finalState)||!fs::save("ticks.bin",times,(fs::frameCount+1)*sizeof(uint32_t))||!fs::save("prt.bin",prts,(fs::frameCount+1)*sizeof(uint32_t))||!fs::save("replies.bin",fs::transcript,fs::transcriptBytes))return false;
    FILE *f=fopen("stages.csv","wb");if(!f)return false;fprintf(f,"player_rules_and_tick_submission_prt_ms,presentation_cpu_estimate_prt_ms,submission_prt_ms,reply_wait_prt_ms,loop_prt_ms,wire_bytes\r\n%lu,%lu,%lu,%lu,%lu,%lu\r\n",(unsigned long)cpu,(unsigned long)presentationCpu,(unsigned long)timedSend,(unsigned long)timedWait,(unsigned long)elapsedPrt,(unsigned long)timedWire);if(fclose(f))return false;
    f=fopen("player.csv","wb");if(!f)return false;fprintf(f,"station,phase,speed,lateral,steering,rules_ticks,score,remaining,rank,laps\r\n%ld,%ld,%ld,%ld,%d,%lu,%lu,%lu,%u,%u\r\n",(long)motion.position,(long)motion.phase,(long)motion.speed,(long)motion.lateral,motion.steering,(unsigned long)rules.phaseTicks,(unsigned long)rules.score,(unsigned long)rules.remaining,unsigned(rules.rank),unsigned(rules.laps));if(fclose(f))return false;
    f=fopen("result.json","wb");if(!f)return false;fprintf(f,"{\"schema\":1,\"valid\":true,\"frames\":%u,\"warm_frames\":2,\"physics_ticks\":%u,\"mos_tick_hz\":120,\"elapsed_mos_ticks\":%lu,\"prt_ticks\":%lu,\"stack_before\":%u,\"stack_after\":%u,\"scroll_calls\":%lu,\"repaint_calls\":%lu,\"sky_repair_calls\":%lu,\"hud_bytes\":%lu,\"footer_calls\":%lu,\"audio_changes\":%lu,\"finish_frames\":%lu,\"input_polls\":%lu,\"request\":%lu,\"generation\":%lu,\"timed_wire_bytes\":%lu,\"retained_replies\":%u,\"transcript_bytes\":%u,\"timer_restored\":%s,\"unloaded\":%s,\"race_view\":true,\"damage_enabled\":false,\"post_swap_fenced\":true,\"clean_text_exit\":true}\n",fs::frameCount,fs::frameCount*4,(unsigned long)elapsedMos,(unsigned long)elapsedPrt,unsigned(stackBefore),unsigned(stackAfter),(unsigned long)fs::scrollCalls,(unsigned long)fs::repaintCalls,(unsigned long)fs::skyRepairCalls,(unsigned long)fs::hudBytes,(unsigned long)fs::footerCalls,(unsigned long)audioChanges,(unsigned long)finishFrames,(unsigned long)inputPolls,(unsigned long)mainRequest,(unsigned long)mainGeneration,(unsigned long)timedWire,fs::transcriptBytes/10,fs::transcriptBytes,fs::timerRestored?"true":"false",fs::unloaded?"true":"false");return fclose(f)==0;
}
// A separate coverage entry executes maintained crash/recovery drawing with a
// frozen camera. It is never included in the 900-frame throughput measurement.
void coverage(){
    FILE *f=fopen("coverage.req","rb");if(!f)return;fclose(f);
    const auto savedMotion=motion;const auto savedCrash=crash;const auto savedRules=rules;
    const uint32_t savedScroll=fs::scrollCalls,savedRepaint=fs::repaintCalls,savedRepair=fs::skyRepairCalls;
    coverageTraffic.reset(Policy::Circuit,selected->length*100,7,2);for(auto &c:coverageTraffic.cars)c.active=false;
    // Anchor the maintained effect to the actual native player's last pose.
    scene.playerBitmap=fs::read16(fs::Outputs[2],2)>>8;
    scene.playerMirror=fs::read16(fs::Outputs[2],8)==63984;
    scene.playerX=int16_t(fs::read16(fs::Outputs[2],13));
    scene.playerCentre=scene.playerX+(scene.playerMirror?50:51);
    crash.begin(motion);unsigned bursts=0,blink=0,recovered=0;
    for(unsigned n=0;n<272&&fs::healthy;++n){
        prepareSky();fs::render();viewport(stream,0,rally::RoadTop,319,239);flush();fs::command(fs::Outputs[0],1);
        viewport(stream,0,HudHeight,319,223);flush();fs::command(fs::Outputs[1],1);
        if(crash.remaining)++bursts;else if(crash.invulnerable&&((crash.invulnerable/10)&1))++blink;
        engine.update(motion.speed,send);drawPlayer();viewport(stream,0,0,319,239);flush();drawHud(0);bottom();vdp_swap();sceneryHistory.swapped();fs::fence();capture(1,n);
        if(crash.tick(motion,coverageTraffic,0)&&!crash.remaining)++recovered;
    }
    motion=savedMotion;crash=savedCrash;rules=savedRules;
    fs::scrollCalls=savedScroll;fs::repaintCalls=savedRepaint;fs::skyRepairCalls=savedRepair;
    f=fopen("coverage.json","wb");if(f){fprintf(f,"{\"schema\":1,\"separate_from_throughput\":true,\"frames\":272,\"explosion_frames\":%u,\"blink_hidden_frames\":%u,\"recovery_transitions\":%u,\"camera_frozen\":true,\"native_physics_ticks\":0,\"healthy\":%s}\n",bursts,blink,recovered,fs::healthy?"true":"false");fclose(f);}
}
}
int main(){
    clearOutputs();prepareRace();
    if(!fs::setup()||!loadMotion()||!loadCapture())goto failed;
    if(fs::read32(fs::Root,fs::PlayerStation)!=3246800||fs::read16(fs::Root,fs::RenderPhase)!=6800){fs::fail("Initial native pose");goto failed;}
    font(Font);engine.start(send);
    // Both retained pages begin with real scene/HUD/footer pixels. Warm renders
    // advance publication generation/request, and no native physics ticks.
    warmLower();paint();warmLower();paint();if(!fs::healthy)goto failed;
    fs::startTimer();if(!fs::healthy)goto failed;
    {
        uint8_t q[2]={17,0};uint16_t stackBefore=fs::transaction(4,q,2,4);
        rally::game::RouteCursor pace;uint32_t cpu=0,presentationCpu=0;
        fs::sendMs=fs::waitMs=fs::wireBytes=0;fs::scrollCalls=fs::repaintCalls=fs::skyRepairCalls=fs::hudBytes=fs::footerCalls=0;finishFrames=0;
        times[0]=fs::now();prts[0]=fs::timer();
        for(unsigned frame=0;frame<fs::frameCount&&fs::healthy;++frame){
            for(unsigned i=0;i<16;++i)(void)vdp_getKeyMap(i);++inputPolls;
            uint32_t begin=fs::timer();
            for(unsigned step=0;step<4;++step){unsigned advance=pace.tick();motion.speed=advance/2;motion.position=(motion.position+advance)%(selected->length*100);motion.phase=(motion.phase+advance)%8000;rules.tick(advance);fs::tick();}
            cpu+=fs::difference(fs::timer(),begin);scriptedTraffic(frame);updateRank(frame);
            unsigned pitch=engine.frequency;engine.update(motion.speed,send);if(engine.frequency!=pitch)++audioChanges;
            begin=fs::timer();uint32_t io=fs::sendMs+fs::waitMs;paint();uint32_t cost=fs::difference(fs::timer(),begin),used=fs::sendMs+fs::waitMs-io;if(cost>=used)presentationCpu+=cost-used;
            if(!fs::healthy)break;times[frame+1]=fs::now();prts[frame+1]=fs::timer();capture(0,frame+1);
        }
        if(!fs::healthy)goto failed;
        const uint32_t elapsedMos=times[fs::frameCount]-times[0],elapsedPrt=fs::difference(prts[fs::frameCount],prts[0]);
        timedSend=fs::sendMs;timedWait=fs::waitMs;timedWire=fs::wireBytes;mainRequest=fs::request;mainGeneration=fs::generation;
        uint16_t stackAfter=fs::transaction(4,q,2,4);unsigned at=0;
        for(const auto &b:fs::Buffers)for(unsigned offset=0;offset<b.bytes;offset+=2){fs::put16(finalState+at,fs::read16(b.id,b.offset+offset));at+=2;}
        if(!fs::healthy)goto failed;
        // Finish and serialize the main comparison before optional coverage.
        // Stop/unload/timer teardown is qualified before success is published.
        coverage();if(!fs::healthy)goto failed;
        engine.stop(send);fs::stop();if(!fs::healthy)goto failed;
        releaseGraphics();restoreText();
        if(!saveResults(cpu,presentationCpu,elapsedMos,elapsedPrt,stackBefore,stackAfter)){fs::fail("Result file write");goto failed;}
        printf("RALLY-28 FULL RACE DONE: logs saved.\n");return 0;
    }
failed:
    engine.stop(send);fs::stop();if(!fs::pending){releaseGraphics();restoreText();}
    {FILE *f=fopen("failure.txt","wb");if(f){fprintf(f,"%s\n",fs::failure);fclose(f);}}
    printf("RALLY-28 FULL RACE FAILED: %s\n",fs::failure);
    if(fs::pending)for(;;){} // Keep callback storage resident until reset.
    return 1;
}
