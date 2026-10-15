#include <new>
#define main unused_product_main
#include "product_main.cpp"
#undef main
#include "scene_workload.hpp"
extern "C" {
void timing_irq(),timing_start(),timing_stop(),timing_release(),frame_callback();
uint24_t timing_ticks(),timing_claim();
volatile uint24_t ticks=0,elapsed=0,completion_prt=0;
volatile uint32_t completion_mos=0;
volatile uint8_t completion_ready=0,completion_count=0;
volatile uint8_t *completion_sysvars;
void shadow_init(),shadow_step(),shadow_snapshot(uint32_t *);
extern uint32_t wire_bytes,wire_calls,send_ticks,uart_chunks;
extern void (*wire_service)();
extern uint8_t transmit;
}
namespace {
constexpr unsigned Frames=900;
struct Frame {uint32_t begin,end,advance,wait,geometry,construct,send,shadow,debt,submitted,returned,callback;};
Frame observations[Frames];unsigned completed=0;uint32_t shadow_calls=0,max_debt=0,last_physics=0;
const char *failure="none";bool callback_restored=false,timer_restored=false;
uint8_t live=0;
void servicePhysics() {
    if(live!=2)return;
    const uint32_t now=rawClock(),due=now-last_physics;if(due>max_debt)max_debt=due;
    // Bounded diagnostic catch-up. Retain the debt; do not hide missed steps.
    unsigned work=due>4?4:unsigned(due);
    while(work--){shadow_step();++shadow_calls;++last_physics;}
}
bool waitCompletion(uint32_t begin) {
    while(!completion_ready) {servicePhysics();if(rawClock()-begin>=1200){failure="callback timeout";return false;}}
    return true;
}
void prepareScene() {
#if CANDIDATE==0
    rally::game::prepareGameScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);
#else
    rally::r28::prepareScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);
#endif
    billboards.prepare(motion,road);
}
bool writeText(uint8_t f,const char *text){const unsigned n=strlen(text);return mos_fwrite(f,const_cast<char*>(text),n)==n;}
}
int main() {
    uint8_t f=mos_fopen("mode.txt",1);char mode[4]={};if(!f)return 1;
    mos_fread(f,mode,3);mos_fclose(f);live=uint8_t(mode[0]-'0');if(live>2)return 2;
    transmit=live!=0;
#if CANDIDATE>0
    new(roadStorage) rally::r28::SharedRoad();road.coarse=CANDIDATE==2;
    road.track=&rally::Fuji;if(!road.load("fuji.road"))return 3;
#endif
    vdp_mode(136);vdp_set_pixel_coordinates();vdp_reset_sprites();vdp_cursor_enable(false);
    capacity::setupScene();
#if BUFFERED
    rally::r28::templates(send);
#endif
    if(!timing_claim())return 4;
    auto oldTimer=reinterpret_cast<void(*)()>(mos_setintvector(0x0c,timing_irq));
    completion_sysvars=mos_sysvars();
    auto previous=*reinterpret_cast<void(**)()>(const_cast<uint8_t*>(completion_sysvars)+0x6c);
    if(live)mos_setkbvector(frame_callback,0);
    // Drain setup outside measurement; GP token is independent of frame markers.
    if(live) {
        const uint8_t fence[]={23,0,202,23,0,128,93};send(fence,sizeof fence);const uint32_t begin=rawClock();
        while(completion_sysvars[sysvar_gp]!=93)if(rawClock()-begin>3600){mos_setkbvector(previous,0);mos_setintvector(0x0c,oldTimer);timing_release();return 5;}
    }
    shadow_init();
    wire_service=live==2?servicePhysics:nullptr;wire_bytes=wire_calls=send_ticks=uart_chunks=0;timing_start();const uint32_t begin=rawClock();last_physics=begin;
    for(unsigned i=0;i<Frames;++i) {
        Frame &o=observations[i];o.begin=rawClock();const uint32_t t0=timing_ticks();
        capacity::advanceScene();const uint32_t t1=timing_ticks();prepareScene();const uint32_t t2=timing_ticks();
        o.geometry=(t2-t1)&0xffffff;
        const uint32_t sent=send_ticks;completion_ready=0;completion_count=0;
        const uint32_t before=shadow_calls;o.submitted=rawClock();capacity::drawScene([](const char*){});
        const uint8_t complete[]={23,0,202,23,0,153,0};if(live)send(complete,sizeof complete);
        const uint32_t t3=timing_ticks();o.returned=rawClock();
        o.construct=(t3-t2)&0xffffff;o.send=(send_ticks-sent)&0xffffff;
        if(live && !waitCompletion(o.submitted))break;
        o.wait=(timing_ticks()-t3)&0xffffff;o.shadow=shadow_calls-before;o.debt=max_debt;
        if(live && completion_count!=1){failure="ambiguous completion";break;}
        o.end=rawClock();o.callback=live?completion_mos:0;o.advance=(t1-t0)&0xffffff; // advance ticks, retained schema label below
        #if CANDIDATE==0
        sceneryHistory.swapped();++completed;servicePhysics();
#else
        sceneryHistory.swapped();++completed;
        // Physics has priority before the next diagnostic render. Retain all
        // debt and service bounded chunks until caught up; no per-frame cap.
        do {servicePhysics();} while(live==2 && rawClock()!=last_physics);
#endif
    }
    const uint32_t end=rawClock();wire_service=nullptr;timing_stop();const uint32_t total=elapsed;
    auto installed=reinterpret_cast<void(*)()>(mos_setintvector(0x0c,oldTimer));timer_restored=installed==timing_irq;timing_release();
    if(live){mos_setkbvector(previous,0);callback_restored=*reinterpret_cast<void(**)()>(const_cast<uint8_t*>(completion_sysvars)+0x6c)==previous;}else callback_restored=true;
    const uint32_t recurring=wire_bytes,callCount=wire_calls,sendTotal=send_ticks,chunkCount=uart_chunks;
    // Freeze the picture for capture/review. This mute command is outside timing.
    engine.stop(send);
    char text[800];snprintf(text,sizeof text,
        "schema=1\r\ncandidate=%u\r\nbuffered=%u\r\nmode=%u\r\nframes=%u\r\nplanned=900\r\nmos_units=%lu\r\nprt_ticks=%lu\r\nbytes=%lu\r\nwire_calls=%lu\r\nuart_chunks=%lu\r\nsend_prt=%lu\r\nposition=%ld\r\nphase=%ld\r\nshadow_calls=%lu\r\nshadow_debt=%lu\r\nmax_shadow_debt=%lu\r\nvector_restored=%u\r\ncallback_restored=%u\r\nfailure=%s\r\n",
        unsigned(CANDIDATE),unsigned(BUFFERED),unsigned(live),completed,(unsigned long)(end-begin),(unsigned long)total,
        (unsigned long)recurring,(unsigned long)callCount,(unsigned long)chunkCount,(unsigned long)sendTotal,(long)motion.position,(long)motion.phase,
        (unsigned long)shadow_calls,(unsigned long)(end-last_physics),(unsigned long)max_debt,unsigned(timer_restored),unsigned(callback_restored),failure);
    f=mos_fopen("summary.txt",6);if(!f)return 6;bool ok=writeText(f,text);mos_fclose(f);
    f=mos_fopen("frames.csv",6);if(!f)return 7;
    ok=writeText(f,"frame,mos_begin,mos_end,advance_prt,geometry_prt,construct_prt,send_prt,wait_prt,physics_while_pending,max_physics_debt,submit_mos,return_mos,callback_mos\r\n")&&ok;
    for(unsigned i=0;i<completed;++i) {const auto &o=observations[i];snprintf(text,sizeof text,"%u,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu\r\n",i,
        (unsigned long)o.begin,(unsigned long)o.end,(unsigned long)o.advance,(unsigned long)o.geometry,(unsigned long)o.construct,
        (unsigned long)o.send,(unsigned long)o.wait,(unsigned long)o.shadow,(unsigned long)o.debt,(unsigned long)o.submitted,(unsigned long)o.returned,(unsigned long)o.callback);ok=writeText(f,text)&&ok;}
    mos_fclose(f);
    if(shadow_calls) {
        uint32_t values[105];shadow_snapshot(values);f=mos_fopen("state.csv",6);if(!f)return 8;
        for(unsigned i=0;i<105;++i){snprintf(text,sizeof text,"%u,%lu\r\n",i,(unsigned long)values[i]);ok=writeText(f,text)&&ok;}mos_fclose(f);
    }
    f=mos_fopen("done.txt",6);if(!f)return 9;ok=writeText(f,"complete\n")&&ok;mos_fclose(f);
#if CANDIDATE>0
    road.~SharedRoad();
#endif
    return ok && completed==900 && !strcmp(failure,"none")?0:10;
}
