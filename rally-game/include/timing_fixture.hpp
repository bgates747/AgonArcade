#pragma once
// R27-05 diagnostic only. No disk or host service in the measured loop.
#include <agon/mos.h>
#include <stdio.h>
#include <stdint.h>
extern "C" {
void r27_callback();
void timing_irq(),timing_start(),timing_stop(),timing_release();
uint24_t timing_ticks(),timing_claim();
volatile uint24_t ticks,elapsed;
volatile uint8_t r27_reply[10],r27_ready;
}
namespace r27 {
constexpr uint32_t Duration=3600;
enum Stage {HotLoop,Geometry,Submission,StageCount};
struct Measurement {
    uint32_t frames=0,contacts=0,checks=0,simulation=0,start=0,end=0,done=0,completed=0;
    uint32_t stage[StageCount]={0,0,0};
    uint8_t token=0;bool valid=true,installed=false,pending=false,prt=false;
    void (*oldVector)()=nullptr;
    uint32_t stageBegin[StageCount]={0,0,0};
    void mark(Stage which,bool begin) {
#ifdef RALLY_TIMING_DETAIL
        const uint32_t now=timing_ticks();
        if(begin)stageBegin[which]=now;else stage[which]+=(now-stageBegin[which])&0xffffff;
#else
        (void)which;(void)begin;
#endif
    }
    const char *failure="none";
    static uint32_t clock() {
        auto *s=(volatile SYSVAR *)mos_sysvars();
        uint32_t a,b;do{a=s->time;b=s->time;}while(a!=b);return b;
    }
    template<class Send> bool command(uint8_t op,Send send,uint32_t &value) {
        if(pending)return false;
        r27_ready=0;const uint8_t q[]={23,0,0xda,op,++token};
        const uint32_t begin=clock();pending=true;send(q,sizeof q);
        while(!r27_ready)if(clock()-begin>=600) {
            valid=false;failure="VDP callback timeout";return false;
        }
        pending=false;
        if(r27_reply[4]!=op || r27_reply[5]!=token) {
            valid=false;failure="VDP callback mismatch";return false;
        }
        value=uint32_t(r27_reply[6]) | uint32_t(r27_reply[7])<<8 |
              uint32_t(r27_reply[8])<<16 | uint32_t(r27_reply[9])<<24;
        return true;
    }
    template<class Send> bool enable(Send send) {
        mos_setkbvector(r27_callback,0);installed=true;
        uint32_t version=0;
        if(!command(1,send,version))return false;
        if(version!=0x010027){valid=false;failure="VDP capability mismatch";return false;}
        return true;
    }
    template<class Send> bool begin(Send send) {
        uint32_t ignored=0;if(!command(5,send,ignored))return false;
        #ifdef RALLY_TIMING_DETAIL
        if(!timing_claim()){valid=false;failure="PRT1 busy";return false;}
        prt=true;oldVector=reinterpret_cast<void(*)()>(mos_setintvector(0x0c,timing_irq));timing_start();
#endif
        start=clock();return true;
    }
    template<class Send> void finish(Send send) {
        end=clock();
        if(command(4,send,completed) && completed!=frames) {
            valid=false;failure="completed frame count mismatch";
        }
        done=clock();
    }
    template<class Send> void disable(Send send) {
        uint32_t ignored=0;if(installed) {
            if(!pending)command(0,send,ignored);
            if(!pending){mos_setkbvector(nullptr,0);installed=false;}
        }
        if(prt){timing_stop();mos_setintvector(0x0c,oldVector);timing_release();prt=false;}
    }
    void save() {
        // Create-new avoids overwriting previous evidence.
        uint8_t f=mos_fopen("timing.csv",0x06);
        if(!f){printf("R27 RESULT WRITE FAILED (existing file or SD error)\n");return;}
        char row[600];
        int n=snprintf(row,sizeof row,
          "schema,track,pacing,clock_hz,submitted,completed,window_ticks,drain_ticks,total_ticks,simulation_ticks,collision_checks,contacts,valid\r\n"
          "1,fuji,both-unpaced,120,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%u\r\n"
          "# failure=%s; completion=R27T-v1; duration_target_ticks=3600; stage_clock=optional-PRT1\r\n",
          (unsigned long)frames,(unsigned long)completed,(unsigned long)(end-start),
          (unsigned long)(done-end),(unsigned long)(done-start),(unsigned long)simulation,
          (unsigned long)checks,(unsigned long)contacts,unsigned(valid),failure);
        bool ok=n>0 && unsigned(n)<sizeof row && mos_fwrite(f,row,n)==unsigned(n);
        mos_fclose(f);
#ifdef RALLY_TIMING_DETAIL
        f=mos_fopen("stages.csv",0x06);
        if(f){n=snprintf(row,sizeof row,"hotloop_prt_ticks,geometry_prt_ticks,submission_prt_ticks\r\n%lu,%lu,%lu\r\n# nominal_cpu_hz=18432000; divider=16; reload=1152; interrupt_overhead_included; geometry_excludes_road_emit_vertices\r\n",
            (unsigned long)stage[HotLoop],(unsigned long)stage[Geometry],(unsigned long)stage[Submission]);
            ok=mos_fwrite(f,row,n)==unsigned(n) && ok;mos_fclose(f);}else ok=false;
#endif
        printf(ok?"R27 TIMING SAVED\n":"R27 RESULT WRITE FAILED\n");
    }
};
}
