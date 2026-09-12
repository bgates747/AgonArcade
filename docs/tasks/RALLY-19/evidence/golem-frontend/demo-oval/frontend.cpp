// R19-09 frontend based on accepted949f618; original source remains read-only.
#include "road.hpp"
#include "car.hpp"
#include "traffic.hpp"
#include "scenery.hpp"
#include "demo.hpp"
#include "pacing.hpp"
#include "workload.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ez80f92.h>
#include "section_road.hpp"
#include "scene.hpp"
#include "task_workload.hpp"
#include "lookup_road.hpp"
#include "golem_renderer.hpp"
extern "C" __attribute__((noinline)) void r18Begin(){asm volatile("nop");}
extern "C" __attribute__((noinline)) void r18End(){asm volatile("nop\nnop");}
namespace {
uint32_t roadLoadTicks=0;
bool autosteer=false;
bool oracleRenderer=false,stateInvalid=false;
rally::r19::GolemRenderer golemRenderer;
bool perspective=false,measure=false,computeOnly=false,displayTiming=false,snapshot=false;
unsigned snapshotPose=0;int snapshotLateral=0,snapshotSteering=0;
volatile rally::r18::SceneState scene{};

rally::Motion motion;
rally::LookupRoad road __attribute__((no_destroy));
rally::Traffic traffic;
rally::DemoDriver demoDriver;
bool demoMode=true;
bool demoInputArmed=false;
bool escapeArmed=true;
bool fenced=false,profiling=false,benchmark=false;
bool workload=false,noSky=false,noTraffic=false,mirrorPlayer=false,lightTiming=false;
unsigned workloadStep=0;
uint32_t poseHash=0,roadBytesTotal=0;
rally::PollFence pollFence;
rally::FrameTiming timings[rally::TimingCapacity];
unsigned timingCount=0;
uint32_t submitted=0,acknowledged=0,unrecorded=0;
uint32_t benchmarkStart=0,runTicks=0,startupTicks=0,drainTicks=0;
bool fenceFailed=false;
// MOS updates a 32-bit counter, while eZ80 loads are at most 24 bits.
// Two matching volatile reads reject a rollover between the component loads.
uint32_t rawClock() {
    uint32_t first,second;
    do {first=sys_vars->time;second=sys_vars->time;} while(first!=second);
    return second;
}
struct PollBackend {
    uint32_t ticks() {return rawClock();}
    uint8_t poll() {return reinterpret_cast<volatile uint8_t *>(sys_vars)[0x37];}
    void send(uint8_t token) {
        const uint8_t command[]={23,0,0x80,token};
        mos_puts((char *)command,sizeof(command),0);
    }
} pollBackend;
bool waitForVDP() {return pollFence.wait(pollBackend,rally::FenceTimeout);}
void saveTimings() {
    const char *name=fenced?"timing-fence.csv":"timing-free.csv";
    FILE *file=fopen(name,"w");
    if(!file) {printf("Could not write %s\n",name);return;}
    fprintf(file,"# clock_hz=120,fenced=%u,submitted=%lu,acknowledged=%lu,unrecorded=%lu,timeout=%u,run_ticks=%lu,startup_ticks=%lu,drain_ticks=%lu,workload=%u,no_sky=%u,no_traffic=%u,mirror=%u,light=%u,recorded=%u,pose_hash=%lu,road_bytes=%lu,fixed_bands=%u\n",
            unsigned(fenced),(unsigned long)submitted,(unsigned long)acknowledged,
            (unsigned long)unrecorded,unsigned(fenceFailed),(unsigned long)runTicks,
            (unsigned long)startupTicks,(unsigned long)drainTicks,unsigned(workload),
            unsigned(noSky),unsigned(noTraffic),unsigned(mirrorPlayer),unsigned(lightTiming),
            timingCount,(unsigned long)poseHash,(unsigned long)roadBytesTotal,unsigned(road.fixedBands));
    fprintf(file,"start,interval,physics,projection,submit,fence,road_bytes,cars,mirrored,geometry,bands,pose,band_count\n");
    for(unsigned i=0;i<timingCount;++i) {
        const auto &t=timings[i];
        fprintf(file,"%lu,%lu,%lu,%lu,%lu,%lu,%u,%u,%u,%lu,%lu,%u,%u\n",
                (unsigned long)t.start,(unsigned long)t.interval,(unsigned long)t.physics,
                (unsigned long)t.projection,(unsigned long)t.submit,(unsigned long)t.fence,
                unsigned(t.roadBytes),unsigned(t.cars),unsigned(t.mirrored),
                (unsigned long)t.geometry,(unsigned long)t.bands,unsigned(t.pose),unsigned(t.bandCount));
    }
    fprintf(file,"# complete\n");
    if(fclose(file)!=0) printf("Error closing %s\n",name);
    else printf("Timing saved: %s (%u rows)\n",name,timingCount);
}
rally::SceneryHistory sceneryHistory;
rally::Stream stream;
constexpr unsigned CarWidth=102, CarHeight=77;
uint8_t carUpload[CarWidth*CarHeight];
uint8_t heldKeys[16];
bool key(int code) { return heldKeys[(code-1)/8] & (1<<((code-1)%8)); }
// One reusable matrix per opponent; coefficients are signed Q8 on the wire.
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
// RALLY-18 isolated diagnostics. No changes to accepted game sources.
void marker(const char *name){FILE*f=fopen(name,"w");if(!f)exit(20);fclose(f);}
void awaitMarker(const char *name){for(;;){FILE*f=fopen(name,"r");if(f){fclose(f);return;}}}
void prepareScene(){rally::r18::prepareScene(motion,traffic,road,sceneryHistory,scene,perspective);}
void drawPlayer(){
    vdp_select_bitmap(scene.playerBitmap);
    vdp_adv_use_affine_matrix(1,scene.playerMirror?63984:65535);
    vdp_draw_bitmap(scene.playerX,rally::r18::PlayerDrawY);
    vdp_adv_use_affine_matrix(1,65535);
}
void drawScene(){
    road.emit(stream,false);drawScenery();mos_puts((char*)stream.data,stream.size,0);
    drawTraffic();drawPlayer();text(9,28,"TIMING FIXTURE");vdp_swap();
}
void saveScene(){
    FILE*f=fopen("scene.csv","w");if(!f)exit(21);
    fprintf(f,"%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",(long)scene.skyOffset,(long)scene.skyDelta,(long)scene.skyLeft,(long)scene.skyRight,(long)scene.skyRepaint,(long)scene.playerBitmap,(long)scene.playerMirror,(long)scene.playerX,(long)scene.cars);
    for(unsigned i=0;i<road.boundaryCount;++i)fprintf(f,"R,%u,%ld,%u\n",unsigned(road.rows[i]),(long)road.centersQ8[i],unsigned(i<road.bands?road.materials[i]:0));
    for(unsigned i=0;i<scene.cars;++i){volatile const auto &c=scene.traffic[i];fprintf(f,"C,%d,%d,%d,%d,%d,%d\n",c.bitmap,c.scale,c.mirrored,c.x,c.y,c.translation);}
    fclose(f);
}
int taskDiagnostic(){
    vdp_swap();sceneryHistory.swapped();if(!waitForVDP())return 22;
    if(snapshot){
        rally::r18::pose(snapshotPose,motion,traffic);
        motion.lateral=snapshotLateral*256L;motion.steering=snapshotSteering;
        for(unsigned i=0;i<2;++i){prepareScene();drawScene();sceneryHistory.swapped();if(!waitForVDP())return 23;}
        saveScene();marker("ready.viz");
        for(;;){if(vdp_getKeyMap(14)&1)break;}
        vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);marker("exit.viz");return 0;
    }
    for(unsigned i=0;i<rally::WorkloadWarmup;++i){
        rally::r18::pose(0,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        prepareScene();drawScene();sceneryHistory.swapped();
    }
    if(!waitForVDP())return 24;
    uint32_t frames=0,cars=0,roadBytes=0,bands=0,hash=0;
    marker("start.snk");awaitMarker("go.snk");
    const uint32_t start=rawClock();r18Begin();
    for(unsigned pose=0;pose<rally::WorkloadFrames;++pose){
        rally::r18::pose(pose,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        prepareScene();
        if(!computeOnly){drawScene();if(stream.overflow)return 25;roadBytes+=stream.size;}
        sceneryHistory.swapped();++frames;cars+=scene.cars;bands+=road.bands;
        hash=rally::workloadHash(hash,motion,traffic);
    }
    while(!(IO(UART0_LSR)&UART0_LSR_TEMT)){}
    r18End();const uint32_t submitted=rawClock();
    bool completed=true;uint32_t finished=submitted;
    if(displayTiming){completed=waitForVDP();finished=rawClock();}
    marker("done.snk");awaitMarker("stop.snk");
    if(!displayTiming)completed=waitForVDP();
    saveScene();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    FILE*f=fopen("measurement.csv","w");if(!f)return 26;
    fprintf(f,"frames,submit_ticks,complete_ticks,completed,road_bytes,cars,pose_hash,bands,load_ticks\n");
    fprintf(f,"%lu,%lu,%lu,%u,%lu,%lu,%lu,%lu,%lu\n",(unsigned long)frames,(unsigned long)rally::ticksSince(submitted,start),(unsigned long)rally::ticksSince(finished,start),unsigned(completed),(unsigned long)roadBytes,(unsigned long)cars,(unsigned long)hash,(unsigned long)bands,(unsigned long)roadLoadTicks);
    fprintf(f,"# complete\n");fclose(f);return completed?0:27;
}

}
int gameMain(int argc, char **argv) {
    const rally::TrackDef *track=&rally::TriOval;
    long start=0;
    for(int i=1;i<argc;++i) {
        if(strcmp(argv[i],"oracle")==0)oracleRenderer=true;
        else if(strcmp(argv[i],"golem")==0)oracleRenderer=false;
        else if(strcmp(argv[i],"autosteer")==0)autosteer=true;
        else if(strcmp(argv[i],"perspective")==0)perspective=true;
        else if(strcmp(argv[i],"measure")==0)measure=true;
        else if(strcmp(argv[i],"compute")==0)computeOnly=true;
        else if(strcmp(argv[i],"display")==0)displayTiming=true;
        else if(strcmp(argv[i],"snapshot")==0)snapshot=true;
        else if(strncmp(argv[i],"pose=",5)==0)snapshotPose=atoi(argv[i]+5);
        else if(strncmp(argv[i],"lateral=",8)==0)snapshotLateral=atoi(argv[i]+8);
        else if(strncmp(argv[i],"steering=",9)==0)snapshotSteering=atoi(argv[i]+9);
        else if(strcmp(argv[i],"fuji")==0) track=&rally::Fuji;
        else if(strcmp(argv[i],"oval")==0) track=&rally::TriOval;
        else if(strcmp(argv[i],"demo")==0) demoMode=true;
        else if(strcmp(argv[i],"race")==0) demoMode=false;
        else if(strcmp(argv[i],"fence")==0) fenced=true;
        else if(strcmp(argv[i],"profile")==0) profiling=true;
        else if(strcmp(argv[i],"bench")==0) profiling=benchmark=true;
        else if(strcmp(argv[i],"fixture")==0) workload=profiling=true;
        else if(strcmp(argv[i],"nosky")==0) noSky=true;
        else if(strcmp(argv[i],"notraffic")==0) noTraffic=true;
        else if(strcmp(argv[i],"mirror")==0) mirrorPlayer=true;
        else if(strcmp(argv[i],"light")==0) lightTiming=true;
        else if(strcmp(argv[i],"fixedbands")==0) road.fixedBands=true;
        else {char *end;long value=strtol(argv[i],&end,10);if(*end==0 && value>=0) start=value;}
    }
    if(!oracleRenderer && (perspective || measure || computeOnly || displayTiming || snapshot ||
                           profiling || workload || fenced || noSky || noTraffic || mirrorPlayer || lightTiming || road.fixedBands)) {
        printf("These experimental rendering/measurement options require the oracle renderer.\n");return 1;
    }
    if((noSky || noTraffic || mirrorPlayer || lightTiming) && !workload) {
        printf("Workload switches require fixture.\n");return 1;
    }
    if(workload) benchmark=false;
    const bool detailTiming=profiling && !lightTiming;
    motion.track=road.track=track;
    if(oracleRenderer){
        road.init();uint32_t loadStart=rawClock();
        if(!road.load(track==&rally::Fuji?"fuji.road":"oval.road")){printf("RALLY-18 road data invalid or unavailable.\n");return 30;}
        roadLoadTicks=rally::ticksSince(rawClock(),loadStart);
    }
    if(start<track->length) {
        motion.position=start*100;motion.phase=(start%rally::Period)*100;
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
    loadScenery();
    if(oracleRenderer)mos_puts((char*)rally::section::Startup,rally::section::StartupSize,0);
    else {
        uint32_t begin=rawClock();
        if(!golemRenderer.load(track==&rally::Fuji)||!waitForVDP()){
            vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
            printf("Golem scene data could not be loaded.\n");return 31;
        }
        startupTicks=rally::ticksSince(rawClock(),begin);
    }
    vdp_set_text_colour(15);
    vdp_set_text_bg_colour(0);
    if(measure||snapshot)return taskDiagnostic();
    // Fence uploads and queued startup primitives before timed work. Both A/B
    // cases use this barrier; normal unfenced play retains its existing startup.
    if(fenced || profiling) {
        uint32_t begin=rawClock();
        vdp_swap();sceneryHistory.swapped();
        fenceFailed=!waitForVDP();
        startupTicks=rally::ticksSince(rawClock(),begin);
    }
    marker("play-ready.viz");
    uint32_t previous=rawClock(),next=previous;
    benchmarkStart=previous;
    for (;;) {
        if(fenceFailed) break;
        if(workload && workloadStep>=rally::WorkloadWarmup+rally::WorkloadFrames) break;
        bool warming=workload && workloadStep<rally::WorkloadWarmup;
        unsigned pose=workload && !warming?workloadStep-rally::WorkloadWarmup:0;
        uint32_t now=rawClock();
        if(benchmark && rally::ticksSince(now,benchmarkStart)>=rally::BenchmarkTicks) break;
        if (!rally::tickDue(now,next)) continue;
        next=now+4;
        for(unsigned i=0;i<16;++i) heldKeys[i]=vdp_getKeyMap(i);

        uint32_t elapsed=rally::ticksSince(now,previous);
        previous=now;
        if(workload) {
            if(key(113)) break;
            rally::workloadPose(pose,motion,traffic,mirrorPlayer);
        } else {
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
        }
        uint32_t physicsEnd=detailTiming?rawClock():0;
        uint32_t geometryEnd=0,projectionEnd=0;
        unsigned visible=0;
        if(oracleRenderer){
            prepareScene();
            if(detailTiming)geometryEnd=rawClock();
            road.emit(stream,false);
            if(stream.overflow)break;
            projectionEnd=detailTiming?rawClock():0;
            if(noSky){vdp_gcol(0,4);vdp_filled_rectangle(0,0,319,rally::RoadTop-1);}
            else drawScenery();
            mos_puts(reinterpret_cast<char *>(stream.data),stream.size,0);
            visible=noTraffic?0:drawTraffic();drawPlayer();
        } else {
            if(!golemRenderer.prepare(motion,traffic,demoMode,autosteer)){stateInvalid=true;break;}
            golemRenderer.submit();
        }
        char hud[41];
        if(workload) text(9,28,"TIMING FIXTURE");
        else if(demoMode) {
            text(7,28,"PRESS ANY KEY TO RACE");
        } else {
            snprintf(hud,sizeof(hud),"SPEED %03ld  UP/DN  -= GRIP  ESC QUIT",(long)motion.speed);
            text(1,28,hud);
            snprintf(hud,sizeof(hud),"%s L/R%+d GRIP%03d%% %s",
                     track==&rally::Fuji?"FUJI":"TRI-OVAL",motion.steering,motion.grip,motion.surfaceName());
            text(1,29,hud);
        }
        vdp_swap();
        if(oracleRenderer)sceneryHistory.swapped();
        ++submitted;
        uint32_t submitEnd=detailTiming?rawClock():0;
        if(fenced || warming) {
            fenceFailed=!waitForVDP();
            if(!fenceFailed) ++acknowledged;
        }
        if(detailTiming && !warming) {
            uint32_t end=rawClock();
            if(timingCount<rally::TimingCapacity) timings[timingCount++]={
                rally::ticksSince(now,benchmarkStart),elapsed,
                rally::ticksSince(physicsEnd,now),rally::ticksSince(projectionEnd,physicsEnd),
                rally::ticksSince(submitEnd,projectionEnd),rally::ticksSince(end,submitEnd),
                rally::ticksSince(geometryEnd,physicsEnd),rally::ticksSince(projectionEnd,geometryEnd),
                uint16_t(pose),uint16_t(road.bands),
                uint16_t(stream.size),uint8_t(visible),uint8_t(motion.mirrored())};
            else ++unrecorded;
        }
        if(!warming) {
            roadBytesTotal+=stream.size;
            if(workload) poseHash=rally::workloadHash(poseHash,motion,traffic);
        }
        if(workload) {
            ++workloadStep;
            if(workloadStep==rally::WorkloadWarmup) {
                submitted=acknowledged=0;
                previous=next=benchmarkStart=rawClock();
            }
        }
    }
    runTicks=rally::ticksSince(rawClock(),benchmarkStart);
    // Drain the baseline's submitted swaps before resetting the mode/writing
    // diagnostics. This final reply is not counted as per-frame acknowledgments.
    if(profiling && !fenceFailed) {
        uint32_t begin=rawClock();
        fenceFailed=!waitForVDP();
        drainTicks=rally::ticksSince(rawClock(),begin);
    }
    vdp_mode(0);
    vdp_set_logical_coordinates();
    vdp_cursor_enable(true);

    if(!oracleRenderer){
        bool cleaned=golemRenderer.unload();
        for(unsigned bitmap=0;bitmap<35;++bitmap)vdp_adv_clear_buffer(64000+bitmap);
        vdp_adv_clear_buffer(64100);vdp_adv_clear_buffer(63984);
        cleaned=waitForVDP()&&cleaned;
        FILE*report=fopen("golem-result.csv","w");
        if(report){fprintf(report,"frames,scene_bytes,startup_ticks,state_invalid,cleanup_ok,grip,phase,track\n%lu,%lu,%lu,%u,%u,%d,%ld,%u\n",
            (unsigned long)golemRenderer.frames,(unsigned long)golemRenderer.sceneBytes,(unsigned long)startupTicks,
            unsigned(stateInvalid),unsigned(cleaned),motion.grip,(long)motion.phase,unsigned(track==&rally::Fuji));fclose(report);}
    }
    FILE *play=fopen("play-result.csv","w");
    if(play){fprintf(play,"demo,steering,speed,lateral,position,frames\n%u,%d,%ld,%ld,%ld,%lu\n",unsigned(demoMode),motion.steering,(long)motion.speed,(long)motion.lateral,(long)motion.position,(unsigned long)submitted);fclose(play);}
    marker("exit.viz");
    printf("Agon Rally: %s renderer ended.\n",oracleRenderer?"oracle":"Golem");
    if(stateInvalid)printf("Scene state rejected before submission.\n");
    if(fenceFailed) printf("Stock VDP poll reply timed out; run stopped.\n");
    if(profiling) saveTimings();
    return 0;
}

int main(int argc,char **argv){int result=gameMain(argc,argv);road.~LookupRoad();return result;}
